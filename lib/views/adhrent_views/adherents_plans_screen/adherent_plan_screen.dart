import 'package:carousel_slider/carousel_slider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';

class AdherentPlanScreen extends StatelessWidget {
  final String _mPackage = 'découverte';
  final String _mPackageAmount = '0';
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
                Expanded(
                  flex: 2,
                  child: Container(
                    color: kPrimaryColor,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Image.asset(
                              'assets/images/pricing.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontal(size: 25)),
                            child: Text(
                              'Le profil adhérent possède plusieurs packages choissez '
                              'celui qui vous convient le mieux et profitez-en.',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: fontSize(size: 17),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: .70,
                                  height: 1.4),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                      decoration: BoxDecoration(),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: height(size: 500),
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
                              mSize: _mSize,
                              action: (){
                                adherentProvider.setAdherentPlan(0);
                                adherentProvider.setProfileEnableState(false);
                                Navigator.pushNamed(context, '/adherent-reg-form');
                              }
                              ),
                          PackageCard(
                              mPackage: 'Accès',
                              mPackageAmount: "3500",
                              mPackageContent: "Couverture santé à 70%",
                              mPackageContent1: "Médécin de famille",
                              mPackageContent2: "Plafond de 350.000 XAF",
                              mSize: _mSize,
                              action: (){
                                adherentProvider.setAdherentPlan(1);
                                adherentProvider.setProfileEnableState(false);
                                Navigator.pushNamed(context, '/adherent-reg-form');
                              }),
                          PackageCard(
                              mPackage: "Assist",
                              mPackageAmount: "6500",
                              mPackageContent: "Couverture santé à 70%",
                              mPackageContent1: "Médécin de famille",
                              mPackageContent2: "Plafond de 650.000 XAF",
                              mSize: _mSize,
                              action: (){
                                adherentProvider.setAdherentPlan(2);
                                adherentProvider.setProfileEnableState(false);
                                Navigator.pushNamed(context, '/adherent-reg-form');
                              }),
                          PackageCard(
                              mPackage: 'Sérénité',
                              mPackageAmount: "9500",
                              mPackageContent: "Couverture santé à 70%",
                              mPackageContent1: "Médécin de famille",
                              mPackageContent2: "Plafond de 1.000.000 XAF",
                              mSize: _mSize,
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
    this.action,
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
  final double _mSize;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(size: 180),
      width: width(size: 250),
      padding: EdgeInsets.symmetric(horizontal: horizontal(size: 20)),
      margin: EdgeInsets.symmetric(
          horizontal: horizontal(size: 10), vertical: vertical(size: 5)),
      decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 4.2,
                spreadRadius: .2,
                color: kBgColor.withOpacity(.3))
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VerticalSpacing(of: 15),
          PackageName(
            mPackage: _mPackage,
            strokeWidth: 1.1,
          ),
          VerticalSpacing(of: 20),
          PackageName(
            mPackage: _mPackageAmount,
            size: 70,
          ),
          VerticalSpacing(of: 20),
          PackageName(
            mPackage: 'cfa',
            size: 17,
            strokeWidth: 1,
          ),
          VerticalSpacing(of: 20),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  PackageWidget(mPackageContent: _mPackageContent),
                  PackageWidget(mPackageContent: _mPackageContent1),
                  PackageWidget(mPackageContent: _mPackageContent2),
                ],
              ),
            ),
          ),
          VerticalSpacing(of: 20),
          Flexible(
            child: ButtonTheme(
              minWidth: width(size: _mSize * 20),
              height: height(size: _mSize * 5.5),
              child: RaisedButton(
                child: Text(
                  'COMMENCEZ',
                  softWrap: true,
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .7,
                      fontSize: fontSize(size: 18)),
                ),
                color: whiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_mSize * 3.15)),
                onPressed: action,
              ),
            ),
          ),
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
