import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/social_network_views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class GroupMembers extends StatefulWidget {
  final String? groupId;
  final List? groupMembers;
  const GroupMembers({ Key? key, this.groupId, this.groupMembers }) : super(key: key);

  @override
  _GroupMembersState createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {
  Widget getFriendsList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("USERS").where(FieldPath.documentId, whereIn: widget.groupMembers).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return snapshot.data!.docs.length >= 1 ? ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot userSnapshot = snapshot.data!.docs[index];
            UserModel singleUser = UserModel.fromDocument(userSnapshot);
            return userBox(
              user: singleUser
            );
          },
        ) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: hv*15,),
              Icon(LineIcons.userPlus, color: Colors.grey[400], size: 85,),
              SizedBox(height: 5,),
              Text(S.of(context)!.nhsitezPasFaireUneDemandeDami, 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[400] )
              , textAlign: TextAlign.center,),
            ],
          ),
        );
      },
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: getFriendsList()),
    );
  }

  Widget userBox({required UserModel user}){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: user.imgUrl != null
              ? CachedNetworkImageProvider(user.imgUrl!)
              : null,
          child: user.imgUrl != null ? Container() : Icon(LineIcons.user, color: whiteColor,),
        ),
        title: Text(user.fullName!, style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold),),
        subtitle: Text(user.profileType!),
        //subtitle: Text("Joined: " + DateFormat("dd MMMM, yyyy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch((int.parse(user.createdAt))))),
        onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(userId: user.userId!),),),
      ),
    );
  }
}