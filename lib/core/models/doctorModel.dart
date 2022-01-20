import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  String id, authId, officeCategory, officeName, hospitalRegion, familyName, surname, about, orderRegistrationCertificate, address, cniName, hospitalTown, field, speciality, email, personContactName, personContactPhone, gender, town, region, profile, medicalService, avatarUrl, cniUrl, orderRegistrationCertificateUrl;
  bool profileEnabled;
  List adherentList, keywords, phoneKeywords, nameKeywords, planning;
  Timestamp dateCreated;
  var serviceList, phoneList;
  Map location, rate, availability;

  DoctorModel({this.id, this.authId, this.keywords, this.phoneKeywords, this.planning, this.nameKeywords, this.adherentList, this.hospitalRegion, this.rate, this.officeCategory, this.about, this.address, this.officeName, this.familyName, this.surname, this.dateCreated, this.availability, this.serviceList, this.orderRegistrationCertificate, this.cniName, this.hospitalTown, this.field, this.speciality, this.email, this.personContactName, this.personContactPhone, this.gender, this.town, this.region, this.profile, this.medicalService, this.avatarUrl, this.cniUrl, this.orderRegistrationCertificateUrl, this.profileEnabled, this.phoneList, this.location});
 
  factory DoctorModel.fromDocument(DocumentSnapshot doc){
    return DoctorModel(
      id: doc.id,
      authId: doc.get("authId"),
      keywords: doc.get("keywords"),
      about: doc.get("about"),
      planning: doc.get("planning"),
      officeCategory: doc.get("categorieEtablissement"),
      officeName: doc.get("nomEtablissement"),
      familyName: doc.get("nomDefamille"),
      surname: doc.get("prenom"),
      orderRegistrationCertificate: doc.get("certificatDenregistrmDordre"),
      cniName: doc.get("cniName"),
      hospitalTown: doc.get("communeHospital"),
      hospitalRegion: doc.get("regionEtablissement"),
      field: doc.get("domaine"),
      speciality: doc.get("specialite"),
      email: doc.get("email"),
      personContactName: doc.get("personneContactName"),
      personContactPhone: doc.get("personneContactPhone"),
      gender: doc.get("sexe"),
      town: doc.get("ville"),
      region: doc.get("regionDorigione"),
      profile: doc.get("profil"),
      medicalService: doc.get("serviceMedcin"),
      avatarUrl: doc.get("urlImage"),
      cniUrl: doc.get("urlScaneCNI"),
      orderRegistrationCertificateUrl: doc.get("urlScaneCertificatEnregDordr"),
      dateCreated: doc.get("dateCreated"),
      phoneList: doc.get("phoneList"),
      address: doc.get("addresse"),
      location: doc.get("localisation"),
      adherentList: doc.get("adherentList"),
      serviceList: doc.get("serviceList"),
      availability: doc.get("availability"),
      rate: doc.get("tarif"),
      phoneKeywords: doc.get("phoneKeywords"),
      nameKeywords: doc.get("nameKeywords")
    );
  }
}