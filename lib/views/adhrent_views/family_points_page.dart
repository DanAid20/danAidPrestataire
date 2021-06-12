import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/adhrent_views/family_badge_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class FamilyPointsPage extends StatefulWidget {
  const FamilyPointsPage({ Key key }) : super(key: key);

  @override
  _FamilyPointsPageState createState() => _FamilyPointsPageState();
}

class _FamilyPointsPageState extends State<FamilyPointsPage> {
  
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {

    final PageController controller = PageController(initialPage: currentPage);
    List<Widget> _pages = [
      FamilyPoints(),
      FamilyBadgePage(),
    ];

    return Stack(
      children: [
        Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: currentPage == 0 ? kDeepTeal : whiteColor),
                onPressed: ()=>Navigator.pop(context)
              ),
              title: Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Démarrer", style: TextStyle(color: currentPage == 0 ? kDeepTeal : whiteColor.withOpacity(0.7), fontSize: 20, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
                  Text(DateTime.now().day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(DateTime.now())+" "+ DateTime.now().year.toString(), style: TextStyle(color: currentPage == 0 ? kDeepTeal : kSouthSeas, fontSize: wv*3.8, fontWeight: FontWeight.w300),),
                ],
              ),
              centerTitle: true,
              actions: [
                IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kSouthSeas,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
                IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: (){})
              ],
            ),
          body: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              PageView(
                scrollDirection: Axis.horizontal,
                controller: controller,
                onPageChanged: (int page) {
                  getChangedPageAndMoveBar(page);
                },
                children: _pages
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < _pages.length; i++)
                      if (i == currentPage) ...[circleBar(isActive: true, light: currentPage == 0)] else
                        circleBar(isActive: false, light: currentPage == 0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPage = page;
    setState(() {});
  }
  
  Widget circleBar({bool isActive, bool light}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 10 : 6,
      width: isActive ? 10 : 6,
      decoration: BoxDecoration(
          color: isActive ? light ? kDeepTeal : kSouthSeas : light ? Colors.grey : Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

}

class FamilyPoints extends StatefulWidget {
  const FamilyPoints({ Key key }) : super(key: key);

  @override
  _FamilyPointsState createState() => _FamilyPointsState();
}

class _FamilyPointsState extends State<FamilyPoints> {
  @override
  Widget build(BuildContext context) {

    UserProvider userProvider = Provider.of<UserProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);

    List visits = userProvider.getUserModel.visits;

    int totalPoints = userProvider.getUserModel.points;

    int points = 0;
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    int monday = now.subtract(Duration(days: DateTime.now().weekday-1)).millisecondsSinceEpoch;
    int sunday = now.add(Duration(days: 7-DateTime.now().weekday)).millisecondsSinceEpoch;
    for(int i=0; i < visits.length; i++){
      int date = visits[i].toDate().millisecondsSinceEpoch;
      if(date > monday && date <= sunday)
        points = points + 25;
    }

    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                color: kSouthSeas.withOpacity(0.4),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: kDeepTeal,
              ),
            )
          ],
        ),
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: wv*4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: hv*13,),
                Text("Points", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: kDeepTeal),),
                SizedBox(height: hv*3,),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Cette\nSemaine", style: TextStyle(fontSize: 27, fontWeight: FontWeight.w400, color: kDeepTeal)),
                            Text("Vous avez gagnez $points sur 175 possibles", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: kTextBlue))
                          ],
                        ),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              shape: BoxShape.circle
                            ),
                          ),
                          CircularPercentIndicator(
                            radius: 140,
                            lineWidth: 25,
                            animation: true,
                            animationDuration: 1000,
                            percent: points/175,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(points.toString(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: kTextBlue)),
                                Text("de 175 Pts", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextBlue)),
                              ],
                            ),
                            progressColor: kDeepTeal,
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(),
                      )
                    ],
                  ),
                ),
                SizedBox(height: hv*5,),
                Text("Total", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: kDeepTeal),),
                SizedBox(height: hv*2,),
                Text("Jusqu'au 31/12/2021", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextBlue)),
                Text("Gagnez 25 points par jour\nGénéraliste, Médecin de Famille", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: kTextBlue)),
                SizedBox(height: hv*2,),
                Text("$totalPoints Pts", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: kDeepTeal),),
                SizedBox(height: hv*0.5,),
                SizedBox(
                  width: wv*63,
                  child: LinearPercentIndicator(
                    animation: true,
                    lineHeight: 27,
                    animationDuration: 1000,
                    percent: totalPoints/9125,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: kDeepTeal,
                    backgroundColor: whiteColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}