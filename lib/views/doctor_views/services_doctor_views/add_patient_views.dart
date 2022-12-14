import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/inactive_account_views.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/constants.dart';

class AddPatientView extends StatefulWidget {
  bool isLaunchConsultation;
  AddPatientView({Key key, this.isLaunchConsultation}) : super(key: key);
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
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String textForQrCode = null;
  String initialCountry = 'CM';
  PhoneNumber number = PhoneNumber(isoCode: 'CM');
  TextEditingController adherentNumber = new TextEditingController();
  TextEditingController _outputController;
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('237');
  String phoneCode = "237";
  //only for choose type of consultaion
  int currentItemSelect = 0;
  String consultationTypeData;
  String encabinet = "EnCabinet";
  String videos = "Video";
  String message = "Message";
  String phone;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    adherentNumber = TextEditingController();
    super.initState();
  }

  Future _scan() async {
    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
      setState(() {
        textForQrCode = barcode == null ? 'codeBarVide' : barcode;
      });
    } else {
      setState(() {
        textForQrCode = barcode;
      });
      if (validateMobile(textForQrCode) == true) {
        print(textForQrCode);
        setState(() {
          confirmSpinner = true;
        });
        await FirebaseFirestore.instance
            .collection('ADHERENTS')
            .doc('${barcode}')
            .get()
            .then((doc) {
          print(doc.exists);
          if (consultationTypeData != null) {
            setState(() {
              confirmSpinner = false;
            });
            if (doc.exists) {
              AdherentModelProvider adherentModelProvider =
                  Provider.of<AdherentModelProvider>(context, listen: false);
              AdherentModel adherent = AdherentModel.fromDocument(doc);
              adherentModelProvider.setAdherentModel(adherent);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${adherent.dateCreated} ")));
              print(adherent.toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InactiveAccount(
                    data: adherent,
                    phoneNumber: barcode,
                    isAccountIsExists: true,
                    consultationType: consultationTypeData,
                  ),
                ),
              );
            } else {
              setState(() {
                confirmSpinner = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("cet adherent n'existe pas ")));

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InactiveAccount(
                    isAccountIsExists: false,
                    data: null,
                    phoneNumber: phone,
                    consultationType: null,
                  ),
                ),
              );
            }
          } else {
            setState(() {
              confirmSpinner = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Veuillez preciser le type de consultation")));
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("veuillez scanner unnumero de t??l??phone valide svp")));
      }
      setState(() {
        confirmSpinner = false;
      });
    }
  }

  checking() async {}

  @override
  void dispose() {
    adherentNumber.dispose();
    super.dispose();
  }

  setconsultationType(consultation, index) {
    setState(() {
      consultationTypeData = consultation;
      currentItemSelect = index;
    });
    print(consultationTypeData);
    print(currentItemSelect);
  }

  Widget offerPart(
      {int index,
      String consultation,
      String consultationType,
      String price,
      String typedeConsultation}) {
    return GestureDetector(
      onTap: () {
        setconsultationType(typedeConsultation, index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              margin: EdgeInsets.only(
                  left: wv * 6, right: wv * 1.5, top: hv * 2, bottom: hv * 1),
              width: 130.w,
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                      color:
                          currentItemSelect == index ? kDeepTeal : kThirdColor,
                      spreadRadius: 0.5,
                      blurRadius: 4),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.only(top: hv * 0.3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: SvgPicture.asset(
                        consultationType == 'Vid??os'
                            ? 'assets/icons/Bulk/VideoTeal.svg'
                            : consultationType == 'Message'
                                ? 'assets/icons/Bulk/Message.svg'
                                : 'assets/icons/Bulk/Profile-color.svg',
                        width: wv * 10,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: wv * 1.9, top: hv * 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
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
                        SizedBox(
                          height: hv * 1.3,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: hv * 0.5, bottom: 8.h),
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
                  )
                ],
              )),
        ],
      ),
    );
  }

  bool validateMobile(String value) {
    String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    RegExp regExp = new RegExp(pattern);

    return regExp.hasMatch(value);
  }

  void _openCountryPickerDialog() => showDialog(
      context: context,
      builder: (context) {
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        return Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
                titlePadding: EdgeInsets.all(10.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration: InputDecoration(
                    hintText: 'Chercher...',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
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
                itemBuilder: _buildCountryDialogItem));
      });

  Widget _buildCountryDialogItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 5.0),
        Text("+${country.phoneCode}",
            style: TextStyle(
                color: kCardTextColor,
                fontWeight: FontWeight.w500,
                fontSize: fontSize(size: wv * 4))),
        SizedBox(width: 5.0),
        Flexible(
            child: Text(country.name,
                style: TextStyle(
                    color: kCardTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize(size: wv * 4))))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DoctorModelProvider doctor =
        Provider.of<DoctorModelProvider>(context, listen: false);
    DateTime date;
    // print( doctor.getDoctor.cniName);
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
                  children: [
                    Text('D??marrer'),
                    Text(
                        '${DateFormat('dd MMMM yyyy ?? h:mm').format(DateTime.now())}')
                  ],
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
                  widget.isLaunchConsultation == true
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 3.0),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: wv * 5, top: hv * 1),
                                  child: Text(
                                      'Choisir le type de consultation ',
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
                                        index: 1,
                                        consultation: 'consultation',
                                        consultationType: 'En cabinet',
                                        price: doctor.getDoctor.rate['public']
                                                .toString() +
                                            ' FCFA',
                                        typedeConsultation: encabinet),
                                    offerPart(
                                        index: 2,
                                        consultation: 'consultation',
                                        consultationType: 'Vid??os',
                                        price: '2000 FCFA',
                                        typedeConsultation: videos),
                                    offerPart(
                                        index: 3,
                                        consultation: 'consultation',
                                        consultationType: 'Message',
                                        price: '2000 FCFA',
                                        typedeConsultation: message),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: hv * 5,
                  ),
                  Container(
                    width: wv * 100,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: wv * 68,
                          decoration: BoxDecoration(
                            color: kDeepTealClair,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          padding: EdgeInsets.only(
                            left: wv * 1.9,
                            right: wv * 1.5,
                            top: hv * 1,
                            bottom: 5.h,
                          ),
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
                              left: inch * 2, right: inch * 2, top: inch * 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Form(
                                key: formKey,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: wv * 2),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Rechercher par numero de t??l??phone ",
                                            style: TextStyle(
                                                fontSize: wv * 4,
                                                color: kBlueForce),
                                          ),
                                          SizedBox(
                                            height: hv * 1,
                                          ),
                                          InternationalPhoneNumberInput(
                                            validator: (String phone) {
                                              return (phone.isEmpty)
                                                  ? "Entrer un numero de t??l??phone valide"
                                                  : null;
                                            },
                                            onInputChanged:
                                                (PhoneNumber number) {
                                              phone = number.phoneNumber;
                                              print(number.phoneNumber);
                                            },
                                            onInputValidated: (bool value) {
                                              print(value);
                                            },
                                            hintText: ' numero de telephone',
                                            spaceBetweenSelectorAndTextField: 0,
                                            selectorConfig: SelectorConfig(
                                              selectorType:
                                                  PhoneInputSelectorType
                                                      .BOTTOM_SHEET,
                                            ),
                                            ignoreBlank: false,
                                            textStyle: TextStyle(
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            autoValidateMode:
                                                AutovalidateMode.disabled,
                                            selectorTextStyle:
                                                TextStyle(color: Colors.black),
                                            initialValue: number,
                                            textFieldController: adherentNumber,
                                            formatInput: true,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: true,
                                                    decimal: true),
                                            inputDecoration: InputDecoration(
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.red[300]),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              fillColor: kBgTextColor,
                                              //prefixIcon: Icon(Icons.search, color: kBrownCanyon,),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: kPrimaryColor
                                                          .withOpacity(0.0)),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: kBgTextColor),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                            ),
                                            onSaved: (PhoneNumber number) {
                                              print('On Saved: $number');
                                            },
                                          ),
                                        ])),
                              ),
                              SizedBox(
                                height: hv * 2,
                              ),
                              widget.isLaunchConsultation == true
                                  ? Text("Ou scanner une carte d'adherent",
                                      style: TextStyle(
                                          fontSize: fontSize(size: wv * 4),
                                          fontWeight: FontWeight.w500,
                                          color: kFirstIntroColor))
                                  : SizedBox.shrink(),
                              widget.isLaunchConsultation == true
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          left: inch * 2,
                                          right: inch * 2,
                                          top: inch * 1),
                                      child: GestureDetector(
                                        onTap: () {
                                          _scan();
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
                                  : SizedBox.shrink(),
                              widget.isLaunchConsultation == true
                                  ? Center(
                                      child: Text(
                                          textForQrCode == null
                                              ? ''
                                              : textForQrCode,
                                          style: TextStyle(
                                              fontSize: fontSize(size: wv * 4),
                                              fontWeight: FontWeight.w500,
                                              color: kFirstIntroColor)),
                                    )
                                  : SizedBox.shrink()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: hv * 2,
                  ),
                  confirmSpinner
                      ? Loaders().buttonLoader(kPrimaryColor)
                      : Container(
                          width: wv * 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: wv * 3.2, vertical: hv * 2),
                          child: TextButton(
                            onPressed: () async {
                              print('${phone}');
                              setState(() {
                                confirmSpinner = true;
                              });
                              await FirebaseFirestore.instance
                                  .collection('ADHERENTS')
                                  .doc('${phone}')
                                  .get()
                                  .then((doc) {
                                print(doc.exists);
                                if (consultationTypeData != null &&
                                    widget.isLaunchConsultation == true) {
                                  setState(() {
                                    confirmSpinner = false;
                                  });
                                  if (doc.exists) {
                                    AdherentModelProvider
                                        adherentModelProvider =
                                        Provider.of<AdherentModelProvider>(
                                            context,
                                            listen: false);
                                    AdherentModel adherent =
                                        AdherentModel.fromDocument(doc);
                                    adherentModelProvider
                                        .setAdherentModel(adherent);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "${adherent.dateCreated} ")));

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InactiveAccount(
                                          data: adherent,
                                          phoneNumber: phone,
                                          isAccountIsExists: true,
                                          consultationType:
                                              consultationTypeData,
                                        ),
                                      ),
                                    );
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
                                          data: null,
                                          phoneNumber: phone,
                                          consultationType: 'REFERENCEMENT',
                                        ),
                                      ),
                                    );
                                  }
                                } else if (consultationTypeData == null &&
                                    widget.isLaunchConsultation == false) {
                                  setState(() {
                                    confirmSpinner = false;
                                  });
                                  if (doc.exists) {
                                    AdherentModelProvider
                                        adherentModelProvider =
                                        Provider.of<AdherentModelProvider>(
                                            context,
                                            listen: false);
                                    AdherentModel adherent =
                                        AdherentModel.fromDocument(doc);
                                    adherentModelProvider
                                        .setAdherentModel(adherent);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "${adherent.dateCreated} ")));

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InactiveAccount(
                                          data: adherent,
                                          phoneNumber: phone,
                                          isAccountIsExists: true,
                                          consultationType: 'CONSULTATION',
                                        ),
                                      ),
                                    );
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
                                          data: null,
                                          phoneNumber: phone,
                                          consultationType: 'REFERENCEMENT',
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  setState(() {
                                    confirmSpinner = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Veuillez preciser le type de consultation")));
                                }
                              });
                            },
                            child: Text(
                              'Rechercher',
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))))),
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
  //             " a ??t?? ajout??(e) comme m??decin de famille..")));
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
