import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderTileModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/doctor_info_cards.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/getPlatform.dart';

class PharmacyList extends StatefulWidget {
  @override
  _PharmacyListState createState() => _PharmacyListState();
}

class _PharmacyListState extends State<PharmacyList> {
  String? filter;

  Stream<QuerySnapshot> query = FirebaseFirestore.instance.collection("PRESTATAIRE").where("profilEnabled", isEqualTo: true).where("categorieEtablissement", isEqualTo: "Pharmacie").snapshots();

  Widget getServiceProviderList() {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    ServiceProviderTileModelProvider spTileProvider = Provider.of<ServiceProviderTileModelProvider>(context);
    ServiceProviderModelProvider spProvider = Provider.of<ServiceProviderModelProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    query = spProvider.getServiceProvider != null ? FirebaseFirestore.instance.collection("PRESTATAIRE").where("profilEnabled", isEqualTo: true).where("categorieEtablissement", isEqualTo: "Pharmacie").where(FieldPath.documentId, isNotEqualTo: spProvider.getServiceProvider?.id).snapshots()
      : FirebaseFirestore.instance.collection("PRESTATAIRE").where("categorieEtablissement", isEqualTo: "Pharmacie").where("profilEnabled", isEqualTo: true).snapshots();
    print(spProvider.getServiceProvider?.coordGps);
    return StreamBuilder<QuerySnapshot>(
        stream: query,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }
          int lastIndex = snapshot.data!.docs.length - 1;
          return snapshot.data!.docs.length >= 1
              ? ListView.builder(
                  //shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    ServiceProviderModel sp = ServiceProviderModel.fromDocument(doc, doc.data() as Map);
                    print("name: ");

                    return Padding(
                      padding: EdgeInsets.only(bottom: lastIndex == index ? hv * 10 : 0),
                      child: DoctorInfoCard(
                        avatarUrl: sp.avatarUrl == "" ? null : sp.avatarUrl,
                        name: sp.name,
                        title: "Prestataire",
                        speciality: sp.category,
                        isInRdvDetail: false,
                        isServiceProvider: true,
                        teleConsultation: sp.serviceList != null ? sp.serviceList["Consultation"] : false,
                        consultation: sp.serviceList != null ? sp.serviceList["Consultation"] : true,
                        chat: sp.serviceList != null ? sp.serviceList["Consultation"] : true,
                        rdv: sp.serviceList != null ? sp.serviceList["Consultation"] : true,
                        visiteDomicile: sp.serviceList != null ? sp.serviceList["Consultation"] : false,
                        distance: 
                         userProvider.getProfileType == adherent ?  
                             adherentProvider.getAdherent?.location!=null&& adherentProvider.getAdherent!.location!["latitude"] != null && sp.coordGps != null
                              ? sp.coordGps!["latitude"] != null ? (Algorithms.calculateDistance( adherentProvider.getAdherent?.location?["latitude"], adherentProvider.getAdherent?.location?["longitude"], sp.coordGps?["latitude"], sp.coordGps?["longitude"]).toStringAsFixed(2)).toString() : null : null
                          :
                          spProvider.getServiceProvider?.coordGps != null && sp.coordGps != null
                              ? (Algorithms.calculateDistance(spProvider.getServiceProvider?.coordGps?["latitude"], spProvider.getServiceProvider?.coordGps?["longitude"], sp.coordGps?["latitude"], sp.coordGps?["longitude"]).toStringAsFixed(2)).toString() : null,
                        onTap: () {
                          spTileProvider.setServiceProviderModel(sp);
                          Navigator.pushNamed(context, "/serviceprovider-profile");
                        },
                      ),
                    );
                  })
              : Center(
                  child: Text("Aucune clinique disponible pour le moment.."),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
                child: DropdownButton<String>(
                    isDense: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: Device.isSmartphone(context) ? wv * 8 : 25,
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
                              .collection("PRESTATAIRE")
                              .where("profilEnabled", isEqualTo: true)
                              .orderBy('nomEtablissement')
                              .snapshots();
                        });
                      }
                    }),
              ),
            ),
          ),
        ],
        mainAxisAlignment: Device.isSmartphone(context) ? MainAxisAlignment.start : MainAxisAlignment.center,
      ),
      SizedBox(
        height: hv * 70,
        width: Device.isSmartphone(context) ? wv*100 : 1000,
        child: getServiceProviderList(),
      ),
    ]);
  }
}
