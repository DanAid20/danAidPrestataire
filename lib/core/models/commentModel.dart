import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id, postId, userId, userName, userAvatar, content, userProfileType;
  final Timestamp dateCreated;
  final bool replying;
  final int type;
  final List likesList;

  CommentModel({this.id, this.replying, this.postId, this.userId, this.userName, this.userAvatar, this.content, this.userProfileType, this.dateCreated, this.type, this.likesList});

  factory CommentModel.fromDocument(DocumentSnapshot doc){
    return CommentModel(
      id: doc.id,
      postId: doc.data()["postId"],
      userId: doc.data()["responderId"],
      userName: doc.data()["responderName"],
      userAvatar: doc.data()["responderAvatarUrl"],
      dateCreated: doc.data()["dateCreated"],
      content: doc.data()["content"],
      type: doc.data()["type"],
      userProfileType: doc.data()["responderProfile"],
      likesList: doc.data()["likesList"],
      replying: doc.data()["replying"]
    );
  }
}