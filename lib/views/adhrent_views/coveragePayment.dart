import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/invoiceModel.dart';
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

class CoveragePayment extends StatefulWidget {
  @override
  _CoveragePaymentState createState() => _CoveragePaymentState();
}

class _CoveragePaymentState extends State<CoveragePayment> {
  final HoverUssd _hoverUssd = HoverUssd();

  int om = 1;
  int momo = 2;
  int choice;

  bool spinner2 = false;

  var reqi;

  void orangeMoneyTransfer({String amount, String pin}) async {
    var res = _hoverUssd.sendUssd(actionId: transferOrangeMoney, extras: {"1": "658112605", "2": amount, "pin": ""});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Afterrrrrr",)));
    print("Afterrereer");
    print(res.toString()+": vaall");
    print("Doonnneee");
  }

  @override
  Widget build(BuildContext context) {

    int test = 1;
    Random random = new Random();

    PlanModelProvider planProvider = Provider.of<PlanModelProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    InvoiceModelProvider invoiceProvider = Provider.of<InvoiceModelProvider>(context);
    invoiceProvider.setInvoiceModel(InvoiceModel());
    InvoiceModel invoice = invoiceProvider.getInvoice;
    PlanModel plan = planProvider.getPlan;

    if(invoiceProvider.getInvoice.paid != null){}

    DateTime now = DateTime.now();

    int months = 0;
    String trimester;
    DateTime start;
    DateTime end;

    //updatePaymentDate({String invoiceId, String regId}){}
    
    if(now.month >= 1 && now.month < 4){
      trimester = "Janvier à Mars " + DateTime.now().year.toString();
      if (now.month != 3){
        months = (now.day < 25) ? 4 - now.month : 4 - now.month - 1;
      }
      else{
        if(now.day < 25){
          months = 1;
          trimester = "Janvier à Mars " + DateTime.now().year.toString();
        }
        else {
          months = 3;
          trimester = "Avril à Juin " + DateTime.now().year.toString();
        }
        trimester = (now.day < 25) ? "Janvier à Mars " + DateTime.now().year.toString() : "Avril à Juin " + DateTime.now().year.toString(); 
        months = (now.day < 25) ? 1 : 3;
      }
      if(now.month == 3 && now.day > 25){
        start = DateTime(now.year, 04, 01);
        end = DateTime(now.year, 07, 01);
      } else {
        start = DateTime(now.year, 01, 01);
        end = DateTime(now.year, 04, 01);
      }
    }

    else if(now.month >= 4 && now.month < 7){
      trimester = "Avril à Juin " + DateTime.now().year.toString();
      if (now.month != 6){months = (now.day < 25) ? 7 - now.month : 7 - now.month - 1;}
      else{
        trimester = (now.day < 25) ? "Avril à Juin " + DateTime.now().year.toString() : "Juillet à Septembre " + DateTime.now().year.toString(); 
        months = (now.day < 25) ? 1 : 3;
      }
      if(now.month == 6 && now.day > 25){
        start = DateTime(now.year, 07, 01);
        end = DateTime(now.year, 10, 01);
      } else {
        start = DateTime(now.year, 04, 01);
        end = DateTime(now.year, 07, 01);
      }
    }

    else if(now.month >= 7 && now.month < 10){
      trimester = "Juillet à Septembre " + DateTime.now().year.toString();
      if (now.month != 9){months = (now.day < 25) ? 10 - now.month : 10 - now.month - 1;}
      else{
        trimester = (now.day < 25) ? "Juillet à Septembre " + DateTime.now().year.toString() : "Octobre à Décembre " + DateTime.now().year.toString(); 
        months = (now.day < 25) ? 1 : 3;}

      if(now.month == 9 && now.day > 25){
        start = DateTime(now.year, 10, 01);
        end = DateTime(now.year, 12, 31);
      } else {
        start = DateTime(now.year, 07, 01);
        end = DateTime(now.year, 10, 01);
      }
    }

    else if(now.month >= 10 && now.month <= 12){
      trimester = "Octobre à Décembre " + DateTime.now().year.toString();
      
      if (now.month != 9){months = (now.day < 25) ? 12 - now.month : 12 - now.month - 1;}
      else{
        trimester = (now.day < 25) ? "Octobre à Décembre " + DateTime.now().year.toString() : "Janvier à Mars " + (DateTime.now().year+1).toString(); 
        months = (now.day < 25) ? 1 : 3;
      }

      if(now.month == 12 && now.day > 25){
        start = DateTime(now.year+1, 01, 01);
        end = DateTime(now.year+1, 04, 01);
      } else {
        start = DateTime(now.year, 10, 01);
        end = DateTime(now.year, 12, 31);
      }
    }

    num total = plan.monthlyAmount*months;
    num registrationFee = plan.registrationFee;

    _hoverUssd.onTransactiontateChanged.listen((event) async {
      if (event == TransactionState.succesfull) {
        print("Successsss");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Completed",)));

      } else if (event == TransactionState.waiting) {

        print("waiit");
        /**
        if(invoice.paid == false){
          if(test == 1){
            setState(() {
              spinner2 = true;
            });
            
            FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(invoice.id).update({
              "paymentDate": DateTime.now(),
            }).then((doc) {

              !adherentProvider.getAdherent.havePaid ? FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(plan.id).update({
                "paymentDate": DateTime.now(),
              }) : print("Il a payé");
              setState(() {
                spinner2 = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vous serez recontactés pour confirmation..",)));
              Navigator.pop(context);
              Navigator.pop(context);
            }).catchError((e){
              setState(() {
                spinner2 = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur",)));
            });
            test = 2;
          }
        } else {
          if(test == 1){
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
              "paymentDate": DateTime.now(),
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
                "paymentDate": DateTime.now(),
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
            test = 2;
          }
        }
        */
      } else if (event == TransactionState.failed) {
        print("Faiiilll");
      }
    });
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded), color: kPrimaryColor, onPressed: ()=>Navigator.pop(context),),
        title: Text(invoice.paid == false ? invoice.label : plan.text["titreNiveau"].toString(), style: TextStyle(color: kPrimaryColor, fontSize: 20),),
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
              /*SizedBox(width: wv*5,),
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
              ),*/
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
                    child: Text((total+registrationFee).toString() + " Cfa", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.end,)
                  )),
                ]
              ),
            ],
          ),

          Container(
            child: CustomTextButton(
              isLoading: spinner2,
              text: "Payer maintenant",
              //enable: choice != null && false,
              action: (){
                Random random = new Random();
                if(invoice.paid == false){
                  setState(() {
                  spinner2 = true;
                });
                
                orangeMoneyTransfer(amount: "50");
                FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(invoice.id).update({
                  "paymentDate": DateTime.now(),
                }).then((doc) {

                  /*!adherentProvider.getAdherent.havePaid ? FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(plan.id).update({
                    "paymentDate": DateTime.now(),
                  }) : print("Il a payé");*/
                  setState(() {
                    spinner2 = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vous serez recontactés pour confirmation..",)));
                  Navigator.pop(context);
                  Navigator.pop(context);
                }).catchError((e){
                  setState(() {
                    spinner2 = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur",)));
                });
                }
                else {
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
                    orangeMoneyTransfer(amount: "55");
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
                }
              
              } //orangeMoneyTransfer,
            ),
          ),

          (invoice.paid == null) ? CustomTextButton(
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
          ) : Container(),

          invoice.paid == null ? Container(
            padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
            child: Text("En choisissant de payer plus tard, vous aurez un délai de 15 jours pour compléter le paiement")
          ) : Container(),

          SizedBox(height: hv*2)
        ],
      ),
    );
  }
  uploadInvoice(){}
}