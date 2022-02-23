import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationChatModel {
  String? conversationId, lastMessage, lastMessageFrom, lastMessageTime;
  int? unseenMessages, lastMessageType;
  List? users;
  Map? phoneIds;
  bool? lastMessageSeen;

  ConversationChatModel({this.conversationId, this.phoneIds, this.lastMessageFrom, this.lastMessageTime, this.unseenMessages, this.lastMessageType, this.users, this.lastMessageSeen, this.lastMessage});

  factory ConversationChatModel.fromDocument(DocumentSnapshot doc, Map data){
    return ConversationChatModel(
      conversationId: doc.id,
      lastMessage: data["lastMessage"],
      lastMessageFrom: data["lastMessageFrom"],
      lastMessageTime: data["lastMessageTime"],
      lastMessageSeen: data["lastMessageSeen"],
      unseenMessages: data["unseenMessages"],
      lastMessageType: data["lastMessageType"],
      users: data["users"],
      phoneIds: data["phoneIds"]
    );
  }
}