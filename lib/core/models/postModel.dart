import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id, userAuthId, userId, userAvatar, userName, text, imgUrl;
  Timestamp  datelineDate, dateCreated;
  num amount, amountCollected;
  int postType, likes;
  List  tags, imgList;

  PostModel({this.id, this.userAuthId, this.userId, this.userAvatar, this.userName, this.text, this.postType, this.likes, this.tags, this.imgUrl, this.imgList, this.datelineDate, this.dateCreated, this.amount, this.amountCollected});

  factory PostModel.fromDocument(DocumentSnapshot doc){
    return PostModel(
      id: doc.id,
      dateCreated: doc.data()["dateCreated"],
      imgUrl: doc.data()["imgUrl"],
      userAuthId: doc.data()["userAuthId"],
      userId: doc.data()["userId"],
      userAvatar: doc.data()["userAvatar"],
      userName: doc.data()["userName"],
      text: doc.data()["text"],
      postType: doc.data()["post-type"],
      likes: doc.data()["likes"],
      tags: doc.data()["tags"],
      imgList: doc.data()["imgList"],
      amount: doc.data()["amount"],
      amountCollected: doc.data()["amount-collected"],
      datelineDate: doc.data()["dateline-date"]
    );
  }
}