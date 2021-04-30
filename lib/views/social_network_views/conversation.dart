import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/providers/conversationModelProvider.dart';
import 'package:danaid/core/models/conversationModel.dart';
import 'package:danaid/core/models/messageModel.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:danaid/core/providers/conversationChatModelProvider.dart';
import 'package:danaid/core/models/conversationChatModel.dart';
import 'package:danaid/widgets/stateful_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:swipeable/swipeable.dart';

class Conversation extends StatefulWidget {
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final FocusNode inputFocusNode = FocusNode();
  final TextEditingController _textController = new TextEditingController();
  final ScrollController listScrollController = ScrollController();
  bool showUploadMenu = false;

  bool showReplyTxt = false;
  bool showReplyImg = false;
  bool showReplySticker = false;
  bool replyIsText = false;
  bool replyIsSticker = false;
  bool replyImgIsSticker = false;
  bool replyIsImage = false;
  String replyMsg = "...";
  String replyImgUrl = "";
  String replyStickerName = "";
  bool replyIsLocal = false;

  String replierName = "Yoo";

  Stream chatMessageStream;

  String lastMsgFrom = "";

  initialization() async {
    ConversationModelProvider conversation = Provider.of<ConversationModelProvider>(context, listen: true);
    ConversationChatModelProvider conversationChat = Provider.of<ConversationChatModelProvider>(context, listen: true);
    String targetId = conversation.getConversation.targetId;
    String id = conversation.getConversation.userId;
    String conversationId = conversation.getConversation.conversationId;
    await FirebaseFirestore.instance.collection("USERS").doc(id).update({'chattingWith': targetId, 'chat-users': FieldValue.arrayUnion([targetId])});
    await FirebaseFirestore.instance.collection("USERS").doc(targetId).update({'chat-users': FieldValue.arrayUnion([id])});
    await FirebaseFirestore.instance.collection("CONVERSATIONS").doc(conversationId).set({"users": FieldValue.arrayUnion([id, targetId])}, SetOptions(merge: true));
    await FirebaseFirestore.instance.collection("CONVERSATIONS").doc(conversationId).get().then((doc) {
      ConversationChatModel conversationModel = ConversationChatModel.fromDocument(doc);
      conversationChat.setConversationModel(conversationModel);
      print(conversationChat.getConversation.conversationId);
    });
  }

