import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:danaid/core/providers/phoneVerificationProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/buttons/default_btn.dart';
import 'package:danaid/widgets/forms/form_widget.dart';
import 'package:danaid/widgets/texts/sign_in_up_tag.dart';
import 'package:danaid/widgets/texts/welcome_text_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:danaid/widgets/loaders.dart';

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

  @override
  void initState() {
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
        child: Stack(
          children: [
            Container(
              height: SizeConfig.screenHeight * .45,
              decoration: BoxDecoration(color: kPrimaryColor),
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
                            border: Border.all(
                                color: kPrimaryColor, width: 2.3),
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
                        child: Text('Entrez votre mot de passe et email pour accéder à votre compte.',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: whiteColor,
                              letterSpacing: .7,
                              height: 1.4,
                              fontSize: fontSize(size: 16)),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: SizeConfig.screenHeight * .8,
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(defaultSize * 2.5),
                            topRight: Radius.circular(defaultSize * 2.5)
                        )
                    ),
                    child: ListView(
                      children: [
                        loginForm(),
                        /*InkWell(
                          onTap: () => navigateReplaceTo(context: context, routeName: '/reset-password'),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'Mot de passe oublié ?',
                              softWrap: true,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: fontSize(size: 15),
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),*/
                        //DefaultBtn(formKey: _mFormKey, signRoute: '/home',),
                        SIgnInUpTag()
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
          //itemFilter: (c) => ['NG', 'DE', 'GB', 'CI'].contains(c.isoCode),
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
    //Country initialCountry = Country(iso3Code: "CMR", isoCode: "CM", name: "Cameroon", phoneCode: "237");
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
              margin: EdgeInsets.symmetric(horizontal: wv*3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(blurRadius: 2, spreadRadius: 1.0, color: Colors.grey.withOpacity(0.5) )
                ],
                //border: Border.all(color: kPrimaryColor)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, top: 15.0),
                    child: Text("Sélectionnez votre pays", style: TextStyle(color: kPrimaryColor, fontSize: wv*4, fontWeight: FontWeight.w600), textAlign: TextAlign.right,),
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
            
            KTextFormField(
              controller: _mPhoneController,
              labelText: 'Téléphone',
              hintText: 'Entrez votre numéro de téléphone',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$')),
              ],
              prefixIcon:
              Icon(SimpleLineIcons.phone),
              validator: (String phone) {
                return (phone.isEmpty)
                    ? kPhoneNumberNullError
                    : (!digitValidatorRegExp.hasMatch(phone))
                    ? "Entrer un numero de téléphone valide" : null;
              },
            ),
            /*KTextFormField(
              controller: _mPasswordController,
              isPassword: _mIsPass,
              labelText: 'Mot de Passe',
              hintText:
                  'Entrez votre mot de passe',
              prefixIcon:
                  Icon(SimpleLineIcons.lock),
              validator: (String pwd) {
                return (pwd.isEmpty)
                    ? kPassNullErrorFr
                    : null;
              },
              suffixIcon: IconButton(
                icon: Icon(_mIsPass
                    ? SimpleLineIcons.eye
                    : Feather.eye_off),
                onPressed: () {
                  setState(() {
                    _mIsPass = !_mIsPass;
                  });
                },
              ),
            ),*/
            loader ? 
            Loaders().buttonLoader(kPrimaryColor)
            : CustomTextButton(
              text: "S'inscrire",
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
                  //_navigationService.navigateTo('/otp');
                }
                
              },
            ),
          ],
        ),
      ),
    );
  }

  void verifyPhoneNumber() async {

    NavigationService _navigationService = locator<NavigationService>();
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    PhoneVerificationProvider phoneVerificationProvider = Provider.of<PhoneVerificationProvider>(context, listen: false);

    PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      showSnackbar("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
      setState((){
        loader = false;
      });
      _navigationService.navigateTo('/profile-type');
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
        setState((){
          loader = false;
        });
        _navigationService.navigateTo('/otp');
      }else{
        setState((){
          loader = false;
        });
      }
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      phoneVerificationProvider.setVerificationId(verificationId);
      showSnackbar("verification code: " + verificationId);
      _verificationId = verificationId;
      setState((){
        loader = false;
      });
    };
    
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: userProvider.getUserId,
          timeout: const Duration(seconds: 60),
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



