import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String idFrom;
  final String idTo;
  final String content;
  final String replierId;
  final String replyContent;
  final int replyType;
  final bool replying;
  final bool seen;
  final String timeStamp;
  final int type;
  MessageModel({this.id, this.idFrom, this.idTo, this.content, this.replierId, this.replyContent, this.replyType, this.replying, this.seen, this.timeStamp, this.type});

  factory MessageModel.fromDocument(DocumentSnapshot doc) {
    return MessageModel(
      id: doc.id,
      idFrom: doc.get("idFrom"),
      idTo: doc.get("idTo"),
      replierId: doc.get("replierId"),
      content: doc.get("content"),
      replyContent: doc.get("replyContent"),
      replyType: doc.get("replyType"),
      replying: doc.get("replying"),
      seen: doc.get("seen"),
      timeStamp: doc.get("timeStamp"),
      type: doc.get("type"),
    );
  }
}