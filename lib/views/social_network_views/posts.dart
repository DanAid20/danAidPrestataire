import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/social_network_widgets/post_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:danaid/core/models/postModel.dart';
import 'package:line_icons/line_icons.dart';
import 'package:simple_tags/simple_tags.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("POSTS").orderBy("dateCreated", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return snapshot.data.docs.length >= 1 ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data.docs[index];
            PostModel post = PostModel.fromDocument(doc);
            return PostContainer(post: post);
          },
        ) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Icon(LineIcons.userShield, color: Colors.grey[400], size: 85,),
              SizedBox(height: 5,),
              Text(S.of(context).aucunGroupePourLeMoment, 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[400] )
              , textAlign: TextAlign.center,),
            ],
          ),
        );
      }
    );
  }

}