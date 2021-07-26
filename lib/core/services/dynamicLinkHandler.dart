import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/postModel.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
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

  void fetchClassicLinkData(BuildContext context) async {
    var link = await FirebaseDynamicLinks.instance.getInitialLink();

    handleLinkData(link, context);

    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      handleLinkData(dynamicLink, context);
    });
  }

  void handleLinkData(PendingDynamicLinkData data, BuildContext context) async {
    final Uri uri = data?.link;
    if(uri != null) {
      final queryParams = uri.queryParameters;
      if(queryParams.length > 0) {
        bool isPost = uri.pathSegments.contains('post');
        if(isPost){
          print("This is a post");
          BottomAppBarControllerProvider bottomAppBarController = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
          String userId = queryParams["userid"];
          String postId = queryParams["postid"];
          if(queryParams["isgroup"] != '1'){
            await FirebaseFirestore.instance.collection("POSTS").doc(queryParams["postid"]).get().then((doc) async {
              PostModel post = PostModel.fromDocument(doc);
              List shares = (post.sharesList != null) ? post.sharesList : [];
              bottomAppBarController.setIndex(0);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetails(post: post),),);
              await FirebaseFirestore.instance.collection("POSTS").doc(queryParams["postid"]).update({'shares': FieldValue.arrayUnion(['+'+queryParams["userid"]])});
            });
          }
        }
        else {
          String userId = queryParams["userid"];
          print("The id is: $userId");
        }
      }
    }
  }
}