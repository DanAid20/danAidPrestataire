import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/services/getPlatform.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/locator.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/providers/phoneVerificationProvider.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/widgets/danAid_default_header.dart';

class OtpView extends StatefulWidget {
  final ConfirmationResult? webRes;
  const OtpView({Key? key, this.webRes}) : super(key: key);

  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  FocusNode? pin2FocusNode, pin3FocusNode, pin4FocusNode;
  FocusNode? pin5FocusNode, pin6FocusNode;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController pin1Controller = new TextEditingController();
  TextEditingController pin2Controller = new TextEditingController();
  TextEditingController pin3Controller = new TextEditingController();
  TextEditingController pin4Controller = new TextEditingController();
  TextEditingController pin5Controller = new TextEditingController();
  TextEditingController pin6Controller = new TextEditingController();
  bool load = false;

  final defaultSize = SizeConfig.defaultSize;
  final GlobalKey<FormState> _mFormKey = GlobalKey<FormState>();
  final NavigationService _navigationService = locator<NavigationService>();
  bool _mIsPass = true;

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode?.dispose();
    pin3FocusNode?.dispose();
    pin4FocusNode?.dispose();
    pin5FocusNode?.dispose();
    pin6FocusNode?.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const DanAidDefaultHeader(showDanAidLogo: true,),
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
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(height: SizeConfig.screenHeight! * 0.05),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          alignment: Alignment.center,
                          child: Text(
                              S.of(context).unCodeDeValidationATEnvoyParSmsAu + userProvider.getUserId!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: darkGreyColor,
                              fontSize: fontSize(size: 17)
                            ),
                          ),
                        ),
                        buildTimer(),
                        otpForm(),
                        //DefaultBtn(formKey: _mFormKey, signText: "Validez le code", signRoute: '/profile-type',),
                        !(pin1Controller.text.isNotEmpty & pin2Controller.text.isNotEmpty & pin3Controller.text.isNotEmpty & pin4Controller.text.isNotEmpty & pin5Controller.text.isNotEmpty & pin6Controller.text.isNotEmpty)
                          ? CustomDisabledTextButton(text: S.of(context).validezLeCode,)
                          : load ? Center(child: Loaders().buttonLoader(kPrimaryColor))
                            : CustomTextButton(
                                text: S.of(context).validezLeCode, 
                                color: kPrimaryColor, 
                                action: 
                                  () async {
                                    setState(() {
                                      load = true;
                                    });
                                    signInWithPhoneNumber();
                                  },
                              ),
                        SizedBox(height: SizeConfig.screenHeight! * .01),
                        GestureDetector(
                          onTap: () => navigateReplaceTo(context: context, routeName: '/login'),
                          child: Text(
                            S.of(context).renvoyezLeCodeDeValidation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: fontSize(size: 18),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(height: height(size: 25),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Container buildTimer() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(S.of(context).leCodeExpireDans, style: TextStyle(fontWeight: FontWeight.w700, fontSize: fontSize(size: 18))),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 40.0, end: 0.0),
            duration: Duration(seconds: 120),
            builder: (_, value, child) => Text(
              "00:${value.toInt()}",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize(size: 18)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container otpForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontal(size: 20)),
      child: Form(
        key: _mFormKey,
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight! * .038),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(60),
                  child: TextFormField(
                    controller: pin1Controller,
                    autofocus: true,
                    //obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {nextField(value, pin2FocusNode!); setState((){});},
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(60),
                  child: TextFormField(
                    controller: pin2Controller,
                    focusNode: pin2FocusNode,
                    //obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {nextField(value, pin3FocusNode!); setState((){});},
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(60),
                  child: TextFormField(
                    controller: pin3Controller,
                    focusNode: pin3FocusNode,
                    //obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {nextField(value, pin4FocusNode!); setState((){});},
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(60),
                  child: TextFormField(
                    controller: pin4Controller,
                    focusNode: pin4FocusNode,
                    //obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {nextField(value, pin5FocusNode!); setState((){});},
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(60),
                  child: TextFormField(
                    controller: pin5Controller,
                    focusNode: pin5FocusNode,
                    //obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {nextField(value, pin6FocusNode!); setState((){});},
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(60),
                  child: TextFormField(
                    controller: pin6Controller,
                    focusNode: pin6FocusNode,
                    //obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      setState((){});
                      if (value.length == 1) {
                        pin6FocusNode!.unfocus();
                        // Then you need to check is the code is correct or not
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.screenHeight! * .05),
          ],
        ),
      ),
    );
  }

  void signInWithPhoneNumber() async {
    PhoneVerificationProvider phoneVerificationProvider = Provider.of<PhoneVerificationProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String smsCode = pin1Controller.text+pin2Controller.text+pin3Controller.text+pin4Controller.text+pin5Controller.text+pin6Controller.text;
    print(phoneVerificationProvider.getVerificationId.toString());
    print(smsCode);
    try {

    if(isWeb()){

      print("web otp: ${widget.webRes?.verificationId.toString()}");

      widget.webRes!.confirm(smsCode).then((userCredential) => postSignInOperations(userCredential));
    
    }
    
    else {

      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: phoneVerificationProvider.getVerificationId!,
        smsCode: smsCode,
      );

       _auth.signInWithCredential(credential).then((val) async {
      print(userProvider.getUserId);
      
      final User user = val.user!;
      userProvider.setAuthId(user.uid);
      HiveDatabase.setSignInState(true);
      HiveDatabase.setAuthPhone(userProvider.getUserId!);
      Map res = await checkIfUserIsAlreadyRegistered(userProvider.getUserId!);
      bool registered = res["exists"];
      String profile = res["profile"];
      UserModel userModel = res["user"];

      if(registered == false){
        print("not registered");
        setState(() {
          load = false;
        });
        Navigator.pushNamed(context, '/profile-type');
      } else {
        print("registered");
        userProvider.setUserModel(userModel);
        if(profile == beneficiary){
          if(userModel.authId == null){
            FirebaseFirestore.instance.collection("USERS").doc(userModel.userId).update({
              "authId": _auth.currentUser!.uid,
              "userCountryCodeIso": userProvider.getCountryCode!.toLowerCase(),
              "userCountryName": userProvider.getCountryName,
            }).then((value) {
              showSnackbar("Profil bénéficiaire recupéré..");
            });
          }
        }
        HiveDatabase.setRegisterState(true);
        setState(() {
          load = false;
        });
        print("profile");
        print(profile);
        HiveDatabase.setProfileType(profile);
        userProvider.setProfileType(profile);
        userProvider.setAuthId(user.uid);
        Navigator.pushReplacementNamed(context, '/home');
      }
      showSnackbar(S.of(context).successfullySignedInUid+user.uid);
      }).catchError((e){
        setState(() {
          load = false;
        });
        showSnackbar(S.of(context).failedToSignIn + e.message.toString());
      });

    }

    
    } on FirebaseAuthException catch (e) {
      setState(() {
        load = false;
      });
      showSnackbar(S.of(context).failedToSignIn + e.message.toString());
    }
  }

  postSignInOperations(UserCredential val) async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    print(userProvider.getUserId);
      
      final User user = val.user!;
      userProvider.setAuthId(user.uid);
      HiveDatabase.setSignInState(true);
      HiveDatabase.setAuthPhone(userProvider.getUserId!);
      Map res = await checkIfUserIsAlreadyRegistered(userProvider.getUserId!);
      bool registered = res["exists"];
      String profile = res["profile"];
      UserModel userModel = res["user"];

      if(registered == false){
        print("not registered");
        setState(() {
          load = false;
        });
        Navigator.pushNamed(context, '/profile-type');
      } else {
        print("registered");
        userProvider.setUserModel(userModel);
        if(profile == beneficiary){
          if(userModel.authId == null){
            FirebaseFirestore.instance.collection("USERS").doc(userModel.userId).update({
              "authId": _auth.currentUser!.uid,
              "userCountryCodeIso": userProvider.getCountryCode!.toLowerCase(),
              "userCountryName": userProvider.getCountryName,
            }).then((value) {
              showSnackbar("Profil bénéficiaire recupéré..");
            });
          }
        }
        HiveDatabase.setRegisterState(true);
        setState(() {
          load = false;
        });
        print("profile");
        print(profile);
        HiveDatabase.setProfileType(profile);
        userProvider.setProfileType(profile);
        userProvider.setAuthId(user.uid);
        Navigator.pushReplacementNamed(context, '/home');
      }
  }

  Future<Map> checkIfUserIsAlreadyRegistered(String phone) async {
    String? profile;
    UserModel? userProfile;
    DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore.instance.collection('USERS').doc(phone).get();
    bool exists = (user.exists) ? true : false;
    if (exists) {
      //profile = user.get("profil");
      profile = user.get("profil");
      userProfile = UserModel.fromDocument(user, user.data()!);
      profile = userProfile.profileType;
    }
    return {
      "exists": exists,
      "profile": profile,
      "user": userProfile
    };
  }

  void showSnackbar(String message) {
    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
    SnackBar snackBar = SnackBar(content: Text(message), duration: Duration(seconds: 10),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
