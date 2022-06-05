import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/getPlatform.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/inactive_account_views.dart';
import 'package:danaid/views/serviceprovider/services_provider_views/inactive_account_views_Providers.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qrscan2/qrscan2.dart' as scanner;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';

class AddPatientViewServiceProvider extends StatefulWidget {
  bool? isLaunchConsultation;
  AddPatientViewServiceProvider({Key? key, this.isLaunchConsultation}) : super(key: key);
  @override
  _AddPatientViewServiceProviderState createState() => _AddPatientViewServiceProviderState();
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

class _AddPatientViewServiceProviderState extends State<AddPatientViewServiceProvider> {
  bool? confirmSpinner = false;
  final GlobalKey? qrKey = GlobalKey(debugLabel: 'QR');
  String? textForQrCode;
  String? initialCountry = 'CM';
  PhoneNumber? number = PhoneNumber(isoCode: 'CM');
  TextEditingController? adherentNumber =  TextEditingController();
  Country? _selectedDialogCountry =CountryPickerUtils.getCountryByPhoneCode('237');
  String? phoneCode = "237";
  //only for choose type of consultaion
  int? currentItemSelect = 0;
  int? price = 0;
  String? consultationTypeData;
  String? encabinet = S.current.encabinet;
  String? videos = S.current.video;
  String? message = S.current.message;
  String? phone;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    adherentNumber = TextEditingController();
    super.initState();
  }

