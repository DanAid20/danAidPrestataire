import 'package:danaid/core/models/campaignModel.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/invoiceModel.dart';
import 'package:danaid/core/models/miniInvoiceModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class PaymentCart extends StatefulWidget {
  final InvoiceModel? invoice;
  final num? regFee;
  const PaymentCart({ Key? key, this.invoice, this.regFee }) : super(key: key);

  @override
  _PaymentCartState createState() => _PaymentCartState();
}

class _PaymentCartState extends State<PaymentCart> {
  int payments = 0;
  int? months;
  int maxMonths = 12;
  num? amountPerMonth;
  num? totalAmount;
  num? total;
  num? registrationFee;
  List campaignsChosen = [];
  num promoSum = 0;
  num promoRegistrationSum = 0;
  bool payInscription = true;

  TextEditingController _codeController = new TextEditingController();

  bool spinner = false;

  init(){
    months = (widget.invoice?.monthsPaid == null ? 12 : 12 - widget.invoice!.monthsPaid!) as int?;
    maxMonths = months!;
    totalAmount = widget.invoice!.amount!;
    registrationFee = widget.invoice?.inscriptionId == null || widget.invoice?.registrationPaid == true ? 0 : widget.regFee;

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
    DateTime? invStart = widget.invoice?.coverageStartDate?.toDate();
    DateTime? invEnd = widget.invoice?.coverageEndDate?.toDate();
    DateTime? invPaidStart = widget.invoice?.currentPaidStartDate?.toDate();
    DateTime? invPaidEnd = widget.invoice?.currentPaidEndDate?.toDate();
    amountPerMonth = totalAmount!/12;
    num? amountToPay = (months! * amountPerMonth!).round();
    DateTime? start = invPaidEnd == null ? invStart : invPaidEnd.add(Duration(days: 1));
    DateTime end = invPaidEnd == null ? invStart!.add(Duration(days: months!*30)) : invPaidEnd.add(Duration(days: months!*30));

    List? campaigns = widget.invoice?.campaignsChosen == null ? [] : widget.invoice?.campaignsChosen;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, color: kTextBlue,), onPressed: ()=>Navigator.pop(context)),
        title: Column(
          children: [
            Text("Mon Panier", style: TextStyle(color: kTextBlue,fontSize: 18),),
            Text("Facture en attente", style: TextStyle(color: kTextBlue,fontSize: 14),),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.grey[200],
                    padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 1.5),
                          decoration: BoxDecoration(
                            color: kSouthSeas.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1.5),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("Facture de couverture", style: TextStyle(color: kTextBlue,fontSize: 14),),
                                        Spacer(),
                                        Text("$months mois", style: TextStyle(color: kTextBlue,fontSize: 14),),
                                      ],
                                    ),
                                    SizedBox(height: hv*2,),
                                    Row(
                                      children: [
                                        Text(widget.invoice!.label!, style: TextStyle(color: kDeepTeal, fontSize: 16.5, fontWeight: FontWeight.bold)),
                                        Spacer(),
                                        Text("$amountToPay f.", style: TextStyle(color: kCardTextColor, fontSize: 16.5, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: hv*0.5),
                                child: Row(
                                  children: [
                                    SizedBox(width: wv*3,),
                                    Expanded(child: Text("Modifier le montant de côtisation", style: TextStyle(color: kCardTextColor, fontSize: 15))),
                                    SizedBox(width: wv*2,),
                                    IconButton(
                                      icon: CircleAvatar(
                                        backgroundColor: kPrimaryColor,
                                        child: Icon(LineIcons.minus, color: whiteColor,),
                                      ), 
                                      onPressed: (adherentProvider.getAdherent?.adherentPlan != 1.1) ? ()=>setState((){months!>1? months = months! - 1 : months = 1;}) : ()=>setState((){months = 6;})
                                    ),
                                    SizedBox(width: wv*2,),
                                    IconButton(
                                      icon: CircleAvatar(
                                        backgroundColor: kPrimaryColor,
                                        child: Icon(LineIcons.plus, color: whiteColor,),
                                      ), 
                                      onPressed: (adherentProvider.getAdherent?.adherentPlan != 1.1) ? ()=>setState((){months!<maxMonths? months = months! + 1 : months = maxMonths;}) : ()=>setState((){months = 12;})
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        widget.invoice?.inscriptionId != null && payInscription == true && widget.invoice?.registrationPaid != true ? Container(
                          margin: EdgeInsets.symmetric(vertical: hv*0.25),
                          padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1.5),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("Facture d'inscription", style: TextStyle(color: kCardTextColor,fontSize: 14),),
                                        Spacer(),
                                      ],
                                    ),
                                    SizedBox(height: hv*1.5,),
                                    Row(
                                      children: [
                                        Text("Frais d'inscription", style: TextStyle(color: kDeepTeal, fontSize: 18, fontWeight: FontWeight.bold)),
                                        Spacer(),
                                        Text("$registrationFee f.", style: TextStyle(color: kCardTextColor, fontSize: 16.5, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: wv*2,),
                              IconButton(
                                icon: CircleAvatar(
                                  backgroundColor: primaryColor,
                                  child: Icon(LineIcons.minus, color: whiteColor,),
                                ), 
                                onPressed: ()=>setState((){payInscription = !payInscription; registrationFee = 0;})
                              ),
                            ],
                          ),
                        ) 
                        : Container(),
                      ],
                    ),
                  ),
                  Container(
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
                            child: Container(
                              width: 150,
                              height: 150,
                              margin: EdgeInsets.symmetric(vertical: hv*2.5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(image: AssetImage('assets/icons/icon.png'), fit: BoxFit.cover)
                              ),
                            ),
                          );
                        }
                        return Container(
                          height: hv*40,
                          margin: EdgeInsets.symmetric(vertical: hv*1.5, horizontal: wv*2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200]!),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index){
                              CampaignModel camp = CampaignModel.fromDocument(snapshot.data!.docs[index]);
                              if((widget.invoice?.inscriptionId == null || payInscription == false || widget.invoice?.registrationPaid == true) && camp.scope == "INSCRIPTION"){
                                return Container();
                              }
                              if(campaigns!.contains(camp.id)){
                                return Container();
                              }
                              return HomePageComponents.getPromotionTile(
                                title: camp.name,
                                description: camp.description,
                                firstDate: camp.startDate?.toDate(),
                                lastDate: camp.endDate?.toDate(),
                                amount: camp.scope == "INSCRIPTION" ? widget.regFee! < 10000 ? widget.regFee : camp.amount : camp.amount,
                                active: camp.active,
                                chosen: campaignsChosen.contains(camp.id),
                                action: (){
                                  num amount = camp.amount!;
                                  if(camp.scope == "INSCRIPTION"){
                                    if(widget.regFee! < 10000){
                                      amount = widget.regFee!;
                                      setState(() {});
                                    }
                                  }
                                  if(camp.requireCoupon == true){
                                    if(adherentProvider.getAdherent?.couponCodeUsed != null){
                                      if(campaignsChosen.contains(camp.id)){
                                        campaignsChosen.remove(camp.id);
                                        registrationFee = registrationFee! + amount;
                                        promoRegistrationSum = promoRegistrationSum + amount;
                                      }
                                      else {
                                        showDialog(context: context,
                                          builder: (BuildContext context){
                                            return StatefulBuilder(
                                              builder: (context, settingState) {
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
                                                          Icon(LineIcons.lock, color: kDeepTeal, size: 70,),
                                                          SizedBox(height: hv*2,),
                                                          Text("Entrez votre code promo", style: TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.w700),),
                                                          CustomTextField(
                                                            controller: _codeController,
                                                            noPadding: true,
                                                            onChanged: (val)=>settingState((){}),
                                                            label: "",
                                                          ),
                                                          SizedBox(height: hv*2),
                                                          CustomTextButton(
                                                            text: "Continuer",
                                                            color: kDeepTeal,
                                                            enable: _codeController.text.isNotEmpty,
                                                            isLoading: spinner,
                                                            action: (){
                                                              if(_codeController.text == adherentProvider.getAdherent?.couponCodeUsed) {
                                                                if(adherentProvider.getAdherent!.dateCreated!.toDate().add(Duration(days: 30)).isBefore(DateTime.now())){
                                                                  campaignsChosen.add(camp.id);
                                                                  registrationFee = registrationFee! - amount;
                                                                  promoRegistrationSum = promoRegistrationSum + amount;
                                                                  print("promo somme: $promoRegistrationSum,\n regFee: $registrationFee \n campagnes: $campaignsChosen");
                                                                  setState(() {});
                                                                  Navigator.pop(context);
                                                                }
                                                                else {
                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ce code promo a déjà expiré..."), backgroundColor: Colors.red,));
                                                                  _codeController.clear();
                                                                  Navigator.pop(context);
                                                                }
                                                              } else {
                                                                _codeController.clear();
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Le code promo est incorrecte")));
                                                              }
                                                            },
                                                          )
                                                          
                                                        ], mainAxisAlignment: MainAxisAlignment.center, ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            );
                                          }
                                        );
                                      }
                                    }
                                    else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Seuls les adhérents s'étant inscrit par lien d'invitation peuvent utiliser un code promo")));
                                    }
                                  }
                                  else {
                                    if(campaignsChosen.contains(camp.id)){
                                      campaignsChosen.remove(camp.id);
                                      totalAmount = totalAmount! + amount;
                                      promoSum = promoSum + amount;
                                    } else {
                                      campaignsChosen.add(camp.id);
                                      totalAmount = totalAmount! - amount;
                                      promoSum = promoSum - amount;
                                    }
                                  }
                                  
                                  setState(() {});
                                }
                              );
                            }
                          ),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: kSouthSeas.withOpacity(0.3),
            padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Text("Montant de la couverture annuelle", style: TextStyle(color: kCardTextColor, fontSize: 16, fontWeight: FontWeight.bold),)),
                    SizedBox(width: wv*2,),
                    Text("$totalAmount FCFA", style: TextStyle(color: kTextBlue, fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                ),
                Divider(color: kPrimaryColor, height: hv*2.5,),
                Row(
                  children: [
                    Expanded(child: Text("Montant couverture choisie", style: TextStyle(color: kTextBlue, fontSize: 16),)),
                    SizedBox(width: wv*2,),
                    Text("$amountToPay FCFA", style: TextStyle(color: kTextBlue, fontSize: 16))
                  ],
                ),
                payInscription && widget.invoice?.registrationPaid != true ? Row(
                  children: [
                    Expanded(child: Text("Montant de l'inscription", style: TextStyle(color: kTextBlue, fontSize: 16),)),
                    SizedBox(width: wv*2,),
                    Text(widget.invoice?.inscriptionId != null ? "$registrationFee FCFA" : "Déjà payée", style: TextStyle(color: kTextBlue, fontSize: 16))
                  ],
                ) : Container(),
                Row(
                  children: [
                    Text("Montant à payer", style: TextStyle(color: kTextBlue, fontSize: 16, fontWeight: FontWeight.bold),),
                    Spacer(),
                    Text("${amountToPay + registrationFee! + 250} FCFA", style: TextStyle(color: kTextBlue, fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(height: hv*2,),
                CustomTextButton(
                  text: "Payer",
                  noPadding: true,
                  isLoading: spinner,
                  action: (){
                    print("Montant à payer $amountToPay \n");
                    print("startCov ${start?.toLocal()} \n");
                    print("endCov ${end.toLocal()} \n");
                    print("months covered $months \n");
                    print(campaignsChosen);
                    pay(amount: amountToPay + registrationFee! + 250, invoice: widget.invoice);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  static const platform = const MethodChannel('danaidproject.sendmoney');

  Future<String> makePayment({num? cost, bool? isOrange}) async {
    String amount = cost.toString();
    String operator = isOrange! ? 'moneyTransferOrangeAction' : 'moneyTransferMTNAction';
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

  pay({num? amount, InvoiceModel? invoice}){
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
                    onTap: (){processPayment(amount: amount!, invoice: invoice!, isOrange: true);}
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
                  onTap: () {processPayment(amount: amount!, invoice: invoice!, isOrange: false);},
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  processPayment({num? amount, InvoiceModel? invoice, bool? isOrange}) async {
    DateTime? invStart = widget.invoice?.coverageStartDate?.toDate();
    DateTime? invEnd = widget.invoice?.coverageEndDate?.toDate();
    DateTime? invPaidStart = widget.invoice?.currentPaidStartDate?.toDate();
    DateTime? invPaidEnd = widget.invoice?.currentPaidEndDate?.toDate();
    amountPerMonth = totalAmount!/12;
    num amountToPay = (months! * amountPerMonth!).round();
    DateTime? start = invPaidEnd == null ? invStart : invPaidEnd.add(Duration(days: 1));
    DateTime? end = invPaidEnd == null ? invStart?.add(Duration(days: months!*30)) : invPaidEnd.add(Duration(days: months!*30));
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);

    int? monthPaid = widget.?invoice?.monthsPaid == null ? 0 : widget.invoice?.monthsPaid;

    bool campOn = widget.invoice?.campaignsChosen == null ? false : widget.invoice!.campaignsChosen!.isEmpty ? false : true;

    String res = await makePayment(cost: amount, isOrange: isOrange);
    if(res == "SUCCESS"){
      try {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Paiement éffectué",)));
        if(widget.invoice?.inscriptionId != null){
          if(payInscription){
            FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent?.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(widget.invoice?.inscriptionId).update({
              "paymentDate": DateTime.now(),
              "montantPayee": registrationFee,
              "promos": FieldValue.arrayUnion(campaignsChosen),
              "paid": true,
              "etatValider": true
            });
          }
        }
        FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent?.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(widget.invoice?.id).update({
          "paymentDate": DateTime.now(),
          "montantPayee": FieldValue.increment(amount!-registrationFee!),
          "moisPayee": FieldValue.increment(months!),
          "registrationPaid": payInscription && widget.invoice?.inscriptionId != null ? true : false,
          "currentPaidStartDate": start,
          "currentPaidEndDate": end,
          "promos": FieldValue.arrayUnion(campaignsChosen),
          "invoiceIsSplitted": true,
          "paid": monthPaid! + months! == 12 ? true : false,
          "etatValider": monthPaid + months! == 12 ? true : false,
          "montant": campOn ? widget.invoice?.amount : widget.invoice!.amount! - promoSum,
          "paymentDates": FieldValue.arrayUnion([{"date" : DateTime.now(), "amount": amount-registrationFee!}]),
        }).then((value) async {
          setState(() {});
          FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent?.adherentId).update({
            //"datDebutvalidite" : start,
            "havePaidBefore": true,
            "paymentDate": DateTime.now(),
            "datFinvalidite": end,
            "paid": true,
          });

          Navigator.pop(context);
          Navigator.pop(context);       
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