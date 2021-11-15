import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String authId, userId, matricule, adherentId, fullName, imgUrl, email, profileType, regionOfOrigin, cniUrl, countryCode, countryName, couponCode;
  Timestamp dateCreated, lastDateVisited;
  bool enabled, enable, isDanAIdAccount;
  int visitPoints, points, comments, posts, isAmbassador;
  List phoneList, phoneKeywords, nameKeywords, friends, groups, visits, friendRequests, chats;

  UserModel({this.visitPoints, this.enable, this.adherentId, this.points, this.isAmbassador, this.isDanAIdAccount, this.comments, this.friendRequests, this.couponCode, this.posts, this.chats, this.visits, this.authId, this.userId, this.dateCreated, this.lastDateVisited,  this.matricule, this.phoneKeywords, this.nameKeywords, this.friends, this.groups, this.fullName, this.imgUrl, this.email, this.profileType, this.regionOfOrigin, this.cniUrl, this.countryCode, this.countryName, this.enabled, this.phoneList});

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      userId: doc.id,
      dateCreated: doc.data()["createdDate"],
      lastDateVisited: doc.data()["lastDateVisited"],
      authId: doc.data()["authId"],
      matricule: doc.data()["matricule"],
      adherentId: doc.data()["adherentId"],
      fullName: doc.data()["fullName"],
      imgUrl: doc.data()["imageUrl"],
      email: doc.data()["emailAdress"],
      points: doc.data()["points"],
      comments: doc.data()["comments"],
      posts: doc.data()["posts"],
      chats: doc.data()["chat-users"],
      visits: doc.data()["visits"],
      visitPoints: doc.data()["visitPoints"],
      profileType: doc.data()["profil"],
      regionOfOrigin: doc.data()["regionDorigione"],
      cniUrl: doc.data()["urlCNI"],
      countryCode: doc.data()["userCountryCodeIso"],
      countryName: doc.data()["userCountryName"],
      enable: doc.data()["enable"],
      enabled: doc.data()["enabled"],
      phoneList: doc.data()["phoneList"],
      phoneKeywords: doc.data()["phoneKeywords"],
      nameKeywords: doc.data()["nameKeywords"],
      friendRequests: doc.data()["friendRequests"],
      friends: doc.data()["friends"],
      groups: doc.data()["groups"],
      isAmbassador: doc.data()["isAmbassador"],
      couponCode: doc.data()["couponCode"],
      isDanAIdAccount: doc.data()["danAidAccount"]
    );
  }
}
