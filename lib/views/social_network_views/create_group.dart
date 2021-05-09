import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/conversationChatModel.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/providers/usersListProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {

  QuerySnapshot searchSnapshot;
  TextEditingController _searchController = new TextEditingController();
  Future<QuerySnapshot> futureSearchResults;
  SharedPreferences preferences;

  searches() {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    UsersListProvider usersListProvider = Provider.of<UsersListProvider>(context, listen: false);
    UserModel user = userProvider.getUserModel;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("USERS").where("nameKeywords", arrayContains: _searchController.text.toLowerCase()).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        List<bool> _checked = List<bool>.filled(snapshot.data.docs.length, false);
        return snapshot.data.docs.length >= 1 ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot userSnapshot = snapshot.data.docs[index];
            UserModel singleUser = UserModel.fromDocument(userSnapshot);
            if (singleUser.userId == user.userId) {
              return Container();
            }
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Row(
                  children: [
                    Checkbox(
                      value: _checked[index],
                      fillColor: MaterialStateProperty.all(kDeepTeal),
                      onChanged: (val){
                        print(_checked[index].toString());
                        print(val.toString());
                        setState(() {
                          _checked[index] = val;
                        });
                        _checked[index] ? usersListProvider.addUser(singleUser) : usersListProvider.removeUser(singleUser);
                        print(usersListProvider.getUsers.length.toString());
                        print(_checked[index].toString());
                      }
                    ),
                    Expanded(
                      child: SearchResult(
                        user: user,
                        target: singleUser,
                        onTap: (){
                          setState(() {
                            _checked[index] = !_checked[index];
                          });
                        _checked[index] ? usersListProvider.addUser(singleUser) : usersListProvider.removeUser(singleUser);
                        },
                      ),
                    ),
                  ],
                );
              }
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)), borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)), borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)), borderRadius: BorderRadius.circular(10)),
                    hintText: "Entrez les noms des utilisateurs à ajouter..",
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
          ? Column(
            children: [
              Expanded(child: searches()),
              CustomTextButton(
                text: "Suivant",
                color: kDeepTeal,
                action: ()=>Navigator.pushNamed(context, '/create-group-final'),
              )
            ],
          )
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
            "Cherchez des utilisateurs",
            style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }
}

class SearchResult extends StatelessWidget {
  final UserModel user;
  final UserModel target;
  final Function onTap;

  const SearchResult({Key key, this.onTap, this.user, this.target}) : super(key: key);

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
    return Container(
      margin: EdgeInsets.symmetric(vertical: hv*0.2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: target.imgUrl != null
              ? CachedNetworkImageProvider(target.imgUrl)
              : AssetImage("assets/images/avatar.png"),
        ),
        title: Text(target.fullName),
        subtitle: Text(target.profileType == doctor ? "Médecin" : target.profileType == serviceProvider ? "Prestataire" : "Adhérent", style: TextStyle(color: kTextBlue),),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: kDeepTeal,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }
}