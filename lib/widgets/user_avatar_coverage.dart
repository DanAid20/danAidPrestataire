import 'package:cached_network_image/cached_network_image.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class UserAvatarAndCoverage extends StatelessWidget {
  String defaultUrl = "data:image/jpeg;base64,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";
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context);
    ServiceProviderModelProvider serviceProviderMP = Provider.of<ServiceProviderModelProvider>(context);
    return (adherentProvider.getAdherent != null) || (doctorProvider.getDoctor != null) || (serviceProviderMP.getServiceProvider != null) ? Row(
      children: [
        SizedBox(width: 0,),
        Stack(clipBehavior: Clip.none,
          children: [
            /**  
             * Correct Circle Avatar
             * 
             CircleAvatar(
              radius: wv*8,
              backgroundColor: Colors.blueGrey[100],
              backgroundImage: userProvider.getUserModel.imgUrl ?? CachedNetworkImageProvider(userProvider.getUserModel.imgUrl),
              child: userProvider.getUserModel.imgUrl == null ? Center(child: Icon(LineIcons.user, color: Colors.white, size: wv*25,)) : Container(),
            ),
             */
            userProvider.getProfileType == adherent ?
              CircleAvatar(
                radius: wv*8,
                backgroundColor: Colors.blueGrey[100],
                backgroundImage: adherentProvider.getAdherent.imgUrl != null ? CachedNetworkImageProvider(adherentProvider.getAdherent.imgUrl) : null,
                child: adherentProvider.getAdherent.imgUrl == null ? Center(child: Icon(LineIcons.user, color: Colors.white, size: wv*12,)) : Container(),
                //backgroundImage: ((doctorProvider.getDoctor.avatarUrl == "") & (doctorProvider.getDoctor.avatarUrl == null))  ? null : CachedNetworkImageProvider(doctorProvider.getDoctor.avatarUrl),
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
                    child: Center(child: Icon(LineIcons.user, color: Colors.white, size: wv*12,)), //CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),
                    padding: EdgeInsets.all(20.0),
                  ),
                  imageUrl: doctorProvider.getDoctor.avatarUrl),
              ),
            ) :
            userProvider.getProfileType == serviceProvider ?
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
                    child: Center(child: Icon(LineIcons.user, color: Colors.white, size: wv*12,)), //CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),
                    padding: EdgeInsets.all(20.0),
                  ),
                  imageUrl: serviceProviderMP.getServiceProvider != null ? serviceProviderMP.getServiceProvider.avatarUrl : null),
              ),
            ) :
            CircleAvatar(
              radius: wv*8,
              backgroundColor: Colors.blueGrey[100],
              child: Icon(LineIcons.user, color: Colors.white, size: wv*13,),
            ),
            Positioned(child: GestureDetector(
              onTap: ()=> Navigator.pushNamed(context, userProvider.getProfileType == doctor ? '/doctor-profile-edit' : userProvider.getProfileType == adherent ? '/adherent-profile-edit' : '/serviceprovider-profile-edit'),
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
              Text(userProvider.getProfileType == adherent ? "Bonjour ${adherentProvider.getAdherent.surname} !" : userProvider.getProfileType == doctor ? "Bonjour Dr. ${doctorProvider.getDoctor.surname} !": userProvider.getProfileType == serviceProvider ? "Salut M. ${serviceProviderMP.getServiceProvider.contactName} !" : "Bonjour !", style: TextStyle(fontSize: wv*5, color: kPrimaryColor, fontWeight: FontWeight.w400), overflow: TextOverflow.clip,),
              Text(
                userProvider.getProfileType == adherent ? 
                adherentProvider.getAdherent != null ? adherentProvider.getAdherent.adherentPlan == 0 ? "Couverture niveau 0: D??couverte" :
                  adherentProvider.getAdherent.adherentPlan == 1 ? "Couverture niveau I: Acc??s" :
                    adherentProvider.getAdherent.adherentPlan == 2 ? "Couverture niveau II: Assist" :
                      adherentProvider.getAdherent.adherentPlan == 3 ? "Couverture niveau III: S??r??nit??" : 
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
    ):
    Row(
      children: [
        Loaders().buttonLoader(kPrimaryColor),
        SizedBox(width: wv*3,),
        Text("Bonjour ..", style: TextStyle(fontSize: wv*5, color: kPrimaryColor, fontWeight: FontWeight.w400))
      ],
    )
    
    ;
  }
}