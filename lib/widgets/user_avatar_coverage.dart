import 'package:cached_network_image/cached_network_image.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class UserAvatarAndCoverage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    return Row(
      children: [
        SizedBox(width: 0,),
        Stack(clipBehavior: Clip.none,
          children: [
            adherentProvider.getAdherent != null ? CircleAvatar(
              radius: wv*8,
              backgroundColor: Colors.blueGrey[100],
              backgroundImage: ((adherentProvider.getAdherent.imgUrl == "") & (adherentProvider.getAdherent.imgUrl == null))  ? null : CachedNetworkImageProvider(adherentProvider.getAdherent.imgUrl),
              child: (adherentProvider.getAdherent.imgUrl == "") & (adherentProvider.getAdherent.imgUrl == null) ? Icon(LineIcons.user, color: Colors.white, size: wv*13,) : Container(),
            ) :
            CircleAvatar(
              radius: wv*8,
              backgroundColor: Colors.blueGrey[100],
              child: Icon(LineIcons.user, color: Colors.white, size: wv*13,),
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
              Text("Bonjour ${adherentProvider.getAdherent.surname}!", style: TextStyle(fontSize: wv*5, color: kPrimaryColor, fontWeight: FontWeight.w400), overflow: TextOverflow.clip,),
              Text(
                adherentProvider.getAdherent.adherentPlan == 0 ? "Couverture niveau 0: Découverte" :
                  adherentProvider.getAdherent.adherentPlan == 1 ? "Couverture niveau I: Accès" :
                    adherentProvider.getAdherent.adherentPlan == 2 ? "Couverture niveau II: Assist" :
                      adherentProvider.getAdherent.adherentPlan == 3 ? "Couverture niveau III: Sérénité" : "Erreur de connexion"
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