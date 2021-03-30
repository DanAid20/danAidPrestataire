import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class UserAvatarAndCoverage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AdherentProvider adherentProvider = Provider.of<AdherentProvider>(context, listen: false);
    return Row(
      children: [
        SizedBox(width: 0,),
        Stack(clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: wv*8,
              backgroundColor: Colors.blueGrey[100],
              backgroundImage: (adherentProvider.getImgUrl == "" ||adherentProvider.getImgUrl == null)  ? null : NetworkImage(adherentProvider.getImgUrl),
              child: (adherentProvider.getImgUrl == "" ||adherentProvider.getImgUrl == null) ? Icon(LineIcons.user, color: Colors.white, size: wv*13,) : Container(),
            ),
            Positioned(child: GestureDetector(
              onTap: ()=>Navigator.pushNamed(context, '/adherent-profile-edit'),
              child: CircleAvatar(
                radius: wv*3,
                backgroundColor: kDeepTeal,
                child: Icon(Icons.edit, color: whiteColor, size: wv*4,),
              )
            ), bottom: hv*0, right: wv*0,)
          ],
        ),
        SizedBox(width: wv*2,),
        Container(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Bonjour ${adherentProvider.getSurname}!", style: TextStyle(fontSize: wv*5, color: kPrimaryColor, fontWeight: FontWeight.w400), overflow: TextOverflow.clip,),
              Text(
                adherentProvider.getAdherentPlan == 0 ? "Couverture niveau 0: Découverte" :
                  adherentProvider.getAdherentPlan == 1 ? "Couverture niveau I: Accès" :
                    adherentProvider.getAdherentPlan == 2 ? "Couverture niveau II: Assist" :
                      adherentProvider.getAdherentPlan == 3 ? "Couverture niveau III: Sérénité" : "Couverture niveau 0: Découverte"
                , style: TextStyle(fontSize: wv*2.8, color: kPrimaryColor)),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        ),
        SizedBox(width: 10,)
      ],
    );
  }
}