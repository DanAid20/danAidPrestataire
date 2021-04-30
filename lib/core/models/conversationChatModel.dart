import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationChatModel {
  String conversationId, lastMessage, lastMessageFrom, lastMessageTime;
  int unseenMessages, lastMessageType;
  List users;
  bool lastMessageSeen;

  ConversationChatModel({this.conversationId, this.lastMessageFrom, this.lastMessageTime, this.unseenMessages, this.lastMessageType, this.users, this.lastMessageSeen, this.lastMessage});

  factory ConversationChatModel.fromDocument(DocumentSnapshot doc){
    return ConversationChatModel(
      conversationId: doc.id,
      lastMessage: doc.data()["lastMessage"],
      lastMessageFrom: doc.data()["lastMessageFrom"],
      lastMessageTime: doc.data()["lastMessageTime"],
      lastMessageSeen: doc.data()["lastMessageSeen"],
      unseenMessages: doc.data()["unseenMessages"],
      lastMessageType: doc.data()["lastMessageType"],
      users: doc.data()["users"],
    );
  }
}