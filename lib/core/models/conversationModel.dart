class ConversationModel {
  String conversationId, userId, userPhoneId, targetPhoneId, targetId, userName, targetName, userAvatar, targetAvatar, targetProfileType;
  bool targetIsSupport;

  ConversationModel({this.conversationId, this.userPhoneId, this.targetPhoneId, this.targetIsSupport, this.userId, this.targetId, this.userName, this.targetName, this.userAvatar, this.targetAvatar, this.targetProfileType});
}