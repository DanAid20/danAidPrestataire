import 'package:cached_network_image/cached_network_image.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/add_patient_views.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/owner_userList_View.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class InactiveAccount extends StatefulWidget {
  final AdherentModel data;
  final bool isAccountIsExists;
  final String phoneNumber;
  InactiveAccount(
      {Key key, this.data, this.isAccountIsExists, this.phoneNumber})
      : super(key: key);

  @override
  _InactiveAccountState createState() => _InactiveAccountState();
}

class _InactiveAccountState extends State<InactiveAccount> {
  bool isActive;
  AdherentModelProvider adherentModelProvider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isAccountIsExists == false) {
        await showDialog<String>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) =>
                _buildAboutDialog(context, true));
      }
    });
  }

  Widget _buildAboutDialog(BuildContext context, bool isIninitState) {
    adherentModelProvider = Provider.of<AdherentModelProvider>(context);
    AdherentModel adherent = adherentModelProvider.getAdherent;

    return Container(
      color: backgroundOverlayColor.withOpacity(0.8),
      child: WillPopScope(
        onWillPop: () {
          if (isIninitState == true) {
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        },
        child: new AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: cardColor,
          scrollable: true,
          elevation: 8.0,
          content: Container(
            width: wv * 100,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            widget.isAccountIsExists == false
                                ? 'Le numéro'
                                : 'Le Compte de l\'adherent',
                            style: TextStyle(
                              color: kBlueForce,
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize(size: 21),
                            )),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            widget.isAccountIsExists == false &&
                                    widget.phoneNumber != null
                                ? widget.phoneNumber
                                : ' est inatif',
                            style: TextStyle(
                              color: kBlueForce,
                              fontWeight: FontWeight.w700,
                              fontSize: fontSize(size: 21),
                            )),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          "assets/icons/Bulk/Danger.svg",
                          height: hv * 20,
                          width: wv * 20,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            widget.isAccountIsExists == false &&
                                    widget.phoneNumber != null
                                ? 'N\'est pas encore adherent a la mutuelle sante DanAid.Recommncer La mutuelle et devenez le medecin de famille de votre patient'
                                : 'L’adhérent n’etant pas à jour de ses cotisation, vous ne bénéficierez pas de la compensation dans le parsours de soins  DanAid.',
                            style: TextStyle(
                              color: kBlueForce,
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize(size: 17),
                            ),
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        height: hv * 2,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.isAccountIsExists == false &&
                                  widget.phoneNumber != null
                              ? 'Vous recevrez la compensation DanAid(2.000 Cfa) si la famille adh7re a la mutuelle'
                              : 'Poursuivez la consultation hors parcours de soin DanAid',
                          style: TextStyle(
                              color: kBlueForce,
                              fontSize: fontSize(size: 17),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: hv * 10.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: new Container(
                    width: wv * 100,
                    margin:
                        EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 15),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: wv * 100,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[500],
                                spreadRadius: 0.5,
                                blurRadius: 3),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildAboutDialog(context, false),
                            );
                          },
                          child: Text(
                            widget.isAccountIsExists == true
                                ? 'Ajouter une famille'
                                : 'Poursuivre hors parcours',
                            style: TextStyle(
                                color: textColor,
                                fontSize: wv * 4.5,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.w600),
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: 15)),
                              backgroundColor:
                                  MaterialStateProperty.all(kFirstIntroColor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))))),
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    adherentModelProvider = Provider.of<AdherentModelProvider>(context);
    AdherentModel adherent = adherentModelProvider.getAdherent;

    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            backgroundColor: kBgTextColor,
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: kDateTextColor,
                  ),
                  onPressed: () => Navigator.pop(context)),
              title: Align(
                alignment: Alignment.center,
                child: Container(
                  child: Column(
                    children: [Text('Famille'), Text('...')],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/Bulk/Setting.svg',
                    color: whiteColor,
                  ),
                  onPressed: () {},
                  color: kSouthSeas,
                )
              ],
            ),
            body: Container(
                child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(children: [
                      SizedBox(
                        height: hv * 2,
                      ),
                      Container(
                        width: wv * 100,
                        height: hv * 67,
                        decoration: BoxDecoration(
                          color: kBlueForce,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        margin: EdgeInsets.only(left: wv * 2, right: hv * 2),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: wv * 3, right: wv * 2, top: hv * 2),
                              child: Row(
                                children: [
                                  Container(
                                      width: wv * 15,
                                      child: Text('Valide jusqu\'au ',
                                          style: TextStyle(
                                              color: textWhiteColor,
                                              fontSize: fontSize(size: 15),
                                              fontWeight: FontWeight.w500))),
                                  Container(
                                      width: wv * 20,
                                      child: Text('10/2021',
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: wv * 4.5,
                                              fontWeight: FontWeight.w700))),
                                  Spacer(),
                                  SvgPicture.asset(
                                    'assets/icons/Bulk/Male.svg',
                                    color: whiteColor,
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/Bulk/Shield Done.svg',
                                    height: hv * 8,
                                    width: wv * 8,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        colorFilter:
                                            widget.isAccountIsExists == true &&
                                                    adherent.enable == true
                                                ? new ColorFilter.mode(
                                                    Colors.red.withOpacity(1),
                                                    BlendMode.dstATop)
                                                : new ColorFilter.mode(
                                                    Colors.red.withOpacity(0.5),
                                                    BlendMode.dstATop),
                                        image: adherent.imgUrl == null
                                            ? AssetImage(
                                                "assets/images/image 9.png")
                                            : CachedNetworkImageProvider(
                                                "${adherent.imgUrl}"),
                                        fit: BoxFit.cover,
                                      ),
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                  width: wv * 40,
                                  height: hv * 20,
                                  child: Stack(children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: Transform.rotate(
                                        angle: -math.pi / 4,
                                        child: Text(
                                          widget.isAccountIsExists == true &&
                                                  adherent.enable == true
                                              ? ''
                                              : 'Compte Inactif',
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              color: Colors.red,
                                              letterSpacing: 0.5,
                                              fontSize: wv * 6.5,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 5,
                                      bottom: -hv * 2,
                                      child: Container(
                                        height: hv * 10,
                                        width: wv * 10,
                                        decoration: BoxDecoration(
                                            color: widget.isAccountIsExists ==
                                                        true &&
                                                    adherent.enable == true
                                                ? Colors.green
                                                : Colors.red,
                                            shape: BoxShape.circle),
                                        child:
                                            widget.isAccountIsExists == true &&
                                                    adherent.enable == true
                                                ? SizedBox.shrink()
                                                : Icon(
                                                    Icons.priority_high,
                                                    color: Colors.white,
                                                    size: hv * 4,
                                                  ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: wv * 10, right: wv * 2, top: hv * 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Non du beneficiaire',
                                      style: TextStyle(
                                          color: textWhiteColor,
                                          fontSize: fontSize(size: 15),
                                          fontWeight: FontWeight.w500)),
                                  Text(adherent.cniName,
                                      style: TextStyle(
                                          color: textWhiteColor,
                                          fontSize: fontSize(size: 15),
                                          fontWeight: FontWeight.w700))
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: wv * 10, right: wv * 2, top: hv * 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Numero Matricule',
                                      style: TextStyle(
                                          color: textWhiteColor,
                                          fontSize: fontSize(size: 15),
                                          fontWeight: FontWeight.w500)),
                                  Text(adherent.matricule,
                                      style: TextStyle(
                                          color: textWhiteColor,
                                          fontSize: fontSize(size: 15),
                                          fontWeight: FontWeight.w700))
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: wv * 10, right: wv * 2, top: hv * 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Medecin de Famille ',
                                      style: TextStyle(
                                          color: textWhiteColor,
                                          fontSize: fontSize(size: 15),
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                      adherent.familyDoctor != null
                                          ? adherent.familyDoctor.cniName
                                          : 'Pas definie ',
                                      style: TextStyle(
                                          color: textWhiteColor,
                                          fontSize: fontSize(size: 15),
                                          fontWeight: FontWeight.w700))
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: hv * 4),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child:
                                    Image.asset('assets/icons/DanaidLogo.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.isAccountIsExists == false
                          ? SizedBox.shrink()
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: wv * 80,
                                margin: EdgeInsets.only(top: hv * 8),
                                child: TextButton(
                                  onPressed: () {
                                    if (adherent.enable == false) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _buildAboutDialog(
                                                  context, false));
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OwnerUserListView(
                                                  idOfAdherent:
                                                      widget.phoneNumber,
                                                )),
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Acceder au carnet de Sante',
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: wv * 4.5,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(vertical: 15)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              kFirstIntroColor),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25))))),
                                ),
                              ),
                            ),
                    ])))));
  }
}
