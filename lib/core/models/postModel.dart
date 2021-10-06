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
      dateCreated: doc.data()["dateCreated"],
      imgUrl: doc.data()["imgUrl"],
      userAuthId: doc.data()["userAuthId"],
      userId: doc.data()["userId"],
      title: doc.data()["title"],
      comments: doc.data()["comments"],
      responderList: doc.data()["responderList"],
      userAvatar: doc.data()["userAvatar"],
      userName: doc.data()["userName"],
      text: doc.data()["text"],
      postType: doc.data()["post-type"],
      likesList: doc.data()["likesList"],
      likes: doc.data()["likes"],
      sharesList: doc.data()["shares"],
      tags: doc.data()["tags"],
      imgList: doc.data()["imgList"],
      amount: doc.data()["amount"],
      amountCollected: doc.data()["amount-collected"],
      datelineDate: doc.data()["dateline-date"],
      isFromDanAid: doc.data()["isFromDanAid"]
    );
  }
}