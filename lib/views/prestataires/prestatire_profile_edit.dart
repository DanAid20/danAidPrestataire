import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/getCities.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/danAid_default_header.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/forms/location_dropdown.dart';
import 'package:danaid/widgets/function_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:provider/provider.dart';

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
  String _city;
  String _stateCode;
  String _region = "Centre";
  bool regionChosen = false;
  bool cityChosen = false;

  bool cniUploaded = false;
  bool otherFileUploaded = false;
  bool cniSpinner = false;
  bool otherFileSpinner = false;
  bool imageSpinner = false;
  bool positionSpinner = false;

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
    if((doctorProvider.getDoctor.speciality != null) & (doctorProvider.getDoctor.speciality != "")){
      setState(() {
        _specialityController.text = doctorProvider.getDoctor.speciality;
        specialityEnabled = false;
      });
    }
    if((doctorProvider.getDoctor.address != null) & (doctorProvider.getDoctor.address != "")){
      setState(() {
        _addressController.text = doctorProvider.getDoctor.address;
        addressEnabled = false;
      });
    }
    
    print("inside");
    if (doctorProvider.getDoctor.location != null){
      print(doctorProvider.getDoctor.location.toString() +"inside+");
      if ((doctorProvider.getDoctor.location["latitude"] != null) | (doctorProvider.getDoctor.location["longitude"] != null) | true){
        setState(() {
          gpsCoords = {
          "latitude": doctorProvider.getDoctor.location["latitude"],
          "longitude": doctorProvider.getDoctor.location["longitude"]
        };
        print(gpsCoords.toString());
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
  }

  @override
  void initState() {
    initRegionDropdown();
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
                  )
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
                      SizedBox(height: hv*1.5,),
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
                      SizedBox(height: hv*1.5,),
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
                      SizedBox(height: hv*1.5,),
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
                      SizedBox(height: hv*1.5,),
                      Divider(),
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
                      SizedBox(height: hv*2,),
                ],),
              )
            ],
            )
          )
        ],),
      ),
    );
  }
  Future uploadImageToFirebase(PickedFile file) async {

    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucune image selectionnée'),));
      return null;
    }
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      imageLoading = true;
    });
    String fileName = userProvider.getUserId;

    Reference storageReference = FirebaseStorage.instance.ref().child('photos/profils_Medecins/$fileName'); //.child('photos/profils_adherents/$fileName');
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Photo de profil ajoutée")));
      String url = await storageReference.getDownloadURL();
      avatarUrl = url;
      print("download url: $url");
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("download url: $url")));
    });
    setState(() {
      imageLoading = false;
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        imageFileAvatar = File(pickedFile.path);
        //imageLoading = true;
      } else {
        print('No image selected.');
      }
    });
    uploadImageToFirebase(pickedFile);
  }

  Future getImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        imageFileAvatar = File(pickedFile.path);
        //imageLoading = true;
      } else {
        print('No image selected.');
      }
    });
    uploadImageToFirebase(pickedFile);
  }
}