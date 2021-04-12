import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/getCities.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/danAid_default_header.dart';
import 'package:danaid/widgets/file_upload_card.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/forms/location_dropdown.dart';
import 'package:danaid/widgets/function_widgets.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:provider/provider.dart';
import 'package:danaid/widgets/doctor_service_choice_card.dart';

class DoctorProfileEdit extends StatefulWidget {
  @override
  _DoctorProfileEditState createState() => _DoctorProfileEditState();
}

class _DoctorProfileEditState extends State<DoctorProfileEdit> {

  final GlobalKey<FormState> _doctorEditFormKey = GlobalKey<FormState>();
  TextEditingController _familynameController = new TextEditingController();
  TextEditingController _surnameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _cniNameController = new TextEditingController();
  TextEditingController _specialityController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _orderRegistrationNberController = new TextEditingController();
  TextEditingController _officeNameController = new TextEditingController();
  TextEditingController _rateController = new TextEditingController();
  TextEditingController _aboutController = new TextEditingController();

  LatLng _initialcameraposition = LatLng(4.044656688777058, 9.695724531228858);
  GoogleMapController _controller;
  Location _location = Location();
  Map<String, dynamic> gpsCoords;
  
  File imageFileAvatar;
  bool imageLoading = false;
  bool buttonLoading = false;
  String avatarUrl;
  bool surnameEnabled = true;
  bool nameEnabled = true;
  bool emailEnabled = true;
  bool cniNameEnabled = true;
  bool specialityEnabled = true;
  bool addressEnabled = true;
  bool orderRegNberEnabled = true;
  bool officeNameEnabled = true;
  bool rateEnabled = true;
  bool aboutEnabled = true;

  String _city;
  String _stateCode;
  String _region = "Centre";
  bool regionChosen = false;
  bool cityChosen = false;
  String _officeCity;
  String _officeRegion;
  String _officeStateCode;
  bool _officeCityChosen = false;
  bool _officeRegionChosen = false;

  bool chatChosen = false;
  bool consultationChosen = false;
  bool teleConsultationChosen = false;
  bool rdvChosen = false;
  bool visiteDomicileChosen = false;

  bool cniUploaded = false;
  bool otherFileUploaded = false;
  bool cniSpinner = false;
  bool otherFileSpinner = false;
  bool imageSpinner;
  bool positionSpinner = false;

  String _category;
  String _type;

  bool mondayToFridaySwitched = true;
  bool saturdaySwitched = false;
  bool sundaySwitched = false;

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

  void initAvailability(){
  }

