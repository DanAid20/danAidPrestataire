import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:danaid/core/providers/phoneVerificationProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/buttons/default_btn.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/forms/form_widget.dart';
import 'package:danaid/widgets/texts/sign_in_up_tag.dart';
import 'package:danaid/widgets/texts/welcome_text_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:danaid/widgets/danAid_default_header.dart';

import '../../locator.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final defaultSize = SizeConfig.defaultSize;
  final GlobalKey<FormState> _mFormKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;
  TextEditingController _mPhoneController, _mPasswordController;
  bool loader = false;
  bool _mIsPass = true;

  bool autovalidate = false;
  Country _selectedDialogCountry = CountryPickerUtils.getCountryByPhoneCode('237');
  String phoneCode = "237";

  testHive() async {
    var registered = await HiveDatabase.getRegisterState();

    var signedIn = await HiveDatabase.getSignInState();
    var name = await HiveDatabase.getFamilyName();
    print("registered:");
    print(signedIn.toString());
    print('Name: $name');
  }

  @override
  void initState() {
    testHive();
    _mPhoneController = TextEditingController();
    _mPasswordController = TextEditingController();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.transparent,
                  child: DanAidDefaultHeader(showDanAidLogo: true,),
                ),
                Expanded(
                  child: Container(
                    height: SizeConfig.screenHeight * .8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(defaultSize * 2.5),
                            topRight: Radius.circular(defaultSize * 2.5)
                        )
                    ),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        loginForm(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _openCountryPickerDialog() => showDialog(
      context: context,
      builder: (context) {
        UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
        return Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
                titlePadding: EdgeInsets.all(15.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration: InputDecoration(
                    hintText: 'Chercher...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)
                ),
                isSearchable: true,
                title: Text('Selectionnez votre pays'),
                onValuePicked: (Country country) {
                  print(country.isoCode);
                  print(country.name);
                  print(country.phoneCode);
                  print(country.iso3Code);
                  userProvider.setCountryCode(country.isoCode);
                  userProvider.setCountryName(country.name);
                  setState(() => _selectedDialogCountry = country);
                  setState(() => phoneCode = country.phoneCode);
                },
                priorityList: [
                  CountryPickerUtils.getCountryByPhoneCode('237'),
                  CountryPickerUtils.getCountryByPhoneCode('225'),
                  CountryPickerUtils.getCountryByPhoneCode('234'),
                ],
                itemBuilder: _buildCountryDialogItem)
        );
      }
  );

  Widget _buildCountryDialogItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8.0),
        Text("+${country.phoneCode}"),
        SizedBox(width: 8.0),
        Flexible(child: Text(country.name))
      ],
    );
  }

  Container loginForm() {
    return Container(
      margin: EdgeInsets.only(top: top(size: 20)),
      child: Form(
        key: _mFormKey,
        autovalidateMode: autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [BoxShadow(blurRadius: 2, spreadRadius: 1.0, color: Colors.grey.withOpacity(0.5) )],
                //border: Border.all(color: kPrimaryColor)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, top: 15.0),
                    child: Text("Sélectionnez votre pays", style: TextStyle(color: kPrimaryColor, fontSize: wv*4.5, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                  ),
                  ListTile(
                    onTap: _openCountryPickerDialog,
                    title: _buildCountryDialogItem(_selectedDialogCountry),
                    trailing: Icon(Icons.arrow_drop_down_circle_sharp, color: kPrimaryColor,),
                  ),
                ],
              ),
            ),

            SizedBox(height: hv*2,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: wv*3),
              child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _mPhoneController,
                  validator: (String phone) {
                    return (phone.isEmpty)
                        ? kPhoneNumberNullError
                        : (!digitValidatorRegExp.hasMatch(phone))
                        ? "Entrer un numero de téléphone valide" : null;
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$')),
                  ],
                  style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: wv*5),
                  decoration: InputDecoration(
                    prefixIcon: Icon(LineIcons.phone),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red[300]),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    fillColor: Colors.grey[100],
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: kPrimaryColor.withOpacity(0.0)),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    hintText: "Numéro de téléphone",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: wv*4),
                  ),
                ),
            ),

            SizedBox(height: hv*4,),
            loader ?
            Loaders().buttonLoader(kPrimaryColor)
                : CustomTextButton(
              text: "Continuer",
              color: kPrimaryColor,
              action: () async {
                setState(() {
                  autovalidate = true;
                });
                UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                print("${_mPhoneController.text}, ${userProvider.getCountryName}, ${userProvider.getCountryCode}");

                if (_mFormKey.currentState.validate()){
                  setState(() {
                    loader = true;
                  });
                  userProvider.setUserId("+$phoneCode${_mPhoneController.text}");
                  print("+${userProvider.getCountryCode}${_mPhoneController.text}");
                  verifyPhoneNumber();
                  /*bool registered = await checkIfUserIsAlreadyRegistered("+${userProvider.getCountryCode}${_mPhoneController.text}");
                  if(registered == false){
                  } else {
                    HiveDatabase.setSignInState(true);
                    HiveDatabase.setRegisterState(true);
                    Navigator.pushReplacementNamed(context, '/home');
                  }*/
                  //_navigationService.navigateTo('/otp');
                }

              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Map> checkIfUserIsAlreadyRegistered(String phone) async {
    String profile;
    DocumentSnapshot user = await FirebaseFirestore.instance.collection('USERS').doc(phone).get();
    bool exists = (user.exists) ? true : false;
    if (exists) {
      profile = user.data()["profil"];
    }
    return {
      "exists": exists,
      "profile": profile
    };
  }

  void verifyPhoneNumber() async {

    NavigationService _navigationService = locator<NavigationService>();
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    PhoneVerificationProvider phoneVerificationProvider = Provider.of<PhoneVerificationProvider>(context, listen: false);

    PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      showSnackbar("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
      userProvider.setAuthId(_auth.currentUser.uid);
      setState((){
        loader = false;
      });
      Map res = await checkIfUserIsAlreadyRegistered(userProvider.getUserId);
      bool registered = res["exists"];
      String profile = res["profile"];
      
      if(registered == false){
        Navigator.pushNamed(context, '/profile-type');
      } else {
        HiveDatabase.setRegisterState(true);
        HiveDatabase.setSignInState(true);
        HiveDatabase.setAuthPhone(userProvider.getUserId);
        print("profile");
        print(profile);
        userProvider.setProfileType(profile);
        HiveDatabase.setProfileType(profile);
        Navigator.pushReplacementNamed(context, '/home');
      }
    };

    //Listens for errors with verification, such as too many attempts
    PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {
      setState((){
        loader = false;
      });
      showSnackbar('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      showSnackbar('Please check your phone for the verification code.');
      if(verificationId != null){
        _verificationId = verificationId;
        /*setState((){
          loader = false;
        });*/
        //_navigationService.navigateTo('/otp');
        showSnackbar("Le code viens d'arriver, patientez encore unpeu ..." );
      }else{
        setState((){
          loader = false;
        });
      }
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      phoneVerificationProvider.setVerificationId(verificationId);
      showSnackbar("verification code: " + verificationId);
      _navigationService.navigateTo('/otp');
      _verificationId = verificationId;
      setState((){
        loader = false;
      });
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: userProvider.getUserId,
          timeout: const Duration(seconds: 40),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackbar("Failed to Verify Phone Number: ${e}");
    }
  }

  void showSnackbar(String message) {
    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
    SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}

