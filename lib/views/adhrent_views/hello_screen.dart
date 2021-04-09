import 'dart:ui';
import 'package:danaid/core/providers/adherentProvider.dart';
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

class _HelloScreenState extends State<HelloScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = <Widget>[
    const Tab(
      text: "Bienvenue",
    ),
    const Tab(
      text: "Ma Couverture",
    ),
    const Tab(
      text: "Mon Docteur",
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
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    //AdherentProvider adherentProvider = Provider.of<AdherentProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
          body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
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
                              onTap: () {},
                              child: Container(
                                  padding: EdgeInsets.all(wv * 3),
                                  child: SvgPicture.asset(
                                    "assets/icons/Two-tone/Notification.svg",
                                    width: wv * 7,
                                  )),
                            ),
                          ),
                          Positioned(
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
                          ),
                          Positioned(
                            right: wv * 1,
                            top: hv * 8,
                            child: Container(
                              child: Row(
                                children: [
                                  Text(
                                    "12 000 Pts",
                                    style: TextStyle(
                                        fontSize: inch * 1.3,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.teal[400]),
                                  ),
                                  SizedBox(
                                    width: wv * 2,
                                  ),
                                  SvgPicture.asset(
                                    "assets/icons/Bulk/Shield Done.svg",
                                    width: 18,
                                  ),
                                  SvgPicture.asset(
                                    "assets/icons/Bulk/Ticket Star.svg",
                                    width: 18,
                                  ),
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
                        tabs: userProvider.getProfileType == doctor
                            ? tabsDoctor
                            : tabs),
                  )
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  userProvider.getProfileType == doctor
                      ? HomeDoctorView()
                      : MyWelcomeScreen(),
                  userProvider.getProfileType == doctor
                      ? DoctorPatientView()
                      : MyCoverageTabView(),
                  userProvider.getProfileType == doctor
                      ? RendezVousDoctorView()
                      : MyDoctorTabView()
                ],
              ))),
    );
  }
}
