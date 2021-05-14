import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:danaid/helpers/constants.dart' as profile;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrestataireProfilePage extends StatefulWidget {
  @override
  _PrestataireProfilePageState createState() => _PrestataireProfilePageState();
}

class _PrestataireProfilePageState extends State<PrestataireProfilePage> {
  
  GoogleMapController mapCardController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  bool isExpanded = false;
  void _onMapCreated(GoogleMapController controller) {
    mapCardController = controller;
  }
  @override
  void initState() {
  
    // TODO: implement initState
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ServiceProviderModelProvider prestataire = Provider.of<ServiceProviderModelProvider>(context);
    var prestatiaireObject= prestataire.getServiceProvider;
    bool isPrestataire=userProvider.getProfileType== serviceProvider ? true : false;

   
    return WillPopScope(
      onWillPop: () async {
        controller.setIndex(1);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isPrestataire? kGold:kPrimaryColor,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: whiteColor,), onPressed: ()=> controller.setIndex(1)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
               Container(
                width:double.infinity,
        decoration: BoxDecoration(
         
           boxShadow: [
                BoxShadow(color: kThirdColor, spreadRadius: 2.5, blurRadius: 4),
              ],
          borderRadius: BorderRadius.only(
               bottomLeft: Radius.circular(10),
               bottomRight: Radius.circular(10),
              ),
        ),
        child: Container(
          width: double.infinity,
          height:200.h ,
          child: Stack(
                fit: StackFit.loose,
                children: <Widget>[
                   Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Container(height: 0.2.sh , width: double.infinity,  decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/image 25.png"),
                          fit: BoxFit.cover,
                        ),
                      
                      ), child: Text('',)),
                       Container(height:0.070.sh, margin: EdgeInsets.only(top: 10.h), width: double.infinity,  color:Colors.black.withOpacity(0.1),
                       child: Text('',)),
                      
                     ], 
                   ),
                   Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(height: 14*hv,color:kGold.withOpacity(0.7), width: double.infinity, child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                     margin: EdgeInsets.only(left: 10.w),
                    child: Text('Hopital de district de New Bell ', style: TextStyle(
                                              color: kBlueForce,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w800), ),
                  ),
                )),

              )),
                   Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container( alignment: Alignment.topRight, height:160.h, width: double.infinity, child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:Container(
                    width: 105.h,
                    child: TextButton(
                                  onPressed: ()=>{}, 
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/icons/Bulk/Edit Square.svg', width: 20, color: kPrimaryColor,),
                                      SizedBox(width: 2,),
                                      Text("Modifier", style: TextStyle(fontSize: 13.sp, color: kPrimaryColor, fontWeight: FontWeight.w900),),
                                    ],
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: wv*3)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                    backgroundColor: MaterialStateProperty.all(whiteColor),
                                    shadowColor: MaterialStateProperty.all(Colors.grey),
                                    elevation: MaterialStateProperty.all(3)
                                  ),
                                ),
                  ),
                )),

              )),
                  
                  Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 69.h,
                  padding: EdgeInsets.only(top:3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                                children: [
                                  
                                  SizedBox(height: hv*1),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      getFeatureCard(title: "Services Offerts", isActifService: true),
                                      getFeatureCard(title: "Consultations"),
                                      getFeatureCard(title: "Soins Ambulances"),
                                    ],
                                  ), 
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      getFeatureCard(title: "Pharmacie"),
                                      getFeatureCard(title: "Labo") ,
                                      getFeatureCard(title: "Hospitalisation") ,
                                    ],
                                  ),
                                
                                ],
                              ),
                ),
              ),
                  )
                  
                ],
              ),
        ) /* add child content here */,
      ),
              
              Column(
                children: [              
                  DefaultTextStyle(
                    style: TextStyle(color: kPrimaryColor),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 5, left:10, top:10.h),
                          child: Text("  A propos", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, fontFamily: 'Quicksand'),),
                        ),
                        SizedBox(height: 3,),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Informed member of a project team using the PMAss method. The aim here is to understand the principles of the method, to master terminology and concept.', textScaleFactor: 1.0,
                           style: TextStyle(fontSize:14.sp ),),
                        ),
                        SizedBox(height: 2.h,),
                        isPrestataire? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                width:  80.w,
                                padding: EdgeInsets.all(6.w),
                                 decoration: BoxDecoration(
                                  color: kblueSky.withOpacity(0.6),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text('Medecin de famille', textScaleFactor: 1.0, textAlign: TextAlign.center, style: TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize:  11.sp )),
                                    Text('2',textAlign:TextAlign.center, textScaleFactor: 1.0, style: TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w400,
                                fontSize:  12.sp )),
                                  ],
                                ),

                              ),
                              SizedBox(width: 10.w,),
                              Container(
                                width:  80.w,
                                padding: EdgeInsets.all(6.w),
                                 decoration: BoxDecoration(
                                  color: kblueSky.withOpacity(0.6),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Personnel inscrit', textScaleFactor: 1.0, textAlign: TextAlign.center, style: TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize:  11.sp )),
                                    Text('2', textAlign: TextAlign.center, textScaleFactor: 1.0,style: TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w400,
                                fontSize:  12.sp )),
                                  ],
                                ),

                              )
                            ],
                          ),
                        ):SizedBox.shrink(),
                        
                      ],
                    ),
                  ),
                  SizedBox(height: hv*1),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left:15, top:5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Personne Contact',
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                      fontSize: 14.sp,
                                      color: kBlueForce,
                                      fontWeight: FontWeight.w600,
                                    ) ),
                              ),
                            ],),
                            
                            Row(children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                   HomePageComponents().getAvatar(
                            imgUrl: prestatiaireObject !=null ?  prestatiaireObject.avatarUrl : '',
                            size: wv * 8.3,
                            renoveIsConnectedButton: false),
                                ],
                              ),
                               Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text( prestatiaireObject!=null ? 'Dr '+prestatiaireObject.contactName: 'pas defini',
                                    textScaleFactor: 1.0,
                                   style: TextStyle(
                                    fontSize: 14.sp,
                                    color: kBlueForce,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  SizedBox(height: 4.h,),
                                  Text( prestatiaireObject!=null  &&  prestatiaireObject.contactFunction!=null  ? prestatiaireObject.contactFunction: 'non defini' ,
                                    textScaleFactor: 1.0,
                                   style: TextStyle(
                                    fontSize: 14.sp,
                                    color: prestatiaireObject==null  &&  prestatiaireObject.contactFunction==null  ? kShadowColor : kBlueDeep,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  SizedBox(height: 2.h,),  
                                ],
                              ),
                            ],),
                           
                           SizedBox(height: 5.h,),  
                            Row(
                              children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                           mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text('Adresse ', textScaleFactor: 1.0,  style: TextStyle(
                                  fontSize: 15.sp,
                                  color: kBlueForce,
                                  fontWeight: FontWeight.w600,
                                ) ),
                         
                          Text(prestatiaireObject!=null  &&  prestatiaireObject.localisation!=null  ?prestatiaireObject.localisation: 'localisation non defini '  ,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: kBlueForce,
                                  fontWeight: FontWeight.w500,
                                ) ),
                        ],),
                              ),
                            ],),
                        ],),
                      ],
                    ),
                  ),
                  SizedBox(height: hv*1),
                  Stack(
                    children: [
                      Container(
                        height: hv*25,
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: prestatiaireObject.localisation == null ? _center : LatLng(prestatiaireObject.localisation["latitude"], prestatiaireObject.localisation["longitude"]),
                            zoom: 11.0,
                          ),
                        ),
                      ),
                      Positioned(
                        right: wv*3,
                        top: hv*2,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(
                              color: Colors.grey[400],
                              spreadRadius: 1,
                              blurRadius: 1.5,
                              offset: Offset(0, 2)
                            )]
                          ),
                          child: CircleAvatar(
                            radius: wv*8,
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(top: inch*1),
                              child: SvgPicture.asset("assets/icons/Bulk/MapLocal.svg"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget getFeatureCard({String title, bool isActifService=false}){
    return Container(
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isActifService? Colors.transparent :  whiteColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(title, textScaleFactor: 1.0, style: TextStyle(color:kPrimaryColor, fontWeight: FontWeight.w500, fontSize: 12.sp)),
    );
  }
}