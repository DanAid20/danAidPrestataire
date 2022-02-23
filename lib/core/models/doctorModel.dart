import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  String? id, authId, officeCategory, officeName, hospitalRegion, familyName, surname, about, orderRegistrationCertificate, address, cniName, hospitalTown, field, speciality, email, personContactName, personContactPhone, gender, town, region, profile, medicalService, avatarUrl, cniUrl, orderRegistrationCertificateUrl;
  bool? profileEnabled;
  List? adherentList, keywords, phoneKeywords, nameKeywords, planning;
  Timestamp? dateCreated;
  var serviceList, phoneList;
  Map? location, rate, availability;

  DoctorModel({this.id, this.authId, this.keywords, this.phoneKeywords, this.planning, this.nameKeywords, this.adherentList, this.hospitalRegion, this.rate, this.officeCategory, this.about, this.address, this.officeName, this.familyName, this.surname, this.dateCreated, this.availability, this.serviceList, this.orderRegistrationCertificate, this.cniName, this.hospitalTown, this.field, this.speciality, this.email, this.personContactName, this.personContactPhone, this.gender, this.town, this.region, this.profile, this.medicalService, this.avatarUrl, this.cniUrl, this.orderRegistrationCertificateUrl, this.profileEnabled, this.phoneList, this.location});
 
  factory DoctorModel.fromDocument(DocumentSnapshot doc, Map data){
    return DoctorModel(
      id: doc.id,
      authId: data["authId"],
      keywords: data["keywords"],
      about: data["about"],
      planning: data["planning"],
      officeCategory: data["categorieEtablissement"],
      officeName: data["nomEtablissement"],
      familyName: data["nomDefamille"],
      surname: data["prenom"],
      orderRegistrationCertificate: data["certificatDenregistrmDordre"],
      cniName: data["cniName"],
      hospitalTown: data["communeHospital"],
      hospitalRegion: data["regionEtablissement"],
      field: data["domaine"],
      speciality: data["specialite"],
      email: data["email"],
      personContactName: data["personneContactName"],
      personContactPhone: data["personneContactPhone"],
      gender: data["sexe"],
      town: data["ville"],
      region: data["regionDorigione"],
      profile: data["profil"],
      medicalService: data["serviceMedcin"],
      avatarUrl: data["urlImage"],
      cniUrl: data["urlScaneCNI"],
      orderRegistrationCertificateUrl: data["urlScaneCertificatEnregDordr"],
      dateCreated: data["dateCreated"],
      phoneList: data["phoneList"],
      address: data["addresse"],
      location: data["localisation"],
      adherentList: data["adherentList"],
      serviceList: data["serviceList"],
      availability: data["availability"],
      rate: data["tarif"],
      phoneKeywords: data["phoneKeywords"],
      nameKeywords: data["nameKeywords"]
    );
  }
}