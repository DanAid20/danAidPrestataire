import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/planModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
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

  var reqi;

  void orangeMoneyTransfer({String amount, String pin}) async {
    var req = await _hoverUssd.sendUssd(actionId: transferOrangeMoney, extras: {"1": "658112605", "2": "55", "pin": ""});

    print(req.toString());
    print("Doonnneee");

    /*await FirebaseFirestore.instance.collection(adherent).doc(adherentProvider.getAdherent.adherentId).collection('FACTURATION_ADHERENT').doc(DateTime.now().microsecondsSinceEpoch.toString()).set({
          "Amount": total,
          "createdDate": DateTime.now(),
          "expiryDate": DateTime.now().add(Duration(days: 90))
        }).then((doc) async {
          await FirebaseFirestore.instance.collection(adherent).doc(adherentProvider.getAdherent.adherentId).update({"protectionLevel": plan.planNumber});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Completed",)));
          Navigator.pop(context);
        });*/
        
    /*.then((res) {
      print("sussss");
      print(res.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Completed",)));
    });*/
  }

  @override
  Widget build(BuildContext context) {

    PlanModelProvider planProvider = Provider.of<PlanModelProvider>(context, listen: false);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    PlanModel plan = planProvider.getPlan;

    num total = plan.registrationFee + plan.monthlyAmount*3;
    
    _hoverUssd.onTransactiontateChanged.listen((event) async {
      if (event == TransactionState.succesfull) {
        print("Successsss");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Completed",)));
      } else if (event == TransactionState.waiting) {
        print("waiit");
        
      } else if (event == TransactionState.failed) {
        print("Faiiilll");
      }
    });
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded), color: kPrimaryColor, onPressed: ()=>Navigator.pop(context),),
        title: Text(plan.text["titreNiveau"], style: TextStyle(color: kPrimaryColor, fontSize: 20),),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _hoverUssd.onTransactiontateChanged,
        builder: (context, snapshot) {
          return Column(
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
                        child: Text(plan.monthlyAmount.toString()+ "Cfa X 3", textAlign: TextAlign.end,)
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
                  text: "Payer",
                  enable: choice != null,
                  action: orangeMoneyTransfer,
                ),
              )
            ],
          );
        }
      ),
    );
  }
}