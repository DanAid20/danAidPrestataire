import 'dart:ui';

import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/advantage_card.dart';
import 'package:danaid/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HelloScreen extends StatefulWidget {
  @override
  _HelloScreenState createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = <Widget>[
    const Tab(text: "Bienvenue",),
    const Tab(text: "Ma Couverture",),
    const Tab(text: "Mon Docteur",),
  ];
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(height: 10,),
      Row(
        children: [
          SizedBox(width: 10,),
          CircleAvatar(
            radius: wv*8,
            child: Image.asset("assets/images/avatar-profile.jpg", fit: BoxFit.cover,),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Bonjour Fabrice!", style: TextStyle(fontSize: inch*2.7, color: kPrimaryColor, fontWeight: FontWeight.w600),),
              Text("Famille"),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                children: [
                  IconButton(
                    color: kPrimaryColor,
                    icon: Icon(Icons.notifications_none_rounded, size: wv*8,),
                    onPressed: (){}),
                    Positioned(
                      left: wv*7,
                      top: hv*1,
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(100)
                        ),
                        child: Text("9+", style: TextStyle(fontSize: wv*2.2, fontWeight: FontWeight.w900),),
                      ),
                    )
                ],
              ),
              Row(
                children: [
                  Text("12 000 Pts", style: TextStyle(fontSize: inch*1.1, fontWeight: FontWeight.w700, color: kPrimaryColor),),
                  SizedBox(width: wv*2,),
                  Icon(MdiIcons.shieldCheck, size: wv*4, color: Colors.red.withOpacity(0.6),),
                  Icon(MdiIcons.starBox, size: wv*4, color: Colors.teal.withOpacity(0.7),)
                ],
              )
            ],
          ),
          SizedBox(width: 10,)
        ],
      ),

      TabBar(
        indicatorWeight: 3,
        indicatorColor: kPrimaryColor,
        isScrollable: true,
        controller: _tabController,
        labelColor: kPrimaryColor,
        labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: inch*2),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
        tabs: tabs
      ),
      Divider(height: 1, thickness: 0.7,),
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            getHealthTab(),
            const Text("MaCouverture"),
            const Text("Mon Docteur")
          ],),
      )
    ],);
  }
  Widget getHealthTab(){
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left:inch*2, right:inch*2, top: inch*1),
                    child: Row(children: [
                      Text("Mes Avantages", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                      Text("Voir plus..")
                    ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                  ),
                  Column(mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(scrollDirection: Axis.horizontal, physics: BouncingScrollPhysics(),
                      child: Row(children: [
                        AdvantageCard(
                          label: "Fond de Soins",
                          description: "Demander une prise en charge maladie",
                          state: "DISPONIBLE",
                          price: "#350.000Xaf",
                          color: Colors.teal[500],
                          onTap: (){},
                        ),
                        AdvantageCard(
                          label: "Prêt de santé",
                          description: "Demander un prêt santé",
                          state: "DISPONIBLE",
                          price: "#100.000Xaf",
                          color: Colors.brown.withOpacity(0.7),
                          onTap: (){},
                        ),
                        AdvantageCard(
                          label: "Fond de Soins",
                          description: "Demander une prise en charge maladie",
                          state: "DISPONIBLE",
                          price: "#350.000Xaf",
                          color: Colors.grey,
                          onTap: (){},
                        ),
                      ],),
                      ),
                    ],
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.only(left:inch*2, right:inch*2, top: inch*0.5),
                    child: Row(children: [
                      Text("Notifications", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                      Text("Voir plus..")
                    ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 20.0,
                          offset: Offset(0.0, 0.75),
                          spreadRadius: -15.0
                        )
                      ]
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min,
                      children: [
                        SingleChildScrollView(scrollDirection: Axis.horizontal, physics: BouncingScrollPhysics(),
                        child: Row(children: [
                          NotificationCard(
                            instruction: "Aller au Labo",
                            description: "Vous avez 3 nouveaux devis pour vos examens médicaux",
                          ),
                          NotificationCard(
                            instruction: "Aller au Labo",
                            description: "Vous avez 3 nouveaux devis pour vos examens médicaux",
                          ),
                          NotificationCard(
                            instruction: "Aller au Labo",
                            description: "Vous avez 3 nouveaux devis pour vos examens médicaux",
                          ),
                        ],),
                        ),
                      ],
                    ),
                  ),
                  
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.3), width: 0.3)),
          ),
          padding: EdgeInsets.only(top: hv*1),
          child: Container(
            margin: EdgeInsets.only(left:inch*1.5, right:inch*1.5, top: inch*0),
            child: Column(
              children: [
                Row(children: [
                  Text("Aujourd'hui", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                  Text("Voir plus..")
                ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                
                SizedBox(height: hv*2,),

                Row(children: [
                  getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
                  getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),     
                  getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),     
                  getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
                  getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
                  Expanded(child: Container()),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: Text("+ 150 Autres...", style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor),),
                  )                       
                ],),

                SizedBox(height: hv*2,),
                
                Row(children: [
                  getProfileStat(imgUrl: "assets/icons/posts.svg", title: "Posts", occurence: 72),
                  verticalDivider(),
                  getProfileStat(imgUrl: "assets/icons/chat.svg", title: "Commentaires", occurence: 122),
                  verticalDivider(),
                  getProfileStat(imgUrl: "assets/icons/2users.svg", title: "Followers", occurence: 21),
                  verticalDivider(),
                  getProfileStat(imgUrl: "assets/icons/message.svg", title: "Messages", occurence: 3),
                ],mainAxisAlignment: MainAxisAlignment.spaceBetween,)
              ],
            ),
          ),
        ),
        SizedBox(height: hv*4)
      ],
    );
  }
  getAvatar({String imgUrl}){
    return Padding(
      padding: EdgeInsets.only(right: wv*1),
      child: Stack(children: [
        CircleAvatar(
          radius: wv*5.5,
          child: Image.asset(imgUrl, fit: BoxFit.cover,),
        ),
        Positioned(
          top: wv*7,
          left: wv*8,
          child: CircleAvatar(
            radius: wv*1.5,
            backgroundColor: primaryColor,
          ),
        )
      ],),
    );
  }
  getProfileStat({String imgUrl, String title, int occurence}){
    return Row(children: [
      Container(
        margin: EdgeInsets.only(right: wv*1),
        child: SvgPicture.asset(imgUrl, width: wv*7,),
      ),
      Column(children: [ 
        Text("$occurence", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        Text(title, style: TextStyle(fontSize: inch*1.3))
      ],)
    ]);
  }
  verticalDivider(){
    return Container(
      width: wv*0.5,
      height: wv*8,
      color: Colors.grey.withOpacity(0.4),
    );
  }
}