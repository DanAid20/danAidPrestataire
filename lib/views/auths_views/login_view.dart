import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/phoneVerificationProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/getPlatform.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/auths_views/otp_view.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:danaid/widgets/danAid_default_header.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

import '../../locator.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final defaultSize = SizeConfig.defaultSize;
  final GlobalKey<FormState> _mFormKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  TextEditingController? _mPhoneController, _mPasswordController;
  bool loader = false;
  bool _mIsPass = true;

  bool autovalidate = false;
  Country _selectedDialogCountry = CountryPickerUtils.getCountryByPhoneCode('237');
  String phoneCode = "237";

  testHive() async {
    var registered = await HiveDatabase.getRegisterState();

    var signedIn = await HiveDatabase.getSignInState();
    String? name = await HiveDatabase.getFamilyName();
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
                  child: const DanAidDefaultHeader(showDanAidLogo: true,),
                ),
                Expanded(
                  child: Container(
                    height: SizeConfig.screenHeight! * .8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(defaultSize! * 2.5),
                            topRight: Radius.circular(defaultSize! * 2.5)
                        )
                    ),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
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
                titlePadding: const EdgeInsets.all(15.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration: InputDecoration(
                    hintText: S.of(context).chercher,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0)
                ),
                isSearchable: true,
                title: Text(S.of(context).selectionnezVotrePays),
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
        const SizedBox(width: 8.0),
        Text("+${country.phoneCode}"),
        const SizedBox(width: 8.0),
        Flexible(child: Text(country.name))
      ],
    );
  }

  Container loginForm() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: Device.isSmartphone(context) ? wv*100 : 500
      ),
      padding: EdgeInsets.symmetric(vertical: Device.isSmartphone(context) ? 10 : hv*10,),
      child: Form(
        key: _mFormKey,
        autovalidateMode: autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        child: Column(
          children: [
            Container(
              width: Device.isSmartphone(context) ? wv*100 : 700,
              margin: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: [BoxShadow(blurRadius: 2, spreadRadius: 1.0, color: Colors.grey.withOpacity(0.5) )],
                //border: Border.all(color: kPrimaryColor)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                    child: Text(S.of(context).slectionnezVotrePays, style: const TextStyle(color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                  ),
                  ListTile(
                    onTap: _openCountryPickerDialog,
                    title: _buildCountryDialogItem(_selectedDialogCountry),
                    trailing: const Icon(Icons.arrow_drop_down_circle_sharp, color: kPrimaryColor,),
                  ),
                ],
              ),
            ),

            SizedBox(height: hv*2,),

            Container(
              width: Device.isSmartphone(context) ? wv*100 : 800,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: wv*3),
                child: TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: _mPhoneController,
                    validator: (String? phone) {
                      return (phone!.isEmpty)
                          ? kPhoneNumberNullError
                          : (!digitValidatorRegExp.hasMatch(phone))
                          ? S.of(context).entrerUnNumeroDeTlphoneValide : null;
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$')),
                    ],
                    style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LineIcons.phone),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.red[300]!),
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: kPrimaryColor.withOpacity(0.0)),
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(0.2)),
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      hintText: S.of(context).numroDeTlphone,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                    ),
                  ),
              ),
            ),

            SizedBox(height: hv*4,),
            SizedBox(
              width: Device.isSmartphone(context) ? wv*100 : 810,
              child: CustomTextButton(
                text: S.of(context).continuer,
                color: kPrimaryColor,
                isLoading: loader,
                action: () async {
                  print("ttt");
                  setState(() {
                    autovalidate = true;
                  });
                  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                  print("${_mPhoneController?.text}, ${userProvider.getCountryName}, ${userProvider.getCountryCode}");

                  if (_mFormKey.currentState!.validate()){
                    setState(() {
                      loader = true;
                    });
                    userProvider.setUserId("+$phoneCode${_mPhoneController?.text}");
                    print("+${userProvider.getCountryCode}${_mPhoneController?.text}");
                    isWeb() ? signInWithPhoneNumber() : verifyPhoneNumber();
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
            ),
          ],
        ),
      ),
    );
  }

  Future<Map> checkIfUserIsAlreadyRegistered(String phone) async {
    String? profile;
    UserModel? userProfile;
    DocumentSnapshot user = await FirebaseFirestore.instance.collection('USERS').doc(phone).get();
    bool exists = (user.exists) ? true : false;
    if (exists) {
      profile = user.get("profil");
      userProfile = UserModel.fromDocument(user, user.data() as Map);
    }
    return {
      "exists": exists,
      "profile": profile,
      "user": userProfile
    };
  }

  void verifyPhoneNumber() async {

    NavigationService _navigationService = locator<NavigationService>();
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    PhoneVerificationProvider phoneVerificationProvider = Provider.of<PhoneVerificationProvider>(context, listen: false);

    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      showSnackbar(S.of(context).phoneNumberAutomaticallyVerifiedAndUserSignedIn+_auth.currentUser!.uid);
      userProvider.setAuthId(_auth.currentUser!.uid);
      setState((){
        loader = false;
      });
      Map res = await checkIfUserIsAlreadyRegistered(userProvider.getUserId!);
      bool registered = res["exists"];
      String profile = res["profile"];
      UserModel user = res["user"];
      
      if(registered == false){
        Navigator.pushNamed(context, '/profile-type');
      } else {
        userProvider.setUserModel(user);
        if(profile == beneficiary){
          if(user.authId == null){
            FirebaseFirestore.instance.collection("USERS").doc(user.userId).update({
              "authId": _auth.currentUser!.uid,
              "userCountryCodeIso": userProvider.getCountryCode!.toLowerCase(),
              "userCountryName": userProvider.getCountryName,
            }).then((value) {
              showSnackbar("Profil bénéficiaire recupéré..");
            });
          }
          HiveDatabase.setAdherentParentAuthPhone(userProvider.getUserModel!.adherentId!);
        }
        HiveDatabase.setRegisterState(true);
        HiveDatabase.setSignInState(true);
        HiveDatabase.setAuthPhone(userProvider.getUserModel!.userId!);
        print("profile:");
        print(profile);
        userProvider.setProfileType(profile);
        HiveDatabase.setProfileType(profile);
        Navigator.pushReplacementNamed(context, '/home');
      }
    };

    //Listens for errors with verification, such as too many attempts
    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {
      setState((){
        loader = false;
      });
      showSnackbar(S.of(context).phoneNumberVerificationFailedCode+authException.code+S.of(context).message + authException.message!);
    };

    // ignore: prefer_function_declarations_over_variables
    PhoneCodeSent codeSent = (String? verificationId, [int? forceResendingToken]) async {
      showSnackbar(S.of(context).pleaseCheckYourPhoneForTheVerificationCode);
      if(verificationId != null){
        _verificationId = verificationId;
        /*setState((){
          loader = false;
        });*/
        //_navigationService.navigateTo('/otp');
        showSnackbar(S.of(context).leCodeViensDarriverPatientezEncoreUnpeu );
      }else{
        setState((){
          loader = false;
        });
      }
    };

    // ignore: prefer_function_declarations_over_variables
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      phoneVerificationProvider.setVerificationId(verificationId);
      showSnackbar(S.of(context).verificationCode + verificationId);
      _navigationService.navigateTo('/otp');
      _verificationId = verificationId;
      setState((){
        loader = false;
      });
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: userProvider.getUserId!,
          timeout: const Duration(seconds: 40),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackbar(S.of(context).phoneNumberVerificationFailedCode+e.toString());
    }
  }

  void signInWithPhoneNumber() async {
    print("Web login");

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    var result = await _auth.signInWithPhoneNumber(userProvider.getUserId!, RecaptchaVerifier(
      onSuccess: () => print('reCAPTCHA Completed!'),
      onError: (FirebaseAuthException error) => print(error),
      onExpired: () => print('reCAPTCHA Expired!'),
    ));
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpView(webRes: result),),);
    
  }

  void showSnackbar(String message) {
    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
    SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}

