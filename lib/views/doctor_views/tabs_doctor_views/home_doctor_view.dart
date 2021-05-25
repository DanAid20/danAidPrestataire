import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/config_size.dart';
import '../../../core/utils/config_size.dart';
import '../../../helpers/colors.dart';
import '../../../widgets/home_page_mini_components.dart';
import '../../../widgets/notification_card.dart';

class HomeDoctorView extends StatefulWidget {
  HomeDoctorView({Key key}) : super(key: key);

  @override
  _HomeDoctorViewState createState() => _HomeDoctorViewState();
}

class _HomeDoctorViewState extends State<HomeDoctorView> {

  
Widget notificationWidget(BuildContext context){
   UserProvider userProvider = Provider.of<UserProvider>(context);
   bool isPrestataire=userProvider.getProfileType== serviceProvider ? true : false;
   DoctorModelProvider doctor= Provider.of<DoctorModelProvider>(context);
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
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 20.0,
              offset: Offset(0.0, 0.75),
              spreadRadius: -15.0)
        ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  doctor.getDoctor.about==null ||doctor.getDoctor.address==null||doctor.getDoctor.availability==null ||doctor.getDoctor.avatarUrl==null || doctor.getDoctor.cniName==null ||doctor.getDoctor.gender==null ||doctor.getDoctor.speciality==null || doctor.getDoctor.hospitalRegion==null ||
                  doctor.getDoctor.hospitalTown==null ||doctor.getDoctor.keywords==null ||doctor.getDoctor.location==null ||
                  doctor.getDoctor.medicalService==null ||
                  doctor.getDoctor.officeCategory==null ||
                  doctor.getDoctor.officeName==null ||
                  doctor.getDoctor.orderRegistrationCertificate==null ||
                  doctor.getDoctor.personContactName==null ||
                  doctor.getDoctor.personContactPhone==null ||
                  doctor.getDoctor.phoneKeywords==null ||
                  doctor.getDoctor.profileEnabled==null 
                  ? 
                  NotificationCard(instruction: "completer",islinkEnable: true, description:"veuillez completer les informations relaif a votre profil pour nous aider a mieux vous faire connaître  ",isprestataire: isPrestataire)
                 :Center(child: Text('Aucune Notification '),),
                  

                 ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
 /// this function get the details of user
 List<String> getRecapActivitieOfTheDay(BuildContext context){
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List<String> avatarList;
    if(userProvider.getProfileType== serviceProvider){
      /** get the details of userImageProfileList In firebase  */
    }else if(userProvider.getProfileType== doctor){
      /** get the details of userList In data base  */
    }
    return avatarList;
 }

 ///  this function get the details interaction of userCount of the day 
 Map<String, int> getDetailsInteractionTheDay(BuildContext context){
    UserProvider userProvider = Provider.of<UserProvider>(context);
    Map<String, int> interActionCOunt;
    if(userProvider.getProfileType== serviceProvider){
      /** get the details of userImageProfileList In firebase  */
    }else if(userProvider.getProfileType== doctor){
      /** get the details of userList In data base  */
    }
    return interActionCOunt ;
 }

Widget recapActivitieOfTheDay(BuildContext context) {
  //List<String> getRecapActivitieOfTheDayData= await getRecapActivitieOfTheDay(context)
  //Map<String, int> getDetailsInteractionTheDayData= await getDetailsInteractionTheDay(context)
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
                  // we will just add foreach here to display de image 
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
                  HomePageComponents().getProfileStat(imgUrl: "assets/icons/posts.svg",title: "Posts",occurence: 72),
                  HomePageComponents().verticalDivider(),
                  HomePageComponents().getProfileStat(imgUrl: "assets/icons/chat.svg",title: "Commentaires",occurence: 122),
                  HomePageComponents().verticalDivider(),
                  HomePageComponents().getProfileStat(imgUrl: "assets/icons/2users.svg",title: "Followers",occurence: 21),
                  HomePageComponents().verticalDivider(),
                  HomePageComponents().getProfileStat(imgUrl: "assets/icons/message.svg",title: "Messages",occurence: 3),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          HomePageComponents().getDoctorQuestion(imgUrl: "assets/images/avatar-profile.jpg",likeCount: 1,sendcountNumber: 13,userName: 'Fabrice Mbanga',timeAgo: "il y 5 min", text:'Docta, que reccomendez vous en cas de fièvre de plus de 40’ de l’enfant?',commentCount: 3),
          HomePageComponents().getDoctorQuestion(imgUrl: "assets/images/avatar-profile.jpg",likeCount: 1,sendcountNumber: 13,userName: 'Fabrice Mbanga', timeAgo: "il y 5 min",text:'Docta, que reccomendez vous en cas de fièvre de plus de 40’ de l’enfant?',commentCount: 3),
          HomePageComponents().getDoctorQuestion(imgUrl: "assets/images/avatar-profile.jpg",likeCount: 1,sendcountNumber: 13,userName: 'Fabrice Mbanga',timeAgo: "il y 5 min",text:'Docta, que reccomendez vous en cas de fièvre de plus de 40’ de l’enfant?',commentCount: 3),
          HomePageComponents().getDoctorQuestion( imgUrl: "assets/images/avatar-profile.jpg",likeCount: 1,sendcountNumber: 13,userName: 'Fabrice Mbanga',timeAgo: "il y 5 min",text:'Docta, que reccomendez vous en cas de fièvre de plus de 40’ de l’enfant?',commentCount: 3),
        ],
      )
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          notificationWidget(context),
          Container( color: Colors.white,child: Column(
            children: [
              recapActivitieOfTheDay(context),
              questionDuDocteur(),
            ],
          ))
        ],
      ),
    );
  }
}
