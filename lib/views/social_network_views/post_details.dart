import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/postModel.dart';
import 'package:danaid/core/models/commentModel.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/social_network_views/profile_page.dart';
import 'package:danaid/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class PostDetails extends StatefulWidget {

  final PostModel post;

  const PostDetails({ Key key, this.post }) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _commentController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  FocusNode _commentFocusNode = new FocusNode();
  bool liked = false;
  List likes = [];

  init(){
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if(widget.post.likesList != null){
      setState((){likes = widget.post.likesList;});
      if(widget.post.likesList.contains(userProvider.getUserModel.userId)){
        setState((){liked = true;});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
    _commentFocusNode.addListener(() {
      _scrollController.jumpTo(-1.0);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, size: 25, color: whiteColor,), onPressed: ()=>Navigator.pop(context)),
        actions: [IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: whiteColor), onPressed: () => _scaffoldKey.currentState.openEndDrawer())],
      ),
      extendBodyBehindAppBar: true,
      endDrawer: DefaultDrawer(
        entraide: (){Navigator.pop(context); Navigator.pop(context);},
        accueil: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
        carnet: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
        partenaire: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
        famille: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            children: [
              Flexible(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  reverse: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 280,
                            decoration: BoxDecoration(
                              color: kDeepTeal,
                              image: widget.post.imgUrl != null ? DecorationImage(image: CachedNetworkImageProvider(widget.post.imgUrl), fit: BoxFit.cover) : null
                            ),
                            child: widget.post.imgUrl == null ? Image.asset('assets/icons/DanaidLogo.png') : null,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: hv*3, horizontal: wv*2.5),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [whiteColor.withOpacity(0.4), whiteColor.withOpacity(0.9), whiteColor],
                                stops: [0.0, 0.4, 1.0],
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                tileMode: TileMode.repeated
                              )
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.post.userId),),);
                                  },
                                  child: Hero(
                                    tag: "publisher",
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      radius: 25,
                                      backgroundImage: widget.post.userAvatar != null ? CachedNetworkImageProvider(widget.post.userAvatar) : null,
                                      child: widget.post.userAvatar == null ? Icon(LineIcons.user, color: whiteColor,) : Container(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: wv*2,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.post.userName, style: TextStyle(color: kTextBlue, fontSize: 16, fontWeight: FontWeight.w900),),
                                      Text(S.of(context).ilYa + Algorithms.getTimeElapsed(date: widget.post.dateCreated.toDate()), style: TextStyle(fontSize: 12, color: kTextBlue)),
                                    ],
                                  ),
                                ),
                                SizedBox(width: wv*1,),
                                //IconButton(icon: Icon(Icons.more_horiz), padding: EdgeInsets.all(0), constraints: BoxConstraints(), onPressed: (){}),
                                SvgPicture.asset('assets/icons/Bulk/Send.svg', width: 30, color: kSouthSeas),
                                SizedBox(width: wv*2.5,),
                                SvgPicture.asset('assets/icons/Bulk/HeartOutline.svg', width: 30, color: kSouthSeas,),
                                SizedBox(width: wv*0.5,),
                                Text(likes.length.toString(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kTextBlue)),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: wv*3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.post.title != null ? Container(
                            padding: EdgeInsets.only(bottom: hv*2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.post.title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: kTextBlue)),
                              ],
                            ),
                          ) : Container(),
                          Text(widget.post.text.toString(), style: TextStyle(fontSize: 14,  color: Colors.grey[700])),

                          SizedBox(height: hv*2,),

                          Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  if(!likes.contains(userProvider.getUserModel.userId)){
                                    FirebaseFirestore.instance.collection('POSTS').doc(widget.post.id).set({
                                      "likesList": FieldValue.arrayUnion([userProvider.getUserModel.userId]),
                                    }, SetOptions(merge: true)).then((value){setState((){liked = true; likes.add(userProvider.getUserModel.userId);});});
                                  } else {
                                    print("dislike");
                                    FirebaseFirestore.instance.collection('POSTS').doc(widget.post.id).set({
                                      "likesList": FieldValue.arrayRemove([userProvider.getUserModel.userId]),
                                    }, SetOptions(merge: true)).then((value){setState((){liked = false; likes.remove(userProvider.getUserModel.userId);});});
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  child: Row(children: [
                                    liked ? Icon(Icons.favorite, color: kSouthSeas, size: 28,) : SvgPicture.asset('assets/icons/Bulk/HeartOutline.svg', color: kSouthSeas, width: 28),
                                    SizedBox(width: wv*1.5),
                                    Text("Aimer", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextBlue))
                                  ],),
                                ),
                              ),
                              SizedBox(width: wv*3),
                              InkWell(
                                onTap: ()=>_commentFocusNode.requestFocus(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  child: Row(children: [
                                    SvgPicture.asset('assets/icons/Bulk/Chat.svg', width: 25),
                                    SizedBox(width: wv*1.5),
                                    Text(S.of(context).commenter, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextBlue))
                                  ],),
                                ),
                              ),
                              SizedBox(width: wv*3),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                child: Row(children: [
                                  SvgPicture.asset('assets/icons/Bulk/Send.svg', width: 25),
                                  SizedBox(width: wv*1.5),
                                  Text(S.of(context).partager, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextBlue))
                                ],),
                              )
                            ],
                          ),
                          ],
                        ),
                      ),

                      SizedBox(height: hv*3,),

                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("POSTS").doc(widget.post.id).collection("COMMENTAIRES").snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(kSouthSeas),),
                            );
                          }
                          List<CommentBox> comments = [];
                          for(int i = 0; i < snapshot.data.docs.length; i++){
                            comments.add(CommentBox(comment: CommentModel.fromDocument(snapshot.data.docs[i]),));
                          }
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: wv*3),
                            child: Column(
                              children: comments,
                            ),
                          );
                        }
                      ),

                      SizedBox(height: hv*13,)
                      
                    ],
                  ),
                ),
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                decoration: BoxDecoration(
                  color: kDeepTeal,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: Row(children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        TextField(
                          scrollPhysics: BouncingScrollPhysics(),
                          minLines: 1,
                          maxLines: 5,
                          controller: _commentController,
                          focusNode: _commentFocusNode,
                          style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600, fontSize: 15),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            //prefixIcon: SizedBox(width: wv*7,),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.red[300]),
                                borderRadius: BorderRadius.all(Radius.circular(20))),
                            fillColor: Colors.white.withOpacity(0.3),
                            //prefixIcon: Icon(Icons.search, color: kBrownCanyon,),
                            contentPadding: EdgeInsets.only(top: hv*1, bottom: hv*1, left: wv*3, right: wv*7),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: kDeepTeal.withOpacity(0.0)),
                                borderRadius: BorderRadius.all(Radius.circular(20))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.white.withOpacity(0.35)),
                                borderRadius: BorderRadius.all(Radius.circular(20))),
                            hintText: S.of(context).ecrireVotreCommentaire,
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                          ),
                        ),
                        /*IconButton(
                          color: Colors.white,
                          icon: SvgPicture.asset('assets/icons/Two-tone/Camera.svg', width: wv*7,),
                          //color: Colors.black45,
                          enableFeedback: true,
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            //showStickers();
                          },
                        ),
                        Positioned(
                          right: 5,
                          child: IconButton(
                            padding: EdgeInsets.all(4),
                            constraints: BoxConstraints(),
                            iconSize: 25,
                            icon: Icon(LineIcons.paperclip),
                            color: Colors.white.withOpacity(0.85),
                            enableFeedback: true,
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              //setState(() {showUploadMenu = !showUploadMenu;});
                              //getImage();
                            },
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  SizedBox(width: wv*3,),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(13),
                      child: Icon(LineIcons.angleRight, color: Colors.white,),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: () async {
                      sendComment(_commentController.text, 0);
                    },
                    borderRadius: BorderRadius.circular(50),
                  ),
                ],),
              ),
            ],
          ),
                
        ],
      ),
    );
  }
  void sendComment(String msg, int type){

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    if (msg != "") {
      _commentController.clear();
      var docRef = FirebaseFirestore.instance.collection("POSTS").doc(widget.post.id).collection("COMMENTAIRES").doc(DateTime.now().millisecondsSinceEpoch.toString());
      /*setState(() {
        lastMsgFrom = conversation.getConversation.userId;
      });*/
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await FirebaseFirestore.instance.collection("POSTS").doc(widget.post.id).set({
          "comments": FieldValue.increment(1),
          "responderList": FieldValue.arrayUnion([userProvider.getUserModel.userId])
          }, SetOptions(merge: true));

        await FirebaseFirestore.instance.collection("USERS").doc(widget.post.userId).set({
          "comments": FieldValue.increment(1)
          }, SetOptions(merge: true));
        
          transaction.set(docRef, {
            "postId": widget.post.id,
            "responderId": userProvider.getUserModel.userId,
            "responder": FirebaseFirestore.instance.collection("USERS").doc(userProvider.getUserModel.userId),
            "responderName": userProvider.getUserModel.fullName,
            "responderAvatarUrl": userProvider.getUserModel.imgUrl,
            "dateCreated": DateTime.now(),
            "content": msg,
            "type": type,
            "responderProfile": userProvider.getUserModel.profileType,
            "replying": false,
            "likesList": []
          });
        /*setState(() {
          replyIsImage = false;
          replyIsSticker = false;
          replyIsText = false;
        });*/
      });
      //listScrollController.animateTo(0.0, duration: Duration(microseconds: 300), curve: Curves.easeOut);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Le message est vide'),));
    }
  }
}

