import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/social_network_views/actuality.dart';
import 'package:danaid/views/social_network_views/groups.dart';
import 'package:danaid/views/social_network_views/friends.dart';
import 'package:danaid/widgets/clippers.dart';
import 'package:danaid/widgets/function_widgets.dart';
import 'package:danaid/widgets/drawer.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SocialMediaHomePage extends StatefulWidget {
  @override
  _SocialMediaHomePageState createState() => _SocialMediaHomePageState();
}

class _SocialMediaHomePageState extends State<SocialMediaHomePage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _socialHomeScaffoldKey = GlobalKey<ScaffoldState>();
  TabController? controller;

  loadUserProfile() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if(userProvider.getProfileType != null || userProvider.getProfileType != ""){
      if (userProvider.getUserModel == null) {
        await FirebaseFirestore.instance.collection('USERS').doc(userProvider.getUserId).get().then((docSnapshot) {
          UserModel user = UserModel.fromDocument(docSnapshot);
          userProvider.setUserModel(user);
        });
      }
    }
    else {
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserProfile();
    controller = TabController(
      length: 3,
      vsync: this,
    );
  }
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _socialHomeScaffoldKey,
      body: userProvider.getUserModel != null ? CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 135,
            stretch: true,
            backgroundColor: kDeepTeal,
            actions: [Container()],
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back_ios_rounded, size: 25,),
                                  padding: EdgeInsets.only(right: 8),
                                  constraints: BoxConstraints(),
                                  onPressed: ()=>Navigator.pop(context)),
                                  Spacer(),
                                IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kSouthSeas,), padding: EdgeInsets.all(5), constraints: BoxConstraints(), onPressed: ()=>Navigator.pushNamed(context, '/search')),
                                IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(5), constraints: BoxConstraints(), onPressed: () => _socialHomeScaffoldKey.currentState!.openEndDrawer(),)
                              ],),
                              SizedBox(height: hv*1,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(S.of(context)!.bonjour+"${userProvider.getUserModel!.fullName}!", style: TextStyle(color: whiteColor, fontSize: 23),),
                                      Text(S.of(context)!.bienvenueAuRseauDentraideDanaid, style: TextStyle(color: whiteColor.withOpacity(0.5), fontSize: 12),),
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(child: SvgPicture.asset('assets/icons/Two-tone/Chat.svg', width: 35,), onTap: ()=>Navigator.pushNamed(context, '/chatroom'))
                                ],
                              ),
                              SizedBox(height: hv*1,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: ()=>Navigator.pushNamed(context, '/create-publication'),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.3)
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(S.of(context)!.queVoulezVousPartager, style: TextStyle(color: Colors.white, fontSize: 14),),
                        Row(mainAxisSize: MainAxisSize.min,
                          children: [
                            Hero(tag: "image", child: SvgPicture.asset('assets/icons/Two-tone/Image.svg', color: kSouthSeas, width: 25)),
                            Hero(tag: "document", child: SvgPicture.asset('assets/icons/Two-tone/Document.svg', color: kSouthSeas, width: 25)),
                            Hero(tag: "video", child: SvgPicture.asset('assets/icons/Two-tone/Video.svg', color: kSouthSeas, width: 25)),
                            Hero(tag: "voice", child: SvgPicture.asset('assets/icons/Two-tone/Voice.svg', color: kSouthSeas, width: 25))
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            pinned: true,
            snap: true,
            floating: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  indicatorColor: kSouthSeas,
                  indicatorWeight: 3,
                  isScrollable: true,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
                  tabs: <Widget>[
                    Tab(child: Row(children: [SvgPicture.asset('assets/icons/Bulk/Outline.svg'), SizedBox(width: wv*2,),Text(S.of(context)!.actualits)],)),
                    Tab(child: Row(children: [SvgPicture.asset('assets/icons/Bulk/Emoticone.svg'), SizedBox(width: wv*2,), Text(S.of(context)!.amis)],)),
                    Tab(child: Row(children: [SvgPicture.asset('assets/icons/Bulk/Users.svg'),  SizedBox(width: wv*2,), Text(S.of(context)!.groupes)],)
                    ),
                  ],
  
                  controller: controller,
                ),
              ),
            ),
          ),
          // SliverList(
          SliverFillRemaining(
            child: TabBarView(
              controller: controller,
              children: <Widget>[
                Center(child: ActualityPage()),
                Center(child: Friends()),
                Center(child: Groups()),
              ],
            ),
          ),
        ],
      ) : Center(child: Loaders().buttonLoader(kPrimaryColor)),
      endDrawer: DefaultDrawer(
        entraide: ()=>Navigator.pop(context),
        accueil: (){Navigator.pop(context); Navigator.pop(context);},
        carnet: (){Navigator.pop(context); Navigator.pop(context);},
        partenaire: (){Navigator.pop(context); Navigator.pop(context);},
        famille: (){Navigator.pop(context); Navigator.pop(context);},
      ),
    );
  }
}

class DrawerPainter extends CustomPainter {
  final Color color;
  DrawerPainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;
    canvas.drawPath(getShapePath(size.width, size.height), paint);
  }

  Path getShapePath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x/1.3, 0)
      ..quadraticBezierTo(x/1.7, y/4, x/1.3, y/1.9)
      ..quadraticBezierTo(x/1.15, y / 1.3, x/1.3, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(DrawerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}