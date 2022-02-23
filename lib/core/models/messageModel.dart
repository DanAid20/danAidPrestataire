import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id;
  final String? idFrom;
  final String? idTo;
  final String? content;
  final String? replierId;
  final String? replyContent;
  final int? replyType;
  final bool? replying;
  final bool? seen;
  final String? timeStamp;
  final int? type;
  MessageModel({this.id, this.idFrom, this.idTo, this.content, this.replierId, this.replyContent, this.replyType, this.replying, this.seen, this.timeStamp, this.type});

  factory MessageModel.fromDocument(DocumentSnapshot doc, Map data) {
    return MessageModel(
      id: doc.id,
      idFrom: data["idFrom"],
      idTo: data["idTo"],
      replierId: data["replierId"],
      content: data["content"],
      replyContent: data["replyContent"],
      replyType: data["replyType"],
      replying: data["replying"],
      seen: data["seen"],
      timeStamp: data["timeStamp"],
      type: data["type"],
    );
  }
}