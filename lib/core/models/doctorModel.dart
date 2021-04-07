
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  String id, officeCategory, officeName, hospitalRegion, familyName, surname, about, orderRegistrationCertificate, address, cniName, hospitalTown, field, speciality, email, personContactName, personContactPhone, gender, town, region, profile, medicalService, avatarUrl, cniUrl, orderRegistrationCertificateUrl;
  bool profileEnabled;
  List adherentList;
  Timestamp dateCreated;
  var serviceList, phoneList;
  Map location, rate, availability;

  DoctorModel({this.id, this.adherentList, this.hospitalRegion, this.rate, this.officeCategory, this.about, this.address, this.officeName, this.familyName, this.surname, this.dateCreated, this.availability, this.serviceList, this.orderRegistrationCertificate, this.cniName, this.hospitalTown, this.field, this.speciality, this.email, this.personContactName, this.personContactPhone, this.gender, this.town, this.region, this.profile, this.medicalService, this.avatarUrl, this.cniUrl, this.orderRegistrationCertificateUrl, this.profileEnabled, this.phoneList, this.location});
 
  factory DoctorModel.fromDocument(DocumentSnapshot doc){
    return DoctorModel(
      id: doc.id,
      about: doc.data()["about"],
      officeCategory: doc.data()["categorieEtablissement"],
      officeName: doc.data()["nomEtablissement"],
      familyName: doc.data()["nomDefamille"],
      surname: doc.data()["prenom"],
      orderRegistrationCertificate: doc.data()["certificatDenregistrmDordre"],
      cniName: doc.data()["cniName"],
      hospitalTown: doc.data()["communeHospital"],
      hospitalRegion: doc.data()["regionEtablissement"],
      field: doc.data()["domaine"],
      speciality: doc.data()["specialite"],
      email: doc.data()["email"],
      personContactName: doc.data()["personneContactName"],
      personContactPhone: doc.data()["personneContactPhone"],
      gender: doc.data()["sexe"],
      town: doc.data()["ville"],
      region: doc.data()["regionDorigione"],
      profile: doc.data()["profil"],
      medicalService: doc.data()["serviceMedcin"],
      avatarUrl: doc.data()["urlImage"],
      cniUrl: doc.data()["urlScaneCNI"],
      orderRegistrationCertificateUrl: doc.data()["urlScaneCertificatEnregDordr"],
      dateCreated: doc.data()["dateCreated"],
      phoneList: doc.data()["phoneList"],
      address: doc.data()["addresse"],
      location: doc.data()["localisation"],
      adherentList: doc.data()["adherentList"],
      serviceList: doc.data()["serviceList"],
      availability: doc.data()["availability"],
      rate: doc.data()["tarif"]
    );
  }
}