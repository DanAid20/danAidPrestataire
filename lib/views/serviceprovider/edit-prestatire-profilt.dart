


import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/getCities.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/clippers.dart';
import 'package:danaid/widgets/doctor_service_choice_card.dart';
import 'package:danaid/widgets/file_upload_card.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
class EditPrestataire extends StatefulWidget {
  EditPrestataire({Key? key}) : super(key: key);

  @override
  _EditPrestataireState createState() => _EditPrestataireState();
}

class _EditPrestataireState extends State<EditPrestataire> {
  final GlobalKey<FormState> _presptataireEditFormKey = GlobalKey<FormState>();
  TextEditingController? _nameController = new TextEditingController();
  TextEditingController? _surnameController = new TextEditingController();
  TextEditingController? _specialityController = new TextEditingController();
  TextEditingController? _cniNameController = new TextEditingController();
  TextEditingController? _localisationController = new TextEditingController();
  TextEditingController? _companyController = new TextEditingController();
  TextEditingController? _contactNameController = new TextEditingController();
  TextEditingController? _contactEmailController = new TextEditingController();
   TextEditingController? _aboutController = new TextEditingController();
  ////////////////////////////
  String? _region;
  String? _city;
  String? _stateCode;
  String? _category="fdfdf";
  String? _localisation;
  String? avatarUrl;
  String? cniUpload;
  String? _type;
  ////////////////////////////////
  bool? nameEnabled = true;
  bool? contactEnabled= true;
  bool? contactEmail= true;
  bool? autovalidate = false;
  bool? localisation=false;
  //////////////////
   /** services  */
   bool? consultationChosen = false;
  bool? soinsAmbulances = false;
  bool? pharmacie = false;
  bool? labo = false;
  bool? hospitalisation = false;
  //////////////////
  bool? aboutEnabled = true;
  bool? regionChosen = false;
  bool? specialityEnabled = false;
  bool? cityChosen = false;
  File? imageFileAvatar;
  bool? imageLoading = false;
  bool? buttonLoading = false;
  bool? surnameEnabled = true;
  bool? emailEnabled = true;
  bool? cniNameEnabled = true;
  bool? cniUploaded = false;
  bool? otherFileUploaded = false;
  bool? cniSpinner = false;
  bool? ortherScanSpinner = false;
  bool? otherFileSpinner = false;
  bool? imageSpinner = false;
  bool? positionSpinner = false;
  LatLng? _initialcameraposition = const LatLng(4.044656688777058, 9.695724531228858);
  GoogleMapController? _controller;
  Location? _location = Location();
  Map<String, dynamic>? gpsCoords;
  void _initializeMap(){
    _location?.getLocation().then((loc) {
      setState(() {
        _initialcameraposition = LatLng(loc.latitude!, loc.longitude!);
      });
    });
  }

