import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class ProfileTypeView extends StatefulWidget {
  @override
  _ProfileTypeViewState createState() => _ProfileTypeViewState();
}

class _ProfileTypeViewState extends State<ProfileTypeView> {
  final String _mProfileText = 'adhérent';
  final String _mProfileText2 = 'médécin';
  final String _mProfileText3 = 'partenaire';
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
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
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Image.asset(
                                'assets/images/profile-type.png',
                                fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontal(size: 25)
                            ),
                            child: Text(
                              'Choisissez votre profil sur Danaid et accéder à ces différentes offres',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: kBgColor,
                                  fontSize: fontSize(size: 17),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: .70,
                                  height: 1.4
                              ),
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
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withAlpha(50),
                    ),
                    child: ListView(
                      children: [
                        InkWell(
                          child: Container(
                            height: height(size: 180),
                            width: width(size: 250),
                            padding: EdgeInsets.symmetric(horizontal: horizontal(size: 20)),
                            margin: EdgeInsets.symmetric(horizontal: horizontal(size: 15), vertical: vertical(size: 15)),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 4.2,
                                  spreadRadius: .2,
                                  color: kBgColor.withOpacity(.3)
                                )
                              ]
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _mProfileText.toUpperCase(),
                                  softWrap: true,
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: fontSize(size: 22),
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                VerticalSpacing(of: 20),
                                Flexible(
                                  child: Text(
                                    'Est considéré comme adhérent de Danaid toutes personnes qui crée un compte sur l\'application '
                                        'Danaid et souscrit à un des packs que celui offre.',
                                    softWrap: true,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: kTextColor,
                                        fontSize: fontSize(size: 14),
                                        letterSpacing: .7,
                                        height: 1.4,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => _navigationService.navigateTo('/profile-type-adherent'),
                        ),
                        Container(
                          height: height(size: 180),
                          width: width(size: 250),
                          padding: EdgeInsets.symmetric(horizontal: horizontal(size: 20)),
                          margin: EdgeInsets.symmetric(horizontal: horizontal(size: 15), vertical: vertical(size: 15)),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 4.2,
                                    spreadRadius: .2,
                                    color: kBgColor.withOpacity(.3)
                                )
                              ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _mProfileText2.toUpperCase(),
                                softWrap: true,
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: fontSize(size: 22),
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              VerticalSpacing(of: 20),
                              Flexible(
                                child: Text(
                                  'Est considéré comme adhérent de Danaid toutes personnes qui crée un compte sur l\'application '
                                      'Danaid et souscrit à un des packs que celui offre.',
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: kTextColor,
                                      fontSize: fontSize(size: 14),
                                      letterSpacing: .7,
                                      height: 1.4,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: height(size: 180),
                          width: width(size: 250),
                          padding: EdgeInsets.symmetric(horizontal: horizontal(size: 20)),
                          margin: EdgeInsets.symmetric(horizontal: horizontal(size: 15), vertical: vertical(size: 15)),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 4.2,
                                    spreadRadius: .2,
                                    color: kBgColor.withOpacity(.3)
                                )
                              ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _mProfileText3.toUpperCase(),
                                softWrap: true,
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: fontSize(size: 22),
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              VerticalSpacing(of: 20),
                              Flexible(
                                child: Text(
                                  'Est considéré comme adhérent de Danaid toutes personnes qui crée un compte sur l\'application '
                                      'Danaid et souscrit à un des packs que celui offre.',
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: kTextColor,
                                      fontSize: fontSize(size: 14),
                                      letterSpacing: .7,
                                      height: 1.4,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
