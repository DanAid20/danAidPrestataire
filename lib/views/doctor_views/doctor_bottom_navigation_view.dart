// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:math';

import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/doctor_views/tabs_doctor_views/doctor_patient_view.dart';
import 'package:danaid/views/doctor_views/tabs_doctor_views/home_doctor_view.dart';
import 'package:danaid/views/doctor_views/tabs_doctor_views/profil_doctor_view.dart';
import 'package:danaid/views/adhrent_views/aid_network_screen.dart';
import 'package:danaid/views/adhrent_views/partners_screen.dart';
import 'package:danaid/widgets/painters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DoctorBottomNavigationView extends StatefulWidget {
  DoctorBottomNavigationView({Key? key}) : super(key: key);

  @override
  _DoctorBottomNavigationViewState createState() =>
      _DoctorBottomNavigationViewState();
}

class _DoctorBottomNavigationViewState extends State<DoctorBottomNavigationView> {

  double width = SizeConfig.screenWidth! / 100;
  double height = SizeConfig.screenHeight! / 100;
  double inch = sqrt(SizeConfig.screenWidth!*SizeConfig.screenWidth! + SizeConfig.screenHeight!*SizeConfig.screenHeight!) / 100;

  int index = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

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
                      index == 4 ? iconActive(svgUrl: "assets/icons/Two-tone/3User.svg") : Container(),
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
                      index == 0 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Category.svg", title: S.of(context).entraide, onTap: networkView),
                      index == 1 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Home.svg", title: S.of(context).accueil, onTap: homeView),
                      index == 2 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Paper.svg", title: S.of(context).mesPatients, onTap: patientView),
                      index == 3 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Location.svg", title: S.of(context).partenaires, onTap: partnerView),
                      index == 4 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/3User.svg", title: S.of(context).profile, onTap: profileView),
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
  networkView(){
    setState(() {
      index = 0;
    });
  }
  homeView(){
    setState(() {
      index = 1;
    });
  }
  patientView(){
    setState(() {
      index = 2;
    });
  }
  partnerView(){
    setState(() {
      index = 3;
    });
  }
  profileView(){
    setState(() {
      index = 4;
    });
  }

  bottomIcon({String? svgUrl, String? title, Function()? onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(svgUrl!, width: inch*3, color: Colors.white.withOpacity(0.65)),
            Text(title!, style: TextStyle(color: Colors.white.withOpacity(0.7)),)
          ],
        ),
      ),
    );
  }

  iconActive({String? svgUrl}){
    return CircleAvatar(
      radius: width*7.5,
      backgroundColor: kPrimaryColor,
      child: CircleAvatar(
        radius: width*7.2,
        backgroundColor: Colors.white,
        child: SvgPicture.asset(svgUrl!, width: inch*4, color: kPrimaryColor.withOpacity(0.65)),
      ),
    );
  }

  getCurrentPage(){

    if(index == 0){
      return AidNetworkScreen();
    }
    else if(index == 1){
      return HomeDoctorView();
    }
    else if(index == 2){
      return DoctorPatientView();
    }
    else if(index == 3){
      return PartnersScreen();
    }
    else if(index == 4){
      return ProfilDoctorView();
    }
  }
}