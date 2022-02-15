import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/doctorTileModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderTileModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/adhrent_views/clinic_list.dart';
import 'package:danaid/views/adhrent_views/family_doctors_list_screen.dart';
import 'package:danaid/views/adhrent_views/lab_list.dart';
import 'package:danaid/views/adhrent_views/pharmacy_list.dart';
import 'package:danaid/views/adhrent_views/specialist_list.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/doctor_info_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:provider/provider.dart';

class PartnersScreen extends StatefulWidget {
  @override
  _PartnersScreenState createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  
  int contentIndex = 0;
  BuildContext? sheetContext;
  double minSheetHeight = 0.4;
  double maxSheetHeight = 1.0;
  double initialSheetHeight = 0.8;
  ScrollController _scrollController = new ScrollController();
  GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List markerIds = [];

  final LatLng _center = const LatLng(4.044656688777058, 9.695724531228858);
  LatLng? _userCoords;

  BitmapDescriptor getMarkerIcon({required String userType, String? prestataireType, required bool isSpecialist}){
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    BitmapDescriptor? descriptor;
    if (prestataireType == null){
      if(userType == adherent || userType == beneficiary){
        descriptor = BitmapDescriptor.defaultMarker;
      }
      else if(userType == doctor){
        if(isSpecialist){
          descriptor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
        }
        else {
          descriptor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
        }
      }
    }
    else {
      if(prestataireType == "Hôpital"){
        descriptor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
      } 
      else if(prestataireType == "Laboratoire"){
        descriptor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      }
      else if(prestataireType == "Pharmacie"){
        descriptor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      }
      else {
        descriptor = BitmapDescriptor.defaultMarker;
      }

    }
    return descriptor!;
  }

