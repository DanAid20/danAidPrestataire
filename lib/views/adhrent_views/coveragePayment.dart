import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/invoiceModel.dart';
import 'package:danaid/core/models/planModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/invoiceModelProvider.dart';
import 'package:danaid/core/providers/planModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class CoveragePayment extends StatefulWidget {
  @override
  _CoveragePaymentState createState() => _CoveragePaymentState();
}

class _CoveragePaymentState extends State<CoveragePayment> {
  static const _hoverChannel = const MethodChannel('danaid.mobile.cm/hover');
  //final HoverUssd _hoverUssd = HoverUssd();

  int om = 1;
  int momo = 2;
  int choice;

  bool spinner2 = false;

  var reqi;

  /*void orangeMoneyTransfer({String amount, String pin}) async {
    var res = _hoverUssd.sendUssd(actionId: transferOrangeMoney, extras: {"1": "658112605", "2": amount, "pin": ""});
    print("Afterrereer");
    print(res.toString()+": vaall");
    print("Doonnneee");
  }

  void mobileMoneyTransfer({String amount, String pin}) async {
    var res = _hoverUssd.sendUssd(actionId: transferMTNMobileMoney, extras: {"phoneNumber": "673662062", "montantTransfert": amount, "raison": "DanAid Payment", "pin": ""});
    print("Afterrereer");
    print(res.toString()+": vaall");
    print("Doonnneee");
  }*/

