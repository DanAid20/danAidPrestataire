import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MyDoctorTabView extends StatefulWidget {
  @override
  _MyDoctorTabViewState createState() => _MyDoctorTabViewState();
}

class _MyDoctorTabViewState extends State<MyDoctorTabView> {

  String text = "Le médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\n\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.";
  GoogleMapController mapCardController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapCardController = controller;
  }
  bool isExpanded = false;

  loadDoctor(){
    AdherentModelProvider adherent = Provider.of<AdherentModelProvider>(context, listen: false);
    if(adherent.getAdherent.familyDoctorId != null){
      if(adherent.getAdherent.familyDoctor != null){
        //
      } else {
        FirebaseFirestore.instance.collection("MEDECINS").doc(adherent.getAdherent.familyDoctorId).get()
          .then((doc) {
            DoctorModel myDoctor = DoctorModel.fromDocument(doc);
            adherent.setFamilyDoctor(myDoctor);
          })
        ;
      }
    }
    else {
      //
    }
  }

  @override
  void initState() {
    loadDoctor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    AdherentModelProvider adherent = Provider.of<AdherentModelProvider>(context, listen: false);
    //DoctorModel doctor = adherent.getAdherent.familyDoctor;
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          Expanded(
            child: adherent.getAdherent.familyDoctorId != null ? ListView(children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("MEDECINS").doc(adherent.getAdherent.familyDoctorId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),);
                  }
                  DoctorModel doctor = DoctorModel.fromDocument(snapshot.data);
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*3),
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
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
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
                                    child: GestureDetector(
                                      onTap: (){
                                        doctorProvider.setDoctorModel(doctor);
                                        Navigator.pushNamed(context, "/doctor-profile");
                                      },
                                      child: CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: doctor.avatarUrl != null ? CachedNetworkImageProvider(doctor.avatarUrl) :AssetImage("assets/images/avatar-profile.jpg",),
                                          radius: 35,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8,),
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                              doctorProvider.setDoctorModel(doctor);
                                              Navigator.pushNamed(context, "/doctor-profile");
                                            },
                                          child: Text(doctor == null ? "Nom" : "Dr. "+doctor.cniName, style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w600),)),
                                        Text("Medecin de Famille, "+ doctor.field, style: TextStyle(color: whiteColor.withOpacity(0.6), fontSize: 14),),
                                        SizedBox(height: hv*1.3,),
                                        Text(doctor.officeName == null ? "A SON COMPTE" : doctor.officeName, style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600, fontSize: 16),),
                                        Text("Service - ${doctor.speciality.toString()}", style: TextStyle(color: whiteColor.withOpacity(0.6), fontSize: 14),),

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),

                            SizedBox(height: 5,),

                            Container(
                              height: 5,
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

                            SizedBox(height: 5,),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 5.0),
                                      child: Text("Services Offerts", style: TextStyle(color: whiteColor, fontSize: 15),),
                                    ),
                                    subtitle: doctor.serviceList != null ? Row(
                                      children: [
                                        SvgPicture.asset("assets/icons/Bulk/Video.svg", width: 20, color: doctor.serviceList["tele-consultation"] ? whiteColor : kSouthSeas,),
                                        SizedBox(width: 10,),
                                        SvgPicture.asset("assets/icons/Bulk/Chat.svg", width: 20, color: doctor.serviceList["chat"] ? whiteColor : kSouthSeas,),
                                        SizedBox(width: 10,),
                                        SvgPicture.asset("assets/icons/Bulk/Calling.svg", width: 20, color: doctor.serviceList["consultation"] ? whiteColor : kSouthSeas),
                                        SizedBox(width: 10,),
                                        SvgPicture.asset("assets/icons/Bulk/Home.svg", width: 20, color: doctor.serviceList["visite-a-domicile"] ? whiteColor : kSouthSeas,),
                                        SizedBox(width: 10,),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: SvgPicture.asset("assets/icons/Bulk/Calendar.svg", width: 25, color: doctor.serviceList["rdv"] ? whiteColor : kSouthSeas),
                                        ),
                                        SizedBox(width: 10,),
                                        SvgPicture.asset("assets/icons/Bulk/Profile.svg", width: 20, color: doctor.serviceList["visite-a-domicile"] ? whiteColor : kSouthSeas),
                                      ],
                                    ) : Text("Non-Spécifié", style: TextStyle(color: Colors.white),),
                                  ),
                                ),
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
                                    radius: wv*8,
                                    backgroundColor: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: inch*1),
                                      child: SvgPicture.asset("assets/icons/Bulk/MapLocal.svg"),
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
                          child: ListTileTheme( 
                            dense: true,
                            child: Theme(
                              data: ThemeData.light().copyWith(
                                accentColor: whiteColor, 
                                primaryColor: whiteColor,
                                iconTheme: IconThemeData(color: whiteColor, size: 40),
                                unselectedWidgetColor: whiteColor
                                ),
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.only(right: 15, left: 3),
                                onExpansionChanged: (val){
                                  setState(() {
                                    isExpanded = val;
                                  });
                                },
                                title: !isExpanded ? Align(child: Text("Plus de détails", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 16)), alignment: Alignment.centerRight,) 
                                : Column(
                                    children: [
                                      Row(
                                        children: [
                                          doctor.serviceList["consultation"] ? getFeatureCard(title: "Consultations") : Container(),
                                          doctor.serviceList["tele-consultation"] ? getFeatureCard(title: "Télé-Consultations") : Container(),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          doctor.serviceList["chat"] ? getFeatureCard(title: "Chat") : Container(),
                                          doctor.serviceList["rdv"] ? getFeatureCard(title: "Rendez-vous") : Container(),
                                          doctor.serviceList["visite-a-domicile"] ? getFeatureCard(title: "Visite à domicile") : Container(),
                                        ],
                                      )
                                    ],
                                  ),
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height:5),
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
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      DefaultTextStyle(
                                        style: TextStyle(color: kPrimaryColor),
                                        child: Row(
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
                                                  Text(doctor.address == null ? "Cameroon" :"${doctor.address}, Cameroun")
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: wv*2,),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: whiteColor.withOpacity(0.7),
                                                borderRadius: BorderRadius.all(Radius.circular(20))
                                              ),
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text("Tarif publique", style: TextStyle(fontWeight: FontWeight.w800)),
                                                  Text("${doctor.rate["public"]} f."),
                                                  SizedBox(height: 10,),
                                                  Text("Tarif DanAid", style: TextStyle(color: Colors.teal[400], fontWeight: FontWeight.w800)),
                                                  Row(
                                                    children: [
                                                      Text("Adhérents"),
                                                      SizedBox(width: 5,),
                                                      Text("${doctor.rate["adherent"]} f."),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Autres"),
                                                      SizedBox(width: 5,),
                                                      Text("${doctor.rate["other"]} f."),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20,)
                                                ]
                                              ),
                                            ),
                                            SizedBox(width: 10,)
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15,),
                                      Container(
                                        height: hv*10,
                                        child: GoogleMap(
                                          onMapCreated: _onMapCreated,
                                          initialCameraPosition: CameraPosition(
                                            target: doctor.location == null ? _center : LatLng(doctor.location["latitude"], doctor.location["longitude"]),
                                            zoom: 11.0,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              ),

              Divider(),

              Container(
                margin: EdgeInsets.only(left: 15),
                child: Text("Mes Rendez-vous", style: TextStyle(color: Colors.teal[400], fontSize: 17),)
              ),
              Column(
                children: [
                  HomePageComponents().getMyDoctorAppointmentTile(
                    doctorName: "Dr. Jean Marie Nka, Médécin de Famille",
                    date: "Mercredi, 18 février 2021, 10:30",
                    state: 0,
                    type: "Consultation",
                    label: "Contrôle"
                  ),
                  HomePageComponents().getMyDoctorAppointmentTile(
                    doctorName: "Dr. Jean Marie Nka, Médécin de Famille",
                    date: "Lundi, 10 février 2021, 14:00",
                    state: 1,
                    type: "Télé-Consultation",
                    label: "Résultat d'examens"
                  ),
                  HomePageComponents().getMyDoctorAppointmentTile(
                    doctorName: "Dr. Jean Marie Nka, Médécin de Famille",
                    date: "Mercredi, 22 Janvier 2021, 08:00",
                    state: 2,
                    type: "Consultation",
                    label: "Résultat d'examens"
                  ),
                  HomePageComponents().getMyDoctorAppointmentTile(
                    doctorName: "Dr. Jean Marie Nka, Médécin de Famille",
                    date: "Mercredi, 10 février 2021, 10:30",
                    state: 3,
                    type: "Consultation",
                    label: "Fièvre et toux depuis"
                  ),

                  SizedBox(height: hv*7+20,),
                ],
              )
            ],)
            :
            Padding(
              padding: EdgeInsets.only(bottom: hv*10),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(blurRadius: 3, spreadRadius: 2, color: Colors.grey[300]), ]
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: wv*10),
                        decoration: BoxDecoration(
                          boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: -10, color: Colors.grey[50])]
                        ),
                        child: ListView(children: [
                          SizedBox(height: hv*3,),
                          RichText(text: TextSpan(text: "Choisissez Votre\n", children: [TextSpan(text: "Médecin de Famille", style: TextStyle(fontWeight: FontWeight.w800))], style: TextStyle(color: kPrimaryColor, fontSize: wv*5.5)), textAlign: TextAlign.center,),
                          SizedBox(height: hv*2),
                          SvgPicture.asset('assets/icons/Bulk/Danger.svg', width: wv*20,),
                          SizedBox(height: hv*2),
                          Text(text, style: TextStyle(color: kPrimaryColor, fontSize: wv*4), textAlign: TextAlign.center,),
                        ], physics: BouncingScrollPhysics(),),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: wv*3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                      ),
                      child: CustomTextButton(text: "Démarrer", action: (){controller.setIndex(3);},),
                    )
                  ],
                ),
              ),
            )
            ,
          ),
        ],
      ),
    );
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