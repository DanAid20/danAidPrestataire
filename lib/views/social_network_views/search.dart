import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/conversationChatModel.dart';
import 'package:danaid/core/models/conversationModel.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/conversationModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  QuerySnapshot searchSnapshot;
  TextEditingController _searchController = new TextEditingController();
  Future<QuerySnapshot> futureSearchResults;
  SharedPreferences preferences;

/*
  // ChatRoom Creation
  createChatroomAndStartConversation(String username) async {
    String chatRoomId = getChatRoomId(username, Constants.localName);

    List<String> users = [username, Constants.localName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId
    };

    Map<String, dynamic> chatRoom = {
      "replierName": username,
      "chatRoomId": chatRoomId
    };

    await _databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.pushNamed(context, '/conversation', arguments: chatRoom);
  }
*/
  searchResults() {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    String userId;
    String userName;
    String avatarUrl;
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<SearchResult> searchUserResult = [];
        dataSnapshot.data.docs.forEach((document) {
          UserModel singleUser = UserModel.fromDocument(document);
          SearchResult userResult = SearchResult(user: singleUser);

          if (userId != document["id"]) {
            searchUserResult.add(userResult);
          }
        });

        return ListView(
          children: searchUserResult,
        );
      },
    );
  }

  searches() {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel user = userProvider.getUserModel;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("USERS").where("nameKeywords", arrayContains: _searchController.text.toLowerCase()).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return snapshot.data.docs.length >= 1 ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot userSnapshot = snapshot.data.docs[index];
            UserModel singleUser = UserModel.fromDocument(userSnapshot);
            if (singleUser.userId == user.userId) {
              return Container();
            }
            return SearchResult(
              user: user,
              target: singleUser,
              userId: user.userId,
              userAvatar: user.imgUrl,
            );
          },
        ) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Icon(MdiIcons.databaseRemove, color: Colors.grey[400], size: 85,),
              SizedBox(height: 5,),
              Text("Aucun utilisateur avec pour nom :\n \"${_searchController.text}\"", 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[400] )
              , textAlign: TextAlign.center,),
            ],
          ),
        );
      },
    );
  }
/*
  search() {
    _databaseMethods.getUserByUsername(_searchController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }
*/

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      //backgroundColor: Color(0xffeeebf2),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: kDeepTeal,
        title: Row(
          children: <Widget>[
            InkWell(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(50),
            ),
            SizedBox(
              width: 0,
            ),
            Expanded(
              child: Container(
                height: 45,
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 5),

                // TextField
                child: TextField(
                  autofocus: true,
                  controller: _searchController,
                  onChanged: (val) {
                    searchUsers(val);
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(color: whiteColor),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: whiteColor),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.0)),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.0)),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.0)),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Entrez le nom..",
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(bottom: 12, left: 15, right: 15),

                    /*prefixIcon: IconButton(icon :Icon(Icons.arrow_back_ios), enableFeedback: false, 
                    onPressed: (){Navigator.pop(context);},),*/
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 7)
          ],
        ),
      ),
      body: (_searchController.text != "")
          ? Container(
              padding:
                  EdgeInsets.symmetric(vertical: hv * 2, horizontal: hv * 2),
              child: searches())
          : noUsers(context),
    );
  }

  searchUsers(String keyWord) {
    Future<QuerySnapshot> allFoundUsers = FirebaseFirestore.instance
        .collection("Users")
        .where("keyWords", arrayContains: keyWord.toLowerCase())
        .get();

    setState(() {
      futureSearchResults = allFoundUsers;
    });
  }

  Widget noUsers(context) {
    final hv = MediaQuery.of(context).size.height / 100;
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: hv * 30),
          Hero(
            tag: "search",
            child: Icon(
              Icons.search,
              size: hv * 10,
              color: Colors.grey,
            ),
          ),
          Text(
            "Cherchez d'autres utilisateurs",
            style: TextStyle(
                fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }
}

class SearchResult extends StatelessWidget {
  final UserModel user;
  final UserModel target;
  final String userId;
  final String userName;
  final String userAvatar;
  final String userEmail;
  final Function onTap;

  const SearchResult({Key key, this.userName, this.userEmail, this.onTap, this.user, this.userId, this.userAvatar, this.target}) : super(key: key);

  ConversationChatModel getConversation() {
    ConversationChatModel chatRoomModel = ConversationChatModel();
    String conversationId = Algorithms.getConversationId(userId: user.authId, targetId: target.authId);
    FirebaseFirestore.instance.collection("CONVERSATIONS").doc(conversationId).get().then((conversation) {
      ConversationChatModel chatRoom = ConversationChatModel.fromDocument(conversation);
      chatRoomModel = chatRoom;
    });
    return chatRoomModel;
  }

  @override
  Widget build(BuildContext context) {
    ConversationChatModel conversationData = ConversationChatModel(lastMessageFrom: userId);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: target.imgUrl != null
              ? CachedNetworkImageProvider(target.imgUrl)
              : null,
          child: target.imgUrl != null ? Container() : Icon(LineIcons.user, color: whiteColor,),
        ),
        title: Text(target.fullName),
        subtitle: Text(target.phoneList[0]["number"].toString()),
        //subtitle: Text("Joined: " + DateFormat("dd MMMM, yyyy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch((int.parse(user.createdAt))))),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
        ),
        onTap: () {
          startConversation(context, conversationData);
        },
      ),
    );
  }

  startConversation(BuildContext context, ConversationChatModel conversationData) {
    ConversationModelProvider conversation = Provider.of<ConversationModelProvider>(context, listen: false);
    ConversationModel conversationModel = ConversationModel(
      conversationId: Algorithms.getConversationId(userId: user.authId, targetId: target.authId),
      userId: user.authId,
      targetId: target.authId,
      userName: user.fullName,
      targetName: target.fullName,
      userAvatar: user.imgUrl,
      targetAvatar: target.imgUrl,
      targetProfileType: target.profileType,
      userPhoneId: user.userId,
      targetPhoneId: target.userId
    );
    conversation.setConversationModel(conversationModel);
    Navigator.pushNamed(context, '/conversation');
  }
}