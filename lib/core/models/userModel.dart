import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? authId, userId, matricule, adherentId, fullName, imgUrl, email, profileType, regionOfOrigin, cniUrl, countryCode, countryName, couponCode;
  Timestamp? dateCreated, lastDateVisited;
  bool? enabled, enable, isDanAIdAccount;
  int? visitPoints, points, comments, posts, isAmbassador;
  List? phoneList, phoneKeywords, nameKeywords, friends, groups, visits, friendRequests, chats;
  Map? location;

  UserModel({this.visitPoints, this.enable, this.adherentId, this.points, this.isAmbassador, this.isDanAIdAccount, this.comments, this.location, this.friendRequests, this.couponCode, this.posts, this.chats, this.visits, this.authId, this.userId, this.dateCreated, this.lastDateVisited,  this.matricule, this.phoneKeywords, this.nameKeywords, this.friends, this.groups, this.fullName, this.imgUrl, this.email, this.profileType, this.regionOfOrigin, this.cniUrl, this.countryCode, this.countryName, this.enabled, this.phoneList});

  factory UserModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel(
      userId: doc.id,
      dateCreated: doc["createdDate"],
      lastDateVisited: doc["lastDateVisited"],
      authId: doc["authId"],
      matricule: doc["matricule"],
      adherentId: doc["adherentId"],
      fullName: doc["fullName"],
      imgUrl: doc["imageUrl"],
      email: doc["emailAdress"],
      points: doc["points"],
      comments: doc["comments"],
      posts: doc["posts"],
      chats: doc["chat-users"],
      visits: doc["visits"],
      visitPoints: doc["visitPoints"],
      profileType: doc["profil"],
      regionOfOrigin: doc["regionDorigione"],
      cniUrl: doc["urlCNI"],
      countryCode: doc["userCountryCodeIso"],
      countryName: doc["userCountryName"],
      enable: doc["enable"],
      enabled: doc["enabled"],
      phoneList: doc["phoneList"],
      phoneKeywords: doc["phoneKeywords"],
      nameKeywords: doc["nameKeywords"],
      friendRequests: doc["friendRequests"],
      friends: doc["friends"],
      groups: doc["groups"],
      isAmbassador: doc["isAmbassador"],
      couponCode: doc["couponCode"],
      location: doc["localisation"],
      isDanAIdAccount: doc["danAidAccount"]
    );
  }
}
