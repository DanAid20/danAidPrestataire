import 'dart:math';

import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FamilyStatsPage extends StatefulWidget {
  const FamilyStatsPage({ Key key }) : super(key: key);

  @override
  _FamilyStatsPageState createState() => _FamilyStatsPageState();
}

class _FamilyStatsPageState extends State<FamilyStatsPage> {

  final Color barBackgroundColor = Colors.transparent;
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  num healthcare = 13, pills = 6, lab = 5, other = 4;

  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {

    UserProvider userProvider = Provider.of<UserProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);

    AdherentModel adhr = adherentProvider.getAdherent;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSouthSeas.withOpacity(0.3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kCardTextColor,), 
          onPressed: ()=>Navigator.pop(context)
        ),
        actions: [
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kCardTextColor,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kCardTextColor), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: (){})
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: wv*3),
            color: kSouthSeas.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: hv*3,),
                Container(child: Text("Famille "+adhr.familyName, style: TextStyle(fontSize: 35, color: kCardTextColor),)),
                Text(
                  adhr.adherentPlan == 0 ? "Vous êtes au Niveau 0: Découverte"
                  : adhr.adherentPlan == 1 ? "Vous êtes au Niveau I: Accès"
                    : adhr.adherentPlan == 2 ? "Vous êtes au Niveau II: Assist"
                      : adhr.adherentPlan == 3 ? "Vous êtes au Niveau III: Sérénité" : "...", 
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kCardTextColor),
                ),
                SizedBox(height: hv*2,),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Adhérent depuis", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kBlueDeep), textAlign: TextAlign.end,),
                      Text(Algorithms.getTimeElapsed(date: adhr.dateCreated.toDate()), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kBlueDeep))
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
                                            TextSpan(text: "Vous êtes au niveau "),
                                            TextSpan(text: adhr.adherentPlan == 0 ? "Découverte" : adhr.adherentPlan == 1 ? "Accès" : adhr.adherentPlan == 2 ? "Assist": adhr.adherentPlan == 3 ? "Sérénité" : "...", style: TextStyle(color: kBrownCanyon, fontWeight: FontWeight.bold))
                                          ]
                                        ),
                                      ),
                                    ),
                                    SvgPicture.asset('assets/icons/Bulk/Shield Done.svg', width: wv*7,)
                                  ],
                                ),
                                
                              Container(
                                height: hv*15,
                                child: BarChart(
                                  mainBarData(),
                                  swapAnimationDuration: animDuration,
                                ),
                              ),
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
                                    Expanded(child: Text("Votre Consommation", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kCardTextColor))),
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
                                            Text("200.000Cfa", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kDeepTeal), textAlign: TextAlign.center,),
                                            Text("de frais santé", style: TextStyle(fontSize: 11, color: kDeepTeal), textAlign: TextAlign.center),
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
                                                  touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
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
                                getIndicator(color: kSouthSeas, label: "Médecine & soin", percentage: healthcare),
                                getIndicator(color: kBlueDeep, label: "Médicaments", percentage: pills),
                                getIndicator(color: kBrownCanyon, label: "Laboratoire", percentage: lab),
                                getIndicator(color: primaryColor, label: "Autres", percentage: other),
                                
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
          Container(child: Text("Vos Statistiques", style: TextStyle(fontSize: 40, color: kCardTextColor, fontWeight: FontWeight.bold)), padding: EdgeInsets.symmetric(horizontal: wv*5),),
          Container(
            padding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*1),
            child: Text(
              adhr.adherentPlan == 0 ? "Vous êtes au Niveau Découverte comme 40% de nos adhérents"
              : adhr.adherentPlan == 1 ? "Vous êtes au Niveau Accès comme 30% de nos adhérents"
                : adhr.adherentPlan == 2 ? "Vous êtes au Niveau Assist comme 20% de nos adhérents"
                  : adhr.adherentPlan == 3 ? "Vous êtes au Niveau Sérénité comme 10% de nos adhérents" : "...", 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kCardTextColor),
            ),
          ),
        ],
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
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
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
          getTextStyles: (value) =>
              const TextStyle(color: kCardTextColor, fontSize: 11),
          margin: 3,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'Découverte';
              case 1:
                return 'Accès';
              case 2:
                return 'Assist';
              case 3:
                return 'Sérénité';
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

  Widget getIndicator({num percentage, Color color, String label}){
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
}