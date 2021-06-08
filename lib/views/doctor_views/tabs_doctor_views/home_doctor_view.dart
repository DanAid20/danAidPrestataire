import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/postModel.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:simple_tags/simple_tags.dart';

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
                 userProvider.isEnabled==false 
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
              // Row(
              //   children: [
              //     Text(
              //       "Aujourd'hui",
              //       style: TextStyle(
              //           color: kPrimaryColor, fontWeight: FontWeight.w700),
              //     ),
              //     Text("Voir plus..")
              //   ],
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // ),
              // SizedBox(
              //   height: hv * 2,
              // ),
              // Row(
              //   children: [
              //     // we will just add foreach here to display de image 
              //     HomePageComponents().getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
              //     HomePageComponents().getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
              //     HomePageComponents().getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
              //     HomePageComponents().getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
              //     HomePageComponents().getAvatar(imgUrl: "assets/images/avatar-profile.jpg"),
              //     Expanded(child: Container()),
              //     Container(
              //       padding: EdgeInsets.all(10),
              //       decoration: BoxDecoration(
              //           color: Colors.grey.withOpacity(0.3),
              //           borderRadius: BorderRadius.circular(100)),
              //       child: Text(
              //         "+ 150 Autres...",
              //         style: TextStyle(
              //             fontWeight: FontWeight.w800, color: kPrimaryColor),
              //       ),
              //     )
              //   ],
              // ),
              // SizedBox(
              //   height: hv * 2,
              // ),
              // Row(
              //   children: [
              //     HomePageComponents().getProfileStat(imgUrl: "assets/icons/posts.svg",title: "Posts",occurence: 72),
              //     HomePageComponents().verticalDivider(),
              //     HomePageComponents().getProfileStat(imgUrl: "assets/icons/chat.svg",title: "Commentaires",occurence: 122),
              //     HomePageComponents().verticalDivider(),
              //     HomePageComponents().getProfileStat(imgUrl: "assets/icons/2users.svg",title: "Followers",occurence: 21),
              //     HomePageComponents().verticalDivider(),
              //     HomePageComponents().getProfileStat(imgUrl: "assets/icons/message.svg",title: "Messages",occurence: 3),
              //   ],
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // ),
              // SizedBox(
              //   height: hv * 1,
              // )
            ],
          ),
        ),
      ),
      SizedBox(height: hv * 0.8)
    ],
  );
}
getDetailDocotor(){
  return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("POSTS").where('post-type', isEqualTo: 0).orderBy("dateCreated", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return snapshot.data.docs.length >= 1 ? ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data.docs[index];
            PostModel post = PostModel.fromDocument(doc);
            return getDiscussionContainers(post: post);
          },
        ) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Icon(LineIcons.comment, color: Colors.grey[400], size: 85,),
              SizedBox(height: 5,),
              Text("Aucune discussion pour le moment", 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[400] )
              , textAlign: TextAlign.center,),
            ],
          ),
        );
      }
    );
}
 getDiscussionContainers({PostModel post}){
    String time = Algorithms.getTimeElapsed(date: post.dateCreated.toDate());
    List<String> tags = [];
    for(int i = 0; i < post.tags.length; i++){
      tags.add(post.tags[i]);
    }

    return Container(
          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1),
          decoration: BoxDecoration(
            color: whiteColor,
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: post.userAvatar != null ? CachedNetworkImageProvider(post.userAvatar) : null,
                child: post.userAvatar == null ? Icon(LineIcons.user, color: whiteColor,) : Container(),
              ),
              SizedBox(width: wv*3,),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.userName, style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.w900),),
                    Text("Il ya "+time, style: TextStyle(fontSize: 12)),
                    SizedBox(height: hv*1.5,),
                    Text(post.text, style: TextStyle(color: Colors.black87)),
                    post.imgUrl != null ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: wv*3, top: hv*1),
                            height: hv*15,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [BoxShadow(color: Colors.grey[500], blurRadius: 2.5, spreadRadius: 1.2, offset: Offset(0, 1.5))],
                              image: DecorationImage(image: CachedNetworkImageProvider(post.imgUrl), fit: BoxFit.cover)
                            ),
                          ),
                        ),
                      ],
                    ) : Container(),

                    post.postType == 1 && post.tags.length >= 1 ? Padding(
                      padding: EdgeInsets.only(top: hv*2),
                      child: SimpleTags(
                        content: tags,
                        wrapSpacing: 4,
                        wrapRunSpacing: 4,
                        tagContainerPadding: EdgeInsets.all(6),
                        tagTextStyle: TextStyle(color: kPrimaryColor),
                        tagContainerDecoration: BoxDecoration(
                          color: kSouthSeas.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ) : Container(),

                    SizedBox(height: hv*2,),

                    Row(
                      children: [
                        Expanded(
                          child: Row(children: [
                            SvgPicture.asset('assets/icons/Bulk/Heart.svg'),
                            SizedBox(width: wv*1.5),
                            Text("0")
                          ],),
                        ),
                        Expanded(
                          child: Row(children: [
                            SvgPicture.asset('assets/icons/Bulk/Chat.svg'),
                            SizedBox(width: wv*1.5),
                            Text("0")
                          ],),
                        ),
                        Expanded(
                          child: Row(children: [
                            SvgPicture.asset('assets/icons/Bulk/Send.svg'),
                            SizedBox(width: wv*1.5),
                            Text("0")
                          ],),
                        ),
                        Expanded(
                          child: Container(),
                        )
                      ],
                    ),
                    //
                  ],
                ),
              ),
            ],
          ),
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
      Container(
        margin: EdgeInsets.only(bottom: 75), 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HomePageComponents().getDoctorQuestion(imgUrl: "assets/images/avatar-profile.jpg",likeCount: 1,sendcountNumber: 13,userName: 'Fabrice Mbanga',timeAgo: "il y 5 min", text:'Docta, que reccomendez vous en cas de fièvre de plus de 40’ de l’enfant?',commentCount: 3),
            // HomePageComponents().getDoctorQuestion(imgUrl: "assets/images/avatar-profile.jpg",likeCount: 1,sendcountNumber: 13,userName: 'Fabrice Mbanga', timeAgo: "il y 5 min",text:'Docta, que reccomendez vous en cas de fièvre de plus de 40’ de l’enfant?',commentCount: 3),
            // HomePageComponents().getDoctorQuestion(imgUrl: "assets/images/avatar-profile.jpg",likeCount: 1,sendcountNumber: 13,userName: 'Fabrice Mbanga',timeAgo: "il y 5 min",text:'Docta, que reccomendez vous en cas de fièvre de plus de 40’ de l’enfant?',commentCount: 3),
            // HomePageComponents().getDoctorQuestion( imgUrl: "assets/images/avatar-profile.jpg",likeCount: 1,sendcountNumber: 13,userName: 'Fabrice Mbanga',timeAgo: "il y 5 min",text:'Docta, que reccomendez vous en cas de fièvre de plus de 40’ de l’enfant?',commentCount: 3),
            getDetailDocotor()
          ],
        ),
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
