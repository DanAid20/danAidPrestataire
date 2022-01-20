import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationChatModel {
  String conversationId, lastMessage, lastMessageFrom, lastMessageTime;
  int unseenMessages, lastMessageType;
  List users;
  Map phoneIds;
  bool lastMessageSeen;

  ConversationChatModel({this.conversationId, this.phoneIds, this.lastMessageFrom, this.lastMessageTime, this.unseenMessages, this.lastMessageType, this.users, this.lastMessageSeen, this.lastMessage});

  factory ConversationChatModel.fromDocument(DocumentSnapshot doc){
    return ConversationChatModel(
      conversationId: doc.id,
      lastMessage: doc.get("lastMessage"),
      lastMessageFrom: doc.get("lastMessageFrom"),
      lastMessageTime: doc.get("lastMessageTime"),
      lastMessageSeen: doc.get("lastMessageSeen"),
      unseenMessages: doc.get("unseenMessages"),
      lastMessageType: doc.get("lastMessageType"),
      users: doc.get("users"),
      phoneIds: doc.get("phoneIds")
    );
  }
}