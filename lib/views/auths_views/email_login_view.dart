import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/models/userModel.dart';
import '../../core/providers/userProvider.dart';
import '../../core/services/getPlatform.dart';
import '../../core/services/hiveDatabase.dart';
import '../../core/utils/config_size.dart';
import '../../generated/l10n.dart';
import '../../helpers/colors.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/danAid_default_header.dart';
import '../../widgets/forms/custom_text_field.dart';
import '../../widgets/forms/defaultInputDecoration.dart';

class EmailLoginView extends StatefulWidget {
  const EmailLoginView({ Key? key }) : super(key: key);

  @override
  State<EmailLoginView> createState() => _EmailLoginViewState();
}

class _EmailLoginViewState extends State<EmailLoginView> {
  final defaultSize = SizeConfig.defaultSize;
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  static final passwordRegExp = RegExp(r'^.{6,}$');
  static final emailRegExp =RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static final phoneRegExp = RegExp(r'\d');

  bool autovalidate = false;
  bool isLogin = true;
  bool loader = false;
  bool obscureText = true;
  String initialCountry = 'CM';
  PhoneNumber number = PhoneNumber(isoCode: 'CM');
  String? phone;
  String? phoneCode;
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
                  child: const Hero(tag: "danaid-login", child: DanAidDefaultHeader(showDanAidLogo: true, color: kSouthSeas,)),
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

