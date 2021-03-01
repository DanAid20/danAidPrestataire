import 'dart:math';

import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/screens/aid_network_screen.dart';
import 'package:danaid/views/screens/health_book_screen.dart';
import 'package:danaid/views/screens/hello_screen.dart';
import 'package:danaid/views/screens/myfamily_screen.dart';
import 'package:danaid/views/screens/partners_screen.dart';
import 'package:flutter/material.dart';
import 'package:danaid/core/utils/config_size.dart';
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
              margin: EdgeInsets.only(bottom: height*10),
              child: getCurrentPage(),
            ),

            Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: kPrimaryColor,
                    constraints: BoxConstraints(maxHeight: height*10),
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
                        index == 0 ? iconActive(icon: MdiIcons.viewGridOutline) : Container(),
                        index == 1 ? iconActive(icon: Icons.home_outlined) : Container(),
                        index == 2 ? iconActive(icon: MdiIcons.fileDocumentOutline) : Container(),
                        index == 3 ? iconActive(icon: MdiIcons.mapMarkerOutline) : Container(),
                        index == 4 ? iconActive(icon: MdiIcons.accountGroupOutline) : Container(),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: height*10,
                    padding: EdgeInsets.symmetric(horizontal: width*3, vertical: height*1.5),
                    decoration: BoxDecoration(color: Colors.transparent,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        index == 0 ? SizedBox(width: width*13,) : bottomIcon(icon: MdiIcons.viewGridOutline, title: "Entraide", onTap: entraideTapped),
                        index == 1 ? SizedBox(width: width*13,) : bottomIcon(icon: Icons.home_outlined, title: "Accueil", onTap: accueilTapped),
                        index == 2 ? SizedBox(width: width*13,) : bottomIcon(icon: MdiIcons.fileDocumentOutline, title: "Carnet", onTap: carnetTapped),
                        index == 3 ? SizedBox(width: width*13,) : bottomIcon(icon: MdiIcons.mapMarkerOutline, title: "partenaire", onTap: partenaireTapped),
                        index == 4 ? SizedBox(width: width*13,) : bottomIcon(icon: MdiIcons.accountGroupOutline, title: "famille", onTap: familleTapped),
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

  bottomIcon({IconData icon, String title, Function onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.7)),
            Text(title, style: TextStyle(color: Colors.white.withOpacity(0.7)),)
          ],
        ),
      ),
    );
  }

  iconActive({IconData icon}){
    return CircleAvatar(
      radius: width*9.2,
      backgroundColor: kPrimaryColor,
      child: CircleAvatar(
        radius: width*7.2,
        backgroundColor: Colors.white,
        child: Icon(icon, size: inch*4, color: kPrimaryColor.withOpacity(0.65),),
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