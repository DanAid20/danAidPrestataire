import 'package:danaid/core/utils/config_size.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp phoneValidatorRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
final RegExp validatorRegExp = RegExp(r"^[a-z0-9]");
final RegExp digitValidatorRegExp = RegExp(r"^[0-9]+$");
final String textValidatorError = "Ce champ ne doit contenir que des chiffres";
const String kEmailNullError = "Please Enter your email";
const String kEmailNullErrorFr = "Svp entrez votre email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kInvalidEmailErrorFr = "Entrez une adresse mail valide";
const String kPassNullError = "Please Enter your password";
const String kPassNullErrorFr = "Svp entrez votre mot de passe";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNameNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kCountryNullError = "Saisissez votre pays";
const String kAddressNullError = "Please Enter your address";
const String kEmptyField = "Ce champ ne doit pas être vide.";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius:
        BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

fontSize({double? size}) => getProportionateScreenWidth(size!);
horizontal({double? size}) => getProportionateScreenWidth(size!);
width({double? size}) => getProportionateScreenWidth(size!);
left({double? size}) => getProportionateScreenWidth(size!);
right({double? size}) => getProportionateScreenWidth(size!);
vertical({double? size}) => getProportionateScreenHeight(size!);
height({double? size}) => getProportionateScreenHeight(size!);
top({double? size}) => getProportionateScreenHeight(size!);
bottom({double? size}) => getProportionateScreenHeight(size!);
navigateTo({BuildContext? context, String? routeName, Object? args}) => Navigator.of(context!).pushNamed(routeName!, arguments: args);
navigateReplaceTo({BuildContext? context, String? routeName, Object? args}) => Navigator.of(context!).pushReplacementNamed(routeName!, arguments: args);

//Profile Types
const String adherent = "ADHERENT";
const String doctor = "MEDECIN";
const String serviceProvider = "PRESTATAIRE";
const String beneficiary = "BENEFICIAIRE";

// consultation Types 
enum ConsultationTypes { Encabinet, Videos, Message }


//Use case service types
const  String consultation = "CONSULTATION";
const  String pharmacy = "PHARMACY";
const  String labo = "LABO";
const  String ambulance = "AMBULANCE";
const  String hospitalization = "HOSPITALIZATION";
const  arrayOfServicesType=[
   {
        "value": "CONSULTATION",
        "key":  consultation,
   },
   {
        "value": "PHARMACY",
        "key":  pharmacy,
   },
   {
        "value": "LABO",
        "key":  labo,
   },
   {
        "value": "AMBULANCE",
        "key":  ambulance,
   },
   {
        "value": "HOSPITALIZATION",
        "key":  hospitalization,
   },
];

//Agora IDs
const agoraAppId = "e5c433dd91e64cebb55005e05ed16087";
const agoraAppCertificate = "cebf5d0706cc4d4f88139780b230d9e5";