  Container loginForm() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: Device.isSmartphone(context) ? wv*100 : 810
      ),
      padding: EdgeInsets.symmetric(vertical: Device.isSmartphone(context) ? 10 : hv*10,),
      child: Form(
        key: _emailFormKey,
        autovalidateMode: autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: wv*3),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => setState(() {isLogin = !isLogin; autovalidate = false;}),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1),
                      child: Text("Connexion", style: isLogin ? const TextStyle(fontSize: 18, fontWeight: FontWeight.w600) : null,),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isLogin ? kSouthSeas : whiteColor, width: 3.0))),
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() {isLogin = !isLogin; autovalidate = false;}),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1),
                      child: Text("Inscription", style: !isLogin ? const TextStyle(fontSize: 18, fontWeight: FontWeight.w600) : null,),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: !isLogin ? kSouthSeas : whiteColor, width: 3.0))),
                    ),
                  ),
                ],
              ),

              SizedBox(height: hv*4,),

              Container(
                width: Device.isSmartphone(context) ? wv*100 : 810,
                child: CustomTextField(
                  prefixIcon: const Icon(MdiIcons.emailOutline, color: kSouthSeas),
                  hintText: S.of(context).entrezVotreAddresseEmail,
                  textColor: Colors.black45,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  noPadding: true,
                  validator:  (String? mail) => emailRegExp.hasMatch(mail.toString()) ? null : "Invalid email address",
                ),
              ),

              isLogin ? Container(height: hv*2.5) : Container(
                width: Device.isSmartphone(context) ? wv*100 : 810,
                padding: EdgeInsets.symmetric(vertical: hv*3),
                child: Column(
                  children: [
                    InternationalPhoneNumberInput(
                      validator: (String? phone) => phoneRegExp.hasMatch(phone.toString()) && phone.toString().length > 8 ? null : "Phone number format is incorrect",
                      onInputChanged: (PhoneNumber number) {
                        phone = number.phoneNumber;
                        phoneCode = number.isoCode;
                        print("phone number ${number.phoneNumber}");
                        print("isocode ${number.isoCode}");
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      spaceBetweenSelectorAndTextField: 0,
                      selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET,),
                      ignoreBlank: false,
                      textStyle: const TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 18),
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: _phoneController,
                      formatInput: false,
                      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                      inputDecoration: defaultInputDecoration(),
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      }, 
                    ),
                    SizedBox(height: hv*0.5,),
                    const Align(child: Text("Obligatoire**"), alignment: Alignment.centerRight,),
                  ],
                ),
              ),

              Container(
                width: Device.isSmartphone(context) ? wv*100 : 810,
                child: CustomTextField(
                  prefixIcon: const Icon(MdiIcons.lock, color: kSouthSeas),
                  obscureText: obscureText,
                  isPassword: true,
                  noPadding: true,
                  textColor: Colors.black45,
                  hintText: "Password",
                  controller: _passwordController,
                  validator: (String? phone) => passwordRegExp.hasMatch(phone.toString()) ? null : "Password must have at least 6 characters",
                  editAction: ()=>setState((){obscureText = !obscureText;}),
                ),
              ),

              SizedBox(height: hv*4,),
              SizedBox(
                width: Device.isSmartphone(context) ? wv*100 : 810,
                child: Hero(
                  tag: "login-email-button",
                  child: CustomTextButton(
                    noPadding: true,
                    text: S.of(context).continuer,
                    color: kSouthSeas,
                    isLoading: loader,
                    action: () async {
                      print("ttt");
                      setState(() {
                        autovalidate = true;
                      });
                      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                      print("${_emailController.text}, ${_passwordController.text}, ${userProvider.getCountryCode}");

                      if (_emailFormKey.currentState!.validate()){
                        setState(() {
                          autovalidate = false;
                          loader = true;
                        });
                        userProvider.setEmail(_emailController.text);
                        if(isLogin){
                          try {
                            UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text
                            );
                            Map res = await checkIfUserIsAlreadyRegistered(email: _emailController.text);
                            bool registered = res["exists"];
                            String? profile = res["profile"];
                            UserModel? user = res["user"];
                            if(registered == false){
                              setState(() {
                                loader = false;
                              });
                              Navigator.pushNamed(context, '/profile-type');
                              showDialogFeedback(title: "Finalisez votre inscription", message: "Vous êtes connecté mais vous devez terminer votre inscription pour continuer..");
                            }
                            else {
                              setState(() {
                                loader = false;
                              });
                              userProvider.setUserModel(user!);
                              userProvider.setUserId(user.userId);
                              if(profile == beneficiary){
                                if(user.authId == null){
                                  FirebaseFirestore.instance.collection("USERS").doc(user.userId).update({
                                    "authId": FirebaseAuth.instance.currentUser!.uid,
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
                              userProvider.setAuthId(FirebaseAuth.instance.currentUser!.uid);
                              userProvider.setProfileType(profile);
                              HiveDatabase.setProfileType(profile!);
                              Navigator.pushReplacementNamed(context, '/home');
                              //showDialogFeedback(title: "Succès", message: "Connexion réussie");
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {loader = false; _passwordController.clear();});
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              showDialogFeedback(title: "Compte inexistant", message: "Auncun utilisateur repertorié avec cet email. Allez dans la section inscription d'abord, si vous ne l'avez pas encore fait..");
                            } else if (e.code == 'wrong-password') {
                              showDialogFeedback(title: "Mot de passe incorrect", message: "Le mot de passe fournit pour cette addresse email est incorrect..");
                              print('Wrong password provided for that user.');
                            } else {
                              print(e.message);
                              showDialogFeedback(title: e.code, message: e.message.toString());
                            }
                          }
                        }
                        else {
                          userProvider.setUserId(phone);
                          userProvider.setCountryCode(phoneCode!);
                          try {
                            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text
                            );
                            Map userRes = await checkIfUserIsAlreadyRegistered(phone: phone!);
                            if(userRes["exists"] == false){
                              userProvider.setAuthId(FirebaseAuth.instance.currentUser!.uid);
                              HiveDatabase.setSignInState(true);
                              HiveDatabase.setAuthPhone(userProvider.getUserId!);
                              Navigator.pushNamed(context, '/profile-type');
                            }
                            else {
                              setState(() {
                                loader = false;
                              });
                              showDialogFeedback(title: "Numéro existant", message: "Un utilisateur utilisant le numéro de téléphone :$phone est déjà inscrit au système..");
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {loader = false; _emailController.clear(); _passwordController.clear(); _phoneController.clear();});
                            
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                              showDialogFeedback(title: "Mot de passe faible", message: "Le mot de passe fournit est trop faible, essayez de fournir un passe plus sécurisé..");
                            } else if (e.code == 'email-already-in-use') {
                              print('The account already exists for that email.');
                              showDialogFeedback(title: "Email en utilisation", message: "L'email fournit est déjà en utilisation dans le système, fournissez un email différent..");
                            } else {
                              print(e.message);
                              showDialogFeedback(title: e.code, message: e.message.toString());
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                        /*bool registered = await checkIfUserIsAlreadyRegistered("+${userProvider.getCountryCode}${_mPhoneController.text}");
                        if(registered == false){
                        } else {
                          HiveDatabase.setSignInState(true);
                          HiveDatabase.setRegisterState(true);
                          Navigator.pushReplacementNamed(context, '/home');
                        }*/
                        //_navigationService.navigateTo('/otp');
                      } else {
                        setState(() {
                          autovalidate = true;
                        });
                      }

                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map> checkIfUserIsAlreadyRegistered({String? phone, String? email}) async {
    String? profile;
    UserModel? userProfile;
    QuerySnapshot<Map<String, dynamic>>? usersByMail = email != null ? await FirebaseFirestore.instance.collection('USERS').where('emailAdress', isEqualTo: email).get() : null;
    DocumentSnapshot? user = phone != null ? await FirebaseFirestore.instance.collection('USERS').doc(phone).get() : usersByMail!.docs.first;
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

  void showSnackbar(String message) {
    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
    SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showDialogFeedback({required String title, required String message, IconData? icon, }){
    showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: wv*5,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(children: [
                    SizedBox(height: hv*4),
                    Icon(icon ?? LineIcons.timesCircle, color: kDeepTeal, size: 70,),
                    SizedBox(height: hv*2,),
                    Text(title, style: const TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
                    SizedBox(height: hv*2,),
                    Text(message, style: TextStyle(color: Colors.grey[600], fontSize: 18), textAlign: TextAlign.center),
                    SizedBox(height: hv*2),
                    CustomTextButton(
                      text: "Annuler",
                      color: kDeepTeal,
                      action: (){Navigator.pop(context);},
                    )
                    
                  ], mainAxisAlignment: MainAxisAlignment.center, ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}