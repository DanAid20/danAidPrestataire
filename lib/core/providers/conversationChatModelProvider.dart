import 'package:flutter/material.dart';
import 'package:danaid/core/models/conversationChatModel.dart';

class ConversationChatModelProvider with ChangeNotifier {

  ConversationChatModel _conversation;

  ConversationChatModelProvider(this._conversation);
  
  ConversationChatModel get getConversation => _conversation;
   
  void setConversationModel(ConversationChatModel val){
    _conversation = val;
    notifyListeners();
  }
}