import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String groupId, creatorId, creatorAuthId, creatorAvatar, groupName, groupDescription, contactName, organizationName, groupType, groupCategory, contactPhone, imgUrl;
  Timestamp dateCreated;
  List adminsIds, membersIds, membersAvatarsUrls;
  
  GroupModel({this.groupId, this.creatorId, this.creatorAuthId, this.membersAvatarsUrls, this.creatorAvatar, this.groupName, this.groupDescription, this.contactName, this.organizationName, this.groupType, this.groupCategory, this.contactPhone, this.imgUrl, this.dateCreated, this.adminsIds, this.membersIds});

  factory GroupModel.fromDocument(DocumentSnapshot doc){
    return GroupModel(
      groupId: doc.id,
      creatorId: doc.data()["creatorId"],
      dateCreated: doc.data()["dateCreated"],
      creatorAuthId: doc.data()["creatorAuthId"],
      adminsIds: doc.data()["adminsIds"],
      creatorAvatar: doc.data()["creatorAvatar"],
      groupName: doc.data()["groupName"],
      groupDescription: doc.data()["groupDescription"],
      contactName: doc.data()["contactName"],
      organizationName: doc.data()["organizationName"],
      groupType: doc.data()["groupType"],
      groupCategory: doc.data()["groupCategory"],
      contactPhone: doc.data()["contactPhone"],
      membersIds: doc.data()["membersIds"],
      membersAvatarsUrls: doc.data()["membersAvatarsUrls"],
      imgUrl: doc.data()["imgUrl"]
    );
  }
}