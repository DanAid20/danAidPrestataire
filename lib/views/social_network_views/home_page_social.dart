import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class SocialMediaHomePage extends StatefulWidget {
  @override
  _SocialMediaHomePageState createState() => _SocialMediaHomePageState();
}

class _SocialMediaHomePageState extends State<SocialMediaHomePage> with SingleTickerProviderStateMixin {
  TabController controller;

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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: hv*18,
            stretch: true,
            backgroundColor: kDeepTeal,
            title: Column(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: hv*12,
                  child: Row(//crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios_rounded, size: 25,),
                          padding: EdgeInsets.only(right: 8),
                          constraints: BoxConstraints(),
                          onPressed: (){}),
                      ),
                      SizedBox(width: wv*3,),
                      Expanded(
                        child: Container(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Bonjour ${userProvider.getUserModel.fullName}!", style: TextStyle(color: whiteColor, fontSize: 23),),
                              Text("Bienvenue au réseau d'entraide DanAid", style: TextStyle(color: whiteColor.withOpacity(0.5), fontSize: 12),),
                            ],
                          ),
                        ),
                      ),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kSouthSeas,), padding: EdgeInsets.all(5), constraints: BoxConstraints(), onPressed: (){}),
                            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(5), constraints: BoxConstraints(), onPressed: (){})
                          ],),
                          IconButton(icon: SvgPicture.asset('assets/icons/Two-tone/Chat.svg', width: wv*10,), padding: EdgeInsets.all(5), constraints: BoxConstraints(), onPressed: ()=>Navigator.pushNamed(context, '/chatroom')),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white.withOpacity(0.3)
                  ),
                  child: Row(
                    children: [
                      Text("Que voulez vous partager ?", style: TextStyle(color: Colors.white, fontSize: 14),),
                    ],
                  ),
                )
              ],
            ),
            pinned: true,
            snap: true,
            floating: true,
            bottom: TabBar(
              indicatorColor: kSouthSeas,
              indicatorWeight: 3,
              isScrollable: true,
              tabs: <Widget>[
                Tab(child: Row(children: [SvgPicture.asset('assets/icons/Bulk/Outline.svg'), SizedBox(width: wv*2,),Text("Actualités")],)),
                Tab(child: Row(children: [SvgPicture.asset('assets/icons/Bulk/Emoticone.svg'), SizedBox(width: wv*2,), Text("Amis   ")],)),
                Tab(child: Row(children: [SvgPicture.asset('assets/icons/Bulk/Users.svg'),  SizedBox(width: wv*2,), Text("Groupes")],)
                ),
              ],
  
              controller: controller,
            ),
          ),
          // SliverList(
          SliverFillRemaining(
            child: TabBarView(
              controller: controller,
              children: <Widget>[
                Center(child: Text("Actualités")),
                Center(child: Text("Amis")),
                Center(child: Text("Groupes")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}