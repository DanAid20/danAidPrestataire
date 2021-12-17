import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/planModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/planModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/danAid_default_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
class AdherentPlanScreen extends StatefulWidget {
  @override
  _AdherentPlanScreenState createState() => _AdherentPlanScreenState();
}

class _AdherentPlanScreenState extends State<AdherentPlanScreen> {
  
  final String _mPackage = 'Découverte';
  final String _mPackageAmount = '00';
  final String _mPackageContent = 'Réseau de santé';
  final String _mPackageContent1 = 'Changer de plan';
  final String _mPackageContent2 = 'Ajout d\'un bénéficiaire';

  final _mSize = SizeConfig.defaultSize;
  
  /*getPlans() async {

    await FirebaseFirestore.instance.collection("SERVICES_LEVEL_CONFIGURATION").get().then((snap) {
      var docs = snap.docs;
      for(int i = 0; i < docs.length; i++){
        PlanModel docModel = PlanModel.fromDocument(docs[i]);
        plans[docModel.planNumber] = docModel;
      }
      setState(() {
        currentPlan = plans[adherentProvider.getAdherent.adherentPlan];
        state = adherentProvider.getAdherent.adherentPlan;
      });
    });
  }

  @override
  void initState() {
    getPlans();
    super.initState();
  }*/
  @override
  Widget build(BuildContext context) {

    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    PlanModelProvider planProvider = Provider.of<PlanModelProvider>(context, listen: false);
    
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Container(
            child: Column(
              children: [
                DanAidDefaultHeader(
                  title: Text(S.of(context).choisirUnNiveauDeServices
                    , style: TextStyle(color: Colors.white, fontSize: wv*5, fontWeight: FontWeight.bold), overflow: TextOverflow.fade,),
                ),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("SERVICES_LEVEL_CONFIGURATION").snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          List<Widget> plans = [];
                          for (int i = 0; i < snapshot.data.docs.length; i++){
                            DocumentSnapshot doc = snapshot.data.docs[i];
                            PlanModel plan = PlanModel.fromDocument(doc);
                            Widget content = PackageCard(
                              mPackage: plan.label,
                              mPackageAmount: plan.monthlyAmount.toString(),
                              mPackageContent: S.of(context).couvertureSant+" ${plan.coveragePercentage}%",
                              mPackageContent1: S.of(context).mdcinDeFamille,
                              mPackageContent2: S.of(context).plafondDe+" ${plan.annualLimit} XAF",
                              mSize: _mSize,
                              titleColor: plan.planNumber == 0 ? kGold : kSouthSeas,
                              content: S.of(context).niveau+" ${plan.label}\n+ "+S.of(context).couverture+" ${plan.coveragePercentage}% "+S.of(context).desFraisnPlafondDeSoins+" ${plan.annualLimit}Cfa/an",
                              level: plan.planNumber.toString(),
                              iconUrl: plan.planNumber == 0 ? 'assets/icons/Bulk/HeartOutline.svg' : plan.planNumber == 1 ? 'assets/icons/Bulk/ShieldAcces.svg' : plan.planNumber == 2 ? 'assets/icons/Bulk/ShieldAssist.svg' :plan.planNumber == 3 ? 'assets/icons/Bulk/ShieldSerenity.svg' : 'assets/icons/Bulk/Shield Done.svg',
                              action: (){
                                adherentProvider.setAdherentModel(AdherentModel());
                                adherentProvider.setAdherentPlan(plan.planNumber);
                                adherentProvider.setAnnualCoverageLimit(plan.annualLimit);
                                planProvider.setPlanModel(plan);
                                adherentProvider.setProfileEnableState(false);
                                Navigator.pushNamed(context, '/adherent-reg-form');
                              });
                            plans.add(content);
                          }
                          return CarouselSlider(
                            options: CarouselOptions(
                              height: hv*65,
                              enlargeCenterPage: true,
                              viewportFraction: .7,
                            ),
                            items: plans,
                          );
                        }
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PackageCard extends StatelessWidget {
  const PackageCard({
    Key key,
    @required String mPackage,
    @required String mPackageAmount,
    @required String mPackageContent,
    @required String mPackageContent1,
    @required String mPackageContent2,
    @required double mSize,
    this.action, this.titleColor, this.iconUrl, this.level, this.content,
  })  : _mPackage = mPackage,
        _mPackageAmount = mPackageAmount,
        _mPackageContent = mPackageContent,
        _mPackageContent1 = mPackageContent1,
        _mPackageContent2 = mPackageContent2,
        _mSize = mSize,
        super(key: key);

  final String _mPackage;
  final String _mPackageAmount;
  final String _mPackageContent;
  final String _mPackageContent1;
  final String _mPackageContent2;
  final String content;
  final String level;
  final Color titleColor;
  final String iconUrl;
  final double _mSize;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(size: 180),
      width: wv*70,
      //padding: EdgeInsets.symmetric(horizontal: horizontal(size: 20)),
      margin: EdgeInsets.symmetric(horizontal: horizontal(size: 5), vertical: vertical(size: 5)),
      decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [ BoxShadow(offset: Offset(1.0, 1.0),blurRadius: 4.2,spreadRadius: .2,color: kBgColor.withOpacity(.3))]),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: wv*1.5, vertical: hv*1),
            decoration: BoxDecoration(
              color: titleColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
            ),
            width: double.infinity,
            child: Column(children: [
              SvgPicture.asset(iconUrl, color: Colors.white, width: wv*10,),
              Text(_mPackage, style: TextStyle(fontSize: hv*5, fontWeight: FontWeight.w600, color: Colors.white), ),
            ],),
          ),
          SizedBox(height: 5,),
          Align(child: Text(" "+S.of(context).niveau+" "+level, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: wv*4, fontWeight: FontWeight.bold)), alignment: Alignment.centerLeft,),
          
