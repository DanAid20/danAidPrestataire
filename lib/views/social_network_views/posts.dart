import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
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
            return getDiscussionContainers(post: post);
          },
        ) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Icon(LineIcons.userShield, color: Colors.grey[400], size: 85,),
              SizedBox(height: 5,),
              Text("Aucun groupe pour le moment", 
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
}