  void _addMarker(String id, String userType, double lat, double lng, String? spType, bool? isSpecialist, AdherentModel? adherent, DoctorModel? doctor, ServiceProviderModel? sp) async {
    var markerIdVal = id;
    final MarkerId markerId = MarkerId(markerIdVal);
    markerIds.add(markerId);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: markerIdVal, snippet: userType, onTap: (){_onMarkerTapped(markerId: markerId, userType: userType, doc: doctor, prestataire: sp);}),
      icon: getMarkerIcon(userType: userType, prestataireType: spType, isSpecialist: isSpecialist!),
      onTap: () {
        //_onMarkerTapped(markerId);
      },
    );

    //mapController.showMarkerInfoWindow(markerId);

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  _onMarkerTapped({required MarkerId markerId, required String userType, DoctorModel? doc, ServiceProviderModel? prestataire}){
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    ServiceProviderTileModelProvider spTileProvider = Provider.of<ServiceProviderTileModelProvider>(context, listen: false);
    DoctorTileModelProvider doctorTileProvider = Provider.of<DoctorTileModelProvider>(context, listen: false);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    showDialog(context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          backgroundColor: kPrimaryColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                ),
                child: doc != null ? DoctorInfoCard(
                  noPadding: true,
                  noShadow: true,
                  avatarUrl: doc.avatarUrl,
                  name: doc.cniName,
                  title: S.of(context).medecinDeFamille + doc.field!,
                  speciality: doc.speciality,
                  teleConsultation: doc.serviceList != null ? doc.serviceList["tele-consultation"] : false,
                  consultation: doc.serviceList != null ? doc.serviceList["consultation"] : false,
                  chat: doc.serviceList != null ? doc.serviceList["chat"] : false,
                  rdv: doc.serviceList != null ? doc.serviceList["rdv"] : false,
                  visiteDomicile: doc.serviceList != null ? doc.serviceList["visite-a-domicile"] : false,
                  field: doc.speciality,
                  officeName: doc.officeName,
                  includeHospital: true,
                  actionText: "Details..",
                  distance: (adherentProvider.getAdherent?.location != null && (userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary)) ?
                      adherentProvider.getAdherent?.location!["latitude"] != null && doc.location!["latitude"] != null ? (Algorithms.calculateDistance(adherentProvider.getAdherent?.location!["latitude"], adherentProvider.getAdherent?.location!["longitude"], doc.location!["latitude"], doc.location!["longitude"]).toStringAsFixed(2)).toString() : null
                    :(doctorProvider.getDoctor?.location != null && userProvider.getProfileType == doctor) ?
                      doctorProvider.getDoctor?.location!["latitude"] != null && doc.location!["latitude"] != null ? (Algorithms.calculateDistance(doctorProvider.getDoctor?.location!["latitude"], doctorProvider.getDoctor?.location!["longitude"], doc.location!["latitude"], doc.location!["longitude"]).toStringAsFixed(2)).toString() : null
                    : null,
                  onTap: () {
                    doctorTileProvider.setDoctorModel(doc);
                    Navigator.pushNamed(context, "/doctor-profile");
                  },
                ) 
                : prestataire != null ? 
                  DoctorInfoCard(
                    noPadding: true,
                    noShadow: true,
                    avatarUrl: prestataire.avatarUrl,
                    name: prestataire.contactName,
                    title: S.of(context).medecinDeFamille + prestataire.contactName!,
                    isServiceProvider: true,
                    speciality: prestataire.category,
                    teleConsultation: false,
                    consultation: false,
                    chat: false,
                    rdv: false,
                    visiteDomicile: false,
                    field: "",
                    officeName: "",
                    actionText: "Details..",
                    includeHospital: true,
                    distance: (adherentProvider.getAdherent?.location != null && (userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary)) ?
                        adherentProvider.getAdherent?.location!["latitude"] != null && prestataire.coordGps != null ? (Algorithms.calculateDistance( adherentProvider.getAdherent?.location!["latitude"], adherentProvider.getAdherent?.location!["longitude"], prestataire.coordGps!["latitude"], prestataire.coordGps!["longitude"]).toStringAsFixed(2)).toString() : null
                      :(doctorProvider.getDoctor?.location != null && userProvider.getProfileType == doctor) ?
                         doctorProvider.getDoctor?.location!["latitude"] != null && prestataire.coordGps != null ? (Algorithms.calculateDistance(doctorProvider.getDoctor?.location!["latitude"],  doctorProvider.getDoctor?.location!["longitude"], prestataire.coordGps!["latitude"], prestataire.coordGps!["longitude"]).toStringAsFixed(2)).toString() : null
                        : null,
                    onTap: () {
                      spTileProvider.setServiceProviderModel(prestataire);
                      Navigator.pushNamed(context, "/serviceprovider-profile");
                    },
                  )
                : Column(
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
                          Icon(LineIcons.mapMarker, color: kPrimaryColor, size: 45,),
                          SizedBox(height: hv*2,),
                          Text("Localisation", style: TextStyle(color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.w700),),
                          SizedBox(height: hv*2,),
                          Text("Ce marqueur indique votre position actuelle sur la carte, les autres marqueurs indiquent les positions des différents médecins et prestataires..", style: TextStyle(color: Colors.grey[600], fontSize: wv*4), textAlign: TextAlign.center),
                          SizedBox(height: hv*2),
                          CustomTextButton(
                            text: "OK",
                            color: kPrimaryColor,
                            action: ()=>Navigator.pop(context),
                          )
                          
                        ], mainAxisAlignment: MainAxisAlignment.center, ),
                      ),
                    ],
                  ),
              ),
            ],
          ),
        );
      }
    );
  }

  getUserGPSLocation(){
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    DoctorModelProvider doctorModelProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    ServiceProviderModelProvider serviceProviderM = Provider.of<ServiceProviderModelProvider>(context, listen: false);
    Map? coords;
    if (userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary){
      if(adherentModelProvider.getAdherent?.location != null){
        if(adherentModelProvider.getAdherent?.location!["latitude"] != null){
          coords = adherentModelProvider.getAdherent?.location;
          _addMarker("YOU", userProvider.getProfileType!, adherentModelProvider.getAdherent?.location!["latitude"], adherentModelProvider.getAdherent?.location!["longitude"], null, null, null, null, null);
        }
      }
    }
    else if (userProvider.getProfileType == doctor){
      if(doctorModelProvider.getDoctor?.location != null){
        if(doctorModelProvider.getDoctor?.location!["latitude"] != null){
          coords = doctorModelProvider.getDoctor?.location;
          _addMarker("YOU", userProvider.getProfileType!, doctorModelProvider.getDoctor!.location!["latitude"], doctorModelProvider.getDoctor!.location!["longitude"], null, doctorModelProvider.getDoctor!.field != "Généraliste", null, doctorModelProvider.getDoctor, null);
        }
      }
    }
    else if (userProvider.getProfileType == serviceProvider){
      if(serviceProviderM.getServiceProvider?.coordGps != null){
        if(serviceProviderM.getServiceProvider?.coordGps!["latitude"] != null){
          coords = serviceProviderM.getServiceProvider?.coordGps;
          _addMarker("YOU", userProvider.getProfileType!, serviceProviderM.getServiceProvider?.coordGps!["latitude"], serviceProviderM.getServiceProvider?.coordGps!["longitude"], serviceProviderM.getServiceProvider!.category, null,  null, null, serviceProviderM.getServiceProvider);
        }
      }
    }

    _userCoords = coords != null ? LatLng(coords['latitude'], coords['longitude']) : null;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {});
  }

  getAllGPSLocations(){
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    Future<QuerySnapshot> getDocs = userProvider.getProfileType != doctor ? FirebaseFirestore.instance.collection("MEDECINS").where("profilEnabled", isEqualTo: true).get() : FirebaseFirestore.instance.collection("MEDECINS").where("profilEnabled", isEqualTo: true).where("id", isNotEqualTo: userProvider.getUserId).get();
    Future<QuerySnapshot> getSPs= userProvider.getProfileType != serviceProvider ? FirebaseFirestore.instance.collection("PRESTATAIRE").where("profilEnabled", isEqualTo: true).get() : FirebaseFirestore.instance.collection("PRESTATAIRE").where("profilEnabled", isEqualTo: true).where(FieldPath.documentId, isNotEqualTo: userProvider.getUserId).get();
    getDocs.then((snap) {
      for(int i = 0; i < snap.docs.length; i++){
        DoctorModel doc = DoctorModel.fromDocument(snap.docs[i], snap.docs[i].data() as Map);
        if(doc.location != null){
          if(doc.location!["latitude"] != null){
            _addMarker("Dr. " + doc.cniName!, doctor, doc.location!["latitude"], doc.location!["longitude"], null, doc.field != "Généraliste", null, doc, null);
          }
        }
      }
    });
    getSPs.then((snap) {
      for(int i = 0; i < snap.docs.length; i++){
        ServiceProviderModel sp = ServiceProviderModel.fromDocument(snap.docs[i]);
        if(sp.coordGps != null){
          if(sp.coordGps!["latitude"] != null){
            _addMarker(sp.name!, serviceProvider, sp.coordGps!["latitude"], sp.coordGps!["longitude"], sp.category, null, null, null, sp);
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserGPSLocation();
    getAllGPSLocations();
  }

  @override
  Widget build(BuildContext context) {
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context);

    /*
    if(mapController != null){
      for(int i = 0; i < markerIds.length; i++){
        if(markerIds[i] != null){
          print(markerIds[i]);
          mapController.showMarkerInfoWindow(markerIds[i]);
        }
      }
    }
    */

    if(mapController != null){
      if(markerIds[0] != null){
        mapController!.showMarkerInfoWindow(markerIds[0]);
      }
    }
    
    
    return WillPopScope(
      onWillPop: () async {
        if(contentIndex == 0){
          controller.toPreviousIndex();
        }
        else{
          setState(() {
            contentIndex = 0;
          });
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBrownCanyon,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              SizedBox(
                width: wv*8,
                child: IconButton(icon: Icon(Icons.arrow_back_ios), 
                onPressed: (){
                  if(contentIndex == 0){
                    controller.toPreviousIndex();
                  }
                  else{
                    setState(() {
                      contentIndex = 0;
                    });
                  }
                }
                ),
              ),
              Text(S.of(context).trouverUnPrestataireDeSant, style: TextStyle(color: whiteColor),),
            ],
          ),
          actions: [
            Align(child: Text("", style: TextStyle(color: primaryColor),), alignment: Alignment.center,),
            Icon(MdiIcons.mapMarkerOutline, color: primaryColor,)
          ],
        ),
        body: Stack(children: [
          Container(
            child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _userCoords != null ? _userCoords! : _center,
              zoom: 8.0,
            ),
            markers: Set<Marker>.of(markers.values),
          ),
          ),
          DraggableScrollableActuator(
            child: DraggableScrollableSheet(
              initialChildSize:  initialSheetHeight, //contentIndex == 0 ? 0.4 : 1.0,
              minChildSize: minSheetHeight, //contentIndex == 0 ? 0.4 : 1.0,
              maxChildSize: maxSheetHeight, //contentIndex == 0 ? 0.9 : 1.0,
              builder: (BuildContext context, _scrollController){
                sheetContext = context;
                return ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.grey.shade200.withOpacity(0.5),
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        controller: _scrollController,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100.withOpacity(0.4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300]!,
                                  blurRadius: 2.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(0, 1)
                                )
                              ]
                            ),
                            child: Row(children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: GestureDetector(
                                  onTap: ()=>Navigator.pushNamed(context, '/partners-search'),
                                  child: TextField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                      fillColor: whiteColor.withOpacity(0.6),
                                      prefixIcon: Hero(tag: "search", child: Icon(Icons.search, color: kBrownCanyon,)),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1, color: kBrownCanyon.withOpacity(0.7)),
                                        borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1, color: kBrownCanyon.withOpacity(0.7)),
                                        borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      hintText: S.of(context).rechercher,
                                      hintStyle: TextStyle(color: kBrownCanyon)
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5,),
                              TextButton(onPressed: ()=>controller.toPreviousIndex(),
                                child: Text(S.of(context).annuler, style: TextStyle(color: kBrownCanyon),)
                              ),
                              //IconButton(icon: SvgPicture.asset("assets/icons/Bulk/Filter.svg"), onPressed: (){})

                            ],),
                          ),
                          //content
                          getSheetContent()
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ],),
      ),
    );
  }

  getSheetContent(){
    if(contentIndex == 0){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          SizedBox(height: hv*1,),
          SvgPicture.asset("assets/icons/Bulk/ArrowUp.svg"),
          Text(S.of(context).recherchezEnInscrivantDirectementLeNomDuPraticienOuDe, style: TextStyle(fontSize: 13), textAlign: TextAlign.center,),
          
          SizedBox(height: hv*4,),

          getDragSheetTiles(
            title: S.of(context).mdcinDeFamille,
            markerColor: kBrownCanyon,
            onTap: (){
              setState(() {
                contentIndex = 1;
                initialSheetHeight = 1.0;
                maxSheetHeight = 1.0;
                minSheetHeight = 1.0;
              });
              DraggableScrollableActuator.reset(context);
            }
          ),
          getDragSheetTiles(
            title: S.of(context).autresSpcialistes,
            markerColor: kPrimaryColor,
            onTap: (){
              setState(() {
                contentIndex = 2;
              });
            }
          ),
          getDragSheetTiles(
            title: S.of(context).hpitalOuClinique,
            markerColor: kSouthSeas,
            onTap: (){
              setState(() {
                contentIndex = 3;
              });
            }
          ),
          getDragSheetTiles(
            title: S.of(context).laboratoire,
            markerColor: primaryColor,
            onTap: (){
              setState(() {
                contentIndex = 4;
              });
            }
          ),
          getDragSheetTiles(
            title: S.of(context).pharmacie,
            markerColor: Colors.teal,
            onTap: (){
              setState(() {
                contentIndex = 5;
              });
            }
          )
        ],
        )
      );
    }
    else if (contentIndex == 1){
      return FamilyDoctorList();
    }
    else if (contentIndex == 2){
      return SpecialistList();
    }
    else if (contentIndex == 3){
      return ClinicList();
    }
    else if (contentIndex == 4){
      return LabList();
    }
    else if (contentIndex == 5){
      return PharmacyList();
    }
  }

  Widget getDragSheetTiles({required String title, required Color markerColor, Function? onTap}){
    return Padding(
      padding: EdgeInsets.only(right: 35.0, top: 3, bottom: 3, left: 20),
      child: Row(
        children: [
          SvgPicture.asset("assets/icons/Bulk/Location.svg", color: markerColor,),
          SizedBox(width: 10,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: kSmoothBrown.withOpacity(0.4),
              ),
              child: ListTile(
                onTap: ()=>onTap,
                dense: true,
                title: Text(title, style: TextStyle(color: kBlueForce, fontSize: inch*1.9, fontWeight: FontWeight.w600),),
                trailing: Icon(Icons.arrow_forward_ios_rounded, color: kBrownCanyon,)
              )
            ),
          )
        ],
      ),
    );
  }
}