  Future<dynamic> sendMoney(String phoneNumber, amount) async {
      var sendMap = <String, dynamic>{
        'phoneNumber': "658112605",
        'amount': amount,
      };
  // vide en attendant le code JAVA
  String response = "";
    try {
      final String result = await  _hoverChannel.invokeMethod('sendMoney',sendMap);
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
  return response;
  }

  @override
  Widget build(BuildContext context) {

    int test = 1;
    Random random = new Random();

    PlanModelProvider planProvider = Provider.of<PlanModelProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    InvoiceModelProvider invoiceProvider = Provider.of<InvoiceModelProvider>(context);
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
      trimester = S.of(context).janvierMars + DateTime.now().year.toString();
      if (now.month != 3){
        months = (now.day < 25) ? 4 - now.month : 4 - now.month - 1;
      }
      else{
        if(now.day < 25){
          months = 1;
          trimester = S.of(context).janvierMars + DateTime.now().year.toString();
        }
        else {
          months = 3;
          trimester = S.of(context).avrilJuin + DateTime.now().year.toString();
        }
        trimester = (now.day < 25) ? S.of(context).janvierMars + DateTime.now().year.toString() : S.of(context).avrilJuin + DateTime.now().year.toString(); 
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
      trimester = S.of(context).avrilJuin + DateTime.now().year.toString();
      if (now.month != 6){months = (now.day < 25) ? 7 - now.month : 7 - now.month - 1;}
      else{
        trimester = (now.day < 25) ? S.of(context).avrilJuin + DateTime.now().year.toString() : S.of(context).juilletSeptembre + DateTime.now().year.toString(); 
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
      trimester = S.of(context).juilletSeptembre + DateTime.now().year.toString();
      if (now.month != 9){months = (now.day < 25) ? 10 - now.month : 10 - now.month - 1;}
      else{
        trimester = (now.day < 25) ? S.of(context).juilletSeptembre + DateTime.now().year.toString() : S.of(context).octobreDcembre + DateTime.now().year.toString(); 
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
      trimester = S.of(context).octobreDcembre + DateTime.now().year.toString();
      
      if (now.month != 9){months = (now.day < 25) ? 12 - now.month : 12 - now.month - 1;}
      else{
        trimester = (now.day < 25) ? S.of(context).octobreDcembre + DateTime.now().year.toString() : S.of(context).janvierMars + (DateTime.now().year+1).toString(); 
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

    /*

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
    */
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded), color: kPrimaryColor, onPressed: ()=>Navigator.pop(context),),
        title: Text(invoice.paid == false ? invoice.label : plan.text["titreNiveau"].toString(), style: TextStyle(color: kPrimaryColor, fontSize: 20),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: hv*2,),
                  /** 
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
                  */
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
                    margin: EdgeInsets.symmetric(horizontal: wv*4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      boxShadow: [BoxShadow(color: Colors.grey[400], spreadRadius: 0.5, blurRadius: 1.0)],
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).important, style: TextStyle(color: Colors.grey[600], fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: hv*1,),
                        Text(S.of(context).notreDispositifDePaiementEstEnCoursDeMiseJour, style: TextStyle(color: kTextBlue, fontSize: 15)),
                      ],
                    ),
                  ),
                  //Spacer(),
                  SizedBox(height: hv*4,),
                  Table(
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]))
                        ),
                        children: [
                          TableCell(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                            child: Row(
                              children: [
                                Container(
                                  height: wv*7,
                                  width: wv*7,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(image: AssetImage('assets/images/momo.jpg'), fit: BoxFit.cover)
                                  ),
                                ),
                                SizedBox(width: wv*2,),
                                Expanded(child: Text("MTN MoMo\n(FABRICE MBANGA):", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),)),
                              ],
                            )
                          )),
                          TableCell(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                            child: Text("673 66 20 62", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.end,)
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
                            child: Row(
                              children: [
                                Container(
                                  height: wv*7,
                                  width: wv*7,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(image: AssetImage('assets/images/om.jpg'), fit: BoxFit.cover)
                                  ),
                                ),
                                SizedBox(width: wv*2,),
                                Expanded(child: Text("Orange Money\n(NYETTO)", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold))),
                              ],
                            )
                          )),
                          TableCell(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                            child: Text("658 11 26 05", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.end,)
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
                            child: Text(S.of(context).trimestre)
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
                            child: Text(S.of(context).fraisDinscription)
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
                          child: Text(S.of(context).paiementTrimestrielle)
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
                            child: Text(S.of(context).totalPayer)
                          )),
                          TableCell(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                            child: Text((total+registrationFee).toString() + " Cfa", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.end,)
                          )),
                        ]
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          /*CustomTextButton(
            text: "New button",
            action: () async {
              String _res =await UssdAdvanced.sendAdvancedUssd(code: '#150*1*1*658112605*50*code#', subscriptionId: -1);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_res.toString()))); //1 1 num 100f code
                    
            },
          ),*/

          Container(
            child: CustomTextButton(
              isLoading: spinner2,
              text: S.of(context).confirmer,
              //enable: choice != null,
              action: (){
                _confirm(context);
                /*
                Random random = new Random();
                if(invoice.paid == false){
                  setState(() {
                  spinner2 = true;
                });
                
                choice == 1 ? orangeMoneyTransfer(amount: invoice.amount.toInt().toString()) :  mobileMoneyTransfer(amount: invoice.amount.toInt().toString());
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
                      "havePaidBefore": true,
                      "numeroRecu": start.year.toString()+"-"+random.nextInt(99999).toString(),
                      "paid": false
                    }) : print("Il a payé");
                    choice == 1 ? orangeMoneyTransfer(amount: (registrationFee + total).toInt().toString()) :  mobileMoneyTransfer(amount: (registrationFee + total).toInt().toString());

                    FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).set({
                      "protectionLevel": plan.planNumber,
                      "datDebutvalidite" : start,
                      "datFinvalidite": end,
                      "paid": false,
                    }, SetOptions(merge: true));
                    setState(() {
                      spinner2 = false;
                    });
                    adherentProvider.setAdherentPlan(plan.planNumber);
                    adherentProvider.setValidityEndDate(end);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Plan modifié",)));
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/compare-plans');
                  }).catchError((e){
                    setState(() {
                      spinner2 = false;
                    });
                    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur",)));
                  });
                }
              */
              }
            ),
          ),

          /*

          (invoice.amount == null) ? CustomTextButton(
            color: kSouthSeas,
            isLoading: spinner2,
            text: "Activer et Payer plus tard",
            action: (){
              /*Random random = new Random();
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
              });*/
            },
          ) : Container(),

          invoice.amount == null ? Container(
            padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
            child: Text("En choisissant de payer plus tard, vous aurez un délai de 15 jours pour compléter le paiement")
          ) : Container(),*/

          SizedBox(height: hv*2)
        ],
      ),
    );
  }

  _confirm (BuildContext context){
    showDialog(context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: wv*5,),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(children: [
                  SizedBox(height: hv*4),
                  RichText(text: TextSpan(children: [TextSpan(text: S.of(context).avezvousDjFfectuLeVirementMobile, style: TextStyle(fontWeight: FontWeight.w700)),], style: TextStyle(color: kPrimaryColor, fontSize: wv*4.5),), textAlign: TextAlign.center,),
                  SizedBox(height: hv*2,),
                  Text(S.of(context).aprsConfirmationUnAgentReviendraVersVousSous24hPour, style: TextStyle(color: Colors.grey[600], fontSize: wv*4), textAlign: TextAlign.center),
                  Row(children: [
                    Expanded(
                      child: CustomTextButton(
                        expand: false,
                        text: S.of(context).confirmer,
                        isLoading: spinner2,
                        color: kPrimaryColor,
                        action: (){
                          Random random = new Random();
                          setState(() {
                            spinner2 = true;
                          });

                          PlanModelProvider planProvider = Provider.of<PlanModelProvider>(context, listen: false);
                          AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
                          InvoiceModelProvider invoiceProvider = Provider.of<InvoiceModelProvider>(context, listen: false);
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
                            trimester = S.of(context).janvierMars + DateTime.now().year.toString();
                            if (now.month != 3){
                              months = (now.day < 25) ? 4 - now.month : 4 - now.month - 1;
                            }
                            else{
                              if(now.day < 25){
                                months = 1;
                                trimester = S.of(context).janvierMars + DateTime.now().year.toString();
                              }
                              else {
                                months = 3;
                                trimester = S.of(context).avrilJuin + DateTime.now().year.toString();
                              }
                              trimester = (now.day < 25) ? S.of(context).janvierMars + DateTime.now().year.toString() : S.of(context).avrilJuin + DateTime.now().year.toString(); 
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
                            trimester = S.of(context).avrilJuin + DateTime.now().year.toString();
                            if (now.month != 6){months = (now.day < 25) ? 7 - now.month : 7 - now.month - 1;}
                            else{
                              trimester = (now.day < 25) ? S.of(context).avrilJuin + DateTime.now().year.toString() : S.of(context).juilletSeptembre + DateTime.now().year.toString(); 
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
                            trimester = S.of(context).juilletSeptembre + DateTime.now().year.toString();
                            if (now.month != 9){months = (now.day < 25) ? 10 - now.month : 10 - now.month - 1;}
                            else{
                              trimester = (now.day < 25) ? S.of(context).juilletSeptembre + DateTime.now().year.toString() : S.of(context).octobreDcembre + DateTime.now().year.toString(); 
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
                            trimester = S.of(context).octobreDcembre + DateTime.now().year.toString();
                            
                            if (now.month != 9){months = (now.day < 25) ? 12 - now.month : 12 - now.month - 1;}
                            else{
                              trimester = (now.day < 25) ? S.of(context).octobreDcembre + DateTime.now().year.toString() : S.of(context).janvierMars + (DateTime.now().year+1).toString(); 
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

                          DocumentReference contributionRef = FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc();
                          String inscriptionId = contributionRef.id;

                          if(invoice.label != null && plan.maxCreditAmount == null){
                            setState(() {
                            spinner2 = true;
                          });

                          try {
                            if(adherentProvider.getAdherent.havePaid == false){
                              FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).set({
                                "havePaidBefore": true,
                              }, SetOptions(merge: true)).then((value) {
                                setState(() {
                                  spinner2 = false;
                                });
                              });
                            }
                            
                          }
                          catch(e) {
                            setState(() {
                              spinner2 = false;
                            });
                          }
                          
                          //choice == 1 ? orangeMoneyTransfer(amount: invoice.amount.toInt().toString()) :  mobileMoneyTransfer(amount: invoice.amount.toInt().toString());
                          /*FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(invoice.id).update({
                            "paymentDate": DateTime.now(),
                            "paid": true
                          }).then((doc) {

                            
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vous serez recontactés pour confirmation..",)));
                            Navigator.pop(context);
                            
                            if(invoice.inscriptionId != null){
                              FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(invoice.inscriptionId).update({
                                "paymentDate": DateTime.now(),
                                "paid": true
                              });
                            }

                            /*!adherentProvider.getAdherent.havePaid ? FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(plan.id).update({
                              "paymentDate": DateTime.now(),
                            }) : print("Il a payé");*/

                            
                          }).catchError((e){
                            setState(() {
                              spinner2 = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur",)));
                          });*/
                          }
                          else {
                            setState(() {
                              spinner2 = true;
                            });
                            try {
                                FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).set({
                                  "protectionLevel": plan.planNumber,
                                  "datDebutvalidite" : start,
                                  "havePaidBefore": true,
                                  "datFinvalidite": end,
                                  "paid": false,
                                }, SetOptions(merge: true));
                                setState(() {
                                  spinner2 = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Plan modifié",)));
                                adherentProvider.setAdherentPlan(plan.planNumber);
                                adherentProvider.setValidityEndDate(end);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/compare-plans');
                            }
                            catch(e){
                              setState(() {
                                spinner2 = false;
                              });
                            }

                            /*adherentProvider.getAdherent.havePaid == false ? FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(inscriptionId).set({
                              "montant": registrationFee,
                              "etatValider": false,
                              "createdDate": DateTime.now(),
                              "trimester": trimester,
                              "firstfacturationOfUser": true,
                              "categoriePaiement": "INSCRIPTION",
                              "intitule": "COSTISATION Q-"+start.year.toString(),
                              "dateDelai": start.add(Duration(days: 15)),
                              "numeroNiveau": plan.planNumber,
                              "paymentDate": null,
                              "numeroRecu": start.year.toString()+"-"+random.nextInt(99999).toString(),
                              "paid": true
                            }) : print("Il a payé");
                            */
                            
                            /*FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection('NEW_FACTURATIONS_ADHERENT').add({
                              "inscriptionId": adherentProvider.getAdherent.havePaid == false ? inscriptionId : null,
                              "montant": total,
                              "createdDate": DateTime.now(),
                              "trimester": trimester,
                              "etatValider": false,
                              "intitule": "COSTISATION Q-"+start.year.toString(),
                              "dateDebutCouvertureAdherent" : start,
                              "dateFinCouvertureAdherent": end,
                              "categoriePaiement" : "COTISATION_TRIMESTRIELLE",
                              "dateDelai": start.add(Duration(days: 15)),
                              "numeroRecu": start.year.toString()+"-"+random.nextInt(99999).toString(),
                              "numeroNiveau": plan.planNumber,
                              "paymentDate": null,
                              "paid": true

                            }).then((doc) {
                              //choice == 1 ? orangeMoneyTransfer(amount: (registrationFee + total).toInt().toString()) :  mobileMoneyTransfer(amount: (registrationFee + total).toInt().toString());

                              
                            }).catchError((e){
                              setState(() {
                                spinner2 = false;
                              });
                              //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur",)));
                            });*/
                          }
                        
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomTextButton(
                        expand: false,
                        text: S.of(context).annuler,
                        color: kSouthSeas,
                        action: () => Navigator.pop(context), //{setState((){spinner2 = !spinner2;});}
                      ),
                    )
                  ], mainAxisSize: MainAxisSize.max,)
                  
                ], mainAxisAlignment: MainAxisAlignment.center, ),
              ),
            ],
          ),
        );
      }
    );
  }
  uploadInvoice(){}
}