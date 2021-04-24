import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DoctorPatientView extends StatefulWidget {
  DoctorPatientView({Key key}) : super(key: key);

  @override
  _DoctorPatientViewState createState() => _DoctorPatientViewState();
}

class _DoctorPatientViewState extends State<DoctorPatientView> {
  final NavigationService _navigationService = locator<NavigationService>();

  Widget servicesList() {
  UserProvider userProvider = Provider.of<UserProvider>(context);
  bool isPrestataire=true;
    return Container(
      margin: EdgeInsets.only(top: hv * 1.5, bottom: hv * 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
              margin:
                  EdgeInsets.only(left: wv * 1.5, right: wv * 1.5, top: 20.h),
              width: 330.w,
              height: 140.h, 
              decoration: BoxDecoration(
                color:  isPrestataire ? kGold :kThirdIntroColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, spreadRadius: 0.5, blurRadius: 4),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(17),
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
                        color:isPrestataire ==true ?kBlueForce:kDeepTeal
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 20.w, right: hv * 1.5, top: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            isPrestataire ? 'Compléter une prise en charge' :'Démarrer une consultation',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 20.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 20.w, right: 60.w, top: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                           isPrestataire ? 'Vérifier le statut des paiements avant de réaliser les services à un adhérent':  'Accédez au Carnet de Santé digital de vos patients et déclenchez leur prise en charge',
                            textScaleFactor: 0.8,
                            style: TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.5.sp),
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
            height: 110.r,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/doctor-add-patient');
                  },
                  child: displsOtherServices(
                      iconesUrl: isPrestataire? 'assets/icons/Bulk/Discount.svg' :'assets/icons/Bulk/Add User.svg',
                      title:  isPrestataire? 'Emettre un devis' :'Ajouter un Patient',
                      isPrestataire: isPrestataire,
                      ),
                ),
                displsOtherServices(
                    iconesUrl: 'assets/icons/Bulk/Chart.svg',
                    title: 'Suivre mes paiements', 
                    isPrestataire: isPrestataire,),
                displsOtherServices(
                    iconesUrl: 'assets/icons/Bulk/Message.svg',
                    title: 'Mes Messages', 
                    isPrestataire: isPrestataire,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  displsOtherServices({String iconesUrl, String title, bool isPrestataire=false}) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(
                left: 20.w, right: wv * 1.5, top: hv * 2, bottom: hv * 1),
            width: 125.r,
            height: 85.r,
            decoration: BoxDecoration(
              color: isPrestataire ==true ? kGoldlight :kThirdIntroColor,
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
                    margin: EdgeInsets.only(left: 10.w, top: 4.h),
                    child: SvgPicture.asset(
                      iconesUrl != null
                          ? iconesUrl
                          : 'assets/icons/Bulk/Bookmark.svg',
                      width: wv * 6,
                     color:isPrestataire ==true ?kBlueForce:kDeepTeal
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 10.w, right: wv * 1.5, top:1.h),
                  child: Row(
                    children: [
                      Container(
                        width: 90.r,
                        child: Text(
                          title != null ? title : 'Ajouter un Patient',
                          style: TextStyle(
                              color: kCardTextColor,
                              fontWeight: FontWeight.w800,
                              fontSize:  17.sp),
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
                "Aujourd'hui ",
                style: TextStyle(
                    color: kFirstIntroColor, fontSize:  15.sp ,fontWeight: FontWeight.w500),
              ),
              Text("Voir plus..",style: TextStyle(
                    color: kBrownCanyon, fontSize:  15.sp, fontWeight: FontWeight.w700))
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
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: kPrimaryColor),
      ),
      subtitle: Text(
         'Nouvelle Consultation',
        overflow: TextOverflow.ellipsis,
         maxLines: 2,
         softWrap: false,
        style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: kPrimaryColor),
      ),
      trailing: isSpontane == true
          ? Text(
              'Spontane',
              style:
                  TextStyle(fontSize: 14.sp, color: kDeepTeal),
            )
          : Container(
              padding: EdgeInsets.only(top: hv * 1, right: wv * 2),
              child: Column(
                children: [
                  Text(
                    apointementDate != null ? apointementDate : '12:15',
                    style: TextStyle(
                        fontSize:  14.sp, color: kPrimaryColor),
                  ),
                  Text(
                    apointementType != null ? apointementType : 'RDV',
                    style: TextStyle(
                        fontSize: 14.sp,
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
