import 'package:cached_network_image/cached_network_image.dart';
import 'package:danaid/core/models/groupModel.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/social_network_views/create_publication.dart';
import 'package:danaid/views/social_network_views/group_feeds.dart';
import 'package:danaid/widgets/drawer.dart';
import 'package:danaid/widgets/social_network_widgets/mini_components.dart';
import 'package:danaid/views/social_network_views/group_members.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';

class Group extends StatefulWidget {
  final GroupModel group;
  const Group({ Key key, this.group }) : super(key: key);

  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _socialHomeScaffoldKey = GlobalKey<ScaffoldState>();
  TabController groupController;

  @override
  void initState() {
    // TODO: implement initState
    groupController = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _socialHomeScaffoldKey,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              toolbarHeight: 200,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              actions: [Container()],
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: kDeepTeal,
                  image: widget.group.imgUrl != null ? DecorationImage(image: CachedNetworkImageProvider(widget.group.imgUrl), fit: BoxFit.cover) : null
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    Row(children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_rounded, size: 25, color: whiteColor,),
                        padding: EdgeInsets.only(right: 8),
                        constraints: BoxConstraints(),
                        onPressed: ()=>Navigator.pop(context)),
                        Spacer(),
                      IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: whiteColor,), padding: EdgeInsets.all(5), constraints: BoxConstraints(), onPressed: ()=>Navigator.pushNamed(context, '/search')),
                      IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: whiteColor), padding: EdgeInsets.all(5), constraints: BoxConstraints(), onPressed: () => _socialHomeScaffoldKey.currentState.openEndDrawer(),)
                    ],),
                  ],
                )
              ),
              titleSpacing: 0,
              title: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [whiteColor.withOpacity(0.0), whiteColor.withOpacity(0.4), whiteColor.withOpacity(0.9), whiteColor],
                              stops: [0.0, 0.1, 0.4, 1.0],
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              tileMode: TileMode.repeated
                            )
                          ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.group.groupName, style: TextStyle(color: kDeepTeal, fontSize: 22, fontWeight: FontWeight.w600),),
                            SizedBox(height: hv*0.5,),
                            Row(
                              children: [
                                Stack(children: [
                                  SizedBox(height: 40, width: wv*20,),
                                  SocialNetworkMiniComponents.getProfileAvatar(avatarUrl: widget.group.creatorAvatar, size: 8),
                                  widget.group.membersIds.length >= 2 ? Positioned(left: wv*5, child: SocialNetworkMiniComponents.getProfileAvatar(avatarUrl: widget.group.membersAvatarsUrls != null ? widget.group.membersAvatarsUrls[0] : null, size: 8)) : Container(),
                                  widget.group.membersIds.length >= 3 ? Positioned(left: wv*10, child: SocialNetworkMiniComponents.getProfileAvatar(avatarUrl: widget.group.membersAvatarsUrls != null ? widget.group.membersAvatarsUrls[1] : null, size: 8)) : Container(),
                                ]),
                                Text(" ${widget.group.membersIds.length} Membres", style: TextStyle(color: kTextBlue))
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              pinned: true,
              floating: true,
              bottom: PreferredSize(
                preferredSize: Size(wv*100, 49),
                child: Container(
                  color: whiteColor,
                  child: TabBar(
                    indicatorColor: Colors.transparent,
                    indicatorWeight: 3,
                    isScrollable: true,
                    labelColor: kSouthSeas,
                    unselectedLabelColor: Colors.grey[300],
                    labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
                    tabs: <Widget>[
                      Tab(text: "Conversations"),
                      Tab(text: "Membres"),
                      Tab(text: "A propos")
                    ],
                    controller: groupController,
                  ),
                ),
              ),
            )
          ];
        }, 
        body: TabBarView(
          controller: groupController,
          children: <Widget>[
            GroupFeeds(group: widget.group,),
            GroupMembers(groupMembers: widget.group.membersIds,),
            Center(child: Text(widget.group.groupDescription != null ? widget.group.groupDescription : "Aucune description fournie"))
          ],
        )
      ),
      endDrawer: DefaultDrawer(
        entraide: (){Navigator.pop(context); Navigator.pop(context);},
        accueil: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
        carnet: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
        partenaire: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
        famille: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(LineIcons.plus),
        backgroundColor: kDeepTeal,
        onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePublication(groupId: widget.group.groupId),),),
      ),
    );
  }
}