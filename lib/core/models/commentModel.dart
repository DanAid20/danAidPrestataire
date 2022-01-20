import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String? id, postId, userId, userName, userAvatar, content, userProfileType;
  final Timestamp? dateCreated;
  final bool? replying;
  final int? type, replies;
  final List? likesList;

  CommentModel({this.id, this.replying, this.replies, this.postId, this.userId, this.userName, this.userAvatar, this.content, this.userProfileType, this.dateCreated, this.type, this.likesList});

  factory CommentModel.fromDocument(DocumentSnapshot doc){
    return CommentModel(
      id: doc.id,
      postId: doc.get("postId"),
      userId: doc.get("responderId"),
      userName: doc.get("responderName"),
      userAvatar: doc.get("responderAvatarUrl"),
      dateCreated: doc.get("dateCreated"),
      content: doc.get("content"),
      type: doc.get("type"),
      userProfileType: doc.get("responderProfile"),
      likesList: doc.get("likesList"),
      replies: doc.get("replies"),
      replying: doc.get("replying")
    );
  }
}