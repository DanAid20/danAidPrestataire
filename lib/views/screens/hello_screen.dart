import 'dart:ui';

import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/advantage_card.dart';
import 'package:danaid/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HelloScreen extends StatefulWidget {
  @override
  _HelloScreenState createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = <Widget>[
    const Tab(text: "Posts",),
    const Tab(text: "Santé",),
    const Tab(text: "Rendez-vous",),
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
        //isScrollable: true,
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
            const Text("Entraide"),
            getHealthTab(),
            const Text("Rendez-vous")
          ],),
      )
    ],);
  }
  Widget getHealthTab(){
    return ListView(
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
                    color: kPrimaryColor,
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
            Column(mainAxisSize: MainAxisSize.min,
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
            Divider(),
            Container(
              margin: EdgeInsets.only(left:inch*2, right:inch*2, top: inch*0),
              child: Row(children: [
                Text("Nouvelles du réseau", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                Text("Y aller..")
              ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
            ),
            SizedBox(height: 50,)
          ],
        ),
      ],
    );
  }
}