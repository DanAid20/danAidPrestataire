import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/conversationModel.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/conversationModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  
  final String? userId;

  const ProfilePage({ Key? key, this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  UserModel? user;
  int publications = 0;
  int comments = 0;
  int friends = 0;
  List targetFriends = [];
  List targetFriendRequests = [];

  bool friendSpinner = false;

  getUserProfile() async {
    await FirebaseFirestore.instance.collection('USERS').doc(widget.userId).get().then((docSnapshot) {
      UserModel user = UserModel.fromDocument(docSnapshot, docSnapshot.data() as Map);
      setState(() {
        this.user = user;
      });
      FirebaseFirestore.instance.collection('POSTS').where('userId', isEqualTo: widget.userId).get().then((doc) {
        publications = doc.docs.length;
        setState((){});
      });
    });
    
    targetFriends = user != null ? user?.friends != null ? user!.friends! : [] : [];
    targetFriendRequests = user != null ? user?.friendRequests != null ? user!.friendRequests! : [] : [];
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserProfile();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    friends = user != null ? user?.friends != null ? user!.friends!.length : 0 : 0;
    comments = user != null ? user?.comments != null ? user!.comments! : 0 : 0;
    print(targetFriendRequests.toString());
    return Scaffold(
      backgroundColor: kDeepTeal,
      appBar: AppBar(
        backgroundColor: kDeepTeal,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: whiteColor,), onPressed: ()=>Navigator.pop(context)),
        //title: Text("Créer un groupe", style: TextStyle(color: whiteColor),)
      ),
      body: user != null ? Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: wv*5),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.grey[900]!.withOpacity(0.6), blurRadius: 2.5, spreadRadius: 1.5, offset: Offset(0,3))]
                      ),
                      child: Container(
                        height: 200,
                        padding: EdgeInsets.symmetric(vertical: hv*1.5, horizontal: wv*2),
                        decoration: BoxDecoration(
                          color: kDeepTeal.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("${user?.points} Pts", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 17),)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: hv*1,),
                    Padding(
                      padding: EdgeInsets.only(left: 130),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user!.fullName!, style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 18)),
                          Text("${user!.regionOfOrigin}, ${user!.countryName}", style: TextStyle(color: whiteColor.withOpacity(0.5), fontWeight: FontWeight.bold, fontSize: 14))
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.grey[900]!.withOpacity(0.6), blurRadius: 2.5, spreadRadius: 1.5, offset: Offset(0,3))]
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: user!.imgUrl != null ? CachedNetworkImageProvider(user!.imgUrl!) : null,
                    ),
                  ),
                )
              ],
            ),
          ),
          Text(""),
          SizedBox(height: hv*2,),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: wv*3),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: hv*7,),
                        Text(S.of(context).activit, style: TextStyle(color: kDeepTeal, fontSize: 16)),
                        SizedBox(height: hv*2,),
                        Row(children: [
                          HomePageComponents().getProfileStat(imgUrl: "assets/icons/posts.svg", title: S.of(context).publications, occurence: publications, color: kSouthSeas, context: context),
                          HomePageComponents().verticalDivider(),
                          HomePageComponents().getProfileStat(imgUrl: "assets/icons/chat.svg", title: S.of(context).commentaires, occurence: comments, color: kSouthSeas, context: context),
                          HomePageComponents().verticalDivider(),
                          HomePageComponents().getProfileStat(imgUrl: "assets/icons/2users.svg", title: S.of(context).amis, occurence: friends, color: kSouthSeas, context: context),
                        ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                      ],
                    ),
                  ),
                ),
                userProvider.getUserModel?.userId != user?.userId ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    user?.isDanAIdAccount != true && userProvider.getUserModel?.isDanAIdAccount != true  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.grey[900]!.withOpacity(0.4), blurRadius: 2.5, spreadRadius: 1.5, offset: Offset(0,3))]
                          ),
                          child: SvgPicture.asset("assets/icons/Bulk/Send.svg", width: 30, color: kSouthSeas,),
                        ),
                        SizedBox(width: 20,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: !friendSpinner ? [BoxShadow(color: Colors.grey[900]!.withOpacity(0.4), blurRadius: 2, spreadRadius: 1, offset: Offset(0,3))] : []
                          ),
                          child: user?.profileType != doctor ? !friendSpinner ? TextButton(
                            child: Text(
                              targetFriends.contains(userProvider.getUserModel?.userId) ? S.of(context).rtirerLami : targetFriendRequests.contains(userProvider.getUserModel!.userId) ? S.of(context).annulerLaDemande : S.of(context).ajouterUnAmi, 
                              style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 15.5)
                            ),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                              backgroundColor: MaterialStateProperty.all(kSouthSeas),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))))
                            ),
                            onPressed: (){
                              setState((){
                                friendSpinner = true;
                              });

                              if(targetFriendRequests.contains(userProvider.getUserModel!.userId)){
                                FirebaseFirestore.instance.collection("USERS").doc(user!.userId).set({'friendRequests': FieldValue.arrayRemove([userProvider.getUserModel!.userId])}, SetOptions(merge: true)).then((doc){
                                  setState((){
                                    friendSpinner = false;
                                    targetFriendRequests.remove(userProvider.getUserModel!.userId);
                                  });
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).demandeAnnule)));
                              }
                              else {
                                FirebaseFirestore.instance.collection("USERS").doc(user!.userId).set({'friendRequests': FieldValue.arrayUnion([userProvider.getUserModel!.userId])}, SetOptions(merge: true)).then((doc){
                                  setState((){
                                    friendSpinner = false;
                                    targetFriendRequests.add(userProvider.getUserModel!.userId);
                                  });
                                  print(targetFriendRequests.toString());
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).demandeEnvoye)));
                              }

                              if(targetFriends.contains(userProvider.getUserModel!.userId)){
                                FirebaseFirestore.instance.collection("USERS").doc(user!.userId).set({'friends': FieldValue.arrayRemove([userProvider.getUserModel!.userId])}, SetOptions(merge: true)).then((doc){
                                  setState((){
                                    friendSpinner = false;
                                    targetFriends.remove(userProvider.getUserModel!.userId);
                                    targetFriendRequests.remove(userProvider.getUserModel!.userId);
                                  });
                                });
                                FirebaseFirestore.instance.collection("USERS").doc(userProvider.getUserModel!.userId).set({'friends': FieldValue.arrayRemove([user!.userId])}, SetOptions(merge: true)).then((doc){
                                  setState((){
                                    friendSpinner = false;
                                  });
                                  userProvider.removeFriend(user!.userId!);
                                });
                              }
                              
                            },
                          ) : Loaders().buttonLoader(kSouthSeas) : Text(""),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: (){
                            if(user?.friends != null || userProvider.getUserModel?.isDanAIdAccount == true){
                              if(user!.friends!.contains(userProvider.getUserModel?.userId) || userProvider.getUserModel?.isDanAIdAccount == true){
                                ConversationModelProvider conversation = Provider.of<ConversationModelProvider>(context, listen: false);
                                ConversationModel conversationModel = ConversationModel(
                                  conversationId: Algorithms.getConversationId(userId: userProvider.getUserModel!.authId, targetId: user!.authId),
                                  userId: userProvider.getUserModel!.authId,
                                  targetId: user!.authId,
                                  userName: userProvider.getUserModel?.fullName,
                                  targetName: user?.fullName,
                                  userAvatar: userProvider.getUserModel?.imgUrl,
                                  targetAvatar: user?.imgUrl,
                                  targetProfileType: user?.profileType,
                                  userPhoneId: userProvider.getUserModel?.userId,
                                  targetPhoneId: user?.userId
                                );
                                conversation.setConversationModel(conversationModel);
                                Navigator.pushNamed(context, '/conversation');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).seulsLesAmisPeuventConverser)));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).seulsLesAmisPeuventConverser)));
                            }
                            
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.grey[900]!.withOpacity(0.4), blurRadius: 2.5, spreadRadius: 1.5, offset: Offset(0,3))]
                            ),
                            child: SvgPicture.asset("assets/icons/chat.svg", width: 30, color: kSouthSeas,),
                          ),
                        ),
                      ],
                    ) 
                    :
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: wv*10),
                      child: CustomTextButton(
                        text: user?.isDanAIdAccount == true ? "Ecrire au support DanAid" : "Ecrire à l'utilisateur",
                        color: kSouthSeas,
                        noPadding: true,
                        action: (){
                          ConversationModelProvider conversation = Provider.of<ConversationModelProvider>(context, listen: false);
                          ConversationModel conversationModel = ConversationModel(
                            conversationId: Algorithms.getConversationId(userId: userProvider.getUserModel!.authId, targetId: user?.authId),
                            userId: userProvider.getUserModel?.authId,
                            targetId: user?.authId,
                            userName: userProvider.getUserModel?.fullName,
                            targetName: user?.fullName,
                            userAvatar: userProvider.getUserModel?.imgUrl,
                            targetAvatar: user?.imgUrl,
                            targetProfileType: user?.profileType,
                            userPhoneId: userProvider.getUserModel?.userId,
                            targetIsSupport: user?.isDanAIdAccount,
                            targetPhoneId: user?.userId
                          );
                          conversation.setConversationModel(conversationModel);
                          Navigator.pushNamed(context, '/conversation');
                        },
                      ),
                    ),
                  ],
                ) : GestureDetector(
                  onTap: ()=>Navigator.pushNamed(context, '/adherent-profile-edit'),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.grey[900]!.withOpacity(0.4), blurRadius: 2.5, spreadRadius: 1.5, offset: Offset(0,3))]
                            ),
                            child: SvgPicture.asset("assets/icons/Bulk/Edit.svg", width: 30, color: kSouthSeas,),
                          ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(whiteColor),)),
      
    );
  }
}