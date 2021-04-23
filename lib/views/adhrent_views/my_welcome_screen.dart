import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/advantage_card.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/notification_card.dart';
import 'package:flutter/material.dart';

class MyWelcomeScreen extends StatefulWidget {
  @override
  _MyWelcomeScreenState createState() => _MyWelcomeScreenState();
}

class _MyWelcomeScreenState extends State<MyWelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: hv*2),
                    padding: EdgeInsets.only(top: hv*1.5, bottom: hv*1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 2.0, spreadRadius: 1.0)]
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left:inch*2, right:inch*2),
                          child: Row(children: [
                            Text("Mes Avantages", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                            Text("Voir plus..")
                          ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                        ),
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
                  ),

                  Container(
                    margin: EdgeInsets.only(top: hv*2),
                    padding: EdgeInsets.only(top: hv*1.5, bottom: hv*1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 2.0, spreadRadius: 1.0)]
                    ),
                    child: Column(children: [
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
                      )
                    ],),
                  )
                  
                  
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
                ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                SizedBox(height: hv*7,)
              ],
            ),
          ),
        ),
        SizedBox(height: hv*4)
      ],
    );
  }
}