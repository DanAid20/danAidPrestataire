import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/providers/phoneVerificationProvider.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/forms/form_widget.dart';
import 'package:danaid/widgets/texts/sign_in_up_tag.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final defaultSize = SizeConfig.defaultSize;
  final GlobalKey<FormState> _mFormKey = GlobalKey<FormState>();
  TextEditingController? _mPhoneController, _mPasswordController, _mEmailController, _mCountryController, _mNameController;
  bool _mIsPass = true;
  bool autovalidate = false;
  String phoneCode = "237";

  Country _selectedDialogCountry = CountryPickerUtils.getCountryByPhoneCode('237');
  Country _selectedFilteredDialogCountry = CountryPickerUtils.getCountryByPhoneCode('237');

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  @override
  void initState() {
    _mPhoneController = TextEditingController();
    _mPasswordController = TextEditingController();
    _mEmailController = TextEditingController();
    _mCountryController = TextEditingController();
    _mNameController = TextEditingController();
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
                  height: SizeConfig.screenHeight! * .45,
                  decoration: BoxDecoration(color: kPrimaryColor),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: SizeConfig.screenHeight! * .3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: top(size: 19)),
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
                          Container(
                            margin: EdgeInsets.only(top: top(size: 14)),
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontal(size: 45)),
                            child: Text(S.of(context)!.entrezVosInformationsAfinDeCrerVotreCompteEt,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: whiteColor,
                                  letterSpacing: .72,
                                  height: 1.4,
                                  fontSize: fontSize(size: 16)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: SizeConfig.screenHeight! * .8,
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(defaultSize! * 2.5),
                                topRight: Radius.circular(defaultSize! * 2.5)
                            )
                        ),
                        child: ListView(
                          children: [
                            loginForm(),
                            //DefaultBtn(formKey: _mFormKey, signText: "S'inscrire", signRoute: '/otp',),
                            
                            SIgnInUpTag(title: S.of(context)!.djMembre, subTitle: S.of(context)!.seConnecter, signRoute: '/login',),
                            SizedBox(height: height(size: 25),)
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
            hintText: S.of(context)!.chercher,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)
          ),
          isSearchable: true,
          title: Text(S.of(context)!.selectionnezVotrePays),
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
        autovalidateMode: autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled, 
        key: _mFormKey,
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
                    child: Text(S.of(context)!.slectionnezVotrePays, style: TextStyle(color: kPrimaryColor, fontSize: wv*4, fontWeight: FontWeight.w600), textAlign: TextAlign.right,),
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
              controller: _mPhoneController!,
              labelText: S.of(context)!.tlphone,
              hintText: S.of(context)!.entrezVotreNumroDeTlphone,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$')),
              ],
              prefixIcon:
              Icon(SimpleLineIcons.phone),
              validator: (String? phone) {
                return (phone!.isEmpty)
                    ? kPhoneNumberNullError
                    : (!digitValidatorRegExp.hasMatch(phone))
                    ? S.of(context)!.entrerUnNumeroDeTlphoneValide : null;
              },
            ),

            /*KTextFormField(
              controller: _mCountryController,
              labelText: 'Pays',
              hintText: 'Entrez votre pays',
              prefixIcon:
              Icon(SimpleLineIcons.flag),
              validator: (String country) {
                return (country.isEmpty)
                    ? kCountryNullError
                    : null;
              },
            ),*/

            KTextFormField(
              controller: _mNameController!,
              labelText: S.of(context)!.nom,
              hintText: S.of(context)!.entrezVotreNom,
              prefixIcon:
              Icon(SimpleLineIcons.flag),
              validator: (String? name) {
                return (name!.isEmpty)
                    ? kCountryNullError
                    : null;
              },
            ),

            KTextFormField  (
              controller: _mEmailController!,
              labelText: S.of(context)!.adresseEmail,
              hintText: S.of(context)!.entrezVotreAdresseEmail,
              keyboardType: TextInputType.emailAddress,
              prefixIcon:
              Icon(SimpleLineIcons.envelope),
              validator: (String? mail) {
                return (mail!.isEmpty)
                    ? kEmailNullErrorFr
                    // : (!emailValidatorRegExp.hasMatch(mail))
                    // ? kInvalidEmailError 
                    : null;
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

            CustomTextButton(
              text: S.of(context)!.sinscrire,
              color: kPrimaryColor,
              action: () async {
                setState(() {
                  autovalidate = true;
                });
                UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                print("${_mCountryController!.text}, ${_mEmailController!.text}, ${_mPhoneController!.text}, ${userProvider.getCountryName}, ${userProvider.getCountryCode}");
                
                if (_mFormKey.currentState!.validate()){

                  userProvider.setEmail(_mEmailController!.text);
                  userProvider.setFullName(_mNameController!.text);
                  userProvider.setUserId("+$phoneCode${_mPhoneController!.text}");
                  print("+${userProvider.getCountryCode}${_mPhoneController!.text}");
                  verifyPhoneNumber();
                  //_navigationService.navigateTo('/otp');
                }else{
                  Navigator.of(context).pushNamed('/profile-type');
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
      showSnackbar(S.of(context)!.phoneNumberAutomaticallyVerifiedAndUserSignedIn +_auth.currentUser!.uid);
      _navigationService.navigateTo('/home');
    };

    //Listens for errors with verification, such as too many attempts
    PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {
      showSnackbar(S.of(context)!.phoneNumberVerificationFailedCode+authException.code+S.of(context)!.message+authException.message!);
    };

    PhoneCodeSent codeSent = (String verificationId, [int? forceResendingToken]) async {
      showSnackbar(S.of(context)!.pleaseCheckYourPhoneForTheVerificationCode); 
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      phoneVerificationProvider.setVerificationId(verificationId);
      showSnackbar(S.of(context)!.verificationCode + verificationId);
      _verificationId = verificationId;
    };
    
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: userProvider.getUserId!,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
          .then((value) => {
            _navigationService.navigateTo('/otp')
          });
    } catch (e) {
      showSnackbar(S.of(context)!.failedToVerifyPhoneNumber+e.toString());
    }
  }

  
  void showSnackbar(String message) {
    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
    SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

