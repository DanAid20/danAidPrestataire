import 'package:flutter/material.dart';

import '../../../core/utils/config_size.dart';
import '../../../core/utils/config_size.dart';
import '../../../helpers/colors.dart';
import '../../../widgets/home_page_mini_components.dart';
import '../../../widgets/notification_card.dart';

class HomePrestataireView extends StatefulWidget {
  HomePrestataireView({Key key}) : super(key: key);

  @override
  _HomePrestataireViewState createState() => _HomePrestataireViewState();
}

Widget notificationWidget() {
  return Column(
    children: [
      SizedBox(
        height: hv * 2.5,
      ),
      Container(
        margin:
            EdgeInsets.only(left: inch * 2, right: inch * 2, top: inch * 0.5),
        child: Row(
          children: [
            Text(
              "Notifications",
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),
            ),
            Text("Voir plus..")
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 20.0,
              offset: Offset(0.0, 0.75),
              spreadRadius: -15.0)
        ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  NotificationCard(
                    instruction: "consulter",
                    description:
                        "Vous avez 3 nouveaux devis pour vos examens médicaux",
                  ),
                  NotificationCard(
                    instruction: "consulter",
                    description:
                        "Vous avez 3 nouveaux devis pour vos examens médicaux",
                  ),
                  NotificationCard(
                    instruction: "consulter",
                    description:
                        "Vous avez 3 nouveaux devis pour vos examens médicaux",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget recapActivitieOfTheDay() {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: Colors.grey.withOpacity(0.3), width: 0.3)),
        ),
        padding: EdgeInsets.only(top: hv * 1),
        child: Container(
          margin: EdgeInsets.only(
              left: inch * 1.5, right: inch * 1.5, top: inch * 0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Aujourd'hui",
                    style: TextStyle(
                        color: kPrimaryColor, fontWeight: FontWeight.w700),
                  ),
                  Text("Voir plus..")
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              SizedBox(
                height: hv * 2,
              ),
              Row(
                children: [
                  HomePageComponents()
                      .getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
                  HomePageComponents()
                      .getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
                  HomePageComponents()
                      .getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
                  HomePageComponents()
                      .getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
                  HomePageComponents()
                      .getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
                  Expanded(child: Container()),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      "+ 150 Autres...",
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: kPrimaryColor),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: hv * 2,
              ),
              Row(
                children: [
                  HomePageComponents().getProfileStat(
                      imgUrl: "assets/icons/posts.svg",
                      title: "Posts",
                      occurence: 72),
                  HomePageComponents().verticalDivider(),
                  HomePageComponents().getProfileStat(
                      imgUrl: "assets/icons/chat.svg",
                      title: "Commentaires",
                      occurence: 122),
                  HomePageComponents().verticalDivider(),
                  HomePageComponents().getProfileStat(
                      imgUrl: "assets/icons/2users.svg",
                      title: "Followers",
                      occurence: 21),
                  HomePageComponents().verticalDivider(),
                  HomePageComponents().getProfileStat(
                      imgUrl: "assets/icons/message.svg",
                      title: "Messages",
                      occurence: 3),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              SizedBox(
                height: hv * 2,
              )
            ],
          ),
        ),
      ),
      SizedBox(height: hv * 0.8)
    ],
  );
}

Widget questionDuDocteur() {
  return Column(
    children: [
      Container(
        margin:
            EdgeInsets.only(left: inch * 1.5, right: inch * 1.5, top: inch * 0),
        child: Row(
          children: [
            Text(
              "Question au Docteur",
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),
            ),
            Text("Voir plus..")
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      Column(
        children: [
          HomePageComponents().getDoctorQuestion(
              imgUrl: "assets/images/avatar-profile.jpg",
              likeCount: 1,
              sendcountNumber: 13,
              userName: 'Fabrice Mbanga',
              timeAgo: "il y 5 min",
              text:
                  'Docta, que reccomendez vous en cas de fièvre de plus de 40’ de l’enfant?',
              commentCount: 3),
          HomePageComponents().getDoctorQuestion(
              imgUrl: "assets/images/avatar-profile.jpg",
              likeCount: 1,
              sendcountNumber: 13,
              userName: 'Fabrice Mbanga',
              timeAgo: "il y 5 min",
              text:
                  'Docta, que reccomendez vous en cas de fièvre de plus de 40’ de l’enfant?',
              commentCount: 3),
          HomePageComponents().getDoctorQuestion(
              imgUrl: "assets/images/avatar-profile.jpg",
              likeCount: 1,
              sendcountNumber: 13,
              userName: 'Fabrice Mbanga',
              timeAgo: "il y 5 min",
              text:
                  'Docta, que reccomendez vous en cas de fièvre de plus de 40’ de l’enfant?',
              commentCount: 3),
          HomePageComponents().getDoctorQuestion(
              imgUrl: "assets/images/avatar-profile.jpg",
              likeCount: 1,
              sendcountNumber: 13,
              userName: 'Fabrice Mbanga',
              timeAgo: "il y 5 min",
              text:
                  'Docta, que reccomendez vous en cas de fièvre de plus de 40’ de l’enfant?',
              commentCount: 3),
        ],
      )
    ],
  );
}

class _HomePrestataireViewState extends State<HomePrestataireView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          notificationWidget(),
          recapActivitieOfTheDay(),
          questionDuDocteur()
        ],
      ),
    );
  }
}
