import 'dart:math';

import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/screens/aid_network_screen.dart';
import 'package:danaid/views/screens/health_book_screen.dart';
import 'package:danaid/views/screens/hello_screen.dart';
import 'package:danaid/views/screens/myfamily_screen.dart';
import 'package:danaid/views/screens/partners_screen.dart';
import 'package:danaid/widgets/painters.dart';
import 'package:flutter/material.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  
  double width = SizeConfig.screenWidth / 100;
  double height = SizeConfig.screenHeight / 100;
  double inch = sqrt(SizeConfig.screenWidth*SizeConfig.screenWidth + SizeConfig.screenHeight*SizeConfig.screenHeight) / 100;

  int index = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [

            Container(
              margin: EdgeInsets.only(bottom: height*7),
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
                        index == 0 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Category.svg", title: "Entraide", onTap: entraideTapped),
                        index == 1 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Home.svg", title: "Accueil", onTap: accueilTapped),
                        index == 2 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Paper.svg", title: "Carnet", onTap: carnetTapped),
                        index == 3 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Location.svg", title: "partenaire", onTap: partenaireTapped),
                        index == 4 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/3User.svg", title: "famille", onTap: familleTapped),
                      ],
                    ),
                  ),
                ),
                
              ],
            )
          ],
        ),
      ),
    );
  }
  entraideTapped(){
    setState(() {
      index = 0;
    });
  }
  accueilTapped(){
    setState(() {
      index = 1;
    });
  }
  carnetTapped(){
    setState(() {
      index = 2;
    });
  }
  partenaireTapped(){
    setState(() {
      index = 3;
    });
  }
  familleTapped(){
    setState(() {
      index = 4;
    });
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

    if(index == 0){
      return AidNetworkScreen();
    }
    else if(index == 1){
      return HelloScreen();
    }
    else if(index == 2){
      return HealthBookScreen();
    }
    else if(index == 3){
      return PartnersScreen();
    }
    else if(index == 4){
      return MyFamilyScreen();
    }
  }

}