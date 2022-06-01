import 'dart:ui';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/providers/notificationModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/getPlatform.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
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
  TabController? _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  double iconSize = Device.isSmartphone(context) ? 15 : 25;
  double space = Device.isSmartphone(context) ? wv*2 : 15;
  EdgeInsetsGeometry iconMargin = EdgeInsets.only(left: Device.isSmartphone(context) ? 0 : 50, bottom: Device.isSmartphone(context) ? 10 : 30);
  List<Widget> tabs = <Widget>[
    Tab(child: Row(children: [SvgPicture.asset('assets/icons/Bulk/Hands.svg', width: iconSize,), SizedBox(width: space), Text(S.current.bienvenue)],), iconMargin: iconMargin,),
    Tab(child: Row(children: [SvgPicture.asset('assets/icons/Bulk/people-safe.svg', width: iconSize), SizedBox(width: space), Text(S.current.maCouverture)],), iconMargin: iconMargin,),
    Tab(child: Row(children: [SvgPicture.asset('assets/icons/Bulk/people-safe-one.svg', width: iconSize), SizedBox(width: space), Text(S.current.monDocteur)],)),
  ];
  List<Widget> tabsDoctor = <Widget>[
    Tab(child: Row(children: [SvgPicture.asset('assets/icons/Bulk/Hands.svg', width: iconSize), SizedBox(width: space), Text(S.current.bienvenue)],),),
    Tab(child: Row(children: [SvgPicture.asset('assets/icons/Bulk/StethoscopeMini.svg', width: iconSize), SizedBox(width: space), Text(S.current.mesServices)],),),
    Tab(child: Row(children: [SvgPicture.asset('assets/icons/Bulk/Vector.svg', width: iconSize), SizedBox(width: space), Text(S.current.mesRendezvous)],),)
  ];
    
    UserProvider userProvider = Provider.of<UserProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context);
    NotificationModelProvider notifications = Provider.of<NotificationModelProvider>(context);
    final birthday = userProvider.getUserModel != null ? userProvider.getUserModel?.dateCreated?.toDate() : DateTime.now();
    final date2 = DateTime.now();
    final yearsForBadget= date2.difference(birthday!).inDays;
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
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      elevation: 1.0,
                      toolbarHeight: Device.isSmartphone(context) ? hv * 12 : 125,
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
                                onTap: () => Navigator.pushNamed(context, "/notifications"),
                                child: Container(padding: EdgeInsets.all(Device.isSmartphone(context) ? wv * 3 : 15), child: SvgPicture.asset("assets/icons/Two-tone/Notification2.svg", width: Device.isSmartphone(context) ? wv*7 : 45,)),
                              ),
                            ),
                            notifications.unSeen == 0 ? Container() : Positioned(
                              right: wv * 2,
                              top: hv * 1,
                              child: Container(
                                padding: EdgeInsets.all(4.5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                    color: Colors.yellow
                                  ),
                                child: Text(
                                  notifications.unSeen.toString(),
                                  style: TextStyle(
                                      fontSize: Device.isSmartphone(context) ? wv * 2.7 : 17,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                            Positioned(
                              right: wv * 1,
                              top: hv * 8,
                              child: Row(
                                children: [
                                  userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary ? InkWell(
                                    onTap: ()=>Navigator.pushNamed(context, '/family-points-page'),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                                      child: Text(
                                        userProvider.getUserModel != null ? "${userProvider.getUserModel?.points != null ? userProvider.getUserModel!.points : 0} pts" : "0 pts",
                                        style: TextStyle(fontSize: Device.isSmartphone(context) ? inch * 1.3 : 19, fontWeight: FontWeight.w700, color: Colors.teal[400]),
                                      ),
                                    ),
                                  ) : Container(),
                                  SizedBox(
                                    width:Device.isSmartphone(context) ? wv * 2 : 10,
                                  ),
                                  adherentProvider.getAdherent != null ? adherentProvider.getAdherent?.adherentPlan != 0 ? SvgPicture.asset("assets/icons/Bulk/Shield Done.svg", width: Device.isSmartphone(context) ? 18 : 23): Container(): Container(),
                                   yearsForBadget>=365 ?SvgPicture.asset("assets/icons/Bulk/Ticket Star.svg", width: Device.isSmartphone(context) ? 18 : 23,) : SizedBox.shrink()
                                ],
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
                          labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: Device.isSmartphone(context) ? inch * 1.7 : 20),
                          unselectedLabelStyle:TextStyle(fontWeight: FontWeight.w400),
                          tabs: userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary ? tabs : tabsDoctor),
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary
                        ? MyWelcomeScreen()
                        :  HomeDoctorView(),
                    userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary
                        ? MyCoverageTabView()
                        : DoctorPatientView(),
                    userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary
                        ? MyDoctorTabView()
                        : RendezVousDoctorView()
                  ],
                ))),
      ),
    );
  }
}
