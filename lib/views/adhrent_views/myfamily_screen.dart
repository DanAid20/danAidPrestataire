import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/adhrent_views/video_room.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:danaid/widgets/user_avatar_coverage.dart';
import 'package:danaid/widgets/streams.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyFamilyScreen extends StatefulWidget {
  @override
  _MyFamilyScreenState createState() => _MyFamilyScreenState();
}

class _MyFamilyScreenState extends State<MyFamilyScreen> {
  callDanAid() {
    String url = "tel:+237233419203";
    launch(url);
  }

  static const platform = const MethodChannel('danaidproject.sendmoney');
  String receivedString = "";

  Future<void> callNativeFunction() async {
    String amount = "60", data = "", phoneNumber = "650913861";

    //moneyTransferMTNAction, moneyTransferOrangeAction
    try {
      final String temp = await platform.invokeMethod(
          'moneyTransferMTNAction',
          {"amount": amount, "phoneNumber": phoneNumber});
      data = temp;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data),
        duration: Duration(seconds: (50)),
      ));
    } on PlatformException catch (e) {
      data = "Failed";
    }
    setState(() {
      receivedString = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    AdherentModelProvider adherentProvider =
        Provider.of<AdherentModelProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    BottomAppBarControllerProvider controller =
        Provider.of<BottomAppBarControllerProvider>(context);

    final birthday = userProvider.getUserModel != null
        ? userProvider.getUserModel.dateCreated.toDate()
        : DateTime.now();
    final date2 = DateTime.now();
    final yearsForBadget = date2.difference(birthday).inDays;

    return WillPopScope(
      onWillPop: () async {
        controller.toPreviousIndex();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          toolbarHeight: hv * 12,
          title: UserAvatarAndCoverage(),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                    icon: SvgPicture.asset('assets/icons/Bulk/Setting.svg',
                        width: wv * 10),
                    onPressed: callNativeFunction),
                Spacer(),
                Container(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: ()=>Navigator.pushNamed(context, '/family-points-page'),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                          child: Text(userProvider.getUserModel != null ? userProvider.getUserModel.points.toString()+" pts" ?? "0 pts" : "0 pts",
                            style: TextStyle(fontSize: inch*1.3, fontWeight: FontWeight.w700, color: Colors.teal[400]),
                          ),
                        ),
                      ),
                      SizedBox(width: wv*2,),
                      adherentProvider.getAdherent.adherentPlan != 0 ? SvgPicture.asset("assets/icons/Bulk/Shield Done.svg", width: 18,) : Container(),
                     yearsForBadget>=365 ? SvgPicture.asset("assets/icons/Bulk/Ticket Star.svg", width: 18,) : SizedBox.shrink(),
                     SizedBox(width: wv*1),
                    ],
                  ),
                ),
                SizedBox(
                  height: hv * 0.5,
                ),
              ],
            )
          ],
        ),
        body: Container(
          color: Colors.grey[100],
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: wv * 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).aperuDeVotreCouverture),
                    TextButton(onPressed: (){}, child: Text(/*"Améliorer..."*/"", style: TextStyle(color: Colors.brown),)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: wv * 3),
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[300],
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                          offset: Offset(0, 1))
                    ]),
                child: Column(
                  children: [
                    adherentProvider.getAdherent.adherentPlan == 0 ? Container(
                      padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*3),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(text: TextSpan(
                            text: S.of(context).vousBnficiezDune,
                            children: [
                              TextSpan(text: S.of(context).rmiseDe5, style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: S.of(context).dansCertainesPharmaciesLabosDuRseauDanaid)
                            ]
                          , style: TextStyle(color: kBlueDeep, fontSize: wv*3.5)),
                          ),
                          TextButton(onPressed: ()=>Navigator.pushNamed(context, '/compare-plans'),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), shadowColor: MaterialStateProperty.all(Colors.grey[50].withOpacity(0.5))),
                            child: Text(S.of(context).obtenezUneCouvertureComplte70, style: TextStyle(color: kDeepTeal, fontSize: wv*3.5, fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ) : Container(),
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              bottom: wv * 3,
                              right: hv * 4,
                              left: wv * 3,
                              top: wv * 3),
                          decoration: BoxDecoration(
                              color: kSouthSeas.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(15)),
                          child: BeneficiaryStream(standardUse: true),
                        ),
                        Positioned(
                          right: wv * 0,
                          bottom: hv * 8,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/add-beneficiary');
                            },
                            iconSize: 35,
                            icon: CircleAvatar(
                              backgroundColor: kPrimaryColor,
                              child: Center(
                                  child: Icon(
                                Icons.add,
                                size: 35,
                                color: Colors.white,
                              )),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: whiteColor, boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200],
                      spreadRadius: 3.0,
                      blurRadius: 5.0)
                ]),
                margin: EdgeInsets.only(top: hv * 4),
                padding:
                    EdgeInsets.symmetric(horizontal: wv * 3, vertical: hv * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).paramtresDuCompte, style: TextStyle(color: kBlueDeep, fontSize: 18)),
                    SizedBox(height: hv*2,),
                    adherentProvider.getAdherent != null ? HomePageComponents.accountParameters(
                      title: S.of(context).domicilePrincipale, 
                      subtitle: adherentProvider.getAdherent.address != null ? adherentProvider.getAdherent.address : "Non configurée", 
                      svgIcon: "assets/icons/Two-tone/Home.svg", 
                      action: ()=>Navigator.pushNamed(context, '/adherent-profile-edit')
                    ) : Container(),
                    HomePageComponents.accountParameters(
                      title: S.of(context).mesStatistiques, 
                      subtitle: S.of(context).consulter, 
                      svgIcon: "assets/icons/Bulk/Graph.svg", 
                      action: ()=>Navigator.pushNamed(context, '/family-stats-page')
                    ),
                    adherentProvider.getAdherent != null
                        ? HomePageComponents.accountParameters(
                            title: "Domicile Principale",
                            subtitle:
                                adherentProvider.getAdherent.address != null
                                    ? adherentProvider.getAdherent.address
                                    : "Non configurée",
                            svgIcon: "assets/icons/Two-tone/Home.svg",
                            action: () => Navigator.pushNamed(
                                context, '/adherent-profile-edit'))
                        : Container(),
                    HomePageComponents.accountParameters(
                      title: S.of(context).pointsEtBadges, 
                      subtitle: S.of(context).consulterEtUtiliserSesBnfices, 
                      svgIcon: "assets/icons/Bulk/TicketStarLine.svg", 
                      action: ()=>Navigator.pushNamed(context, '/family-points-page')
                    ),
                    HomePageComponents.accountParameters(
                      title: S.of(context).changezDeNiveauDeService, 
                      subtitle: S.of(context).comparerLesNiveauxEtChoisir, 
                      svgIcon: "assets/icons/Bulk/ShieldLine.svg", 
                      action: ()=>Navigator.pushNamed(context, '/compare-plans')
                    ),
                    HomePageComponents.accountParameters(
                      title: S.of(context).changezDeMedecinDeFamille, 
                      subtitle: S.of(context).faitesUneDemande, 
                      svgIcon: "assets/icons/Bulk/Stethoscope.svg", 
                      action: callDanAid
                    ),
                    HomePageComponents.accountParameters(
                      title: S.of(context).documentsDanaid, 
                      subtitle: S.of(context).contratsDocumentsGuides, 
                      svgIcon: "assets/icons/Two-tone/Paper.svg", 
                      action: ()=>Navigator.pushNamed(context, '/family-documents-page')
                    ),

                    SizedBox(height: hv*10,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget marginX = SizedBox(
    width: wv * 3,
  );
}
 