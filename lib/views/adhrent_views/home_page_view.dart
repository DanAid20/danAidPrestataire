import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/adhrent_views/aid_network_screen.dart';
import 'package:danaid/views/adhrent_views/doctor_profile.dart';
import 'package:danaid/views/adhrent_views/health_book_screen.dart';
import 'package:danaid/views/adhrent_views/hello_screen.dart';
import 'package:danaid/views/adhrent_views/myfamily_screen.dart';
import 'package:danaid/views/adhrent_views/partners_screen.dart';
import 'package:danaid/views/doctor_views/tabs_doctor_views/profil_doctor_view.dart';
import 'package:danaid/widgets/painters.dart';
import 'package:flutter/material.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  
  double width = SizeConfig.screenWidth / 100;
  double height = SizeConfig.screenHeight / 100;
  double inch = sqrt(SizeConfig.screenWidth*SizeConfig.screenWidth + SizeConfig.screenHeight*SizeConfig.screenHeight) / 100;

  //int index = 1;
  loadAdherentprofile() async {
    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if(userProvider.getUserId != null || userProvider.getUserId != ""){
      if(adherentModelProvider.getAdherent != null){
          //
        }
        else {
          FirebaseFirestore.instance.collection('ADHERENTS').doc(userProvider.getUserId).get().then((docSnapshot) {
            AdherentModel adherent = AdherentModel.fromDocument(docSnapshot);
            adherentModelProvider.setAdherentModel(adherent);
          });
        }
    } else {
      String phone = await HiveDatabase.getAuthPhone();
      if(adherentModelProvider.getAdherent != null){
          //
        }
        else {
          FirebaseFirestore.instance.collection('ADHERENTS').doc(phone).get().then((docSnapshot) {
             AdherentModel adherent = AdherentModel.fromDocument(docSnapshot);
            adherentModelProvider.setAdherentModel(adherent);
          });
        }
    }
  }
  loadDoctorProfile() async {
    DoctorModelProvider doctorModelProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if(userProvider.getUserId != null || userProvider.getUserId != ""){
      if(doctorModelProvider.getDoctor != null){
          //
        }
        else {
          FirebaseFirestore.instance.collection('MEDECINS').doc(userProvider.getUserId).get().then((docSnapshot) {
            DoctorModel doc = DoctorModel.fromDocument(docSnapshot);
            doctorModelProvider.setDoctorModel(doc);
          });
        }
    } else {
      String phone = await HiveDatabase.getAuthPhone();
      if(doctorModelProvider.getDoctor != null){
          //
        }
        else {
          FirebaseFirestore.instance.collection('MEDECINS').doc(phone).get().then((docSnapshot) {
             DoctorModel doc = DoctorModel.fromDocument(docSnapshot);
            doctorModelProvider.setDoctorModel(doc);
          });
        }
    }
  }

  loadUserProfile() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if(userProvider.getProfileType != null || userProvider.getProfileType != ""){
      if(userProvider.getProfileType == adherent){
        loadAdherentprofile();
      }
      else if(userProvider.getProfileType == doctor) {
        loadDoctorProfile();
      }
      else if(userProvider.getProfileType == serviceProvider){
        loadAdherentprofile();
      }
    }
    else {
      String profile = await HiveDatabase.getProfileType();
      if(profile != null){
        userProvider.setProfileType(profile);
        if(profile == adherent){
          loadAdherentprofile();
        }
        else if(userProvider.getProfileType == doctor) {
          loadDoctorProfile();
        }
        else if(userProvider.getProfileType == serviceProvider){
          loadAdherentprofile();
        }
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    loadUserProfile();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    BottomAppBarControllerProvider bottomAppBarController = Provider.of<BottomAppBarControllerProvider>(context);
    int index = bottomAppBarController.getIndex;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [

          Container(
            child: getCurrentPage(),
          ),

          Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.transparent,
                  height: hv*12,
                  width: double.infinity,
                  child: CustomPaint(painter: BottomNavBarBackgroundPainter(),),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.transparent,
                  height: hv*12,
                  width: double.infinity,
                  child: CustomPaint(painter: BottomNavBarPainter(),),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: height*12,
                  padding: EdgeInsets.symmetric(horizontal: width*1),
                  decoration: BoxDecoration(color: Colors.transparent,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      index == 0 ? iconActive(svgUrl: "assets/icons/Two-tone/Category.svg") : Container(),
                      index == 1 ? iconActive(svgUrl: "assets/icons/Two-tone/Home.svg") : Container(),
                      index == 2 ? iconActive(svgUrl: "assets/icons/Two-tone/Paper.svg") : Container(),
                      index == 3 ? iconActive(svgUrl: "assets/icons/Two-tone/Location.svg") : Container(),
                      index == 4 ? iconActive(svgUrl: userProvider.getProfileType != doctor ? "assets/icons/Two-tone/3User.svg" : "assets/icons/Two-tone/Profile.svg") : Container(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: height*10,
                  padding: EdgeInsets.symmetric(horizontal: width*3, vertical: height*1.0),
                  decoration: BoxDecoration(color: Colors.transparent,),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      index == 0 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Category.svg", title: "Entraide", onTap: entraideTapped),
                      index == 1 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Home.svg", title: "Accueil", onTap: accueilTapped),
                      index == 2 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Paper.svg", title: "Carnet", onTap: carnetTapped),
                      index == 3 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Location.svg", title: "partenaire", onTap: partenaireTapped),
                      index == 4 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: userProvider.getProfileType != doctor ? "assets/icons/Two-tone/3User.svg" : "assets/icons/Two-tone/Profile.svg", title: userProvider.getProfileType == doctor ? "Profile" : "famille", onTap: familleTapped),
                    ],
                  ),
                ),
              ),
              
            ],
          )
        ],
      ),
    );
  }
  entraideTapped(){
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    controller.setIndex(0);
  }
  accueilTapped(){
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    controller.setIndex(1);
  }
  carnetTapped(){
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    controller.setIndex(2);
  }
  partenaireTapped(){
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    controller.setIndex(3);
  }
  familleTapped(){
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    controller.setIndex(4);
  }

  bottomIcon({String svgUrl, String title, Function onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(svgUrl, width: inch*3, color: Colors.white.withOpacity(0.65)),
            Text(title, style: TextStyle(color: Colors.white.withOpacity(0.7)),)
          ],
        ),
      ),
    );
  }

  iconActive({String svgUrl}){
    return CircleAvatar(
      radius: width*7.5,
      backgroundColor: kPrimaryColor,
      child: CircleAvatar(
        radius: width*7.2,
        backgroundColor: Colors.white,
        child: SvgPicture.asset(svgUrl, width: inch*4, color: kPrimaryColor.withOpacity(0.65)),
      ),
    );
  }

  getCurrentPage(){
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);

    if(controller.getIndex == 0){
      return AidNetworkScreen();
    }
    else if(controller.getIndex == 1){
      return HelloScreen();
    }
    else if(controller.getIndex == 2){
      return userProvider.getProfileType == doctor ? ProfilDoctorView() : HealthBookScreen();
    }
    else if(controller.getIndex == 3){
      return userProvider.getProfileType == doctor ? ProfilDoctorView() : PartnersScreen();
    }
    else if(controller.getIndex == 4){
      return userProvider.getProfileType == doctor ? DoctorProfilePage() : MyFamilyScreen();
    }
  }

}