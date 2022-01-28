import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/conversationChatModel.dart';
import 'package:danaid/core/models/conversationModel.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/conversationModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:danaid/widgets/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  chatRoomList() {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    var chatRoomStream = FirebaseFirestore.instance.collection("CONVERSATIONS").where("users", arrayContains: userProvider.getUserModel!.authId).orderBy("lastMessageTime", descending: true).snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? snapshot.data!.docs.length >= 1 ? Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot? doc = snapshot.data?.docs[index];
                        ConversationChatModel conversation = ConversationChatModel.fromDocument(doc!);
                        String targetId = (conversation.users![0] == userProvider.getUserModel?.authId) ? conversation.users![1] : conversation.users![0];

                        return doc != null
                            ? ChatRoomTile(conversation: conversation, targetId: targetId)
                            : CircularProgressIndicator();
                      }),
                ) : Center(
                  child: Column(mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: hv*30,),
                      Icon(LineIcons.commentDots, color: Colors.grey[400], size: 85,),
                      SizedBox(height: 5,),
                      Text(S.of(context)!.commencezUneConversation, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.grey[400]), textAlign: TextAlign.center,),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //backgroundColor: Color(0xFF008778),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: kDeepTeal,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: whiteColor,), onPressed: ()=>Navigator.pop(context)),
        title: Text(S.of(context)!.crerUnGroupe, style: TextStyle(color: whiteColor),),
        actions: [
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kSouthSeas,), padding: EdgeInsets.all(5), constraints: BoxConstraints(), onPressed: ()=>Navigator.pushNamed(context, '/search')),
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(5), constraints: BoxConstraints(), onPressed: () => _scaffoldKey.currentState?.openEndDrawer())],
      ),
      endDrawer: DefaultDrawer(
        entraide: (){Navigator.pop(context); Navigator.pop(context);},
        accueil: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
        carnet: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
        partenaire: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
        famille: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          chatRoomList(),
        ],
      ),
    );
  }
}


class ChatRoomTile extends StatefulWidget {
  final String? targetId;
  final ConversationChatModel? conversation;

  const ChatRoomTile({Key? key, this.targetId, this.conversation}) : super(key: key);

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  @override
  Widget build(BuildContext context) {
    ConversationModelProvider conversation = Provider.of<ConversationModelProvider>(context);
    bool isLocal = widget.conversation!.lastMessageFrom != widget.targetId;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("USERS").doc(widget.conversation!.phoneIds![widget.targetId]).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          }
          UserModel chatBuddy = UserModel.fromDocument(snapshot.data!);
          print(chatBuddy.authId);
          print(widget.targetId);
          return Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
                decoration: BoxDecoration(
                    ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  leading: Hero(
                    tag: "heroAvatar",
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: chatBuddy.imgUrl != null
                          ? CachedNetworkImageProvider(chatBuddy.imgUrl!)
                          : null,
                      child: chatBuddy.imgUrl != null ? Container() : Icon(LineIcons.user, color: whiteColor,),
                    ),
                  ),
                  title: Text(chatBuddy.fullName != null ? chatBuddy.fullName! : "wait"),
                  subtitle: widget.conversation?.lastMessageType == 0
                      ? Row(
                          children: <Widget>[
                            isLocal ? Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Icon(
                                MdiIcons.checkAll,
                                color: widget.conversation!.lastMessageSeen! ? kDeepTeal : Colors.grey[400],
                                size: 17,
                              ),
                            ) : Container(),
                            SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                widget.conversation?.lastMessage != null
                                    ? widget.conversation!.lastMessage!
                                    : S.of(context)!.wait,
                                style: TextStyle(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      : widget.conversation?.lastMessageType == 1
                          ? Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Row(
                                children: <Widget>[
                                  isLocal ? Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: Icon(
                                      MdiIcons.checkAll,
                                      color: Colors.grey[400],
                                      size: 17,
                                    ),
                                  ) : Container(),
                                  Icon(
                                    MdiIcons.image,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(S.of(context)!.image)
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Row(
                                children: <Widget>[
                                  isLocal ? Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: Icon(
                                      MdiIcons.checkAll,
                                      color: Colors.grey[400],
                                      size: 17,
                                    ),
                                  ) : Container(),
                                  SizedBox(width: 3),
                                  Icon(
                                    MdiIcons.sticker,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(S.of(context)!.sticker)
                                ],
                              ),
                            ),
                  //subtitle: Text("Joined: " + DateFormat("dd MMMM, yyyy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch((int.parse(user.createdAt))))),
                  trailing: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Text(
                        widget.conversation?.lastMessageTime != null
                            ? Algorithms.getDateFromTimestamp(
                                int.parse(widget.conversation!.lastMessageTime!),
                              )
                            : S.of(context)!.wait,
                        style: TextStyle(fontSize: 13, color: Colors.grey),),
                    SizedBox(height: 5,),
                    !isLocal ? 
                    widget.conversation?.unseenMessages != null ?
                      widget.conversation!.unseenMessages! > 0 ?
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: kDeepTeal,
                        child: Text(widget.conversation!.unseenMessages.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.white))
                      )
                      : Text("") : Text("") : Text(""),
                  ],),
                  
                  onTap: () {
                    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

                    ConversationModel conversationModel = ConversationModel(
                      conversationId: widget.conversation?.conversationId,
                      userId: userProvider.getUserModel?.authId,
                      targetId: widget.targetId,
                      userName: userProvider.getUserModel?.fullName,
                      targetName: chatBuddy.fullName,
                      userAvatar: userProvider.getUserModel?.imgUrl,
                      targetAvatar: chatBuddy.imgUrl,
                      targetProfileType: chatBuddy.profileType,
                      userPhoneId: userProvider.getUserModel?.userId,
                      targetPhoneId: chatBuddy.userId
                    );
                    conversation.setConversationModel(conversationModel);
                    Navigator.pushNamed(context, '/conversation');
                  },
                ),
              ),
              Divider(height: 0)
            ],
          );
        });
  }
}