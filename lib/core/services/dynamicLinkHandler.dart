import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/postModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/views/social_network_views/post_details.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DynamicLinkHandler {
  static Future<Uri> createClassicDynamicLink({@required String userId}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://danaid.page.link',
      link: Uri.parse('https://danaid.page.link/classicinvite?userid=$userId'),
      androidParameters: AndroidParameters(
        packageName: 'com.danaid.danaidmobile',
        minimumVersion: 210020010,
      ),
      /*iosParameters: IosParameters(
        bundleId: 'com.danaid.danaidmobile',
        minimumVersion: '210020010',
        appStoreId: '',
      ),*/
    );
    final link = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    return shortenedLink.shortUrl;
  }
  
  static Future<Uri> createPostDynamicLink({@required String userId, @required String postId, @required String isGroup}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://danaid.page.link',
      link: Uri.parse('https://danaid.page.link/post?userid=$userId&postid=$postId&isgroup=$isGroup'),
      androidParameters: AndroidParameters(
        packageName: 'com.danaid.danaidmobile',
        minimumVersion: 210020010,
      ),
      /*iosParameters: IosParameters(
        bundleId: 'com.danaid.danaidmobile',
        minimumVersion: '210020010',
        appStoreId: '',
      ),*/
    );
    final link = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    return shortenedLink.shortUrl;
  }
  
  static Future<Uri> createCompareServiceDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://danaid.page.link',
      link: Uri.parse('https://danaid.page.link/compare?comp=yes'),
      androidParameters: AndroidParameters(
        packageName: 'com.danaid.danaidmobile',
        minimumVersion: 210020010,
      ),
      /*iosParameters: IosParameters(
        bundleId: 'com.danaid.danaidmobile',
        minimumVersion: '210020010',
        appStoreId: '',
      ),*/
    );
    final link = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    return shortenedLink.shortUrl;
  }
  
  static Future<Uri> createFriendInviteDynamicLink({@required String userId}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://danaid.page.link',
      link: Uri.parse('https://danaid.page.link/friend?userid=$userId'),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: Uri.parse("https://firebasestorage.googleapis.com/v0/b/danaidapp.appspot.com/o/FCMImages%2FDanAid%20Logo%20mini%20icon.png?alt=media&token=93298300-7e26-4760-962a-08a3b31960c6"),
        title: "Friend Request",
        description: "A new friend request from DanAid"
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short),
      androidParameters: AndroidParameters(
        packageName: 'com.danaid.danaidmobile',
        minimumVersion: 210020010,
      ),
      /*iosParameters: IosParameters(
        bundleId: 'com.danaid.danaidmobile',
        minimumVersion: '210020010',
        appStoreId: '',
      ),*/
    );
    final ShortDynamicLink shortLink =  await parameters.buildShortLink();
    final link = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    return shortLink.shortUrl;
  }

  void fetchClassicLinkData(BuildContext context) async {
    var link = await FirebaseDynamicLinks.instance.getInitialLink();

    handleLinkData(link, context);

    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      handleLinkData(dynamicLink, context);
    });
  }

  void handleLinkData(PendingDynamicLinkData data, BuildContext context) async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    final Uri uri = data?.link;
    if(uri != null) {
      final queryParams = uri.queryParameters;
      if(queryParams.length > 0) {
        bool isPost = uri.pathSegments.contains('post');
        bool isFriendInvite = uri.pathSegments.contains('friend');
        bool isCompareService = uri.pathSegments.contains('compare');
        if(isPost){
          print("This is a post link");
          BottomAppBarControllerProvider bottomAppBarController = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
          String userId = queryParams["userid"].substring(1);
          String postId = queryParams["postid"];
          if(queryParams["isgroup"] != '1'){
            await FirebaseFirestore.instance.collection("POSTS").doc(queryParams["postid"]).get().then((doc) async {
              PostModel post = PostModel.fromDocument(doc);
              List shares = (post.sharesList != null) ? post.sharesList : [];
              bottomAppBarController.setIndex(0);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetails(post: post),),);
              await FirebaseFirestore.instance.collection("POSTS").doc(queryParams["postid"]).update({'shares': FieldValue.arrayUnion(['+'+queryParams["userid"].substring(1)])});
            });
          }
        }
        else if(isFriendInvite){
          print("This is a friend invite");
          print(userProvider.getUserModel.userId.toString());
          print('+'+queryParams["userid"].substring(1).toString());
          print('start');
          if(adherentProvider.getAdherent != null){
            if (adherentProvider.getAdherent.enable == false){
              await FirebaseFirestore.instance.collection("USERS").doc(adherentProvider.getAdherent.getAdherentId).set({'friendRequests': FieldValue.arrayUnion(['+'+queryParams["userid"].substring(1)])}, SetOptions(merge: true)).then((doc) async {
              await FirebaseFirestore.instance.collection("USERS").doc('+'+queryParams["userid"].substring(1).toString()).update({"points": FieldValue.increment(100)}).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Demande d'amitié en attente")));
                Navigator.pushNamed(context, '/friend-requests');
                });
              });
            } 
          }
        }
        else if(isCompareService){
          BottomAppBarControllerProvider bottomAppBarController = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
          bottomAppBarController.setIndex(1);
          print("This is a compare service link");
          Navigator.pushNamed(context, '/compare-plans');
        }
        else {
          String userId = queryParams["userid"];
          print("The id is: $userId");
        }
      }
    }
  }
}