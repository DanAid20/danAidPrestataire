import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String authId, userId, matricule, adherentId, fullName, imgUrl, email, profileType, regionOfOrigin, cniUrl, countryCode, countryName, couponCode;
  Timestamp dateCreated, lastDateVisited;
  bool enabled, enable, isDanAIdAccount;
  int visitPoints, points, comments, posts, isAmbassador;
  List phoneList, phoneKeywords, nameKeywords, friends, groups, visits, friendRequests, chats;
  Map location;

  UserModel({this.visitPoints, this.enable, this.adherentId, this.points, this.isAmbassador, this.isDanAIdAccount, this.comments, this.location, this.friendRequests, this.couponCode, this.posts, this.chats, this.visits, this.authId, this.userId, this.dateCreated, this.lastDateVisited,  this.matricule, this.phoneKeywords, this.nameKeywords, this.friends, this.groups, this.fullName, this.imgUrl, this.email, this.profileType, this.regionOfOrigin, this.cniUrl, this.countryCode, this.countryName, this.enabled, this.phoneList});

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      userId: doc.id,
      dateCreated: doc.get("createdDate"),
      lastDateVisited: doc.get("lastDateVisited"),
      authId: doc.get("authId"),
      matricule: doc.get("matricule"),
      adherentId: doc.get("adherentId"),
      fullName: doc.get("fullName"),
      imgUrl: doc.get("imageUrl"),
      email: doc.get("emailAdress"),
      points: doc.get("points"),
      comments: doc.get("comments"),
      posts: doc.get("posts"),
      chats: doc.get("chat-users"),
      visits: doc.get("visits"),
      visitPoints: doc.get("visitPoints"),
      profileType: doc.get("profil"),
      regionOfOrigin: doc.get("regionDorigione"),
      cniUrl: doc.get("urlCNI"),
      countryCode: doc.get("userCountryCodeIso"),
      countryName: doc.get("userCountryName"),
      enable: doc.get("enable"),
      enabled: doc.get("enabled"),
      phoneList: doc.get("phoneList"),
      phoneKeywords: doc.get("phoneKeywords"),
      nameKeywords: doc.get("nameKeywords"),
      friendRequests: doc.get("friendRequests"),
      friends: doc.get("friends"),
      groups: doc.get("groups"),
      isAmbassador: doc.get("isAmbassador"),
      couponCode: doc.get("couponCode"),
      location: doc.get("localisation"),
      isDanAIdAccount: doc.get("danAidAccount")
    );
  }
}
