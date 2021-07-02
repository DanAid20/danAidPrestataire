import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FamilyBadgePage extends StatefulWidget {
  const FamilyBadgePage({ Key key }) : super(key: key);

  @override
  _FamilyBadgePageState createState() => _FamilyBadgePageState();
}

class _FamilyBadgePageState extends State<FamilyBadgePage> {
  @override
  Widget build(BuildContext context) {

    UserProvider userProvider = Provider.of<UserProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    final birthday = userProvider.getUserModel != null ? userProvider.getUserModel.dateCreated.toDate() : DateTime.now();
    final date2 = DateTime.now();
    final yearsForBadget= date2.difference(birthday).inDays;

    return Container(
      color: kDeepTeal,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: wv*4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: hv*15,),
              Text("Badges", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: whiteColor),),
              SizedBox(height: hv*5,),
              Row(
                children: [
                  badgeBox(
                    img: 'assets/icons/Bulk/Shield Done.svg',
                    color: kBrownCanyon,
                    label: "Couvert",
                    description: "Vous Avez Une Couverture Santé Optimale, Accès, Assist ou Sérénité",
                    active: adherentProvider.getAdherent.adherentPlan != 0
                  ),
                  Spacer(),
                  badgeBox(
                    img: 'assets/icons/Bulk/Ticket Star.svg',
                    color: kDeepTeal,
                    label: "Ancienneté",
                    description: "Vous êtes adhérent depuis plus d'un an sans discontinuer",
                    active: yearsForBadget >= 365
                  ),
                ],
              ),
              SizedBox(height: hv*3.5,),
              badgeBox(
                img: 'assets/icons/Bulk/Heart.svg',
                color: primaryColor,
                label: "Contributeur",
                description: "Vous êtes un Contributeur régulier aans le réseau d’entraide DanAid",
                active: false
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget badgeBox({String img, String label, String description, bool active = false, Color color}){
    return Container(
      width: wv*43,
      constraints: BoxConstraints(minHeight: wv*45),
      padding: EdgeInsets.symmetric(horizontal: wv*1.5, vertical: hv*1),
      decoration: BoxDecoration(
        color: active ? whiteColor : whiteColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(7),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 1.5, blurRadius: 3, offset: Offset(0,3))]
      ),
      child: Column(
        children: [
          SvgPicture.asset(img, height: hv*9, color: color,),
          SizedBox(height: hv*1,),
          Text(label, style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold, fontSize: 18),),
          SizedBox(height: hv*1.5,),
          Text(description, style: TextStyle(color: kPrimaryColor, fontSize: 14), textAlign: TextAlign.center,),
          SizedBox(height: hv*1,)
        ],
      ),
    );
  }
}