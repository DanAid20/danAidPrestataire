import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HealthBookScreen extends StatefulWidget {
  @override
  _HealthBookScreenState createState() => _HealthBookScreenState();
}

class _HealthBookScreenState extends State<HealthBookScreen> {
  TextEditingController phone = new TextEditingController();
  TextEditingController name = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              SizedBox(height: hv*5,),
              Text("Carnet de Santé"),
              Text("Paramètres temporaires : Déconnexion", textAlign: TextAlign.center,),
              SizedBox(height: hv*2,),
              /*TextField(
                controller: phone,
              ),
              SizedBox(height: hv*2,),
              TextField(
                controller: name,
              ),*/
              
              /*TextButton(
                child: Text("Créer un medecin"),
                onPressed: () async {
                  Map availabilty = {
                    "monday to friday" : {
                      "available" : true,
                      "start" : TimeOfDay(hour: 8, minute: 00).format(context),
                      "end" : TimeOfDay(hour: 16, minute: 00).format(context)
                    },
                    "weekend" : {
                      "available" : true,
                      "start" : TimeOfDay(hour: 8, minute: 00).format(context),
                      "end" : TimeOfDay(hour: 16, minute: 00).format(context)
                    },
                    "monday" : {
                      "start" : TimeOfDay(hour: 8, minute: 00).format(context),
                      "end" : TimeOfDay(hour: 16, minute: 00).format(context)
                    },
                    "tuesday" : {
                      "start" : TimeOfDay(hour: 8, minute: 00).format(context),
                      "end" : TimeOfDay(hour: 16, minute: 00).format(context)
                    },
                    "wednesday" : {
                      "start" : TimeOfDay(hour: 8, minute: 00).format(context),
                      "end" : TimeOfDay(hour: 16, minute: 00).format(context)
                    },
                    "thursday" : {
                      "start" : TimeOfDay(hour: 8, minute: 00).format(context),
                      "end" : TimeOfDay(hour: 16, minute: 00).format(context)
                    },
                    "friday" : {
                      "start" : TimeOfDay(hour: 8, minute: 00).format(context),
                      "end" : TimeOfDay(hour: 16, minute: 00).format(context)
                    },
                    "saturday" : {
                      "start" : TimeOfDay(hour: 8, minute: 00).format(context),
                      "end" : TimeOfDay(hour: 16, minute: 00).format(context)
                    },
                    "sunday" : {
                      "start" : TimeOfDay(hour: 8, minute: 00).format(context),
                      "end" : TimeOfDay(hour: 16, minute: 00).format(context)
                    },
                  };
                  var localisation = {
                    "addresse": "Nouvelle Route, Face Hotel la Falaise",
                    "latitude": 4.498504266423082,
                    "longitude": 12.228042871599243,
                    "altitude": 0
                  };
                  var serviceList = {
                    "consultation" : true,
                    "tele-consultation" : true,
                    "visite-a-domicile" : false,
                    "chat" : true,
                    "rdv" : false
                  };
                  var tarif = {
                    "public": 3000,
                    "adherent": 900,
                    "other": 2950
                  };
                  print(phone.text + " hey " + name.text);
                  FirebaseFirestore.instance.collection("MEDECINS")
                    .doc(phone.text)
                    .set({
                      //"certificatDenregistrmDordre": registerOrder,
                      "communeHospital": "Yaoundé",
                      "about": "Informed member of a project team using the PMAss method. The aim here is to understand the principles of the method, to master terminology and concept.",
                      "addresse": "Nouvelle Route, Face Hotel la Falaise",
                      "nomEtablissement": "Hôpital Centrale de Yaoundé",
                      "specialite": "Médécine générale",
                      "domaine": "Généraliste",
                      "cniName": name.text,
                      "createdDate": DateTime.now(),
                      "id": phone.text,
                      "enabled": true,
                      "phoneList": FieldValue.arrayUnion([{"number": phone.text}]),
                      "profil": "MEDECIN",
                      "profilEnabled": true,
                      "availability" : availabilty,
                      "localisation" : localisation,
                      "serviceList" : serviceList,
                      "tarif": tarif,
                      "urlImage": "https://firebasestorage.googleapis.com/v0/b/danaid-dev.appspot.com/o/photos%2Fprofils_adherents%2F%2B237670424589?alt=media&token=8a276245-a068-42ad-a7cb-980455646c30"
                    }, SetOptions(merge: true));
                },
              ),*/
              
              TextButton(
                child: Text("Se Déconnecter"),
                onPressed: () async {
                  AdherentModelProvider adherent = Provider.of<AdherentModelProvider>(context, listen: false);
                  ServiceProviderModelProvider sp = Provider.of<ServiceProviderModelProvider>(context, listen: false);
                  DoctorModelProvider doctor = Provider.of<DoctorModelProvider>(context, listen: false);
                  UserProvider user = Provider.of<UserProvider>(context, listen: false);
                  user.setUserId(null);
                  user.setProfileType(null);
                  user.setUserModel(null);
                  adherent.setAdherentModel(null);
                  sp.setServiceProviderModel(null);
                  doctor.setDoctorModel(null);
                  HiveDatabase.setRegisterState(false);
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],),
          ),
        ),
      ),
    );
  }
}