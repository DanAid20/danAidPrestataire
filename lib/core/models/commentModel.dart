import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String? id, postId, userId, userName, userAvatar, content, userProfileType;
  final Timestamp? dateCreated;
  final bool? replying;
  final int? type, replies;
  final List? likesList;

  CommentModel({this.id, this.replying, this.replies, this.postId, this.userId, this.userName, this.userAvatar, this.content, this.userProfileType, this.dateCreated, this.type, this.likesList});

  factory CommentModel.fromDocument(DocumentSnapshot doc, Map data){
    return CommentModel(
      id: doc.id,
      postId: data["postId"],
      userId: data["responderId"],
      userName: data["responderName"],
      userAvatar: data["responderAvatarUrl"],
      dateCreated: data["dateCreated"],
      content: data["content"],
      type: data["type"],
      userProfileType: data["responderProfile"],
      likesList: data["likesList"],
      replies: data["replies"],
      replying: data["replying"]
    );
  }
}