  Future<bool> onBackPress() {
    if (showUploadMenu) {
      setState(() {
        showUploadMenu= false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  void initState() {
    initialization();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ConversationModelProvider conversation = Provider.of<ConversationModelProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: kDeepTeal,
          leading: InkWell(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                LineIcons.angleLeft,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: "heroAvatar",
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: kSouthSeas,
                      //backgroundImage: ((doctorProvider.getDoctor.avatarUrl == "") & (doctorProvider.getDoctor.avatarUrl == null))  ? null : CachedNetworkImageProvider(doctorProvider.getDoctor.avatarUrl),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            child: Center(child: Icon(LineIcons.user, color: Colors.white, size: wv*25,)), //CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),
                            padding: EdgeInsets.all(20.0),
                          ),
                          imageUrl: conversation.getConversation.targetAvatar),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text((conversation.getConversation.targetProfileType != doctor ? "" : "Dr. ") + conversation.getConversation.targetName, overflow: TextOverflow.fade, style: TextStyle( color: Colors.white),),
                      SizedBox(height: 1),
                      Text(
                        "Actif en ce moment",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Filter.svg', color: Colors.white,), onPressed: () {})
            ],
          )),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                chatMsgList(),
                Text(""),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1),
              decoration: BoxDecoration(
                color: kDeepTeal,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              ),
              child: Column(mainAxisSize: MainAxisSize.min,
                children: [
                  showReplyTxt
                    ? Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*1),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    MdiIcons.share,
                                    size: 28,
                                    color: kDeepTeal,
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      replyIsLocal
                                          ? "You"
                                          : conversation.getConversation.targetName,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: kDeepTeal,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      replyMsg,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey[600]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                )),
                                IconButton(
                                  icon: Icon(MdiIcons.close),
                                  color: Colors.grey,
                                  onPressed: () {
                                    setState(() {
                                      showReplyTxt = false;
                                      replyIsImage = false;
                                      replyIsSticker = false;
                                      replyIsText = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: wv*100,
                    height: showUploadMenu ? hv*5 : 0,
                    child: Row(children: [
                      IconButton(
                        padding: EdgeInsets.all(5),
                        constraints: BoxConstraints(),
                        iconSize: wv*7,
                        icon: SvgPicture.asset('assets/icons/Bulk/Video.svg', width: wv*7,),
                        color: Colors.white,
                        enableFeedback: true,
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          //getImage();
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.all(7),
                        constraints: BoxConstraints(),
                        iconSize: wv*7,
                        icon: SvgPicture.asset('assets/icons/Two-tone/Document.svg', width: wv*7),
                        color: Colors.white,
                        enableFeedback: true,
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          //getImage();
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.all(4),
                        constraints: BoxConstraints(),
                        iconSize: wv*7,
                        icon: SvgPicture.asset('assets/icons/Two-tone/Voice.svg', width: wv*7),
                        color: Colors.white,
                        enableFeedback: true,
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          //getImage();
                        },
                      ),
                    ], mainAxisAlignment: MainAxisAlignment.center,),
                  ),
                  Row(children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          TextField(
                            scrollPhysics: BouncingScrollPhysics(),
                            minLines: 1,
                            maxLines: 5,
                            controller: _textController,
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600, fontSize: 15),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              prefixIcon: SizedBox(width: wv*7,),
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
                              hintText: "Ecrire votre commentaire",
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                            ),
                          ),
                          IconButton(
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
                                setState(() {showUploadMenu = !showUploadMenu;});
                                //getImage();
                              },
                            ),
                          ),
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
                        sendMessage(_textController.text, 0);
                      },
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ],),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

   sendMessage(String msg, int type) {
    ConversationModelProvider conversation = Provider.of<ConversationModelProvider>(context, listen: false);
    setState(() {
      showReplyTxt = false;
      showReplyImg = false;
    });
    //0: text     1: image    2: sticker
    if (msg != "") {
      _textController.clear();
      var docRef = FirebaseFirestore.instance.collection("CONVERSATIONS")
          .doc(conversation.getConversation.conversationId)
          .collection("MESSAGES")
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      setState(() {
        lastMsgFrom = conversation.getConversation.userId;
      });
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await FirebaseFirestore.instance
            .collection("CONVERSATIONS")
            .doc(conversation.getConversation.conversationId)
            .set({
              'lastMessage': msg,
              "lastMessageType": type,
              "lastMessageTime": DateTime.now().millisecondsSinceEpoch.toString(),
              "lastMessageSeen": false,
              "lastMessageFrom": conversation.getConversation.userId,
              "unseenMessages": FieldValue.increment(1)
            }, SetOptions(merge: true));
        if (replyIsText) {
          transaction.set(docRef, {
            "idFrom": conversation.getConversation.userId,
            "idTo": conversation.getConversation.targetId,
            "replierId": replyIsLocal ? conversation.getConversation.userId : conversation.getConversation.targetId,
            "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
            "content": msg,
            "type": type,
            "seen": false,
            "replying": true,
            "replyType": replyIsText ? 0 : (replyImgIsSticker) ? 2 : 1,
            "replyContent": replyMsg
          });
        } else if (replyIsImage || replyImgIsSticker) {
          transaction.set(docRef, {
            "idFrom": conversation.getConversation.userId,
            "idTo": conversation.getConversation.targetId,
            "replierId": replyIsLocal ? conversation.getConversation.userId : conversation.getConversation.targetId,
            "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
            "content": msg,
            "type": type,
            "seen": false,
            "replying": true,
            "replyType": replyIsText ? 0 : (replyImgIsSticker) ? 2 : 1,
            "replyContent": replyImgUrl
          });
        } 
        else {
          transaction.set(docRef, {
            "idFrom": conversation.getConversation.userId,
            "idTo": conversation.getConversation.targetId,
            "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
            "content": msg,
            "type": type,
            "seen": false,
            "replying": false,
          });
        }
        setState(() {
          replyIsImage = false;
          replyIsSticker = false;
          replyIsText = false;
        });
      });
      listScrollController.animateTo(0.0,
          duration: Duration(microseconds: 300), curve: Curves.easeOut);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Le message est vide'),));
    }
  }


  void markMessagesAsSeen() {
    ConversationModelProvider conversation = Provider.of<ConversationModelProvider>(context, listen: true);
    ConversationChatModelProvider conversationChat = Provider.of<ConversationChatModelProvider>(context, listen: true);
    String targetId = conversation.getConversation.targetId;
    String userId = conversation.getConversation.userId;
    String conversationId = conversation.getConversation.conversationId;
    if (conversationChat.getConversation != null){
      print("userId: $userId\n lastMsgFrom: ${conversationChat.getConversation.lastMessageFrom}");
      if ((conversationChat.getConversation.lastMessageFrom == targetId) && (conversationChat.getConversation.lastMessageFrom != userId)) {
        FirebaseFirestore.instance
            .collection("CONVERSATIONS")
            .doc(conversationId)
            .set({"lastMessageSeen": true, "unseenMessages": 0},
                SetOptions(merge: true));
      }
    }
  }

  chatMsgList() {
    ConversationModelProvider conversation = Provider.of<ConversationModelProvider>(context);
    return Flexible(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("CONVERSATIONS").doc(conversation.getConversation.conversationId).collection("MESSAGES").orderBy("timeStamp", descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              markMessagesAsSeen();
              return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  controller: listScrollController,
                  padding: EdgeInsets.only(bottom: 100),
                  itemCount: snapshot.data.docs.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data.docs[index];
                    MessageModel msg = MessageModel.fromDocument(doc);
                    return Column(
                      children: <Widget>[
                        createMsgBox(index, msg, conversation.getConversation),
                        index == 0 ?  SizedBox(height: hv*5,) : Container()
                      ],
                    );
                  }
                );
            }
          },
        ));
  }

  Widget createMsgBox(int index, MessageModel msg, ConversationModel conversation) {
    if (msg.type == 0) {
      // Text Message
      return (msg.idFrom == conversation.userId)
          ?
          //My messages
          Swipeable(
              threshold: 50.0,
              onSwipeEnd: () {
                setState(() {
                  replyMsg = msg.content;
                  showReplyTxt = true;
                  showReplyImg = false;
                  showReplySticker = false;
                  replyIsLocal = true;
                  replyIsText = true;
                  replyImgIsSticker = false;
                  replyIsImage = false;
                });
              },
              background: Container(),
              child: MessageBox(
                userAvatar: conversation.userAvatar,
                targetAvatar: conversation.targetAvatar,
                message: msg,
                userName: conversation.userName,
                targetName: conversation.targetName,
              )
            )
          :
          //Target Messages
          Swipeable(
              threshold: 50.0,
              onSwipeEnd: () {
                print("replyIsText: $replyIsText replyImgIsSticker: $replyImgIsSticker replyIsImage: $replyIsImage");
                setState(() {
                  replyMsg = msg.content;
                  showReplyTxt = true;
                  replyIsText = true;
                  replyImgIsSticker = false;
                  replyIsImage = false;
                  showReplyImg = false;
                  showReplySticker = false;
                  replyIsLocal = false;
                });
              },
              background: Container(),
              child: MessageBox(
                userAvatar: conversation.userAvatar,
                targetAvatar: conversation.targetAvatar,
                message: msg,
                userName: conversation.userName,
                targetName: conversation.targetName,
              ),
            );
    } else if (msg.type == 1) {
      //Images
      return Swipeable(
        threshold: 50,
        background: Container(),
        onSwipeEnd: () {
          print(
              "replyIsText: $replyIsText replyImgIsSticker: $replyImgIsSticker replyIsImage: $replyIsImage");
          (msg.idFrom== conversation.userId)
              ? setState(() {
                  replyIsLocal = true;
                })
              : setState(() {
                  replyIsLocal = false;
                });
          print("this is $replyIsLocal");
          setState(() {
            replyImgUrl = msg.content;
            showReplyImg = true;
            showReplyTxt = false;
            showReplySticker = false;
            replyImgIsSticker = false;
            replyIsText = false;
            replyImgIsSticker = false;
            replyIsImage = true;
          });
        },
        child: Row(
          mainAxisAlignment:
              msg.idFrom== conversation.userId
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 8),
                child: GestureDetector(
                    onTap: () {
                      //url: document.data()["content"]});
                    },
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          width: 200.0,
                          height: 200.0,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.7),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        errorWidget: (context, url, error) => Material(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset("assets/images/not_found.jpeg",
                              width: 200.0, height: 200.0, fit: BoxFit.cover),
                        ),
                        imageUrl: msg.content,
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    )),
                margin: EdgeInsets.only(bottom: 10.0, right: 10.0)),
          ],
        ),
      );
    } else {
      //Stickers
      return Swipeable(
        threshold: 50,
        background: Container(),
        onSwipeEnd: () {
          print(
              "replyIsText: $replyIsText replyImgIsSticker: $replyImgIsSticker replyIsImage: $replyIsImage");
          (msg.idFrom == conversation.userId)
              ? setState(() {
                  replyIsLocal = true;
                })
              : setState(() {
                  replyIsLocal = false;
                });
          print("this is $replyIsLocal");
          setState(() {
            replyImgUrl = msg.content;
            showReplyImg = true;
            showReplyTxt = false;
            showReplySticker = false;
            replyImgIsSticker = true;
            replyIsText = false;
            replyImgIsSticker = true;
            replyIsImage = false;
          });
        },
        child: Row(
          mainAxisAlignment:
              msg.idFrom== conversation.userId
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Image.asset(
                  "assets/images/${msg.content}.gif",
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover),
              margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
            ),
          ],
        ),
      );
    }

    /*if (document.data()["idFrom"] == userId) {
      return Row(
        children: <Widget>[
          document.data()["type"] == 0
              ? Container()
              : document.data()["type"] == 1 ? Container() : Container()
        ],
      );
    } else {
      //
    }*/
  }

}