  void _saveLocation(){
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    setState(() {
      positionSpinner = true;
    });
    _location.getLocation().then((loc) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(loc.latitude, loc.longitude),zoom: 11)),
      );

      setState(() {
        positionSpinner = false;
        _initialcameraposition = LatLng(loc.latitude, loc.longitude);
        gpsCoords = {
          "latitude": loc.latitude,
          "longitude": loc.longitude
        };
      });
      doctorProvider.setLocation(gpsCoords);
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) async {
    _location.getLocation().then((loc) {
      setState(() {
        _initialcameraposition = LatLng(loc.latitude, loc.longitude);
      });
    });
    setState(() {
      _controller = _cntlr;
    });
  }

  initRegionDropdown(){
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    setState(() {
      _stateCode = Algorithms.getStateCodeFromRegion(regions, doctorProvider.getDoctor.region);
      _region = doctorProvider.getDoctor.region;
      regionChosen = true;
      cityChosen = true;
      _city = doctorProvider.getDoctor.town;
    });
    
  }

  initOfficeRegionDropdown(){
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    setState(() {
      _officeStateCode = Algorithms.getStateCodeFromRegion(regions, doctorProvider.getDoctor.hospitalRegion);
      _officeRegion = doctorProvider.getDoctor.hospitalRegion;
      _officeRegionChosen = true;
      _officeCityChosen = true;
      _officeCity = doctorProvider.getDoctor.hospitalTown;
    });
    
  }

  textFieldsControl (){
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);

    if((doctorProvider.getDoctor.surname != null) & (doctorProvider.getDoctor.surname != "")){
      setState(() {
        _surnameController.text = doctorProvider.getDoctor.surname;
        surnameEnabled = false; 
      });
    }
    if((doctorProvider.getDoctor.familyName != null) & (doctorProvider.getDoctor.familyName != "")){
      setState(() {
        _familynameController.text = doctorProvider.getDoctor.familyName;
        nameEnabled = false;
      });
    }
    if((doctorProvider.getDoctor.cniName != null) & (doctorProvider.getDoctor.cniName != "")){
      setState(() {
        _cniNameController.text = doctorProvider.getDoctor.cniName;
        cniNameEnabled = false;
      });
    }
    if((doctorProvider.getDoctor.email != null) & (doctorProvider.getDoctor.email != "")){
      setState(() {
        _emailController.text = doctorProvider.getDoctor.email;
        emailEnabled = false;
      });
    }
    if((doctorProvider.getDoctor.about != null) & (doctorProvider.getDoctor.about != "")){
      setState(() {
        _aboutController.text = doctorProvider.getDoctor.about;
        aboutEnabled = false;
      });
    }
    if((doctorProvider.getDoctor.orderRegistrationCertificate != null) & (doctorProvider.getDoctor.orderRegistrationCertificate != "")){
      setState(() {
        _orderRegistrationNberController.text = doctorProvider.getDoctor.orderRegistrationCertificate;
        orderRegNberEnabled = false;
      });
    }
    if((doctorProvider.getDoctor.speciality != null) & (doctorProvider.getDoctor.speciality != "")){
      setState(() {
        _specialityController.text = doctorProvider.getDoctor.speciality;
        specialityEnabled = false;
      });
    }
    if((doctorProvider.getDoctor.rate != null)){
      setState(() {
        _rateController.text = doctorProvider.getDoctor.rate["public"].toString();
        rateEnabled = false;
      });
    }
    if((doctorProvider.getDoctor.address != null) & (doctorProvider.getDoctor.address != "")){
      setState(() {
        _addressController.text = doctorProvider.getDoctor.address;
        addressEnabled = false;
      });
    }
    if((doctorProvider.getDoctor.officeName != null) & (doctorProvider.getDoctor.officeName != "")){
      setState(() {
        _officeNameController.text = doctorProvider.getDoctor.officeName;
        officeNameEnabled = false;
      });
    }
    if((doctorProvider.getDoctor.officeCategory != null) & (doctorProvider.getDoctor.officeCategory != "")){
      setState(() {
        _category = doctorProvider.getDoctor.officeCategory;
      });
    }
    if((doctorProvider.getDoctor.field != null) & (doctorProvider.getDoctor.field != "")){
      setState(() {
        _type = doctorProvider.getDoctor.field;
      });
    }
    
    if (doctorProvider.getDoctor.location != null){
      print(doctorProvider.getDoctor.location.toString() +"inside+");
      if ((doctorProvider.getDoctor.location["latitude"] != null) | (doctorProvider.getDoctor.location["longitude"] != null) | true){
        setState(() {
          gpsCoords = {
          "latitude": doctorProvider.getDoctor.location["latitude"],
          "longitude": doctorProvider.getDoctor.location["longitude"]
        };
        });
      }
    }
    
    if((doctorProvider.getDoctor.cniUrl != "") & (doctorProvider.getDoctor.cniUrl != null)){
      setState(() {
        cniUploaded = true;
      });
    }
    if((doctorProvider.getDoctor.orderRegistrationCertificateUrl != "") & (doctorProvider.getDoctor.orderRegistrationCertificateUrl != null)){
      setState(() {
        otherFileUploaded = true;
      });
    }
    if((doctorProvider.getDoctor.serviceList != "") & (doctorProvider.getDoctor.serviceList != null)){
      setState(() {
          chatChosen = doctorProvider.getDoctor.serviceList["chat"];
          consultationChosen = doctorProvider.getDoctor.serviceList["consultation"];
          teleConsultationChosen = doctorProvider.getDoctor.serviceList["tele-consultation"];
          rdvChosen = doctorProvider.getDoctor.serviceList["rdv"];
          visiteDomicileChosen = doctorProvider.getDoctor.serviceList["visite-a-domicile"];
      });
    }
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
    imageSpinner = false;
    initAvailability();
    initRegionDropdown();
    initOfficeRegionDropdown();
    textFieldsControl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context);
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Column(children: [
          Container(
            margin: EdgeInsets.only(bottom: hv*2),
            child: Stack(clipBehavior: Clip.none, children: [
              DanAidDefaultHeader(),
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
                          padding: EdgeInsets.all(20.0),
                        ),
                        imageUrl: doctorProvider.getDoctor.avatarUrl,),
                    ),
                      //backgroundImage: CachedNetworkImageProvider(adherentModelProvider.getAdherent.imgUrl),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 5,
                    child: CircleAvatar(
                      backgroundColor: kDeepTeal,
                      radius: wv*5,
                      child: IconButton(
                        icon: Icon(Icons.add, color: whiteColor,), 
                        color: kPrimaryColor, 
                        onPressed: (){FunctionWidgets.chooseImageProvider(context: context, gallery: getImageFromGallery, camera: getImageFromCamera);}
                      ),
                    ),
                  ),
                  
                  imageSpinner ? Positioned(
                    top: hv*7,
                    right: wv*13,
                    child: CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(whiteColor),)
                  ) : Container(),
                ],),
              ),
            ], alignment: AlignmentDirectional.topCenter,),
          ),
          Expanded(child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Form(key: _doctorEditFormKey,
                child: Column(children: [
                  SizedBox(height: hv*1,),

                      CustomTextField(
                        prefixIcon: Icon(LineIcons.users, color: kPrimaryColor),
                        label: "Nom de Famille *",
                        hintText: "Entrez votre nom de famille",
                        controller: _familynameController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                        enabled: nameEnabled,
                        editAction: (){
                          setState(() {
                            nameEnabled = true;
                          });}
                      ),
                      SizedBox(height: hv*2,),
                      CustomTextField(
                        prefixIcon: Icon(LineIcons.user, color: kPrimaryColor),
                        label: "Prénom (s)",
                        hintText: "Entrez votre prénom",
                        enabled: surnameEnabled,
                        controller: _surnameController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                        editAction: (){
                          setState(() {
                            surnameEnabled = true;
                          });
                        },
                      ),
                      SizedBox(height: hv*2,),
                      CustomTextField(
                        prefixIcon: Icon(MdiIcons.cardAccountDetailsOutline, color: kPrimaryColor),
                        label: "Nom tel que sur la CNI",
                        hintText: "Nom CNI",
                        enabled: cniNameEnabled,
                        controller: _cniNameController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                        editAction: (){
                          setState(() {
                            cniNameEnabled = true;
                          });
                        },
                      ),
                      SizedBox(height: hv*2,),
                      CustomTextField(
                        prefixIcon: Icon(MdiIcons.cardAccountDetailsOutline, color: kPrimaryColor),
                        label: "A propos",
                        hintText: "Parlez brièvement de vous..",
                        enabled: aboutEnabled,
                        multiLine: true,
                        controller: _aboutController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                        editAction: (){
                          setState(() {
                            aboutEnabled = true;
                          });
                        },
                      ),
                      SizedBox(height: hv*2,),
                      CustomTextField(
                        prefixIcon: Icon(MdiIcons.emailOutline, color: kPrimaryColor),
                        label: "Email",
                        hintText: "Entrez votre addresse email",
                        enabled: emailEnabled,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator:  (String mail) {
                          return (mail.isEmpty)
                              ? kEmailNullErrorFr
                              : (!emailValidatorRegExp.hasMatch(mail))
                              ? kInvalidEmailError : null;
                        },
                        editAction: (){
                          setState(() {
                            emailEnabled = true;
                          });
                        },
                      ),
                      SizedBox(height: hv*1.5,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: wv*3),
                        child: LocationDropdown(
                          city: _city,
                          stateCode: _stateCode,
                          cityChosen: cityChosen,
                          regionChosen: regionChosen,
                          regionOnChanged: (value) async {
                            setState(() {
                              _stateCode = value;
                              _region = Algorithms.getRegionFromStateCode(regions, value);
                              _city = null;
                              cityChosen = false;
                              regionChosen = true;
                            });
                          },
                        cityOnChanged: (value) {
                          setState(() {
                            _city = value;
                            cityChosen = true;
                          });
                        },
                        ),
                      ),
                      SizedBox(height: hv*2,),
                      CustomTextField(
                        prefixIcon: Icon(LineIcons.mapMarker, color: kPrimaryColor),
                        label: "Votre addresse",
                        hintText: "Ex: Carrefour TKC, Biyem-Assi",
                        enabled: addressEnabled,
                        controller: _addressController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                        editAction: (){
                          setState(() {
                            addressEnabled = true;
                          });
                        },
                      ),
                      SizedBox(height: hv*3.5,),
                      (gpsCoords != null) | (doctorProvider.getDoctor.location != null) ? Container(margin: EdgeInsets.symmetric(horizontal: wv*4),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("GPS:", style: TextStyle(fontWeight: FontWeight.w900),),
                            RichText(text: TextSpan(
                              text: "Lat: ",
                              children: [
                                TextSpan(text: (gpsCoords != null) ? gpsCoords["latitude"].toString() : doctorProvider.getDoctor.location["latitude"], style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryColor)),
                                TextSpan(text: "     Lng: "),
                                TextSpan(text: (gpsCoords != null) ? gpsCoords["longitude"].toString() : doctorProvider.getDoctor.location["longitude"], style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryColor))
                              ]
                            , style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
                            )
                          ],
                        ),
                      )
                      : Container(),
                      Stack(
                        children: [
                          Container(
                            height: hv*30,
                            margin: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1),
                            decoration: BoxDecoration(
                              boxShadow: [BoxShadow(spreadRadius: 1.5, blurRadius: 2, color: Colors.grey[400])],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: GoogleMap(
                                myLocationButtonEnabled: true,
                                initialCameraPosition: CameraPosition(target: doctorProvider.getDoctor.location == null ? _initialcameraposition : LatLng(doctorProvider.getDoctor.location["latitude"], doctorProvider.getDoctor.location["longitude"]), zoom: 11.0),
                                mapType: MapType.normal,
                                onMapCreated: _onMapCreated,
                                myLocationEnabled: true,
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: hv*2,
                            right: wv*7,
                            child: !positionSpinner ? TextButton(
                              onPressed: _saveLocation,
                              child: Text("Ajouter ma location", style: TextStyle(color: whiteColor),),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
                              ),
                            ) :  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor), strokeWidth: 2.0,),
                          ),
                        ],
                      ),
                      SizedBox(height: hv*2,),
                      Divider(),
                      SizedBox(height: hv*2,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: wv*3),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Statut", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                            SizedBox(height: 5,),
                            Container(
                              constraints: BoxConstraints(minWidth: wv*45),
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: Text("Choisir"),
                                  isExpanded: true,
                                  value: _type,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text("Généraliste", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                      value: "Généraliste",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Spécialiste", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                      value: "Spécialiste",
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _type = value;
                                    });
                                  }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      _type == "Spécialiste" ? Column(
                        children: [
                          SizedBox(height: hv*2,),
                          CustomTextField(
                            prefixIcon: Icon(MdiIcons.accountTieOutline, color: kPrimaryColor),
                            label: "Spécialité",
                            hintText: "ex: Chirurgien",
                            enabled: specialityEnabled,
                            controller: _specialityController,
                            validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                            editAction: (){
                              setState(() {
                                specialityEnabled = true;
                              });
                            },
                          ),
                        ],
                      ) : Container(),
                      SizedBox(height: hv*2,),

                      CustomTextField(
                        prefixIcon: Icon(MdiIcons.barcode, color: kPrimaryColor),
                        label: "Numéro d'enrégistrement à l'ordre",
                        hintText: "Votre matricule",
                        enabled: orderRegNberEnabled,
                        controller: _orderRegistrationNberController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                        editAction: (){
                          setState(() {
                            orderRegNberEnabled = true;
                          });
                        },
                      ),

                      SizedBox(height: hv*2,),

                      CustomTextField(
                        prefixIcon: Icon(MdiIcons.cardAccountDetailsOutline, color: kPrimaryColor),
                        label: "Votre tarif par heure",
                        hintText: "ex: 3500",
                        enabled: rateEnabled,
                        controller: _rateController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$')),
                        ],
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                        editAction: (){
                          setState(() {
                            rateEnabled = true;
                          });
                        },
                      ),
                      SizedBox(height: hv*2,),

                      CustomTextField(
                        prefixIcon: Icon(LineIcons.hospital, color: kPrimaryColor),
                        label: "Nom de votre établissement",
                        hintText: "ex: Hôpital de District de Limbé",
                        enabled: officeNameEnabled,
                        controller: _officeNameController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                        editAction: (){
                          setState(() {
                            officeNameEnabled = true;
                          });
                        },
                      ),

                      SizedBox(height: hv*2,),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: wv*3),
                        child: Column(children: [
                          Text("Type d'établissement *", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                          SizedBox(height: 5,),
                          Container(
                            constraints: BoxConstraints(minWidth: wv*45),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: _category,
                                  hint: Text("Choisir"),
                                  items: [
                                    DropdownMenuItem(
                                      child: Text("Hôpital", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                      value: "Hôpital",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Pharmacie", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                      value: "Pharmacie",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Laboratoire", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                      value: "Laboratoire",
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _category = value;
                                    });
                                  }),
                              ),
                            ),
                          ),

                          SizedBox(height: hv*2,),

                          LocationDropdown(
                            city: _officeCity,
                            stateCode: _officeStateCode,
                            cityChosen: _officeCityChosen,
                            regionChosen: _officeRegionChosen,
                            regionOnChanged: (value) async {
                              setState(() {
                                _officeStateCode = value;
                                _officeRegion = Algorithms.getRegionFromStateCode(regions, value);
                                _officeCity = null;
                                _officeCityChosen = false;
                                _officeRegionChosen = true;
                              });
                            },
                            cityOnChanged: (value) {
                              setState(() {
                                _officeCity = value;
                                _officeCityChosen = true;
                              });
                            },
                          ),
                          ], crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),

                      SizedBox(height: hv*1.5,),
                      Divider(),
                      SizedBox(height: hv*0.5,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: wv*3),
                        child: Text("Sélectionnez vos horaires", style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.w600),),
                      ),
                      SizedBox(height: hv*1,),
                      Table(
                        columnWidths: {2: FlexColumnWidth(1.3),3: FlexColumnWidth(1.3),},
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]))),
                            children: [
                              TableCell(child: Text('', textAlign: TextAlign.left,)),
                              TableCell(child: Padding(
                                padding: EdgeInsets.symmetric(vertical: hv*1),
                                child: Text('Jours', style: tablehead,),
                              )),
                              TableCell(child: Center(child: Text('Début', style: tablehead,))),
                              TableCell(child: Center(child: Text('Fin', style: tablehead,))),
                          ]),
                          TableRow(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]))),
                            children: [
                            TableCell(child: Center(
                              child: Switch(
                                value: availability["monday to friday"]["available"],
                                onChanged: (value) {
                                  setState(() {
                                    availability["monday to friday"]["available"] = value;
                                  });
                                },
                                activeTrackColor: kSouthSeas,
                                activeColor: kDeepTeal),
                              ),
                            ),
                            TableCell(child: Text('Lundi à Vendredi'),),
                            TableCell(child: availability["monday to friday"]["available"] ? DoctorServiceChoiceCard(
                              service: availability["monday to friday"]["start"].hour.toString().padLeft(2, '0').padLeft(2, '0')+" : "+availability["monday to friday"]["start"].minute.toString().padLeft(2, '0'),
                              icon: "assets/icons/Bulk/Edit.svg",
                              action: ()=>_selectStartTimeWeek(context),
                            ) : Center(child: Text("/"))),
                            TableCell(child: availability["monday to friday"]["available"] ? DoctorServiceChoiceCard(
                              service: availability["monday to friday"]["end"].hour.toString().padLeft(2, '0')+" : "+availability["monday to friday"]["end"].minute.toString().padLeft(2, '0'),
                              icon: "assets/icons/Bulk/Edit.svg",
                              action: ()=>_selectEndTimeWeek(context),
                            ) : Center(child: Text("/"))),
                          ]),
                          TableRow(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]))), children: [
                            TableCell(child: Center(
                              child: Switch(
                                value: availability["saturday"]["available"],
                                onChanged: (value) {
                                  setState(() {
                                    availability["saturday"]["available"] = value;
                                  });
                                },
                                activeTrackColor: kSouthSeas,
                                activeColor: kDeepTeal),
                              )),
                            TableCell(child: Text('Samedi'),),
                            TableCell(child: availability["saturday"]["available"] ? DoctorServiceChoiceCard(
                              service: availability["saturday"]["start"].hour.toString().padLeft(2, '0')+" : "+availability["saturday"]["start"].minute.toString().padLeft(2, '0'),
                              icon: "assets/icons/Bulk/Edit.svg",
                              action: ()=>_selectStartTimeSaturday(context),
                            ) : Center(child: Text("/"))),
                            TableCell(child: availability["saturday"]["available"] ? DoctorServiceChoiceCard(
                              service: availability["saturday"]["end"].hour.toString().padLeft(2, '0')+" : "+availability["saturday"]["end"].minute.toString().padLeft(2, '0'),
                              icon: "assets/icons/Bulk/Edit.svg",
                              action: ()=>_selectEndTimeSaturday(context),
                            ) : Center(child: Text("/"))),
                          ]),
                          TableRow(children: [
                            TableCell(child: Center(
                              child: Switch(
                                value: availability["sunday"]["available"],
                                onChanged: (value) {
                                  setState(() {
                                    availability["sunday"]["available"] = value;
                                  });
                                },
                                activeTrackColor: kSouthSeas,
                                activeColor: kDeepTeal),
                              )),
                            TableCell(child: Text('Dimanche'),),
                            TableCell(child: availability["sunday"]["available"] ? DoctorServiceChoiceCard(
                              service: availability["sunday"]["start"].hour.toString().padLeft(2, '0')+" : "+availability["sunday"]["start"].minute.toString().padLeft(2, '0'),
                              icon: "assets/icons/Bulk/Edit.svg",
                              action: ()=>_selectStartTimeSunday(context),
                            ) : Center(child: Text("/"))),
                            TableCell(child: availability["sunday"]["available"] ? DoctorServiceChoiceCard(
                              service: availability["sunday"]["end"].hour.toString().padLeft(2, '0')+" : "+availability["sunday"]["end"].minute.toString().padLeft(2, '0'),
                              icon: "assets/icons/Bulk/Edit.svg",
                              action: ()=>_selectEndTimeSunday(context),
                            ) : Center(child: Text("/"))),
                          ])
                        ],
                      ),

                      SizedBox(height: hv*2,),
                      
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: wv*3),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sélectionnez vos services", style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.w600),),
                              SizedBox(height: hv*2,),
                              Row(
                                children: [
                                  DoctorServiceChoiceCard(
                                    service: "Consultation",
                                    icon: "assets/icons/Bulk/Chat.svg",
                                    chosen: consultationChosen,
                                    action: ()=> setState(() {consultationChosen = !consultationChosen;})
                                  ),
                                  DoctorServiceChoiceCard(
                                    service: "Télé-Consultation",
                                    icon: "assets/icons/Bulk/Video.svg",
                                    chosen: teleConsultationChosen,
                                    action: ()=> setState(() {teleConsultationChosen = !teleConsultationChosen;})
                                  ),
                                  DoctorServiceChoiceCard(
                                    service: "Chat",
                                    icon: "assets/icons/Bulk/Chat.svg",
                                    chosen: chatChosen,
                                    action: ()=> setState(() {chatChosen = !chatChosen;})
                                  ),
                                ],
                              ),
                              SizedBox(height: hv*1,),
                              Row(
                                children: [
                                  DoctorServiceChoiceCard(
                                    service: "Rendez-Vous",
                                    icon: "assets/icons/Bulk/CalendarLine.svg",
                                    chosen: rdvChosen,
                                    action: ()=> setState(() {rdvChosen = !rdvChosen;})
                                  ),
                                  DoctorServiceChoiceCard(
                                    service: "Visite à Domicile",
                                    icon: "assets/icons/Bulk/Home.svg",
                                    chosen: visiteDomicileChosen,
                                    action: ()=> setState(() {visiteDomicileChosen = !visiteDomicileChosen;})
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ), 

                      SizedBox(height: hv*1.5,),
                      Divider(),
                      SizedBox(height: hv*1.5,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: wv*3),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pièces justificatives", style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.w600),),
                            SizedBox(height: hv*2,),
                            Column(
                              children: [
                                FileUploadCard(
                                  title: "Scan de la pièce d'identité (CNI, Passport, etc)",
                                  state: cniUploaded,
                                  loading: cniSpinner,
                                  action: () async {await getDocFromPhone('CNI');}
                                ),
                                FileUploadCard(
                                  title: "Certificat d'enrégistrement à l'ordre",
                                  state: otherFileUploaded,
                                  loading: otherFileSpinner,
                                  action: () async {await getDocFromPhone('Order_Registration_Certificate');}
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: hv*2,),
                      Container(
                        child: cityChosen & _officeCityChosen & _rateController.text.isNotEmpty ?  
                          !buttonLoading ? CustomTextButton(
                            text: "Mettre à jour",
                            color: kPrimaryColor,
                            action: () async {
                              String fname = _familynameController.text;
                              String sname = _surnameController.text;
                              String cniName = _cniNameController.text;
                              String email = _emailController.text;
                              String address = _addressController.text;
                              String speciality =_specialityController.text;
                              String officeName = _officeNameController.text;
                              String orderReg = _orderRegistrationNberController.text;
                              String about = _aboutController.text;
                              double rate = double.parse(_rateController.text);
                              Map availabilityStamp = {
                                "monday to friday": {
                                  "available": availability["monday to friday"]["available"],
                                  "start": availability["monday to friday"]["start"],
                                  "end": availability["monday to friday"]["end"]
                                },
                                "saturday": {
                                  "available": availability["saturday"]["available"],
                                  "start": availability["saturday"]["start"],
                                  "end": availability["saturday"]["end"]
                                },
                                "sunday": {
                                  "available": availability["sunday"]["available"],
                                  "start": availability["sunday"]["start"],
                                  "end": availability["sunday"]["end"]
                                },
                              };
                              Map serviceList = {
                                "consultation" : consultationChosen,
                                "tele-consultation" : teleConsultationChosen,
                                "visite-a-domicile" : visiteDomicileChosen,
                                "chat" : chatChosen,
                                "rdv" : rdvChosen
                              };
                              Map rateMap = {
                                "public": rate,
                                "adherent": rate*0.3,
                                "other": rate*0.98
                              };
                              Map location = gpsCoords != null ? {
                                "addresse": address,
                                "latitude": gpsCoords["latitude"],
                                "longitude": gpsCoords["longitude"],
                                "altitude": 0
                                } : {
                                  "addresse": address,
                                };
                              if (_doctorEditFormKey.currentState.validate()){
                                setState(() {
                                  buttonLoading = true;
                                });
                                DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
                                print("$fname, $sname, $avatarUrl");
                                doctorProvider.setFamilyName(fname);
                                doctorProvider.setSurname(sname);
                                doctorProvider.setEmail(email);
                                doctorProvider.setSpeciality(speciality);
                                doctorProvider.setAddress(address);
                                doctorProvider.setCniName(cniName);
                                doctorProvider.setOrderRegistrationCertificate(orderReg);
                                doctorProvider.setRate(rateMap);
                                doctorProvider.setServiceList(serviceList);
                                doctorProvider.setRegion(_region);
                                doctorProvider.setTown(_city);
                                doctorProvider.setOfficeName(officeName);
                                doctorProvider.setOfficeRegion(_officeRegion);
                                doctorProvider.setOfficeTown(_officeCity);
                                doctorProvider.setAvailability(availabilityStamp);
                                doctorProvider.setAbout(about);
                                (gpsCoords["latitude"] == null) || (gpsCoords["longitude"] == null) ? doctorProvider.setLocation(location) : print("No data");
                                doctorProvider.setAvailability(availability);
                                await FirebaseFirestore.instance.collection("USERS")
                                  .doc(doctorProvider.getDoctor.id)
                                  .set({
                                    'emailAdress': email,
                                    'fullName': cniName,
                                    "regionDorigione": _region
                                  }, SetOptions(merge: true))
                                  .then((value) async {
                                    print(gpsCoords["latitude"].toString()+ "Laaaaaaat");
                                    await FirebaseFirestore.instance.collection("MEDECINS")
                                      .doc(doctorProvider.getDoctor.id)
                                      .set({
                                        "cniName": cniName,
                                        "emailAdress": email,
                                        "about": about,
                                        "nomDefamille": fname,
                                        "prenom": sname,
                                        "domaine": _type,
                                        "specialite": speciality,
                                        "regionDorigione": _region,
                                        "certificatDenregistrmDordre": orderReg,
                                        "ville": _city == null ? doctorProvider.getDoctor.town : _city,
                                        "communeHospital": _officeCity,
                                        "nomEtablissement": officeName,
                                        "categorieEtablissement": _category,
                                        "tarif": rateMap,
                                        "regionEtablissement": _officeRegion,
                                        "localisation": location,
                                        "addresse": address,
                                        "availability": availability,
                                        "serviceList": serviceList
                                      }, SetOptions(merge: true))
                                      .then((value) async {

                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Informations mises à jour..")));
                                        Navigator.pop(context, (value) {
                                          setState(() {});
                                        });
                                        setState(() {
                                          buttonLoading = false;
                                        });
                                      })
                                      .catchError((e) {
                                        print(e.toString());
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                        setState(() {
                                          buttonLoading = false;
                                        });
                                      })
                                      ;
                                  })
                                  .catchError((e){
                                    print(e.toString());
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                    setState(() {
                                      buttonLoading = false;
                                    });
                                  })
                                  ;
                              }
                            },
                          ) : Center(child: Loaders().buttonLoader(kPrimaryColor)) :
                          CustomDisabledTextButton(
                            text: "Mettre à Jour",
                          )
                      ,),
                      SizedBox(height: hv*3,),
                      Center(
                        child: TextButton(
                          child: Text("Se Déconnecter"),
                          onPressed: () async {
                            DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
                            UserProvider user = Provider.of<UserProvider>(context, listen: false);
                            user.setUserId(null);
                            user.setProfileType(null);
                            doctorProvider.setDoctorId(null);
                            HiveDatabase.setRegisterState(false);
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ),
                ], crossAxisAlignment: CrossAxisAlignment.start, ),
              )
            ],
            )
          )
        ],),
      ),
    );
  }

  TextStyle tablehead = TextStyle(fontWeight: FontWeight.w600, fontSize: wv*4);

  Future<void> _selectStartTimeWeek(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: availability["monday to friday"]["start"].hour, minute: availability["monday to friday"]["start"].minute), builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );});

    if (picked_s != null && picked_s != TimeOfDay(hour: availability["monday to friday"]["start"].hour, minute: availability["monday to friday"]["start"].minute))
      setState(() {
        availability["monday to friday"]["start"] = DateTime(2000, 1, 1, picked_s.hour, picked_s.minute);
      });
  }
  Future<void> _selectEndTimeWeek(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: availability["monday to friday"]["end"].hour, minute: availability["monday to friday"]["end"].minute), builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );});

    if (picked_s != null && picked_s != TimeOfDay(hour: availability["monday to friday"]["end"].hour, minute: availability["monday to friday"]["end"].minute))
      setState(() {
        availability["monday to friday"]["end"] = DateTime(2000, 1, 1, picked_s.hour, picked_s.minute);
      });
  }
  Future<void> _selectStartTimeSaturday(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: availability["saturday"]["start"].hour, minute: availability["saturday"]["start"].minute), builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );});

    if (picked_s != null && picked_s != TimeOfDay(hour: availability["saturday"]["start"].hour, minute: availability["saturday"]["start"].minute))
      setState(() {
        availability["saturday"]["start"] = DateTime(2000, 1, 1, picked_s.hour, picked_s.minute);
      });
  }
  Future<void> _selectEndTimeSaturday(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: availability["saturday"]["end"].hour, minute: availability["saturday"]["end"].minute), builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );});

    if (picked_s != null && picked_s != TimeOfDay(hour: availability["saturday"]["end"].hour, minute: availability["saturday"]["end"].minute))
      setState(() {
        availability["saturday"]["end"] = DateTime(2000, 1, 1, picked_s.hour, picked_s.minute);
      });
  }
  Future<void> _selectStartTimeSunday(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: availability["sunday"]["start"].hour, minute: availability["sunday"]["start"].minute), builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );});

    if (picked_s != null && picked_s != TimeOfDay(hour: availability["sunday"]["start"].hour, minute: availability["sunday"]["start"].minute))
      setState(() {
        availability["sunday"]["start"] = DateTime(2000, 1, 1, picked_s.hour, picked_s.minute);
      });
  }
  Future<void> _selectEndTimeSunday(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: availability["sunday"]["end"].hour, minute: availability["sunday"]["end"].minute), builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );});

    if (picked_s != null && picked_s != TimeOfDay(hour: availability["sunday"]["end"].hour, minute: availability["sunday"]["end"].minute))
      setState(() {
        availability["sunday"]["end"] = DateTime(2000, 1, 1, picked_s.hour, picked_s.minute);
      });
  }

  Future getDocFromPhone(String name) async {

    setState(() {
      if (name == "CNI"){
        cniSpinner = true;
      } else {
        otherFileSpinner = true;
      }
    });
    
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc'],);
    if(result != null) {
      File file = File(result.files.single.path);
      uploadDocumentToFirebase(file, name);
    } else {
      setState(() {
        if (name == "CNI"){
          cniSpinner = false;
        } else {
          otherFileSpinner = false;
        }
      });
    }
  }

  Future uploadDocumentToFirebase(File file, String name) async {

    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucun document selectionnée'),));
      return null;
    }
    
    String doctorId = doctorProvider.getDoctor.id;
    Reference storageReference = FirebaseStorage.instance.ref().child('pieces_didentite/pieces_medecins/$doctorId/$name');
    final metadata = SettableMetadata(
      customMetadata: {'picked-file-path': file.path}
    );

    UploadTask storageUploadTask;
    if (kIsWeb) {
      storageUploadTask = storageReference.putData(await file.readAsBytes(), metadata);
    } else {
      storageUploadTask = storageReference.putFile(File(file.path), metadata);
    }

    storageUploadTask.catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
    });
    storageUploadTask.whenComplete(() async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name ajoutée")));
      String url = await storageReference.getDownloadURL();
      if (name == "CNI"){
        doctorProvider.setCNIUrl(url);
        FirebaseFirestore.instance.collection(doctor+"S")
        .doc(doctorId)
        .update({
          "urlScaneCNI": url,
        }).then((value) {
          FirebaseFirestore.instance.collection("USERS")
            .doc(doctorId)
            .update({
              "urlCNI": url,
            });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Document Sauvegardé")));
          setState(() {
            cniUploaded = true;
            cniSpinner = false;
          });
        });
      }
      else {
        doctorProvider.setOrderRegistrationCertificateUrl(url);
        FirebaseFirestore.instance.collection(doctor+"S")
        .doc(doctorId)
        .update({
          "urlScaneCertificatEnregDordr": url,
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Document Sauvegardé")));
          setState(() {
            otherFileUploaded = true;
            otherFileSpinner = false;
          });
        });
      }
      print("download url: $url");
    }).catchError((e){
      print(e.toString());
    });
  }

  Future uploadImageToFirebase(PickedFile file) async {

    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);

    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucune image selectionnée'),));
      return null;
    }
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
        imageSpinner = true;
    }));
    String fileName = userProvider.getUserId;

    Reference storageReference = FirebaseStorage.instance.ref().child('photos/profils_Medecins/$fileName');
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
    
    storageUploadTask = storageReference.putFile(imageFileAvatar);

    storageUploadTask.catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
    });
    storageUploadTask.whenComplete(() async {
      String url = await storageReference.getDownloadURL();
      doctorProvider.setImgUrl(url);
      FirebaseFirestore.instance.collection(doctor+"S")
        .doc(doctorProvider.getDoctor.id)
        .update({
          "urlImage": url,
        }).then((value) {
          FirebaseFirestore.instance.collection("USERS")
            .doc(doctorProvider.getDoctor.id)
            .update({
              "imageUrl": url,
            });
        });
      avatarUrl = url;
      print("download url: $url");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Photo de profil ajoutée")));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
      imageSpinner = false;
    }));
  }

  Future getImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
      if (pickedFile != null) {
        imageFileAvatar = File(pickedFile.path);
        imageSpinner = true;
        //imageLoading = true;
      } else {
        print('No image selected.');
      }
    }));
    uploadImageToFirebase(pickedFile);
  }

  Future getImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
        imageSpinner = true;
      }));
      setState(() {
        imageFileAvatar = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
    
    uploadImageToFirebase(pickedFile);
  }
}