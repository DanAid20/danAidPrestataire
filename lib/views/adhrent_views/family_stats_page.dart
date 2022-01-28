import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/drawer.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class FamilyStatsPage extends StatefulWidget {
  const FamilyStatsPage({ Key? key }) : super(key: key);

  @override
  _FamilyStatsPageState createState() => _FamilyStatsPageState();
}

class _FamilyStatsPageState extends State<FamilyStatsPage> {

  final Color barBackgroundColor = Colors.transparent;
  final Duration animDuration = const Duration(milliseconds: 250);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int touchedIndex = -1;

  num healthcare = 0, pills = 0, lab = 0, other = 0;
  num access = 0, assist = 0, serenity = 0, discovery = 0, families = 0, beneficiaries = 0, serviceProviders = 0;
  int members = 1;

  bool isPlaying = false;

  init() {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    try {
      FirebaseFirestore.instance.collection("BENEFICIAIRES").where("adherentId", isEqualTo: adherentProvider.getAdherent!.adherentId).get().then((doc){
        setState(() {
                members = members + doc.docs.length;
        });
      });
    }
    catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() { 
    init();
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);

    AdherentModel? adhr = adherentProvider.getAdherent;

    num coverage = adhr?.adherentPlan == 0 ? 25000 : adhr?.adherentPlan == 1 ? 350000 : adhr?.adherentPlan == 2 ? 650000 : adhr?.adherentPlan == 3 ? 1000000 : 0;
    num expense = coverage - adhr!.insuranceLimit!;
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: kSouthSeas.withOpacity(0.3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kCardTextColor,), 
          onPressed: ()=>Navigator.pop(context)
        ),
        actions: [
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kCardTextColor,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kCardTextColor), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: () => _scaffoldKey.currentState!.openEndDrawer())
        ],
      ),
      endDrawer: DefaultDrawer(
        entraide: (){Navigator.pop(context); Navigator.pop(context);},
        accueil: (){Navigator.pop(context); Navigator.pop(context);},
        carnet: (){Navigator.pop(context); Navigator.pop(context);},
        partenaire: (){Navigator.pop(context); Navigator.pop(context);},
        famille: (){Navigator.pop(context); Navigator.pop(context);},
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('DANAID_DATA').doc('STATISTIQUES').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: Loaders().buttonLoader(kDeepTeal));
          }
          if(snapshot.hasData){
            discovery = snapshot.data!.get("discovery_share");
            access = snapshot.data!.get("acces_share");
            assist = snapshot.data!.get("assist_share");
            serenity = snapshot.data!.get("serenity_share");
            print(discovery);
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: wv*3),
                  color: kSouthSeas.withOpacity(0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: hv*3,),
                      Container(child: Text(S.of(context)!.famille+adhr.familyName!, style: TextStyle(fontSize: 35, color: kCardTextColor),)),
                      Text(
                        adhr.adherentPlan == 0 ? S.of(context)!.vousTesAuNiveau0+S.of(context)!.dcouverte
                        : adhr.adherentPlan == 1 ? S.of(context)!.vousTesAuNiveauI+S.of(context)!.accs
                          : adhr.adherentPlan == 2 ? S.of(context)!.vousTesAuNiveauIi+S.of(context)!.assist
                            : adhr.adherentPlan == 3 ? S.of(context)!.vousTesAuNiveauIii+S.of(context)!.srnit : "...", 
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kCardTextColor),
                      ),
                      SizedBox(height: hv*2,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(S.of(context)!.adhrentDepuis, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kBlueDeep), textAlign: TextAlign.end,),
                            Text(Algorithms.getTimeElapsed(date: adhr.dateCreated!.toDate())!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kBlueDeep))
                          ],
                        ),
                      ),
                      SizedBox(height: hv*1,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: wv*1, vertical: hv*1),
                                  decoration: BoxDecoration(
                                    color: whiteColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              textAlign: TextAlign.end,
                                              text: TextSpan(
                                                style: TextStyle(color: kCardTextColor, fontSize: 15),
                                                children: [
                                                  TextSpan(text: S.of(context)!.vousTesAuNiveau),
                                                  TextSpan(text: adhr.adherentPlan == 0 ? S.of(context)!.dcouverte : adhr.adherentPlan == 1 ? S.of(context)!.accs : adhr.adherentPlan == 2 ? S.of(context)!.assist: adhr.adherentPlan == 3 ? S.of(context)!.srnit : "...", style: TextStyle(color: kBrownCanyon, fontWeight: FontWeight.bold))
                                                ]
                                              ),
                                            ),
                                          ),
                                          SvgPicture.asset('assets/icons/Bulk/Shield Done.svg', width: wv*7,)
                                        ],
                                      ),
                                      
                                    Container(
                                      height: hv*15,
                                      child: /*BarChart(
                                        mainBarData(),
                                        swapAnimationDuration: animDuration,
                                      ),*/
                                      Row(
                                        children: [
                                          getHistogram(
                                            title: "Découverte",
                                            color: kDeepTeal,
                                            value: discovery
                                          ),
                                          getHistogram(
                                            title: "Accès",
                                            color: kBrownCanyon,
                                            value: access
                                          ),
                                          getHistogram(
                                            title: "Assist",
                                            color: kPrimaryColor,
                                            value: assist
                                          ),
                                          getHistogram(
                                            title: "Sérénité",
                                            color: kSouthSeas,
                                            value: serenity
                                          ),
                                        ],
                                      )
                                    ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: hv*1,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: wv*1, vertical: hv*1),
                                        height: hv*13.5,
                                        decoration: BoxDecoration(
                                          color: whiteColor.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Plafond restant:", style: TextStyle(color: kPrimaryColor, fontSize: 13),),
                                            Text("${adhr.insuranceLimit} f.", style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold),),
                                            SizedBox(height: hv*0.5,),
                                            Center(
                                              child: CircularPercentIndicator(
                                                radius: wv*12,
                                                lineWidth: wv*2,
                                                animation: true,
                                                animationDuration: 500,
                                                percent: adhr.insuranceLimit! >= coverage ? 1 : adhr.insuranceLimit!/coverage,
                                                center: Text("${((adhr.insuranceLimit!/coverage)*100).round()}%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kDeepTeal)),
                                                progressColor: kDeepTeal,
                                                backgroundColor: kSouthSeas,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ),
                                    SizedBox(width: wv*2,),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*0.5),
                                      height: hv*13.5,
                                      decoration: BoxDecoration(
                                        color: kDeepTeal,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          SizedBox(height: hv*0.5,),
                                          Text("Couverture à", style: TextStyle(color: whiteColor),),
                                          SizedBox(height: hv*1,),
                                          Text("70%", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 40))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: hv*1,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*1),
                                  decoration: BoxDecoration(
                                    color: whiteColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Notre Communauté", style: TextStyle(color: kPrimaryColor, fontSize: 12)),
                                            SizedBox(height: hv*1,),
                                            Text(snapshot.data!["families"].toString(), style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold, fontSize: 18)),
                                            Text("Familles", style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold, fontSize: 12)),
                                            Text(snapshot.data!["beneficiaries"].toString(), style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold, fontSize: 18)),
                                            Text("Bénéficiaires", style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold, fontSize: 12)),
                                            Text(snapshot.data!["service_providers"].toString(), style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold, fontSize: 18)),
                                            Text("Prestataires", style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Image.asset('assets/images/Cameroon.png'),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: wv*3,),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: wv*1, vertical: hv*1),
                                  decoration: BoxDecoration(
                                    color: whiteColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: hv*0.5,),
                                      Row(
                                        children: [
                                          Expanded(child: Text(S.of(context)!.votreConsommation, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kCardTextColor))),
                                        ],
                                      ),
                                      SizedBox(height: hv*1.5,),
                                      AspectRatio(
                                        aspectRatio: 1,
                                        child: Stack(
                                          alignment: AlignmentDirectional.center,
                                          children: [
                                            Container(
                                              width: 60,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [ 
                                                  Text("${(coverage - adhr.insuranceLimit!)}Cfa", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kDeepTeal), textAlign: TextAlign.center,),
                                                  Text(S.of(context)!.deFraisSant, style: TextStyle(fontSize: 11, color: kDeepTeal), textAlign: TextAlign.center),
                                                ],
                                              ),
                                            ),
                                            PieChart(
                                              PieChartData(
                                                  pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                                                    setState(() {
                                                      final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                                                          pieTouchResponse.touchInput is! PointerUpEvent;
                                                      if (desiredTouch && pieTouchResponse.touchedSection != null) {
                                                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                                      } else {
                                                        touchedIndex = -1;
                                                      }
                                                    });
                                                  }),
                                                  borderData: FlBorderData(
                                                    show: false,
                                                  ),
                                                  sectionsSpace: 0,
                                                  centerSpaceRadius: 40,
                                                  sections: showingSections()),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: hv*3,),
                                      getIndicator(color: kSouthSeas, label: S.of(context)!.mdecineSoin, percentage: healthcare),
                                      getIndicator(color: kBlueDeep, label: S.of(context)!.mdicaments, percentage: pills),
                                      getIndicator(color: kBrownCanyon, label: S.of(context)!.laboratoire, percentage: lab),
                                      getIndicator(color: primaryColor, label: S.of(context)!.autres, percentage: other),
                                      SizedBox(height: hv*2,),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("DanAid", style: TextStyle(color: kTextBlue, fontSize: 12),),
                                              Text("${(expense*0.7)} f.", style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold, fontSize: 13))
                                          ],),
                                          Spacer(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text("Vous", style: TextStyle(color: kTextBlue, fontSize: 12),),
                                              Text("${expense*0.3} f.", style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold, fontSize: 13))
                                          ],),
                                        ]
                                      ),
                                      LinearPercentIndicator(
                                        animation: true,
                                        lineHeight: 10,
                                        animationDuration: 1000,
                                        percent: 0.7,
                                        linearStrokeCap: LinearStrokeCap.roundAll,
                                        progressColor: kDeepTeal,
                                        backgroundColor: whiteColor,
                                        center: Text("70%", style: TextStyle(color: whiteColor, fontSize: 9, fontWeight: FontWeight.bold),),
                                      ),
                                      SizedBox(height: hv*0.5,)
                                      
                                    ],
                                  ),
                                ),
                                SizedBox(height: hv*1,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: wv*1, vertical: hv*1),
                                  decoration: BoxDecoration(
                                    color: whiteColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Votre famille compte:", style: TextStyle(color: kPrimaryColor, fontSize: 12),),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(members.toString(), style: TextStyle(color: kDeepTeal, fontSize: 40, fontWeight: FontWeight.bold)),
                                                Text(members == 1 ? "Personne" : "Personnes", style: TextStyle(color: kDeepTeal, fontSize: 12, fontWeight: FontWeight.bold))
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                height: hv*9.5,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    SizedBox(height: hv*0.5,),
                                                    Text("Max.", style: TextStyle(color: kSouthSeas, fontWeight: FontWeight.bold)),
                                                    Spacer(),
                                                    Container(
                                                      height: hv*6.4,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          SizedBox(height: hv*0.5,),
                                                          Text("Moy.", style: TextStyle(color: kBrownCanyon.withOpacity(0.7), fontWeight: FontWeight.bold)),
                                                          Spacer(),
                                                          Container(
                                                            height: hv*3.2,
                                                            child: Text("Vous", style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold),),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: wv*1,),
                                              Container(
                                                height: hv*9.5,
                                                decoration: BoxDecoration(
                                                  color: kSouthSeas,
                                                  borderRadius: BorderRadius.circular(7)
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    SizedBox(height: hv*0.5,),
                                                    Text("9", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold)),
                                                    Spacer(),
                                                    Container(
                                                      height: hv*6.4,
                                                      decoration: BoxDecoration(
                                                        color: kBrownCanyon.withOpacity(0.7),
                                                        borderRadius: BorderRadius.circular(7)
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          SizedBox(height: hv*0.5,),
                                                          Text("4", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold)),
                                                          Spacer(),
                                                          Container(
                                                            height: hv*3.2,
                                                            width: wv*7,
                                                            padding: EdgeInsets.symmetric(horizontal: wv*1, vertical: hv*0.5),
                                                            decoration: BoxDecoration(
                                                              color: kDeepTeal,
                                                              borderRadius: BorderRadius.circular(7)
                                                            ),
                                                            child: Center(child: Text("$members", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: hv*2.5,)
                    ],
                  ),
                ),
                SizedBox(height: hv*3,),
                Container(child: Text(S.of(context)!.vosStatistiques, style: TextStyle(fontSize: 40, color: kCardTextColor, fontWeight: FontWeight.bold)), padding: EdgeInsets.symmetric(horizontal: wv*5),),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*1),
                  child: Text(
                    adhr.adherentPlan == 0 ? S.of(context)!.vousTesAuNiveauDcouverteComme40DeNosAdhrents
                    : adhr.adherentPlan == 1 ? S.of(context)!.vousTesAuNiveauAccsComme30DeNosAdhrents
                      : adhr.adherentPlan == 2 ? S.of(context)!.vousTesAuNiveauAssistComme20DeNosAdhrents
                        : adhr.adherentPlan == 3 ? S.of(context)!.vousTesAuNiveauSrnitComme10DeNosAdhrents : "...", 
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kCardTextColor),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 50,
    List<int> showTooltips = const [40, 30, 20, 10],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          borderRadius: BorderRadius.circular(10),
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(4, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 40, isTouched: i == touchedIndex, barColor: kDeepTeal);
          case 1:
            return makeGroupData(1, 30, isTouched: i == touchedIndex, barColor: kBrownCanyon);
          case 2:
            return makeGroupData(2, 20, isTouched: i == touchedIndex, barColor: kBlueDeep);
          case 3:
            return makeGroupData(3, 10, isTouched: i == touchedIndex, barColor: kSouthSeas);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      //maxY: 100,
      barTouchData: BarTouchData(
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerExitEvent) {
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(color: kCardTextColor, fontSize: 11),
          margin: 3,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return S.of(context)!.dcouverte;
              case 1:
                return S.of(context)!.accs;
              case 2:
                return S.of(context)!.assist;
              case 3:
                return S.of(context)!.srnit;
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      await refreshState();
    }
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 30.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: kDeepTeal,
            value: 100.0 - healthcare - pills - lab - other,
            radius: radius,
            showTitle: false
          );
        case 1:
          return PieChartSectionData(
            color: kSouthSeas,
            value: healthcare.toDouble(),
            radius: radius,
            showTitle: false
          );
        case 2:
          return PieChartSectionData(
            color: kBlueDeep,
            value: pills.toDouble(),
            radius: radius,
            showTitle: false
          );
        case 3:
          return PieChartSectionData(
            color: kBrownCanyon,
            value: lab.toDouble(),
            radius: radius,
            showTitle: false
          );
        case 4:
          return PieChartSectionData(
            color: primaryColor,
            value: other.toDouble(),
            radius: radius,
            showTitle: false
          );
        default:
          throw Error();
      }
    });
  }

  Widget getIndicator({required num percentage, required Color color, required String label}){
    return Row(
      children: [
        SizedBox(width: 2.5,),
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        SizedBox(width: 2.5,),
        Text("$percentage %", style: TextStyle(fontSize: 13, color: kCardTextColor, fontWeight: FontWeight.bold)),
        SizedBox(width: 5,),
        Text(label, style: TextStyle(fontSize: 12, color: kCardTextColor))
      ],
    );
  }
  Widget getHistogram({required String title, required Color color, required num value}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              margin: EdgeInsets.symmetric(horizontal: wv*0.5),
              width: wv*12,
              height: hv*15*value,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5)
              )
            ),
            Column(
              children: [
                Text("${value*100} %", style: TextStyle(color: whiteColor, fontSize: 10, fontWeight: FontWeight.bold),),
                SizedBox(height: 2,)
              ],
            ),
          ],
        ),
        Text(title, style: TextStyle(fontSize: 9, color: kTextBlue),)
      ],
    );
  }
}