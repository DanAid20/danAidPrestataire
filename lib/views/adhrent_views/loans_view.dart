import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/loanModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/loanModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/drawer.dart';
import 'package:danaid/widgets/advantage_card.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class Loans extends StatefulWidget {
  @override
  _LoansState createState() => _LoansState();
}

class _LoansState extends State<Loans> with TickerProviderStateMixin {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _loanTabController;
  TextEditingController _amountController = new TextEditingController();
  final currency = new NumberFormat("#,##0", "en_US");

  checkIfBeneficiary() async {
    await Future.delayed(Duration(seconds: 1));
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if(userProvider.getUserModel.profileType == beneficiary){
      Navigator.pop(context);
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
                    Icon(LineIcons.times, color: Colors.red, size: 45,),
                    SizedBox(height: hv*2,),
                    Text("Accès restreint", style: TextStyle(color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.w700),),
                    SizedBox(height: hv*2,),
                    Text("Seul l'adhérent principale peux éffectuer un prêt..", style: TextStyle(color: Colors.grey[600], fontSize: wv*4), textAlign: TextAlign.center),
                    SizedBox(height: hv*2),
                    CustomTextButton(
                      text: "OK",
                      color: kPrimaryColor,
                      action: ()=>Navigator.pop(context),
                    )
                    
                  ], mainAxisAlignment: MainAxisAlignment.center, ),
                ),
              ],
            ),
          );
        }
      );
    }
  }

  @override
  void initState() {
    _loanTabController = new TabController(length: 2, vsync: this);
    // TODO: implement initState
    super.initState();
    checkIfBeneficiary();
  }
  
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    LoanModelProvider loanProvider = Provider.of<LoanModelProvider>(context);
    AdherentModel adh = adherentProvider.getAdherent;

    bool enable = userProvider.getUserModel.enable == null ? false : userProvider.getUserModel.enable;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,),
          onPressed: ()=>Navigator.pop(context)
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(S.of(context).aperuDeMonPrtSant, style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
            Text(S.of(context).ajouterModifierOuEnvoyerLesPices, 
              style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          //IconButton(icon: SvgPicture.asset('assets/icons/Two-tone/InfoSquare.svg', color: kSouthSeas,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: hv*2),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: hv*11),
                        padding: EdgeInsets.only(bottom: hv*9),
                        decoration: BoxDecoration(
                          color: kBrownCanyon.withOpacity(0.3),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                        ),
                        child: HomePageComponents.header(title: adh.surname + " " + adh.familyName, subtitle: adh.address.toString(), avatarUrl: adh.imgUrl),
                      ),
                      Positioned(
                        top: hv*5.5,
                        child: Hero(
                          tag: "loanCard",
                          child: AdvantageCard(
                            label: S.of(context).prtDeSant,
                            description: S.of(context).maximumDisponible,
                            state: S.of(context).disponible,
                            price: adh.loanLimit == null ? "### f." : "#${currency.format(adh.loanLimit)} f.",
                            showLogo: true,
                            color: Colors.brown.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: wv*90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*0.5),
                          decoration: BoxDecoration(
                            color: kSouthSeas,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text(S.of(context).rapide, style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(width: wv*5,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*0.5),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text(S.of(context).pourTous, style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(width: wv*5,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*0.5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text(S.of(context).simple, style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: hv*2,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(width: wv*3,),
                      Expanded(
                        flex: 6,
                        child: CustomTextField(
                          label: S.of(context).jeSouhaiteEmprunter,
                          noPadding: true,
                          hintText: S.of(context).entrerLeMontant,
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$')),
                          ],
                          onChanged: (val)=>setState((){}),
                        ),
                      ),
                      SizedBox(width: wv*3,),
                      Expanded(
                        flex: 5,
                        child: CustomTextButton(
                          noPadding: true,
                          expand: false,
                          enable: _amountController.text.isNotEmpty && enable == true,
                          fontSize: 14,
                          borderRadius: 20,
                          text: S.of(context).dmanderUnCrdit,
                          action: (){
                            num amount = num.parse(_amountController.text);
                            num maxAmount =  adh.loanLimit;
                            if(amount > maxAmount){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).dsolVotrePlanActuelNeVousPermetPasDemprunterPlus+maxAmount.toString()+' f.'),));
                            }
                            else{
                              //loanProvider.setAmount(double.parse(_amountController.text));
                              loanProvider.setLoanModel(LoanModel(amount: num.parse(_amountController.text), maxAmount: maxAmount));
                              //loanProvider.setMaxAmount(maxAmount);
                              Navigator.pushNamed(context, '/loan-form');
                            }
                          },
                        ),
                      ),
                      SizedBox(width: wv*3,)
                    ],
                  ),
                  SizedBox(height: hv*1.5,)
                ],
              ),
            ),
            SizedBox(height: hv*2.5,),
            enable ? HomePageComponents.getInfoActionCard(
              icon: SvgPicture.asset('assets/icons/Two-tone/Monochrome.svg'),
              title: S.of(context).emprunterCoteDeLargent,
              subtitle: S.of(context).unCrditVousEngageEtDoitTreRemboursVrifiezVos,
              actionLabel: S.of(context).faq,
              action: (){}
            ) :  Container(),
            !enable ? Container(
              padding: EdgeInsets.symmetric(vertical: hv*1),
              child: HomePageComponents.getInfoActionCard(
                title: S.of(context).completezDabordVotreProfil,
                subtitle: S.of(context).fournirLesInformationsEtPicesDmandesPourPouvoirEmprunter,
                actionLabel: S.of(context).complterMonProfil,
                action: ()=>Navigator.pushNamed(context, '/adherent-profile-edit')
              ),
            ) : Container(),
            adherentProvider.getAdherent.adherentPlan == 0 ? Container(
              padding: EdgeInsets.symmetric(vertical: hv*1),
              child: HomePageComponents.getInfoActionCard(
                title: S.of(context).vousTesAuNiveau0+S.of(context).dcouverte,
                subtitle: S.of(context).vousDevezRferer3AmisConnaissancesPourPouvoirEmprunter,
                actionLabel: S.of(context).inviterDesAmis,
                action: (){}
              ),
            ) : Container(),
            SizedBox(height: hv*2.5,),
            Container(
              decoration: BoxDecoration(
                color: whiteColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: hv*2,),
                  Text(S.of(context).statutDesEmprunts, style: TextStyle(color: kPrimaryColor, fontSize: 16),),
                  SizedBox(height: hv*2,),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.only(left: wv*3),
                          child: TabBar(
                            controller: _loanTabController,
                            indicatorWeight: 5,
                            indicatorColor: kPrimaryColor,
                            isScrollable: true,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            labelColor: kPrimaryColor,
                            tabs: [
                              Tab(text: S.of(context).enCours),
                              Tab(text: S.of(context).achevs),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: hv*50,
                        child: TabBarView(
                          controller: _loanTabController,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: hv*2),
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance.collection("CREDITS").where('adherentId', isEqualTo: adherentProvider.getAdherent.adherentId).where('status', isEqualTo: 0).orderBy('createdDate', descending: true).snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                                      ),
                                    );
                                  }
                                  return snapshot.data.docs.length >= 1
                                    ? ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          int lastIndex = snapshot.data.docs.length - 1;
                                          DocumentSnapshot loanDoc = snapshot.data.docs[index];
                                          LoanModel loan = LoanModel.fromDocument(loanDoc);
                                          print("name: ");
                                          return Padding(
                                            padding: EdgeInsets.only(bottom: lastIndex == index ? hv * 5 : 0),
                                            child: HomePageComponents.getLoanTile(
                                              label: "hhgfhfghfh",
                                              subtitle: loan.purpose,
                                              date: loan.dateCreated.toDate(),
                                              firstDate: loan.firstPaymentDate.toDate(),
                                              lastDate: loan.lastPaymentDate.toDate(),
                                              mensuality: loan.amount.toInt(),
                                              type: "gfg",
                                              state: loan.status,
                                              action: (){
                                                LoanModelProvider loanProvider = Provider.of<LoanModelProvider>(context, listen: false);
                                                loanProvider.setLoanModel(loan);
                                                Navigator.pushNamed(context, '/loan-details');
                                              }
                                            ),
                                          );
                                        })
                                    : Center(
                                      child: Container(padding: EdgeInsets.only(bottom: hv*4),child: Text(S.of(context).aucuneDemandeDeCrditEnrgistrenpourLeMoment, textAlign: TextAlign.center)),
                                    );
                                }
                              ),
                            ),
                            Container(),
                          ],
                        ),
                      )
                    ],
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