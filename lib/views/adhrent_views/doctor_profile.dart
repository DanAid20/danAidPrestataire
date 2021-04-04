import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

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
  

  @override
  Widget build(BuildContext context) {
    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    DoctorModelProvider doctor = Provider.of<DoctorModelProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: whiteColor,), onPressed: ()=>Navigator.pop(context)),
        actions: [
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg'), onPressed: (){},)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                      color: kPrimaryColor,
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
                                  backgroundColor: Colors.grey,
                                  backgroundImage: doctor.getDoctor.avatarUrl == null ? AssetImage("assets/images/avatar-profile.jpg",) : CachedNetworkImageProvider(doctor.getDoctor.avatarUrl) ,
                                  radius: 35,
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
                            child: adherentModelProvider.getAdherent.familyDoctorId == null ? TextButton(
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
                            ,
                          )
                        ],
                      ),

                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: Text("Services Offerts", style: TextStyle(color: whiteColor, fontSize: 15),),
                              ),
                              subtitle: Row(
                                children: [
                                  SvgPicture.asset("assets/icons/Bulk/Video.svg", width: 20),
                                  SizedBox(width: 10,),
                                  SvgPicture.asset("assets/icons/Bulk/Chat.svg", width: 20),
                                  SizedBox(width: 10,),
                                  SvgPicture.asset("assets/icons/Bulk/Calling.svg", width: 20, color: whiteColor),
                                  SizedBox(width: 10,),
                                  SvgPicture.asset("assets/icons/Bulk/Home.svg", width: 20, color: whiteColor.withOpacity(0.7),),
                                  SizedBox(width: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SvgPicture.asset("assets/icons/Bulk/Calendar.svg", width: 25, color: whiteColor),
                                  ),
                                  SizedBox(width: 10,),
                                  SvgPicture.asset("assets/icons/Bulk/Profile.svg", width: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                    ],),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kSouthSeas,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                    ),
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
                                getFeatureCard(title: "Rendez-vous"),
                              ],
                            ),
                            SizedBox(height: hv*1),
                          ],
                        ),
                  )
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
                        icon: SvgPicture.asset("assets/icons/Bulk/Chat.svg"),
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
                      SizedBox(height: 7,),
                      Row(
                        children: [
                          SizedBox(width: wv*2,),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Horaire", style: TextStyle(fontWeight: FontWeight.w800)),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text("Lundi à Vendredi")),
                                      Text("08H00 - 16H00"),
                                    ]
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Samedi"),
                                      Text("08H00 - 16H00"),
                                    ]
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Dimanche"),
                                      Text("08H00 - 16H00"),
                                    ]
                                  ),
                                ),

                                SizedBox(height: 10,),

                                Text("Adresse", style: TextStyle(fontWeight: FontWeight.w800)),
                                Text(doctor.getDoctor.address == null ? "Cameroon" :"${doctor.getDoctor.address}, Cameroun")
                              ],
                            ),
                          ),
                          SizedBox(width: wv*2,),
                          Container(
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
                          ),
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