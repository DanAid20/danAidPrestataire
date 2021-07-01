import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/groupModel.dart';
import 'package:danaid/core/models/postModel.dart';
import 'package:danaid/widgets/social_network_widgets/post_cards.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class GroupFeeds extends StatefulWidget {
  final GroupModel group;
  const GroupFeeds({ Key key, this.group }) : super(key: key);

  @override
  _GroupFeedsState createState() => _GroupFeedsState();
}

class _GroupFeedsState extends State<GroupFeeds> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("GROUPS").doc(widget.group.groupId).collection("POSTS").orderBy("dateCreated", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return snapshot.data.docs.length >= 1 ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data.docs[index];
            PostModel post = PostModel.fromDocument(doc);
            return PostContainer(post: post, groupId: widget.group.groupId);
          },
        ) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Icon(LineIcons.userShield, color: Colors.grey[400], size: 85,),
              SizedBox(height: 5,),
              Text("Aucun posts pour le moment", 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[400] )
              , textAlign: TextAlign.center,),
            ],
          ),
        );
      }
    );
  }
}