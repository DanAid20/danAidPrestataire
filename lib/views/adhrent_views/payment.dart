/**
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/planModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/invoiceModelProvider.dart';
import 'package:danaid/core/providers/planModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:hover_ussd/hover_ussd.dart';
import 'package:provider/provider.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final HoverUssd _hoverUssd = HoverUssd();

  int om = 1;
  int momo = 2;
  int choice;

  bool spinner2 = false;

  var reqi;

  void orangeMoneyTransfer({String amount, String pin}) async {
    var req = await _hoverUssd.sendUssd(actionId: transferOrangeMoney, extras: {"1": "658112605", "2": "55", "pin": ""});

    print(req.toString());
    print("Doonnneee");

    await FirebaseFirestore.instance.collection(adherent).doc(adherentProvider.getAdherent.adherentId).collection('FACTURATION_ADHERENT').doc(DateTime.now().microsecondsSinceEpoch.toString()).set({
          "Amount": total,
          "createdDate": DateTime.now(),
          "expiryDate": DateTime.now().add(Duration(days: 90))
        }).then((doc) async {
          await FirebaseFirestore.instance.collection(adherent).doc(adherentProvider.getAdherent.adherentId).update({"protectionLevel": plan.planNumber});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Completed",)));
          Navigator.pop(context);
        });
        
    /*.then((res) {
      print("sussss");
      print(res.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Completed",)));
    });*/
  }

  @override
  Widget build(BuildContext context) {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    InvoiceModelProvider invoiceProvider = Provider.of<InvoiceModelProvider>(context);
    
    /*_hoverUssd.onTransactiontateChanged.listen((event) async {
      if (event == TransactionState.succesfull) {
        print("Successsss");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Completed",)));
      } else if (event == TransactionState.waiting) {
        print("waiit");
        
      } else if (event == TransactionState.failed) {
        print("Faiiilll");
      }
    });*/
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded), color: kPrimaryColor, onPressed: ()=>Navigator.pop(context),),
        title: Text(plan.text["titreNiveau"], style: TextStyle(color: kPrimaryColor, fontSize: 20),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: hv*2,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: ()=>setState((){choice = om;}),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: wv*30,
                      width: wv*40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(image: AssetImage('assets/images/om.jpg'), fit: BoxFit.cover)
                      ),
                    ),
                    choice == om ? Positioned(
                      bottom: -5,
                      right: -5,
                      child: CircleAvatar(
                        backgroundColor: kPrimaryColor,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.check, color: whiteColor,),
                        ),
                      ),
                    ) : Container()
                  ],
                ),
              ),
              SizedBox(width: wv*5,),
              GestureDetector(
                onTap: ()=>setState((){choice = momo;}),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: wv*30,
                      width: wv*40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(image: AssetImage('assets/images/momo.jpg'), fit: BoxFit.cover)
                      ),
                    ),
                    choice == momo ? Positioned(
                      bottom: -5,
                      right: -5,
                      child: CircleAvatar(
                        backgroundColor: kPrimaryColor,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.check, color: whiteColor,),
                        ),
                      ),
                    ) : Container()
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          Table(
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]))
                ),
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                    child: Text("Trimestre:")
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                    child: Text(trimester, textAlign: TextAlign.end,)
                  )),
                ]
              ),
              TableRow(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]))
                ),
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                    child: Text("Frais d'inscription:")
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                    child: Text(plan.registrationFee.toString() + "Cfa", textAlign: TextAlign.end,)
                  )),
                ]
              ),
              TableRow(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]))
                ),
                children: [
                  TableCell(child: Container(
                  padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                  child: Text("Paiement trimestrielle:")
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                    child: Text(plan.monthlyAmount.toString()+ "Cfa X $months", textAlign: TextAlign.end,)
                  )),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                    child: Text("Total à payer:")
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                    child: Text(total.toString() + " Cfa", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.end,)
                  )),
                ]
              ),
            ],
          ),

          Container(
            child: CustomTextButton(
              text: "Payer maintenant",
              enable: choice != null && false,
              action: (){} //orangeMoneyTransfer,
            ),
          ),

          CustomTextButton(
            color: kSouthSeas,
            isLoading: spinner2,
            text: "Activer et Payer plus tard",
            action: (){
              Random random = new Random();
              setState(() {
                spinner2 = true;
              });
              
              FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(DateTime.now().microsecondsSinceEpoch.toString()).set({
                "montant": total,
                "createdDate": DateTime.now(),
                "trimester": trimester,
                "intitule": "COSTISATION Q-"+start.year.toString(),
                "dateDebutCouvertureAdherent" : start,
                "dateFinCouvertureAdherent": end,
                "categoriePaiement" : "COTISATION_TRIMESTRIELLE",
                "dateDelai": start.add(Duration(days: 15)),
                "numeroRecu": start.year.toString()+"-"+random.nextInt(99999).toString(),
                "numeroNiveau": plan.planNumber,
                "paymentDate": null,
                "paid": false

              }).then((doc) {

                adherentProvider.getAdherent.havePaid != true ? FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc((DateTime.now().microsecondsSinceEpoch+1).toString()).set({
                  "montant": registrationFee,
                  "createdDate": DateTime.now(),
                  "trimester": trimester,
                  "categoriePaiement": "INSCRIPTION",
                  "intitule": "COSTISATION Q-"+start.year.toString(),
                  "dateDelai": start.add(Duration(days: 15)),
                  "numeroNiveau": plan.planNumber,
                  "paymentDate": null,
                  "numeroRecu": start.year.toString()+"-"+random.nextInt(99999).toString(),
                  "paid": false
                }) : print("Il a payé");

                FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).set({
                  "protectionLevel": plan.planNumber,
                  "datDebutvalidite" : start,
                  "datFinvalidite": end,
                  "paid": false,
                }, SetOptions(merge: true));
                adherentProvider.setAdherentPlan(plan.planNumber);
                adherentProvider.setValidityEndDate(end);
                setState(() {
                  spinner2 = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Plan modifié",)));
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/compare-plans');
              }).catchError((e){
                setState(() {
                  spinner2 = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur",)));
              });
            },
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
            child: Text("En choisissant de payer plus tard, vous aurez un délai de 15 jours pour compléter le paiement")
          ),

          SizedBox(height: hv*2)
        ],
      ),
    );
  }
}
*/