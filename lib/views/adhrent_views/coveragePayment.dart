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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CoveragePayment extends StatefulWidget {
  @override
  _CoveragePaymentState createState() => _CoveragePaymentState();
}

class _CoveragePaymentState extends State<CoveragePayment> {
  static const _hoverChannel = const MethodChannel('danaid.mobile.cm/hover');
  //final HoverUssd _hoverUssd = HoverUssd();

  int om = 1;
  int momo = 2;
  int? choice;

  bool spinner2 = false;

  var reqi;

  static const platform = const MethodChannel('danaidproject.sendmoney');
  String receivedString = "";

  Future<String> makePayment({required num cost, required bool isOrange}) async {
    //String amount = "60", data = "", phoneNumber = "650913861";
    String amount = cost.toString();
    String operator = isOrange ? 'moneyTransferOrangeAction' : 'moneyTransferMTNAction';
    String phoneNumber = isOrange ? '658112605' : '673662062';

    //moneyTransferMTNAction, moneyTransferOrangeAction
    try {
      final String result = await platform.invokeMethod(operator, {"amount": amount, "phoneNumber": phoneNumber});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result == "SUCCESS" ? "Transaction réussie" : "Transaction échouée")));
      if(result == null){
        setState(() { spinner2 = false;});
      }
      return result;
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Transaction échouée")));
      setState(() { spinner2 = false;});
      return "FAILED";
    }
  }


  bool reduction = false;

  int removedAmount = 0;
  bool campaignOn = false;

  init() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('DANAID_DATA').doc('CAMPAGNE').get();
    setState(() {
      campaignOn = doc.get("active");
      removedAmount = doc.get("amount");
    });
  }

  @override
  void initState() { 
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {

    int test = 1;
    Random random = new Random();

    PlanModelProvider planProvider = Provider.of<PlanModelProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    InvoiceModelProvider invoiceProvider = Provider.of<InvoiceModelProvider>(context);
    InvoiceModel invoice = invoiceProvider.getInvoice;
    PlanModel? plan = planProvider.getPlan;

    if(invoiceProvider.getInvoice.paid != null){}

    DateTime now = DateTime.now();

    int months = 0;
    String trimester;
    DateTime start;
    DateTime end;


    num? registrationFee = (invoice.paid == false || invoice.stateValidate == false) && invoice.inscriptionId != null ? plan!.registrationFee : 0;
    num total = !reduction ? invoice.amount! + registrationFee! : (invoice.amount! + registrationFee! - removedAmount);
    total = total.toInt();
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded), color: kPrimaryColor, onPressed: ()=>Navigator.pop(context),),
        title: Text(invoice.paid == false ? invoice.label! : plan!.text!["titreNiveau"]!.toString(), style: TextStyle(color: kPrimaryColor, fontSize: 20),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
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
                  SizedBox(height: hv*3,),
                  
                  invoice.planNumber == 1 && campaignOn ? Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
                    margin: EdgeInsets.symmetric(horizontal: wv*4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      boxShadow: [BoxShadow(color: Colors.grey[400]!, spreadRadius: 0.5, blurRadius: 1.0)],
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).important, style: TextStyle(color: Colors.grey[600], fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: hv*1,),
                        Text("Obtenez $removedAmount FCFA de réduction pour l'achat de ce plan de service", style: TextStyle(color: kTextBlue, fontSize: 15)),
                        SizedBox(height: hv*1,),
                        CustomTextButton(
                          noPadding: true,
                          text: reduction ? "Annuler" : "Reçevoir",
                          color: kSouthSeas,
                          action: ()=>setState((){reduction = !reduction;}),
                        )
                      ],
                    ),
                  ) : Container(),
                  //Spacer(),
                  SizedBox(height: hv*4,),
                  Table(
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]!))
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
                          border: Border(bottom: BorderSide(color: Colors.grey[300]!))
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
                          border: Border(bottom: BorderSide(color: Colors.grey[300]!))
                        ),
                        children: [
                          TableCell(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                            child: Text(S.of(context).fraisDinscription)
                          )),
                          TableCell(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                            child: Text(registrationFee.toString() + "Cfa", textAlign: TextAlign.end,)
                          )),
                        ]
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]!))
                        ),
                        children: [
                          TableCell(child: Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                          child: Text("Paiement annuelle")
                          )),
                          TableCell(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                            child: Text((invoice.amount!/12).toString()+" X 12", textAlign: TextAlign.end,)
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
                            child: !reduction ? Text("$total Cfa", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.end,) :
                                      RichText(
                                        textAlign: TextAlign.end,
                                        text: TextSpan(
                                          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                                          children: [
                                            TextSpan(text: "${total + removedAmount}", style: TextStyle(decoration: TextDecoration.lineThrough, fontWeight: FontWeight.w400)),
                                            TextSpan(text: "  $total Cfa", style: TextStyle(color: kDeepTeal))
                                          ]
                                        ),
                                      )
                          )),
                        ]
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Container(
            child: CustomTextButton(
              isLoading: spinner2,
              text: S.of(context).confirmer,
              enable: choice != null,
              action: () async {
                setState(() {spinner2 = true;});
                //_confirm(context);
                String result = await makePayment(cost: total, isOrange: choice == om);
                if(result == "SUCCESS"){
                  print("Paiement effectué");
                  if(!adherentProvider.getAdherent!.havePaid! && invoice.inscriptionId != null){
                    await FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(invoice.inscriptionId).update({
                      "paymentDate": DateTime.now(),
                      "etatValider": true,
                      "paid": true
                    });
                  }
                  FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(invoice.id).update({
                    "paymentDate": DateTime.now(),
                    "etatValider": true,
                    "amountPaid": (total - registrationFee),
                    "reduction": reduction,
                    "paid": true
                  }).then((value) async {
                    await FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).set({
                      "datDebutvalidite" : invoice.coverageStartDate,
                      "havePaidBefore": true,
                      "paymentDate": DateTime.now(),
                      "datFinvalidite": invoice.coverageEndDate,
                      "paid": true,
                    }, SetOptions(merge: true));
                  
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Plan modifié",)));
                    adherentProvider.setAdherentPlan(invoice.planNumber!);
                    adherentProvider.setValidityEndDate(invoice.coverageEndDate!.toDate());
                    setState(() {spinner2 = false;});
                    setState(() {
                      spinner2 = false;
                    });
                    Navigator.pop(context);
                  });
                }
                else {
                  setState(() {spinner2 = false;});
                }
              }
            ),
          ), 

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
                        action: (){},
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
}