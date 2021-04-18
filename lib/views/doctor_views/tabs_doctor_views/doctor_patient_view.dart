import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../locator.dart';

class DoctorPatientView extends StatefulWidget {
  DoctorPatientView({Key key}) : super(key: key);

  @override
  _DoctorPatientViewState createState() => _DoctorPatientViewState();
}

class _DoctorPatientViewState extends State<DoctorPatientView> {
  final NavigationService _navigationService = locator<NavigationService>();
  Widget servicesList() {
    return Container(
      margin: EdgeInsets.only(top: hv * 1.5, bottom: hv * 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
              margin:
                  EdgeInsets.only(left: wv * 1.5, right: wv * 1.5, top: hv * 3),
              width: wv * 90,
              height: hv * 20,
              decoration: BoxDecoration(
                color: kThirdIntroColor,
                boxShadow: [
                  BoxShadow(
                      color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.only(top: hv * 1),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(right: wv * 3.5, top: hv * 0.5),
                      child: SvgPicture.asset(
                        'assets/icons/Bulk/Bookmark.svg',
                        width: wv * 8,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: wv * 2.9, right: hv * 1.5, top: hv * 1),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Demarer Une consultation',
                            style: TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w800,
                                fontSize: fontSize(size: wv * 7)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: wv * 0.2, right: hv * 1.5, top: hv * 2.5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Accédez au Carnet de Santé digital de vos patients et déclenchez leur prise en charge',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: fontSize(size: wv * 4)),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.0),
            height: hv * 17,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/doctor-add-patient');
                  },
                  child: displsOtherServices(
                      iconesUrl: 'assets/icons/Bulk/Add User.svg',
                      title: 'Ajouter un Patient'),
                ),
                displsOtherServices(
                    iconesUrl: 'assets/icons/Bulk/Chart.svg',
                    title: 'Suivre mes paiements'),
                displsOtherServices(
                    iconesUrl: 'assets/icons/Bulk/Message.svg',
                    title: 'Mes Messages'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  displsOtherServices({String iconesUrl, String title}) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(
                left: wv * 6, right: wv * 1.5, top: hv * 2, bottom: hv * 1),
            width: wv * 24,
            height: hv * 14,
            decoration: BoxDecoration(
              color: kThirdIntroColor,
              boxShadow: [
                BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding: EdgeInsets.only(top: hv * 0.3),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: wv * 1.5, top: hv * 0.5),
                    child: SvgPicture.asset(
                      iconesUrl != null
                          ? iconesUrl
                          : 'assets/icons/Bulk/Bookmark.svg',
                      width: wv * 6,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: wv * 1.9, right: wv * 1.5, top: hv * 1),
                  child: Row(
                    children: [
                      Container(
                        width: wv * 15,
                        child: Text(
                          title != null ? title : 'Ajouter un Patient',
                          style: TextStyle(
                              color: kCardTextColor,
                              fontWeight: FontWeight.w800,
                              fontSize: fontSize(size: wv * 4)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }

  patientOfTodyaList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.only(top: hv * 2, left: wv * 5, right: wv * 5),
          child: Row(
            children: [
              Text(
                "Question au Docteur",
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.w700),
              ),
              Text("Voir plus..")
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 2.0),
          color: Colors.white,
          child: new ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              patientsItem(
                  apointementDate: "12:15",
                  apointementType: 'RDV',
                  imgUrl: 'assets/images/avatar-profile.jpg',
                  nom: 'Fabrice Mbanga',
                  subtitle: 'Nouvelle Consultation'),
              patientsItem(
                  apointementDate: "12:05",
                  apointementType: 'RDV',
                  imgUrl: 'assets/images/avatar-profile.jpg',
                  nom: 'Fabrice Mbanga',
                  subtitle: 'Nouvelle Consultation',
                  isSpontane: true),
              patientsItem(
                  apointementDate: "12:15",
                  apointementType: 'RDV',
                  imgUrl: 'assets/images/avatar-profile.jpg',
                  nom: 'Fabrice Mbanga',
                  subtitle: 'Nouvelle Consultation'),
            ],
          ),
        ),
      ]),
    );
  }

  Widget patientsItem(
      {String imgUrl,
      String nom,
      String subtitle,
      String apointementDate,
      String apointementType,
      bool isSpontane = false}) {
    return ListTile(
      leading: HomePageComponents().getAvatar(
          imgUrl: imgUrl != null ? imgUrl : "assets/images/avatar-profile.jpg",
          size: wv * 8,
          renoveIsConnectedButton: false),
      title: Text(
        nom != null ? nom : 'Fabrice Mbanga',
        style: TextStyle(
            fontSize: fontSize(size: wv * 5),
            fontWeight: FontWeight.w700,
            color: kPrimaryColor),
      ),
      subtitle: Text(
        subtitle != null ? subtitle : 'Nouvelle Consultation',
        style: TextStyle(
            fontSize: fontSize(size: wv * 4),
            fontWeight: FontWeight.w500,
            color: kPrimaryColor),
      ),
      trailing: isSpontane == true
          ? Text(
              'Spontane',
              style:
                  TextStyle(fontSize: fontSize(size: wv * 5), color: kDeepTeal),
            )
          : Container(
              padding: EdgeInsets.only(top: hv * 1, right: wv * 2),
              child: Column(
                children: [
                  Text(
                    apointementDate != null ? apointementDate : '12:15',
                    style: TextStyle(
                        fontSize: fontSize(size: wv * 4), color: kPrimaryColor),
                  ),
                  Text(
                    apointementType != null ? apointementType : 'RDV',
                    style: TextStyle(
                        fontSize: fontSize(size: wv * 4),
                        fontWeight: FontWeight.w700,
                        color: primaryColor),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
          color: kBgTextColor,
        ),
        child: Column(
          children: [servicesList(), patientOfTodyaList()],
        ),
      ),
    );
  }
}
