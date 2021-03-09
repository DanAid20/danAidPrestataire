import 'dart:ui';

import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/screens/my_coverage_tab.dart';
import 'package:danaid/views/screens/my_doctor_tab.dart';
import 'package:danaid/widgets/advantage_card.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

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
    return Scaffold(
      body: NestedScrollView(floatHeaderSlivers: true, 
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return <Widget>[
            SliverAppBar(
              toolbarHeight: hv*12,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 0,),
                      CircleAvatar(
                        radius: wv*8,
                        child: Image.asset("assets/images/avatar-profile.jpg", fit: BoxFit.cover,),
                      ),
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bonjour Fabrice!", style: TextStyle(fontSize: inch*2.7, color: kPrimaryColor, fontWeight: FontWeight.w500),),
                          Text("Couverture Accès", style: TextStyle(fontSize: inch*1.5, color: kPrimaryColor)),
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      SizedBox(width: 10,)
                    ],
                  ),
                  /*Row(
                    children: [
                      Text("12 000 Pts", style: TextStyle(fontSize: inch*1.1, fontWeight: FontWeight.w700, color: kPrimaryColor),),
                      SizedBox(width: wv*2,),
                      Icon(MdiIcons.shieldCheck, size: wv*4, color: Colors.red.withOpacity(0.6),),
                      Icon(MdiIcons.starBox, size: wv*4, color: Colors.teal.withOpacity(0.7),)
                    ],
                  ),*/
                ],
              ),
              actions: [
                Stack(
                  children: [
                    SizedBox(width: wv*30),
                    Positioned(
                      right: 0,
                      child: InkWell(
                        onTap: (){},
                        child: Container(
                          padding: EdgeInsets.all(wv*3),
                          child: WebsafeSvg.asset("assets/icons/Two-tone/Notification.svg", width: wv*7,)
                        ),
                      ),
                    ),
                    
                    Positioned(
                      right:wv*1,
                      top: hv*1,
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(100)
                        ),
                        child: Text("9+", style: TextStyle(fontSize: wv*2.2, color: Colors.teal, fontWeight: FontWeight.w900),),
                      ),
                    ),

                    Positioned(
                      right: wv*1,
                      top: hv*8,
                      child: Container(
                        child: Row(
                          children: [
                            Text("12 000 Pts", style: TextStyle(fontSize: inch*1.3, fontWeight: FontWeight.w700, color: Colors.teal[400]),),
                            SizedBox(width: wv*2,),
                            WebsafeSvg.asset("assets/icons/Bulk/Shield Done.svg", width: 18,),
                            WebsafeSvg.asset("assets/icons/Bulk/Ticket Star.svg", width: 18,),
                          ],
                       ),
                      ),
                    ),

                  ],
                ),
              ],
              pinned: true,
              floating: true,
              bottom: TabBar(
                indicatorWeight: 3,
                indicatorColor: kPrimaryColor,
                isScrollable: true,
                controller: _tabController,
                labelColor: kPrimaryColor,
                labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: inch*1.7),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
                tabs: tabs
              ),
            )
          ];
        }, 
      
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            getHealthTab(),
            MyCoverageTabView(),
            MyDoctorTabView()
          ],)
        
    )
    );
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
                  HomePageComponents().getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
                  HomePageComponents().getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),     
                  HomePageComponents().getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),     
                  HomePageComponents().getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
                  HomePageComponents().getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
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
                  HomePageComponents().getProfileStat(imgUrl: "assets/icons/posts.svg", title: "Posts", occurence: 72),
                  HomePageComponents().verticalDivider(),
                  HomePageComponents().getProfileStat(imgUrl: "assets/icons/chat.svg", title: "Commentaires", occurence: 122),
                  HomePageComponents().verticalDivider(),
                  HomePageComponents().getProfileStat(imgUrl: "assets/icons/2users.svg", title: "Followers", occurence: 21),
                  HomePageComponents().verticalDivider(),
                  HomePageComponents().getProfileStat(imgUrl: "assets/icons/message.svg", title: "Messages", occurence: 3),
                ],mainAxisAlignment: MainAxisAlignment.spaceBetween,)
              ],
            ),
          ),
        ),
        SizedBox(height: hv*4)
      ],
    );
  }
}