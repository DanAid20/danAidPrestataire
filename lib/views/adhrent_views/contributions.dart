import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/planModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/models/invoiceModel.dart';
import 'package:danaid/core/providers/invoiceModelProvider.dart';
import 'package:danaid/core/providers/planModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:danaid/widgets/drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Contributions extends StatefulWidget {
  @override
  _ContributionsState createState() => _ContributionsState();
}

class _ContributionsState extends State<Contributions> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    InvoiceModelProvider invoiceProvider = Provider.of<InvoiceModelProvider>(context);
    PlanModelProvider planProvider = Provider.of<PlanModelProvider>(context, listen: false);

    DateTime limit = adherentProvider.getAdherent.validityEndDate != null ? adherentProvider.getAdherent.validityEndDate.toDate() : null;
    String limitString = limit != null ? limit.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(limit)+" "+ limit.year.toString() : null;
    String inscriptionId;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,), 
          onPressed: ()=>Navigator.pop(context)
        ),
        title: Text("Historique des paiements", style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
        centerTitle: true,
        actions: [
          //IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kSouthSeas,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: () => _scaffoldKey.currentState.openEndDrawer())
        ],
      ),
      endDrawer: DefaultDrawer(
        entraide: (){Navigator.pop(context); Navigator.pop(context);},
        accueil: (){Navigator.pop(context); Navigator.pop(context);},
        carnet: (){Navigator.pop(context); Navigator.pop(context);},
        partenaire: (){Navigator.pop(context); Navigator.pop(context);},
        famille: (){Navigator.pop(context); Navigator.pop(context);},
      ),
      body: Column(
        children: [
          SizedBox(height: hv*2.5,),
          HomePageComponents.getInfoActionCard(
            title: adherentProvider.getAdherent.adherentPlan == 0 ? "Vous êtes au Niveau 0: Découverte" : adherentProvider.getAdherent.adherentPlan == 1 ? "Vous êtes au Niveau I: Accès" : adherentProvider.getAdherent.adherentPlan == 2 ? "Vous êtes au Niveau II: Assist" : adherentProvider.getAdherent.adherentPlan == 3 ? "Vous êtes au Niveau III: Sérénité" : "...",
            actionLabel: "Comparer Les Services",
            subtitle: limitString != null ? "Vous êtes couverts jusqu'au $limitString" : "...",
            action: ()=>Navigator.pushNamed(context, '/compare-plans')
          ),
          SizedBox(height: hv*2.5,),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*2),
              width: double.infinity,
              color: whiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("  Mes dernières factures", style: TextStyle(color: kBlueDeep, fontSize: 16, fontWeight: FontWeight.w400)),
                  SizedBox(height: hv*2,),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection('NEW_FACTURATIONS_ADHERENT').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        );
                      }

                      return snapshot.data.docs.length >= 1
                      ? Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot useCaseDoc = snapshot.data.docs[index];
                              InvoiceModel invoice = InvoiceModel.fromDocument(useCaseDoc);
                              if(invoice.type == "INSCRIPTION"){
                                inscriptionId = invoice.id;
                              }
                              print("name: ");
                              return getContributionTile(
                                label : invoice.trimester == null ? invoice.label : invoice.trimester, 
                                doctorName : "bdbd", 
                                date : DateTime.now(), 
                                amount: invoice.amount, 
                                firstDate : invoice.type == "INSCRIPTION" ? invoice.dateCreated.toDate() : invoice.coverageStartDate.toDate(), 
                                lastDate : invoice.paymentDelayDate != null ? invoice.paymentDelayDate.toDate() : invoice.coverageEndDate.toDate(),
                                paid: invoice.stateValidate == true ? 1 : invoice.paid == true && invoice.stateValidate == false ? 3 : invoice.paymentDelayDate != null ? invoice.paymentDelayDate.toDate().compareTo(DateTime.now()) > 0 ? 2 : 0 : 2,
                                type : invoice.type, state : 0, 
                                action : (){
                                  if(invoice.type == "INSCRIPTION"){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vous devez sélectionner la côtisation pour payer l'inscription",)));
                                  }
                                  else if(invoice.stateValidate == true || invoice.paid == true){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Côtisation éffectuée",)));
                                  }
                                  else {
                                    PlanModel plan = PlanModel(
                                      id: inscriptionId,
                                      monthlyAmount: invoice.amount,
                                      label: invoice.label,
                                      registrationFee: 10000,
                                      text: {"titreNiveau": invoice.label}
                                    );
                                    planProvider.setPlanModel(plan);
                                    invoiceProvider.setInvoiceModel(invoice);
                                    Navigator.pushNamed(context, '/coverage-payment');
                                  }
                                }
                              );
                            }),
                      )
                      : Center(
                        child: Container(padding: EdgeInsets.only(top: hv*4),child: Text("Aucune côtisation enrégistrée pour le moment..", textAlign: TextAlign.center)),
                      );
                    }
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getContributionTile({String label, String doctorName, DateTime date, num amount, DateTime firstDate, DateTime lastDate, String type, int state, int paid, Function action}) {
    String lastDateString = lastDate.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(lastDate)+" "+ firstDate.year.toString();
    return GestureDetector(
      onTap: action,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: hv*0.5, horizontal: wv*2),
        padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey[200].withOpacity(0.8), blurRadius: 20.0, spreadRadius: 7.0, offset: Offset(0, 7))]
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type == "INSCRIPTION" ? "Inscription" : "Côtisation", style: TextStyle(color: kDeepTeal, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(label, style: TextStyle(color: kDeepTeal, fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.fade),
                SizedBox(height: hv*2,),
                Text("Montant", style: TextStyle(color: kPrimaryColor, fontSize: 14)),
                Text("$amount f.", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.fade),
              ],
            ),
            Spacer(),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text(paid == 1 ? "Payée" : paid == 2 ? "En retard!" : paid == 3 ? "Validation en cours" : "En attente!", style: TextStyle(color: paid == 1 ? Colors.teal[500] : paid == 2 ? Colors.red : kGoldDeep, fontWeight: FontWeight.bold, fontSize: wv*3.5))),
                      SizedBox(height: hv*2,),
                      Text("Délai de paiement", style: TextStyle(color: kPrimaryColor, fontSize: 14)),
                      Text(lastDateString, style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold, decoration: paid == 1 ? TextDecoration.lineThrough : TextDecoration.none),),
                    ],
                  ),
                  paid != 1 ? SizedBox(width: wv*5,) : Container(),
                  Container(
                    padding: EdgeInsets.only(bottom: hv*3),
                    child: paid != 1 ? Column(
                      children: [
                        Center(child: SvgPicture.asset('assets/icons/Two-tone/Wallet.svg', width: wv*8,)),
                        Text("Payer", style: TextStyle(color: kSouthSeas, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ) :
                    Container(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}