class CommentBox extends StatelessWidget {

  final CommentModel comment;

  const CommentBox({ Key key, this.comment }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    UserProvider userProvider = Provider.of<UserProvider>(context);
    bool isLocal = comment.userId == userProvider.getUserModel.userId;
    bool isDoctor = comment.userProfileType == doctor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: isLocal ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        !isLocal ? Padding(
          padding: EdgeInsets.only(right: wv*1, top: isDoctor ? 25 : 0),
          child: CircleAvatar(
            backgroundImage: comment.userAvatar != null ? CachedNetworkImageProvider(comment.userAvatar) : null,
            backgroundColor: kDeepTeal,
            child: comment.userAvatar == null ? Icon(LineIcons.user, color: whiteColor,) : null,
          ),
        ) : Container(),
        Expanded(
          child: Column(
            crossAxisAlignment: isLocal ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              isDoctor ? Align(
                alignment: isLocal ? Alignment.bottomRight : Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.only(bottom: hv*0.5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/icons/Bulk/Heart.svg', color: kSouthSeas, width: 20),
                      SvgPicture.asset("assets/icons/Two-tone/Bookmark.svg", color: kSouthSeas, width: 20),
                      SizedBox(width: wv*2,),
                      Text(S.of(context).mdecin, style: TextStyle(fontSize: 13, color: kTextBlue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ) : Container(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(isLocal ? 0 : 15), topLeft: Radius.circular(isLocal ? 15 : 0), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                  color: isDoctor ? kSouthSeas.withOpacity(0.2) : Colors.grey[200]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.userName, style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold, fontSize: 14),),
                    Text(comment.content, style: TextStyle(color: Colors.black87, fontSize: 14)),
                  ],
                )
              ),
              Align(
                alignment: isLocal ? Alignment.bottomRight : Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).ilYa + Algorithms.getTimeElapsed(date: comment.dateCreated.toDate()), style: TextStyle(fontSize: 12)),
                    SizedBox(width: wv*5,),
                    Row(
                      children: [
                        Icon(comment.likesList.contains(userProvider.getUserModel.userId) ? Icons.thumb_up : LineIcons.thumbsUp, color: kSouthSeas, size: 20,),
                        SizedBox(width: wv*0.5,),
                        Text(comment.likesList.length.toString(), style: TextStyle(fontSize: 12, color: kSouthSeas, fontWeight: FontWeight.bold)),
                        SizedBox(width: wv*1.5,),
                        InkWell(
                          onTap: (){
                            if(!comment.likesList.contains(userProvider.getUserModel.userId)){
                              FirebaseFirestore.instance.collection('POSTS').doc(comment.postId).collection('COMMENTAIRES').doc(comment.id).set({
                                "likesList": FieldValue.arrayUnion([userProvider.getUserModel.userId]),
                              }, SetOptions(merge: true));
                            } else {
                              print("dislike");
                              FirebaseFirestore.instance.collection('POSTS').doc(comment.postId).collection('COMMENTAIRES').doc(comment.id).set({
                                "likesList": FieldValue.arrayRemove([userProvider.getUserModel.userId]),
                              }, SetOptions(merge: true));
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            child: Text(comment.likesList.contains(userProvider.getUserModel.userId) ? S.of(context).annuler : S.of(context).aimer, style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: hv*1,),
            ],
          ),
        ),
        isLocal ? Padding(
          padding: EdgeInsets.only(left: wv*1, top: isDoctor ? 25 : 0),
          child: CircleAvatar(
            backgroundImage: comment.userAvatar != null ? CachedNetworkImageProvider(comment.userAvatar) : null,
            backgroundColor: kDeepTeal,
            child: comment.userAvatar == null ? Icon(LineIcons.user, color: whiteColor,) : null,
          ),
        ) : Container(),
      ],
    );
  }
}