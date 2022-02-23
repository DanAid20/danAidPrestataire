import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProviderModel {
  String? id, about, localisation,specialite, profileType, category, name, region, town, contactName, contactEmail, authPhone, countryName, isoCountryCode, contactFunction, avatarUrl, cniUrl, orderRegistrationCertificateUrl, otherDocUrl;
  bool? profileEnabled;
  List? phoneList = [], phoneKeywords, nameKeywords;
  var serviceList;
  Map? coordGps;
  Timestamp? dateCreated;

  ServiceProviderModel({this.id, this.about,  this.specialite, this.serviceList, this.coordGps, this.profileType, this.category, this.phoneKeywords, this.nameKeywords, this.name, this.region, this.town, this.contactName, this.contactEmail, this.authPhone, this.countryName, this.isoCountryCode, this.contactFunction, this.localisation, this.avatarUrl, this.cniUrl, this.orderRegistrationCertificateUrl, this.otherDocUrl, this.profileEnabled, this.phoneList, this.dateCreated});

  factory ServiceProviderModel.fromDocument(DocumentSnapshot doc, Map data){
    return ServiceProviderModel(
      id: doc.id, 
      about: data["about"],
      dateCreated: data["createdDate"],
      name: data["nomEtablissement"],
      contactName: data["nomCompletPContact"],
      contactEmail: data["emailPContact"],
      authPhone: data["authPhoneNumber"],
      category: data["categorieEtablissement"],
      avatarUrl: data["imageUrl"],
      cniUrl: data["urlScaneCNI"],
      localisation: data["addresse"],
      specialite: data["contactFunction"],
      coordGps: data["localisation"],
      otherDocUrl: data["urlDautreJustificatif"],
      orderRegistrationCertificateUrl: data["urlScaneCertificatEnregDordr"],
      phoneList: data["phoneList"],
      profileType: data["profil"],
      profileEnabled: data["profilEnabled"],
      region: data["region"],
      town: data["villeEtab"],
      isoCountryCode: data["userCountryCodeIso"],
      countryName: data["userCountryName"],
      phoneKeywords: data["phoneKeywords"],
      nameKeywords: data["nameKeywords"], 
      serviceList: data["serviceList"],
    );
  }
}