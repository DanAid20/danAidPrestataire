import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/doctorTileModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/doctor_info_cards.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:danaid/core/models/doctorModel.dart';

class FamilyDoctorList extends StatefulWidget {
  @override
  _FamilyDoctorListState createState() => _FamilyDoctorListState();
}

class _FamilyDoctorListState extends State<FamilyDoctorList> {
  String filter;

  Stream<QuerySnapshot> query = FirebaseFirestore.instance.collection("MEDECINS").where("domaine", isEqualTo: "Généraliste").where("profilEnabled", isEqualTo: true).snapshots();

  getDoctorsList() {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    DoctorTileModelProvider doctorTileProvider = Provider.of<DoctorTileModelProvider>(context, listen: false);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    query = userProvider.getProfileType == doctor ? FirebaseFirestore.instance.collection("MEDECINS").where("domaine", isEqualTo: "Généraliste").where("profilEnabled", isEqualTo: true).where("id", isNotEqualTo: doctorProvider.getDoctor.id).snapshots()
      : FirebaseFirestore.instance.collection("MEDECINS").where("domaine", isEqualTo: "Généraliste").where("profilEnabled", isEqualTo: true).snapshots();
    return (adherentProvider.getAdherent?.location != null && (userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary)) || (doctorProvider.getDoctor?.location != null && userProvider.getProfileType == doctor) 
      ? StreamBuilder(
        stream: query,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }
          int lastIndex = snapshot.data.docs.length - 1;
          return snapshot.data.docs.length >= 1
              ? ListView.builder(
                  //shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data.docs[index];
                    DoctorModel doctor = DoctorModel.fromDocument(doc);
                    print("name: ");

                    return Padding(
                      padding: EdgeInsets.only(bottom: lastIndex == index ? hv * 10 : 0),
                      child: DoctorInfoCard(
                        avatarUrl: doctor.avatarUrl,
                        name: doctor.cniName,
                        title: S.of(context).medecinDeFamille + doctor.field,
                        speciality: doctor.speciality,
                        teleConsultation: doctor.serviceList != null ? doctor.serviceList["tele-consultation"] : false,
                        consultation: doctor.serviceList != null ? doctor.serviceList["consultation"] : false,
                        chat: doctor.serviceList != null ? doctor.serviceList["chat"] : false,
                        rdv: doctor.serviceList != null ? doctor.serviceList["rdv"] : false,
                        visiteDomicile: doctor.serviceList != null ? doctor.serviceList["visite-a-domicile"] : false,
                        distance: 
                          userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary ?  
                            adherentProvider.getAdherent.location["latitude"] != null && doctor.location["latitude"] != null
                              ? (Algorithms.calculateDistance( adherentProvider.getAdherent.location["latitude"], adherentProvider.getAdherent.location["longitude"], doctor.location["latitude"], doctor.location["longitude"]).toStringAsFixed(2)).toString() : null
                          :
                          doctorProvider.getDoctor.location != null && doctor.location != null
                              ? (Algorithms.calculateDistance(doctorProvider.getDoctor.location["latitude"], doctorProvider.getDoctor.location["longitude"], doctor.location["latitude"], doctor.location["longitude"]).toStringAsFixed(2)).toString() : null,
                        onTap: () {
                          doctorTileProvider.setDoctorModel(doctor);
                          Navigator.pushNamed(context, "/doctor-profile");
                        },
                      ),
                    );
                  })
              : Center(
                  child: Text(S.of(context).aucunMedecinDisponiblePourLeMoment),
                );
        }) : Center(
          child: CustomTextButton(
            text: S.of(context).mettezJourVotreProfilAinsiQueVotreLocationGps,
            action: ()=>Navigator.pushNamed(context, '/adherent-profile-edit'),
            ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Row(
          children: [
            Text(S.of(context).ordonnerPar),
            Container(
              margin: EdgeInsets.symmetric(vertical: hv * 1),
              padding:
                  EdgeInsets.symmetric(horizontal: wv * 1, vertical: hv * 1),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                      isDense: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: wv * 8,
                        color: kPrimaryColor,
                      ),
                      hint: Text(
                        S.of(context).choisir,
                        style: TextStyle(
                            color: kPrimaryColor, fontWeight: FontWeight.w600),
                      ),
                      value: filter,
                      items: [
                        DropdownMenuItem(
                          child: Text(S.of(context).nom,
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold)),
                          value: S.of(context).name,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            S.of(context).distance,
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          value: S.of(context).distance,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          filter = value;
                        });
                        if (value == "name") {
                          setState(() {
                            query = FirebaseFirestore.instance
                                .collection("MEDECINS")
                                .where("profilEnabled", isEqualTo: true)
                                .orderBy('cniName')
                                .snapshots();
                          });
                        }
                      }),
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        Container(
          height: hv * 70,
          child: getDoctorsList(),
        ),
      ]),
    );
  }
}
