import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/providers/usecaseModelProvider.dart';
import 'package:danaid/helpers/SizeConfig.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerUserListView extends StatefulWidget {
  final String idOfAdherent;
  final BeneficiaryModel  beneficiare;
  final String consultationCode;
  final DateTime createdAt;
  OwnerUserListView({Key key, this.consultationCode, this.createdAt, this.idOfAdherent, this.beneficiare}) : super(key: key);

  @override
  _OwnerUserListViewState createState() => _OwnerUserListViewState();
}

class _OwnerUserListViewState extends State<OwnerUserListView> {
UseCaseModelProvider userCaprovider;
 DateTime date;
  @override
  void initState() {
    super.initState();
     userCaprovider= Provider.of<UseCaseModelProvider>(context, listen: false);
    date= widget.createdAt;
   
  }
 String getAge(date){
    Timestamp t =date;
    DateTime d = t.toDate();
    DateTime dateTimeNow = DateTime.now();
    final differenceInDays = dateTimeNow.difference(d).inDays ~/365;
 
  return differenceInDays.toString();
 }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
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
                  children: [
                    Text('Carnet de santé  '),
                    Text('${DateFormat('dd MMMM yyyy, h:mm').format(date)}')
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
                onPressed: () {},
                color: kSouthSeas,
              )
            ],
          ),
          body: Container(
              child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          HomePageComponents().getAvatar(
                              imgUrl: widget.beneficiare !=null?  widget.beneficiare.avatarUrl:  'assets/images/avatar-profile.jpg',
                              size: MySize.size42,
                              renoveIsConnectedButton: false),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.beneficiare.cniName,
                                  style: TextStyle(
                                      color: kBlueForce,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MySize.getScaledSizeHeight(19.0))),
                              Row(
                                children: [
                                  Text(widget.beneficiare.gender=="H"? 'Masculin': 'Feminin ',
                                      style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize:
                                              MySize.getScaledSizeHeight(17))),
                                  SizedBox(width: MySize.getScaledSizeHeight(5),),
                                  Text('${getAge(widget.beneficiare.birthDate)} ',
                                      style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize:
                                              MySize.getScaledSizeHeight(17))),
                                  Text(' ans',
                                      style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize:
                                              MySize.getScaledSizeHeight(17))),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: Spacing.all(8.0),
                                  child: Container(
                                      child: Text('BMI',
                                          style: TextStyle(
                                              color: kBlueForce,
                                              fontSize:
                                                  MySize.getScaledSizeHeight(
                                                      22),
                                              letterSpacing: 2.h,
                                              fontWeight: FontWeight.w400))),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          children: [
                                            Text(''),
                                            Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                decoration: BoxDecoration(
                                                  color: kBlueForceLight,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                height:
                                                    MySize.getScaledSizeHeight(
                                                        5),
                                                width:
                                                    MySize.getScaledSizeWidth(
                                                        20),
                                                child: Text('')),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('${widget.beneficiare.weight/ widget.beneficiare.height*widget.beneficiare.height}',
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    color: kBlueForce,
                                                    fontSize: MySize
                                                        .getScaledSizeHeight(
                                                            14),
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: kDeepTealCAdress,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(3),
                                                          topRight:
                                                              Radius.circular(
                                                                  3)),
                                                ),
                                                height:
                                                    MySize.getScaledSizeWidth(
                                                        12),
                                                width:
                                                    MySize.getScaledSizeWidth(
                                                        35),
                                                child: Text('')),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(''),
                                            Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                decoration: BoxDecoration(
                                                    color: kGoldlightYellow),
                                                height:
                                                    MySize.getScaledSizeWidth(
                                                        5),
                                                width:
                                                    MySize.getScaledSizeWidth(
                                                        25),
                                                child: Text('')),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(''),
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                height:
                                                    MySize.getScaledSizeWidth(
                                                        5),
                                                width:
                                                    MySize.getScaledSizeWidth(
                                                        25),
                                                child: Text('')),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          margin: Spacing.only(right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/Bulk/BloodGroup.svg',
                                      height: MySize.getScaledSizeWidth(25),
                                      width: MySize.getScaledSizeWidth(25),
                                      color: kDeepTealCAdress,
                                    ),
                                    SizedBox(
                                        height: MySize.getScaledSizeHeight(5)),
                                    SvgPicture.asset(
                                      'assets/icons/Bulk/weight.svg',
                                      height: MySize.getScaledSizeWidth(25),
                                      width: MySize.getScaledSizeWidth(25),
                                      color: kDeepTealCAdress,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: Spacing.only(
                                                            left: 5, top: 5),
                                                        child: Text(
                                                          widget.beneficiare.bloodGroup,
                                                          style: TextStyle(
                                                              color: kBlueForce,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: MySize
                                                                  .getScaledSizeHeight(
                                                                      14)),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: MySize
                                                              .getScaledSizeHeight(
                                                                  15)),
                                                      Text(
                                                        '${ widget.beneficiare.weight} Kg',
                                                        style: TextStyle(
                                                            color: kBlueForce,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: MySize
                                                                .getScaledSizeHeight(
                                                                    14)),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding: Spacing.only(
                                                            right: 6.0),
                                                        child: SvgPicture.asset(
                                                          'assets/icons/Bulk/Pedestrian.svg',
                                                          height: MySize
                                                              .getScaledSizeHeight(
                                                                  60),
                                                          width: MySize
                                                              .getScaledSizeWidth(
                                                                  50),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ])
                                      ],
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          color: kDeepTealCAdress,
                                        ),
                                        height: MySize.getScaledSizeHeight(3),
                                        width: MySize.getScaledSizeWidth(70),
                                        child: Text(' ')),
                                  ],
                                )
                              ]),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                Column(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: kDeepTealCAdress,
                                        ),
                                        height: MySize.getScaledSizeHeight(2),
                                        width: MySize.getScaledSizeWidth(20),
                                        child: Text(' ')),
                                    Container(
                                        decoration: BoxDecoration(
                                          color: kDeepTealCAdress,
                                        ),
                                        height: MySize.getScaledSizeHeight(10),
                                        width: MySize.getScaledSizeWidth(2),
                                        child: Text(' ')),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                        child: Text('${ widget.beneficiare.height}',
                                            style: TextStyle(
                                                color: kBlueForce,
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    MySize.getScaledSizeHeight(
                                                        14)))),
                                    Container(
                                        child: Text('cm',
                                            style: TextStyle(
                                                color: kBlueForce,
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    MySize.getScaledSizeHeight(
                                                        14)))),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: kDeepTealCAdress,
                                        ),
                                        height:
                                            MySize.getScaledSizeHeight(10),
                                        width: MySize.getScaledSizeWidth(2),
                                        child: Text(' ')),
                                    Container(
                                        decoration: BoxDecoration(
                                          color: kDeepTealCAdress,
                                        ),
                                        height: MySize.getScaledSizeHeight(2),
                                        width: MySize.getScaledSizeWidth(20),
                                        child: Text(' ')),
                                  ],
                                )
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MySize.getScaledSizeHeight(5),),
                    Container(
                      height: MySize.getScaledSizeHeight(100),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: kTealsLinearColors),
                      child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          Positioned(
                              right: 0,
                              top:-2,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: kDeepDarkTeal,
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20))),
                                  height: MySize.getScaledSizeHeight(85),
                                  width: MySize.getScaledSizeWidth(85),
                                  child: Padding(
                                    padding: Spacing.only(left: 15.0, top: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      
                                      children: [
                                        Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Profil', style: TextStyle(color: whiteColor, fontSize: MySize.getScaledSizeHeight(15), fontWeight: FontWeight.bold),),
                                            Text('Détaillé', style: TextStyle(color: whiteColor, fontSize: MySize.getScaledSizeHeight(15), fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                         
                                          SizedBox(
                                            height: MySize.getScaledSizeWidth(3),
                                          ),
                                       SvgPicture.asset(
                                        'assets/icons/Bulk/ArrowDown.svg',
                                            width:MySize.getScaledSizeWidth(35),
                                            height:MySize.getScaledSizeHeight(25),
                                        ),
                                      ],
                                    ),
                                  ))),
                        Positioned(
                              right: MySize.getScaledSizeWidth(70),
                               top:MySize.getScaledSizeWidth(-2),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color:  Color(0xFF7CA9A9),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20))),
                                  height: MySize.getScaledSizeHeight(85),
                                  width: MySize.getScaledSizeWidth(110),
                                  child: Padding(
                                    padding: Spacing.only(left:10.0, top: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      
                                      children: [
                                        Column(
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text('Prochains', style: TextStyle(color: whiteColor, fontSize: MySize.getScaledSizeHeight(15), fontWeight: FontWeight.bold),),
                                            Text('Rendez-vous', style: TextStyle(color: whiteColor, fontSize: MySize.getScaledSizeHeight(15), fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                         
                                          SizedBox(
                                            height: MySize.getScaledSizeWidth(3),
                                          ),
                                       SvgPicture.asset(
                                        'assets/icons/Bulk/Calendar.svg',
                                            width:MySize.getScaledSizeWidth(40),
                                            height:MySize.getScaledSizeHeight(30),
                                        ),
                                      ],
                                    ),
                                  ))),
                        Positioned(
                              right: MySize.getScaledSizeWidth(170),
                               top:MySize.getScaledSizeWidth(-2),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF82AEAC),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20))),
                                  height: MySize.getScaledSizeHeight(85),
                                  width: MySize.getScaledSizeWidth(80),
                                  child: Padding(
                                    padding: Spacing.only(left: 2.0, top: 10.0, right: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,                                     
                                      children: [
                                        Column(
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text('Suive des',  style: TextStyle(color: whiteColor, fontSize: MySize.getScaledSizeHeight(15), fontWeight: FontWeight.bold),),
                                            Text('Soins', style: TextStyle(color: whiteColor, fontSize: MySize.getScaledSizeHeight(15), fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                         
                                          SizedBox(
                                            height: MySize.getScaledSizeWidth(3),
                                          ),
                                       SvgPicture.asset(
                                        'assets/icons/Bulk/More Square.svg',
                                            width:MySize.getScaledSizeWidth(35),
                                            height:MySize.getScaledSizeHeight(15),
                                        ),
                                      ],
                                    ),
                                  ))),
                        Positioned(
                              right: MySize.getScaledSizeWidth(170),
                               top:MySize.getScaledSizeWidth(-2),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF82AEAC),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20))),
                                  height: MySize.getScaledSizeHeight(85),
                                  width: MySize.getScaledSizeWidth(80),
                                  child: Padding(
                                    padding: Spacing.only(left: 15.0, top: 10.0, right: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,                                     
                                      children: [
                                        Column(
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text('Suivi des ',  style: TextStyle(color: whiteColor, fontSize: MySize.getScaledSizeHeight(15), fontWeight: FontWeight.bold),),
                                            Text('Soins', style: TextStyle(color: whiteColor, fontSize: MySize.getScaledSizeHeight(15), fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                         
                                          SizedBox(
                                            height: MySize.getScaledSizeWidth(3),
                                          ),
                                       SvgPicture.asset(
                                        'assets/icons/Bulk/More Square.svg',
                                            width:MySize.getScaledSizeWidth(35),
                                            height:MySize.getScaledSizeHeight(25),
                                        ),
                                      ],
                                    ),
                                  ))),
                        Positioned(
                              right: MySize.getScaledSizeWidth(240),
                               top:MySize.getScaledSizeWidth(-2),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: kTabs2,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20))),
                                  height: MySize.getScaledSizeHeight(85),
                                  width: MySize.getScaledSizeWidth(80),
                                  child: Padding(
                                    padding: Spacing.only(left: 15.0, top: 10.0, right: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,                                     
                                      children: [
                                        Column(
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text('Données ',  style: TextStyle(color: whiteColor, fontSize: MySize.getScaledSizeHeight(15), fontWeight: FontWeight.bold),),
                                            Text('Vitales', style: TextStyle(color: whiteColor, fontSize: MySize.getScaledSizeHeight(15), fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                         
                                          SizedBox(
                                            height: MySize.getScaledSizeWidth(3),
                                          ),
                                       SvgPicture.asset(
                                        'assets/icons/Bulk/Activity.svg',
                                            width:MySize.getScaledSizeWidth(35),
                                            height:MySize.getScaledSizeHeight(25),
                                        ),
                                      ],
                                    ),
                                  ))),
                        Positioned(
                              right: MySize.getScaledSizeWidth(310),
                               top:MySize.getScaledSizeWidth(-2),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: kDeepDarkTeal,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20))),
                                  height: MySize.getScaledSizeHeight(85),
                                  width: MySize.getScaledSizeWidth(100),
                                  child: Padding(
                                    padding: Spacing.only(left:30.0, top: 10.0, right: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,                                     
                                      children: [
                                        Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Notes du  ',  style: TextStyle(color: whiteColor, fontSize: MySize.getScaledSizeHeight(15), fontWeight: FontWeight.bold),),
                                            Text('Médecin', style: TextStyle(color: whiteColor, fontSize: MySize.getScaledSizeHeight(15), fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                         
                                          SizedBox(
                                            height: MySize.getScaledSizeWidth(3),
                                          ),
                                       SvgPicture.asset(
                                        'assets/icons/Bulk/Edit Square.svg',
                                            width:MySize.getScaledSizeWidth(35),
                                            height:MySize.getScaledSizeHeight(25),
                                            color: whiteColor,
                                        ),
                                      ],
                                    ),
                                  ))),
                          
                        ],
                      ),
                    )
                  ]),
                ),
                Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Code De consultation ',style: TextStyle(
                              color: kCardTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: MySize.getScaledSizeHeight(20) )),
                      Text('${widget.consultationCode}',style: TextStyle(
                              color: kCardTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: MySize.getScaledSizeHeight(20) )),
                    ],
                  ),
                ))
              ],
            ),
          )),
        ));
  }
}
