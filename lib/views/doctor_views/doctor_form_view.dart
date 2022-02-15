//import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/services/getCities.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/danAid_default_header.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:danaid/widgets/function_widgets.dart';
import 'package:danaid/widgets/forms/location_dropdown.dart';

class DoctorFormView extends StatefulWidget {
  @override
  _DoctorFormViewState createState() => _DoctorFormViewState();
}

class _DoctorFormViewState extends State<DoctorFormView> {
  final GlobalKey<FormState> _mFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _mFormKey2 = GlobalKey<FormState>();
  TextEditingController? _mSurnameController, _mNameController, _mEmailController, _mRegionController, _mIdNumberController;
  TextEditingController? _mOfficeNameController, _mOfficeCategoryController, _mSpecController,
      _mRegisterOrder, _mHospitalCommuneController, _mCityController;
  String? _mGender;
  String? _type;
  bool? _isPersonal = false;
  File? imageFileAvatar;
  bool? imageLoading = false;
  bool? buttonLoading = false;
  String? avatarUrl;
  String? _gender = "H";
  String? _category;
  DateTime? selectedDate;
  DateTime? initialDate = DateTime(1990);
  String? _city;
  String? _stateCode;
  String? _region = "Centre";
  bool? regionChosen = false;
  bool? cityChosen = false;
  String? _officeCity;
  String? _officeRegion;
  String? _officeStateCode;
  bool? _officeCityChosen = false;
  bool? _officeRegionChosen = false;
  bool? _serviceTermsAccepted = false;
  String? termsAndConditions = S.current.leMdecinDeFamilleDanaidAssureLeSuiviLongTerme;

