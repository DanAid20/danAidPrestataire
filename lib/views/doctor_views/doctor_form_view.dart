import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/default_btn.dart';
import 'package:danaid/widgets/forms/form_widget.dart';
import 'package:danaid/widgets/texts/welcome_text_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class DoctorFormView extends StatefulWidget {
  @override
  _DoctorFormViewState createState() => _DoctorFormViewState();
}

class _DoctorFormViewState extends State<DoctorFormView> {
  final GlobalKey<FormState> _mFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _mFormKey2 = GlobalKey<FormState>();
  TextEditingController _mSurnameController, _mRegionController, _mIdNumberController;
  TextEditingController _mOfficeNameController, _mOfficeCategoryController, _mSpecController,
      _mRegisterOrder, _mHospitalCommuneController, _mCityController;
  String _mGender;
  bool _isPersonal = false;

  @override
  void initState() {
    _mHospitalCommuneController = TextEditingController();
    _mRegionController = TextEditingController();
    _mIdNumberController = TextEditingController();
    _mOfficeNameController = TextEditingController();
    _mSurnameController = TextEditingController();
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
          body: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  height: SizeConfig.screenHeight * .15,
                  width: SizeConfig.screenWidth,
                  color: Colors.transparent,
                  child: SvgPicture.asset(
                    'assets/images/headImage.svg',
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: SizeConfig.screenHeight * .3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: top(size: 14)),
                            decoration: BoxDecoration(
                                border: Border.all(color: kPrimaryColor, width: 2.3),
                                shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage:
                              AssetImage('assets/images/male.png'),
                            ),
                          ),
                          WelcomeHeader(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontal(size: 35)),
                            child: Text('Complétez vos informations afin d\'accéder à la plateforme.',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  letterSpacing: .7,
                                  height: 1.4,
                                  fontWeight: FontWeight.w700,
                                  fontSize: fontSize(size: 16)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: SizeConfig.screenHeight * 1.1,
                        decoration: BoxDecoration(
                            color: whiteColor,
                        ),
                        child: ListView(
                          children: [
                            (!_isPersonal) ?
                             personalInfosForm()
                             : professionalInfosForm()
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  Container personalInfosForm() {
    return Container(
      child: Form(
        key: _mFormKey,
        child: Column(
          children: [
            KTextFormField(
              controller: _mSurnameController,
              labelText: 'Prénom',
              hintText: 'Entrez votre prénom',
              prefixIcon: Icon(SimpleLineIcons.user),
              onChanged: (value){
                setState(() {
                  _mSurnameController.text = value;
                });
              },
              validator: (String surname) {
                return (surname.isEmpty)
                    ? kEmptyField
                    : null;
              },
            ),
            KTextFormField(
              controller: _mRegionController,
              labelText: 'Région d\'Origine',
              hintText: 'Entrez votre région d\'origine',
              prefixIcon: Icon(SimpleLineIcons.globe),
              onChanged: (value){
                setState(() {
                  _mRegionController.text = value;
                });
              },
              validator: (String origine) {
                return (origine.isEmpty)
                    ? kEmptyField
                    : null;
              },
            ),
            KTextFormField(
              controller: _mCityController,
              labelText: 'Lieu de résidence',
              hintText: 'Entrez votre ville',
              prefixIcon: Icon(SimpleLineIcons.location_pin),
              onChanged: (value){
                setState(() {
                  _mCityController.text = value;
                });
              },
              validator: (String town) {
                return (town.isEmpty)
                    ? kEmptyField
                    : null;
              },
            ),
            KTextFormField(
              controller: _mIdNumberController,
              labelText: 'Numéro de CNI',
              hintText: 'Entrez votre numéro de cni',
              keyboardType: TextInputType.number,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset('assets/icons/id-card.svg',
                  height: 30,
                  width: 30,
                ),
              ),
              onChanged: (value){
                setState(() {
                  _mIdNumberController.text = value;
                });
              },
              validator: (String origine) {
                return (origine.isEmpty)
                    ? kEmptyField
                    : null;
              },
            ),
            Container(
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
            ),
            DefaultBtn(
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
            )
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
            KTextFormField(
              controller: _mOfficeNameController,
              labelText: 'Nom de l\'hôpital',
              hintText: 'Entrez le nom de l\'hôpital',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset('assets/icons/hospital.svg',
                  height: 30,
                  width: 30,
                ),
              ),
              onChanged: (value){
                setState(() {
                  _mOfficeNameController.text = value;
                });
              },
              validator: (String office) {
                return (office.isEmpty)
                    ? kEmptyField
                    : null;
              },
            ),
            KTextFormField(
              controller: _mOfficeCategoryController,
              labelText: 'Catégorie Hôpital',
              hintText: 'Entrez la catégorie de l\'hôpital',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset('assets/icons/first-aid-kit.svg',
                  height: 30,
                  width: 30,
                ),
              ),
              onChanged: (value){
                setState(() {
                  _mOfficeCategoryController.text = value;
                });
              },
              validator: (String _mOffice) {
                return (_mOffice.isEmpty)
                    ? kEmptyField
                    : null;
              },
            ),
            KTextFormField(
              controller: _mRegisterOrder,
              labelText: 'Numéro dans l\'ordre',
              hintText: 'Entrez votre numéro d\'enregistrement',
              keyboardType: TextInputType.number,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset('assets/icons/caduceus.svg',
                  height: 30,
                  width: 30,
                ),
              ),
              onChanged: (value){
                setState(() {
                  _mRegisterOrder.text = value;
                });
              },
              validator: (String origine) {
                return (origine.isEmpty)
                    ? kEmptyField
                    : null;
              },
            ),
            KTextFormField(
              controller: _mSpecController,
              labelText: 'Spécialité',
              hintText: 'Entrez votre spécialité',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset('assets/icons/stethoscope.svg',
                  height: 30,
                  width: 30,
                ),
              ),
              onChanged: (value){
                setState(() {
                  _mSpecController.text = value;
                });
              },
              validator: (String spec) {
                return (spec.isEmpty)
                    ? kEmptyField
                    : null;
              },
            ),
            KTextFormField(
              controller: _mHospitalCommuneController,
              labelText: 'Commune Hôpital',
              hintText: 'Entrez votre commune',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset('assets/icons/hospitalLocation.svg',
                  height: 30,
                  width: 30,
                ),
              ),
              onChanged: (value){
                setState(() {
                  _mHospitalCommuneController.text = value;
                });
              },
              validator: (String commune) {
                return (commune.isEmpty)
                    ? kEmptyField
                    : null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: width(size: 200),
                    child: DefaultBtn(
                      formKey: _mFormKey,
                      signText: 'Retour',
                      bgColor: kSecondaryColor,
                      onPress: (){
                        setState(() {
                          _isPersonal = false;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: width(size: 250),
                    child: DefaultBtn(
                      formKey: _mFormKey,
                      signText: 'Continuez',
                      onPress: () async {
                        UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                        String hcommune = _mHospitalCommuneController.text;
                        String region = _mRegionController.text;
                        String cni = _mIdNumberController.text;
                        String officeName = _mOfficeNameController.text;
                        String surname = _mSurnameController.text;
                        String officeCategory = _mOfficeCategoryController.text;
                        String spec = _mSpecController.text;
                        String registerOrder = _mRegisterOrder.text;
                        String city = _mCityController.text;

                        await FirebaseFirestore.instance.collection("USERS")
                          .doc(userProvider.getUserId)
                          .set({
                            'createdDate': DateTime.now(),
                            'enabled': false,
                            "phoneList": FieldValue.arrayUnion([{"number": userProvider.getUserId}]),
                            "urlCNI": "",
                            "userCountryCodeIso": userProvider.getCountryCode.toLowerCase(),
                            "userCountryName": userProvider.getCountryName,
                            "authId": userProvider.getAuthId,
                            'fullName': surname,
                            "profil": "MEDECIN",
                            "regionDorigione": region
                          }, SetOptions(merge: true))
                          .then((value) async {
                            await FirebaseFirestore.instance.collection("MEDECINS")
                              .doc(userProvider.getUserId)
                              .set({
                                "certificatDenregistrmDordre": registerOrder,
                                "categorieEtablissement": officeCategory,
                                "communeHospital": hcommune,
                                "nomEtablissement": officeName,
                                "specialite": spec,
                                "cniName": cni,
                                "createdDate": DateTime.now(),
                                "id": userProvider.getUserId,
                                "enabled": false,
                                "genre": _mGender,
                                "phoneList": FieldValue.arrayUnion([{"number": userProvider.getUserId}]),
                                "prenom": surname,
                                "profil": "MEDECIN",
                                "profilEnabled": false,
                                "regionDorigione": region,
                                "statuMatrimonialMarie": false,
                                "ville": city,
                              }, SetOptions(merge: true))
                              .then((value) async {
                                Navigator.pushNamed(context, '/doctor-home');
                              })
                              .catchError((e) {
                                print(e.toString());
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              });
                            });
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
