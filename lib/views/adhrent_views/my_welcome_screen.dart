import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/advantage_card.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:danaid/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyWelcomeScreen extends StatefulWidget {
  @override
  _MyWelcomeScreenState createState() => _MyWelcomeScreenState();
}

class _MyWelcomeScreenState extends State<MyWelcomeScreen> {
  callDanAid() {
    String url = "tel:+237233419203";
    launch(url);
  }
  @override
  Widget build(BuildContext context) {

    UserProvider userProvider = Provider.of<UserProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    BottomAppBarControllerProvider navController = Provider.of<BottomAppBarControllerProvider>(context);

    bool enable = adherentProvider.getAdherent.enable != null ? adherentProvider.getAdherent.enable : false;

    return userProvider.getUserModel != null && adherentProvider.getAdherent != null ? Column(
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
                      //boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 2.0, spreadRadius: 1.0)]
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left:inch*2, right:inch*2),
                          child: Row(children: [
                            Text("Mes Avantages", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                            //Text("Voir plus..")
                          ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                        ),
                        SingleChildScrollView(scrollDirection: Axis.horizontal, physics: BouncingScrollPhysics(),
                        child: Row(children: [
                          AdvantageCard(
                            label: "Fond de soin",
                            state: "DISPONIBLE",
                            price: adherentProvider.getAdherent.adherentPlan == 0 ? "#25.000 f." : adherentProvider.getAdherent.adherentPlan == 1 ? "#350.000 f." : adherentProvider.getAdherent.adherentPlan == 2 ? "#650.000 f." : "#1000.000 f.",
                            color: Colors.teal[500],
                            onTap: ()=>Navigator.pushNamed(context, '/refund-form'),
                          ),
                          /*AdvantageCard(
                            label: "Fond de Soins",
                            state: "DISPONIBLE",
                            price: "#350.000Xaf",
                            color: Colors.teal[500],
                            onTap: () {
                              String url = "tel:+237233419203";
                              launch(url);
                            },
                          ),*/
                          Hero(
                            tag: "loanCard",
                            flightShuttleBuilder: flightShuttleBuilder,
                            child: AdvantageCard(
                              label: "Prêt de santé",
                              state: "DISPONIBLE",
                              price: adherentProvider.getAdherent.adherentPlan == 0 ? "#50.000 f." : adherentProvider.getAdherent.adherentPlan == 1 ? "#100.000 f." : adherentProvider.getAdherent.adherentPlan == 2 ? "#150.000 f." : "#200.000 f.",
                              color: Colors.brown.withOpacity(0.7),
                              onTap: ()=>Navigator.pushNamed(context, '/loans'),
                            ),
                          ),
                          /*AdvantageCard(
                            label: "Fond de Soins",
                            state: "DISPONIBLE",
                            price: "#350.000Xaf",
                            color: Colors.grey,
                            onTap: callDanAid,
                          ),*/
                        ],),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: hv*2),
                    //padding: EdgeInsets.only(top: hv*1.5, bottom: hv*1),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                      Container(
                        margin: EdgeInsets.only(left:inch*2, right:inch*2, top: inch*0.5),
                        child: Row(children: [
                          Text("Notifications", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                          //Text("Voir plus..")
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
                              !enable ? GestureDetector(
                                onTap: ()=>Navigator.pushNamed(context, userProvider.getProfileType == doctor ? '/doctor-profile-edit' : userProvider.getProfileType == adherent ? '/adherent-profile-edit' : '/serviceprovider-profile-edit'),
                                child: NotificationCard(
                                  isprestataire: false,
                                  instruction: "Ouvrir la Page...",
                                  description: "Mettez à jour votre profil pour pouvoir pleinement profiter de vos avantages DanAid",
                                ),
                              ) : Container(),

                              !enable ? GestureDetector(
                                onTap: ()=>navController.setIndex(4),
                                child: NotificationCard(
                                  isprestataire: false,
                                  instruction: "Ouvrir la Page...",
                                  description: "Ajouter les membres de votre famille à votre liste de bénéficiaires",
                                ),
                              ) : Container(),

                              adherentProvider.getAdherent.familyDoctorId == null ? GestureDetector(
                                onTap: ()=>navController.setIndex(3),
                                child: NotificationCard(
                                  isprestataire: false,
                                  instruction: "Ouvrir la Page...",
                                  description: "Choisissez votre médecin de famille DanAid",
                                ),
                              ) : Container(),

                              adherentProvider.getAdherent.havePaid != true && adherentProvider.getAdherent.adherentPlan != 0 ? GestureDetector(
                                onTap: ()=>Navigator.pushNamed(context, '/contributions'),
                                child: NotificationCard(
                                  isprestataire: false,
                                  instruction: "Ouvrir la Page...",
                                  description: "Vous n'avez pas encore payé votre souscription",
                                ),
                              ) : Container(),

                              enable && adherentProvider.getAdherent.familyDoctorId != null && !(adherentProvider.getAdherent.havePaid != true && adherentProvider.getAdherent.adherentPlan != 0) ?  NotificationCard(
                                  isprestataire: false,
                                  instruction: "",
                                  description: "Aucune notifications pour le moment",
                                ) : Container()
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
        /*Container(
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
        ),*/
        SizedBox(height: hv*4)
      ],
    ) :
    Center(child: Loaders().buttonLoader(kPrimaryColor));
  }

  Widget flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
    ) {
  return DefaultTextStyle(
    style: DefaultTextStyle.of(toHeroContext).style,
    child: toHeroContext.widget,
  );
}
}