import 'package:flutter/material.dart';
import 'package:danaid/core/models/conversationModel.dart';

class ConversationModelProvider with ChangeNotifier {
  ConversationModel _conversation;

  ConversationModelProvider(this._conversation);

  ConversationModel get getConversation => _conversation;
   
  void setConversationModel(ConversationModel val){
    _conversation = val;
    notifyListeners();
  }
}