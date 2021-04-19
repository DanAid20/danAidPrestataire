import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/inactive_account_views.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/buttons/default_btn.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

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
  TextEditingController adherentNumber = new TextEditingController();
  Widget offerPart() {
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
                        'Consultation',
                        style: TextStyle(
                            color: kCardTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: fontSize(size: wv * 4)),
                      ),
                      Text(
                        'en Cabinet',
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
                            '2000 cfa',
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
                              offerPart(),
                              offerPart(),
                              offerPart(),
                              offerPart(),
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
                    height: hv * 44,
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
                              left: inch * 2, right: inch * 2, top: inch * 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    'assets/icons/Bulk/Scan.svg',
                                    color: kSouthSeas,
                                    height: hv * 12,
                                    width: wv * 12,
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
                            .doc('${adherentNumber.text}')
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

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InactiveAccount(
                                  data: adherent,
                                  phoneNumber: adherentNumber.text,
                                  isAccountIsExists: true,
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
