import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String groupId, creatorId, creatorAuthId, creatorAvatar, groupName, groupDescription, contactName, organizationName, groupType, groupCategory, contactPhone, imgUrl;
  Timestamp dateCreated;
  List adminsIds, membersIds, membersAvatarsUrls;
  
  GroupModel({this.groupId, this.creatorId, this.creatorAuthId, this.membersAvatarsUrls, this.creatorAvatar, this.groupName, this.groupDescription, this.contactName, this.organizationName, this.groupType, this.groupCategory, this.contactPhone, this.imgUrl, this.dateCreated, this.adminsIds, this.membersIds});

  factory GroupModel.fromDocument(DocumentSnapshot doc){
    return GroupModel(
      groupId: doc.id,
      creatorId: doc.get("creatorId"),
      dateCreated: doc.get("dateCreated"),
      creatorAuthId: doc.get("creatorAuthId"),
      adminsIds: doc.get("adminsIds"),
      creatorAvatar: doc.get("creatorAvatar"),
      groupName: doc.get("groupName"),
      groupDescription: doc.get("groupDescription"),
      contactName: doc.get("contactName"),
      organizationName: doc.get("organizationName"),
      groupType: doc.get("groupType"),
      groupCategory: doc.get("groupCategory"),
      contactPhone: doc.get("contactPhone"),
      membersIds: doc.get("membersIds"),
      membersAvatarsUrls: doc.get("membersAvatarsUrls"),
      imgUrl: doc.get("imgUrl")
    );
  }
}