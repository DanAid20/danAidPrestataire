import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/danAid_default_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';

class AdherentPlanScreen extends StatelessWidget {
  final String _mPackage = 'Découverte';
  final String _mPackageAmount = '00';
  final String _mPackageContent = 'Réseau de santé';
  final String _mPackageContent1 = 'Changer de plan';
  final String _mPackageContent2 = 'Ajout d\'un bénéficiaire';
  final _mSize = SizeConfig.defaultSize;
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    AdherentProvider adherentProvider = Provider.of<AdherentProvider>(context, listen: false);
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
                  title: Text("Choisir un niveau de services", style: TextStyle(color: Colors.white, fontSize: wv*5, fontWeight: FontWeight.bold), overflow: TextOverflow.fade,),
                ),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: hv*65,
                          enlargeCenterPage: true,
                          viewportFraction: .6,
                        ),
                        items: [
                          PackageCard(
                              mPackage: _mPackage,
                              mPackageAmount: _mPackageAmount,
                              mPackageContent: _mPackageContent,
                              mPackageContent1: _mPackageContent1,
                              mPackageContent2: _mPackageContent2,
                              titleColor: kSouthSeas,
                              content: "Accédez au réseau DanAid et gagnez des points que vous pourrez utiliser pour vous soigner",
                              level: "0",
                              iconUrl: 'assets/icons/Bulk/Shield Done.svg',
                              mSize: _mSize,
                              action: (){
                                adherentProvider.setAdherentPlan(0);
                                adherentProvider.setProfileEnableState(false);
                                Navigator.pushNamed(context, '/adherent-reg-form');
                              }
                              ),
                          PackageCard(
                              mPackage: 'Accès',
                              mPackageAmount: "3,500",
                              mPackageContent: "Couverture santé à 70%",
                              mPackageContent1: "Médécin de famille",
                              mPackageContent2: "Plafond de 350.000 XAF",
                              mSize: _mSize,
                              titleColor: kGold,
                              content: "Niveau Découverte\n+ couverture à 70% des frais\n+ Plafond de soins à 350.000 Cfa/an",
                              level: "I",
                              iconUrl: 'assets/icons/Bulk/Shield Done.svg',
                              action: (){
                                adherentProvider.setAdherentPlan(1);
                                adherentProvider.setProfileEnableState(false);
                                Navigator.pushNamed(context, '/adherent-reg-form');
                              }),
                          PackageCard(
                              mPackage: "Assist",
                              mPackageAmount: "6,500",
                              mPackageContent: "Couverture santé à 70%",
                              mPackageContent1: "Médécin de famille",
                              mPackageContent2: "Plafond de 650.000 XAF",
                              mSize: _mSize,
                              titleColor: kGold,
                              content: "Niveau Découverte\n+ couverture à 70% des frais\n+ Plafond de soins à 650.000 Cfa/an",
                              level: "II",
                              iconUrl: 'assets/icons/Bulk/Shield Done.svg',
                              action: (){
                                adherentProvider.setAdherentPlan(2);
                                adherentProvider.setProfileEnableState(false);
                                Navigator.pushNamed(context, '/adherent-reg-form');
                              }),
                          PackageCard(
                              mPackage: 'Sérénité',
                              mPackageAmount: "9,500",
                              mPackageContent: "Couverture santé à 70%",
                              mPackageContent1: "Médécin de famille",
                              mPackageContent2: "Plafond de 1.000.000 XAF",
                              mSize: _mSize,
                              titleColor: kGold,
                              content: "Niveau Découverte\n+ couverture à 70% des frais\n+ Plafond de soins à 1.000.000 Cfa/an",
                              level: "III",
                              iconUrl: 'assets/icons/Bulk/Shield Done.svg',
                              action: (){
                                adherentProvider.setAdherentPlan(3);
                                adherentProvider.setProfileEnableState(false);
                                Navigator.pushNamed(context, '/adherent-reg-form');
                              }),
                        ],
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
      width: width(size: 250),
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
          Align(child: Text("  Niveau "+level, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: wv*4, fontWeight: FontWeight.bold)), alignment: Alignment.centerLeft,),
          
          SizedBox(height: hv*2,),
          RichText(text: TextSpan(text: _mPackageAmount, children: [TextSpan(text: " Cfa", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w300))], style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: wv*15))),
          SizedBox(height: hv*0.25),
          Text("par famille / Mois", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: wv*4),),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: hv*4),
                    padding: EdgeInsets.symmetric(horizontal: wv*2),
                    child: Text(content, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: wv*3.5, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: hv*1,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: wv*3),
            child: CustomTextButton(text: "Commencer", color: whiteColor, textColor: kPrimaryColor, action: action,),
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
