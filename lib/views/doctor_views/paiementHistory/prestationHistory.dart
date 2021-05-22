import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
class PrestationHistory extends StatefulWidget {
  PrestationHistory({Key key}) : super(key: key);

  @override
  _PrestationHistoryState createState() => _PrestationHistoryState();
}

class _PrestationHistoryState extends State<PrestationHistory> {
 
  @override
  Widget build(BuildContext context) {
     String data= DateFormat("yyyy").format(DateTime.now());
    print(data);
    int dataTIme= int.parse(data);
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
                  children: [Text('Historique des prestqtions'), Text('Vos consultations & paiement')],
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
                                      Text('${dataTIme+1}', style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w700,
                                          
                                          fontSize: wv*3.5), textScaleFactor: 1.0),
                                    //  Container(height: 4.h, width:30.w, color: kFirstIntroColor, child:Text('') ,)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('${dataTIme}', style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w700,
                                          
                                          fontSize: wv*3.5), textScaleFactor: 1.0),
                                      Container(height: 4.h, width:30.w, color: kFirstIntroColor, child:Text('') ,)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('${dataTIme-1}', style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w700,
                                          
                                          fontSize: wv*3.5), textScaleFactor: 1.0),
                                      //Container(height: 4.h, width:30.w, color: kFirstIntroColor, child:Text('') ,)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('${dataTIme-2}', style: TextStyle(
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
                           
                          margin: EdgeInsets.only(left: wv*5, top: hv*2, right: wv*5) ,
                          padding: EdgeInsets.all(20) ,
                          width: double.infinity,
                              decoration: BoxDecoration(
                                color:kThirdIntroColor.withOpacity(0.3),
                                
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                          child: 
                          Column(
                            mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              
                              children: [
                                Text('Consultation', textScaleFactor: 1.0, style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w500,
                                          
                                          fontSize: wv*3.5)),
                                Container(
                                  margin: EdgeInsets.only(left:wv*6),
                                  child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('15 x',textScaleFactor: 1.0, style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w600,
                                          
                                          fontSize: wv*3.5)),
                                            Text('2000 f.',style: TextStyle(
                                          color: kSimpleForce,
                                          fontWeight: FontWeight.w500,
                                          
                                          fontSize: wv*3.5), textScaleFactor: 1.0,),
                                          ],
                                        ),
                                      Container(
                                        width: 80.w,
                                        child: Text('Beneficiares à jours',style: TextStyle(
                                          color: kSimpleForce,
                                          fontWeight: FontWeight.w500,
                                          fontSize: wv*3), textScaleFactor: 1.0,),
                                      ),
                                        
                                                                          ],
                                    ),
                                  ],
                                )),
                                Text('30.0000f',style: TextStyle(
                                      color: kFirstIntroColor,
                                      fontWeight: FontWeight.w500,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,),
                              ],
                            ),
                             SizedBox(
                          height: hv * 1.3,
                        ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Référencements', textScaleFactor: 1.0, style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w500,
                                          
                                          fontSize: wv*3.5)),
                                Container(
                                  margin: EdgeInsets.only(left:hv*4),
                                  child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('0 x',textScaleFactor: 1.0, style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w600,
                                          
                                          fontSize: wv*3.5)),
                                            Text('2000 f.',style: TextStyle(
                                          color: kSimpleForce,
                                          fontWeight: FontWeight.w500,
                                          
                                          fontSize: wv*3.5), textScaleFactor: 1.0,),
                                          ],
                                        ),
                                       Container(
                                        width: 80.w,
                                        child: Text('Personnes inscrites',style: TextStyle(
                                          color: kSimpleForce,
                                          fontWeight: FontWeight.w500,
                                          fontSize: wv*3), textScaleFactor: 1.0,),
                                      ),
                                      ],
                                    ),
                                  ],
                                )),
                                Spacer(),
                                Text('0f',style: TextStyle(
                                      color: kFirstIntroColor,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,),
                              ],
                            ),
                            new Divider(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total annuel ', textScaleFactor: 1.0, style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w500,
                                          
                                          fontSize: wv*3.5)),
                                 Spacer(),
                                Text('30.000 f',style: TextStyle(
                                      color: kFirstIntroColor,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,),
                              ],
                            ),
                           SizedBox(
                          height: hv * 1.3,
                        ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Payé ', textScaleFactor: 1.0, style: TextStyle(
                                          color: kDeepTeal,
                                          fontWeight: FontWeight.w600,
                                          
                                          fontSize: wv*3.5)),
                                 Spacer(),
                                Text('10.000 f',style: TextStyle(
                                      color: kDeepTeal,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,),
                              ],
                            ),
                           SizedBox(
                          height: hv * 1.3,
                        ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Reste à Payer ', textScaleFactor: 1.0, style: TextStyle(
                                          color: kSimpleForce,
                                          fontWeight: FontWeight.w600,
                                          
                                          fontSize: wv*3.5)),
                                 Spacer(),
                                Text('10.000 f',style: TextStyle(
                                      color: kFirstIntroColor,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,),
                              ],
                            ),
                          ],
                        )),
                      ],
                    )),
                  ],
                ),
               SizedBox(height: hv * 3,),
               Container(
                 width: double.infinity,
                  color: Colors.white,
                  margin: EdgeInsets.only(top: hv * 2),
                              child: Column(
                                children: [
                                  Container( margin: EdgeInsets.only(left: wv * 4, top: hv * 2,bottom: wv * 2),alignment: Alignment.centerLeft, child: Text('Mes derniers prestations', style: TextStyle(
                                      color: kFirstIntroColor,
                                      fontWeight: FontWeight.w500,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,)),
                            Column(
                              children: [
                                GestureDetector(onTap:(){
                                  Navigator.pushNamed(context, '/details-history-prestation-doctor');
                                }, 
                                   child: HomePageComponents().paiementItem()),
                                HomePageComponents().paiementItem(),
                                HomePageComponents().paiementItem(),
                                HomePageComponents().paiementItem(),
                               
                              ],
                            ),
                    

                 ]
                                ,
                              ),
               )
              ],
            ),
          ),
        )
      );
  }
}