class MessageBox extends StatelessWidget {
  
  final MessageModel message;
  final String userAvatar, targetAvatar, userName, targetName;
  final bool seen;

  const MessageBox({Key key, this.message, this.userAvatar, this.targetAvatar, this.userName, this.targetName, this.seen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConversationModelProvider conversation = Provider.of<ConversationModelProvider>(context, listen: true);
    bool messageIsLocal = message.idFrom == conversation.getConversation.userId;
    return StatefulWrapper(
      onInit: () {
        _markAsSeen(context).then((value) {
          print('Async done');
        });
      },
      child: Container(
      padding: EdgeInsets.only(top: 5, left: messageIsLocal ? 0 : 10, right: messageIsLocal ? 10 : 0),
      margin: EdgeInsets.symmetric(vertical: 2),
      width: double.infinity,
      alignment: messageIsLocal ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(alignment: Alignment.centerRight,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(maxWidth: wv * 93, minWidth: wv * 23),
                  margin: EdgeInsets.only(left: wv*3, right: wv*1.5),
                  padding: EdgeInsets.only(left: wv * 2.5, bottom: hv * 3.7, right: wv * 2, top: hv * 1),
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), offset: new Offset(2.0, 2.0), blurRadius: 4.0, spreadRadius: 4.0),],
                      color: messageIsLocal ? Colors.teal[50] : Color(0xff605bbd),
                      borderRadius: messageIsLocal
                          ? BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15),
                            )
                          : BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      message.replying
                          ? GestureDetector(
                              onTap: () {
                                print("reply tapped");
                              },
                              child: Container(
                                //width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 10, bottom: 5, right: 5, top: 5),
                                margin:
                                    EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  border: Border(
                                    left: BorderSide(
                                        color: messageIsLocal
                                            ? Theme.of(context).primaryColor
                                            : Colors.white,
                                        width: 3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    (message.replyType == 1)||(message.replyType == 2)
                                        ? Container(
                                            width: wv * 15,
                                            height: wv * 15,
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5, right: 10),
                                            child: (message.replyType == 1)
                                                ? CachedNetworkImage(
                                                    placeholder: (context, url) =>
                                                        Container(
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(Colors.white),
                                                      ),
                                                      padding: EdgeInsets.all(70.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(8.0)),
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Material(
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                      clipBehavior: Clip.hardEdge,
                                                      child: Image.asset(
                                                          "assets/images/not_found.jpeg",
                                                          fit: BoxFit.cover),
                                                    ),
                                                    imageUrl: message.replyContent,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    "assets/images/${message.replyContent}.gif",
                                                    fit: BoxFit.cover,
                                                  ),
                                          )
                                        : Container(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          message.replierId == conversation.getConversation.targetId
                                              ? conversation.getConversation.targetName
                                              : "You",
                                          style: TextStyle(
                                              color: messageIsLocal
                                                  ? Theme.of(context).primaryColor
                                                  : Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(
                                              right: 10,
                                            ),
                                            constraints: BoxConstraints(
                                                maxWidth: wv * 50, maxHeight: hv * 5),
                                            child: Text(
                                              message.replyType == 0
                                                  ? message.replyContent
                                                  : message.replyType == 1
                                                      ? "Image"
                                                      : message.replyType == 2
                                                          ? "Sticker"
                                                          : "content",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: messageIsLocal
                                                      ? Colors.grey[400]
                                                      : Colors.white),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              width: 1,
                            ),
                      Text(
                        message.content,
                        style: TextStyle(
                            color: !messageIsLocal ? Colors.white : Colors.black54,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    right: 10,
                    bottom: 5,
                    child: Row(
                      children: <Widget>[
                        Text(
                          Algorithms.getDateFromTimestamp(
                            int.parse(message.timeStamp),
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: !messageIsLocal
                                ? Colors.grey[100]
                                : Colors.grey,
                          ),
                        ),
                        SizedBox(width: 5),
                        messageIsLocal
                            ? Icon(
                                MdiIcons.checkAll,
                                color: message.seen == true
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[500],
                                size: wv * 5,
                              )
                            : Container(),
                      ],
                    ))
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.circle,
              image: userAvatar != null ? DecorationImage(image: CachedNetworkImageProvider(userAvatar), fit: BoxFit.cover) : null,
            ),
            child: userAvatar != null ? Container() : Icon(LineIcons.user, color: whiteColor,),
          ),
        ],
      ),
    )
  
    );
  }
    Future _markAsSeen(BuildContext context) async {
      ConversationModelProvider conversation = Provider.of<ConversationModelProvider>(context, listen: false);
      DocumentReference msg = FirebaseFirestore.instance.collection("Conversation").doc(conversation.getConversation.conversationId).collection("MESSAGES").doc(message.id);
      if ((message.idFrom == conversation.getConversation.targetId && seen == false)) {
        msg.update({"seen": true});
      }
    }
}