          SizedBox(height: hv*2,),
          RichText(text: TextSpan(text: level == "0" ? "00" : _mPackageAmount, children: [TextSpan(text: " Cfa", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w300))], style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: wv*15))),
          SizedBox(height: hv*0.25),
          Text(level == "1.1" ? "par Etudiant/an" : S.of(context).parFamilleMois, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: wv*4),),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: hv*4),
                    padding: EdgeInsets.symmetric(horizontal: wv*5),
                    child: Text(content, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: wv*3.5, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: hv*1,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: wv*3),
            child: CustomTextButton(text: S.of(context).commencer, color: whiteColor, textColor: kPrimaryColor, action: action,),
          ),
          SizedBox(height: hv*1,)
        ],
      ),
    );
  }
}

class PackageWidget extends StatelessWidget {
  const PackageWidget({
    Key key,
    @required String mPackageContent,
  })  : _mPackageContent = mPackageContent,
        super(key: key);

  final String _mPackageContent;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        _mPackageContent,
        softWrap: true,
        style: TextStyle(
            color: whiteColor,
            letterSpacing: .7,
            height: 1.5,
            fontWeight: FontWeight.w800,
            fontSize: fontSize(size: 14)),
      ),
    );
  }
}

class PackageName extends StatelessWidget {
  const PackageName({
    Key key,
    @required String mPackage,
    this.size,
    this.strokeWidth,
  })  : _mPackage = mPackage,
        super(key: key);

  final String _mPackage;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          _mPackage.toUpperCase(),
          softWrap: true,
          style: TextStyle(
              fontSize: fontSize(size: size ?? 25),
              fontWeight: FontWeight.w600,
              letterSpacing: .5,
              foreground: Paint()
                ..color = kPrimaryColor
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth ?? 3,
              shadows: [
                BoxShadow(
                    offset: Offset(0, 2), blurRadius: 5, color: whiteColor)
              ]),
        ),
        Text(
          _mPackage.toUpperCase(),
          softWrap: true,
          style: TextStyle(
              fontSize: fontSize(size: size ?? 25),
              fontWeight: FontWeight.w600,
              letterSpacing: .5,
              foreground: Paint()
                ..color = whiteColor
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth ?? 3
                ..strokeCap),
        ),
      ],
    );
  }
}
