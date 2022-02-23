import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String? groupId, creatorId, creatorAuthId, creatorAvatar, groupName, groupDescription, contactName, organizationName, groupType, groupCategory, contactPhone, imgUrl;
  Timestamp? dateCreated;
  List? adminsIds, membersIds, membersAvatarsUrls;
  
  GroupModel({this.groupId, this.creatorId, this.creatorAuthId, this.membersAvatarsUrls, this.creatorAvatar, this.groupName, this.groupDescription, this.contactName, this.organizationName, this.groupType, this.groupCategory, this.contactPhone, this.imgUrl, this.dateCreated, this.adminsIds, this.membersIds});

  factory GroupModel.fromDocument(DocumentSnapshot doc, Map data){
    return GroupModel(
      groupId: doc.id,
      creatorId: data["creatorId"],
      dateCreated: data["dateCreated"],
      creatorAuthId: data["creatorAuthId"],
      adminsIds: data["adminsIds"],
      creatorAvatar: data["creatorAvatar"],
      groupName: data["groupName"],
      groupDescription: data["groupDescription"],
      contactName: data["contactName"],
      organizationName: data["organizationName"],
      groupType: data["groupType"],
      groupCategory: data["groupCategory"],
      contactPhone: data["contactPhone"],
      membersIds: data["membersIds"],
      membersAvatarsUrls: data["membersAvatarsUrls"],
      imgUrl: data["imgUrl"]
    );
  }
}