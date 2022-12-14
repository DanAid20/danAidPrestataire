import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/danAid_default_header.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/core/services/getCities.dart';

class ServiceProviderForm extends StatefulWidget {
  @override
  _ServiceProviderFormState createState() => _ServiceProviderFormState();
}

class _ServiceProviderFormState extends State<ServiceProviderForm> {
  final GlobalKey<FormState> _adherentFormKey = GlobalKey<FormState>();
  TextEditingController _companyNameController = new TextEditingController();
  TextEditingController _contactNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  bool autovalidate = false;
  String _category = "Hôpital";
  String _region = "Centre";
  List<String> myCities = [];
  String _city;
  String _stateCode;
  bool regionChosen = false;
  bool cityChosen = false;
  bool _serviceTermsAccepted = false;
  String termsAndConditions = "Le médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\n\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la s";
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
        body: Column(
          children: [
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
                      child: imageFileAvatar == null ? Icon(LineIcons.building, color: Colors.white, size: wv*20,) : Container(),
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
              ], alignment: AlignmentDirectional.topCenter,),
            ),
            Expanded(
              child: ListView(
                children: [
                  Form(
                    key: _adherentFormKey,
                    autovalidateMode: autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    child: Column(children: [

                      CustomTextField(
                        prefixIcon: Icon(MdiIcons.officeBuildingOutline, color: kDeepTeal),
                        label: "Nom de l'établissement *",
                        hintText: "ex: Hôpial Centrale",
                        controller: _companyNameController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                      ),
                      SizedBox(height: hv*2.5,),
                      CustomTextField(
                        prefixIcon: Icon(Icons.account_circle_outlined, color: kDeepTeal,),
                        label: "Nom complet du contact *",
                        hintText: "Entrez votre nom",
                        controller: _contactNameController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                      ),
                      SizedBox(height: hv*2.5,),
                      CustomTextField(
                        prefixIcon: Icon(Icons.email_outlined, color: kDeepTeal,),
                        keyboardType: TextInputType.emailAddress,
                        label: "Email du contact",
                        hintText: "Entrez votre addresse email",
                        controller: _emailController,
                        validator: _emailFieldValidator,
                      ),
                      SizedBox(height: hv*2.5,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: wv*3),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                      SizedBox(height: hv*2.5,),
                    ],)
                  ),
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
                  
                ],
              ),
            ),
            Container(
              child: (_serviceTermsAccepted & cityChosen) ?  
                !buttonLoading ? CustomTextButton(
                  text: "Envoyer",
                  color: kPrimaryColor,
                  action: () async {
                    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                    setState(() {
                      autovalidate = true;
                    });
                    String companyName = _companyNameController.text;
                    String contactName = _contactNameController.text;
                    String email = _emailController.text;
                    if (_adherentFormKey.currentState.validate()){
                      setState(() {
                        buttonLoading = true;
                      });
                      AdherentProvider adherentProvider = Provider.of<AdherentProvider>(context, listen: false);
                      print("$companyName, $_category, $avatarUrl");
                      adherentProvider.setAdherentId(userProvider.getUserId);
                      adherentProvider.setImgUrl(avatarUrl);
                      //adherentProvider.setFamilyName(fname);
                      adherentProvider.setSurname(companyName);
                      await FirebaseFirestore.instance.collection("USERS")
                        .doc(userProvider.getUserId)
                        .set({
                          'createdDate': DateTime.now(),
                          "authId": FirebaseAuth.instance.currentUser.uid,
                          'emailAdress': userProvider.getEmail,
                          'enabled': userProvider.isEnabled,
                          "phoneList": FieldValue.arrayUnion([{"number": userProvider.getUserId}]),
                          "urlCNI": "",
                          "userCountryCodeIso": userProvider.getCountryCode.toLowerCase(),
                          "userCountryName": userProvider.getCountryName,
                          'fullName': "$companyName",
                          "imageUrl" : avatarUrl,
                          "profil": "PRESTATAIRE",
                          "points": 500,
                          "visitPoints": 0,
                          "regionDorigione": adherentProvider.getRegionOfOrigin,
                          "phoneKeywords": Algorithms.getKeyWords(userProvider.getUserId),
                          "nameKeywords": Algorithms.getKeyWords(companyName)
                        }, SetOptions(merge: true))
                        .then((value) async {
                          await FirebaseFirestore.instance.collection("PRESTATAIRE")
                            .doc(userProvider.getUserId)
                            .set({
                              "createdDate": DateTime.now(),
                              "authId": FirebaseAuth.instance.currentUser.uid,
                              "nomEtablissement": companyName,
                              "nomCompletPContact": contactName,
                              "emailPContact": email,
                              "authPhoneNumber": userProvider.getUserId,
                              "categorieEtablissement": _category,
                              "imageUrl" : avatarUrl,
                              "phoneList": FieldValue.arrayUnion([{"number": userProvider.getUserId}]),
                              "profil": "PRESTATAIRE",
                              "profilEnabled": false,
                              "region": adherentProvider.getRegionOfOrigin,
                              "villeEtab": adherentProvider.getTown,
                              "userCountryCodeIso": userProvider.getCountryCode.toLowerCase(),
                              "userCountryName": userProvider.getCountryName,
                              "phoneKeywords": Algorithms.getKeyWords(userProvider.getUserId),
                              "nameKeywords": Algorithms.getKeyWords(companyName)
                            }, SetOptions(merge: true))
                            .then((value) async {
                              HiveDatabase.setRegisterState(true);
                              HiveDatabase.setAuthPhone(userProvider.getUserId);
                              HiveDatabase.setSurname(companyName);
                              HiveDatabase.setImgUrl(avatarUrl);
                              setState(() {
                                buttonLoading = false;
                              });
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
                        });
                    }

                  },
                ) : Loaders().buttonLoader(kPrimaryColor) :
                CustomDisabledTextButton(
                  text: "Envoyer",
                )
            ),
          ],
        ),
      ),
    );
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

    Reference storageReference = FirebaseStorage.instance.ref().child('photos/profils_prestataires/$fileName'); //.child('photos/profils_adherents/$fileName');
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
  String _emailFieldValidator(String value) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Entrer une addresse email valide";
    }
  }
}