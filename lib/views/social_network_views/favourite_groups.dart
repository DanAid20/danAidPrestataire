import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/core/models/groupModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class FavouriteGroups extends StatefulWidget {
  @override
  _FavouriteGroupsState createState() => _FavouriteGroupsState();
}

class _FavouriteGroupsState extends State<FavouriteGroups> {
  CarouselController buttonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      child: Column(
        children: [
          SizedBox(height: hv*2,),
          Stack(alignment: Alignment.centerLeft,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("GROUPS").where("membersIds", arrayContains: userProvider.getUserModel.userId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<Widget> groups = [];
                  for (int i = 0; i < snapshot.data.docs.length; i++){
                    DocumentSnapshot doc = snapshot.data.docs[i];
                    GroupModel group = GroupModel.fromDocument(doc);
                    Widget content = getContent(
                      switchColor: i.isEven,
                      group: group
                    );
                    groups.add(content);
                  }
                  return CarouselSlider(
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      scrollPhysics: BouncingScrollPhysics(),
                      height: hv * 52,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.7,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: groups
                    /*[
                      getContent(),
                      getContent(switchColor: false),
                      getContent(),
                      getContent(switchColor: false)
                    ],*/
                  );
                }
              ),
              Positioned(
                left: wv*2,
                child: Column(
                  children: [
                    IconButton(
                      icon: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: kDeepTeal),
                        child: Icon(Icons.add, color: whiteColor, size: 30,)), 
                      onPressed: ()=>Navigator.pushNamed(context, '/create-group'),
                    ),
                    SizedBox(
                      child: Text("Ajouter un groupe", style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow( // bottomLeft
                          offset: Offset(-1, -1),
                          color: Colors.white
                        ),
                        Shadow( // bottomRight
                          offset: Offset(1, -1),
                          color: Colors.white
                        ),
                        Shadow( // topRight
                          offset: Offset(1, 1),
                          color: Colors.white
                        ),
                        Shadow( // topLeft
                          offset: Offset(-1, 1),
                          color: Colors.white
                        ),]
                      ), textAlign: TextAlign.center,), 
                      width: 60,
                    )
                  ],
                ), 
                
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget getContent({bool switchColor = true, GroupModel group}){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: wv*2.5),
      padding: EdgeInsets.symmetric(vertical: hv*1),
      decoration: BoxDecoration(
        color: switchColor ? kDeepTeal : kSouthSeas,
        borderRadius: BorderRadius.circular(20),
        //boxShadow: [BoxShadow(color: Colors.grey[600], blurRadius: 1.5, spreadRadius: 0.5, offset: Offset(0, 2))]
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: wv*4),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.groupName, style: TextStyle(color: whiteColor, fontSize: 22, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis,),
                SizedBox(height: hv*0.8,),
                Text(group.membersIds.length.toString()+" membres", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: !switchColor ? kDeepTeal : kSouthSeas)),
                SizedBox(height: hv*0.7,),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: wv*40,
                        height: hv*20,
                      ),
                      Positioned(
                        left: wv*4,
                        child: Container(
                          width: wv*65,
                          height: hv*20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.grey[800], blurRadius: 2.5, spreadRadius: 1, offset: Offset(0, 2))],
                            image: group.imgUrl != null ? DecorationImage(image: CachedNetworkImageProvider(group.imgUrl), fit: BoxFit.cover) : null,
                          ),
                          child: group.imgUrl == null ? SvgPicture.asset('assets/icons/Bulk/Users.svg', width: wv*15, color: Colors.grey[300],) : Container(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: hv*2,),
                  Row(children: [
                    Expanded(flex: 5, 
                      child: Align(child: SvgPicture.asset('assets/icons/Bulk/NewConversations.svg', color: !switchColor ? kDeepTeal : kSouthSeas, width: wv*8, alignment: Alignment.centerRight,))
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Text("2", style: TextStyle(color: whiteColor,fontWeight: FontWeight.bold, fontSize: 25), textAlign: TextAlign.right,),
                    ),
                    Expanded(flex: 11,
                      child: RichText(text: TextSpan(
                        text: "Nouvelles\n",
                        style: TextStyle(color: !switchColor ? kDeepTeal : kSouthSeas, fontSize: 13),
                        children: [TextSpan(text: "Conversations", style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold))])
                      ),
                    )
                  ],),
                  SizedBox(height: hv*1),
                  Row(children: [
                    Expanded(flex: 5, 
                      child: Align(child: SvgPicture.asset('assets/icons/Bulk/NewComments.svg', color: !switchColor ? kDeepTeal : kSouthSeas, width: wv*8, alignment: Alignment.centerRight,))
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Text("4", style: TextStyle(color: whiteColor,fontWeight: FontWeight.bold, fontSize: 25), textAlign: TextAlign.right,),
                    ),
                    Expanded(flex: 11,
                      child: RichText(text: TextSpan(
                        text: "Nouvelles\n",
                        style: TextStyle(color: !switchColor ? kDeepTeal : kSouthSeas, fontSize: 13),
                        children: [TextSpan(text: "Conversations", style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold))])
                      ),
                    )
                  ],),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: wv*4),
            child: Row(children: [
              getProfileAvatar(avatarUrl: group.creatorAvatar),
              group.membersIds.length >= 2 ? getProfileAvatar(avatarUrl: group.membersAvatarsUrls != null ? group.membersAvatarsUrls[0] : null) : Container(),
              group.membersIds.length >= 3 ? getProfileAvatar(avatarUrl: group.membersAvatarsUrls != null ? group.membersAvatarsUrls[1] : null) : Container(),
            ], mainAxisAlignment: MainAxisAlignment.end,),
          )
        ],
      ),
    );
  }

  getProfileAvatar({String avatarUrl}){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: wv*0.5),
      width: wv*12,
      height: wv*12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
        image: avatarUrl != null ? DecorationImage(image: CachedNetworkImageProvider(avatarUrl), fit: BoxFit.cover) : null,
        boxShadow: [BoxShadow(color: Colors.grey[800], blurRadius: 2.5, spreadRadius: 1, offset: Offset(0, 2))],
      ),
      child: avatarUrl == null ? Icon(LineIcons.user, size: 30,) : Container(),
    );
  }
}