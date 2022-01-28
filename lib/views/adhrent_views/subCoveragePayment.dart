import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/invoiceModel.dart';
import 'package:danaid/core/models/miniInvoiceModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SubCoveragePayment extends StatefulWidget {
  final InvoiceModel? invoice;
  const SubCoveragePayment({ Key? key, this.invoice }) : super(key: key);

  @override
  _SubCoveragePaymentState createState() => _SubCoveragePaymentState();
}

class _SubCoveragePaymentState extends State<SubCoveragePayment> {
  int payments = 0;

  init(){
    payments = widget.invoice!.paymentDates!.length;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }
  @override
  Widget build(BuildContext context) {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey[700],), onPressed: ()=>Navigator.pop(context)),
        title: Text("${widget.invoice!.label}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Text("Sous-factures: ", style: TextStyle(color: kTextBlue, fontSize: 18, fontWeight: FontWeight.bold)),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(widget.invoice!.id).collection('SOUS_FACTURATIONS_ADHERENT').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(kSouthSeas),
                      ),
                    );
                  }
                  if (!(snapshot.data!.docs.length >= 1)) {
                    return Center(
                      child: Container(padding: EdgeInsets.only(top: hv*4),child: Text("Aucune promotion disponible pour le moment", textAlign: TextAlign.center)),
                    );
                  }
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      MiniInvoiceModel inv = MiniInvoiceModel.fromDocument(snapshot.data!.docs[index]);
                      return HomePageComponents.getInvoiceSegmentTile(
                        label: inv.label,
                        firstDate: inv.startDate?.toDate(),
                        lastDate: inv.endDate?.toDate(),
                        date: inv.startDate?.toDate(),
                        mensuality: inv.amount,
                        type: "0",
                        subtitle: "Segment ${inv.number}",
                        state: inv.status,
                        action: (){pay(amount: inv.amount!, mini: inv);}
                      );
                    }
                  );
                }
              ),
              SizedBox(height: hv*3,),
              Text(widget.invoice?.segments != null && payments > 0 ? "$payments factures payées sur ${widget.invoice?.segments} " : "Aucune sous facture payée..", style: TextStyle(color: kTextBlue, fontSize: 16)),
              SizedBox(height: hv*3,),
            ],
          ),
        ),
      ),
    );
  }

  static const platform = const MethodChannel('danaidproject.sendmoney');

  Future<String> makePayment({required num cost, required bool isOrange}) async {
    String amount = cost.toString();
    String operator = isOrange ? 'moneyTransferOrangeAction' : 'moneyTransferMTNAction';
    String phoneNumber = isOrange ? '658112605' : '673662062';

    try {
      final String result = await platform.invokeMethod(operator, {"amount": amount, "phoneNumber": phoneNumber});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result == "SUCCESS" ? "Transaction réussie" : "Transaction échouée")));
      if(result == null){
        //setState(() { spinner2 = false;});
      }
      return result;
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Transaction échouée")));
      //setState(() { spinner2 = false;});
      return "FAILED";
    }
  }

  pay({required num amount, required MiniInvoiceModel mini}){
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext bc){
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Container(
                      height: 35,
                      width: wv*13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(image: AssetImage('assets/images/om.jpg'), fit: BoxFit.cover)
                      ),
                    ),
                    title: Text("ORANGE MONEY"),
                    onTap: (){processPayment(amount: amount, mini: mini, isOrange: true);}
                    ),
                ListTile(
                  leading: Container(
                    height: 35,
                    width: wv*13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(image: AssetImage('assets/images/momo.jpg'), fit: BoxFit.cover)
                    ),
                  ),
                  title: Text("MTN MOBILE MONEY"),
                  onTap: () {processPayment(amount: amount, mini: mini, isOrange: false);},
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  processPayment({required num amount, required MiniInvoiceModel mini, required bool isOrange}) async {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);

    String res = await makePayment(cost: amount, isOrange: isOrange);
    if(res == "SUCCESS"){
      try {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Paiement éffectué",)));
        FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(widget.invoice!.id).collection('SOUS_FACTURATIONS_ADHERENT').doc(mini.id).update({
          "paymentDate": DateTime.now(),
          "status": 1
        }).then((value) async {
          payments = payments + 1;
          setState(() {});
          await FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(widget.invoice!.id).update({
            "paymentDates": FieldValue.arrayUnion([DateTime.now()]),
            "paid": payments == widget.invoice?.segments ? true : false,
            "etatValider": payments == widget.invoice?.segments ? true : false,
            "amountPaid": FieldValue.increment(amount)
          });
          FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).update({
            "datDebutvalidite" : mini.startDate,
            "havePaidBefore": true,
            "paymentDate": DateTime.now(),
            "datFinvalidite": mini.endDate,
            "paid": true,
          });
        
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mise à jour des statuts éffectué",)));

        });
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),)));
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Une erreur de paiement est survenue..",)));
    }
  }
}