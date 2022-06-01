import 'package:danaid/core/models/notificationModel.dart';
import 'package:hive/hive.dart';

class HiveDatabase {

  final userBox = Hive.box('user');
  final adherentBox = Hive.box('adherent');
  final serviceProviderBox = Hive.box('serviceProvider');
  final authBox = Hive.box('auth');

  //Setters
  static setProfileType(String val) async {
    Box userBox = await Hive.openBox('user');
    userBox.put('profile', val);
  }

  static addNotification(NotificationModel val) async {
    print("Adding notification...");
    var notificationBox = await Hive.openBox<NotificationModel>('notifications');
    var unseenNotificationsBox = await Hive.openBox('unseen_notification');
    notificationBox.add(val);
    print(unseenNotificationsBox.get('unseen_classic').toString());
    int unseenClassic = unseenNotificationsBox.get('unseen_classic') == null ? 0 : unseenNotificationsBox.get('unseen_classic');
    unseenNotificationsBox.put('unseen_classic', unseenClassic+1);
    print("new value");
    print(unseenNotificationsBox.get('unseen_classic').toString());
  }

  static incrementUnseenNotification(int val) async {
    Box notificationCountBox = await Hive.openBox('notification');
    num counter = notificationCountBox.get('counter') != null ? notificationCountBox.get('counter') : 0;
    notificationCountBox.put('counter', counter++);
  }
  static setAuthPhone(String val) async {
    Box adherentBox = await Hive.openBox('adherent');
    adherentBox.put('phone', val);
  }
  static setAdherentParentAuthPhone(String val) async {
    Box adherentBox = await Hive.openBox('adherent');
    adherentBox.put('phone-adherent', val);
  }
  static setVisit(DateTime val) async {
    Box adherentBox = await Hive.openBox('adherent');
    adherentBox.put('visit', val.toString());
  }
  static setFamilyName(String val) async {
    Box adherentBox = await Hive.openBox('adherent');
    adherentBox.put('fname', val);
  }
  static setSurname(String val) async {
    Box adherentBox = await Hive.openBox('adherent');
    adherentBox.put('sname', val);
  }
  static setImgUrl(String? val) async {
    Box adherentBox = await Hive.openBox('adherent');
    adherentBox.put('imgUrl', val);
  }
  static setGender(String val) async {
    Box adherentBox = await Hive.openBox('adherent');
    adherentBox.put('gender', val);
  }
  static setRegion(String val) async {
    Box adherentBox = await Hive.openBox('adherent');
    adherentBox.put('region', val);
  }
  static setTown(String val) async {
    Box adherentBox = await Hive.openBox('adherent');
    adherentBox.put('town', val);
  }
  static setSignInState(bool? val) async {
    Box authBox = await Hive.openBox('auth');
    if(val == null){
      authBox.put('isSignedIn', false);
    }
    authBox.put('isSignedIn', val);
  }
  static setRegisterState(bool? val) async {
    Box authBox = await Hive.openBox('auth');
    /*if(val == null){
      authBox.put('isRegistered', false);
    }*/
    authBox.put('isRegistered', val);
  }
  static setLanguage(String val) async {
    Box languageBox = await Hive.openBox('language');
    languageBox.put('language', val);
  }

  //Getters

  static Future<String> getlanguage() async {
    Box languageBox = await Hive.openBox('language');
    return languageBox.get('language');
  }
  static Future<String?> getProfileType() async {
    Box userBox = await Hive.openBox('user');
    return userBox.get('profile');
  }
  static Future<String?> getFamilyName() async {
    Box adherentBox = await Hive.openBox('adherent');
    return adherentBox.get('fname');
  }
  static Future<String?> getVisit() async {
    Box adherentBox = await Hive.openBox('adherent');
    return adherentBox.get('visit');
  }
  static Future<String> getSurname() async {
    Box adherentBox = await Hive.openBox('adherent');
    return adherentBox.get('sname');
  }
  static Future<String> getImgUrl() async {
    Box adherentBox = await Hive.openBox('adherent');
    return adherentBox.get('imgUrl');
  }
  static Future<String> getGender() async {
    Box adherentBox = await Hive.openBox('adherent');
    return adherentBox.get('gender');
  }
  static Future<String> getRegion() async {
    Box adherentBox = await Hive.openBox('adherent');
    return adherentBox.get('region');
  }
  static Future<String> getTown() async {
    Box adherentBox = await Hive.openBox('adherent');
    return adherentBox.get('town');
  }
  static Future<bool?> getSignInState() async {
    Box authBox = await Hive.openBox('auth');
    return authBox.get('isSignedIn');
  }
  static Future<bool?> getRegisterState() async {
    Box authBox = await Hive.openBox('auth');
    return authBox.get('isRegistered');
  }
  static Future<String?> getAuthPhone() async {
    Box adherentBox = await Hive.openBox('adherent');
    return adherentBox.get('phone');
  }
  static Future<String> getParentAdherentAuthPhone() async {
    Box adherentBox = await Hive.openBox('adherent');
    return adherentBox.get('phone-adherent');
  }
  
}