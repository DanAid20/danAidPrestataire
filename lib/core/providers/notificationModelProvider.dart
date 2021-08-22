import 'package:danaid/core/models/notificationModel.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class NotificationModelProvider with ChangeNotifier {

  List<NotificationModel> _notifications;
  int unSeen;

  NotificationModelProvider(this._notifications, this.unSeen);

  List<NotificationModel> get getNotifications => _notifications;

  int get getUnseenNotifications => unSeen;

  updateProvider() async {
    print("Updating provider...");
    var box = await Hive.openBox<NotificationModel>('notifications');
    var unseenNotificationsBox = await Hive.openBox('unseen_notification');
    List<NotificationModel> notifications = box.values.toList();
    _notifications = notifications;
    print(unseenNotificationsBox.get('unseen_classic').toString());
    this.unSeen = unseenNotificationsBox.get('unseen_classic') == null ? 0 : unseenNotificationsBox.get('unseen_classic');
    notifyListeners();
  }

  addNotification(NotificationModel val) async {
    print("Adding notification...");
    var notificationBox = await Hive.openBox<NotificationModel>('notifications');
    var unseenNotificationsBox = await Hive.openBox('unseen_notification');
    notificationBox.add(val);
    _notifications.add(val);
    print(unseenNotificationsBox.get('unseen_classic').toString());
    int unseenClassic = unseenNotificationsBox.get('unseen_classic') == null ? 0 : unseenNotificationsBox.get('unseen_classic');
    unseenNotificationsBox.put('unseen_classic', unseenClassic+1);
    this.unSeen++;
    print("new value");
    print(unseenNotificationsBox.get('unseen_classic').toString());
    notifyListeners();
  }

  markAllAsSeen() async {
    print("Marking all notifications as seen...");
    var unseenNotificationsBox = await Hive.openBox('unseen_notification');
    unseenNotificationsBox.put('unseen_classic', 0);
    this.unSeen = 0;
    notifyListeners();
  }
}