import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/planModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/planModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/services/getPlatform.dart';

class ComparePlans extends StatefulWidget {
  @override
  _ComparePlansState createState() => _ComparePlansState();
}

class _ComparePlansState extends State<ComparePlans> {

  num isDecouverte = 0;
  num isAcces = 1;
  num isAssist = 2;
  num isSerenity = 3;
  num isAcademik = 1.1;
  num? state;
  Map<num, PlanModel> plans = {};
  PlanModel? currentPlan;

  getPlans() async {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);

    await FirebaseFirestore.instance.collection("SERVICES_LEVEL_CONFIGURATION").get().then((snap) {
      var docs = snap.docs;
      for(int i = 0; i < docs.length; i++){
        PlanModel docModel = PlanModel.fromDocument(docs[i], docs[i].data());
        plans[docModel.planNumber!] = docModel;
      }
      setState(() {
        currentPlan = plans[adherentProvider.getAdherent!.adherentPlan!];
        state = adherentProvider.getAdherent!.adherentPlan;
      });
    });
  }

  changePlan(num plan) async {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    PlanModelProvider planProvider = Provider.of<PlanModelProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).set({
      "protectionLevel": plan,
      //"datDebutvalidite" : DateTime.now(),
      //"datFinvalidite": DateTime.now().add(Duration(days: 365)),
      "paid": false,
    }, SetOptions(merge: true));
    setState(() {
      //spinner2 = false;
    });
    planProvider.setPlanModel(plans[plan]!);
    adherentProvider.setAdherentPlan(plan);
    Navigator.of(context).pushNamed('/contributions');
  }

  @override
  void initState() {
    getPlans();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    PlanModelProvider planProvider = Provider.of<PlanModelProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    DateTime? limit = adherentProvider.getAdherent?.validityEndDate?.toDate();
    String limitString = limit!.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(limit)+" "+ limit.year.toString();

    String yes = 'assets/icons/Bulk/TickSquare.svg';
    String no = 'assets/icons/Bulk/CloseSquare.svg';

    Color good = Colors.teal[300]!;
    Color bad = Colors.red.withOpacity(0.4);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,),
          onPressed: ()=>Navigator.pop(context)
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(S.of(context).comparerLesServices, style: TextStyle(color: kPrimaryColor, fontSize: Device.isSmartphone(context) ? wv*4.2 : 22.5, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
            Text(S.of(context).modifierMaCouverture,
              style: const TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),
              child: SizedBox(
                width: Device.isSmartphone(context) ? wv*100 : 1000,
                child: HomePageComponents.getInfoActionCard(
                  title: Algorithms.getPlanDescriptionText(plan: adherentProvider.getAdherent!.adherentPlan),
                  actionLabel: S.of(context).comparerLesServices,
                  subtitle: S.of(context).vousTesCouvertsJusquau+limitString,
                  noAction: true,
                  noPadding: Device.isSmartphone(context) ? false : true,
                  context: context
                ),
              ),
            ),
            SizedBox(height: hv*1,),

            currentPlan != null && state != null ? Row(
              children: [
                Device.isSmartphone(context) ? Container() : Expanded(flex: 1, child: Container()),
                Table(
                  defaultColumnWidth: FixedColumnWidth(Device.isSmartphone(context) ? wv*30 : 250),
                  columnWidths: <int, TableColumnWidth>{0 : FixedColumnWidth(Device.isSmartphone(context) ? 200 : 250)},
                  children: [
                    TableRow(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: wv*2),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: kDeepTeal, fontSize: 16),
                              children: [
                                TextSpan(text: plans[state]!.label! +'\n', style: TextStyle(fontSize: 30)),
                                TextSpan(text: plans[state]!.monthlyAmount.toString(), style: TextStyle(fontSize: 25)),
                                TextSpan(text: S.of(context).cfan),
                                TextSpan(text: S.of(context).parFamilleMois),
                              ]
                            )
                          ),
                        )
                      ]
                    ),
                    TableRow(children: [defaultCell(text: S.of(context).couvertureSant, center: false)]),
                    TableRow(children: [defaultCell(text: S.of(context).plafondAnnuel, center: false)]),
                    TableRow(children: [defaultCell(text: "Prêt santé", center: false)]),
                    TableRow(children: [defaultCell(text: "taux d'intérêt", center: false)]),
                    TableRow(children: [defaultCell(text: "Médecin de famille gratuit", center: false)]),
                    TableRow(children: [defaultCell(text: "Réseau d'entraide", center: false)]),
                    TableRow(children: [defaultCell(text: "Gagner des points", subtitle: "1 pt = 0,5 Cfa", center: false)]),
                    TableRow(children: [defaultCell(text: "Couverture familiale", subtitle: "Jusqu'a 5 personnes", center: false)]),
                  ],
                ),
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    //physics: const BouncingScrollPhysics(),
                    child: Table(
                      defaultColumnWidth: FixedColumnWidth(Device.isSmartphone(context) ? wv*30 : 200),
                      children: [
                        TableRow(
                          children: [
                            headerCell(text: S.of(context).niveau0, icon: 'assets/icons/Bulk/HeartOutline.svg', isActive: state == isDecouverte),
                            headerCell(text: S.of(context).niveauI, icon: 'assets/icons/Bulk/ShieldAcces.svg', isActive: state == isAcces),
                            headerCell(text: "Niveau I.I", icon: 'assets/icons/Bulk/ShieldAcces.svg', isActive: state == isAcademik),
                            headerCell(text: S.of(context).niveauIi, icon: 'assets/icons/Bulk/ShieldAssist.svg', isActive: state == isAssist),
                            headerCell(text: S.of(context).niveauIii, icon: 'assets/icons/Bulk/ShieldSerenity.svg', isActive: state == isSerenity),
                          ]
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: whiteColor),
                          children: [
                            defaultCell(text: plans[0]!.coveragePercentage.toString()+"%", fontSize: 30, textColor: kDeepTeal, isActive: state == isDecouverte),
                            defaultCell(text: plans[1]!.coveragePercentage.toString()+" %", fontSize: 30, textColor: kDeepTeal, isActive: state == isAcces),
                            defaultCell(text: plans[1.1]!.coveragePercentage.toString()+" %", fontSize: 30, textColor: kDeepTeal, isActive: state == isAcademik),
                            defaultCell(text: plans[2]!.coveragePercentage.toString()+" %", fontSize: 30, textColor: kDeepTeal, isActive: state == isAssist),
                            defaultCell(text: plans[3]!.coveragePercentage.toString()+" %", fontSize: 30, textColor: kDeepTeal, isActive: state == isSerenity)
                          ]
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: whiteColor),
                          children: [
                            defaultCell(text: plans[0]!.annualLimit.toString()+"Cfa", fontSize: 16, isActive: state == isDecouverte),
                            defaultCell(text: plans[1]!.annualLimit.toString()+"Cfa", fontSize: 16, isActive: state == isAcces),
                            defaultCell(text: plans[1.1]!.annualLimit.toString()+"Cfa", fontSize: 16, isActive: state == isAcademik),
                            defaultCell(text: plans[2]!.annualLimit.toString()+"Cfa", fontSize: 16, isActive: state == isAssist),
                            defaultCell(text: plans[3]!.annualLimit.toString()+"Cfa", fontSize: 16, isActive: state == isSerenity)
                          ]
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: whiteColor),
                          children: [
                            defaultCell(text: plans[0]!.annualLimit.toString()+"Cfa", fontSize: 16, isActive: state == isDecouverte),
                            defaultCell(text: plans[1]!.maxCreditAmount.toString()+"Cfa", fontSize: 16, isActive: state == isAcces),
                            defaultCell(text: plans[1.1]!.maxCreditAmount.toString()+"Cfa", fontSize: 16, isActive: state == isAcademik),
                            defaultCell(text: plans[2]!.maxCreditAmount.toString()+"Cfa", fontSize: 16, isActive: state == isAssist),
                            defaultCell(text: plans[3]!.maxCreditAmount.toString()+"Cfa", fontSize: 16, isActive: state == isSerenity)
                          ]
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: whiteColor),
                          children: [
                            defaultCell(text: (plans[0]!.creditRate!*100).toString()+"%", fontSize: 16, isActive: state == isDecouverte),
                            defaultCell(text: (plans[1]!.creditRate!*100).toString()+"%", fontSize: 16, isActive: state == isAcces),
                            defaultCell(text: (plans[1.1]!.creditRate!*100).toString()+"%", fontSize: 16, isActive: state == isAcademik),
                            defaultCell(text: (plans[2]!.creditRate!*100).toString()+"%", fontSize: 16, isActive: state == isAssist),
                            defaultCell(text: (plans[3]!.creditRate!*100).toString()+"%", fontSize: 16, isActive: state == isSerenity)
                          ]
                        ),
                        TableRow(
                          children: [
                            defaultCell(content: Center(child: SvgPicture.asset(plans[0]!.familyDoctorIsFree! ? yes : no, height: 30, color: plans[0]!.familyDoctorIsFree! ? good : bad)), isActive: state == isDecouverte),
                            defaultCell(content: Center(child: SvgPicture.asset(plans[1]!.familyDoctorIsFree! ? yes : no, height: 30, color: plans[1]!.familyDoctorIsFree! ? good : bad)), isActive: state == isAcces),
                            defaultCell(content: Center(child: SvgPicture.asset(plans[1.1]!.familyDoctorIsFree! ? yes : no, height: 30, color: plans[1.1]!.familyDoctorIsFree! ? good : bad)), isActive: state == isAcademik),
                            defaultCell(content: Center(child: SvgPicture.asset(plans[2]!.familyDoctorIsFree! ? yes : no, height: 30, color: plans[2]!.familyDoctorIsFree! ? good : bad)), isActive: state == isAssist),
                            defaultCell(content: Center(child: SvgPicture.asset(plans[3]!.familyDoctorIsFree! ? yes : no, height: 30, color: plans[3]!.familyDoctorIsFree! ? good : bad)), isActive: state == isSerenity)
                          ]
                        ),
                        TableRow(
                          children: [
                            defaultCell(content: Center(child: SvgPicture.asset(plans[0]!.socialNetworkEnable! ? yes : no, height: 30, color: plans[0]!.socialNetworkEnable! ? good : bad)), isActive: state == isDecouverte),
                            defaultCell(content: Center(child: SvgPicture.asset(plans[1]!.socialNetworkEnable! ? yes : no, height: 30, color: plans[1]!.socialNetworkEnable! ? good : bad)), isActive: state == isAcces),
                            defaultCell(content: Center(child: SvgPicture.asset(plans[1.1]!.socialNetworkEnable! ? yes : no, height: 30, color: plans[1.1]!.socialNetworkEnable! ? good : bad)), isActive: state == isAcademik),
                            defaultCell(content: Center(child: SvgPicture.asset(plans[2]!.socialNetworkEnable! ? yes : no, height: 30, color: plans[3]!.socialNetworkEnable! ? good : bad)), isActive: state == isAssist),
                            defaultCell(content: Center(child: SvgPicture.asset(plans[3]!.socialNetworkEnable! ? yes : no, height: 30, color: plans[3]!.socialNetworkEnable! ? good : bad)), isActive: state == isSerenity)
                          ]
                        ),
                        TableRow(
                          children: [
                            defaultCell(content: Center(child: SvgPicture.asset(plans[0]!.canWinPoints! ? yes : no, height: 30, color: plans[0]!.canWinPoints! ? good : bad)), isActive: state == isDecouverte),
                            defaultCell(content: Center(child: SvgPicture.asset(plans[1]!.canWinPoints! ? yes : no, height: 30, color: plans[1]!.canWinPoints! ? good : bad)), isActive: state == isAcces),
                            defaultCell(content: Center(child: SvgPicture.asset(plans[1.1]!.canWinPoints! ? yes : no, height: 30, color: plans[1.1]!.canWinPoints! ? good : bad)), isActive: state == isAcademik),
                            defaultCell(content: Center(child: SvgPicture.asset(plans[2]!.canWinPoints! ? yes : no, height: 30, color: plans[2]!.canWinPoints! ? good : bad)), isActive: state == isAssist),
                            defaultCell(content: Center(child: SvgPicture.asset(plans[3]!.canWinPoints! ? yes : no, height: 30, color: plans[3]!.canWinPoints! ? good : bad)), isActive: state == isSerenity)
                          ]
                        ),
                        TableRow(
                          children: [
                            bottomCell(content: Center(child: SvgPicture.asset(plans[0]!.familyCoverage! ? yes : no, height: 30, color: plans[0]!.familyCoverage! ? good : bad)), isActive: state == isDecouverte),
                            bottomCell(content: Center(child: SvgPicture.asset(plans[1]!.familyCoverage! ? yes : no, height: 30, color: plans[1]!.familyCoverage! ? good : bad)), isActive: state == isAcces),
                            bottomCell(content: Center(child: SvgPicture.asset(plans[1.1]!.familyCoverage! ? yes : no, height: 30, color: plans[1.1]!.familyCoverage! ? good : bad)), isActive: state == isAcademik),
                            bottomCell(content: Center(child: SvgPicture.asset(plans[2]!.familyCoverage! ? yes : no, height: 30, color: plans[2]!.familyCoverage! ? good : bad)), isActive: state == isAssist),
                            bottomCell(content: Center(child: SvgPicture.asset(plans[3]!.familyCoverage! ? yes : no, height: 30, color: plans[3]!.familyCoverage! ? good : bad)), isActive: state == isSerenity)
                          ]
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ) : Center(child: Loaders().buttonLoader(kSouthSeas)),

            Container(
              margin: EdgeInsets.symmetric(horizontal: Device.isSmartphone(context) ? wv*12 : 0, vertical: hv*3),
              child: SizedBox(
                width: Device.isSmartphone(context) ? wv*100 : 1000,
                child: CustomTextButton(
                  text: "Changer de niveau",
                  enable: currentPlan != null && state != null && userProvider.getUserModel?.profileType != beneficiary,
                  action: (){
                    setState(() {});
                    adherentProvider.getAdherent?.adherentPlan == 0 ? showModalBottomSheet(
                      context: context, 
                      builder: (BuildContext bc){
                        return SafeArea(
                          child: Wrap(
                            children: <Widget>[
                              state != isDecouverte ? ListTile(
                                  leading: SvgPicture.asset('assets/icons/Bulk/HeartOutline.svg', height: 30, color: kSouthSeas),
                                  title: const Text('Niveau 0 : Découverte', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600),),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  }) : Container(),
                              state != isAcces ? ListTile(
                                leading: SvgPicture.asset('assets/icons/Bulk/ShieldAcces.svg', height: 30, color: kSouthSeas),
                                title: const Text('Niveau I : Accès', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                                onTap: () {
                                  changePlan(1);
                                },
                              ) : Container(),
                              state != isAcademik ? ListTile(
                                leading: SvgPicture.asset('assets/icons/Bulk/ShieldAcces.svg', height: 30, color: kSouthSeas),
                                title: const Text('Niveau I.I : Academik', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                                onTap: () {
                                  changePlan(1.1);
                                },
                              ) : Container(),
                              state != isAssist ? ListTile(
                                leading: SvgPicture.asset('assets/icons/Bulk/ShieldAssist.svg', height: 30, color: kSouthSeas),
                                title: const Text('Niveau II : Assist', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                                onTap: () {
                                  changePlan(2);
                                },
                              ) : Container(),
                              state != isSerenity ? ListTile(
                                leading: SvgPicture.asset('assets/icons/Bulk/ShieldSerenity.svg', height: 30, color: kSouthSeas),
                                title: const Text('Niveau III : Sérénité', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                                onTap: () {
                                  changePlan(3);
                                },
                              ) : Container(),
                            ],
                          ),
                        );
                      }
                    ) :
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Opération annulée : vous avez déjà un plan en cours",)));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget defaultCell({String? text, Widget? content, String? subtitle, double fontSize = 16, bool isActive = false, bool center = true, Color textColor = kPrimaryColor}){
    return Container(
      height: Device.isSmartphone(context) ? 50 : 60,
      padding: EdgeInsets.symmetric(horizontal: wv*2.5, vertical: 5),
      color: isActive ? kSouthSeas.withOpacity(0.7) : whiteColor,
      child: content ?? Column(
        crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text!, style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis,),
          subtitle != null ? Text(subtitle, style: const TextStyle(color: kPrimaryColor, fontSize: 12, fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis,) : Container(),
        ],
      ),
    );
  }

  Widget headerCell({Widget? content, String? text, String? icon, double fontSize = 20, bool isActive = false}){
    return Container(
      height: 110,
      padding: EdgeInsets.only(top: 15, bottom: 5),
      decoration: BoxDecoration(
        color: isActive ? kSouthSeas.withOpacity(0.7) : Colors.transparent,
        borderRadius: isActive ? BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)) : null
      ),
      child: content ?? Column(
        mainAxisAlignment: isActive ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          SvgPicture.asset(icon!, height: 35, color: isActive ? whiteColor : kSouthSeas,),
          SizedBox(height: isActive ? 15 : 5,),
          Text(text!, style: TextStyle(color: kPrimaryColor, fontSize: fontSize, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }

  Widget bottomCell({Widget? content, double fontSize = 15, bool isActive = false}){
    return Container(
      constraints: BoxConstraints(minHeight: isActive ? 80 : 60),
      padding: EdgeInsets.only(top: 15, bottom: 5),
      decoration: BoxDecoration(
        color: isActive ? kSouthSeas.withOpacity(0.7) : whiteColor,
        borderRadius: isActive ? BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)) : null
      ),
      child: Align(child: content, alignment: Alignment.topCenter,),
    );
  }
}