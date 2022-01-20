import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  
  String id, userAuthId, userId, userAvatar, title, userName, text, imgUrl;
  Timestamp  datelineDate, dateCreated;
  num amount, amountCollected;
  int postType, likes, comments;
  bool isFromDanAid;
  List  tags, imgList, likesList, responderList, sharesList;

  PostModel({this.id, this.userAuthId, this.comments, this.isFromDanAid, this.responderList, this.sharesList, this.likesList, this.userId, this.title, this.userAvatar, this.userName, this.text, this.postType, this.likes, this.tags, this.imgUrl, this.imgList, this.datelineDate, this.dateCreated, this.amount, this.amountCollected});

  factory PostModel.fromDocument(DocumentSnapshot doc){
    return PostModel(
      id: doc.id,
      dateCreated: doc.get("dateCreated"),
      imgUrl: doc.get("imgUrl"),
      userAuthId: doc.get("userAuthId"),
      userId: doc.get("userId"),
      title: doc.get("title"),
      comments: doc.get("comments"),
      responderList: doc.get("responderList"),
      userAvatar: doc.get("userAvatar"),
      userName: doc.get("userName"),
      text: doc.get("text"),
      postType: doc.get("post-type"),
      likesList: doc.get("likesList"),
      likes: doc.get("likes"),
      sharesList: doc.get("shares"),
      tags: doc.get("tags"),
      imgList: doc.get("imgList"),
      amount: doc.get("amount"),
      amountCollected: doc.get("amount-collected"),
      datelineDate: doc.get("dateline-date"),
      isFromDanAid: doc.get("isFromDanAid")
    );
  }
}