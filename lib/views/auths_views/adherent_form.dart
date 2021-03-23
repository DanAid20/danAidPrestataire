import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:danaid/widgets/clippers.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:provider/provider.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/core/services/getCities.dart';

class AdherentRegistrationFormm extends StatefulWidget {
  @override
  _AdherentRegistrationFormmState createState() => _AdherentRegistrationFormmState();
}

class _AdherentRegistrationFormmState extends State<AdherentRegistrationFormm> {
  final GlobalKey<FormState> _adherentFormKey = GlobalKey<FormState>();
  TextEditingController _familynameController = new TextEditingController();
  TextEditingController _surnameController = new TextEditingController();
  TextEditingController _regionController = new TextEditingController();
  TextEditingController _townController = new TextEditingController();
  bool autovalidate = false;
  String _gender = "H";
  String _region = "Centre";
  List<String> myCities = [];
  String _city;
  String _stateCode;
  bool regionChosen = false;
  bool cityChosen = false;
  bool _serviceTermsAccepted = false;
  String termsAndConditions = "Le médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\n\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la s";
  DateTime selectedDate = DateTime(1990);
  File imageFileAvatar;
  bool imageLoading = false;
  bool buttonLoading = false;
  String avatarUrl;
  @override
  Widget build(BuildContext context) {
    AdherentProvider adherentProvider = Provider.of<AdherentProvider>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: kPrimaryColor
      ),
      child: Scaffold(
        body: ListView(
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
                          child: imageFileAvatar == null ? Icon(LineIcons.user, color: Colors.white, size: wv*25,) : Container(),
                          backgroundImage: imageFileAvatar == null ? null : FileImage(imageFileAvatar),
                        ),
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
              key: _adherentFormKey,
              autovalidateMode: autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
              child: Column(children: [
                SizedBox(height: hv*6,),

                CustomTextField(
                  label: "Nom de Famille *",
                  hintText: "Entrez votre nom de famille",
                  controller: _familynameController,
                  validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                ),
                SizedBox(height: hv*1.5,),
                CustomTextField(
                  label: "Prénom (s)",
                  hintText: "Entrez votre prénom",
                  controller: _surnameController,
                  validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                ),
                SizedBox(height: hv*1.5,),
                Row(
                  children: [
                    SizedBox(width: wv*3,),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Genre *", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
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
                                value: _gender,
                                items: [
                                  DropdownMenuItem(
                                    child: Text("Masculin", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                    value: "H",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Féminin", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                    value: "F",
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                }),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: wv*5,),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date de naissance *", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                          SizedBox(height: 5,),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: Row(children: [
                                SvgPicture.asset("assets/icons/Bulk/CalendarLine.svg", color: kDeepTeal,),
                                VerticalDivider(),
                                Text( "${selectedDate.toLocal()}".split(' ')[0], style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.bold),),
                              ],),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: wv*3,),
                  ],
                ),
                SizedBox(height: hv*1.5,),
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
                                    adherentProvider.setRegionOfOrigin(getRegionFromStateCode(regions, value));
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
                          Text("Choix de la ville", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
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
                                  hint: Text("Ville"),
                                  items: getTownNamesFromRegion(cities, _stateCode).map((city){
                                    print("city: "+city);
                                    return DropdownMenuItem(
                                      child: Text(city, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                      value: city,
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    adherentProvider.setTown(value);
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
                SizedBox(height: hv*1.5,),
                /*Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: CustomTextField(
                        label: "Region",
                        hintText: "ex: Centre",
                        controller: _regionController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                        //svgIcon: "assets/icons/Bulk/Discovery.svg",
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: CustomTextField(
                        label: "Ville",
                        hintText: "ex: Yaoundé",
                        controller: _townController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                      ),
                    ),
                  ],
                ),*/
              ],)
            ),
            /*Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                List<String> myList = getTownNamesFromList(towns);
                return myList.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                }).toList();
              },
              onSelected: (String selection) {
                print('Selected $selection.');
              },
            ),*/

            SizedBox(height: hv*1,),
            CheckboxListTile(
              tristate: false,
              title: Row(children: [
                Text("Lu et accepté les "),
                InkWell(child: Text("termes des services", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600, decoration: TextDecoration.underline,)), 
                  onTap: (){
                    showDialog(context: context, 
                    builder: (BuildContext context){
                      return termsAndConditionsDialog();
                    }
                    );
                  },)
              ],),
              value: _serviceTermsAccepted,
              activeColor: primaryColor,
              onChanged: (newValue) {
                setState(() {
                  _serviceTermsAccepted = newValue;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            imageLoading ? Loaders().buttonLoader(kPrimaryColor) : Container(),
            (_serviceTermsAccepted & cityChosen) ?  
            !buttonLoading ? CustomTextButton(
              text: "Envoyer",
              color: kPrimaryColor,
              action: () async {
                UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                setState(() {
                  autovalidate = true;
                });
                String fname = _familynameController.text;
                String sname = _surnameController.text;
                if (_adherentFormKey.currentState.validate()){
                  setState(() {
                    buttonLoading = true;
                  });
                  AdherentProvider adherentProvider = Provider.of<AdherentProvider>(context, listen: false);
                  print("$fname, $sname, $selectedDate, $_gender, $avatarUrl");
                  print("${Algorithms().getMatricule(selectedDate, "Centre", _gender)}");
                  adherentProvider.setAdherentId(userProvider.getUserId);
                  adherentProvider.setFamilyName(fname);
                  adherentProvider.setSurname(sname);
                  adherentProvider.setBirthDate(selectedDate);
                  adherentProvider.setImgUrl(avatarUrl);
                  await FirebaseFirestore.instance.collection("USERS")
                    .doc(userProvider.getUserId)
                    .set({
                      'fullName': "$fname $sname",
                      "imageUrl" : avatarUrl,
                      "matricule": Algorithms().getMatricule(selectedDate, adherentProvider.getRegionOfOrigin, _gender),
                      "profil": "ADHERENT",
                      "regionDorigione": adherentProvider.getRegionOfOrigin
                    }, SetOptions(merge: true))
                    .then((value) async {
                      await FirebaseFirestore.instance.collection("ADHERENTS")
                        .doc(userProvider.getUserId)
                        .set({
                          "createdDate": DateTime.now(),
                          "authPhoneNumber": userProvider.getUserId,
                          "enabled": userProvider.isEnabled,
                          "dateNaissance": selectedDate,
                          "genre": _gender,
                          "imageUrl" : avatarUrl,
                          "matricule": Algorithms().getMatricule(selectedDate, adherentProvider.getRegionOfOrigin, _gender),
                          "phoneList": FieldValue.arrayUnion([{"number": userProvider.getUserId}]),
                          "nbBeneficiare": 0,
                          "nombreEnfant": 0,
                          "nomFamille": fname,
                          "prenom": sname,
                          "profil": "ADHERENT",
                          "profilEnabled": false,
                          "protectionLevel": adherentProvider.getAdherentPlan,
                          "regionDorigione": adherentProvider.getRegionOfOrigin,
                          "statuMatrimonialMarie": false,
                          "ville": adherentProvider.getTown,
                        }, SetOptions(merge: true))
                        .then((value) async {
                          await HiveDatabase.setRegisterState(true);
                          HiveDatabase.setFamilyName(fname);
                          HiveDatabase.setSurname(sname);
                          HiveDatabase.setGender(_gender);
                          HiveDatabase.setImgUrl(avatarUrl);
                          Navigator.pushNamed(context, '/home');
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
/*
                await FirebaseFirestore.instance.collection("USERS")
                  .doc(userProvider.getUserId)
                  .set({
                    //'createdDate': DateTime.now(),
                    //'emailAdress': userProvider.getEmail,
                    //'enabled': userProvider.isEnabled,
                    'fullName': sname + ' ' + fname,
                    "imageUrl" : null,
                    "matricule": Algorithms().getMatricule(selectedDate, "Centre", _gender),
                    //"phoneList": FieldValue.arrayUnion([{"number": userProvider.getUserId}]),
                    "profil": "ADHERENT",
                    "regionDorigione": "",
                    //"urlCNI": "",
                    //"userCountryCodeIso": userProvider.getCountryCode.toLowerCase(),
                    //"userCountryName": userProvider.getCountryName
                  }, SetOptions(merge: true))
                  .then((value) => Navigator.pushNamed(context, '/home'));
*/

              },
            ) : Loaders().buttonLoader(kPrimaryColor) :
            CustomDisabledTextButton(
              text: "Envoyer",
            )
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget termsAndConditionsDialog(){
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*1),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: hv*2,),
                  Text("Termes de services", style: TextStyle(fontSize: wv*6, fontWeight: FontWeight.w900, color: kPrimaryColor),),
                  SizedBox(height: hv*2,),
                  Expanded(child: SingleChildScrollView(child: Text(termsAndConditions), physics: BouncingScrollPhysics(),)),
                ],
              ),
            ),
            CustomTextButton(
              text: "Fermer",
              color: kPrimaryColor,
              action: () => Navigator.pop(context),
            )
          ],
        ),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Photo de profil ajoutée")));
      String url = await storageReference.getDownloadURL();
      avatarUrl = url;
      print("download url: $url");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("download url: $url")));
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

  List towns = [
    {
      "objectId": "nQvoL0apr2",
      "name": "Abong Mbang",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "358qOuakct",
      "name": "Akom II",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "QDmWjo3Wky",
      "name": "Akono",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "alWwq4ozHa",
      "name": "Akonolinga",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "oWqHCGBVjg",
      "name": "Ambam",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "QKEWCfaHs4",
      "name": "Babanki",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "HbK5MA4ADk",
      "name": "Bafang",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "gBteXn6J4E",
      "name": "Bafia",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "sDHroWBLPg",
      "name": "Bafoussam",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "ilGxDgVL0L",
      "name": "Bali",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "3bZq1TkRVu",
      "name": "Bamenda",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "KgWPFPJpp3",
      "name": "Bamendjou",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "1k21d2cEaU",
      "name": "Bamusso",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "SjSlGo9hQb",
      "name": "Bana",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "iTUw4kUvuS",
      "name": "Bandjoun",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "dnCAqpjftA",
      "name": "Bangangté",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "5J5zZvaWXp",
      "name": "Bankim",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "xMRg3y30Cp",
      "name": "Bansoa",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "8fSU6LCJGA",
      "name": "Banyo",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "3OS6QnopdB",
      "name": "Batibo",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "yGjwjAZGOz",
      "name": "Batouri",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "VK8UKIbnKy",
      "name": "Bazou",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "4WkPvdLdeT",
      "name": "Bekondo",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "xpov253iiE",
      "name": "Belo",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "VE3nc53QnQ",
      "name": "Bertoua",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "pIXjFADTg3",
      "name": "Bogo",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "rRc2INHVqP",
      "name": "Bonabéri",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "BgLPHz84oI",
      "name": "Buea",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "KkZJBQwJza",
      "name": "Bélabo",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "yfDZj1gA58",
      "name": "Bélel",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "FScL6nKDbE",
      "name": "Bétaré Oya",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "qFCTdgtxRN",
      "name": "Diang",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "aUFk5LktOT",
      "name": "Dibombari",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "qg9GsDhqoA",
      "name": "Dimako",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "HvBld1dGYz",
      "name": "Dizangué",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "gW6FbwKxFA",
      "name": "Djohong",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "vEB8bWS3oL",
      "name": "Douala",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "Xt0j7W7OWm",
      "name": "Doumé",
      "createdAt": "2019-12-09T21:27:17.384Z",
      "updatedAt": "2019-12-09T21:27:17.384Z"
    },
    {
      "objectId": "bEsxUPzDQJ",
      "name": "Dschang",
      "createdAt": "2019-12-09T21:27:17.383Z",
      "updatedAt": "2019-12-09T21:27:17.383Z"
    },
    {
      "objectId": "V2uGTqOToh",
      "name": "Edéa",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "ZWWInJqsCF",
      "name": "Essé",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "EGq4QJCiCW",
      "name": "Eséka",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "GmC5yF909m",
      "name": "Fontem",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "QiPd6ihzZw",
      "name": "Foumban",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "KHzF4Qf6MS",
      "name": "Foumbot",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "7Tvm52If5E",
      "name": "Fundong",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "RI3m8rJdo6",
      "name": "Garoua",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "NrIJz6dylb",
      "name": "Garoua Boulaï",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "KxK01mdt4G",
      "name": "Guider",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "KSBAxz2qe9",
      "name": "Idenao",
      "createdAt": "2019-12-09T21:27:18.422Z",
      "updatedAt": "2019-12-09T21:27:18.422Z"
    },
    {
      "objectId": "bPWfzHjZAt",
      "name": "Jakiri",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "WIX08snrst",
      "name": "Kaélé",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "TombFbYa3T",
      "name": "Kontcha",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "HFlGJS5KXq",
      "name": "Kousséri",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "XFANQg04Ev",
      "name": "Koza",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "TP2bNQqF8P",
      "name": "Kribi",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "qGknMZJHra",
      "name": "Kumba",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "nHx5ZwnhnU",
      "name": "Kumbo",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    },
    {
      "objectId": "y4V7H8qnlY",
      "name": "Lagdo",
      "createdAt": "2019-12-09T21:27:16.101Z",
      "updatedAt": "2019-12-09T21:27:16.101Z"
    },
    {
      "objectId": "GuhTYXBEDs",
      "name": "Limbe",
      "createdAt": "2019-12-09T21:27:16.101Z",
      "updatedAt": "2019-12-09T21:27:16.101Z"
    },
    {
      "objectId": "Cu2osuXoNz",
      "name": "Lolodorf",
      "createdAt": "2019-12-09T21:27:16.101Z",
      "updatedAt": "2019-12-09T21:27:16.101Z"
    },
    {
      "objectId": "dhSD8Iqw70",
      "name": "Loum",
      "createdAt": "2019-12-09T21:27:16.101Z",
      "updatedAt": "2019-12-09T21:27:16.101Z"
    },
    {
      "objectId": "NmxRMbOsLy",
      "name": "Makary",
      "createdAt": "2019-12-09T21:27:16.101Z",
      "updatedAt": "2019-12-09T21:27:16.101Z"
    },
    {
      "objectId": "bQszhs5rxt",
      "name": "Mamfe",
      "createdAt": "2019-12-09T21:27:16.101Z",
      "updatedAt": "2019-12-09T21:27:16.101Z"
    },
    {
      "objectId": "ErKaz5uaqC",
      "name": "Manjo",
      "createdAt": "2019-12-09T21:27:16.101Z",
      "updatedAt": "2019-12-09T21:27:16.101Z"
    },
    {
      "objectId": "yBCF3Hj8IE",
      "name": "Maroua",
      "createdAt": "2019-12-09T21:27:16.101Z",
      "updatedAt": "2019-12-09T21:27:16.101Z"
    },
    {
      "objectId": "ajxVbOHFvf",
      "name": "Mbalmayo",
      "createdAt": "2019-12-09T21:27:16.101Z",
      "updatedAt": "2019-12-09T21:27:16.101Z"
    },
    {
      "objectId": "tYJp6DGJui",
      "name": "Mbandjok",
      "createdAt": "2019-12-09T21:27:16.101Z",
      "updatedAt": "2019-12-09T21:27:16.101Z"
    },
    {
      "objectId": "XNxayWb2Cb",
      "name": "Mbang",
      "createdAt": "2019-12-09T21:27:16.101Z",
      "updatedAt": "2019-12-09T21:27:16.101Z"
    },
    {
      "objectId": "t2XhSmZalu",
      "name": "Mbanga",
      "createdAt": "2019-12-09T21:27:16.101Z",
      "updatedAt": "2019-12-09T21:27:16.101Z"
    },
    {
      "objectId": "33KlAxM6XG",
      "name": "Mbankomo",
      "createdAt": "2019-12-09T21:27:16.101Z",
      "updatedAt": "2019-12-09T21:27:16.101Z"
    },
    {
      "objectId": "erUXieaDhR",
      "name": "Mbengwi",
      "createdAt": "2019-12-09T21:27:16.100Z",
      "updatedAt": "2019-12-09T21:27:16.100Z"
    },
    {
      "objectId": "mlT2fRFPcg",
      "name": "Mbouda",
      "createdAt": "2019-12-09T21:27:16.100Z",
      "updatedAt": "2019-12-09T21:27:16.100Z"
    },
    {
      "objectId": "P5FTGzEA6b",
      "name": "Melong",
      "createdAt": "2019-12-09T21:27:16.100Z",
      "updatedAt": "2019-12-09T21:27:16.100Z"
    },
    {
      "objectId": "eIiVPJswgz",
      "name": "Meïganga",
      "createdAt": "2019-12-09T21:27:16.100Z",
      "updatedAt": "2019-12-09T21:27:16.100Z"
    },
    {
      "objectId": "eHMknDplAW",
      "name": "Mindif",
      "createdAt": "2019-12-09T21:27:16.100Z",
      "updatedAt": "2019-12-09T21:27:16.100Z"
    },
    {
      "objectId": "q65Jp0xKPz",
      "name": "Minta",
      "createdAt": "2019-12-09T21:27:16.100Z",
      "updatedAt": "2019-12-09T21:27:16.100Z"
    },
    {
      "objectId": "Rl13l6KQHB",
      "name": "Mme-Bafumen",
      "createdAt": "2019-12-09T21:27:16.100Z",
      "updatedAt": "2019-12-09T21:27:16.100Z"
    },
    {
      "objectId": "G7MlWswMal",
      "name": "Mokolo",
      "createdAt": "2019-12-09T21:27:15.496Z",
      "updatedAt": "2019-12-09T21:27:15.496Z"
    },
    {
      "objectId": "9F00TBz1AT",
      "name": "Mora",
      "createdAt": "2019-12-09T21:27:15.496Z",
      "updatedAt": "2019-12-09T21:27:15.496Z"
    },
    {
      "objectId": "sFTwc6F0I5",
      "name": "Mouanko",
      "createdAt": "2019-12-09T21:27:15.496Z",
      "updatedAt": "2019-12-09T21:27:15.496Z"
    },
    {
      "objectId": "Db5hxGABix",
      "name": "Mundemba",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "6sw29F5tFT",
      "name": "Mutengene",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "MP7A7mhAAY",
      "name": "Muyuka",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "Axh5x1TgJa",
      "name": "Mvangué",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "m4FhHwnvFh",
      "name": "Nanga Eboko",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "druOp8KwnJ",
      "name": "Ndelele",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "stfmf1kIiK",
      "name": "Ndikiniméki",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "MHSNLlwkBP",
      "name": "Ndom",
      "createdAt": "2019-12-09T21:27:18.422Z",
      "updatedAt": "2019-12-09T21:27:18.422Z"
    },
    {
      "objectId": "cMFPcjzgzE",
      "name": "Ngambé",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "AhjtK6212t",
      "name": "Ngaoundéré",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "xVR10Cdk3C",
      "name": "Ngomedzap",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "L69NMVlRGv",
      "name": "Ngoro",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "YxlFfEIgvU",
      "name": "Ngou",
      "createdAt": "2019-12-09T21:27:17.967Z",
      "updatedAt": "2019-12-09T21:27:17.967Z"
    },
    {
      "objectId": "ZCUPthI8ht",
      "name": "Nguti",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "4ZxXgovcV6",
      "name": "Njinikom",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "wv0IjUnAcf",
      "name": "Nkongsamba",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "q0padYRAAX",
      "name": "Nkoteng",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "ymjFBVOENh",
      "name": "Ntui",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "gtgBwgoXaE",
      "name": "Obala",
      "createdAt": "2019-12-09T21:27:15.495Z",
      "updatedAt": "2019-12-09T21:27:15.495Z"
    },
    {
      "objectId": "upxVWcifnY",
      "name": "Okoa",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "grF4IygCJY",
      "name": "Okola",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "oAHJG0auM5",
      "name": "Ombésa",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "ZY7sJTo9V3",
      "name": "Penja",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "GetuUJUkcE",
      "name": "Pitoa",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "uwGMRQQAhB",
      "name": "Poli",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "yPK9IcDeyx",
      "name": "Rey Bouba",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "RIUnH7uigf",
      "name": "Saa",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "i24XNyDxBy",
      "name": "Sangmélima",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "EEjjLnRFrN",
      "name": "Somié",
      "createdAt": "2019-12-09T21:27:18.422Z",
      "updatedAt": "2019-12-09T21:27:18.422Z"
    },
    {
      "objectId": "RpQzhRDVmB",
      "name": "Tcholliré",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "fzA2hJwcI8",
      "name": "Tibati",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "mbheudvXtu",
      "name": "Tignère",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "HPRVHNQj3B",
      "name": "Tiko",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "GiosEhx6vA",
      "name": "Tonga",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "wc8M6OUKad",
      "name": "Wum",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "0rANOBpXdM",
      "name": "Yabassi",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "5T0E96IDe9",
      "name": "Yagoua",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "4H7Ffwbntv",
      "name": "Yaoundé",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "XXlNBSg3pt",
      "name": "Yokadouma",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "eYtMrJXa5r",
      "name": "Yoko",
      "createdAt": "2019-12-09T21:27:14.907Z",
      "updatedAt": "2019-12-09T21:27:14.907Z"
    },
    {
      "objectId": "OvXFr6yHba",
      "name": "Ébolowa",
      "createdAt": "2019-12-09T21:27:17.383Z",
      "updatedAt": "2019-12-09T21:27:17.383Z"
    },
    {
      "objectId": "t7JGaldfvv",
      "name": "Évodoula",
      "createdAt": "2019-12-09T21:27:16.730Z",
      "updatedAt": "2019-12-09T21:27:16.730Z"
    }
  ];

}