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
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
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
  final String currency = FlutterwaveCurrency.XAF;
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

  init() async {

    
    months = (widget.invoice?.monthsPaid == null ? 12 : 12 - widget.invoice!.monthsPaid!) as int?;
    maxMonths = months!;
    totalAmount = widget.invoice!.amount!;
    registrationFee = widget.invoice?.inscriptionId == null || widget.invoice?.registrationPaid == true ? 0 : widget.regFee;

    setState(() {});

    await Future.delayed(const Duration(milliseconds: 200));
    showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
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
                    Icon(LineIcons.timesCircle, color: kDeepTeal, size: 70,),
                    SizedBox(height: hv*2,),
                    Text("Méthode de paiement en cours de révision", style: TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
                    SizedBox(height: hv*2,),
                    Text("Il sera disponible dans la prochaine mise à jour sous une forme ameliorée, plus flexible et plus sécurisée", style: TextStyle(color: Colors.grey[600], fontSize: 18), textAlign: TextAlign.center),
                    SizedBox(height: hv*2),
                    CustomTextButton(
                      text: "OK",
                      color: kDeepTeal,
                      action: (){Navigator.pop(context); Navigator.pop(context);},
                    )
                    
                  ], mainAxisAlignment: MainAxisAlignment.center, ),
                ),
              ],
            ),
          ),
        );
      }
    );
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
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index){
                              CampaignModel camp = CampaignModel.fromDocument(snapshot.data!.docs[index], snapshot.data!.docs[index].data() as Map);
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
                                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ce code promo a déjà expiré..."), backgroundColor: Colors.red,));
                                                                  _codeController.clear();
                                                                  Navigator.pop(context);
                                                                }
                                                              } else {
                                                                _codeController.clear();
                                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Le code promo est incorrecte")));
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
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Seuls les adhérents s'étant inscrit par lien d'invitation peuvent utiliser un code promo")));
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
                  action: () async {
                    print("Montant à payer $amountToPay \n");
                    print("startCov ${start?.toLocal()} \n");
                    print("endCov ${end.toLocal()} \n");
                    print("months covered $months \n");
                    print(campaignsChosen);
                    num? monthPaid = widget.invoice?.monthsPaid ?? 0;
                    bool campOn = widget.invoice?.campaignsChosen == null ? false : widget.invoice!.campaignsChosen!.isEmpty ? false : true;
                    //pay(amount: amountToPay + registrationFee! + 250, invoice: widget.invoice);
                    
              //setState(() {spinner2 = true;});
                    String currency = FlutterwaveCurrency.XAF;
                    String txref = adherentProvider.getAdherent!.adherentId.toString() + "_" + DateTime.now().toString();
                    num total = amountToPay + registrationFee! + 250;
                    num amount = total;
                    final Flutterwave flutterwave = Flutterwave.forUIPayment(
                        context: this.context,
                        encryptionKey: "90ca704f5c5cef5382cc73a5",
                        publicKey: "FLWPUBK-89f133d0d410d4b2bb10007de429ea41-X",
                        currency: currency,
                        amount: total.toString(),
                        email: adherentProvider.getAdherent?.email != null ? adherentProvider.getAdherent!.email! : "info@danaid.org",
                        fullName: adherentProvider.getAdherent!.familyName.toString(),
                        txRef: txref,
                        isDebugMode: false,
                        phoneNumber: adherentProvider.getAdherent!.adherentId!.substring(1),
                        acceptCardPayment: true,
                        acceptUSSDPayment: false,
                        acceptAccountPayment: false,
                        acceptFrancophoneMobileMoney: true,
                        acceptGhanaPayment: false,
                        acceptMpesaPayment: false,
                        acceptRwandaMoneyPayment: false,
                        acceptUgandaPayment: false,
                        acceptZambiaPayment: false);
                
                    try {
                      final ChargeResponse response = await flutterwave.initializeForUiPayments();
                      if (response == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transaction intérrompue..",)));
                      } else {
                        final isSuccessful = checkPaymentIsSuccessful(response, total.toString(), txref);
                        if (isSuccessful) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transaction réussie..",)));
                          print("Paiement effectué");
                          try {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Paiement éffectué",)));
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
                              "montantPayee": FieldValue.increment(amount-registrationFee!),
                              "moisPayee": FieldValue.increment(months!),
                              "registrationPaid": payInscription && widget.invoice?.inscriptionId != null ? true : false,
                              "currentPaidStartDate": start,
                              "currentPaidEndDate": end,
                              "promos": FieldValue.arrayUnion(campaignsChosen),
                              "invoiceIsSplitted": true,
                              "paid": monthPaid + months! == 12 ? true : false,
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
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mise à jour des statuts éffectué",)));

                            });
                          }
                          catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),)));
                          }
                          // provide value to customer
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${response.message}",)));
                          print(response.message); print(response.status); print(response.data!.processorResponse);
                        }
                      }
                    } catch (error, stacktrace) {
                      // handleError(error);
                    }
                  
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  bool checkPaymentIsSuccessful(final ChargeResponse response, String amount, String txref) {
    return response.data!.status == FlutterwaveConstants.SUCCESSFUL && response.data!.currency == this.currency && response.data!.amount == amount && response.data!.txRef == txref;
  }

  Future<String> makePayment({num? cost, bool? isOrange}) async {
    return "FAILED";
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

    num? monthPaid = widget.invoice?.monthsPaid ?? 0;

    bool campOn = widget.invoice?.campaignsChosen == null ? false : widget.invoice!.campaignsChosen!.isEmpty ? false : true;

    String res = await makePayment(cost: amount, isOrange: isOrange);
    if(res == "SUCCESS"){
      try {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Paiement éffectué",)));
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
          "paid": monthPaid + months! == 12 ? true : false,
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mise à jour des statuts éffectué",)));

        });
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),)));
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Une erreur de paiement est survenue..",)));
    }
  }
}