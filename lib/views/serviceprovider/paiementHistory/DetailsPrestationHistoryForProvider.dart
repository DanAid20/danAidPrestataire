// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/facture.dart';
import 'package:danaid/core/services/getPlatform.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DetailsPrestationHistoryForProvider extends StatefulWidget {
  final List<Facture>? facture;
  final String? month;
  DetailsPrestationHistoryForProvider({Key? key, this.facture, this.month})
      : super(key: key);

  @override
  _DetailsPrestationHistoryForProviderState createState() =>
      _DetailsPrestationHistoryForProviderState();
}

class _DetailsPrestationHistoryForProviderState extends State<DetailsPrestationHistoryForProvider> {
  String userName = 'a';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 
  @override
  void initState() {
    super.initState();
  }

   getUsername(id) {
    if (mounted){
      var data='';
      var newUseCase =
          FirebaseFirestore.instance.collection('ADHERENTS').doc(id).get();
      newUseCase.then((value) {
        data = value.data()!['cniName'].toString();
        setState((){
        if (kDebugMode) {
          print(data);
        }
        userName = value.data()!['cniName'].toString();

        });
      });
    }

    
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: kBgTextColor,
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: kDateTextColor,
                ),
                onPressed: () => Navigator.pop(context)),
            title: Align(
              alignment: Alignment.center,
              child:  Container(
                child: Column(
                  children: [
                    Text(S.of(context).historiqueDesPrestations, style:  TextStyle(color: kBlueForce, fontSize: wv*4)),
                    Text(S.of(context).vosConsultationsPaiementDetaill, style:  TextStyle(color: kBlueForce, fontSize: wv*4))
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/Bulk/Search.svg',
                  color: kSouthSeas,
                ),
                onPressed: () {},
                color: kSouthSeas,
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/Bulk/Drawer.svg',
                  color: kSouthSeas,
                ),
                onPressed: ()=> _scaffoldKey.currentState!.openEndDrawer(),
                color: kSouthSeas,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 15.w, top: 3.h, bottom: 15.h),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(widget.month!.toUpperCase(),
                                style: TextStyle(
                                    color: kFirstIntroColor,
                                    fontWeight: FontWeight.w700,
                                     fontSize:  Device.isSmartphone(context) ? wv*10.5: 17,
                                    ),
                                textScaleFactor: 1.0),
                            //  Container(height: 4.h, width:30.w, color: kFirstIntroColor, child:Text('') ,)
                          ],
                        ),
                      ],
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 15.w, top: 2.h),
                            child: Text(
                              S.of(context).statusDesPaiements,
                              style: TextStyle(
                                  color: kFirstIntroColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize:  Device.isSmartphone(context) ? 16.sp: 19),
                              textScaleFactor: 1.0,
                            )),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin:
                                EdgeInsets.only(left: wv * 1, right: wv * 5),
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            child: Column(
                              children: [
                                ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: widget.facture!.length,
                                    itemBuilder: (context, index) {
                                      // print( paiementHistory.elementAt(index)[key]);
                                      // print( paiementHistory.elementAt(index)[key]['month']);
                                      // String etat = '';

                                      // String userNamem = 'a';
                                     
                                    
                                      if (widget.facture![index].types!='REFERENCEMENT') {
                                       return FutureBuilder<DocumentSnapshot>(
                                      future:  FirebaseFirestore.instance.collection('ADHERENTS').doc(widget
                                          .facture![index].idAdherent).get(),
                                      builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot) {
                                           if (snapshot.connectionState==ConnectionState.waiting) {
                                              return const Center(
                                                child: CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                                                ),
                                              );
                                            }
                                          if (snapshot.hasError) {
                                            return Text(S.of(context).somethingWentWrong);
                                          }
                                          if (snapshot.connectionState == ConnectionState.done) {
                                            return  HomePageComponents()
                                          .paienementDetailsListItem(
                                              context: context,
                                              etat: widget.facture![index].canPay!.toInt(),
                                              montant:
                                                  '${widget.facture![index].amountToPay}f',
                                              date: DateFormat("dd MMMM yyy ")
                                                  .format(widget.facture![index].createdAt!),
                                              nom: snapshot.data!['cniName']! as String ,
                                              iconesConsultationTypes: widget.facture![index].types=='CONSULTATION' || widget.facture![index].types=='REFERENCEMENT' ?
                                                  'assets/icons/Bulk/Profile.svg' : widget.facture![index].types=='En cabinet'?'assets/icons/Bulk/Profile.svg' : widget.facture![index].types=='Video'? 'assets/icons/Bulk/Video.svg': widget.facture![index].types=='Message'? 'assets/icons/Bulk/Message.svg': 'assets/icons/Bulk/Profile.svg'    );
                                       }
                                           return Text(S.of(context).loading);
                                      });
                                      } else {
                                        userName = widget.facture![index].idFammillyMember!;
                                      return HomePageComponents()
                                          .paienementDetailsListItem( 
                                              etat: widget.facture![index].canPay!.toInt(),
                                              montant:
                                                  '${widget.facture![index].amountToPay!}f',
                                              date: DateFormat("dd MMMM yyy ")
                                                  .format(widget.facture![index].createdAt!),
                                              nom: userName,
                                            iconesConsultationTypes: widget.facture![index].types=='CONSULTATION' || widget.facture![index].types=='REFERENCEMENT' ?
                                                  'assets/icons/Bulk/Profile.svg' : widget.facture![index].types=='En cabinet'?'assets/icons/Bulk/Profile.svg' : widget.facture![index].types=='Video'? 'assets/icons/Bulk/Video.svg': widget.facture![index].types=='Message'? 'assets/icons/Bulk/Message.svg': 'assets/icons/Bulk/Profile.svg'    );
                                      }
                                    }),

                                // HomePageComponents().paienementDetailsListItem(etat: "14:00", montant: '2.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Jonas Erik Nana', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                                // HomePageComponents().paienementDetailsListItem(etat: "Clôturé", montant: '6.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Cabinet Dr. Namaouda Malachie', iconesConsultationTypes: 'assets/icons/Bulk/Video.svg'),
                                // HomePageComponents().paienementDetailsListItem(etat: "En Attente", montant: '14.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Hopital Laquintinie de Douala', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                                // HomePageComponents().paienementDetailsListItem(etat: "14:00", montant: '2.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Jonas Erik Nana', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                                // HomePageComponents().paienementDetailsListItem(etat: "Clôturé", montant: '6.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Cabinet Dr. Namaouda Malachie', iconesConsultationTypes: 'assets/icons/Bulk/Send.svg'),
                                // HomePageComponents().paienementDetailsListItem(etat: "14:00", montant: '14.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Hopital Laquintinie de Douala', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                                // HomePageComponents().paienementDetailsListItem(etat: "14:00", montant: '2.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Jonas Erik Nana', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                                // HomePageComponents().paienementDetailsListItem(etat: "Clôturé", montant: '6.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Cabinet Dr. Namaouda Malachie', iconesConsultationTypes: 'assets/icons/Bulk/Video.svg'),
                                // HomePageComponents().paienementDetailsListItem(etat: "En Attente", montant: '14.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Hopital Laquintinie de Douala', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                                // HomePageComponents().paienementDetailsListItem(etat: "14:00", montant: '2.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Jonas Erik Nana', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                                // HomePageComponents().paienementDetailsListItem(etat: "Clôturé", montant: '6.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Cabinet Dr. Namaouda Malachie', iconesConsultationTypes: 'assets/icons/Bulk/Send.svg'),
                                // HomePageComponents().paienementDetailsListItem(etat: "14:00", montant: '14.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Hopital Laquintinie de Douala', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                              ],
                            )),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
