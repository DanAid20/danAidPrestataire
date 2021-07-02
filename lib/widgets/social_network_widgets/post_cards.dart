import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/postModel.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/social_network_views/profile_page.dart';
import 'package:danaid/views/social_network_views/edit_post.dart';
import 'package:danaid/views/social_network_views/post_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:simple_tags/simple_tags.dart';

class PostContainer extends StatelessWidget {
  final PostModel post;
  final String groupId;
  const PostContainer({ Key key, this.post, this.groupId }) : super(key: key);

  void handleClick(int value){
    switch (value) {
      case 0:
        break;
      case 1:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String time = Algorithms.getTimeElapsed(date: post.dateCreated.toDate());
    List<String> tags = [];
    for(int i = 0; i < post.tags.length; i++){
      tags.add(post.tags[i]);
    }
    List likes = (post.likesList != null) ? post.likesList : [];

    DocumentReference normalRef = FirebaseFirestore.instance.collection("POSTS").doc(post.id);
    DocumentReference groupRef = FirebaseFirestore.instance.collection("GROUPS").doc(groupId).collection("POSTS").doc(post.id);
    DocumentReference docRef = groupId == null ? normalRef : groupRef;

    return InkWell(
      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetails(post: post),),),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*3),
        decoration: BoxDecoration(
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(userId: post.userId),),);
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: post.userAvatar != null ? CachedNetworkImageProvider(post.userAvatar) : null,
                child: post.userAvatar == null ? Icon(LineIcons.user, color: whiteColor,) : Container(),
              ),
            ),
            SizedBox(width: wv*3,),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.userName, style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.w900),),
                          Text("Il ya "+time, style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Spacer(),
                      //IconButton(icon: Icon(Icons.more_horiz), padding: EdgeInsets.all(0), constraints: BoxConstraints(), onPressed: (){}),
                      PopupMenuButton<int>(
                        color: kDeepTeal,
                        onSelected: (int value){
                          switch (value) {
                            case 0:
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditPost(post: post, groupId: groupId,),),);
                              break;
                            case 1:
                              docRef.collection("SIGNALEMENTS_POST").add({
                                "complainantId": userProvider.getUserModel.userId,
                                "complainantAuthId": FirebaseAuth.instance.currentUser.uid,
                                "postId": post.id,
                                "dateCreated": DateTime.now()
                              }).then((value){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post signalé !")));
                              })
                                .catchError((e){
                                  print(e.toString());
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              });
                              break;
                            case 2:
                              docRef.delete().then((value){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post supprimé avec succès !")));});
                              break;
                            case 3:
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(userId: post.userId),),);
                              break;
                          }
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        icon: Padding(
                          padding: EdgeInsets.only(bottom: 50),
                          child: Icon(Icons.more_horiz, color: kDeepTeal,),
                        ),
                        padding: EdgeInsets.all(0),
                        itemBuilder: (context) => [
                          userProvider.getUserModel.userId == post.userId ? PopupMenuItem(
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/Bulk/Edit.svg', color: whiteColor.withOpacity(0.7), width: 25,),
                                SizedBox(width: wv*1.5,),
                              Text("Editer", style: TextStyle(color: whiteColor.withOpacity(0.7),),),
                              ],
                            ),
                            value: 0,
                          )
                          :
                          PopupMenuItem(
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/Two-tone/NotificationChat.svg', color: whiteColor.withOpacity(0.7),),
                                SizedBox(width: wv*1.5,),
                                Text("Signaler", style: TextStyle(color: whiteColor.withOpacity(0.7),),),
                              ],
                            ),
                            value: 1,
                          ),
                          userProvider.getUserModel.userId == post.userId ? PopupMenuItem(
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/Bulk/Delete.svg', color: whiteColor.withOpacity(0.7),),
                                SizedBox(width: wv*1.5,),
                                Text("Supprimer", style: TextStyle(color: whiteColor.withOpacity(0.7),)),
                              ],
                            ),
                            value: 2,
                          ) : PopupMenuItem(
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/Two-tone/Profile.svg', color: whiteColor.withOpacity(0.7),),
                                SizedBox(width: wv*1.5,),
                                Text("Voir le profil", style: TextStyle(color: whiteColor.withOpacity(0.7),),),
                              ],
                            ),
                            value: 3,
                          )
                        ]
                      )
                    ],
                  ),
                  SizedBox(height: hv*1.0,),
                  post.title != null ? Column(
                    children: [
                      Text(post.title, style: TextStyle(color: kTextBlue, fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(height: hv*0.5,),
                    ],
                  ) : Container(),
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
                        child: InkWell(
                          onTap: (){
                            print(post.likesList.toString());
                            if(!likes.contains(userProvider.getUserModel.userId)){
                              print("like");
                              FirebaseFirestore.instance.collection('POSTS').doc(post.id).set({
                                "likesList": FieldValue.arrayUnion([userProvider.getUserModel.userId]),
                              }, SetOptions(merge: true));
                            } else {
                              print("dislike");
                              FirebaseFirestore.instance.collection('POSTS').doc(post.id).set({
                                "likesList": FieldValue.arrayRemove([userProvider.getUserModel.userId]),
                              }, SetOptions(merge: true));
                            }
                          },
                          child: Row(children: [
                            SvgPicture.asset('assets/icons/Bulk/Heart.svg'),
                            SizedBox(width: wv*1.5),
                            Text(likes.length.toString())
                          ],),
                        ),
                      ),
                      Expanded(
                        child: Row(children: [
                          SvgPicture.asset('assets/icons/Bulk/Chat.svg'),
                          SizedBox(width: wv*1.5),
                          Text(post.comments != null ? post.comments.toString() : "0")
                        ],),
                      ),
                      Expanded(
                        child: Row(children: [
                          SvgPicture.asset('assets/icons/Bulk/Send.svg'),
                          SizedBox(width: wv*1.5),
                          Text("")
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
      ),
    );
  }
}