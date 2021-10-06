import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/dynamicLinkHandler.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/social_network_views/profile_page.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class Friends extends StatefulWidget {
  const Friends({ Key key }) : super(key: key);

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  bool spinner = false;

  Widget getFriendsList(){
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel user = userProvider.getUserModel;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("USERS").where("friends", arrayContains: user.userId).snapshots(),
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
            return userBox(
              user: singleUser
            );
          },
        ) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: hv*15,),
              Icon(LineIcons.userPlus, color: Colors.grey[400], size: 85,),
              SizedBox(height: 5,),
              Text(S.of(context).nhsitezPasFaireUneDemandeDami, 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[400] )
              , textAlign: TextAlign.center,),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container(child: getFriendsList())),
          userProvider.getUserModel.isAmbassador != 1 ? CustomTextButton(
            text: " Devenir ambassadeur DanAid  ",
            fontSize: 16,
            color: kSouthSeas,
            enable: userProvider.getUserModel.isAmbassador == null,
            expand: false,
            action: (){
              showDialog(context: context,
                builder: (BuildContext context){
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*5,),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Column(children: [
                            SizedBox(height: hv*4),
                            Icon(LineIcons.userTie, color: kDeepTeal, size: 70,),
                            SizedBox(height: hv*2,),
                            Text("Etre ambassadeur", style: TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.w700),),
                            SizedBox(height: hv*2,),
                          Text("Vous serez promoteur des services DanAid et leurs avantages au près de votre entourage et au délà. Souhaitez vous poursuivre ?", style: TextStyle(color: Colors.grey[600], fontSize: wv*4), textAlign: TextAlign.center),
                            SizedBox(height: hv*2),
                            CustomTextButton(
                              text: "Continuer",
                              color: kDeepTeal,
                              isLoading: spinner,
                              action: (){
                                setState(() { spinner = true; });
                                FirebaseFirestore.instance.collection("USERS").doc(userProvider.getUserModel.userId).set({
                                  "isAmbassador" : 0,
                                  "couponCode": userProvider.getUserModel.matricule.replaceAll(new RegExp(r'[^0-9]'),'')
                                }, SetOptions(merge: true)).then((value) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Votre demande est en cours d'examen",)));
                                });
                              
                              },
                            )
                            
                          ], mainAxisAlignment: MainAxisAlignment.center, ),
                        ),
                      ],
                    ),
                  );
                }
              );
            },
          ) 
          : 
          SizedBox(
            width: wv*82,
            child: CustomTextButton(
              text: "Ambassador Dashboard",
              fontSize: 16,
              color: kDeepTeal,
              action: (){Navigator.pushNamed(context, "/ambassador-dashboard"); print("yooo");}
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: SvgPicture.asset('assets/icons/Two-tone/AddUser.svg', width: wv*8,),
        backgroundColor: kDeepTeal,
        onPressed: () async {
          var link;
          //var link = userProvider.getUserModel.isAmbassador == 1 ? await DynamicLinkHandler.createAmbassadorDynamicLink(userId: userProvider.getUserModel.userId) : await DynamicLinkHandler.createFriendInviteDynamicLink(userId: userProvider.getUserModel.userId);
          if(userProvider.getUserModel.isAmbassador == 1) {
            String couponCode = userProvider.getUserModel.matricule.replaceAll(new RegExp(r'[^0-9]'),'');
            link = await DynamicLinkHandler.createAmbassadorDynamicLink(userId: userProvider.getUserModel.userId, couponCode: couponCode);
          }
          else {
            link = await DynamicLinkHandler.createFriendInviteDynamicLink(userId: userProvider.getUserModel.userId);
          }
          Share.share(link.toString(), subject: "Nouvelle demande d'ami sur DanAid").then((value) {
            print("Done !");
          });
        },
      ),
    );
  }

  Widget userBox({UserModel user}){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: user.imgUrl != null
              ? CachedNetworkImageProvider(user.imgUrl)
              : null,
          child: user.imgUrl != null ? Container() : Icon(LineIcons.user, color: whiteColor,),
        ),
        title: Text(user.fullName, style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold),),
        subtitle: Text(user.profileType),
        //subtitle: Text("Joined: " + DateFormat("dd MMMM, yyyy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch((int.parse(user.createdAt))))),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
        ),
        onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(userId: user.userId),),),
      ),
    );
  }
}