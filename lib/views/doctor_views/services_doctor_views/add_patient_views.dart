import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/inactive_account_views.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/buttons/default_btn.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddPatientView extends StatefulWidget {
  @override
  _AddPatientViewState createState() => _AddPatientViewState();
}

// Widget offerPartsssss() {
//   return Container(
//     width: wv * 100,
//     height: hv * 25,
//     color: whiteColor,
//     child: Column(children: [
//       Text('Choisir le type de consultation '),
//       Container(
//         margin: EdgeInsets.symmetric(vertical: 2.0),
//         color: Colors.white,
//         child: new ListView(
//           scrollDirection: Axis.horizontal,
//           children: <Widget>[
//             offerPart(),
//             offerPart(),
//             offerPart(),
//             offerPart(),
//           ],
//         ),
//       ),
//     ]),
//   );
// }

class _AddPatientViewState extends State<AddPatientView> {
  bool confirmSpinner = false;
  String initialCountry = 'CM';
  PhoneNumber number = PhoneNumber(isoCode: 'CM');
  TextEditingController adherentNumber = new TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controllers;
  Country _selectedDialogCountry = CountryPickerUtils.getCountryByPhoneCode('237');
  String phoneCode = "237";

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controllers.pauseCamera();
    } else if (Platform.isIOS) {
      controllers.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controllers = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  Widget offerPart(
      {String consultation, String consultationType, String price}) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(
                left: wv * 6, right: wv * 1.5, top: hv * 2, bottom: hv * 1),
            width: wv * 40,
            height: hv * 12,
            decoration: BoxDecoration(
              color: cardColor,
              boxShadow: [
                BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding: EdgeInsets.only(top: hv * 0.3),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: wv * 1.5, top: hv * 0.5),
                    child: SvgPicture.asset(
                      'assets/icons/Bulk/Profile-color.svg',
                      width: wv * 10,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: wv * 1.9, top: hv * 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consultation,
                        style: TextStyle(
                            color: kCardTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: fontSize(size: wv * 4)),
                      ),
                      Text(
                        consultationType,
                        style: TextStyle(
                            color: kCardTextColor,
                            fontWeight: FontWeight.w800,
                            fontSize: fontSize(size: wv * 4)),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: hv * 2),
                          child: Text(
                            price,
                            style: TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: fontSize(size: wv * 4)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
  
  void _openCountryPickerDialog() => showDialog(
      context: context,
      builder: (context) {
        UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
        return Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
                titlePadding: EdgeInsets.all(10.0),
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
        SizedBox(width: 5.0),
        Text("+${country.phoneCode}", style:TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: fontSize(size: wv * 4))),
        SizedBox(width: 5.0),
        Flexible(child: Text(country.name,style:TextStyle(
                                color: kCardTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: fontSize(size: wv * 4))))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: kBgTextColor,
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: kDateTextColor,
                ),
                onPressed: () => Navigator.pop(context)),
            title: Align(
              alignment: Alignment.center,
              child: Container(
                child: Column(
                  children: [Text('Demarer'), Text('15 Janvier 2021, 1:30')],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/Bulk/Search.svg',
                  color: kSouthSeas,
                ),
                onPressed: () {},
                color: kSouthSeas,
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/Bulk/Drawer.svg',
                  color: kSouthSeas,
                ),
                onPressed: () {},
                color: kSouthSeas,
              )
            ],
          ),
          body: Container(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 2.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: wv * 5, top: hv * 2),
                            child: Text('Choisir le type de consultation ',
                                style: TextStyle(
                                    fontSize: fontSize(size: wv * 4),
                                    fontWeight: FontWeight.w700,
                                    color: kPrimaryColor)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2.0),
                          height: hv * 17,
                          color: Colors.white,
                          child: new ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              offerPart(
                                  consultation: 'consultation',
                                  consultationType: 'En cabinet',
                                  price: '2000 FCFA'),
                              offerPart(
                                  consultation: 'consultation',
                                  consultationType: 'Vidéos',
                                  price: '2000 FCFA'),
                              offerPart(
                                  consultation: 'consultation',
                                  consultationType: 'Message',
                                  price: '2000 FCFA'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: hv * 5,
                  ),
                  Container(
                    width: wv * 100,
                    height: hv * 48,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: wv * 70,
                          decoration: BoxDecoration(
                            color: kDeepTealClair,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          padding: EdgeInsets.only(
                              left: wv * 1.9, right: wv * 1.5, top: hv * 1),
                          child: Row(
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  'assets/icons/Bulk/Add User.svg',
                                  color: kSouthSeas,
                                ),
                              ),
                              SizedBox(
                                width: wv * 2,
                              ),
                              Text(
                                'Selectionner ou ajouter le patient ',
                                style: TextStyle(
                                    fontSize: fontSize(size: wv * 4),
                                    fontWeight: FontWeight.w500,
                                    color: kFirstIntroColor),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: wv * 30,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: inch * 2, right: inch * 2, top: inch * 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                    padding: EdgeInsets.only(left: 15.0, top: 10.0),
                    child: Text("Sélectionnez votre pays", style: TextStyle(color: kPrimaryColor, fontSize: wv*3.5, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                  ),
                  ListTile(
                    onTap: ()=> _openCountryPickerDialog,
                    title: _buildCountryDialogItem(_selectedDialogCountry),
                    trailing: Icon(Icons.arrow_drop_down_circle_sharp, color: kPrimaryColor,),
                  ),
                ],
              ),
            ),
                              Text('Recherche par numero de telephone',
                                  style: TextStyle(
                                      fontSize: fontSize(size: wv * 4),
                                      fontWeight: FontWeight.w500,
                                      color: kFirstIntroColor)),
                              SizedBox(
                                height: hv * 2,
                              ),
                              Container(
                                width: wv * 100,
                                height: hv * 7,
                                decoration: BoxDecoration(
                                  color: kBgTextColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: Row(children: [
                                  SizedBox(
                                    width: wv * 2,
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/Bulk/Search.svg',
                                    color: kSouthSeas,
                                  ),
                                  SizedBox(
                                    height: hv * 2,
                                  ),
                                  Container(
                                    width: wv * 48,
                                    child: TextFormField(
                                      controller: adherentNumber,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.red[300]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        fillColor: kBgTextColor,
                                        //prefixIcon: Icon(Icons.search, color: kBrownCanyon,),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: kPrimaryColor
                                                    .withOpacity(0.0)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: kBgTextColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: inch * 2,
                                        right: inch * 2,
                                        top: inch * 2),
                                    width: wv * 28,
                                    height: hv * 7,
                                    decoration: BoxDecoration(
                                      color: kBgTextColor,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          bottomRight: Radius.circular(15)),
                                    ),
                                    child: Text('Rechercher',
                                        style: TextStyle(
                                            fontSize: fontSize(size: wv * 4),
                                            fontWeight: FontWeight.w700,
                                            color: kSouthSeas)),
                                  ),
                                ]),
                              ),
                              SizedBox(
                                height: hv * 2,
                              ),
                              Text("Ou scanner une carte d'adherent",
                                  style: TextStyle(
                                      fontSize: fontSize(size: wv * 4),
                                      fontWeight: FontWeight.w500,
                                      color: kFirstIntroColor)),
                              Container(
                                margin: EdgeInsets.only(
                                    left: inch * 2,
                                    right: inch * 2,
                                    top: inch * 1),
                                child: GestureDetector(
                                  onTap: () {
                                    _showMyDialog();
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      'assets/icons/Bulk/Scan.svg',
                                      color: kSouthSeas,
                                      height: hv * 12,
                                      width: wv * 12,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: hv * 2,
                  ),
                  Container(
                    width: wv * 50,
                    padding: EdgeInsets.symmetric(
                        horizontal: wv * 3.2, vertical: hv * 2),
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          confirmSpinner = true;
                        });
                        await FirebaseFirestore.instance
                            .collection('ADHERENTS')
                            .doc('+$phoneCode${adherentNumber.text}')
                            .get()
                            .then((doc) {
                          print(doc.exists);

                          setState(() {
                            confirmSpinner = false;
                          });
                          if (doc.exists) {
                            AdherentModelProvider adherentModelProvider =
                                Provider.of<AdherentModelProvider>(context,
                                    listen: false);
                            AdherentModel adherent =
                                AdherentModel.fromDocument(doc);
                            adherentModelProvider.setAdherentModel(adherent);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("${adherent.dateCreated} ")));

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => InactiveAccount(
                            //       data: adherent,
                            //       phoneNumber: adherentNumber.text,
                            //       isAccountIsExists: true,
                            //     ),
                            //   ),
                            // );
                          } else {
                            setState(() {
                              confirmSpinner = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("existe pas ")));

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InactiveAccount(
                                  isAccountIsExists: false,
                                  phoneNumber: adherentNumber.text,
                                ),
                              ),
                            );
                          }
                        });
                      },
                      child: Text(
                        confirmSpinner ? "..." : 'Envoyer',
                        style: TextStyle(
                            color: textColor,
                            fontSize: wv * 4.5,
                            fontWeight: FontWeight.w600),
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 15)),
                          backgroundColor:
                              MaterialStateProperty.all(kFirstIntroColor),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // confirmDoctor() async {
  //   setState(() {
  //     confirmSpinner = true;
  //   });
  //   DoctorModelProvider doctor =
  //       Provider.of<DoctorModelProvider>(context, listen: false);
  //   AdherentModelProvider adherentModelProvider =
  //       Provider.of<AdherentModelProvider>(context, listen: false);
  //   BottomAppBarControllerProvider controller =
  //       Provider.of<BottomAppBarControllerProvider>(context, listen: false);
  //   // il existe

  //   FirebaseFirestore.instance
  //       .collection("ADHERENTS")
  //       .doc(adherentNumber.text)
  //       .set({
  //     "familyDoctorId": doctor.getDoctor.id,
  //   }, SetOptions(merge: true)).then((value) {
  //     setState(() {
  //       confirmSpinner = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text("Le Dr " +
  //             doctor.getDoctor.cniName +
  //             " a été ajouté(e) comme médecin de famille..")));
  //     controller.setIndex(1);
  //     adherentModelProvider.setFamilyDoctorId(doctor.getDoctor.id);
  //     adherentModelProvider.setFamilyDoctor(doctor.getDoctor);
  //     Navigator.pushReplacementNamed(context, '/home');
  //   }).catchError((e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(e.toString())));
  //     setState(() {
  //       confirmSpinner = false;
  //     });
  //   });
  // }
}
