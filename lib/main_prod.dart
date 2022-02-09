// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/danaid.dart';
import 'package:danaid/core/models/notificationModel.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'helpers/constants.dart';
import 'locator.dart';


Future<void> _showNotification({required int id, required String title, String? body}) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = const IOSInitializationSettings();
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings/*, onSelectNotification: onSelectNotification*/);
  print("showing..");
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'com.danaid.danaidmobile', 'DanAid',
      channelDescription: 'Mutuelle Santé 100% mobile',
      importance: Importance.max,
      playSound: true,
      //sound: AndroidNotificationSound,
      showProgress: true,
      enableVibration: true,
      enableLights: true,
      priority: Priority.high,
      ticker: 'test ticker'
  );

  var iOSChannelSpecifics = const IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(android : androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(id, title, body, platformChannelSpecifics, payload: 'new_notification');
}

Future<void> _messageHandler(RemoteMessage message) async {
  print("background notifications");
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  await Firebase.initializeApp();
  Hive.init(directory.path);
  Hive.registerAdapter(NotificationModelAdapter());

  if (message.data['type'] == "LIKE_GROUP_POST"){
    //String postId = message.data['postId'];
    String groupId = message.data['groupId'];
    if(message.data['groupId'] != null){
      FirebaseFirestore.instance.collection('GROUPS').doc(message.data['groupId']).get().then((doc) async {
        String groupName = doc.data()!['groupName'];
        await _showNotification(id: 5, title: "Nouveau like", body: "Nouveau like de votre publication dans le groupe $groupName");
      });
    }
  }
  else if(message.data['type'] == "CONSULTATION"){
    print('Adding notif in background...');
    await HiveDatabase.addNotification(NotificationModel(
      messageId: message.messageId,
      title: message.data['status'] == '1' ? "Demande Approuvée" : "Demande rejétée",
      description: message.data['status'] == '1' ? "Votre rendez-vous a été approuvée par le médecin de famille." : "Votre demande de rendez-vous a été réjetée par le médecin de famille.",
      type: message.data['type'],
      data: message.data,
      dateReceived: DateTime.now(),
      seen: false
    ));
  }
  else if (message.data['type'] == "LIKE_CLASSICAL_POST"){
    await _showNotification(id: 5, title: "Nouveau like", body: "Nouveau like d'une de vos publications");
  }
  else if (message.data['type'] == "LIKE_COMMMENT"){
    String name = "";
    String type = "adhérent";
    print(message.data["likerId"]);
    FirebaseFirestore.instance.collection('USERS').doc(message.data["likerId"]).get().then((doc) async {
      name = doc.data()!['fullName'];
      type = doc.data()!['profil'] == adherent ? "l'adhérent" : doc.data()!['profil'] == doctor ? "le médecin" : "le prestataire";
      await _showNotification(id: 4, title: "Nouveau like", body: "Votre commentaire a été liké par $type $name");
    });
  }
  else if (message.data['type'] == "FRIEND_REQUESTS"){
    String name = "";
    String type = "adhérent";
    FirebaseFirestore.instance.collection('USERS').doc(message.data["userWhoRquestFriendId"]).get().then((doc) async {
      name = doc.data()!['fullName'];
      type = doc.data()!['profil'] == adherent ? "de l'adhérent" : doc.data()!['profil'] == doctor ? "du médecin" : "du prestataire";
      await _showNotification(id: 7, title: "Demande d'amitié", body: "Nouvelle demande d'amitié de la part $type $name");
      print('Adding notif in background...');
      HiveDatabase.addNotification(NotificationModel(
        messageId: message.messageId,
        title: "Demande d'amitié",
        description: "Nouvelle demande d'amitié de la part $type $name",
        type: message.data['type'],
        data: message.data,
        dateReceived: DateTime.now(),
        seen: false
      ));
    });
  }
  else if (message.data['type'] == "FRIEND_ADDED"){
    String name = "";
    String type = "adhérent";
    FirebaseFirestore.instance.collection('USERS').doc(message.data["friendWhoAddedId"]).get().then((doc) async {
      name = doc.data()!['fullName'];
      type = doc.data()!['profil'] == adherent ? "l'adhérent" : doc.data()!['profil'] == doctor ? "le médecin" : "le prestataire";
      await _showNotification(id: 7, title: "Demande d'amitié acceptée", body: "Vous et $type $name êtes désormais amis");
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    setUrlStrategy(PathUrlStrategy());}
  else {
    Directory directory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  Hive.registerAdapter(NotificationModelAdapter());
  await chechIfExists();
  setupLocator();
  runApp(const Danaid(env: "prod",));
}

chechIfExists() async {
  bool exists = await Hive.boxExists('language');
  if(exists){
     await Hive.openBox('language');
  }else{
    var box = await Hive.openBox('language');
     await box.put('language', 'Français');
     await Hive.openBox('language');
  }
}
