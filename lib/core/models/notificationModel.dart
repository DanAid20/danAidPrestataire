import 'package:hive/hive.dart';
part 'notificationModel.g.dart';

@HiveType(typeId: 0)
class NotificationModel {
  @HiveField(0)
  final String messageId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final Map<String, dynamic> data;

  @HiveField(5)
  final String imgUrl;

  @HiveField(6)
  final DateTime dateReceived;

  @HiveField(7)
  final bool seen;

  @HiveField(8)
  final String profileImgUrl;

  NotificationModel({this.messageId, this.title, this.type, this.data, this.imgUrl, this.description, this.dateReceived, this.seen, this.profileImgUrl});
}