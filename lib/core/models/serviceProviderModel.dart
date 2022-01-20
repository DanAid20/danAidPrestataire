import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProviderModel {
  String? id, about, localisation,specialite, profileType, category, name, region, town, contactName, contactEmail, authPhone, countryName, isoCountryCode, contactFunction, avatarUrl, cniUrl, orderRegistrationCertificateUrl, otherDocUrl;
  bool? profileEnabled;
  List? phoneList = [], phoneKeywords, nameKeywords;
  var serviceList;
  Map? coordGps;
  Timestamp? dateCreated;

  ServiceProviderModel({this.id, this.about,  this.specialite, this.serviceList, this.coordGps, this.profileType, this.category, this.phoneKeywords, this.nameKeywords, this.name, this.region, this.town, this.contactName, this.contactEmail, this.authPhone, this.countryName, this.isoCountryCode, this.contactFunction, this.localisation, this.avatarUrl, this.cniUrl, this.orderRegistrationCertificateUrl, this.otherDocUrl, this.profileEnabled, this.phoneList, this.dateCreated});

  factory ServiceProviderModel.fromDocument(DocumentSnapshot doc){
    return ServiceProviderModel(
      id: doc.id, 
      about: doc.get("about"),
      dateCreated: doc.get("createdDate"),
      name: doc.get("nomEtablissement"),
      contactName: doc.get("nomCompletPContact"),
      contactEmail: doc.get("emailPContact"),
      authPhone: doc.get("authPhoneNumber"),
      category: doc.get("categorieEtablissement"),
      avatarUrl: doc.get("imageUrl"),
      cniUrl: doc.get("urlScaneCNI"),
      localisation: doc.get("addresse"),
      specialite: doc.get("contactFunction"),
      coordGps: doc.get("localisation"),
      otherDocUrl: doc.get("urlDautreJustificatif"),
      orderRegistrationCertificateUrl: doc.get("urlScaneCertificatEnregDordr"),
      phoneList: doc.get("phoneList"),
      profileType: doc.get("profil"),
      profileEnabled: doc.get("profilEnabled"),
      region: doc.get("region"),
      town: doc.get("villeEtab"),
      isoCountryCode: doc.get("userCountryCodeIso"),
      countryName: doc.get("userCountryName"),
      phoneKeywords: doc.get("phoneKeywords"),
      nameKeywords: doc.get("nameKeywords"), 
      serviceList: doc.get("serviceList"),
    );
  }
}