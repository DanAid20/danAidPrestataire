import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DetailsPrestationHistory extends StatefulWidget {
  DetailsPrestationHistory({Key key}) : super(key: key);

  @override
  _DetailsPrestationHistoryState createState() => _DetailsPrestationHistoryState();
}

class _DetailsPrestationHistoryState extends State<DetailsPrestationHistory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: kBgTextColor,
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: kDateTextColor,
                ),
                onPressed: () => Navigator.pop(context)),
            title: Align(
              alignment: Alignment.center,
              child: Container(
                child: Column(
                  children: [Text('Historique des prestations '), Text('Vos consultations & paiement detaillé')],
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
                onPressed: () {},
                color: kSouthSeas,
              )
            ],
          ),
          body: SingleChildScrollView(
    
      child: Column(
              children: [
                Container(   margin : EdgeInsets.only(
                              left: 15.w,top: 3.h, bottom: 15.h), alignment: Alignment.centerLeft,
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text('2022', style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w700,
                                          
                                          fontSize: wv*3.5), textScaleFactor: 1.0),
                                    //  Container(height: 4.h, width:30.w, color: kFirstIntroColor, child:Text('') ,)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('2021', style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w700,
                                          
                                          fontSize: wv*3.5), textScaleFactor: 1.0),
                                      Container(height: 4.h, width:30.w, color: kFirstIntroColor, child:Text('') ,)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('2020', style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w700,
                                          
                                          fontSize: wv*3.5), textScaleFactor: 1.0),
                                      //Container(height: 4.h, width:30.w, color: kFirstIntroColor, child:Text('') ,)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('2019', style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w700,
                                          
                                          fontSize: wv*3.5), textScaleFactor: 1.0),
                                     // Container(height: 4.h, width:30.w, color: kFirstIntroColor, child:Text('') ,)
                                    ],
                                  ),
                                 
                                ],
                              )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin : EdgeInsets.only(
                              left: 15.w,top: 2.h),
                          child: Text('Status des Paiements ', style: TextStyle(
                                      color: kFirstIntroColor,
                                      fontWeight: FontWeight.w500,
                                      
                                      fontSize:  16.sp), textScaleFactor: 1.0,)),
                        Container(
                           alignment: Alignment.centerLeft,
                           
                          margin: EdgeInsets.only(left: wv*1, right: wv*5) ,
                          padding: EdgeInsets.all(10) ,
                          width: double.infinity,
                          
                          child: Column(
                            children: [
                              HomePageComponents().paienementDetailsListItem(etat: "14:00", montant: '2.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Jonas Erik Nana', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                              HomePageComponents().paienementDetailsListItem(etat: "Clôturé", montant: '6.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Cabinet Dr. Namaouda Malachie', iconesConsultationTypes: 'assets/icons/Bulk/Video.svg'),
                              HomePageComponents().paienementDetailsListItem(etat: "En Attente", montant: '14.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Hopital Laquintinie de Douala', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                              HomePageComponents().paienementDetailsListItem(etat: "14:00", montant: '2.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Jonas Erik Nana', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                              HomePageComponents().paienementDetailsListItem(etat: "Clôturé", montant: '6.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Cabinet Dr. Namaouda Malachie', iconesConsultationTypes: 'assets/icons/Bulk/Send.svg'),
                              HomePageComponents().paienementDetailsListItem(etat: "14:00", montant: '14.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Hopital Laquintinie de Douala', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                              HomePageComponents().paienementDetailsListItem(etat: "14:00", montant: '2.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Jonas Erik Nana', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                              HomePageComponents().paienementDetailsListItem(etat: "Clôturé", montant: '6.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Cabinet Dr. Namaouda Malachie', iconesConsultationTypes: 'assets/icons/Bulk/Video.svg'),
                              HomePageComponents().paienementDetailsListItem(etat: "En Attente", montant: '14.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Hopital Laquintinie de Douala', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                              HomePageComponents().paienementDetailsListItem(etat: "14:00", montant: '2.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Jonas Erik Nana', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                              HomePageComponents().paienementDetailsListItem(etat: "Clôturé", montant: '6.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Cabinet Dr. Namaouda Malachie', iconesConsultationTypes: 'assets/icons/Bulk/Send.svg'),
                              HomePageComponents().paienementDetailsListItem(etat: "14:00", montant: '14.000f.', date: 'Mercredi, 22 kanvier 2021', nom:'Hopital Laquintinie de Douala', iconesConsultationTypes: 'assets/icons/Bulk/Profile.svg'),
                            ],
                          )
                         ),
                      ],
                    )),
                  ],
                ),
              
              ],
            ),
          ),
        )
      );
  }
}