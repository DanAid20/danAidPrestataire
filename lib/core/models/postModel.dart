import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  
  String? id, userAuthId, userId, userAvatar, title, userName, text, imgUrl;
  Timestamp?  datelineDate, dateCreated;
  num? amount, amountCollected;
  int? postType, likes, comments;
  bool? isFromDanAid;
  List?  tags, imgList, likesList, responderList, sharesList;

  PostModel({this.id, this.userAuthId, this.comments, this.isFromDanAid, this.responderList, this.sharesList, this.likesList, this.userId, this.title, this.userAvatar, this.userName, this.text, this.postType, this.likes, this.tags, this.imgUrl, this.imgList, this.datelineDate, this.dateCreated, this.amount, this.amountCollected});

  factory PostModel.fromDocument(DocumentSnapshot doc, Map data){
    return PostModel(
      id: doc.id,
      dateCreated: data["dateCreated"],
      imgUrl: data["imgUrl"],
      userAuthId: data["userAuthId"],
      userId: data["userId"],
      title: data["title"],
      comments: data["comments"],
      responderList: data["responderList"],
      userAvatar: data["userAvatar"],
      userName: data["userName"],
      text: data["text"],
      postType: data["post-type"],
      likesList: data["likesList"],
      likes: data["likes"],
      sharesList: data["shares"],
      tags: data["tags"],
      imgList: data["imgList"],
      amount: data["amount"],
      amountCollected: data["amount-collected"],
      datelineDate: data["dateline-date"],
      isFromDanAid: data["isFromDanAid"]
    );
  }
}