  Future _scan() async {
    await Permission.camera.request();
    String? barcode = await scanner.scan();
    if (barcode == null) {
      if (kDebugMode) {
        print('nothing return.');
      }
      setState(() {
        textForQrCode = barcode ?? S.of(context).codebarvide;
      });
    } else {
      setState(() {
        textForQrCode = barcode;
      });
      if (validateMobile(textForQrCode!) == true) {
        if (kDebugMode) {
          print(textForQrCode);
        }
        setState(() {
          confirmSpinner = true;
        });
        await FirebaseFirestore.instance
            .collection('ADHERENTS')
            .doc(barcode)
            .get()
            .then((doc) {
          if (kDebugMode) {
            print(doc.exists);
          }
          if (consultationTypeData != null) {
            setState(() {
              confirmSpinner = false;
            });
            if (doc.exists) {
              AdherentModelProvider adherentModelProvider =
                  Provider.of<AdherentModelProvider>(context, listen: false);
              AdherentModel adherent = AdherentModel.fromDocument(doc, doc.data() as Map);
              adherentModelProvider.setAdherentModel(adherent);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${adherent.dateCreated} ")));
              print(adherent.toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InactiveAccountProvider(
                    data: adherent,
                    phoneNumber: barcode,
                    isAccountIsExists: true,
                    consultationType: consultationTypeData!,
                  ),
                ),
              );
            } else {
              setState(() {
                confirmSpinner = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.of(context).cetAdherentNexistePas)));
              AdherentModel? obj= AdherentModel();
              String? consultationType= '';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InactiveAccountProvider(
                    isAccountIsExists: false,
                    data: obj,
                    phoneNumber: phone!,
                    consultationType: consultationType,
                  ),
                ),
              );
            }
          } else {
            setState(() {
              confirmSpinner = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(S.of(context).veuillezPreciserLeTypeDeConsultation)));
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(S.of(context).veuillezScannerUnnumeroDeTlphoneValideSvp)));
      }
      setState(() {
        confirmSpinner = false;
      });
    }
  }

  checking() async {}

  @override
  void dispose() {
    adherentNumber?.dispose();
    super.dispose();
  }

  setconsultationType(consultation, index) {
    setState(() {
      consultationTypeData = consultation;
      currentItemSelect = index;
    });
    if (kDebugMode) {
      print(consultationTypeData);
      print(currentItemSelect);
    }
  }

  Widget offerPart(
      {int? index,
      String? consultation,
      String? consultationType,
      String? price,
      String? typedeConsultation}) {
    return GestureDetector(
      onTap: () {
        setconsultationType(typedeConsultation,  index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              margin: EdgeInsets.only(
                  left: Device.isSmartphone(context) ? wv * 6 : wv * 1, right: wv * 1.5, top: hv * 2, bottom: hv * 1),
               width: Device.isSmartphone(context) ? 130.w : 200 ,
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                      color:
                          currentItemSelect == index ? kDeepTeal : kThirdColor,
                      spreadRadius: 0.5,
                      blurRadius: 4),
                ],
                borderRadius: const BorderRadius.all(
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
                        consultationType == S.of(context).vidos
                            ? 'assets/icons/Bulk/VideoTeal.svg'
                            : consultationType == S.of(context).message
                                ? 'assets/icons/Bulk/Message.svg'
                                : 'assets/icons/Bulk/Profile-color.svg',
                         width:Device.isSmartphone(context) ? wv * 10 : wv * 3,
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
                          consultation!,
                          style: TextStyle(
                              color: kCardTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize(size: Device.isSmartphone(context) ? wv * 4: 6)),
                        ),
                        Text(
                          consultationType!,
                          style: TextStyle(
                              color: kCardTextColor,
                              fontWeight: FontWeight.w800,
                              fontSize: fontSize(size: Device.isSmartphone(context) ? wv * 4: 6)),
                        ),
                        SizedBox(
                          height: hv * 1.3,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: hv * 0.5, bottom: 8.h),
                            child: Text(
                              price!,
                              style: TextStyle(
                                  color: kCardTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: fontSize(size:Device.isSmartphone(context) ? wv * 4: 6)),
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
    RegExp regExp =  RegExp(pattern);

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
                titlePadding: const EdgeInsets.all(10.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration: InputDecoration(
                    hintText: S.of(context).chercher,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                isSearchable: true,
                title: Text(S.of(context).selectionnezVotrePays),
                onValuePicked: (Country country) {
                  if (kDebugMode) {
                    print(country.isoCode);
                    print(country.name);
                    print(country.phoneCode);
                    print(country.iso3Code);
                  }
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
        const SizedBox(width: 5.0),
        Text("+${country.phoneCode}",
            style: TextStyle(
                color: kCardTextColor,
                fontWeight: FontWeight.w500,
                fontSize: fontSize(size: wv * 4))),
        const SizedBox(width: 5.0),
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

    // print( doctor.getDoctor.cniName);
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor:  kDeepYellow,
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: kDateTextColor,
                ),
                onPressed: () => Navigator.pop(context)),
            title: Align(
              alignment: Alignment.center,
              child: Container(
                child: Column(
                  children: [
                    Text(S.of(context).dmarrer),
                    Text(DateFormat('dd MMMM yyyy à h:mm').format(DateTime.now()))
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
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  widget.isLaunchConsultation == true
                      ? Container(
                          constraints: BoxConstraints(
                          maxWidth: Device.isSmartphone(context) ? double.infinity : wv*43
                        ),
                        margin: EdgeInsets.symmetric(vertical: 3.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:  BorderRadius.circular(10),
                              // ignore: prefer_const_literals_to_create_immutables
                              boxShadow: [
                                const BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 0.5,
                                    blurRadius: 2),
                              ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: Device.isSmartphone(context) ? wv * 5 : 10 , top: hv * 1),
                                  child: Text(
                                      S.of(context).choisirLeTypeDeConsultation,
                                      style: TextStyle(
                                          fontSize: fontSize(size:  Device.isSmartphone(context) ? wv * 4 : 6),
                                          fontWeight: FontWeight.w700,
                                          color: kPrimaryColor)),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 2.0),
                                height:  Device.isSmartphone(context) ? hv * 17 : hv * 23,
                               
                                child:  ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    offerPart(
                                        index: 1,
                                        consultation: S.of(context).consultation,
                                        consultationType: S.of(context).enCabinet,
                                        price: '2000 FCFA',
                                        typedeConsultation: encabinet),
                                    offerPart(
                                        index: 2,
                                        consultation: S.of(context).consultation,
                                        consultationType: S.of(context).vidos,
                                        price: '2000 FCFA',
                                        typedeConsultation: videos),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  SizedBox(
                    height: hv * 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                       constraints: BoxConstraints(
                          maxWidth: Device.isSmartphone(context) ? double.infinity : wv*43
                        ),
                       margin: EdgeInsets.symmetric(horizontal:  Device.isSmartphone(context) ? 0 : wv*28),
                      width:Device.isSmartphone(context) ? wv * 100 : wv*90 ,
                       decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:  BorderRadius.circular(10),
                            ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Device.isSmartphone(context) ? wv * 68 : wv * 30,
                            decoration: const BoxDecoration(
                              color: kDeepTealClair,
                              borderRadius:  BorderRadius.only(
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
                                  S.of(context).selectionnerOuAjouterLePatient,
                                  style: TextStyle(
                                      fontSize: fontSize(size: Device.isSmartphone(context) ?  wv * 4 : 6),
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
                                              S.of(context).rechercherParNumeroDeTlphone,
                                              style: TextStyle(
                                                  fontSize: Device.isSmartphone(context) ?  wv * 4 : 14,
                                                  color: kBlueForce),
                                            ),
                                            SizedBox(
                                              height: hv * 1,
                                            ),
                                            InternationalPhoneNumberInput(
                                              validator: (String? phone) {
                                                return (phone!.isEmpty)
                                                    ? S.of(context).entrerUnNumeroDeTlphoneValide
                                                    : null;
                                              },
                                              onInputChanged:
                                                  (PhoneNumber number) {
                                                phone = number.phoneNumber;
                                                if (kDebugMode) {
                                                  print(number.phoneNumber);
                                                }
                                              },
                                              onInputValidated: (bool value) {
                                                if (kDebugMode) {
                                                  print(value);
                                                }
                                              },
                                              hintText: S.of(context).numeroDeTelephone,
                                              spaceBetweenSelectorAndTextField: 0,
                                              selectorConfig:const SelectorConfig(
                                                selectorType: 
                                                    PhoneInputSelectorType
                                                        .BOTTOM_SHEET,
                                              ),
                                              ignoreBlank: false,
                                              textStyle: const TextStyle(
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
                                              keyboardType: const
                                                  TextInputType.numberWithOptions(
                                                      signed: true,
                                                      decimal: true),
                                              inputDecoration: InputDecoration(
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: (Colors.red[300])!),
                                                    borderRadius:const
                                                        BorderRadius.all(
                                                            Radius.circular(20))),
                                                fillColor: kBgTextColor,
                                                //prefixIcon: Icon(Icons.search, color: kBrownCanyon,),
                                                contentPadding:const
                                                    EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 5),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: kPrimaryColor
                                                            .withOpacity(0.0)),
                                                    borderRadius:const
                                                        BorderRadius.all(
                                                            Radius.circular(20))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: kBgTextColor),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(20))),
                                              ),
                                              onSaved: (PhoneNumber number) {
                                                if (kDebugMode) {
                                                  print('On Saved: $number');
                                                }
                                              },
                                            ),
                                          ])),
                                ),
                                SizedBox(
                                  height: Device.isSmartphone(context) ?  hv * 2 : hv * 4
                                ),
                                widget.isLaunchConsultation == true
                                    ? Device.isSmartphone(context) ? Text(S.of(context).ouScannerUneCarteDadherent,
                                        style: TextStyle(
                                            fontSize: fontSize(size: wv * 4),
                                            fontWeight: FontWeight.w500,
                                            color: kFirstIntroColor))
                                    : const SizedBox.shrink(): const SizedBox.shrink(),
                                widget.isLaunchConsultation == true
                                    ?  Device.isSmartphone(context) ? Container(
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
                                              height: Device.isSmartphone(context) ?  hv * 12 : 100 ,
                                              width:Device.isSmartphone(context) ?  wv * 12 : 100,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink():const SizedBox.shrink(),
                                widget.isLaunchConsultation == true
                                    ? Center(
                                        child: Text(
                                            textForQrCode ?? '',
                                            style: TextStyle(
                                                fontSize: fontSize(size: wv * 4),
                                                fontWeight: FontWeight.w500,
                                                color: kFirstIntroColor)),
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: hv * 2,
                  ),
                  confirmSpinner!
                      ? Loaders().buttonLoader(kPrimaryColor)
                      : Container(
                          width: wv * 50,
                          padding: EdgeInsets.symmetric(
                              horizontal:Device.isSmartphone(context) ?  wv * 3.2 : wv * 2.5, vertical: hv * 2),
                          child: TextButton(
                            onPressed: () async {
                              if (kDebugMode) {
                                print(phone);
                              }
                              setState(() {
                                confirmSpinner = true;
                              });
                              await FirebaseFirestore.instance
                                  .collection('ADHERENTS')
                                  .doc(phone)
                                  .get()
                                  .then((doc) {
                                if (kDebugMode) {
                                  print(doc.exists);
                                }
                                if ( widget.isLaunchConsultation == true) {
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
                                        AdherentModel.fromDocument(doc, doc.data() as Map);
                                    adherentModelProvider
                                        .setAdherentModel(adherent);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "${adherent.dateCreated} ")));

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InactiveAccountProvider(
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
                                        SnackBar(content: Text(S.of(context).existePas)));
                                    AdherentModel? data= AdherentModel();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InactiveAccountProvider(
                                          isAccountIsExists: false,
                                          data: data,
                                          phoneNumber: phone!,
                                          consultationType: S.of(context).referencement,
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
                                        AdherentModel.fromDocument(doc, doc.data() as Map);
                                    adherentModelProvider
                                        .setAdherentModel(adherent);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "${adherent.dateCreated} ")));

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InactiveAccountProvider(
                                          data: adherent,
                                          phoneNumber: phone!,
                                          isAccountIsExists: true,
                                          consultationType: S.of(context).consultation.toString()                                        ),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      confirmSpinner = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("existe pas ")));
                                    AdherentModel? data= AdherentModel();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InactiveAccountProvider(
                                          isAccountIsExists: false,
                                          data: data,
                                          phoneNumber: phone!,
                                          consultationType: S.of(context).referencement,
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
                                              S.of(context).veuillezPreciserLeTypeDeConsultation)));
                                }
                              });
                            },
                            child: Text(
                              S.of(context).rechercher,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize:  Device.isSmartphone(context) ? wv * 4.5 : 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(vertical: 15)),
                                backgroundColor:
                                    MaterialStateProperty.all(kFirstIntroColor),
                                shape: MaterialStateProperty.all(
                                   const RoundedRectangleBorder(
                                        borderRadius:   BorderRadius.all(
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
