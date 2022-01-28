import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/campaignModel.dart';
import 'package:danaid/core/models/invoiceModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/adhrent_views/subCoveragePayment.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoiceSplit extends StatefulWidget {
  final InvoiceModel invoice;
  const InvoiceSplit({ Key? key, required this.invoice }) : super(key: key);

  @override
  _InvoiceSplitState createState() => _InvoiceSplitState();
}

class _InvoiceSplitState extends State<InvoiceSplit> {
  num? totalAmount;
  int? _segments;
  List campaignsChosen = [];

  bool spinner = false;

  init(){
    totalAmount = widget.invoice.inscriptionId == null ? widget.invoice.amount : widget.invoice.amount! + 10000;
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
    
    DateTime covStart = widget.invoice.coverageStartDate!.toDate();
    DateTime covEnd = widget.invoice.coverageEndDate!.toDate();
    Duration covPeriod = covEnd.difference(covStart);
    Duration segPeriod = Duration(days: _segments != null ? (covPeriod.inDays/_segments!).round() : 0);
    print(segPeriod.inDays);


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey[700],), onPressed: ()=>Navigator.pop(context)),
        title: Text("Montant total: $totalAmount FCFA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Promotions disponible", style: TextStyle(color: kTextBlue, fontSize: 16),),
              Container(
                height: 220,
                margin: EdgeInsets.symmetric(vertical: hv*1.5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('CAMPAGNES').where('active', isEqualTo: true).snapshots(),
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
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){
                        CampaignModel camp = CampaignModel.fromDocument(snapshot.data!.docs[index]);
                        return HomePageComponents.getPromotionTile(
                          title: camp.name,
                          description: camp.description,
                          firstDate: camp.startDate!.toDate(),
                          lastDate: camp.endDate!.toDate(),
                          amount: camp.amount,
                          active: camp.active,
                          chosen: campaignsChosen.contains(camp.id),
                          action: (){
                            if(campaignsChosen.contains(camp.id)){
                              campaignsChosen.remove(camp.id);
                              totalAmount = totalAmount! + camp.amount!;
                            } else {
                              campaignsChosen.add(camp.id);
                              totalAmount = totalAmount! - camp.amount!;
                            }
                            setState(() {});
                          }
                        );
                      }
                    );
                  }
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: hv*3,),
                  Text("Nombre de versements", style: TextStyle(fontSize: 16, color: kTextBlue, fontWeight: FontWeight.w400),),
                  SizedBox(height: 5,),
                  Container(
                    constraints: BoxConstraints(minWidth: wv*45),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          hint: Text(S.of(context)!.choisir),
                          value: _segments,
                          items: [
                            DropdownMenuItem(
                              child: Text("2 versements", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text("3 versements", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                              value: 3,
                            ),
                            DropdownMenuItem(
                              child: Text("4 versements", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                              value: 4,
                            ),
                            DropdownMenuItem(
                              child: Text("5 versements", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                              value: 5,
                            ),
                            DropdownMenuItem(
                              child: Text("6 versements", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                              value: 6,
                            ),
                            DropdownMenuItem(
                              child: Text("7 versements", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                              value: 7,
                            ),
                            DropdownMenuItem(
                              child: Text("8 versements", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                              value: 8,
                            ),
                            DropdownMenuItem(
                              child: Text("9 versements", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                              value: 9,
                            ),
                            DropdownMenuItem(
                              child: Text("10 versments", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                              value: 10,
                            )
                          ],
                          onChanged: (int? value) {
                            setState(() {
                              _segments = value;
                            });
                          }),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: hv*3,),
              _segments == null ? 
                Text("NB: A chaque segmentation des frais de services à hauteur de 250FCFA sont appliqués")
              :
                Column(
                  children: [
                    for (int i = 0; i < _segments!; i++)
                      HomePageComponents.getInvoiceSegmentTile(
                        label: "Segment $i",
                        firstDate: covStart.add(Duration(days: segPeriod.inDays*i)),
                        lastDate: i == (_segments! - 1) ? covEnd : covStart.add(Duration(days: segPeriod.inDays*(i+1))),
                        date: covStart.add(Duration(days: segPeriod.inDays*i)),
                        mensuality: ((totalAmount! / _segments!) + 250).round(),
                        type: "0",
                        subtitle: "Segment ${i+1}",
                        state: 0 
                      )
                  ],
                )
              ,
              SizedBox(height: hv*2,),
              CustomTextButton(
                text: "Continuer",
                color: kBrownCanyon,
                isLoading: spinner,
                enable: _segments != null,
                action: (){
                  setState(() { spinner = true;});
                  try {
                    for (int i = 0; i < _segments!; i++){
                      FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(widget.invoice.id).collection('SOUS_FACTURATIONS_ADHERENT').doc((i+1).toString()).set({
                        "label": "Segment ${i+1}",
                        "number": i+1,
                        "amount": ((totalAmount! / _segments!)+250).round(),
                        "startDate" : covStart.add(Duration(days: segPeriod.inDays*i)),
                        "endDate": i == (_segments! - 1) ? covEnd : covStart.add(Duration(days: segPeriod.inDays*(i+1))),
                        "paymentDate": null,
                        "status": 0
                      }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sous-facture numéro ${i+1} crée")));
                      });
                    }
                    FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(widget.invoice.id).update({
                      "invoiceIsSplitted": true,
                      "segments": _segments,
                      "promos": campaignsChosen,
                      "paymentDates": []
                    }).then((value) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubCoveragePayment(invoice: widget.invoice,),),);
                    });
                  }
                  catch(e){
                    setState((){spinner = false;});
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}