import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class FriendRequests extends StatefulWidget {
  const FriendRequests({ Key? key }) : super(key: key);

  @override
  _FriendRequestsState createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {

  loadUserProfile() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    FirebaseFirestore.instance.collection('USERS').doc(userProvider.getUserModel!.userId).get().then((docSnapshot) {
      UserModel user = UserModel.fromDocument(docSnapshot, docSnapshot.data()!);
      userProvider.setUserModel(user);
      print(userProvider.getUserModel!.friendRequests.toString());
    });
  }

  int accept = -1;
  int decline = -1;

  @override
  void initState() {
    super.initState();
    //loadUserProfile();
  }
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: kDeepTeal,
      appBar: AppBar(
        backgroundColor: kDeepTeal,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: whiteColor,), onPressed: ()=>Navigator.pop(context)),
        centerTitle: true,
        title: Text(S.of(context).demandesDamiti, style: TextStyle(color: whiteColor, fontSize: 18, fontWeight: FontWeight.w600))
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('USERS').doc(userProvider.getUserModel!.userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(kSouthSeas),));
          }
          UserModel user = UserModel.fromDocument(snapshot.data!, snapshot.data?.data() as Map);

          return user.friendRequests != null && user.friendRequests!.isNotEmpty ? StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("USERS").where(FieldPath.documentId, whereIn: user.friendRequests).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(kSouthSeas),));
            }
            return snapshot.data!.docs.length >= 1 ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                UserModel user = UserModel.fromDocument(doc, doc.data() as Map);
                return getRequestBox(user: user);
              },
            ) :
            Container(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50,),
                  Icon(LineIcons.comment, color: whiteColor, size: 85,),
                  SizedBox(height: 5,),
                  Text(S.of(context).aucuneDmandeDamiti, 
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: whiteColor )
                  , textAlign: TextAlign.center,),
                ],
              ),
            );
          }
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 50,),
                        Icon(LineIcons.comment, color: whiteColor, size: 85,),
                        SizedBox(height: 5,),
                        Text(S.of(context).aucuneDmandeDamiti, 
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: whiteColor )
                        , textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
            ],
          );
        }
      )
    );
  }

  Widget getRequestBox({required UserModel user, int? index}){
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      margin: EdgeInsets.only(bottom: hv*1.5, right: wv*3, left: wv*3),
      padding: EdgeInsets.symmetric(horizontal: wv*2.5, vertical: hv*1.5),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            backgroundImage: user.imgUrl != null ? CachedNetworkImageProvider(user.imgUrl!) : null,
            child: user.imgUrl == null ? Icon(LineIcons.user, color: whiteColor,) : null,
          ),
          SizedBox(width: wv*2),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullName!, style: TextStyle(color: kTextBlue, fontSize: 15, fontWeight: FontWeight.bold),),
                Text(
                  user.profileType == adherent ? "Adhérent" : user.profileType == doctor ? "Médecin" : "Prestataire",
                  style: TextStyle(color: Colors.grey[700], fontSize: 13)
                )
              ],
            ),
          ),
          SizedBox(width: wv*1),
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: "Accepter",
                    fontSize: 12,
                    isLoading: accept == index,
                    color: kDeepTeal,
                    noPadding: true,
                    action: (){
                      setState((){
                        accept = index!;
                      });
                      
                      FirebaseFirestore.instance.collection("USERS").doc(user.userId).set({'friends': FieldValue.arrayUnion([userProvider.getUserModel!.userId])}, SetOptions(merge: true)).then((doc){
                        setState((){
                          accept = -1;
                        });
                      });
                      FirebaseFirestore.instance.collection("USERS").doc(userProvider.getUserModel!.userId).set({'friends': FieldValue.arrayUnion([user.userId])}, SetOptions(merge: true)).then((doc){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vous êtes désormais amis !")));
                        userProvider.addFriend(user.userId!);
                      });

                      FirebaseFirestore.instance.collection("USERS").doc(userProvider.getUserModel!.userId).set({'friendRequests': FieldValue.arrayRemove([user.userId])}, SetOptions(merge: true)).then((doc){
                        userProvider.removeFriendRequest(user.userId!);
                        setState((){
                          accept = -1;
                        });
                      });
                    },
                  ),
                ),
                SizedBox(width: wv*1.5),
                Expanded(
                  child: CustomTextButton(
                    text: "Réfuser",
                    fontSize: 12,
                    isLoading: decline == index,
                    color: kSouthSeas,
                    noPadding: true,
                    action: (){
                      setState((){
                        decline = index!;
                      });
                      FirebaseFirestore.instance.collection("USERS").doc(userProvider.getUserModel!.userId).set({'friendRequests': FieldValue.arrayRemove([user.userId])}, SetOptions(merge: true)).then((doc){
                        userProvider.removeFriendRequest(user.userId!);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Demande refusée")));
                      setState((){
                        decline = -1;
                      });
                    },
                  ),
                ),
              ],),
          ),
        ],
      ),
    );
  }
}