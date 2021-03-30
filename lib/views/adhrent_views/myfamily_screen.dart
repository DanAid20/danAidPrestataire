import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:danaid/widgets/user_avatar_coverage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MyFamilyScreen extends StatefulWidget {
  @override
  _MyFamilyScreenState createState() => _MyFamilyScreenState();
}

class _MyFamilyScreenState extends State<MyFamilyScreen> {
  @override
  Widget build(BuildContext context) {
    AdherentProvider adherentProvider = Provider.of<AdherentProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: hv*10,
        title: UserAvatarAndCoverage(),
        actions: [
          Column(crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Setting.svg', width: wv*10), onPressed: (){}),
              Container(
                child: Row(
                  children: [
                    Text("12 000 Pts", style: TextStyle(fontSize: inch*1.3, fontWeight: FontWeight.w700, color: Colors.teal[400]),),
                    SizedBox(width: wv*2,),
                    ((adherentProvider.getAdherentPlan == 1) | (adherentProvider.getAdherentPlan == 2) | (adherentProvider.getAdherentPlan == 3)) ? SvgPicture.asset("assets/icons/Bulk/Shield Done.svg", width: 18,) : Container(),
                    SvgPicture.asset("assets/icons/Bulk/Ticket Star.svg", width: 18,),
                  ],
                ),
              )
            ],
          )
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: wv*3),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Aperçu de votre couverture"),
                  TextButton(onPressed: (){}, child: Text("Améliorer...", style: TextStyle(color: Colors.brown),)),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Column(
                    children: [
                      RichText(text: TextSpan(
                        text: "Vous bénéficiez d'une ",
                        children: [
                          TextSpan(text: "rémise de 5%"),
                          TextSpan(text: " dans certaines pharmacies & Labos du réseau DanAid")
                        ]
                      , style: TextStyle(color: kPrimaryColor)),
                        
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),

    );
  }
  Widget marginX = SizedBox(width: wv*3,);
}