  void _saveLocation(){
    ServiceProviderModelProvider? servicetProvider = Provider.of<ServiceProviderModelProvider>(context, listen: false);
    setState(() {
      positionSpinner = true;
    });
    _location?.getLocation().then((loc) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(loc.latitude!, loc.longitude!),zoom: 11)),

      );
      setState(() {
        positionSpinner = false;
        _initialcameraposition = LatLng(loc.latitude!, loc.longitude!);
        gpsCoords = {
          "latitude": loc.latitude,
          "longitude": loc.longitude
        };
      });
      servicetProvider.setcoordGps(gpsCoords!);
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) async {
    _location!.getLocation().then((loc) {
      setState(() {
        _initialcameraposition = LatLng(loc.latitude!, loc.longitude!);
      });
    });
    setState(() {
      _controller = _cntlr;
    });
    /*_location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 18)),

    );});*/
    _location!.onLocationChanged.listen((loc) { 
        /*setState(() {
          _initialcameraposition = LatLng(loc.latitude, loc.longitude);
        });*/
      /*_controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 11.0),
          ),
         );*/
    });
  }

  initRegionDropdown(){
    ServiceProviderModelProvider servicetProvider = Provider.of<ServiceProviderModelProvider>(context, listen: false);
   
      setState(() {
        _stateCode = getStateCodeFromRegion(regions, servicetProvider.getServiceProvider!.region!);
        _region = servicetProvider.getServiceProvider!.region;
        regionChosen = true;
      cityChosen = true;
      
      _city = servicetProvider.getServiceProvider!.town;
      });
   
    
  }

  textFieldsControl (){

    ServiceProviderModelProvider serviceProvider = Provider.of<ServiceProviderModelProvider>(context, listen: false);
    if((serviceProvider.getServiceProvider!.about != null) & (serviceProvider.getServiceProvider!.about != "")){
      setState(() {
        _aboutController!.text = serviceProvider.getServiceProvider!.about!;
        aboutEnabled = false;
      });
    }
    if((serviceProvider.getServiceProvider!.name != null) & (serviceProvider.getServiceProvider!.name != "")){
      setState(() {
        _nameController!.text = serviceProvider.getServiceProvider!.name!;
        nameEnabled = false; 
      });
    }
    if((serviceProvider.getServiceProvider!.avatarUrl != null) & (serviceProvider.getServiceProvider!.avatarUrl != "")){
      setState(() {
        avatarUrl= serviceProvider.getServiceProvider!.avatarUrl;
       
      });
    }
    if((serviceProvider.getServiceProvider!.contactName != null) & (serviceProvider.getServiceProvider!.contactName  != "")){
      setState(() {
        _contactNameController!.text = serviceProvider.getServiceProvider!.contactName!;
        contactEnabled = false;
      });
    }
    if((serviceProvider.getServiceProvider!.contactEmail  != null) & (serviceProvider.getServiceProvider!.contactEmail  != "")){
      setState(() {
        _contactEmailController!.text = serviceProvider.getServiceProvider!.contactEmail! ;
        contactEmail = false;
      });
    }
    if((serviceProvider.getServiceProvider!.category  != null) & (serviceProvider.getServiceProvider!.category  != "")){
      setState(() {
       _category=serviceProvider.getServiceProvider!.category;
      });
    }
    if((serviceProvider.getServiceProvider!.localisation  != null) & (serviceProvider.getServiceProvider!.localisation != "")){
      setState(() {
        _localisationController!.text=serviceProvider.getServiceProvider!.localisation!;
        localisation=false;
      });
    }
    if((serviceProvider.getServiceProvider!.specialite  != null) & (serviceProvider.getServiceProvider!.specialite != "")){
      setState(() {
       _specialityController!.text =serviceProvider.getServiceProvider!.specialite!;
      });
    }
    if(( serviceProvider.getServiceProvider!.serviceList != "") & ( serviceProvider.getServiceProvider!.serviceList != null)){
     
      setState(() {
          consultationChosen = serviceProvider.getServiceProvider!.serviceList["Consultation"];
          soinsAmbulances = serviceProvider.getServiceProvider!.serviceList["SoinsAmbulances"];
          pharmacie  = serviceProvider.getServiceProvider!.serviceList["Pharmacie"];
          labo = serviceProvider.getServiceProvider!.serviceList["laboratoire"];
          hospitalisation = serviceProvider.getServiceProvider!.serviceList["Hospitalisation"];
      });
    }
    if (kDebugMode) {
      print("inside");
    }
    if (serviceProvider.getServiceProvider!.coordGps != null){
      //print(serviceProvider.getServiceProvider!.coordGps"inside+");
      if ((serviceProvider.getServiceProvider!.coordGps!["latitude"] != null) | (serviceProvider.getServiceProvider!.coordGps!["longitude"] != null) | true){
        setState(() {
          gpsCoords = {
          "latitude": serviceProvider.getServiceProvider!.coordGps!["latitude"],
          "longitude": serviceProvider.getServiceProvider!.coordGps!["longitude"]
        };
        if (kDebugMode) {
          print(gpsCoords.toString());
        }
        });
      }
    }

  }

  @override
  void initState() {
    _initializeMap();
    initRegionDropdown();
    textFieldsControl();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ServiceProviderModelProvider serviceProvider = Provider.of<ServiceProviderModelProvider>(context, listen: false);
    ServiceProviderModel prestataire= serviceProvider.getServiceProvider!;
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: hv*1, automaticallyImplyLeading: false, backgroundColor: kGold.withOpacity(0.99)),
        body:Column(
          children: [
            Expanded(
              child: ListView(
                 children: [
                    Stack(clipBehavior: Clip.none, children: [
                          ClipPath(
                            clipper: WaveClipperTop2(),
                            child: Container(
                              height: wv*42,
                              decoration: BoxDecoration(
                                color: Colors.grey[200]
                              ),
                            ),
                          ),
                          ClipPath(
                            clipper: WaveClipperTop(),
                            child: Container(
                              height: wv*42,
                              decoration: BoxDecoration(
                                color: kGold.withOpacity(0.6)
                              ),
                            ),
                          ),
                          Positioned(
                            top: hv*5,
                            child: Stack(children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                radius: wv*18,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    height: wv*36,
                                    width: wv*36,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      child: imageFileAvatar == null ? Center(child: Icon(LineIcons.user, color: Colors.white, size: wv*25,)) : Container(), //CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),
                                      padding: const EdgeInsets.all(20.0),
                                    ),
                                    imageUrl:prestataire.avatarUrl!,),
                                ),
                                  //backgroundImage: CachedNetworkImageProvider(adherentModelProvider.getAdherent.imgUrl),
                              ),

                              imageSpinner! ? Positioned(
                                top: hv*7,
                                right: wv*13,
                                child: const CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(whiteColor),)
                              ) : Container(),

                              Positioned(
                                bottom: 2,
                                right: 5,
                                child: CircleAvatar(
                                  backgroundColor: kDeepTeal,
                                  radius: wv*5,
                                  child: IconButton(icon: const Icon(Icons.add, color: whiteColor,), color: kPrimaryColor, onPressed: (){getImage(context);}),
                                ),
                              )
                            ],),
                          ),
                          Positioned(
                            top: hv*2,
                            left: wv*3,
                            child: GestureDetector(
                              onTap: (){Navigator.pop(context);},
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: wv*3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(Icons.arrow_back_ios_rounded),
                              ),
                            ),
                          )
                        ], alignment: AlignmentDirectional.topCenter,),
                          Form(
                    key: _presptataireEditFormKey,
                                        autovalidateMode: autovalidate! ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,

                    child: Column(children: [
                       SizedBox(height: hv*6,),
                     
                      CustomTextField(
                        prefixIcon: const Icon(MdiIcons.officeBuildingOutline, color: kDeepTeal),
                        label: S.of(context)!.nomDeLtablissement,
                        hintText: S.of(context)!.exHpialCentrale,
                        controller: _nameController!,
                        validator: (String? val) => (val!.isEmpty) ? S.of(context)!.ceChampEstObligatoire : null,
                      ),
                      SizedBox(height: hv*2.5,),
                      CustomTextField(
                        prefixIcon: const Icon(Icons.account_circle_outlined, color: kDeepTeal,),
                        label: S.of(context)!.nomCompletDuContact,
                        hintText: S.of(context)!.entrezVotreNom,
                        controller: _contactNameController!,
                        validator: (String? val) => (val!.isEmpty) ? S.of(context)!.ceChampEstObligatoire : null,
                      ),
                      SizedBox(height: hv*2.5,),
                      CustomTextField(
                        prefixIcon:const Icon(Icons.email_outlined, color: kDeepTeal,),
                        keyboardType: TextInputType.emailAddress,
                        label: S.of(context)!.emailDuContact,
                        hintText: S.of(context)!.entrezVotreAddresseEmail,
                        controller: _contactEmailController!,
                        validator: _emailFieldValidator,
                      ),
                      SizedBox(height: hv*2,),
                      CustomTextField(
                        prefixIcon: const  Icon(MdiIcons.cardAccountDetailsOutline, color: kPrimaryColor),
                        label: S.of(context)!.aPropos,
                        hintText: S.of(context)!.parlezBrivementDeVous,
                        enabled: aboutEnabled!,
                        multiLine: true,
                        controller: _aboutController!,
                        validator: (String? val) => (val!.isEmpty) ? S.of(context)!.ceChampEstObligatoire : null,
                        editAction: (){
                          setState(() {
                            aboutEnabled = true;
                          });
                        },
                      ),
                       Column(
                        children: [
                          SizedBox(height: hv*2,),
                          CustomTextField(
                            prefixIcon: const Icon(MdiIcons.accountTieOutline, color: kPrimaryColor),
                            label: S.of(context)!.votreFunction,
                            hintText: S.of(context)!.pharmaciene,
                            enabled: specialityEnabled!,
                            controller: _specialityController!,
                            validator: (String? val) => (val!.isEmpty) ? S.of(context)!.ceChampEstObligatoire : null,
                            editAction: (){
                              setState(() {
                                specialityEnabled = true;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: hv*2,),
                      SizedBox(height: hv*2.5,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: wv*3),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context)!.typeDtablissement, style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                            const SizedBox(height: 5,),
                            Container(
                              constraints: BoxConstraints(minWidth: wv*45),
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: const BorderRadius.all(Radius.circular(20))
                              ),
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: _category,
                                    items: [
                                      const DropdownMenuItem(
                                        child:  Text("Hôpital", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                        value: "Hôpital",
                                      ),
                                      DropdownMenuItem(
                                        child: Text(S.of(context)!.pharmacie, style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                        value: S.of(context)!.pharmacie,
                                      ),
                                      DropdownMenuItem(
                                        child: Text(S.of(context)!.laboratoire, style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                        value: S.of(context)!.laboratoire,
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _category = value.toString();
                                      });
                                    }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: hv*2.5,),
                      Row(
                        children: [
                          SizedBox(width: wv*3,),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(S.of(context)!.region, style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                                const SizedBox(height: 5,),
                                Container(
                                  constraints: BoxConstraints(minWidth: wv*45),
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: const BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: _stateCode,
                                        hint: Text(S.of(context)!.choisirUneRegion),
                                        items: regions.map((region){
                                          return DropdownMenuItem(
                                            child: SizedBox(child: Text(region["value"]!, style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)), width: wv*50,),
                                            value: region["key"],
                                          );
                                        }).toList(),
                                        onChanged: (value) async {
                                          //List<String> reg = getTownNamesFromRegion(cities, value);
                                          serviceProvider.setRegion(getRegionFromStateCode(regions, value.toString()));
                                          setState(() {
                                            _stateCode = value.toString();
                                            _region = getRegionFromStateCode(regions, value.toString());
                                            _city = null;
                                            cityChosen = false;
                                            //myCities = reg;
                                            regionChosen = true;
                                          });
                                        }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: wv*3,),
                          regionChosen! ? Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(S.of(context)!.choixDeLaVille, style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                                const SizedBox(height: 5,),
                                Container(
                                  constraints: BoxConstraints(minWidth: wv*45),
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: const BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: _city,
                                        hint: Text(S.of(context)!.ville),
                                        items: getTownNamesFromRegion(cities, _stateCode!).map((city){
                                          if (kDebugMode) {
                                            print("city: "+city);
                                          }
                                          return DropdownMenuItem(
                                            child: Text(city, style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                            value: city,
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          serviceProvider.setTown(value.toString());
                                          setState(() {
                                            _city = value.toString();
                                            cityChosen = true;
                                          });
                                        }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ) : Container(),
                          SizedBox(width: wv*3,), 
                        ],
                      ),
                      SizedBox(height: hv*2.5,),
                      CustomTextField(
                        prefixIcon: const Icon(Icons.location_pin, color: kDeepTeal,),
                        keyboardType: TextInputType.emailAddress,
                        label: S.of(context)!.preciserLemplacementDeLorganisation,
                        hintText: S.of(context)!.exfacePharmacieDuLac,
                        controller: _localisationController!,
                        validator: (String? val) => (val!.isEmpty) ? S.of(context)!.ceChampEstObligatoire : null
                      ),
                      SizedBox(height: hv*4,),
                      (gpsCoords != null) | (serviceProvider.getServiceProvider!.coordGps != null) ? Container(margin: EdgeInsets.symmetric(horizontal: wv*4),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("GPS:", style: const TextStyle(fontWeight: FontWeight.w900),),
                            RichText(text: TextSpan(
                              text: "Lat: ",
                              children: [
                                TextSpan(text: (gpsCoords != null) ? gpsCoords!["latitude"].toString() : serviceProvider.getServiceProvider!.coordGps!["latitude"], style: const TextStyle(fontWeight: FontWeight.w900, color: kPrimaryColor)),
                                TextSpan(text: "     Lng: "),
                                TextSpan(text: (gpsCoords != null) ? gpsCoords!["longitude"].toString() : serviceProvider.getServiceProvider!.coordGps!["longitude"], style: const TextStyle(fontWeight: FontWeight.w900, color: kPrimaryColor))
                              ]
                            , style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
                            )
                          ],
                        ),
                      )
                      : Container(),
                      SizedBox(height: hv*2.5,),
                      Stack(
                        children: [
                          Container(
                            height: hv*30,
                            margin: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1),
                            decoration: BoxDecoration(
                              boxShadow: [BoxShadow(spreadRadius: 1.5, blurRadius: 2, color: (Colors.grey[400])!)],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: GoogleMap(
                                myLocationButtonEnabled: true,
                                initialCameraPosition: CameraPosition(target: 
                                serviceProvider.getServiceProvider!.coordGps == null ?
                                   _initialcameraposition : 
                                LatLng(
                                  serviceProvider.getServiceProvider!.coordGps!["latitude"] != null ? 
                                    serviceProvider.getServiceProvider!.coordGps["latitude"] :
                                     _initialcameraposition.latitude, 
                                
                                serviceProvider.getServiceProvider!.coordGps["longitude"] != null ? 
                                serviceProvider.getServiceProvider!.coordGps["longitude"] : 
                                _initialcameraposition.longitude), zoom: 11.0),
                                mapType: MapType.normal,
                                onMapCreated: _onMapCreated,
                               
                              ),
                            ),
                          ),
                            Positioned(
                            bottom: hv*2,
                            right: wv*7,
                            child: !positionSpinner! ? TextButton(
                              onPressed: _saveLocation,
                              child: Text(S.of(context)!.ajouterMaLocalisation, style: const TextStyle(color: whiteColor),),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
                              ),
                            ) :  const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor), strokeWidth: 2.0,),
                          ),
                        ]),
                        SizedBox(height: hv*1.5,),
                      
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: wv*3),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context)!.slectionnezVosServices, style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.w600),),
                              SizedBox(height: hv*2,),
                              
                              Row(
                                children: [
                                  DoctorServiceChoiceCard(
                                    service: S.of(context)!.consultation,
                                    icon: "assets/icons/Bulk/Stethoscope.svg",
                                    chosen: consultationChosen!,
                                    action: ()=> setState(() {consultationChosen = !consultationChosen!;})
                                  ),
                                  DoctorServiceChoiceCard(
                                    service: S.of(context)!.ambulances,
                                    icon: "assets/icons/Bulk/Danger.svg",
                                    chosen: soinsAmbulances!,
                                    action: ()=> setState(() {soinsAmbulances = !soinsAmbulances!;})
                                  ),
                                  DoctorServiceChoiceCard(
                                    service: S.of(context)!.phamarmacie,
                                    icon: "assets/icons/Bulk/Soins.svg",
                                    chosen: pharmacie!,
                                    action: ()=> setState(() {pharmacie = !pharmacie!;})
                                  ),
                                ],
                              ),
                              SizedBox(height: hv*1,),
                              Row(
                                children: [
                                  DoctorServiceChoiceCard(
                                    service: S.of(context)!.laboratoire,
                                    icon: "assets/icons/Bulk/Ordonance.svg",
                                    chosen: labo!,
                                    action: ()=> setState(() {labo = !labo!;})
                                  ),
                                  DoctorServiceChoiceCard(
                                    service: S.of(context)!.hospitalisation,
                                    icon: "assets/icons/Bulk/Hospitalisation.svg",
                                    chosen: hospitalisation!,
                                    action: ()=> setState(() {hospitalisation = !hospitalisation!;})
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ), 

                      SizedBox(height: hv*1.5,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: wv*3),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context)!.picesJustificatives, style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w600),),
                            SizedBox(height: hv*1,),
                            Column(
                              children: [
                                FileUploadCard(
                                  title: S.of(context)!.scanDeLaCni,
                                  state: cniUploaded!,
                                  loading: cniSpinner!,
                                  action: () async {await getDocFromPhone('CNI');}
                                ),
                               
                                FileUploadCard(
                                  title: S.of(context)!.autrePiceJustificative,
                                  state: otherFileUploaded!,
                                  loading: otherFileSpinner!,
                                  action: () async {await getDocFromPhone('Pièce_Justificative_Supplémentaire');}
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: hv*3),
                       Container(
              child: 
                !buttonLoading! ? CustomTextButton(
                  text: S.of(context)!.envoyer,
                  color: kPrimaryColor,
                  action: () async {
                    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                    setState(() {
                      autovalidate = true;
                    });
                   
                    String contactName = _contactNameController!.text;
                    String email = _contactEmailController!.text;
                    String nomEtab=_nameController!.text.toString();
                     String speciality =_specialityController!.text;
                     String localisation =_localisationController!.text;
                       String about = _aboutController!.text;
                    if (_presptataireEditFormKey.currentState!.validate()){
                      setState(() {
                        buttonLoading = true;
                      });
                    
                       Map serviceList = {
                                "Consultation" : consultationChosen,
                                "Pharmacie" : pharmacie,
                                "laboratoire" : labo,
                                "SoinsAmbulances" : soinsAmbulances,
                                "Hospitalisation" : hospitalisation,
                              };
                      ServiceProviderModelProvider adherentProvider = Provider.of<ServiceProviderModelProvider>(context, listen: false);
                      print("$_contactNameController, $_category, $avatarUrl");
                      adherentProvider.setAvatarUrl(avatarUrl!);
                      //adherentProvider.setFamilyName(fname);
                      adherentProvider.setServiceList(serviceList);
                      adherentProvider.setSpecialite(speciality);
                      adherentProvider.setName(contactName);
                      adherentProvider.setcoordGps(gpsCoords!);
                      adherentProvider.setLocalisation(localisation);
                      adherentProvider.setAbout(about);
                      await FirebaseFirestore.instance.collection("USERS")
                        .doc(userProvider.getUserId)
                        .set({
                          'createdDate': DateTime.now(),
                          "authId": FirebaseAuth.instance.currentUser!.uid,
                          'emailAdress': email,
                          'fullName': contactName,
                          "enable": true,
                          "regionDorigione": _region,
                          "phoneKeywords": Algorithms.getKeyWords(adherentProvider.getServiceProvider!.id!),
                          "nameKeywords": Algorithms.getKeyWords(contactName)
                        }, SetOptions(merge: true))
                        .then((value) async {
                          await FirebaseFirestore.instance.collection("PRESTATAIRE")
                            .doc(userProvider.getUserId)
                            .set({
                              "createdDate": DateTime.now(),
                              "authId": FirebaseAuth.instance.currentUser!.uid,
                              "nomEtablissement": nomEtab,
                              "nomCompletPContact": contactName,
                              "emailPContact": email,
                              "about": about,
                              "authPhoneNumber": userProvider.getUserId,
                              "categorieEtablissement": _category,
                              "imageUrl" : avatarUrl,
                              "contactFunction": speciality,
                              "phoneList": FieldValue.arrayUnion([{"number": userProvider.getUserId}]),
                              "profil": "PRESTATAIRE",
                              "addresse": localisation,
                              "localisation": gpsCoords != null ? {
                                "addresse": _localisationController!.text,
                                "latitude": gpsCoords!["latitude"],
                                "longitude": gpsCoords!["longitude"],
                                "altitude": 0
                              } : {
                                "addresse": _localisationController!.text,
                              },
                              "serviceList": serviceList,
                              "region": adherentProvider.getServiceProvider!.region,
                              "villeEtab": adherentProvider.getServiceProvider!.town,
                              "userCountryCodeIso": userProvider.getCountryCode!.toLowerCase(),
                              "userCountryName": userProvider.getCountryName,
                              "phoneKeywords": Algorithms.getKeyWords(userProvider.getUserId!),
                              "nameKeywords": Algorithms.getKeyWords( _companyController!.text.toString().isEmpty? contactName: _companyController!.text.toString())
                            }, SetOptions(merge: true))
                            .then((value) async {
                              HiveDatabase.setRegisterState(true);
                              HiveDatabase.setAuthPhone(userProvider.getUserId!);
                              HiveDatabase.setSurname( _companyController!.text.toString());
                              HiveDatabase.setImgUrl(avatarUrl!);
                              setState(() {
                                buttonLoading = false;
                              });
                              
                            })
                            .catchError((e) {
                              if (kDebugMode) {
                                print(e.toString());
                              }
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              setState(() {
                                buttonLoading = false;
                              });
                            })
                            ;
                        })
                        .catchError((e){
                          if (kDebugMode) {
                            print(e.toString());
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          setState(() {
                            buttonLoading = false;
                          });
                        });
                    }

                  },
                ) : Loaders().buttonLoader(kPrimaryColor)
            ),
                    ]),
                   ),
                      ],
                    ),

                  ),
                 ]
              ))
          );
     
  }
   Future getDocFromPhone(String name) async {

    setState(() {
      if (name == "CNI"){
        cniSpinner = true;
      }else if (name == "CertificatEnregDor"){
          ortherScanSpinner = false;
      } else {
        otherFileSpinner = true;
      }
    });
    
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc'],);
    if(result != null) {
      File file = File(result.files.single.path!);
      uploadDocumentToFirebase(file, name);
    } else {
      setState(() {
        if (name == "CNI"){
          cniSpinner = false;
        } else if (name == "CertificatEnregDor"){
          ortherScanSpinner = false;
        } else {
          otherFileSpinner = false;
        }
      });
    }
  }
   Future uploadDocumentToFirebase(File file, String name) async {
    ServiceProviderModelProvider PrestatireModelProvider = Provider.of<ServiceProviderModelProvider>(context, listen: false);
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(S.of(context)!.aucuneImageSelectionne),));
      return null;
    }
    
    String adherentId = PrestatireModelProvider.getServiceProvider!.id!;
    Reference storageReference = FirebaseStorage.instance.ref().child('pieces_didentite/piece_prestatires/$adherentId/$name'); //.child('photos/profils_adherents/$fileName');
    final metadata = SettableMetadata(
      //contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path}
    );

    UploadTask storageUploadTask;
    if (kIsWeb) {
      storageUploadTask = storageReference.putData(await file.readAsBytes(), metadata);
    } else {
      storageUploadTask = storageReference.putFile(File(file.path), metadata);
    }
    
    //storageUploadTask = storageReference.putFile(imageFileAvatar);

    storageUploadTask.catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
    });
    storageUploadTask.whenComplete(() async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name ajoutée")));
      String url = await storageReference.getDownloadURL();
      avatarUrl = url;
     
       if (name == "CNI"){
        PrestatireModelProvider.setCniUrl(url);
        FirebaseFirestore.instance.collection("PRESTATAIRE")
        .doc(PrestatireModelProvider.getServiceProvider!.id)
        .set({
          "urlDocOficiel": url,
        }, SetOptions(merge: true)).then((value) {
          FirebaseFirestore.instance.collection("USERS")
            .doc(PrestatireModelProvider.getServiceProvider!.id)
            .update({
              "urlCNI": url,
            });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context)!.documentSauvegard)));
          setState(() {
            cniUploaded = true;
            cniSpinner = false;
          });
        });
      }
       else if (name == "CertificatEnregDor"){
        PrestatireModelProvider.setOrderRegistrationCertificateUrl(url);
        FirebaseFirestore.instance.collection("PRESTATAIRE")
        .doc(PrestatireModelProvider.getServiceProvider!.id)
        .set({
          "urlDocOficiel": url,
        }, SetOptions(merge: true)).then((value) {
          FirebaseFirestore.instance.collection("USERS")
            .doc(PrestatireModelProvider.getServiceProvider!.id)
            .update({
              "urlCNI": url,
            });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context)!.documentSauvegard)));
          setState(() {
            cniUploaded = true;
            cniSpinner = false;
          });
        });
      }
      else {
         PrestatireModelProvider.setOtherDocUrl(url);
        FirebaseFirestore.instance.collection("PRESTATAIRE")
        .doc(PrestatireModelProvider.getServiceProvider!.id)
        .set({
          "urlAutrePiecesJustificatif": url,
        }, SetOptions(merge: true)).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context)!.documentSauvegard)));
          setState(() {
            otherFileUploaded = true;
            otherFileSpinner = false;
          });
        });
      }
      
      print("download url: $url");
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("download url: $url")));
    }).catchError((e){
      print(e.toString());
    });
  }

   List<String> getTownNamesFromRegion(List origin, String region){
    List<String> target = [];
    for(int i=0; i<origin.length; i++){
      if (origin[i]["state_code"] == region){
       target.add(origin[i]["value"].toString());
      }
    }
    //print(target);
    return target;
  }
   getImage(BuildContext context){
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext bc){
        return SafeArea(
          child: Container(
            child:  Wrap(
              children: <Widget>[
                 ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const  Text('Gallerie'),
                    onTap: () async {
                      getImageFromGallery();
                      Navigator.of(context).pop();
                    }),
                 ListTile(
                  leading: const  Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getImageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  Future getImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        imageSpinner = true;
        imageFileAvatar = File(pickedFile.path);
        //imageLoading = true;
      } else {
        print('No image selected.');
      }
    });
    uploadImageToFirebase(pickedFile!);
  }
   Future getImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        imageSpinner = true;
        imageFileAvatar = File(pickedFile.path);
        //imageLoading = true;
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
    uploadImageToFirebase(pickedFile!);
  }
   Future uploadImageToFirebase(PickedFile file) async {
     ServiceProviderModelProvider serviceProvider = Provider.of<ServiceProviderModelProvider>(context, listen: false);

    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(S.of(context)!.aucuneImageSelectionne),));
      return null;
    }
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      imageLoading = true;
    });
    String fileName = userProvider.getUserId!;

    Reference storageReference = FirebaseStorage.instance.ref().child('photos/profils_adherents/$fileName'); //.child('photos/profils_adherents/$fileName');
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path}
    );

    UploadTask storageUploadTask;
    if (kIsWeb) {
      storageUploadTask = storageReference.putData(await file.readAsBytes(), metadata);
    } else {
      storageUploadTask = storageReference.putFile(File(file.path), metadata);
    }
    
    storageUploadTask = storageReference.putFile(imageFileAvatar!);

    storageUploadTask.catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
    });
    storageUploadTask.whenComplete(() async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context)!.finalisation)));
      String url = await storageReference.getDownloadURL();
      avatarUrl = url;
      HiveDatabase.setImgUrl(url);
      serviceProvider.setAvatarUrl(url);
      userProvider.setImgUrl(url);
      FirebaseFirestore.instance.collection("USERS").doc(serviceProvider.getServiceProvider!.id)
        .set({
          "imageUrl": url,
      }, SetOptions(merge: true));
      FirebaseFirestore.instance.collection("PRESTATAIRE")
        .doc(serviceProvider.getServiceProvider!.id)
        .update({
          "imageUrl": url,
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context)!.photoDeProfilAjoute)));
          setState(() {
            imageSpinner = false;
          });
        });
      print("download url: $url");
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("download url: $url")));
    });
    setState(() {
      imageLoading = false;
    });
  }
  String getRegionFromStateCode(List? origin, String? code){
    String region='';
    for(int i=0; i<origin!.length; i++){
      if (origin[i]["key"] == code){
       region = origin[i]["value"];
      }
    }
    return region;
  }
  String getStateCodeFromRegion(List? origin, String? region){
    String code='';
    for(int i=0; i<origin!.length; i++){
      if (origin[i]["value"] == region){
       code = origin[i]["key"];
      }
    }
    return code;
  }
  Future<String> _emailFieldValidator(String? value) async {
    return !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)?S.of(context)!.entrerUneAddresseEmailValide: '';
    }
  
}