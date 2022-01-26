import 'package:cached_network_image/cached_network_image.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoctorInfoCard extends StatelessWidget {

  final String? name;
  final String? avatarUrl;
  final String? title;
  final String? speciality;
  final String? distance;
  final bool? isInRdvDetail;
  final String? service;
  final int? appointmentState;
  final bool? chat, consultation, teleConsultation, rdv, visiteDomicile, noShadow;
  final bool? noPadding, includeHospital, isServiceProvider;
  final String? field, officeName, actionText;
  final Function? onTap;

  const DoctorInfoCard({Key? key, this.name, this.title, this.speciality, this.noShadow = false, this.isServiceProvider = false, this.service, this.appointmentState, this.actionText, this.distance, this.isInRdvDetail = false, this.onTap, this.avatarUrl, this.chat, this.consultation, this.teleConsultation, this.rdv, this.visiteDomicile, this.noPadding = false, this.includeHospital = false, this.field, this.officeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: !noPadding! ? EdgeInsets.symmetric(horizontal: wv*5, vertical: 5) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: kSouthSeas,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: noShadow! ? [] : [BoxShadow(
          color: Colors.grey[300]!,
          spreadRadius: 1.5,
          blurRadius: 3,
          offset: Offset(0, 2)
        )]
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: kPrimaryColor,
            ),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*1.5),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 1,
                          blurRadius: 1.5,
                          offset: Offset(0, 2)
                        )]
                      ),
                      child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: avatarUrl == null ? AssetImage("assets/images/avatar-profile.jpg",) : CachedNetworkImageProvider(avatarUrl!) as ImageProvider,
                          radius: 30,
                      ),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isServiceProvider! ? name! : "Dr. $name", style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w600),),
                          Text("$title${includeHospital! ? "" : " ,"+speciality!}", style: TextStyle(color: whiteColor.withOpacity(0.6), fontSize: 14),),
                          includeHospital! ? Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: hv*1.3,),
                              Text(officeName.toString(), style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600, fontSize: 16),),
                              Text(S.of(context).service+"- ${field.toString()}", style: TextStyle(color: whiteColor.withOpacity(0.6), fontSize: 14),),
                            ],
                          ) : Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 5,),

              Container(
                height: 2.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kSouthSeas, kPrimaryColor],
                    begin: Alignment.centerLeft,
                    stops: [0.25, 0.55],
                  ),
                  color: kSouthSeas,
                ),
                child: Divider(color: Colors.transparent,),
              ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(!isInRdvDetail! ? S.of(context).servicesOfferts : S.of(context).serviceDemand, style: TextStyle(color: whiteColor, fontSize: 15),),
                  ),
                  Row(
                    children: [
                      distance != null ? Text("$distance Km", style: TextStyle(color: whiteColor, fontSize: 15),) : Container(),
                      SizedBox(width: 15,),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(
                            color: Colors.black54,
                            spreadRadius: 1,
                            blurRadius: 1.5,
                            offset: Offset(0, 2)
                          )]
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: SvgPicture.asset("assets/icons/Bulk/MapLocal.svg", width: 25,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              !isInRdvDetail! && !isServiceProvider! ? Row(
                children: [
                  SizedBox(width: 10,),
                  SvgPicture.asset("assets/icons/Bulk/Video.svg", width: 20, color: teleConsultation! ? whiteColor : kSouthSeas),
                  SizedBox(width: 10,),
                  SvgPicture.asset("assets/icons/Bulk/Chat.svg", width: 20, color: chat! ? whiteColor : kSouthSeas),
                  SizedBox(width: 10,),
                  SvgPicture.asset("assets/icons/Bulk/Calling.svg", width: 20, color: consultation! ? whiteColor : kSouthSeas),
                  SizedBox(width: 10,),
                  SvgPicture.asset("assets/icons/Bulk/Home.svg", width: 20, color: visiteDomicile! ? whiteColor : kSouthSeas,),
                  SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: SvgPicture.asset("assets/icons/Bulk/Calendar.svg", width: 25, color: rdv! ? whiteColor : kSouthSeas),
                  ),
                  SizedBox(width: 10,),
                  SvgPicture.asset("assets/icons/Bulk/Profile.svg", width: 20, color: visiteDomicile! ? whiteColor : kSouthSeas),
                ],
              ) :
              Row(
                children: [
                  SizedBox(width: wv*2,),
                  SvgPicture.asset("assets/icons/Bulk/Profile.svg", width: 35, color: whiteColor),
                  SizedBox(width: wv*2,),
                  Text(service == null ? S.of(context).consultation : service!, style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 16),)
                ],
              ),
              SizedBox(height: 5,),
            ],),
          ),
          /*Container(
            margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
            child: Text("Yeahhh")
          )*/
          Container(height: 30,
            child: TextButton(
              onPressed: ()=>onTap,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.only(bottom: 4, right: 15))
              ),
              child: isInRdvDetail! ? Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: whiteColor),
                    children: [
                      TextSpan(text: S.of(context).votreDemandeDeRdvEst),
                      TextSpan(text: HomePageComponents().getAppointmentStateText(appointmentState!), style: TextStyle(fontWeight: FontWeight.bold))
                    ]
                  ),
                ),
              ) :
              Row(children: [
                Text(actionText != null ? actionText! : includeHospital! ? S.of(context).autreMdecin : S.of(context).plusDeDtails, style: TextStyle(color: Colors.white),),
                SizedBox(width: 10,),
                Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],mainAxisAlignment: MainAxisAlignment.end)
            ),
          )
        ],
      ),
    )
        ;
  }
}