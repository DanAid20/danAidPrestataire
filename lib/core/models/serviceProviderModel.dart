import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProviderModel {
  String id, profileType, category, name, region, town, contactName, contactEmail, authPhone, countryName, isoCountryCode, contactFunction, avatarUrl, cniUrl, orderRegistrationCertificateUrl, otherDocUrl;
  bool profileEnabled;
  List phoneList = [];
  Map localisation;
  Timestamp dateCreated;

  ServiceProviderModel({this.id, this.profileType, this.category, this.name, this.region, this.town, this.contactName, this.contactEmail, this.authPhone, this.countryName, this.isoCountryCode, this.contactFunction, this.localisation, this.avatarUrl, this.cniUrl, this.orderRegistrationCertificateUrl, this.otherDocUrl, this.profileEnabled, this.phoneList, this.dateCreated});

  factory ServiceProviderModel.fromDocument(DocumentSnapshot doc){
    return ServiceProviderModel(
      id: doc.id, 
      dateCreated: doc.data()["createdDate"],
      name: doc.data()["nomEtablissement"],
      contactName: doc.data()["nomCompletPContact"],
      contactEmail: doc.data()["emailPContact"],
      authPhone: doc.data()["authPhoneNumber"],
      category: doc.data()["categorieEtablissement"],
      avatarUrl: doc.data()["imageUrl"],
      cniUrl: doc.data()["urlScaneCNI"],
      localisation: doc.data()["localisation"],
      otherDocUrl: doc.data()["urlDautreJustificatif"],
      orderRegistrationCertificateUrl: doc.data()["urlScaneCertificatEnregDordr"],
      phoneList: doc.data()["phoneList"],
      profileType: doc.data()["profil"],
      profileEnabled: doc.data()["profilEnabled"],
      region: doc.data()["region"],
      town: doc.data()["villeEtab"],
      isoCountryCode: doc.data()["userCountryCodeIso"],
      countryName: doc.data()["userCountryName"]
    );
  }
}