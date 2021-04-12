import 'package:cached_network_image/cached_network_image.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class UserAvatarAndCoverage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context);
    return Row(
      children: [
        SizedBox(width: 0,),
        Stack(clipBehavior: Clip.none,
          children: [
            userProvider.getProfileType == adherent ?
              CircleAvatar(
                radius: wv*8,
                backgroundColor: Colors.blueGrey[100],
                backgroundImage: ((adherentProvider.getAdherent.imgUrl == "") & (adherentProvider.getAdherent.imgUrl == null))  ? null : CachedNetworkImageProvider(adherentProvider.getAdherent.imgUrl),
                child: (adherentProvider.getAdherent.imgUrl == "") & (adherentProvider.getAdherent.imgUrl == null) ? Icon(LineIcons.user, color: Colors.white, size: wv*13,) : Container(),
              ) :
            userProvider.getProfileType == doctor ?
              CircleAvatar(
              radius: wv*8,
              backgroundColor: Colors.blueGrey[100],
              //backgroundImage: ((doctorProvider.getDoctor.avatarUrl == "") & (doctorProvider.getDoctor.avatarUrl == null))  ? null : CachedNetworkImageProvider(doctorProvider.getDoctor.avatarUrl),
              child: ClipOval(
                child: CachedNetworkImage(
                  height: wv*16,
                  width: wv*16,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    child: Center(child: Icon(LineIcons.user, color: Colors.white, size: wv*25,)), //CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),
                    padding: EdgeInsets.all(20.0),
                  ),
                  imageUrl: doctorProvider.getDoctor.avatarUrl,),
              ),
            ) :
            CircleAvatar(
              radius: wv*8,
              backgroundColor: Colors.blueGrey[100],
              child: Icon(LineIcons.user, color: Colors.white, size: wv*13,),
            ),
            Positioned(child: GestureDetector(
              onTap: ()=> Navigator.pushNamed(context, userProvider.getProfileType == doctor ? '/doctor-profile-edit' : '/adherent-profile-edit'),
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
              Text(userProvider.getProfileType == adherent ? "Bonjour ${adherentProvider.getAdherent.surname} !" : userProvider.getProfileType == doctor ? "Salut Dr. ${doctorProvider.getDoctor.surname} !" : "Bonjour !", style: TextStyle(fontSize: wv*5, color: kPrimaryColor, fontWeight: FontWeight.w400), overflow: TextOverflow.clip,),
              Text(
                userProvider.getProfileType == adherent ? 
                adherentProvider.getAdherent != null ? adherentProvider.getAdherent.adherentPlan == 0 ? "Couverture niveau 0: Découverte" :
                  adherentProvider.getAdherent.adherentPlan == 1 ? "Couverture niveau I: Accès" :
                    adherentProvider.getAdherent.adherentPlan == 2 ? "Couverture niveau II: Assist" :
                      adherentProvider.getAdherent.adherentPlan == 3 ? "Couverture niveau III: Sérénité" : 
                userProvider.getProfileType == doctor ?   
                      "Nous vous attendions.." : "Nous vous attendions..": "Nous vous attendions.." : "Nous vous attendions.."
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