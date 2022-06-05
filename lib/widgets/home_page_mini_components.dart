import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/services/getPlatform.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/SizeConfig.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import '../helpers/constants.dart';
import '../helpers/styles.dart';
import '../widgets/readMoreText.dart';

class HomePageComponents {

  Widget prestataireItemList({
    String? nom, 
    String? date,
    String? montant, 
    int? etat,
    String? iconesConsultationTypes,
    Function? redirectOncliked,
  }){
    print(etat.runtimeType);
    return GestureDetector(
      onTap: (){
        redirectOncliked!();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            margin: EdgeInsets.only( top: hv*2) ,
          child: Row(
                                  children: [
                                    Column(
                                      children: [
                                       Container(
                                           padding: EdgeInsets.all(5) ,
                                          decoration: BoxDecoration(color: kDeepTeal, boxShadow: [ BoxShadow(color: kShadowColor.withOpacity(0.2), spreadRadius: 0.9, blurRadius: 6),],borderRadius: BorderRadius.all(Radius.circular(10))),
                                         child: SvgPicture.asset(
                                                iconesConsultationTypes!,
                                                height: 28.h,
                                                color: kSouthSeas,
                                                width: wv * 12, 
                                          ),
                                       ),
                                      ],
                                    ),
                                    SizedBox(
                                  width: wv * 2.3,
                                ),
                                    Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(nom!, overflow: TextOverflow.clip,  style: TextStyle(
                                                color: kBlueForce,
                                                fontWeight: FontWeight.w600,
                                                fontSize: wv*3.5), textScaleFactor: 1.0),
                                            ),
                                                SizedBox(
                                  width: hv * 2.3,
                                ),
                                            Text(date!,  style: TextStyle(
                                              color: kBlueForce,
                                              fontWeight: FontWeight.w500,
                                              fontSize: wv*3.5), textScaleFactor: 1.0),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Column(
                                           crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(montant!, style: TextStyle(
                                              color: kBlueForce,
                                              fontWeight: FontWeight.w500,
                                              fontSize: wv*3.5), textScaleFactor: 1.0),
                                            Text(etat==0? S.current.enAttente: etat==1? 'Payer': etat==2?"Livré" : 'inconue'  , style: TextStyle(
                                              color:  getCOlor(etat) ,
                                              fontWeight: FontWeight.w400,
                                              fontSize: wv*3.5), textScaleFactor: 1.0),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
        ),
      ),
    );
  }
  

  Widget paienementDetailsListItem({
    BuildContext? context,
    String? nom, 
    String? date,
    String? montant, 
    int? etat,
    String? iconesConsultationTypes
  }){
    print(etat.runtimeType);
    return Container(
        margin: EdgeInsets.only( top: hv*2) ,
      child: Row(
                              children: [
                                Column(
                                  children: [
                                   Container(
                                       padding: EdgeInsets.all(5) ,
                                      decoration: BoxDecoration(color: kDeepTeal, boxShadow: [ BoxShadow(color: kShadowColor.withOpacity(0.2), spreadRadius: 0.9, blurRadius: 6),],borderRadius: BorderRadius.all(Radius.circular(10))),
                                     child: SvgPicture.asset(
                                            iconesConsultationTypes!,
                                            height: 28.h,
                                            color: kSouthSeas,
                                            width: wv * 12, 
                                      ),
                                   ),
                                  ],
                                ),
                                SizedBox(
                              width: wv * 2.3,
                            ),
                                Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(nom!, overflow: TextOverflow.clip,  style: TextStyle(
                                            color: kBlueForce,
                                            fontWeight: FontWeight.w600,
                                            fontSize: Device.isSmartphone(context!) ? wv*3.5 : 15 ), textScaleFactor: 1.0),
                                        ),
                                            SizedBox(
                              width: hv * 2.3,
                            ),
                                        Text(date!,  style: TextStyle(
                                          color: kBlueForce,
                                          fontWeight: FontWeight.w500,
                                          fontSize: Device.isSmartphone(context) ? wv*3.5 : 15), textScaleFactor: 1.0),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Column(
                                       crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(montant!, style: TextStyle(
                                          color: kBlueForce,
                                          fontWeight: FontWeight.w500,
                                          fontSize: Device.isSmartphone(context) ? wv*3.5 : 15), textScaleFactor: 1.0),
                                        Text(etat==0? S.current.enAttente: etat==1? S.current.valider: etat==2?S.current.rejett : ''  , style: TextStyle(
                                          color:  getCOlor(etat) ,
                                          fontWeight: FontWeight.w400,
                                          fontSize: Device.isSmartphone(context) ? wv*3.5 : 15), textScaleFactor: 1.0),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
    );
  }

  Color getCOlor(etat){
    Color? couleurs; 
    if(etat==0) couleurs=Colors.yellow;
    else if( etat==1)  couleurs=Colors.teal;
    else if(etat==2)  couleurs=kMaron;
    return couleurs!;
  }
  Widget paiementItem({
    BuildContext? context,
    String? month, 
    String? prix,
    String? lastDatePaiement,
    bool? paidOrNot,
    String? paidAllReady,
  }){
    return Container(
        margin: EdgeInsets.all( wv * 3),
                 decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: kShadowColor.withOpacity(0.2), spreadRadius: 0.9, blurRadius: 6),
                ],
                borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
      child: Padding(
                   padding: const EdgeInsets.all(12.0),
                   child: Column(
                    mainAxisSize: MainAxisSize.min,
                     children: [
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                          Column(
                             mainAxisSize: MainAxisSize.min,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                                   Container(alignment: Alignment.centerLeft, child: Text(month!, style: TextStyle(
                                      color: kDeepTeal,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize: Device.isSmartphone(context!) ? wv*3.5: 15), textScaleFactor: 1.0,)),
                                   SizedBox( height: hv * 1.3,),
                                   Container(alignment: Alignment.centerLeft, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(S.current.montant, style: TextStyle(
                                      color: kBlueForce,
                                      fontWeight: FontWeight.w500,
                                      
                                      fontSize:  Device.isSmartphone(context) ? wv*3.5: 15), textScaleFactor: 1.0),Text('$prix f', style: TextStyle(
                                      color: kBlueForce,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize:  Device.isSmartphone(context) ? wv*3.5: 15), textScaleFactor: 1.0,),],)),
                             ],
                           ),
                          SizedBox(
                            width: wv * 20.3,
                          ),
                          Column(
                             mainAxisSize: MainAxisSize.min,
                             crossAxisAlignment: CrossAxisAlignment.end,
                             children: [
                                   Container(alignment: Alignment.centerRight, child: Text(paidOrNot==false ? 'En attente ($paidAllReady)' : 'payé', style: TextStyle(
                                      color: kArgent,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize:  Device.isSmartphone(context) ? wv*3.5: 15), textScaleFactor: 1.0,)),
                                   SizedBox( height: hv * 1.3,),
                                   Container(alignment: Alignment.centerRight, child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Text('Delai de paiement ',style: TextStyle(
                                      color: kBlueForce,
                                      fontWeight: FontWeight.w500,
                                      fontSize:  Device.isSmartphone(context) ? wv*3.5: 15), textScaleFactor: 1.0, ),Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(lastDatePaiement!, style: TextStyle(
                                        color: kBlueForce,
                                        fontWeight: FontWeight.w600,
                                        fontSize:  Device.isSmartphone(context) ? wv*3.5: 15), textScaleFactor: 1.0),
                                      ),],)),
                             ],
                           ),
                          Column(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                                  
                                 Container(child: Column(children: [SvgPicture.asset(
                                        'assets/icons/Bulk/Wallet.svg',
                                        height: hv * 3,
                                        color: kSouthSeas,
                                        width: wv * 10, 
                                  ),
                                  Text(S.current.auditer, style: TextStyle(
                                      color: kSouthSeas,
                                      fontWeight: FontWeight.w600,
                                      
                                      fontSize:  Device.isSmartphone(context) ? wv*3.5: 15), textScaleFactor: 1.0),],)),
                             ],
                           ),
                         ],
                       ),
                     ],
                   ),
                 ),
    );
  }
 
   Widget paiementPrestaireItem({
    String? month, 
    String? prix,
    String? lastDatePaiement,
    int? paidOrNot,
    String? paidAllReady,
    Function? redirectOncliked,
  }){
    return 
    Container(
        margin: EdgeInsets.all( wv * 3),
                 decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: kShadowColor.withOpacity(0.2), spreadRadius: 0.9, blurRadius: 6),
                ],
                borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
      child: Padding(
                   padding: const EdgeInsets.all(12.0),
                   child: Column(
                    mainAxisSize: MainAxisSize.min,
                     children: [
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                          Column(
                             mainAxisSize: MainAxisSize.min,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                                   Container(alignment: Alignment.centerLeft, child: Text(month!, style: TextStyle(
                                      color: kDeepTeal,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,)),
                                   SizedBox( height: hv * 1.3,),
                                   Container(alignment: Alignment.centerLeft, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(S.current.montant, style: TextStyle(
                                      color: kBlueForce,
                                      fontWeight: FontWeight.w500,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0),Text('$prix f', style: TextStyle(
                                      color: kBlueForce,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,),],)),
                             ],
                           ),
                         
                          Column(
                             mainAxisSize: MainAxisSize.min,
                             crossAxisAlignment: CrossAxisAlignment.end,
                             children: [
                                   Container(alignment: Alignment.centerRight, child: Text(paidOrNot==0 ? 'En attente ' : paidOrNot==1? 'Payé': paidOrNot==2 ? "Livré":" ", style: TextStyle(
                                      color:paidOrNot ==1 ? kDeepTealCAdress:  paidOrNot==2? kDeepTealClair: kArgent,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,)),
                                   SizedBox( height: hv * 1.3,),
                                   Container(alignment: Alignment.centerRight, child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Text('Copaiement Restant',style: TextStyle(
                                      color: kBlueForce,
                                      fontWeight: FontWeight.w500,
                                      fontSize: wv*3.5), textScaleFactor: 1.0, ),Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(lastDatePaiement!, style: TextStyle(
                                        color: kBlueForce,
                                        fontWeight: FontWeight.w600,
                                        fontSize: wv*3.5), textScaleFactor: 1.0),
                                      ),],)),
                             ],
                           ),
                          GestureDetector(
                             onTap: ()=>{
                                redirectOncliked!(),
                            },
                            child: Column(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                    
                                   Container(child: Column(children: [SvgPicture.asset(
                                          'assets/icons/Bulk/Wallet.svg',
                                          height: hv * 3,
                                          color: kSouthSeas,
                                          width: wv * 10, 
                                    ),
                                    Text("Livrer", style: TextStyle(
                                        color: kSouthSeas,
                                        fontWeight: FontWeight.w600,
                                        
                                        fontSize: wv*3.5), textScaleFactor: 1.0),],)),
                               ],
                             ),
                          ),

                         ],
                       ),
                     ],
                   ),
                 ),
    );
  }
 
  Widget patientsItem(
      {String? imgUrl,
      String? nom,
      String? subtitle,
      String? apointementDate,
      int? etat,
      bool isSpontane = false}) {
    return ListTile(
      leading: HomePageComponents().getAvatar(
          imgUrl: imgUrl!,
          size: wv * 8,
          renoveIsConnectedButton: false),
      title: Text(
        nom != null ? nom : '',
        style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: kPrimaryColor),
      ),
      subtitle: Text(
         subtitle!,
        overflow: TextOverflow.ellipsis,
         maxLines: 2,
         softWrap: false,
        style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: kPrimaryColor),
      ),
      trailing: isSpontane == true
          ? Text(
              '',
              style:
                  TextStyle(fontSize: 14.sp, color: kDeepTeal),
            )
          : Container(
              padding: EdgeInsets.only(top: hv * 1, right: wv * 2),
              child: Column(
                children: [
                  Text(
                    apointementDate != null ? apointementDate : '',
                    style: TextStyle(
                        fontSize:  14.sp, color: kPrimaryColor),
                  ),
                  Text(
                    etat==0? S.current.enAttente: etat==1? S.current.valider: etat==2?S.current.rejett : '' ,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color:  etat == 0 ?  Colors.red : etat==1 ? Colors.green: etat == 2 ? kblueSky : Colors.amber),
                  ),
                ],
              ),
            ),
    );
  }
  Widget timeline({
    String? time,
    String? userImage,
    String? userName,
    String? consultationDetails,
    String? age,
    String? consultationType,
    String? videChatLink,
    String? detailsCOnsultationLink,
    bool? isPrestataire,
    String? consultationtype,
    Function? approuveAppointement,String? adhrentId, String? doctorId,
    bool isanounced=false
  }) {
    return Container(
      decoration: BoxDecoration(
       
      ),
      width: wv * 100,
      padding: EdgeInsets.only(left: wv * 3, right: wv * 3.3),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: wv * .5),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: wv * 1.5),
                  child: Text(time!,
                      style: TextStyle(
                          color: kTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: fontSize(size: wv * 5))),
                ),
                SvgPicture.asset(
                  'assets/icons/Bulk/Line.svg',
                  height: hv * 3,
                  color: kPrimaryColor,
                  width: wv * 5,
                ),
              ],
            ),
          ),
          Container(
            width: wv * 70,
            height: MySize.getScaledSizeHeight(90),
            margin: EdgeInsets.only(bottom: wv * 2),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
              ],
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: wv * 20,
                      height: hv * 12,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image:  NetworkImage(userImage!),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kThirdColor,
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          )),
                    ),
                    Positioned(
                        bottom: hv * 0.5,
                        right: wv * 1,
                        child: SvgPicture.asset(
                         'assets/icons/Bulk/Shield Done.svg',
                          width: wv * 4,
                          
                        )),
                   isanounced!=null && isanounced!=true? SizedBox.shrink() : Positioned(
                        top: hv * 0.5,
                        left: wv * 1,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kDeepTealCAdress, spreadRadius: 0.5, blurRadius: 4
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),child: Text(''),)
                    )
                  ],
                ),
                Container(
                  width: wv * 38.5,
                  margin: EdgeInsets.only(left: wv * 1.5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: hv * 1.5,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(userName!,
                                  overflow: TextOverflow.ellipsis,
                                  style:  TextStyle(
                                      color: kDateTextColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(age!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: kCardTextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.sp)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: hv * 0.7,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: wv * 6),
                            child: Text(consultationDetails!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: kCardTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: MySize.getScaledSizeHeight(15))),
                          ),
                          SizedBox(
                            height: MySize.getScaledSizeHeight(5),
                          ),
                          Text(consultationType!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: kDeepTeal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: MySize.getScaledSizeHeight(16))),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // lien la page de l'appel video
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        width: MySize.getScaledSizeWidth(38.5), 
                        height: MySize.getScaledSizeHeight(40),
                        decoration: BoxDecoration(
                            color: isPrestataire! ? kGoldForIconesBg:kSouthSeas,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )),
                        child: SvgPicture.asset(
                        consultationtype=="vidéos"? 'assets/icons/Bulk/Video.svg': consultationtype=="Cabinet"? "assets/icons/Bulk/Profile.svg" : "assets/icons/Bulk/Home.svg",
                          width: wv * 7,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        approuveAppointement!(adhrentId, doctorId);
                      },
                      child: Container(
                        padding: EdgeInsets.all(3),
                        height: hv * 5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/Bulk/ArrowRight Circle.svg',
                          width: wv * 7,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget timelineForDeskstop(
   { BuildContext? context, int? iSelected, String? doctorName, BeneficiaryModel? adherent, bool? isAccountIsExists, int? index, Function? onclick}
  ) {
    return GestureDetector(
      onTap: ()=>{
         
           if(iSelected==index){
            onclick!(index, adherent, 'remove')
         }else{
           print(index),
           print(index),
            onclick!(index, adherent, 'add')
         }
      },
      child: Container(
        width: Device.isSmartphone(context!) ? 0  : double.infinity,
        height: MySize.getScaledSizeHeight(140),
        child: Column(
          children: [
            Container(
              width: Device.isSmartphone(context) ? 0  : double.infinity,
              height: MySize.getScaledSizeHeight(130),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
                ],
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: wv * 14,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                               colorFilter: isAccountIsExists == true &&
                               adherent!=null && adherent.enabled == true
                            ? ColorFilter.mode(
                                Colors.red.withOpacity(1), BlendMode.dstATop)
                            :  ColorFilter.mode(
                                Colors.red.withOpacity(0.5), BlendMode.dstATop),
                            image: adherent==null
                                ? AssetImage("assets/images/image 25.png")
                                : adherent.avatarUrl==null ? AssetImage("assets/images/avatar-profile.jpg"):  CachedNetworkImageProvider("${adherent.avatarUrl}") as ImageProvider,
                            fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: kThirdColor,
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            )),
                      ),
                      adherent!=null && adherent.protectionLevel==0 ?
                      Positioned(
                          bottom: hv * 0.5,
                          right: wv * 1,
                          child: SvgPicture.asset(
                         'assets/icons/Bulk/Shield Done.svg',
                            width: wv * 4,
                            
                          )):Container(),
                    ],
                  ),
                  Container(
                    width: Device.isSmartphone(context)? wv * 38.5: 200 ,
                    margin: EdgeInsets.only(left: wv * 1.5),
                    child: Column(
                      children: [
                        SizedBox(
                          height: hv * 1.5,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text('',
                                    overflow: TextOverflow.ellipsis,
                                    style:  TextStyle(
                                        color: kDateTextColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize:Device.isSmartphone(context)? 14.sp : 14)),
                              ),
                              Expanded( 
                                flex: 1,
                                child: Text(adherent!=null && adherent.validityEndDate!=null ? DateFormat('M/yyyy').format(adherent.validityEndDate!.toDate()) : S.current.pasDefini ,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: kCardTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: Device.isSmartphone(context)? 15.sp : 15)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: hv * 0.7,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: wv * 6),
                              child: Text( (adherent!=null && adherent.cniName !=null)
                          ?   adherent.cniName!
                          : S.current.pasDefini,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: kCardTextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MySize.getScaledSizeHeight(15))),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: wv * 6),
                              child: Text( (adherent!=null &&  adherent.matricule!=null)
                          ?  adherent.matricule!
                          : S.current.pasDefini,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: kCardTextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MySize.getScaledSizeHeight(15))),
                            ),
                            SizedBox(
                              height: MySize.getScaledSizeHeight(5),
                            ),
                            Text( doctorName!=null ? 'Dr '+doctorName :  S.current.pasDefinie,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: kDeepTeal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: MySize.getScaledSizeHeight(16))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // lien la page de l'appel video
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          width: MySize.getScaledSizeWidth(20), 
                          height: MySize.getScaledSizeHeight(40),
                          decoration: const BoxDecoration(
                              color: kSouthSeas,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                          child: SvgPicture.asset(
                            (adherent!=null && adherent.gender=='H')?'assets/icons/Bulk/Male.svg': (adherent!=null && adherent.gender=='F') ? 'assets/icons/Bulk/Female.svg': '', 
                            width: wv * 7,
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     approuveAppointement!(adhrentId, doctorId);
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.all(3),
                      //     height: hv * 5,
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //     ),
                      //     child: SvgPicture.asset(
                      //       'assets/icons/Bulk/ArrowRight Circle.svg',
                      //       width: wv * 7,
                      //     ),
                      //   ),
                      // )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget waitingRoomListOfUser({
    String? userImage,
    String? nom,
    String? syntomes,
    bool isanounced=false
  }) {
    return Container(
      width: wv * 50,
      height: hv * 8,
      margin: EdgeInsets.only(
        left: wv * 1.5,
        right: wv * 1.5,
        top: hv * 2,
        bottom: hv * 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
             child: Stack(
               children: [
                Container(
                width: wv * 15,
                height: double.infinity,
                decoration: BoxDecoration(
                    image: userImage !=null ? DecorationImage(
                      image: NetworkImage(userImage),
                      fit: BoxFit.cover,
                    ) :
                    DecorationImage(
                      image: AssetImage("assets/images/avatar-profile.jpg"),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: kThirdColor,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )),
            ),
            isanounced!=null && isanounced!=true? SizedBox.shrink() : Positioned(
                        top: hv * 0.5,
                        left: wv * 1,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kDeepTealCAdress, spreadRadius: 0.5, blurRadius: 4
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),child: Text(''),)
                    )
            ]
             ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 3.h),
                  child: Text( nom!=null ? nom :'',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: kDateTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: fontSize(size: wv * 3.5))),
                ),
              SizedBox(
                height: hv * .5,
              ),
              Flexible(fit: FlexFit.tight , 
                              child: Container(
                  padding: EdgeInsets.only(
                    left: wv * 1,
                  ),
                  child: Container(
                    width: wv * 30,
                    child: Text(
                        syntomes !=null ? syntomes : '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: kDateTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: fontSize(size: wv * 3.5))),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  getAdherentsListForPrestataire({ String? doctorName, BeneficiaryModel? adherent, bool? isAccountIsExists}) {
    return Container(
      width: wv * 78,
      height: hv*55,
      decoration: BoxDecoration(
        color: kBlueForce,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
         boxShadow: [
                BoxShadow(color:  kBlueForce, spreadRadius: 2, blurRadius: 4),
              ],
      ),
      margin: EdgeInsets.only(left: wv * 2, right:2.5.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: wv * 3, right: wv * 2, top: hv * 1),
            child: Row(
              children: [
                Container(
                    width: wv * 15,
                    child: Text(S.current.valideJusquau,
                        style: TextStyle(
                            color: textWhiteColor,
                            fontSize: fontSize(size: 15),
                            fontWeight: FontWeight.w500))),
                Container(
                    width: wv * 20,
                    child: Text(adherent!=null && adherent.validityEndDate!=null ? DateFormat('M/yyyy').format(adherent.validityEndDate!.toDate()) : S.current.pasDefini ,
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: wv * 4.5,
                            fontWeight: FontWeight.w700))),
                Spacer(),
                SvgPicture.asset(
               (adherent!=null && adherent.gender=='H')?'assets/icons/Bulk/Male.svg': (adherent!=null && adherent.gender=='F') ? 'assets/icons/Bulk/Female.svg': '', 
                  color: whiteColor,
                ),
                SvgPicture.asset(
                adherent!=null && adherent.protectionLevel==0 ? '': 'assets/icons/Bulk/Shield Done.svg',
                  height: hv * 5,
                  width: wv * 5,
                )
              ],
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter: 
                             adherent!=null && adherent.enabled == true
                          ? new ColorFilter.mode(
                              Colors.red.withOpacity(1), BlendMode.dstATop)
                          : new ColorFilter.mode(
                              Colors.red.withOpacity(0.5), BlendMode.dstATop),
                      image: adherent==null
                          ? AssetImage("assets/images/image 25.png")
                          : adherent.avatarUrl==null ? AssetImage("assets/images/avatar-profile.jpg"):  CachedNetworkImageProvider("${adherent.avatarUrl}") as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    color: Colors.red,
                    shape: BoxShape.circle),
                width: wv * 40,
                height: hv * 20,
                child: Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      angle: -math.pi / 4,
                      child: Text(
                         adherent!=null && adherent.enabled == true
                            ? ''
                            : S.current.compteInactif,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: Colors.red,
                            letterSpacing: 0.5,
                            fontSize: wv * 6.5,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  
                ]),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: wv * 10, right: wv * 2, top: hv * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(S.current.nonDuBeneficiaire,
                    style: TextStyle(
                        color: textWhiteColor,
                        fontSize: fontSize(size: 15),
                        fontWeight: FontWeight.w500)),
                Text((adherent!=null && adherent.cniName!=null) ? adherent.cniName! : ''  ,
                    style: TextStyle(
                        color: textWhiteColor,
                        fontSize: fontSize(size: 15),
                        fontWeight: FontWeight.w700))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: wv * 10, right: wv * 2, top: hv * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(S.current.numeroMatricule,
                    style: TextStyle(
                        color: textWhiteColor,
                        fontSize: fontSize(size: 15),
                        fontWeight: FontWeight.w500)),
                Text(
                  (adherent!=null &&  adherent.matricule!=null)
                        ?  adherent.matricule!
                        : S.current.pasDefini,
                    style: TextStyle(
                        color: textWhiteColor,
                        fontSize: fontSize(size: 15),
                        fontWeight: FontWeight.w700))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: wv * 10, right: wv * 2, top: hv * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(S.current.medecinDeFamille,
                    style: TextStyle(
                        color: textWhiteColor,
                        fontSize: fontSize(size: 15),
                        fontWeight: FontWeight.w500)),
                Text(
                     doctorName!=null ? 'Dr '+doctorName :  S.current.pasDefinie,
                    style: TextStyle(
                        color: textWhiteColor,
                        fontSize: fontSize(size: 15),
                        fontWeight: FontWeight.w700))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: hv * 4),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/icons/DanaidLogo.png'),
            ),
          ),

        ],
      ),
    );
  }

  getAdherentsList({ BuildContext? context, int? iSelected, String? doctorName, BeneficiaryModel? adherent, bool? isAccountIsExists, int? index, Function? onclick}) {
    return GestureDetector(
      onTap: ()=>{
         
           if(iSelected==index){
            onclick!(index, adherent, 'remove')
         }else{
           print(index),
           print(index),
            onclick!(index, adherent, 'add')
         }
      },
      child: Container(
        width: wv * 78 ,
        decoration: BoxDecoration(
          color: kBlueForce,
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
           boxShadow: [
                  BoxShadow(color: iSelected==index? kBlueForce: Colors.transparent, spreadRadius: 2, blurRadius: 4),
                ],
        ),
        margin: EdgeInsets.only(left: wv * 2, right:2.5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: wv * 3, right: wv * 2, top: hv * 1),
              child: Row(
                children: [
                  Container(
                      width: wv * 15 ,
                      child: Text(S.current.valideJusquau,
                          style: TextStyle(
                              color: textWhiteColor,
                              fontSize: fontSize(size:  15  ),
                              fontWeight: FontWeight.w500))),
                  Container(
                      width: wv * 20,
                      child: Text(adherent!=null && adherent.validityEndDate!=null ? DateFormat('M/yyyy').format(adherent.validityEndDate!.toDate()) : S.current.pasDefini ,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: wv * 4.5  ,
                              fontWeight: FontWeight.w700))),
                  Spacer(),
                  SvgPicture.asset(
                 (adherent!=null && adherent.gender=='H')?'assets/icons/Bulk/Male.svg': (adherent!=null && adherent.gender=='F') ? 'assets/icons/Bulk/Female.svg': '', 
                    color: whiteColor,
                  ),
                  SvgPicture.asset(
                  adherent!=null && adherent.protectionLevel==0 ? '': 'assets/icons/Bulk/Shield Done.svg',
                    height: hv * 5,
                    width: wv * 5,
                  )
                ],
              ),
            ),
            Container(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: isAccountIsExists == true &&
                               adherent!=null && adherent.enabled == true
                            ? ColorFilter.mode(
                                Colors.red.withOpacity(1), BlendMode.dstATop)
                            :  ColorFilter.mode(
                                Colors.red.withOpacity(0.5), BlendMode.dstATop),
                        image: adherent==null
                            ? AssetImage("assets/images/image 25.png")
                            : adherent.avatarUrl==null ? AssetImage("assets/images/avatar-profile.jpg"):  CachedNetworkImageProvider("${adherent.avatarUrl}") as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                      color: Colors.red,
                      shape: BoxShape.circle),
                  width: wv * 40,
                  height: hv * 20 ,
                  child: Stack(children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: Text(
                          isAccountIsExists == true && (adherent!=null && adherent.enabled!) == true
                              ? ''
                              : S.current.compteInactif,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: Colors.red,
                              letterSpacing: 0.5,
                              fontSize: wv * 6.5 ,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Positioned(
                      right:  5 ,
                      bottom:  -hv * 2 ,
                      child: Container(
                        height:  hv * 10 ,
                        width:  wv * 10,
                        decoration: BoxDecoration(
                            color: isAccountIsExists == true &&
                                    (adherent!=null && adherent.enabled!) == true
                                ? Colors.green
                                : Colors.red,
                            shape: BoxShape.circle),
                        child:
                            isAccountIsExists == true && (adherent!=null && adherent.enabled!) == true
                                ? const SizedBox.shrink()
                                : Icon(
                                    Icons.priority_high,
                                    color: Colors.white,
                                    size: hv * 4,
                                  ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: wv * 10, right: wv * 2, top: hv * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(S.current.nonDuBeneficiaire,
                      style: TextStyle(
                          color: textWhiteColor,
                          fontSize: fontSize(size: 15),
                          fontWeight: FontWeight.w500)),
                  Text((adherent!=null && adherent.cniName !=null) ? adherent.cniName! : ''  ,
                      style: TextStyle(
                          color: textWhiteColor,
                          fontSize: fontSize(size: 15),
                          fontWeight: FontWeight.w700))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: wv * 10, right: wv * 2, top: hv * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(S.current.numeroMatricule,
                      style: TextStyle(
                          color: textWhiteColor,
                          fontSize:  fontSize(size: 15),
                          fontWeight: FontWeight.w500)),
                  Text(
                    (adherent!=null &&  adherent.matricule!=null)
                          ?  adherent.matricule!
                          : S.current.pasDefini,
                      style: TextStyle(
                          color: textWhiteColor,
                          fontSize:  fontSize(size: 15),
                          fontWeight: FontWeight.w700))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: wv * 10, right: wv * 2, top: hv * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(S.current.medecinDeFamille,
                      style: TextStyle(
                          color: textWhiteColor,
                          fontSize:  fontSize(size: 15),
                          fontWeight: FontWeight.w500)),
                  Text(
                       doctorName!=null ? 'Dr '+doctorName :  S.current.pasDefinie,
                      style: TextStyle(
                          color: textWhiteColor,
                          fontSize:  fontSize(size: 15),
                          fontWeight: FontWeight.w700))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: hv * 4),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/icons/DanaidLogo.png'),
              ),
            ),

          ],
        ),
      ),
    );
  }

  getDoctorQuestion(
      {String? imgUrl,
      String? userName,
      String? timeAgo,
      String? text,
      int? likeCount,
      int? commentCount,
      int? sendcountNumber}) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: inch * 1, right: inch * 1, top: inch * 1),
            child: Column(
              children: [
                Row(
                  children: [
                    getAvatar(
                        imgUrl: imgUrl!,
                        size: wv * 8.3,
                        renoveIsConnectedButton: false),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '$userName',
                              style: TextStyle(
                                color: kDeepTeal,
                                fontSize: fontSize(size: 17),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(S.current.aPosUne,
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: fontSize(size: 17))),
                            SizedBox(
                              width: wv * 1,
                            ),
                            Text(S.current.question,
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: fontSize(size: 16))),
                          ],
                        ),
                        SizedBox(
                          height: hv * 0.3,
                        ),
                        Text(
                          '$timeAgo',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize(size: 16)),
                        )
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ReadMoreText(
                    text != null
                        ? text
                        : S.current.doctaQueReccomendezVousEnCasDeFivreDePlus,
                    trimLines: 2,
                    trimLength: 73,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, color: bkgColor),
                    colorClickableText: kDeepTeal,
                    trimMode: TrimMode.Length,
                    trimCollapsedText: S.current.voirPlus,
                    trimExpandedText: S.current.reduire,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: inch * 0.6, right: inch * 1.5, top: inch * 0),
                  child: Row(children: [
                    Container(
                      margin: EdgeInsets.only(right: wv * 1),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Bulk/Heart.svg',
                            width: wv * 7,
                          ),
                          SizedBox(
                            width: wv * 1,
                          ),
                          Text(
                              likeCount != null
                                  ? '${likeCount.toString()}'
                                  : "123",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    SizedBox(width: wv * 7),
                    Container(
                      margin: EdgeInsets.only(right: wv * 1),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Bulk/Chat.svg',
                            width: wv * 7,
                          ),
                          SizedBox(
                            width: wv * 1.5,
                          ),
                          Text(
                              commentCount != null
                                  ? '${commentCount.toString()}'
                                  : "123",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    SizedBox(width: wv * 5),
                    Container(
                      margin: EdgeInsets.only(right: wv * 1),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Bulk/Send.svg',
                            width: wv * 7,
                          ),
                          SizedBox(
                            width: wv * 1.5,
                          ),
                          Text(
                              sendcountNumber != null
                                  ? '${sendcountNumber.toString()}'
                                  : "123",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getAvatar({String? imgUrl, double? size, bool renoveIsConnectedButton = true}) {
      var stringToComparedev="https://firebasestorage.googleapis.com/v0/b/danaid-dev";
      var stringToCompareprod="https://firebasestorage.googleapis.com/v0/b/danaidapp.appspot.com";

    return Padding(
      padding: EdgeInsets.only(right: wv * 1),
      child: Stack(
        children: [
         imgUrl!=null &&  imgUrl.contains(stringToComparedev) || imgUrl!=null && imgUrl.contains(stringToCompareprod)  ? CircleAvatar(
                radius:  size != null ? size : wv * 5.5,
                backgroundImage: NetworkImage(imgUrl),
                backgroundColor: Colors.transparent,
          ):
          CircleAvatar(
            radius: size != null ? size : wv * 5.5,
            child:Image.asset(
              "assets/images/avatar-profile.jpg",
              fit: BoxFit.cover,
            ),
          ),
          renoveIsConnectedButton
              ? Positioned(
                  top: wv * 7,
                  left: wv * 8,
                  child: CircleAvatar(
                    radius: wv * 1.5,
                    backgroundColor: primaryColor,
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }

  getProfileStat({String? imgUrl, String? title, int? occurence, Color color = primaryColor}) {
    return Row(children: [
      Container(
        margin: EdgeInsets.only(right: wv * 1),
        child: SvgPicture.asset(
          imgUrl!,
          width: wv * 7,
          color: color,
        ),
      ),
      Column(
        children: [
          Text("$occurence",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          Text(title!, style: TextStyle(fontSize: inch * 1.3))
        ],
      )
    ]);
  }

  Widget getMyCoverageOptionsCard(
      {String? imgUrl, String? label, Color? labelColor}) {
    return Container(
      width: wv * 35,
      height: hv * 17,
      padding: EdgeInsets.symmetric(horizontal: wv * 3, vertical: hv * 2.5),
      margin: EdgeInsets.symmetric(horizontal: wv * 1.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(inch * 2.5)),
          image: DecorationImage(image: AssetImage(imgUrl!), fit: BoxFit.cover)),
      child: Align(
        child: Text(label!,
            style: TextStyle(
                color: labelColor, fontSize: 16, fontWeight: FontWeight.w800)),
        alignment: Alignment.bottomLeft,
      ),
    );
  }

  Widget getMyCoverageHospitalsTiles({String? initial, String? name, DateTime? date, num? price, num? state, Function()? action}) {
    return ListTile(
      onTap: action,
      leading: Container(
        width: wv * 13,
        padding: EdgeInsets.symmetric(horizontal: wv * 1, vertical: hv * 2),
        decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.all(Radius.circular(inch * 1))),
        child: Center(
            child: Text(initial!,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: inch * 2,
                    fontWeight: FontWeight.w700))),
      ),
      title: Text(
        name!,
        style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: inch * 1.6),
      ),
      subtitle: Text(
        DateFormat('EEEE', 'fr_FR').format(date!)+", "+ date.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(date)+" "+ date.year.toString(),
        style: TextStyle(color: kPrimaryColor),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            price.toString()+ "f.",
            style: TextStyle(color: kPrimaryColor, fontSize: inch * 1.5),
          ),
          Text(
            getUseCaseStateText(state!),
            style: TextStyle(
                color: getUseCaseStateColor(state),
                fontSize: inch * 1.5),
          ),
        ],
      ),
    );
  }

  getMyDoctorAppointmentTile({String? label, String? doctorName, DateTime? date, String? type, int? state, required Function() action}) {
    return ListTile(
      leading: Container(
        width: wv * 12,
        padding: EdgeInsets.symmetric(horizontal: wv * 1),
        decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.all(Radius.circular(inch * 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(date!.day.toString().padLeft(2, '0'),
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: inch * 1.7,
                    fontWeight: FontWeight.w700)),
            Text("${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: inch * 1.5,
                    fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          label!,
          style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w700,
              fontSize: inch * 2),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Algorithms.getFormattedDate(date).trim().substring(0, 1).toUpperCase() + Algorithms.getFormattedDate(date).trim().substring(1),
            style: TextStyle(color: kPrimaryColor, fontSize: inch * 1.4),
          ),
          Text(
            doctorName!,
            style: TextStyle(color: kPrimaryColor, fontSize: inch * 1.4),
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            type!,
            style: TextStyle(color: kPrimaryColor, fontSize: inch * 1.7),
          ),
          Text(
            getAppointmentStateText(state!),
            style: TextStyle(
                color: getAppointmentStateColor(state), fontSize: inch * 1.7),
          ),
        ],
      ),
      onTap: action,
    );
  }

  static Widget getLoanTile({String? label, String? subtitle, DateTime? date, num? mensuality, DateTime? firstDate, DateTime? lastDate, String? type, num? state, Function()? action}) {
    String firstDateString = firstDate!.day.toString().padLeft(2, '0') + '/' + firstDate.month.toString().padLeft(2, '0') + '/' + firstDate.year.toString().padLeft(2, '0');
    String lastDateString = lastDate!.day.toString().padLeft(2, '0') + '/' + lastDate.month.toString().padLeft(2, '0') + '/' + lastDate.year.toString().padLeft(2, '0');
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: wv*2),
      leading: Container(
        width: wv * 12,
        padding: EdgeInsets.symmetric(horizontal: wv * 1),
        decoration: BoxDecoration(
            color: kBrownCanyon,
            borderRadius: BorderRadius.all(Radius.circular(inch * 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(date!.day.toString().padLeft(2, '0'),
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: inch * 1.7,
                    fontWeight: FontWeight.w700)),
            Text("${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: inch * 1.5,
                fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text("$firstDateString au $lastDateString", style: TextStyle(color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis, maxLines: 2,),),
      subtitle: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle!, style: TextStyle(color: kPrimaryColor, fontSize: 14), overflow: TextOverflow.fade, maxLines: 1,)
            ],
          ),
        ],
      ),
      trailing: Container(
        width: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(mensuality.toString()+" .f", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                Text("", style: TextStyle(color: kPrimaryColor, fontSize: inch * 1.7),),
              ],
            ),
            SizedBox(width: wv*2,),
            Column(
              children: [
                SvgPicture.asset('assets/icons/Two-tone/Wallet.svg', height: 35,),
                Text(S.current.payer, style: TextStyle(color: kSouthSeas, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            )
          ],
        ),
      ),
      onTap: action,
    );
  }

  String getUseCaseStateText(num val) {
    if (val == 0)
      return S.current.enAttente;
    else if (val == 1)
      return S.current.enCours;
    else if (val == 2)
      return S.current.rejett;
    else
      return S.current.cltur;
  }

  Color getUseCaseStateColor(num val) {
    if (val == 0)
      return kBrownCanyon;
    else if (val == 1)
      return primaryColor;
    else if (val == 2)
      return Colors.red;
    else
      return kDeepTeal;
  }

  String getAppointmentStateText(int val) {
    if (val == 0)
      return S.current.enAttente;
    else if (val == 1)
      return S.current.enCours;
    else if (val == 2)
      return S.current.rejett;
    else
      return S.current.cltur;
  }

  Color getAppointmentStateColor(int val) {
    if (val == 0)
      return primaryColor;
    else if (val == 1)
      return Colors.teal;
    else if (val == 2)
      return Colors.red;
    else
      return Colors.brown;
  }

  verticalDivider() {
    return Container(
      width: wv * 0.5,
      height: wv * 8,
      color: Colors.grey.withOpacity(0.4),
    );
  }

  static beneficiaryCard({String? name, String? imgUrl, bool edit = true, Function()? action}){
    return Container(
      width: wv*25,
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name!, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(right: wv*2),
                height: hv*18, width: wv*25,
                decoration: BoxDecoration(
                  image: DecorationImage(image: CachedNetworkImageProvider(imgUrl!), fit: BoxFit.cover),
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 1.0, blurRadius: 2.0, offset: Offset(0, 1))]
                ),
                child: ((imgUrl == null) || (imgUrl == "")) ? Icon(LineIcons.user, color: Colors.black26, size: wv*25,) : Container(),
              ),
              edit ? Positioned(
                bottom: hv*0,
                child: IconButton(padding: EdgeInsets.all(0),
                  icon: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [BoxShadow(color: Colors.black45.withOpacity(0.3), spreadRadius: 2.0, blurRadius: 3.0, offset: Offset(0, 2))]
                    ),
                    child: CircleAvatar(child: SvgPicture.asset('assets/icons/Bulk/Edit.svg', width: wv*4.5,), backgroundColor: whiteColor, radius: wv*4,)), 
                  onPressed: action
                ),
              ) : Container()
            ],
          )
        ],
      ),
    );
  }

  static beneficiaryChoiceCard({String? name, String? imgUrl, Function()? editAction, Function()? selectAction, bool isSelected = false}){
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: selectAction,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: wv*1),
                  height: isSelected ? hv*21 : hv*18,
                  width: isSelected ? wv*28 : wv*25,
                  decoration: BoxDecoration(
                    image: imgUrl == null ? null : DecorationImage(image: CachedNetworkImageProvider(imgUrl), fit: BoxFit.cover),
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 1.0, blurRadius: 2.0, offset: Offset(0, 1))]
                  ),
                  child: ((imgUrl == null) || (imgUrl == "")) ? Icon(LineIcons.user, color: Colors.black26, size: wv*25,) : Container(),
                ),
              ),
              Positioned(
                bottom: hv*0,
                child: Column(
                  children: [
                    IconButton(padding: EdgeInsets.all(0),
                      icon: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [BoxShadow(color: Colors.black45.withOpacity(0.3), spreadRadius: 2.0, blurRadius: 3.0, offset: Offset(0, 2))]
                        ),
                        child: CircleAvatar(child: SvgPicture.asset('assets/icons/Bulk/Edit.svg', width: wv*4.5,), backgroundColor: whiteColor, radius: wv*4,)), 
                      onPressed: editAction
                    ),
                  ],
                ),
              )
            ],
          ),
          Text(name ?? "Aucun nom", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)
        ],
      ),
    );
  }

  static appointmentPurpose({String? iconPath, String? title, bool enable = true, Function()? action}){
    return Container(
      decoration: BoxDecoration(
        color: kSouthSeas,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 3.0, spreadRadius: 1.0, offset: Offset(0, 2))]
      ),
      child: Row(children: [
        SizedBox(width: wv*2.5,),
        SvgPicture.asset(iconPath!, width: wv*7, color: whiteColor,),
        SizedBox(width: wv*3,),
        Expanded(child: 
          CustomTextButton(
            enable: enable,
            text: title!,
            color: kPrimaryColor,
            noPadding: true,
            action: action!,
          )
        )
      ],)
    );
  }

  static consultationType({String? iconPath, String? title, String? type, String? price, bool selected = false, Function()? action}){
    return  GestureDetector(
      onTap: action,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: hv*1.5),
        margin: EdgeInsets.symmetric(horizontal: wv*1.5, vertical: hv*1.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: selected ? kDeepTeal.withOpacity(0.4) : Colors.transparent, width: 1.0),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 2.0, spreadRadius: 1.0, offset: Offset(0,1))]
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: wv*1.5),
            SvgPicture.asset(iconPath!, width: wv*9.5, color: kSouthSeas,),
            SizedBox(width: wv*2),
            RichText(text: TextSpan(
              text: "$title\n",
              children: [
                TextSpan(text: "$type\n\n", style: TextStyle(fontSize: wv*4.2, fontWeight: FontWeight.bold),),
                TextSpan(text: "$price Cfa", style: TextStyle(fontSize: wv*4.2, color: kBlueDeep),)
              ], style: TextStyle(color: kPrimaryColor, fontSize: wv*3.8)),
            ),
            SizedBox(width: wv*4,)
          ],
        ),
      ),
    );
  }
  
  static publicationType({IconData? icon, String? title, bool selected = false, Function()? action}){
    return  GestureDetector(
      onTap: action,
      child: Container(
        height: 120,
        width: wv*28,
        padding: EdgeInsets.symmetric(vertical: hv*1.5, horizontal: wv*2),
        margin: EdgeInsets.symmetric(horizontal: wv*1.5, vertical: hv*1.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: selected ? kDeepTeal.withOpacity(0.8) : Colors.transparent, width: 1.5),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 2.0, spreadRadius: 1.0, offset: Offset(0,1))]
        ),
        child: Column(mainAxisSize: MainAxisSize.min,
          children: [
            Text(title!, style: TextStyle(color: kBlueDeep, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
            Spacer(),
            Icon(icon, size: 50, color: Colors.grey[400],),
          ],
        ),
      ),
    );
  }

  static accountParameters({String? title, String? subtitle, String? svgIcon, Function()? action}){
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: ListTile(
        title: Padding(
          padding: EdgeInsets.only(bottom: 5.0),
          child: Text(title!, style: TextStyle(color: kBlueDeep, fontWeight: FontWeight.w900, fontSize: 17)),
        ),
        subtitle: Row(children: [
          SvgPicture.asset(svgIcon!, color: kSouthSeas, width: 30,), SizedBox(width: wv*2,),
          Expanded(child: Text(subtitle!, style: TextStyle(color: kPrimaryColor, fontSize: 15), overflow: TextOverflow.fade,))
        ],),
        trailing: TextButton(onPressed: action, child: Text(S.current.modifier, style: TextStyle(color: kBrownCanyon, fontWeight: FontWeight.bold))),
      ),
    );
  }

  static termsAndConditionsTile({Function(bool?)? onChanged, bool? value, Function()? action, Color? activeColor, Color? textColor}){
    return CheckboxListTile(
      tristate: false,
      dense: true,
      title: ExcludeSemantics(
        excluding: true,
        child: Container(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16),
              children: [
                TextSpan(
                  text: S.current.luEtAcceptLes,
                  style: TextStyle(color: textColor == null ? Colors.grey[600] : textColor),
                ),
                TextSpan(
                  text: S.current.termesDesServices,
                  style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = action,
                )
              ]
            ),
            overflow: TextOverflow.fade,
          ),
        ),
      ),
      value: value,
      activeColor: activeColor ?? primaryColor,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  static confirmTermsTile({Function(bool)? onChanged, bool? value, Function()? action, Color? activeColor, Color? textColor}){
    return CheckboxListTile(
      tristate: false,
      dense: true,
      title: ExcludeSemantics(
        excluding: true,
        child: Container(
          child: Column(
            children: [
              Text(S.current.jeReconnaisParLaPrsenteQuenCasDeDfautDe, style:  TextStyle(color: textColor == null ? Colors.grey[600] : textColor, fontWeight: FontWeight.w600),),
              SizedBox(height: hv*0.5),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                  text: TextSpan(
                    style:  TextStyle(color: textColor == null ? Colors.grey[600] : textColor, fontWeight: FontWeight.w400,),
                    children: [
                      TextSpan(
                        text: "\u2022 " + S.current.desPoursuiteJudiciairesn,
                      ),
                      TextSpan(
                        text: "\u2022 " + S.current.incriptionAuFichierPublicDesMauvaisPayeurs,
                      ),
                      TextSpan(
                        text: S.current.creditRiskCameroun,
                        style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                        //recognizer: TapGestureRecognizer()..onTap = action,
                      ),
                    ]
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ),
      value: value,
      activeColor: activeColor ?? primaryColor,
      onChanged: (bool)=>onChanged,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  static Widget head({String? surname, String? fname, String? avatarUrl, Timestamp? birthDate}){
    return Container(
      padding: EdgeInsets.only(left: wv*4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: hv*1),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.current.pourLePatient, style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w900)),
            SizedBox(height: hv*1,),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: avatarUrl != null ? CachedNetworkImageProvider(avatarUrl) : null,
                  backgroundColor: whiteColor,
                  radius: wv*5,
                  child: avatarUrl != null ? Container() : Icon(LineIcons.user, color: kSouthSeas.withOpacity(0.7), size: wv*8),
                ),
                SizedBox(width: wv*3,),
                Expanded(
                  child: RichText(text: TextSpan(
                    text: surname! + " " +  fname! + "\n",
                    children: birthDate != null ? [
                      TextSpan(text: (DateTime.now().year - birthDate.toDate().year).toString() + S.current.ans, style: TextStyle(fontSize: wv*3.3)),
                    ] : [], style: TextStyle(color: kBlueDeep, fontSize: 16.5)),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],),
          ],
        ),
      ),
    );
  }

  static Widget header({String? title, String? subtitle, String? avatarUrl, String? label, Color titleColor = kPrimaryColor}){
    return Container(
      padding: EdgeInsets.only(left: wv*4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: hv*1),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label != null ? Container(child: Text(label, style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w900)), margin: EdgeInsets.only(bottom: hv*1),) : Container(),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: avatarUrl != null ? CachedNetworkImageProvider(avatarUrl) : null,
                  backgroundColor: whiteColor,
                  radius: wv*5,
                  child: avatarUrl != null ? Container() : Icon(LineIcons.user, color: kSouthSeas.withOpacity(0.7), size: wv*8),
                ),
                SizedBox(width: wv*3,),
                Expanded(
                  child: RichText(text: TextSpan(
                    text: title! + "\n",
                    children: [
                      TextSpan(text: subtitle, style: TextStyle(fontSize: wv*3.3)),
                    ], style: TextStyle(color: titleColor, fontSize: 16.5)),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],),
          ],
        ),
      ),
    );
  }

 static Widget getInfoActionCard({Widget? icon, String? title, String? subtitle, String? actionLabel, bool noAction = false, bool noPadding = false, Function()? action, BuildContext? context}){
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        boxShadow: [BoxShadow(color: Colors.grey[350]!, spreadRadius: 0.5, blurRadius: 1.0)],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(inch*1), topRight: Radius.circular(inch*1), bottomLeft: Radius.circular(inch*1),)
      ),
      margin: EdgeInsets.symmetric(horizontal: noPadding ? 0 : wv*3),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: icon == null ? Icon(Icons.message, size: Device.isSmartphone(context!) ? 35 : 50, color: Colors.teal[300],) : icon,
              ),
            ),
            Expanded(
              flex: 7,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: hv*1,),
                  Text(title!, style: TextStyle(color: kPrimaryColor, fontSize: Device.isSmartphone(context!) ? 14 : 20, fontWeight: FontWeight.bold)
                  ),
                  Text(subtitle!, style: TextStyle(color: kPrimaryColor, fontSize: Device.isSmartphone(context) ? 12 : 18)),
                  SizedBox(height: hv*1,),
                ],
              ),
            ),
            !noAction ? Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: action,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(inch*1), bottomLeft: Radius.circular(inch*1),),
                    color: kPrimaryColor,
                  ),
                  child: Center(child: Text(actionLabel!, style: TextStyle(color: Colors.white, fontSize: Device.isSmartphone(context) ? 14 : 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
                ),
              ),
            ): Container()
          ],
        ),
      ),
    );
  }
  
  static getStatusIndicator({double size = 15, num? status}){
    Color color = status == 0 ? Colors.red : status == 1 ? kDeepTeal : primaryColor;
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: color.withOpacity(0.4)
      ),
      child: Icon(status == 0 ? LineIcons.times : status == 1 ? LineIcons.check : Icons.priority_high_rounded, color: color, size: size,),
    );
  }  
  
  static getIconBox({double size = 15, String? iconPath, Color? color, Function()? action}){
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: color!.withOpacity(0.4)
        ),
        child: SvgPicture.asset(iconPath!, width: size, color: color,),
      ),
    );
  }

  static Widget getPromotionTile({String? title, String? description, num? amount, DateTime? firstDate, DateTime? lastDate, bool? active, bool? chosen, Function()? action}) {
    String? lastDateString = lastDate!.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(lastDate)+" "+ firstDate!.year.toString();
    return Container(
      margin: EdgeInsets.symmetric(vertical: hv*0.5, horizontal: wv*2),
      padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey[200]!.withOpacity(0.8), blurRadius: 20.0, spreadRadius: 7.0, offset: Offset(0, 7))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toString(), style: TextStyle(color: kDeepTeal, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(description.toString(), style: TextStyle(color: kDeepTeal, fontSize: 14), overflow: TextOverflow.fade),
          SizedBox(height: hv*2,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Montant", style: TextStyle(color: kPrimaryColor, fontSize: 14)),
                  Text("$amount f.", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.fade),
                ],
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Fin de la promotion", style: TextStyle(color: kPrimaryColor, fontSize: 14)),
                      Text(lastDateString, style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(width: wv*5,),
                  Container(
                    child: CustomTextButton(
                      text: chosen! ? " Annuler " : " Profiter ",
                      fontSize: 14,
                      color: chosen ? kSouthSeas : kDeepTeal,
                      noPadding: true,
                      expand: false,
                      action: action!,
                    )
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  static Widget getInvoiceSegmentTile({String? label, String? subtitle, DateTime? date, num? mensuality, DateTime? firstDate, DateTime? lastDate, String? type, num? state, Function()? action}) {
    String firstDateString = firstDate!.day.toString().padLeft(2, '0') + '/' + firstDate.month.toString().padLeft(2, '0') + '/' + firstDate.year.toString().padLeft(2, '0');
    String lastDateString = lastDate!.day.toString().padLeft(2, '0') + '/' + lastDate.month.toString().padLeft(2, '0') + '/' + lastDate.year.toString().padLeft(2, '0');
    return Container(
      margin: EdgeInsets.symmetric(vertical: hv*0.5, horizontal: wv*2),
      padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey[200]!.withOpacity(0.8), blurRadius: 20.0, spreadRadius: 7.0, offset: Offset(0, 7))]
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: wv*2),
        leading: Container(
          width: wv * 12,
          padding: EdgeInsets.symmetric(horizontal: wv * 1),
          decoration: BoxDecoration(
              color: kBrownCanyon,
              borderRadius: BorderRadius.all(Radius.circular(inch * 1))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(date!.day.toString().padLeft(2, '0'),
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: inch * 1.7,
                      fontWeight: FontWeight.w700)),
              Text("${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: inch * 1.5,
                  fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text("$firstDateString au $lastDateString", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis, maxLines: 2,),),
        subtitle: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle!, style: TextStyle(color: Colors.grey[600], fontSize: 14), overflow: TextOverflow.fade, maxLines: 1,)
              ],
            ),
          ],
        ),
        trailing: Container(
          width: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(mensuality.toString()+" .f", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, decoration: state == 1 ? TextDecoration.lineThrough : TextDecoration.none, fontSize: 16)),
                  Text("", style: TextStyle(color: kPrimaryColor, fontSize: inch * 1.7),),
                ],
              ),
              action == null || state == 1 ? Container() : SizedBox(width: wv*2,),
              action == null || state == 1 ? Container() : Column(
                children: [
                  SvgPicture.asset('assets/icons/Two-tone/Wallet.svg', height: 35,),
                  Text(S.current.payer, style: TextStyle(color: kSouthSeas, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              )
            ],
          ),
        ),
        onTap: action,
      ),
    );
  }
   static Widget navigationArrows({Color fillColor = kCardTextColor, Color outlineColor = whiteColor, required Function() prevAction, required Function() nextAction}){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        roundButtonBack(fillColor: fillColor, outlineColor: outlineColor.withOpacity(0.8), prevAction: prevAction),
        roundButtonForward(fillColor: fillColor, outlineColor: outlineColor.withOpacity(0.8), nextAction: nextAction)
      ],),
    );
  }
  static Widget roundButtonForward({required Color fillColor, required Color outlineColor, required Function() nextAction}){
    return GestureDetector(
      onTap: nextAction,
      child: Container(
        decoration: BoxDecoration(
          color: fillColor,
          shape: BoxShape.circle,
          border: Border.all(width: 4, color: outlineColor)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Icon(Icons.arrow_forward_rounded, color: whiteColor.withOpacity(0.8), size: 35,),
      ),
    );
  }

  static Widget roundButtonBack({required Color fillColor, required Color outlineColor, required Function() prevAction}){
    return GestureDetector(
      onTap: prevAction,
      child: Container(
        decoration: BoxDecoration(
          color: kCardTextColor,
          shape: BoxShape.circle,
          border: Border.all(width: 4, color: whiteColor.withOpacity(0.8))
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Icon(Icons.arrow_back, color: whiteColor.withOpacity(0.8), size: 35,),
      ),
    );
  }
}

