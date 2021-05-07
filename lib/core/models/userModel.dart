import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String authId, userId, matricule, fullName, imgUrl, email, profileType, regionOfOrigin, cniUrl, countryCode, countryName;
  final bool enabled;
  final List phoneList, phoneKeywords, nameKeywords, followers, groups;

  UserModel({this.authId,this.userId, this.matricule, this.phoneKeywords, this.nameKeywords, this.followers, this.groups, this.fullName, this.imgUrl, this.email, this.profileType, this.regionOfOrigin, this.cniUrl, this.countryCode, this.countryName, this.enabled, this.phoneList});

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      userId: doc.id,
      authId: doc.data()["authId"],
      matricule: doc.data()["matricule"],
      fullName: doc.data()["fullName"],
      imgUrl: doc.data()["imageUrl"],
      email: doc.data()["emailAdress"],
      profileType: doc.data()["profil"],
      regionOfOrigin: doc.data()["regionDorigione"],
      cniUrl: doc.data()["urlCNI"],
      countryCode: doc.data()["userCountryCodeIso"],
      countryName: doc.data()["userCountryName"],
      enabled: doc.data()["enabled"],
      phoneList: doc.data()["phoneList"],
      phoneKeywords: doc.data()["phoneKeywords"],
      nameKeywords: doc.data()["nameKeywords"],
      followers: doc.data()["followers"],
      groups: doc.data()["groups"]
    );
  }
}
