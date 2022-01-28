import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:danaid/core/models/postModel.dart';
import 'package:line_icons/line_icons.dart';
import 'package:danaid/widgets/social_network_widgets/post_cards.dart';

class Discussions extends StatefulWidget {
  @override
  _DiscussionsState createState() => _DiscussionsState();
}

class _DiscussionsState extends State<Discussions> {
  int limit = 10;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("POSTS").where('post-type', isEqualTo: 1).orderBy("dateCreated", descending: true).limit(limit).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return snapshot.data!.docs.length >= 1 ? NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            var metrics = scrollEnd.metrics;
            if (metrics.atEdge) {
              if (metrics.pixels == 0) print('At top');
              else setState(() {limit = limit + 5;});
            }
            return true;
          },
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              PostModel post = PostModel.fromDocument(doc);
              return PostContainer(post: post);
            },
          ),
        ) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Icon(LineIcons.comment, color: Colors.grey[400], size: 85,),
              SizedBox(height: 5,),
              Text(S.of(context)!.aucuneDiscussionPourLeMoment, 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[400] )
              , textAlign: TextAlign.center,),
            ],
          ),
        );
      }
    );
  }
}