  @override
  void initState() {
    _mHospitalCommuneController = TextEditingController();
    _mRegionController = TextEditingController();
    _mIdNumberController = TextEditingController();
    _mOfficeNameController = TextEditingController();
    _mSurnameController = TextEditingController();
    _mNameController = TextEditingController();
    _mEmailController = TextEditingController();
    _mOfficeCategoryController = TextEditingController();
    _mSpecController = TextEditingController();
    _mRegisterOrder = TextEditingController();
    _mCityController = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                        child: imageFileAvatar == null ? Icon(LineIcons.user, color: Colors.white, size: wv*25,) : Container(),
                        backgroundImage: imageFileAvatar == null ? null : FileImage(imageFileAvatar!),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 5,
                        child: CircleAvatar(
                          backgroundColor: kDeepTeal,
                          radius: wv*5,
                          child: IconButton(
                            icon: const Icon(Icons.add, color: whiteColor,), 
                            color: kPrimaryColor, 
                            onPressed: (){FunctionWidgets.chooseImageProvider(context: context, gallery: getImageFromGallery, camera: getImageFromCamera);}
                          ),
                        ),
                      )
                    ],),
                  ),
                ], alignment: AlignmentDirectional.topCenter,),
              ),
              Expanded(
                child: Container(
                  height: SizeConfig.screenHeight! * 1.1,
                  decoration: const BoxDecoration(
                      color: whiteColor,
                  ),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      (!_isPersonal!) ?
                       personalInfosForm()
                       : professionalInfosForm()
                    ],
                  ),
                ),
              ),
              Container(
                child: (!_isPersonal!) ? 
                  (cityChosen! & (selectedDate != null)) ? CustomTextButton(
                    text: S.of(context).continuer,
                    action: (){
                      if(_mFormKey.currentState!.validate()){
                        setState(() {
                          _isPersonal = true;
                          debugPrint(_mSurnameController!.text,);
                          debugPrint(_mRegionController!.text,);
                          debugPrint(_mCityController!.text,);
                          debugPrint(_mIdNumberController!.text,);
                        });
                      }
                    },
                  )
                  : CustomDisabledTextButton(text: S.of(context).continuer,)
                :  Row(
                  children: [
                    Expanded(
                      child: CustomTextButton(
                        text: S.of(context).retour,
                        color: kDeepTeal,
                        expand: false,
                        action: (){
                          setState(() {
                            _isPersonal = false;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: (_officeCityChosen! & _serviceTermsAccepted! & (_category != null) & (_type != null)) ? 
                        !buttonLoading! ? CustomTextButton(
                          text: S.of(context).envoyer,
                          expand: false,
                          action: () async {
                            registerDoctor();
                          },
                        ) : Center(child: Loaders().buttonLoader(kPrimaryColor))
                      : CustomDisabledTextButton(text: S.of(context).envoyer, expand: false,),
                    ),
                  ],
                )
                ,
              )
            ],
          )),
    );
  }

  Container personalInfosForm() {
    return Container(
      child: Form(
        key: _mFormKey,
        child: Column(
          children: [
            CustomTextField(
              label: S.of(context).nomDeFamille,
              hintText: S.of(context).entrezVotreNomDeFamille,
              controller: _mNameController!,
              validator: (String? val) => (val!.isEmpty) ? S.of(context).ceChampEstObligatoire : null,
            ),
            SizedBox(height: hv*1.5,),
            CustomTextField(
              label: S.of(context).prnomS,
              hintText: S.of(context).entrezVotrePrnom,
              controller: _mSurnameController!,
              validator: (String? val) => (val!.isEmpty) ? S.of(context).ceChampEstObligatoire : null,
            ),
            SizedBox(height: hv*1.5,),
            CustomTextField(
              label: S.of(context).email,
              hintText: S.of(context).entrezVotreAddresseEmail,
              controller: _mEmailController!,
              keyboardType: TextInputType.emailAddress,
              validator:  (String? mail) {
                return (mail!.isEmpty)
                    ? kEmailNullErrorFr
                    : (!emailValidatorRegExp.hasMatch(mail))
                    ? kInvalidEmailError : null;
              },
            ),
            SizedBox(height: hv*1.5,),
            Row(
              children: [
                SizedBox(width: wv*3,),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).genre, style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                      const SizedBox(height: 5,),
                      Container(
                        constraints: BoxConstraints(minWidth: wv*45),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: const BorderRadius.all(Radius.circular(20))
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: _gender,
                            items: [
                              DropdownMenuItem(
                                child: Text(S.of(context).masculin, style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                value: "H",
                              ),
                              DropdownMenuItem(
                                child: Text(S.of(context).fminin, style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                value: "F",
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _gender = value.toString();
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
                      Text(S.of(context).dateDeNaissance, style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                      const SizedBox(height: 5,),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.all(Radius.circular(20))
                          ),
                          child: Row(children: [
                            SvgPicture.asset("assets/icons/Bulk/CalendarLine.svg", color: kDeepTeal,),
                            const VerticalDivider(),
                            Text( selectedDate != null ? "${selectedDate!.toLocal()}".split(' ')[0] : S.of(context).choisir, style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.bold),),
                          ],),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: wv*3,),
              ],
            ),
            /*Container(
              margin: EdgeInsets.only(top: top(size: defSize * 1.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ChoiceTile(
                    label: "Homme",
                    icon: FontAwesome.male,
                    isActive: _mGender == "M",
                    onPressed: () {
                      setState(() {
                        _mGender = "M";
                      });
                    },
                  ),
                  HorizontalSpacing(of: defSize * 3),
                  ChoiceTile(
                    label: "Femme",
                    icon: FontAwesome.female,
                    isActive: _mGender == "F",
                    onPressed: () {
                      setState(() {
                        _mGender = "F";
                      });
                    },
                  ),
                ],
              ),
            ),*/
            SizedBox(height: hv*1.5,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: wv*3),
              child: LocationDropdown(
                city: _city!,
                stateCode: _stateCode!,
                cityChosen: cityChosen!,
                regionChosen: regionChosen!,
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
            )
            /*DefaultBtn(
              formKey: _mFormKey,
              signText: 'Continuez',
              onPress: (){
                if(_mFormKey.currentState.validate()){
                  setState(() {
                    _isPersonal = true;
                    debugPrint(_mSurnameController.text,);
                    debugPrint(_mRegionController.text,);
                    debugPrint(_mCityController.text,);
                    debugPrint(_mIdNumberController.text,);
                  });
                }
              },
            )*/
          ],
        ),
      ),
    );
  }

  Container professionalInfosForm() {
    return Container(
      margin: EdgeInsets.only(top: top(size: 20)),
      child: Form(
        key: _mFormKey2,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: wv*3),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).tesVousGnralisteOuSpcialiste, style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                  const SizedBox(height: 5,),
                  Container(
                    constraints: BoxConstraints(minWidth: wv*45),
                    padding:const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(S.of(context).choisir),
                        isExpanded: true,
                        value: _type,
                        items: [
                          DropdownMenuItem(
                            child:  Text(S.of(context).gnraliste, style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                            value: S.of(context).gnraliste,
                          ),
                          DropdownMenuItem(
                            child: Text(S.of(context).spcialiste, style:const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                            value: S.of(context).spcialiste,
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _type = value.toString();
                          });
                        }),
                    ),
                  ),
                ],
              ),
            ),
            _type == S.of(context).spcialiste ? Column(
              children: [
                SizedBox(height: hv*1.5,),
                CustomTextField(
                  label: S.of(context).spcialit,
                  hintText: S.of(context).exPdiatre,
                  controller: _mSpecController!,
                  validator: (String? val) => (val!.isEmpty) ? S.of(context).ceChampEstObligatoire : null,
                ),
              ],
            )
            : Container(),
            SizedBox(height: hv*1.5,),
            CustomTextField(
              label: S.of(context).nomDeLhpital,
              hintText: S.of(context).exHpitaleGnrale,
              controller: _mOfficeNameController!,
              validator: (String? val) => (val!.isEmpty) ? S.of(context).ceChampEstObligatoire : null,
            ),
            SizedBox(height: hv*1.5,),
            Padding(
              padding: EdgeInsets.all(wv*3),
              child: LocationDropdown(
                city: _officeCity!,
                stateCode: _officeStateCode!,
                cityChosen: _officeCityChosen!,
                regionChosen: _officeRegionChosen!,
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
            ),
            SizedBox(height: hv*1.5,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: wv*3),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).typeDtablissement, style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
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
                          hint: Text(S.of(context).choisir),
                          items: [
                            DropdownMenuItem(
                              child: Text(S.of(context).publique, style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                              value: S.of(context).public,
                            ),
                            DropdownMenuItem(
                              child: Text(S.of(context).confessionel, style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                              value: S.of(context).confessionel,
                            ),
                            DropdownMenuItem(
                              child: Text(S.of(context).priv, style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                              value: S.of(context).private,
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
                  SizedBox(height: hv*1,),
                  HomePageComponents.termsAndConditionsTile(
                    action: ()=>FunctionWidgets.termsAndConditionsDialog(context: context),
                    value: _serviceTermsAccepted!,
                    activeColor: primaryColor,
                    onChanged: (newValue) {
                      setState(() {
                        _serviceTermsAccepted = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  registerDoctor() async {
    if(_mFormKey2.currentState!.validate()){
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String hcommune = _officeCity!;
    String hregion = _officeRegion!;
    String region = _region!;
    String cni = _mNameController!.text + " " + _mSurnameController!.text;
    String officeName = _mOfficeNameController!.text;
    String surname = _mSurnameController!.text;
    String name = _mNameController!.text;
    String officeCategory = _category!;
    String spec = _mSpecController!.text;
    String city = _city!;
    String email = _mEmailController!.text;

    await FirebaseFirestore.instance.collection("USERS")
      .doc(userProvider.getUserId)
      .set({
        'emailAdress': email,
        "authId": FirebaseAuth.instance.currentUser!.uid,
        'createdDate': DateTime.now(),
        'enabled': false,
        "phoneList": FieldValue.arrayUnion([{"number": userProvider.getUserId}]),
        "urlCNI": "",
        "userCountryCodeIso": userProvider.getCountryCode!.toLowerCase(),
        "userCountryName": userProvider.getCountryName,
        'fullName': cni,
        "profil": "MEDECIN",
        "points": 500,
        "visitPoints": 0,
        "regionDorigione": region,
        "imageUrl": avatarUrl,
        "phoneKeywords": Algorithms.getKeyWords(userProvider.getUserId!),
        "nameKeywords": Algorithms.getKeyWords(name + " "+ surname)
      }, SetOptions(merge: true))
      .then((value) async {
        await FirebaseFirestore.instance.collection("MEDECINS")
          .doc(userProvider.getUserId)
          .set({
            //"certificatDenregistrmDordre": registerOrder,
            "categorieEtablissement": officeCategory,
            "communeHospital": hcommune,
            "authId": FirebaseAuth.instance.currentUser!.uid,
            "regionEtablissement": hregion,
            "nomEtablissement": officeName,
            "email": email,
            "specialite": _type == "Généraliste" ? "Médécine Générale" : spec,
            "domaine": _type,
            "cniName": cni,
            "createdDate": DateTime.now(),
            "id": userProvider.getUserId,
            "enabled": false,
            "genre": _gender,
            "phoneList": FieldValue.arrayUnion([{"number": userProvider.getUserId}]),
            "prenom": surname,
            "nomDefamille": name,
            "profil": "MEDECIN",
            "profilEnabled": false,
            "regionDorigione": region,
            "statuMatrimonialMarie": false,
            "ville": city,
            "urlImage": avatarUrl,
            "phoneKeywords": Algorithms.getKeyWords(userProvider.getUserId!),
            "nameKeywords": Algorithms.getKeyWords(name + " "+ surname)
          }, SetOptions(merge: true))
          .then((value) async {
            HiveDatabase.setRegisterState(true);
            HiveDatabase.setAuthPhone(userProvider.getUserId!);
            HiveDatabase.setProfileType(doctor);
            Navigator.pushNamed(context, '/home');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).profilMdcinCre)));
          })
          .catchError((e) {
            if (kDebugMode) {
              print(e.toString());
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
          });
        });
    }
  }

  Future uploadImageToFirebase(PickedFile file) async {
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);

    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).aucuneImageSelectionne)));
      return null;
    }
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      imageLoading = true;
    });
    String fileName = userProvider.getUserId!;

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
    
    storageUploadTask = storageReference.putFile(imageFileAvatar!);

    storageUploadTask.catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    });
    storageUploadTask.whenComplete(() async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).photoDeProfilAjoute)));
      String url = await storageReference.getDownloadURL();
      doctorProvider.setImgUrl(url);
      avatarUrl = url;
      if (kDebugMode) {
        print("download url: $url");
      }
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
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
    uploadImageToFirebase(pickedFile!);
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
    uploadImageToFirebase(pickedFile!);
  }
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate!, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != selectedDate)
      setState((){
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
                  Text(S.of(context).termesDeServices, style: TextStyle(fontSize: wv*6, fontWeight: FontWeight.w900, color: kPrimaryColor),),
                  SizedBox(height: hv*2,),
                  Expanded(child: SingleChildScrollView(child: Text(termsAndConditions!), physics: const BouncingScrollPhysics(),)),
                ],
              ),
            ),
            CustomTextButton(
              text: S.of(context).fermer,
              color: kPrimaryColor,
              action: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }

}
