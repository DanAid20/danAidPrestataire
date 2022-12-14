import 'dart:ui';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/adhrent_views/my_coverage_tab.dart';
import 'package:danaid/views/adhrent_views/my_doctor_tab.dart';
import 'package:danaid/views/doctor_views/tabs_doctor_views/doctor_patient_view.dart';
import 'package:danaid/views/doctor_views/tabs_doctor_views/rendez_vous_doctor.dart';
import 'package:danaid/widgets/user_avatar_coverage.dart';
import 'package:danaid/views/adhrent_views/my_welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../doctor_views/tabs_doctor_views/home_doctor_view.dart';

class HelloScreen extends StatefulWidget {
  @override
  _HelloScreenState createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = <Widget>[
    Tab(
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/Bulk/Hands.svg'),
          SizedBox(
            width: wv * 2,
          ),
          Text("Bienvenue")
        ],
      )
    ),
    Tab(
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/Bulk/people-safe.svg'),
          SizedBox(
            width: wv * 2,
          ),
          Text("Ma Couverture")
        ],
      )
    ),
    Tab(
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/Bulk/people-safe-one.svg'),
          SizedBox(
            width: wv * 2,
          ),
          Text("Mon Docteur")
        ],
      )
    ),
  ];
  List tabsDoctor = <Widget>[
    Tab(
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/Bulk/Hands.svg'),
          SizedBox(
            width: wv * 2,
          ),
          Text("Bienvenue")
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/Bulk/StethoscopeMini.svg'),
          SizedBox(
            width: wv * 2,
          ),
          Text("Mes Services")
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/Bulk/Vector.svg'),
          SizedBox(
            width: wv * 2,
          ),
          Text("Mes Rendez-vous")
        ],
      ),
    )
  ];
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    UserProvider userProvider = Provider.of<UserProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context);
    final birthday = userProvider.getUserModel != null ? userProvider.getUserModel.dateCreated.toDate() : DateTime.now();
    final date2 = DateTime.now();
    final yearsForBadget= date2.difference(birthday).inDays;
    return WillPopScope(
      onWillPop: () async {
        controller.toPreviousIndex();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[100],
            body: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      elevation: 1.0,
                      toolbarHeight: hv * 12,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.white,
                      title: Column(
                        children: [
                          UserAvatarAndCoverage(),
                        ],
                      ),
                      actions: [
                        Stack(
                          children: [
                            SizedBox(width: wv * 30),
                            Positioned(
                              right: 0,
                              child: InkWell(
                                onTap: () => Navigator.pushNamed(context, "/chatroom"),
                                child: Container(
                                    padding: EdgeInsets.all(wv * 3),
                                    child: SvgPicture.asset(
                                      "assets/icons/Two-tone/Notification2.svg",
                                      width: wv * 7,
                                    )),
                              ),
                            ),
                            /*Positioned(
                              right: wv * 1,
                              top: hv * 1,
                              child: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text(
                                  "9+",
                                  style: TextStyle(
                                      fontSize: wv * 2.2,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),*/
                            Positioned(
                              right: wv * 1,
                              top: hv * 8,
                              child: Container(
                                child: Row(
                                  children: [
                                    userProvider.getProfileType == adherent ? Text(
                                      userProvider.getUserModel != null ? userProvider.getUserModel.points.toString()+" pts" ?? "0 pts" : "0 pts",
                                      style: TextStyle(
                                          fontSize: inch * 1.3,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.teal[400]),
                                    ) : Container(),
                                    SizedBox(
                                      width: wv * 2,
                                    ),
                                    adherentProvider.getAdherent != null ? adherentProvider.getAdherent.adherentPlan != 0 ? SvgPicture.asset(
                                      "assets/icons/Bulk/Shield Done.svg",
                                      width: 18,
                                    ): Container(): Container(),
                                     yearsForBadget>=365 ?SvgPicture.asset("assets/icons/Bulk/Ticket Star.svg", width: 18,) : SizedBox.shrink()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      pinned: true,
                      floating: true,
                      bottom: TabBar(
                          indicatorWeight: 3,
                          indicatorColor: kPrimaryColor,
                          isScrollable: true,
                          controller: _tabController,
                          labelColor: kPrimaryColor,
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: inch * 1.7),
                          unselectedLabelStyle:
                              TextStyle(fontWeight: FontWeight.w400),
                          tabs: userProvider.getProfileType == adherent
                              ? tabs
                              : tabsDoctor),
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    userProvider.getProfileType == adherent
                        ? MyWelcomeScreen()
                        :  HomeDoctorView(),
                    userProvider.getProfileType == adherent
                        ? MyCoverageTabView()
                        : DoctorPatientView(),
                    userProvider.getProfileType == adherent
                        ? MyDoctorTabView()
                        : RendezVousDoctorView()
                  ],
                ))),
      ),
    );
  }
}
