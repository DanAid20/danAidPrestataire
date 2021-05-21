import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:danaid/widgets/clippers.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/core/services/getCities.dart';
import 'package:danaid/widgets/file_upload_card.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {

  final GlobalKey<FormState> _adherentEditFormKey = GlobalKey<FormState>();
  TextEditingController _familynameController = new TextEditingController();
  TextEditingController _surnameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _cniNameController = new TextEditingController();
  TextEditingController _professionController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  bool autovalidate = false;
  String _region;
  List<String> myCities = [];
  String _city;
  String _stateCode;
  bool regionChosen = false;
  bool cityChosen = false;
  DateTime selectedDate = DateTime(1990);
  File imageFileAvatar;
  bool imageLoading = false;
  bool buttonLoading = false;
  String avatarUrl;
  bool surnameEnabled = true;
  bool nameEnabled = true;
  bool emailEnabled = true;
  bool cniNameEnabled = true;
  bool professionEnabled = true;
  bool addressEnabled = true;
  Map<String, dynamic> gpsCoords;
  bool isMarried = false;
  bool askMarriageCertificate = false;
  bool marriageCertificateUploaded = false;
  bool cniUploaded = false;
  bool otherFileUploaded = false;
  bool marriageCertificateSpinner = false;
  bool cniSpinner = false;
  bool otherFileSpinner = false;
  bool imageSpinner = false;
  bool positionSpinner = false;

  LatLng _initialcameraposition = LatLng(4.044656688777058, 9.695724531228858);
  GoogleMapController _controller;
  Location _location = Location();
  
  void _initializeMap(){
    _location.getLocation().then((loc) {
      setState(() {
        _initialcameraposition = LatLng(loc.latitude, loc.longitude);
      });
    });
  }

  void _saveLocation(){
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
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
      adherentProvider.setLocation(gpsCoords);
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
    /*_location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 18)),

    );});*/
    _location.onLocationChanged.listen((loc) { 
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
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    setState(() {
      _stateCode = getStateCodeFromRegion(regions, adherentProvider.getAdherent.regionOfOrigin);
      _region = adherentProvider.getAdherent.regionOfOrigin;
      regionChosen = true;
    cityChosen = true;
    
    _city = adherentProvider.getAdherent.town;
    });
    
  }

  textFieldsControl (){

    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);

    if((adherentProvider.getAdherent.surname != null) & (adherentProvider.getAdherent.surname != "")){
      setState(() {
        _surnameController.text = adherentProvider.getAdherent.surname;
        surnameEnabled = false; 
      });
    }
    if((adherentProvider.getAdherent.familyName != null) & (adherentProvider.getAdherent.familyName != "")){
      setState(() {
        _familynameController.text = adherentProvider.getAdherent.familyName;
        nameEnabled = false;
      });
    }
    if((adherentProvider.getAdherent.cniName != null) & (adherentProvider.getAdherent.cniName != "")){
      setState(() {
        _cniNameController.text = adherentProvider.getAdherent.cniName;
        cniNameEnabled = false;
      });
    }
    if((adherentProvider.getAdherent.email != null) & (adherentProvider.getAdherent.email != "")){
      setState(() {
        _emailController.text = adherentProvider.getAdherent.email;
        emailEnabled = false;
      });
    }
    if((adherentProvider.getAdherent.profession != null) & (adherentProvider.getAdherent.profession != "")){
      setState(() {
        _professionController.text = adherentProvider.getAdherent.profession;
        professionEnabled = false;
      });
    }
    if((adherentProvider.getAdherent.address != null) & (adherentProvider.getAdherent.address != "")){
      setState(() {
        _addressController.text = adherentProvider.getAdherent.address;
        addressEnabled = false;
      });
    }
    
    print("inside");
    if (adherentProvider.getAdherent.location != null){
      print(adherentProvider.getAdherent.location.toString() +"inside+");
      if ((adherentProvider.getAdherent.location["latitude"] != null) | (adherentProvider.getAdherent.location["longitude"] != null) | true){
        setState(() {
          gpsCoords = {
          "latitude": adherentProvider.getAdherent.location["latitude"],
          "longitude": adherentProvider.getAdherent.location["longitude"]
        };
        print(gpsCoords.toString());
        });
      }
    }
    if(adherentProvider.getAdherent.isMarried != null){
      setState(() {
        isMarried = adherentProvider.getAdherent.isMarried;
      });
    }

    if((adherentProvider.getAdherent.marriageCertificateUrl != "") & (adherentProvider.getAdherent.marriageCertificateUrl != null)){
      setState(() {
        marriageCertificateUploaded = true;
      });
    }
    if((adherentProvider.getAdherent.officialDocUrl != "") & (adherentProvider.getAdherent.officialDocUrl != null)){
      setState(() {
        cniUploaded = true;
      });
    }
    if((adherentProvider.getAdherent.otherJustificativeDocsUrl != "") & (adherentProvider.getAdherent.otherJustificativeDocsUrl != null)){
      setState(() {
        otherFileUploaded = true;
      });
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
    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: hv*1, automaticallyImplyLeading: false, backgroundColor: kPrimaryColor.withOpacity(0.99)),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    child: Column(
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
                                color: kPrimaryColor.withOpacity(0.6)
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
                                      padding: EdgeInsets.all(20.0),
                                    ),
                                    imageUrl: adherentModelProvider.getAdherent.imgUrl,),
                                ),
                                  //backgroundImage: CachedNetworkImageProvider(adherentModelProvider.getAdherent.imgUrl),
                              ),

                              imageSpinner ? Positioned(
                                top: hv*7,
                                right: wv*13,
                                child: CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(whiteColor),)
                              ) : Container(),

                              Positioned(
                                bottom: 2,
                                right: 5,
                                child: CircleAvatar(
                                  backgroundColor: kDeepTeal,
                                  radius: wv*5,
                                  child: IconButton(icon: Icon(Icons.add, color: whiteColor,), color: kPrimaryColor, onPressed: (){getImage(context);}),
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
                                child: Icon(Icons.arrow_back_ios_rounded),
                              ),
                            ),
                          )
                        ], alignment: AlignmentDirectional.topCenter,)
                      ],
                    ),
                  ),
                  Form(
                    key: _adherentEditFormKey,
                    //autovalidateMode:  AutovalidateMode.always, //autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    child: Column(children: [
                      SizedBox(height: hv*6,),

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
                      SizedBox(height: hv*2.5,),
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
                      SizedBox(height: hv*2.5,),
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
                      SizedBox(height: hv*2.5,),
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
                      SizedBox(height: hv*2.5,),
                      CustomTextField(
                        prefixIcon: Icon(MdiIcons.accountTieOutline, color: kPrimaryColor),
                        label: "Profession",
                        hintText: "ex: Méchanicien",
                        enabled: professionEnabled,
                        controller: _professionController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                        editAction: (){
                          setState(() {
                            professionEnabled = true;
                          });
                        },
                      ),
                      SizedBox(height: hv*2,),
                      Divider(),
                      SizedBox(height: hv*2,),
                      Row(
                        children: [
                          SizedBox(width: wv*3,),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Region", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
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
                                        value: _stateCode,
                                        hint: Text("Choisir une region"),
                                        items: regions.map((region){
                                          return DropdownMenuItem(
                                            child: SizedBox(child: Text(region["value"], style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)), width: wv*50,),
                                            value: region["key"],
                                          );
                                        }).toList(),
                                        onChanged: (value) async {
                                          //List<String> reg = getTownNamesFromRegion(cities, value);
                                          adherentModelProvider.setRegionOfOrigin(getRegionFromStateCode(regions, value));
                                          setState(() {
                                            _stateCode = value;
                                            _region = getRegionFromStateCode(regions, value);
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
                          regionChosen ? Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ville", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
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
                                        value: _city,
                                        hint: Text( (adherentModelProvider.getAdherent.town != "") & (regionChosen == false) ? adherentModelProvider.getAdherent.town : "Ville", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                        items: getTownNamesFromRegion(cities, _stateCode).map((city){
                                          return DropdownMenuItem(
                                            child: Text(city, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                            value: city,
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          adherentModelProvider.setTown(value);
                                          setState(() {
                                            _city = value;
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
                        prefixIcon: Icon(MdiIcons.homeCityOutline, color: kPrimaryColor),
                        label: "Addresse",
                        hintText: "ex: carrefour Obili",
                        enabled: addressEnabled,
                        controller: _addressController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                        editAction: (){
                          setState(() {
                            addressEnabled = true;
                          });
                        },
                      ),
                      SizedBox(height: hv*4,),
                      (gpsCoords != null) | (adherentModelProvider.getAdherent.location != null) ? Container(margin: EdgeInsets.symmetric(horizontal: wv*4),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("GPS:", style: TextStyle(fontWeight: FontWeight.w900),),
                            RichText(text: TextSpan(
                              text: "Lat: ",
                              children: [
                                TextSpan(text: (gpsCoords != null) ? gpsCoords["latitude"].toString() : adherentModelProvider.getAdherent.location["latitude"], style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryColor)),
                                TextSpan(text: "     Lng: "),
                                TextSpan(text: (gpsCoords != null) ? gpsCoords["longitude"].toString() : adherentModelProvider.getAdherent.location["longitude"], style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryColor))
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
                                initialCameraPosition: CameraPosition(target: adherentModelProvider.getAdherent.location == null ? _initialcameraposition : LatLng(adherentModelProvider.getAdherent.location["latitude"] != null ? adherentModelProvider.getAdherent.location["latitude"] : _initialcameraposition.latitude, adherentModelProvider.getAdherent.location["longitude"] != null ? adherentModelProvider.getAdherent.location["longitude"] : _initialcameraposition.longitude), zoom: 11.0),
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
                      Divider(),
                      SizedBox(height: hv*2),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: wv*3),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Statut Matrimoniale", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w500),),
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
                                    hint: Text("Choisir"),
                                    value: isMarried,
                                    items: [
                                      DropdownMenuItem(
                                        child: Text("Célibataire", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                        value: false,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("Marrié (e)", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                        value: true,
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        isMarried = value;
                                      });
                                      if(value == true){
                                        setState(() {
                                          askMarriageCertificate = true;
                                        });
                                      }
                                    }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: hv*1.5,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: wv*3),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pièces justificatives", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w600),),
                            SizedBox(height: hv*1,),
                            Column(
                              children: [
                                isMarried ? FileUploadCard(
                                  title: "Acte de Marriage",
                                  state: marriageCertificateUploaded,
                                  loading: marriageCertificateSpinner,
                                  action: () async {await getDocFromPhone('Acte_De_Marriage');}
                                ) : Container(),
                                FileUploadCard(
                                  title: "Scan de la CNI",
                                  state: cniUploaded,
                                  loading: cniSpinner,
                                  action: () async {await getDocFromPhone('CNI');}
                                ),
                                FileUploadCard(
                                  title: "Autre pièce justificative",
                                  state: otherFileUploaded,
                                  loading: otherFileSpinner,
                                  action: () async {await getDocFromPhone('Pièce_Justificative_Supplémentaire');}
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: hv*3,)
                    ],)
                  ),
                  imageLoading ? Loaders().buttonLoader(kPrimaryColor) : Container(),
                ],
              ),
            ),
            Container(
              child: (cityChosen) ?  
                !buttonLoading ? CustomTextButton(
                  text: "Mettre à jour",
                  color: kPrimaryColor,
                  action: () async {
                    setState(() {
                      autovalidate = true;
                    });
                    String fname = _familynameController.text;
                    String sname = _surnameController.text;
                    String cniName = _cniNameController.text;
                    String email = _emailController.text;
                    String address = _addressController.text;
                    String profession =_professionController.text;
                    if (_adherentEditFormKey.currentState.validate()){
                      setState(() {
                        buttonLoading = true;
                      });
                      AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
                      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                      print("$fname, $sname, $avatarUrl");
                      adherentProvider.setFamilyName(fname);
                      adherentProvider.setSurname(sname);
                      adherentProvider.setEmail(email);
                      adherentProvider.setProfession(profession);
                      adherentProvider.setAddress(address);
                      adherentProvider.setCniName(cniName);
                      userProvider.enable(true);
                      await FirebaseFirestore.instance.collection("USERS")
                        .doc(adherentProvider.getAdherent.getAdherentId)
                        .set({
                          "authId": FirebaseAuth.instance.currentUser.uid,
                          'emailAdress': email,
                          'fullName': cniName,
                          "enable": true,
                          "regionDorigione": _region,
                          "phoneKeywords": Algorithms.getKeyWords(adherentProvider.getAdherent.getAdherentId),
                          "nameKeywords": Algorithms.getKeyWords(fname + " "+ sname)
                        }, SetOptions(merge: true))
                        .then((value) async {
                          await FirebaseFirestore.instance.collection("ADHERENTS")
                            .doc(adherentProvider.getAdherent.getAdherentId)
                            .set({
                              "authId": FirebaseAuth.instance.currentUser.uid,
                              "dateCreated": DateTime.now(),
                              "cniName": cniName,
                              "emailAdress": email,
                              "adresse": address,
                              "profession": profession,
                              "acteMariageName": cniName,
                              "nomFamille": fname,
                              "prenom": sname,
                              "regionDorigione": _region,
                              "statuMatrimonialMarie": isMarried,
                              "ville": _city == null ? adherentProvider.getAdherent.town : _city,
                              "localisation": gpsCoords != null ? {
                                "addresse": address,
                                "latitude": gpsCoords["latitude"],
                                "longitude": gpsCoords["longitude"],
                                "altitude": 0
                              } : {
                                "addresse": address,
                              },
                                "phoneKeywords": Algorithms.getKeyWords(adherentProvider.getAdherent.getAdherentId),
                                "nameKeywords": Algorithms.getKeyWords(fname + " "+ sname)
                            }, SetOptions(merge: true))
                            .then((value) async {
                              textFieldsControl();
                              await HiveDatabase.setRegisterState(true);
                              HiveDatabase.setFamilyName(fname);
                              HiveDatabase.setSurname(sname);
                              HiveDatabase.setImgUrl(avatarUrl);

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Informations mises à jour..")));
                              Navigator.pop(context);
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
                ) : Loaders().buttonLoader(kPrimaryColor) :
                CustomDisabledTextButton(
                  text: "Mettre à Jour",
                )
            ,)
          ],
        ),
      ),
    );
  }

  Future getDocFromPhone(String name) async {

    setState(() {
      if (name == "Acte_De_Marriage") {
        marriageCertificateSpinner = true;
      } else if (name == "CNI"){
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
    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucune image selectionnée'),));
      return null;
    }
    
    String adherentId = adherentModelProvider.getAdherent.adherentId;
    Reference storageReference = FirebaseStorage.instance.ref().child('pieces_didentite/piece_adherents/$adherentId/$name'); //.child('photos/profils_adherents/$fileName');
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
      if(name == "Acte_De_Marriage"){
        adherentModelProvider.setMarriageCertificateUrl(url);
        FirebaseFirestore.instance.collection("ADHERENTS")
        .doc(adherentModelProvider.getAdherent.adherentId)
        .set({
          "urlActeMariage": url,
          "statuMatrimonialMarie": true,
        }, SetOptions(merge: true)).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Document Sauvegardé")));
          setState(() {
            marriageCertificateUploaded = true;
            marriageCertificateSpinner = false;
          });
        });
      }
      else if (name == "CNI"){
        adherentModelProvider.setOfficialDocUrl(url);
        FirebaseFirestore.instance.collection("ADHERENTS")
        .doc(adherentModelProvider.getAdherent.adherentId)
        .set({
          "urlDocOficiel": url,
        }, SetOptions(merge: true)).then((value) {
          FirebaseFirestore.instance.collection("USERS")
            .doc(adherentModelProvider.getAdherent.adherentId)
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
        adherentModelProvider.setOtherJustificativeDocsUrl(url);
        FirebaseFirestore.instance.collection("ADHERENTS")
        .doc(adherentModelProvider.getAdherent.adherentId)
        .set({
          "urlAutrePiecesJustificatif": url,
        }, SetOptions(merge: true)).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Document Sauvegardé")));
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


  Future uploadImageToFirebase(PickedFile file) async {

    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);

    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucune image selectionnée'),));
      return null;
    }
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      imageLoading = true;
    });
    String fileName = userProvider.getUserId;

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
    
    storageUploadTask = storageReference.putFile(imageFileAvatar);

    storageUploadTask.catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
    });
    storageUploadTask.whenComplete(() async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Finalisation...")));
      String url = await storageReference.getDownloadURL();
      avatarUrl = url;
      HiveDatabase.setImgUrl(url);
      adherentModelProvider.setImgUrl(url);
      FirebaseFirestore.instance.collection("ADHERENTS")
        .doc(adherentModelProvider.getAdherent.adherentId)
        .update({
          "imageUrl": url,
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Photo de profil ajoutée")));
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

  Future getImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        imageSpinner = true;
        imageFileAvatar = File(pickedFile.path);
        //imageLoading = true;
      } else {
        print('No image selected.');
      }
    });
    uploadImageToFirebase(pickedFile);
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
    uploadImageToFirebase(pickedFile);
  }

  getImage(BuildContext context){
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext bc){
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Gallerie'),
                    onTap: () {
                      getImageFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
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

  String getRegionFromStateCode(List origin, String code){
    String region;
    for(int i=0; i<origin.length; i++){
      if (origin[i]["key"] == code){
       region = origin[i]["value"];
      }
    }
    return region;
  }
  String getStateCodeFromRegion(List origin, String region){
    String code;
    for(int i=0; i<origin.length; i++){
      if (origin[i]["value"] == region){
       code = origin[i]["key"];
      }
    }
    return code;
  }
}