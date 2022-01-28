import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/planModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/models/invoiceModel.dart';
import 'package:danaid/core/providers/invoiceModelProvider.dart';
import 'package:danaid/core/providers/planModelProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/adhrent_views/invoiceSplit.dart';
import 'package:danaid/views/adhrent_views/paymentCart.dart';
import 'package:danaid/views/adhrent_views/subCoveragePayment.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
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

  InvoiceModel? latestInvoice;

  init() async {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).collection('NEW_FACTURATIONS_ADHERENT').where('categoriePaiement', isEqualTo: "COTISATION_ANNUELLE").get().then((query) {
      DateTime witness = DateTime(2000);
      for(int i = 0; i < query.docs.length; i++){
        InvoiceModel model = InvoiceModel.fromDocument(query.docs[i]);
        if(model.coverageStartDate!.toDate().isAfter(witness)){
          witness = model.coverageStartDate!.toDate();
          latestInvoice = model;
          setState(() { });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }
  @override
  Widget build(BuildContext context) {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    InvoiceModelProvider invoiceProvider = Provider.of<InvoiceModelProvider>(context);
    PlanModelProvider planProvider = Provider.of<PlanModelProvider>(context, listen: false);

    DateTime? limit = adherentProvider.getAdherent?.validityEndDate != null ? adherentProvider.getAdherent?.validityEndDate?.toDate() : null;
    String? limitString = limit != null ? limit.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(limit)+" "+ limit.year.toString() : null;
    String? inscriptionId;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,), 
          onPressed: ()=>Navigator.pop(context)
        ),
        title: Text(S.of(context)!.historiqueDesPaiements, style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
        centerTitle: true,
        actions: [
          //IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kSouthSeas,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: () => _scaffoldKey.currentState?.openEndDrawer())
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
            title: Algorithms.getPlanDescriptionText(plan: adherentProvider.getAdherent?.adherentPlan),
            actionLabel: S.of(context)!.comparerLesServices,
            subtitle: limitString != null ? S.of(context)!.vousTesCouvertsJusquau+limitString : "...",
            action: ()=>Navigator.pushNamed(context, '/compare-plans')
          ),
          SizedBox(height: hv*1,),
          latestInvoice != null ? Container(
            margin: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
            padding: EdgeInsets.symmetric(horizontal: wv*3.5, vertical: hv*2.25),
            decoration: BoxDecoration(
              color: kSouthSeas.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(child: Text("Côtisation de base", style: TextStyle(color: kCardTextColor, fontSize: 16),), width: wv*40,),
                    SizedBox(width: wv*2,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("1 X ${latestInvoice?.amount} f.", style: TextStyle(color: kCardTextColor, fontSize: 13)),
                          Text("Famille", style: TextStyle(color: kCardTextColor, fontSize: 13)),
                          Text("(1 à 5 personnes)", style: TextStyle(color: kCardTextColor, fontSize: 13)),
                        ],
                      ),
                    ),
                    SizedBox(width: wv*2,),
                    Text("${latestInvoice?.amount} f.", style: TextStyle(color: kCardTextColor, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: hv*1.5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(child: Text("Supplément", style: TextStyle(color: kCardTextColor, fontSize: 16),), width: wv*40,),
                    SizedBox(width: wv*2,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("0 X 15000 f.", style: TextStyle(color: kCardTextColor, fontSize: 13)),
                          Text("Personnes", style: TextStyle(color: kCardTextColor, fontSize: 13)),
                          Text("additionelles", style: TextStyle(color: kCardTextColor, fontSize: 13)),
                        ],
                      ),
                    ),
                    SizedBox(width: wv*2,),
                    Text("0 f.", style: TextStyle(color: kCardTextColor, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: hv*1.5),
                Divider(color: kSouthSeas, thickness: 3, height: hv*1.5,),
                Row(
                  children: [
                    Text("Total annuel", style: TextStyle(color: kCardTextColor, fontSize: 16)),
                    Spacer(),
                    Text("${latestInvoice?.amount} f.", style: TextStyle(color: kCardTextColor, fontSize: 16))
                  ],
                ),
                SizedBox(height: hv*0.5),
                Row(
                  children: [
                    Text("Payé", style: TextStyle(color: kDeepTeal, fontSize: 16, fontWeight: FontWeight.bold)),
                    Spacer(),
                    Text("${latestInvoice?.amountPaid != null ? latestInvoice?.amountPaid : 0} f.", style: TextStyle(color: kDeepTeal, fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(height: hv*1.5),
                Row(
                  children: [
                    Text("Reste à payer", style: TextStyle(color: kCardTextColor, fontSize: 18, fontWeight: FontWeight.bold)),
                    Spacer(),
                    Text("${latestInvoice?.amountPaid != null ? latestInvoice!.amount! - latestInvoice!.amountPaid! < 0 ? 0 : latestInvoice!.amount! - latestInvoice!.amountPaid! : latestInvoice!.amount} f.", style: TextStyle(color: kCardTextColor, fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
              ],
            ),
          ) : Container(),
          SizedBox(height: hv*1,),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*2),
              width: double.infinity,
              color: whiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context)!.mesDerniresFactures, style: TextStyle(color: kBlueDeep, fontSize: 16, fontWeight: FontWeight.w400)),
                  SizedBox(height: hv*2,),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).collection('NEW_FACTURATIONS_ADHERENT').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        );
                      }

                      return snapshot.data!.docs.length >= 1
                      ? Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot useCaseDoc = snapshot.data!.docs[index];
                              InvoiceModel invoice = InvoiceModel.fromDocument(useCaseDoc);
                              if(invoice.type == "INSCRIPTION"){
                                inscriptionId = invoice.id!;
                              }
                              print("name: ");
                              return getContributionTile(
                                label : invoice.trimester == null ? invoice.label : invoice.trimester, 
                                doctorName : "bdbd", 
                                date : DateTime.now(), 
                                amount: invoice.amount, 
                                firstDate : invoice.type == "INSCRIPTION" ? invoice.dateCreated!.toDate() : invoice.coverageStartDate!.toDate(), 
                                lastDate : invoice.paymentDelayDate != null ? invoice.paymentDelayDate!.toDate() : invoice.coverageEndDate!.toDate(),
                                paid: invoice.stateValidate == true ? 1 : invoice.paid == true && invoice.stateValidate == false ? 3 : invoice.paymentDelayDate != null ? invoice.paymentDelayDate!.toDate().compareTo(DateTime.now()) > 0 ? 2 : 0 : 2,
                                type : invoice.type, state : 0, 
                                action : () async {
                                  num regFee = 10000;
                                  if(invoice.type == "INSCRIPTION"){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vous devez sélectionner la côtisation pour payer l'inscription",)));
                                  }
                                  else if(invoice.stateValidate == true || invoice.paid == true){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Côtisation éffectuée",)));
                                  }
                                  else {
                                    await FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).collection('NEW_FACTURATIONS_ADHERENT').doc(invoice.inscriptionId).get().then((doc) {
                                      InvoiceModel regInvoice = InvoiceModel.fromDocument(doc);
                                      regFee = regInvoice.amount != null ? regInvoice.amount! : regFee;
                                    });
                                    if(invoice.invoiceIsSplitted == true){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentCart(invoice: invoice, regFee: regFee,),),);
                                    }
                                    else {
                                      showModalBottomSheet(
                                        context: context, 
                                        builder: (BuildContext bc){
                                          return SafeArea(
                                            child: Container(
                                              child: new Wrap(
                                                children: <Widget>[
                                                  ListTile(
                                                    contentPadding: EdgeInsets.symmetric(vertical: hv*0.75),
                                                    leading: SvgPicture.asset('assets/icons/Bulk/HeartOutline.svg', height: 30, color: kSouthSeas),
                                                    title: new Text('Payer en une fois', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600),),
                                                    subtitle: Text("Opérer un paiement unique pour votre couverture annuelle"),
                                                    onTap: () {
                                                      //Paiement unique
                                                      PlanModel plan = PlanModel(
                                                        id: inscriptionId,
                                                        monthlyAmount: invoice.amount,
                                                        label: invoice.label,
                                                        registrationFee: regFee,
                                                        text: {"titreNiveau": invoice.label}
                                                      );
                                                      planProvider.setPlanModel(plan);
                                                      invoiceProvider.setInvoiceModel(invoice);
                                                      Navigator.pushNamed(context, '/coverage-payment');
                                                  }),
                                                  ListTile(
                                                    contentPadding: EdgeInsets.symmetric(vertical: hv*0.75),
                                                    leading: SvgPicture.asset('assets/icons/Bulk/HeartOutline.svg', height: 30, color: kSouthSeas),
                                                    title: new Text('Segmenter la facture', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600),),
                                                    subtitle: Text("Des frais de gestion supplémentaires de 250FCFA s'appliqueront à chaque segmentation"),
                                                    onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentCart(invoice: invoice, regFee: regFee),),),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      );
                                    }
                                  }
                                }
                              );
                            }),
                      )
                      : Center(
                        child: Container(padding: EdgeInsets.only(top: hv*4),child: Text(S.of(context)!.aucuneCtisationEnrgistrePourLeMoment, textAlign: TextAlign.center)),
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

  Widget getContributionTile({String? label, String? doctorName, DateTime? date, num? amount, DateTime? firstDate, DateTime? lastDate, String? type, int? state, required int paid, Function? action}) {
    String lastDateString = lastDate!.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(lastDate)+" "+ firstDate!.year.toString();
    return GestureDetector(
      onTap: ()=>action,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: hv*0.5, horizontal: wv*2),
        padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey[200]!.withOpacity(0.8), blurRadius: 20.0, spreadRadius: 7.0, offset: Offset(0, 7))]
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type == "INSCRIPTION" ? S.of(context)!.inscription : S.of(context)!.ctisation, style: TextStyle(color: kDeepTeal, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(label!, style: TextStyle(color: kDeepTeal, fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.fade),
                SizedBox(height: hv*2,),
                Text(S.of(context)!.montant, style: TextStyle(color: kPrimaryColor, fontSize: 14)),
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
                      Center(child: Text(paid == 1 ? S.of(context)!.paye : paid == 2 ? S.of(context)!.enRetard : paid == 3 ? S.of(context)!.validationEnCours : S.of(context)!.enAttente, style: TextStyle(color: paid == 1 ? Colors.teal[500] : paid == 2 ? Colors.red : kGoldDeep, fontWeight: FontWeight.bold, fontSize: wv*3.5))),
                      SizedBox(height: hv*2,),
                      Text(S.of(context)!.dlaiDePaiement, style: TextStyle(color: kPrimaryColor, fontSize: 14)),
                      Text(lastDateString, style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold, decoration: paid == 1 ? TextDecoration.lineThrough : TextDecoration.none),),
                    ],
                  ),
                  paid != 1 ? SizedBox(width: wv*5,) : Container(),
                  Container(
                    padding: EdgeInsets.only(bottom: hv*3),
                    child: paid != 1 ? Column(
                      children: [
                        Center(child: SvgPicture.asset('assets/icons/Two-tone/Wallet.svg', width: wv*8,)),
                        Text(S.of(context)!.payer, style: TextStyle(color: kSouthSeas, fontWeight: FontWeight.bold, fontSize: 12)),
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