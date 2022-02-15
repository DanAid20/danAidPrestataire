import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? authId, userId, matricule, adherentId, fullName, imgUrl, email, profileType, regionOfOrigin, cniUrl, countryCode, countryName, couponCode;
  Timestamp? dateCreated, lastDateVisited;
  bool? enabled, enable, isDanAIdAccount;
  int? visitPoints, points, comments, posts, isAmbassador;
  List? phoneList, phoneKeywords, nameKeywords, friends, groups, visits, friendRequests, chats;
  Map? location;

  UserModel({this.visitPoints, this.enable, this.adherentId, this.points, this.isAmbassador, this.isDanAIdAccount, this.comments, this.location, this.friendRequests, this.couponCode, this.posts, this.chats, this.visits, this.authId, this.userId, this.dateCreated, this.lastDateVisited,  this.matricule, this.phoneKeywords, this.nameKeywords, this.friends, this.groups, this.fullName, this.imgUrl, this.email, this.profileType, this.regionOfOrigin, this.cniUrl, this.countryCode, this.countryName, this.enabled, this.phoneList});

  factory UserModel.fromDocument(DocumentSnapshot doc, Map data) {
    return UserModel(
      userId: doc.id,
      dateCreated: data["createdDate"],
      lastDateVisited: data["lastDateVisited"],
      authId: data["authId"],
      matricule: data["matricule"],
      adherentId: data["adherentId"],
      fullName: data["fullName"],
      imgUrl: data["imageUrl"],
      email: data["emailAdress"],
      points: data["points"],
      comments: data["comments"],
      posts: data["posts"],
      chats: data["chat-users"],
      visits: data["visits"],
      visitPoints: data["visitPoints"],
      profileType: data["profil"],
      regionOfOrigin: data["regionDorigione"],
      cniUrl: data["urlCNI"],
      countryCode: data["userCountryCodeIso"],
      countryName: data["userCountryName"],
      enable: data["enable"],
      enabled: data["enabled"],
      phoneList: data["phoneList"],
      phoneKeywords: data["phoneKeywords"],
      nameKeywords: data["nameKeywords"],
      friendRequests: data["friendRequests"],
      friends: data["friends"],
      groups: data["groups"],
      isAmbassador: data["isAmbassador"],
      couponCode: data["couponCode"],
      location: data["localisation"],
      isDanAIdAccount: data["danAidAccount"]
    );
  }
}
