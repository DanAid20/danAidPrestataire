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

class DoctorProfilePage extends StatefulWidget {
  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  
  GoogleMapController mapCardController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  bool isExpanded = false;
  void _onMapCreated(GoogleMapController controller) {
    mapCardController = controller;
  }
  bool confirmSpinner = false;
  Map availability = {
    "monday to friday": {
      "available": true,
      "start": DateTime(2000, 1, 1, 8, 0),
      "end": DateTime(2000, 1, 1, 16, 0)
    },
    "saturday": {
      "available": false,
      "start": DateTime(2000, 1, 1, 8, 0),
      "end": DateTime(2000, 1, 1, 16, 0)
    },
    "sunday": {
      "available": false,
      "start": DateTime(2000, 1, 1, 8, 0),
      "end": DateTime(2000, 1, 1, 16, 0)
    },
  };

  initAvailability(){
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    if(doctorProvider.getDoctor.availability != null){
      Map avail = doctorProvider.getDoctor.availability;
      if(avail["monday to friday"]["start"] is Timestamp){
        setState(() {
          availability = {
              "monday to friday": {
                "available": avail["monday to friday"]["available"],
                "start": DateTime(2000, 1, 1, avail["monday to friday"]["start"].toDate().hour, avail["monday to friday"]["start"].toDate().minute),
                "end": DateTime(2000, 1, 1, avail["monday to friday"]["end"].toDate().hour, avail["monday to friday"]["end"].toDate().minute)
              },
              "saturday": {
                "available": avail["saturday"]["available"],
                "start": DateTime(2000, 1, 1, avail["saturday"]["start"].toDate().hour, avail["saturday"]["start"].toDate().minute),
                "end": DateTime(2000, 1, 1, avail["saturday"]["end"].toDate().hour, avail["saturday"]["end"].toDate().minute)
              },
              "sunday": {
                "available": avail["sunday"]["available"],
                "start": DateTime(2000, 1, 1, avail["sunday"]["start"].toDate().hour, avail["sunday"]["start"].toDate().minute),
                "end": DateTime(2000, 1, 1, avail["sunday"]["end"].toDate().hour, avail["sunday"]["end"].toDate().minute)
              },
            };
        });
      } else {
        setState(() {
          availability = {
            "monday to friday": {
              "available": avail["monday to friday"]["available"],
              "start": DateTime(2000, 1, 1, avail["monday to friday"]["start"].hour, avail["monday to friday"]["start"].minute),
              "end": DateTime(2000, 1, 1, avail["monday to friday"]["end"].hour, avail["monday to friday"]["end"].minute)
            },
            "saturday": {
              "available": avail["saturday"]["available"],
              "start": DateTime(2000, 1, 1, avail["saturday"]["start"].hour, avail["saturday"]["start"].minute),
              "end": DateTime(2000, 1, 1, avail["saturday"]["end"].hour, avail["saturday"]["end"].minute)
            },
            "sunday": {
              "available": avail["sunday"]["available"],
              "start": DateTime(2000, 1, 1, avail["sunday"]["start"].hour, avail["sunday"]["start"].minute),
              "end": DateTime(2000, 1, 1, avail["sunday"]["end"].hour, avail["sunday"]["end"].minute)
            },
          };
        });
      }
    }
  }

