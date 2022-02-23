import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/doctorTileModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/social_network_views/create_group.dart';
import 'package:danaid/widgets/doctor_info_cards.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class PartnersSearchScreen extends StatefulWidget {
  const PartnersSearchScreen({ Key? key }) : super(key: key);

  @override
  _PartnersSearchScreenState createState() => _PartnersSearchScreenState();
}

class _PartnersSearchScreenState extends State<PartnersSearchScreen> {
  QuerySnapshot? searchSnapshot;
  Future<QuerySnapshot>? futureSearchResults;
  TextEditingController _searchController = new TextEditingController();
  bool searchDoc = true;

  searchResults() {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    DoctorTileModelProvider doctorTileProvider = Provider.of<DoctorTileModelProvider>(context, listen: false);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    var query = searchDoc ? doctorProvider.getDoctor != null ? FirebaseFirestore.instance.collection("MEDECINS").where("nameKeywords", arrayContains: _searchController.text.toLowerCase()).where("profilEnabled", isEqualTo: true).where("id", isNotEqualTo: doctorProvider.getDoctor!.id).snapshots()
      : FirebaseFirestore.instance.collection("MEDECINS").where("domaine", isEqualTo: "Généraliste").where("nameKeywords", arrayContains: _searchController.text.toLowerCase()).where("profilEnabled", isEqualTo: true).snapshots() : FirebaseFirestore.instance.collection("PRESTATAIRES").where("nameKeywords", arrayContains: _searchController.text.toLowerCase()).where("domaine", isEqualTo: "Généraliste").where("profilEnabled", isEqualTo: true).snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: query,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        int lastIndex = snapshot.data!.docs.length - 1;
        return snapshot.data!.docs.length >= 1 ? ListView.builder(
          //shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            DoctorModel doctor = DoctorModel.fromDocument(doc, doc.data() as Map);
            print("name: ");

            return Padding(
              padding: EdgeInsets.only(bottom: lastIndex == index ? hv * 10 : 0),
              child: DoctorInfoCard(
                avatarUrl: doctor.avatarUrl,
                name: doctor.cniName,
                title: S.of(context).medecinDeFamille + doctor.field!,
                speciality: doctor.speciality,
                teleConsultation: doctor.serviceList != null ? doctor.serviceList["tele-consultation"] : false,
                consultation: doctor.serviceList != null ? doctor.serviceList["consultation"] : false,
                chat: doctor.serviceList != null ? doctor.serviceList["chat"] : false,
                rdv: doctor.serviceList != null ? doctor.serviceList["rdv"] : false,
                visiteDomicile: doctor.serviceList != null ? doctor.serviceList["visite-a-domicile"] : false,
                distance: 
                  userProvider.getProfileType == adherent ?  
                    adherentProvider.getAdherent?.location!["latitude"] != null && doctor.location!["latitude"] != null
                      ? (Algorithms.calculateDistance( adherentProvider.getAdherent?.location!["latitude"], adherentProvider.getAdherent?.location!["longitude"], doctor.location!["latitude"], doctor.location!["longitude"]).toStringAsFixed(2)).toString() : null
                  :
                  doctorProvider.getDoctor?.location != null && doctor.location != null
                      ? (Algorithms.calculateDistance(doctorProvider.getDoctor?.location!["latitude"], doctorProvider.getDoctor?.location!["longitude"], doctor.location!["latitude"], doctor.location!["longitude"]).toStringAsFixed(2)).toString() : null,
                onTap: () {
                  doctorTileProvider.setDoctorModel(doctor);
                  Navigator.pushNamed(context, "/doctor-profile");
                },
              ),
            );
          }) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Icon(MdiIcons.databaseRemove, color: kSouthSeas.withOpacity(0.7), size: 85,),
              SizedBox(height: 5,),
              Text(S.of(context).aucunMdecinAvecPourNom+":\n \"${_searchController.text}\"", 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kSouthSeas )
              , textAlign: TextAlign.center,),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Row(
          children: <Widget>[
            InkWell(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(50),
            ),
            SizedBox(
              width: 0,
            ),
            Expanded(
              child: Container(
                height: 45,
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 5),

                // TextField
                child: TextField(
                  autofocus: true,
                  controller: _searchController,
                  onChanged: (val) {
                    setState((){});
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(color: whiteColor),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: whiteColor),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.0)),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.0)),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.0)),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: S.of(context).entrezLeNom,
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(bottom: 12, left: 15, right: 15),

                    /*prefixIcon: IconButton(icon :Icon(Icons.arrow_back_ios), enableFeedback: false, 
                    onPressed: (){Navigator.pop(context);},),*/
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 7)
          ],
        ),
      ),
      body: (_searchController.text != "")
          ? Container(
              child: searchResults())
          : noUsers(context),
    );
  }

  Widget noUsers(context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: hv * 30),
            Hero(
              tag: "search",
              child: Icon(
                Icons.search,
                size: hv * 15,
                color: kSouthSeas,
              ),
            ),
            Text(
              S.of(context).rechercheDeMdecins,
              style: TextStyle(fontSize: 17, color: kSouthSeas, fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
    );
  }
}