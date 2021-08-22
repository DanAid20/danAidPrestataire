import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProviderModel {
  String id, about, localisation,specialite, profileType, category, name, region, town, contactName, contactEmail, authPhone, countryName, isoCountryCode, contactFunction, avatarUrl, cniUrl, orderRegistrationCertificateUrl, otherDocUrl;
  bool profileEnabled;
  List phoneList = [], phoneKeywords, nameKeywords;
  var serviceList;
  Map coordGps;
  Timestamp dateCreated;

  ServiceProviderModel({this.id, this.about,  this.specialite, this.serviceList, this.coordGps, this.profileType, this.category, this.phoneKeywords, this.nameKeywords, this.name, this.region, this.town, this.contactName, this.contactEmail, this.authPhone, this.countryName, this.isoCountryCode, this.contactFunction, this.localisation, this.avatarUrl, this.cniUrl, this.orderRegistrationCertificateUrl, this.otherDocUrl, this.profileEnabled, this.phoneList, this.dateCreated});

  factory ServiceProviderModel.fromDocument(DocumentSnapshot doc){
    return ServiceProviderModel(
      id: doc.id, 
      about: doc.data()["about"],
      dateCreated: doc.data()["createdDate"],
      name: doc.data()["nomEtablissement"],
      contactName: doc.data()["nomCompletPContact"],
      contactEmail: doc.data()["emailPContact"],
      authPhone: doc.data()["authPhoneNumber"],
      category: doc.data()["categorieEtablissement"],
      avatarUrl: doc.data()["imageUrl"],
      cniUrl: doc.data()["urlScaneCNI"],
      localisation: doc.data()["addresse"],
      specialite: doc.data()["contactFunction"],
      coordGps: doc.data()["localisation"],
      otherDocUrl: doc.data()["urlDautreJustificatif"],
      orderRegistrationCertificateUrl: doc.data()["urlScaneCertificatEnregDordr"],
      phoneList: doc.data()["phoneList"],
      profileType: doc.data()["profil"],
      profileEnabled: doc.data()["profilEnabled"],
      region: doc.data()["region"],
      town: doc.data()["villeEtab"],
      isoCountryCode: doc.data()["userCountryCodeIso"],
      countryName: doc.data()["userCountryName"],
      phoneKeywords: doc.data()["phoneKeywords"],
      nameKeywords: doc.data()["nameKeywords"], 
      serviceList: doc.data()["serviceList"],
    );
  }
}