  @override
  void initState() {
    initAvailability();
    // TODO: implement initState
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    bool isPrestataire=userProvider.getProfileType== serviceProvider ? true : false;

    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context);
    DoctorModelProvider doctor = Provider.of<DoctorModelProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        (adherentModelProvider.getAdherent != null) ? (adherentModelProvider.getAdherent.adherentId == userProvider.getUserId) ? Navigator.pop(context) : controller.setIndex(1) : controller.setIndex(1);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isPrestataire? kGold:kPrimaryColor,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: whiteColor,), onPressed: ()=> (adherentModelProvider.getAdherent != null) ? (adherentModelProvider.getAdherent.adherentId == userProvider.getUserId) ? Navigator.pop(context) : controller.setIndex(1) : controller.setIndex(1),),
          actions: [
            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg'), onPressed: (){},)
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              isPrestataire?   
               Container(
                 height: 200.h ,width: 1.5.sw,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/image 25.png"),
            fit: BoxFit.cover,
          ),
           boxShadow: [
                BoxShadow(color: kThirdColor, spreadRadius: 2.5, blurRadius: 4),
              ],
          borderRadius: BorderRadius.only(
               bottomLeft: Radius.circular(10),
               bottomRight: Radius.circular(10),
              ),
        ),
        child: Column(
           mainAxisAlignment: MainAxisAlignment.end, 
          children: [
            Column(
              
  children: <Widget>[

    Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 120.h,
          decoration: BoxDecoration(
              
              color: kGold.withOpacity(0.6), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), 
              )),
           child: Container(
                  padding: EdgeInsets.only(
                      left: 10.w, right: wv * 1.5, top:10),
                  child: Text(
                   'Ajouter un Patient',
                    style: TextStyle(
                        color: kCardTextColor,
                        fontWeight: FontWeight.w800,
                        fontSize:  17.sp),
                  ),
                ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: ScreenUtil().screenWidth ,
              height: 70,
              color: Colors.white.withOpacity(0.5),
              child: Column(
                            children: [
                              
                              SizedBox(height: hv*1),
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   getFeatureCard(title: "Consultations"),
                                   getFeatureCard(title: "Télé-Consultations"),
                                  getFeatureCard(title: "Visite à domicile"),
                                ],
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  getFeatureCard(title: "Chat"),
                                   getFeatureCard(title: "Rendez-vous") ,
                                ],
                              ),
                             
                            ],
                          ),
            ),
          ),
        )
      ],
    ),
  ],
),
             
          ],
        ) /* add child content here */,
      ):
              Container(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [BoxShadow(
                    color: Colors.grey[300],
                    spreadRadius: 1.5,
                    blurRadius: 3,
                    offset: Offset(0, 2)
                  )]
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:  isPrestataire? kGold: kPrimaryColor,
                      ),
                      child: Column(children: [
                        //SizedBox(height: hv*10,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: wv*2),
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
                                    //backgroundColor: Colors.grey,
                                    backgroundImage: doctor.getDoctor.avatarUrl == null ? AssetImage("assets/images/avatar-profile.jpg",) : CachedNetworkImageProvider(doctor.getDoctor.avatarUrl) ,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        height: wv*16,
                                        width: wv*16,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          child: Center(child: Icon(LineIcons.user, color: Colors.white, size: wv*25,)), //CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),
                                          padding: EdgeInsets.all(20.0),
                                        ),
                                        imageUrl: doctor.getDoctor.avatarUrl,),
                                    ),
                                    radius: wv*8,
                                ),
                              ),
                              SizedBox(width: 8,),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Dr. ${doctor.getDoctor.cniName}", style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w600),),
                                    Text("Medecin de Famille, ${doctor.getDoctor.field}", style: TextStyle(color: whiteColor.withOpacity(0.6), fontSize: 14),),
                                    SizedBox(height: hv*1.3,),
                                    Text(doctor.getDoctor.officeName, style: TextStyle(color: whiteColor, fontSize: 15, fontWeight: FontWeight.w600),),
                                    Text("Service - ${doctor.getDoctor.speciality}", style: TextStyle(color: whiteColor.withOpacity(0.6), fontSize: 14),),

                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: hv*3),
                              height: 3,
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

                            Positioned(
                              right: wv*3,
                              bottom: -hv*0,
                              child: userProvider.getProfileType != profile.doctor ? adherentModelProvider.getAdherent.familyDoctorId == null ? 
                                TextButton(
                                  onPressed: () => _chooseDoctor(doctor.getDoctor), 
                                  child: Text("Mon médecin", style: TextStyle(color: kPrimaryColor),),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: wv*3)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                    backgroundColor: MaterialStateProperty.all(whiteColor),
                                    shadowColor: MaterialStateProperty.all(Colors.grey),
                                    elevation: MaterialStateProperty.all(10)
                                  ),
                                ) :
                              CircleAvatar(
                                radius: wv*7,
                                backgroundColor: Colors.white,
                                child: Icon(LineIcons.stethoscope, size: wv*8, color: kSouthSeas, ),
                              ) 
                              :
                              TextButton(
                                onPressed: () {Navigator.pushNamed(context, '/doctor-profile-edit');}, 
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/Bulk/Edit.svg', width: 20, color: kPrimaryColor,),
                                    SizedBox(width: 2,),
                                    Text("Modifier", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w900),),
                                  ],
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: wv*3)),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                  backgroundColor: MaterialStateProperty.all(whiteColor),
                                  shadowColor: MaterialStateProperty.all(Colors.grey),
                                  elevation: MaterialStateProperty.all(10)
                                ),
                              )
                              ,
                            )
                          ],
                        ),

                        doctor.getDoctor.serviceList != null ? Row(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Padding(
                                  padding: EdgeInsets.only(bottom: 5.0),
                                  child: Text("Services Offerts", style: TextStyle(color: whiteColor, fontSize: 15),),
                                ),
                                subtitle: Row(
                                  children: [
                                    SvgPicture.asset("assets/icons/Bulk/Video.svg", width: 20, color: doctor.getDoctor.serviceList["tele-consultation"] ? kSouthSeas : whiteColor),
                                    SizedBox(width: 10,),
                                    SvgPicture.asset("assets/icons/Bulk/Chat.svg", width: 20, color: doctor.getDoctor.serviceList["chat"] ? kSouthSeas : whiteColor),
                                    SizedBox(width: 10,),
                                    SvgPicture.asset("assets/icons/Bulk/Calling.svg", width: 20, color: doctor.getDoctor.serviceList["consultation"] ? kSouthSeas : whiteColor),
                                    SizedBox(width: 10,),
                                    SvgPicture.asset("assets/icons/Bulk/Home.svg", width: 20, color: doctor.getDoctor.serviceList["visite-a-domicile"] ? kSouthSeas : whiteColor,),
                                    SizedBox(width: 10,),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SvgPicture.asset("assets/icons/Bulk/Calendar.svg", width: 25, color: doctor.getDoctor.serviceList["rdv"] ? kSouthSeas : whiteColor),
                                    ),
                                    //SizedBox(width: 10,),
                                    //SvgPicture.asset("assets/icons/Bulk/Profile.svg", width: 20, color: doctor.getDoctor.serviceList["consultation"] ? kDeepTeal : whiteColor),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ): Container(),
                        SizedBox(height: 5,),
                      ],),
                    ),
                    doctor.getDoctor.serviceList != null ? Container(
                      decoration: BoxDecoration(
                        color: isPrestataire? kGold: kSouthSeas,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                      ),
                      child: Column(
                            children: [
                              SizedBox(height: hv*1),
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  doctor.getDoctor.serviceList["consultation"] ? getFeatureCard(title: "Consultations") : Container(),
                                  doctor.getDoctor.serviceList["tele-consultation"] ? getFeatureCard(title: "Télé-Consultations") : Container(),
                                  doctor.getDoctor.serviceList["visite-a-domicile"] ? getFeatureCard(title: "Visite à domicile") : Container(),
                                ],
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  doctor.getDoctor.serviceList["chat"] ? getFeatureCard(title: "Chat") : Container(),
                                  doctor.getDoctor.serviceList["rdv"] ? getFeatureCard(title: "Rendez-vous") : Container(),
                                ],
                              ),
                              SizedBox(height: hv*1),
                            ],
                          ),
                    ) : Container()
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height:hv*2),
                  SizedBox(height: 30,
                    child: Row(
                      children: [
                        SizedBox(width: 5,),
                        TextButton.icon(
                          onPressed: (){},
                          icon: SvgPicture.asset("assets/icons/Bulk/Chat.svg", color: whiteColor),
                          label: Text("Ecrire", style: TextStyle(color: whiteColor),),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                            padding: MaterialStateProperty.all(EdgeInsets.only(right: 10, left: 8)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                          ),
                        ),

                        SizedBox(width: 10,),

                        TextButton.icon(
                          onPressed: (){},
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: SvgPicture.asset("assets/icons/Bulk/Calendar.svg", color: kPrimaryColor,),
                          ),
                          label: Text("Prendre Rendez-vous", style: TextStyle(color: kPrimaryColor),),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(whiteColor),
                            padding: MaterialStateProperty.all(EdgeInsets.only(right: 10, left: 8)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                            elevation: MaterialStateProperty.all(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  DefaultTextStyle(
                    style: TextStyle(color: kPrimaryColor),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("  A propos", style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 3,),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(doctor.getDoctor.about == null ? "R.A.S" : doctor.getDoctor.about),
                        ),
                        SizedBox(height: 10.h,),
                        isPrestataire? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                height: 60,
                                width:  80.w,
                                padding: EdgeInsets.all(6.w),
                                 decoration: BoxDecoration(
                                  color: kblueSky,
                                  boxShadow: [
                                    BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text('Medecin de famille', textAlign: TextAlign.center, style: TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize:  14.sp )),
                                    Text('2',textAlign:TextAlign.center, style: TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w400,
                                fontSize:  15.sp )),
                                  ],
                                ),

                              ),
                              SizedBox(width: 10.w,),
                              Container(
                                height: 60,
                                width:  80.w,
                                padding: EdgeInsets.all(6.w),
                                 decoration: BoxDecoration(
                                  color: kblueSky,
                                  boxShadow: [
                                    BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text('Personnel inscrit', textAlign: TextAlign.center, style: TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize:  14.sp )),
                                    Text('2', textAlign: TextAlign.center, style: TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w400,
                                fontSize:  15.sp )),
                                  ],
                                ),

                              )
                            ],
                          ),
                        ):SizedBox.shrink(),
                        Row(
                          children: [
                            SizedBox(width: wv*2,),
                            doctor.getDoctor.availability != null ? Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Horaire", style: TextStyle(fontWeight: FontWeight.w800)),
                                  doctor.getDoctor.availability["monday to friday"]["available"] ? Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text("Lundi à Vendredi")),
                                        Text("${availability["monday to friday"]["start"].hour.toString().padLeft(2, '0')}H${availability["monday to friday"]["start"].minute.toString().padLeft(2, '0')} - ${availability["monday to friday"]["end"].hour.toString().padLeft(2, '0')}H${availability["monday to friday"]["end"].minute.toString().padLeft(2, '0')}"),
                                      ]
                                    ),
                                  ) : Container(),
                                  doctor.getDoctor.availability["saturday"]["available"] ? Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Samedi"),
                                        Text("${availability["saturday"]["start"].hour.toString().padLeft(2, '0')}H${availability["saturday"]["start"].minute.toString().padLeft(2, '0')} - ${availability["saturday"]["end"].hour.toString().padLeft(2, '0')}H${availability["saturday"]["end"].minute.toString().padLeft(2, '0')}"),
                                      ]
                                    ),
                                  ) : Container(),
                                  doctor.getDoctor.availability["sunday"]["available"] ? Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Dimanche"),
                                        Text("${availability["sunday"]["start"].hour.toString().padLeft(2, '0')}H${availability["sunday"]["start"].minute.toString().padLeft(2, '0')} - ${availability["sunday"]["end"].hour.toString().padLeft(2, '0')}H${availability["sunday"]["end"].minute.toString().padLeft(2, '0')}"),
                                      ]
                                    ),
                                  ) : Container(),

                                  SizedBox(height: 10,),

                                  Text("Adresse", style: TextStyle(fontWeight: FontWeight.w800)),
                                  Text(doctor.getDoctor.address == null ? "Cameroon" :"${doctor.getDoctor.address}, Cameroun")
                                ],
                              ),
                            )  :  Container(),
                            SizedBox(width: wv*2,),
                            doctor.getDoctor.rate != null ? Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kSouthSeas.withOpacity(0.7),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Tarif publique", style: TextStyle(fontWeight: FontWeight.w800)),
                                  Text("${doctor.getDoctor.rate["public"]} f."),
                                  SizedBox(height: 10,),
                                  Text("Tarif DanAid", style: TextStyle(color: Colors.teal[400], fontWeight: FontWeight.w800)),
                                  Row(
                                    children: [
                                      Text("Adhérents"),
                                      SizedBox(width: 5,),
                                      Text("${doctor.getDoctor.rate["adherent"]} f."),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Autres"),
                                      SizedBox(width: 5,),
                                      Text("${doctor.getDoctor.rate["other"]} f."),
                                    ],
                                  ),
                                  SizedBox(height: 20,)
                                ]
                              ),
                            ) : Container(),
                            SizedBox(width: 10,)
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: hv*2,),
                  Stack(
                    children: [
                      Container(
                        height: hv*25,
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: doctor.getDoctor.location == null ? _center : LatLng(doctor.getDoctor.location["latitude"], doctor.getDoctor.location["longitude"]),
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
  _chooseDoctor (DoctorModel doctor){
        print("Heeey");
    showDialog(context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: wv*5,),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(children: [
                  SizedBox(height: hv*4),
                  RichText(text: TextSpan(text: "Voulez vous choisir le ", children: [TextSpan(text: "Dr. "+doctor.cniName, style: TextStyle(fontWeight: FontWeight.w700)), TextSpan(text: " comme medecin de Famille ?")], style: TextStyle(color: kPrimaryColor, fontSize: wv*4.5),), textAlign: TextAlign.center,),
                  SizedBox(height: hv*2,),
                  Text("NB: Après confirmation, Vous ne pourrez plus modifier ce paramètre par vous même", style: TextStyle(color: Colors.grey[600], fontSize: wv*4), textAlign: TextAlign.center),
                  Row(children: [
                    Expanded(
                      child: !confirmSpinner ? CustomTextButton(
                        expand: false,
                        text: "Confirmer",
                        color: kPrimaryColor,
                        action: confirmDoctor,
                      ) : 
                      Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),)),
                    ),
                    Expanded(
                      child: CustomTextButton(
                        expand: false,
                        text: "Annuler",
                        color: kSouthSeas,
                        action: () => Navigator.pop(context),
                      ),
                    )
                  ], mainAxisSize: MainAxisSize.max,)
                  
                ], mainAxisAlignment: MainAxisAlignment.center, ),
              ),
            ],
          ),
        );
      }
    );
  }
  confirmDoctor(){
    setState(() {
      confirmSpinner = true;
    });
    DoctorModelProvider doctor = Provider.of<DoctorModelProvider>(context, listen: false);
    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    FirebaseFirestore.instance.collection("ADHERENTS")
      .doc(adherentModelProvider.getAdherent.adherentId)
      .set({
        "familyDoctorId": doctor.getDoctor.id,
      }, SetOptions(merge: true)).then((value) {
        setState(() {
          confirmSpinner = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Le Dr "+doctor.getDoctor.cniName+" a été ajouté(e) comme médecin de famille..")));
        controller.setIndex(1);
        adherentModelProvider.setFamilyDoctorId(doctor.getDoctor.id);
        adherentModelProvider.setFamilyDoctor(doctor.getDoctor);
        Navigator.pushReplacementNamed(context, '/home');
        
      }).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          confirmSpinner = false;
        });
      });
  }

  Widget getFeatureCard({String title}){
    return Container(
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(title, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500, fontSize: 13)),
    );
  }
}