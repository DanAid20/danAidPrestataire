import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:danaid/core/models/notificationModel.dart';
import 'package:danaid/core/models/planModel.dart';
import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/doctorTileModelProvider.dart';
import 'package:danaid/core/providers/notificationModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/SizeConfig.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/core/services/dynamicLinkHandler.dart';
import 'package:danaid/views/adhrent_views/aid_network_screen.dart';
import 'package:danaid/views/adhrent_views/doctor_profile.dart';
import 'package:danaid/views/adhrent_views/health_book_screen.dart';
import 'package:danaid/views/adhrent_views/hello_screen.dart';
import 'package:danaid/views/adhrent_views/myfamily_screen.dart';
import 'package:danaid/views/adhrent_views/partners_screen.dart';
import 'package:danaid/views/doctor_views/tabs_doctor_views/profil_doctor_view.dart';
import 'package:danaid/views/doctor_views/prestataire_profil_page.dart';
import 'package:danaid/views/social_network_views/home_page_social.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';




Future<void> _showNotification({required int id, required String title, String? body}) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings/*, onSelectNotification: onSelectNotification*/);
  print("showing..");
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
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

  var iOSChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(android : androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(id, title, body, platformChannelSpecifics, payload: 'new_notification');
}



class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> with WidgetsBindingObserver {
  
  double width = SizeConfig.screenWidth! / 100;
  double height = SizeConfig.screenHeight! / 100;
  double inch = sqrt(SizeConfig.screenWidth! * SizeConfig.screenWidth! + SizeConfig.screenHeight! * SizeConfig.screenHeight!) / 100;
  AppLifecycleState? _notifier; 
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    NotificationModelProvider notifications = Provider.of<NotificationModelProvider>(context, listen: false);
    await notifications.updateProvider();
      _notifier = state;
      print(_notifier.toString());
  }

  //int index = 1;
  loadAdherentprofile() async {

    DateTime fullDate = DateTime.now();
    DateTime date = DateTime(fullDate.year, fullDate.month, fullDate.day);
    AdherentModel adherentModel;

    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if(userProvider.getUserId != null || userProvider.getUserId != ""){
      if(adherentModelProvider.getAdherent != null){
        adherentModel = adherentModelProvider.getAdherent!;
        //generateInvoice(adherentModel);
        }
        else {
          FirebaseFirestore.instance.collection('ADHERENTS').doc(userProvider.getUserId).get().then((docSnapshot) async {
            AdherentModel adherent = AdherentModel.fromDocument(docSnapshot, docSnapshot.data() as Map);
            adherentModelProvider.setAdherentModel(adherent);

            if(adherent.insuranceLimit == null || adherent.loanLimit == null){
              DocumentSnapshot planDoc = await FirebaseFirestore.instance.collection("SERVICES_LEVEL_CONFIGURATION").doc(adherent.adherentPlan.toString()).get();
              PlanModel plan = PlanModel.fromDocument(planDoc, planDoc.data() as Map);
              await FirebaseFirestore.instance.collection('ADHERENTS').doc(userProvider.getUserId).update({
                "plafond": adherent.insuranceLimit == null ? plan.annualLimit : adherent.insuranceLimit,
                "creditLimit": adherent.loanLimit == null ? plan.maxCreditAmount : adherent.loanLimit
              }).then((value) {
                adherentModelProvider.setInsuranceLimit(adherent.insuranceLimit == null ? plan.annualLimit! : adherent.insuranceLimit!);
                adherentModelProvider.setLoanLimit(adherent.loanLimit == null ? plan.maxCreditAmount! : adherent.loanLimit!);
              });
            }
            //generateInvoice(adherentModel);
          });
        }
    } else {
      String? phone = await HiveDatabase.getAuthPhone();
      userProvider.setUserId(phone);
      if(adherentModelProvider.getAdherent != null){
        adherentModel = adherentModelProvider.getAdherent!;
        //generateInvoice(adherentModel);
          //
        }
        else {
          FirebaseFirestore.instance.collection('ADHERENTS').doc(phone).get().then((docSnapshot) async {
            AdherentModel adherent = AdherentModel.fromDocument(docSnapshot, docSnapshot.data() as Map);
            adherentModelProvider.setAdherentModel(adherent);
            userProvider.setUserId(adherent.adherentId!);

            if(adherent.insuranceLimit == null || adherent.loanLimit == null){
              DocumentSnapshot planDoc = await FirebaseFirestore.instance.collection("SERVICES_LEVEL_CONFIGURATION").doc(adherent.adherentPlan.toString()).get();
              PlanModel plan = PlanModel.fromDocument(planDoc, planDoc.data() as Map);
              await FirebaseFirestore.instance.collection('ADHERENTS').doc(userProvider.getUserId).update({
                "plafond": adherent.insuranceLimit == null ? plan.annualLimit : adherent.insuranceLimit,
                "creditLimit": adherent.loanLimit == null ? plan.maxCreditAmount : adherent.loanLimit
              }).then((value) {
                adherentModelProvider.setInsuranceLimit(adherent.insuranceLimit == null ? plan.annualLimit! : adherent.insuranceLimit!);
                adherentModelProvider.setLoanLimit(adherent.loanLimit == null ? plan.maxCreditAmount! : adherent.loanLimit!);
              });
            }
          });
        }
    }
  }

  generateInvoice(AdherentModel adhr){
    DateTime now = DateTime.now();
    Random random = new Random();
    if(now.isAfter(adhr.validityEndDate!.toDate()) && adhr.adherentPlan != 0){
      FirebaseFirestore.instance.collection('FACTURATION_TRIMESTRIELLE').doc('facturation_en_cour').get().then((doc) {
        int trimesterUnit = doc.data()!["trimestre"];
        int year = doc.data()!["date"].toDate().year;
        Map data = Algorithms.getAutomaticCoveragePeriod(trimesterUnit: trimesterUnit, year: year);

        FirebaseFirestore.instance.collection("SERVICES_LEVEL_CONFIGURATION").doc(adhr.adherentPlan.toString()).get().then((serviceDoc){
          PlanModel plan = PlanModel.fromDocument(serviceDoc, serviceDoc.data() as Map);
          FirebaseFirestore.instance.collection("ADHERENTS").doc(adhr.adherentId).collection('NEW_FACTURATIONS_ADHERENT').add({
            "montant": plan.monthlyAmount,
            "createdDate": DateTime.now(),
            "trimester": data["trimester"],
            "etatValider": false,
            "intitule": "COSTISATION Q-$trimesterUnit",
            "dateDebutCouvertureAdherent" : data["start"],
            "dateFinCouvertureAdherent": data["end"],
            "categoriePaiement" : "COTISATION_TRIMESTRIELLE",
            "dateDelai": data["start"].add(Duration(days: 15)),
            "numeroRecu": data["start"].year.toString()+"-"+random.nextInt(99999).toString(),
            "numeroNiveau": plan.planNumber,
            "paymentDate": null,
            "paid": false
          }).then((value) {
            FirebaseFirestore.instance.collection("ADHERENTS").doc(adhr.adherentId).set({
              "datDebutvalidite" : data["start"],
              "havePaidBefore": true,
              "datFinvalidite": data["end"],
              "paid": false,
            }, SetOptions(merge: true));
            });
          });

        
      });
    }
    
  }

  loadDoctorProfile() async {
    DoctorModelProvider doctorModelProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if(userProvider.getUserId != null || userProvider.getUserId != ""){
      
      /*if((doctorModelProvider.getDoctor != null) & (doctorModelProvider.getDoctor.id == userProvider.getUserId)) {
          print("ok");
          return;
      }*/
        print("iiiin1"+userProvider.getUserId.toString());
        FirebaseFirestore.instance.collection('MEDECINS').doc(userProvider.getUserId).get().then((docSnapshot) {
          DoctorModel doc = DoctorModel.fromDocument(docSnapshot, docSnapshot.data() as Map);
          doctorModelProvider.setDoctorModel(doc);
        print("ok");
          userProvider.setUserId(doc.id!);
        });

    } else {
          print("iiiiin2");
      String? phone = await HiveDatabase.getAuthPhone();
      print("inside");
      print("inside"+phone.toString());
      if(doctorModelProvider.getDoctor != null){
          //
        }
        else {
          FirebaseFirestore.instance.collection('MEDECINS').doc(phone).get().then((docSnapshot) {
             DoctorModel doc = DoctorModel.fromDocument(docSnapshot, docSnapshot.data() as Map);
            doctorModelProvider.setDoctorModel(doc);
            userProvider.setUserId(doc.id!);
          });
        }
    }
  }

  loadServiceProviderProfile() async {
   
    print("prestataire");

    ServiceProviderModelProvider serviceProviderM = Provider.of<ServiceProviderModelProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      print("prestataire"+userProvider.getUserId.toString());
    if(userProvider.getUserId != null && userProvider.getUserId != ""){
      FirebaseFirestore.instance.collection(serviceProvider).doc(userProvider.getUserId).get().then((docSnapshot) {
        ServiceProviderModel doc = ServiceProviderModel.fromDocument(docSnapshot, docSnapshot.data() as Map);
        serviceProviderM.setServiceProviderModel(doc);
        print("ok");
      });
    } 
    else {
      String? phone = await HiveDatabase.getAuthPhone();
      print("inside");
      print("inside"+phone.toString());
      if(serviceProviderM.getServiceProvider != null){
          //
      }
      else {
        FirebaseFirestore.instance.collection(serviceProvider).doc(phone).get().then((docSnapshot) {
          ServiceProviderModel doc = ServiceProviderModel.fromDocument(docSnapshot, docSnapshot.data() as Map);
          serviceProviderM.setServiceProviderModel(doc);
          userProvider.setUserId(doc.id!);
        });
      }
    }
    
     // print("service provider"+serviceProviderM.getServiceProvider.avatarUrl);
  }


  loadBeneficiaryProfile() async {

    print("Loading beneficiaire..");

    DateTime fullDate = DateTime.now();
    DateTime date = DateTime(fullDate.year, fullDate.month, fullDate.day);
    AdherentModel adherentModel;
    UserModel user;

    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if(userProvider.getUserModel != null && adherentModelProvider.getAdherent != null){

    } else {
      String? phone = await HiveDatabase.getAuthPhone();
      String adhPhone = await HiveDatabase.getParentAdherentAuthPhone();
      userProvider.setUserId(phone);
      FirebaseFirestore.instance.collection('USERS').doc(phone).get().then((userSnap) async {
        user = UserModel.fromDocument(userSnap, userSnap.data()!);
        userProvider.setUserModel(user);
        DocumentSnapshot benSnap = await FirebaseFirestore.instance.collection('ADHERENTS').doc(userProvider.getUserModel!.adherentId).collection('BENEFICIAIRES').doc(userProvider.getUserModel!.matricule).get();
        BeneficiaryModel beneficiary = BeneficiaryModel.fromDocument(benSnap, benSnap.data() as Map);
        FirebaseFirestore.instance.collection('ADHERENTS').doc(userProvider.getUserModel!.adherentId).get().then((adhSnap) async {
          AdherentModel adherent = AdherentModel.fromDocument(adhSnap, adhSnap.data() as Map);
          adherentModelProvider.setAdherentModel(adherent);
          adherentModelProvider.setSurname(beneficiary.surname!);
          adherentModelProvider.setFamilyName(beneficiary.familyName!);
          adherentModelProvider.setCniName(user.fullName!);
        });
      });
    }
  }

  loadCommonUserProfile() async {

    DateTime fullDate = DateTime.now();
    DateTime date = DateTime(fullDate.year, fullDate.month, fullDate.day);

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.getUserModel == null) {
      await FirebaseFirestore.instance.collection('USERS').doc(userProvider.getUserId).get().then((docSnapshot) {
        UserModel user = UserModel.fromDocument(docSnapshot, docSnapshot.data()!);
        userProvider.setUserModel(user);
      });
    }
    if(userProvider.getProfileType == adherent){
      String? lastDateVisited = await HiveDatabase.getVisit();
      if(lastDateVisited != null){
        if(date.toString() != lastDateVisited.toString()){
          FirebaseFirestore.instance.collection('USERS').doc(userProvider.getUserId).set({
            "visitPoints": FieldValue.increment(25),
            "points": FieldValue.increment(25),
            "visits": FieldValue.arrayUnion([date]),
            "lastDateVisited": date,
          }, SetOptions(merge: true));
          HiveDatabase.setVisit(date);
          userProvider.addPoints(25);
        }
      } else {
        Timestamp? serverLastDate = userProvider.getUserModel?.lastDateVisited;
        lastDateVisited = userProvider.getUserModel?.lastDateVisited != null ? DateTime(serverLastDate!.toDate().year, serverLastDate.toDate().month, serverLastDate.toDate().day).toString() : DateTime(2000).toString();
        if(date.toString() != lastDateVisited){
          FirebaseFirestore.instance.collection('USERS').doc(userProvider.getUserId).set({
            "visitPoints": FieldValue.increment(25),
            "points": FieldValue.increment(25),
            "visits": FieldValue.arrayUnion([date]),
            "lastDateVisited": date,
          }, SetOptions(merge: true));
          HiveDatabase.setVisit(date);
          userProvider.addPoints(25);
        }
      }
    }
  }

  loadUserProfile() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if(userProvider.getProfileType != null || userProvider.getProfileType != ""){
      if(userProvider.getProfileType == adherent){
        loadAdherentprofile();
      }
      else if(userProvider.getProfileType == doctor) {
        loadDoctorProfile();
      }
      else if(userProvider.getProfileType == serviceProvider){
        loadServiceProviderProfile();
      }
      else if(userProvider.getProfileType == beneficiary){
        loadBeneficiaryProfile();
      }
    }
    else {
      String? profile = await HiveDatabase.getProfileType();
      if(profile != null){
        userProvider.setProfileType(profile);
        if(profile == adherent){
          loadAdherentprofile();
        }
        else if(userProvider.getProfileType == doctor) {
          loadDoctorProfile();
        }
        else if(userProvider.getProfileType == serviceProvider){
          loadServiceProviderProfile();
        }
        else if(userProvider.getProfileType == beneficiary){
          loadBeneficiaryProfile();
        }
      }
    }
  }


  handleNotifications() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    NotificationModelProvider notifications = Provider.of<NotificationModelProvider>(context, listen: false);
    notifications.updateProvider();
    
    print("0");
    await FirebaseMessaging.instance.subscribeToTopic(FirebaseAuth.instance.currentUser!.uid);
    await FirebaseMessaging.instance.subscribeToTopic(userProvider.getUserId!.substring(1));
    await FirebaseMessaging.instance.subscribeToTopic("DanAidAccount");
    print("1");
    

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("2");
      print('Got a message while in the foreground!');
      print('Message data: ${message.data}');

      if(message.data['type'] == "CONSULTATION"){
        notifications.addNotification(NotificationModel(
          messageId: message.messageId,
          title: message.data['status'] == '1' ? "Demande Approuvée" : "Demande rejétée",
          description: message.data['status'] == '1' ? "Votre rendez-vous a été approuvée par le médecin de famille." : "Votre demande de rendez-vous a été réjetée par le médecin de famille.",
          type: message.data['type'],
          data: message.data,
          dateReceived: DateTime.now(),
          seen: false
        ));
        showDialog(context: context,
          builder: (BuildContext context){
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*5,),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(children: [
                      SizedBox(height: hv*4),
                      Icon(message.data['status'] == '1' ? LineIcons.check : LineIcons.times, color: message.data['status'] == '1' ? kPrimaryColor : Colors.red, size: 45,),
                      SizedBox(height: hv*2,),
                      Text(message.data['body'], style: TextStyle(color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.w700),),
                      SizedBox(height: hv*2,),
                      Text(message.data['status'] == '1' ? "Votre rendez-vous a été approuvée par le médecin de famille, vous êtes attendu le jour du rendez-vous" : "Votre demande de rendez-vous a été réjetée par le médecin de famille. Changez de date et réessayez s'il vous plaît", style: TextStyle(color: Colors.grey[600], fontSize: wv*4), textAlign: TextAlign.center),
                      SizedBox(height: hv*2),
                      CustomTextButton(
                        text: "OK",
                        color: kPrimaryColor,
                        action: ()=>Navigator.pop(context),
                      )
                      
                    ], mainAxisAlignment: MainAxisAlignment.center, ),
                  ),
                ],
              ),
            );
          }
        );
      }
      else if (message.data['type'] == "CHAT_MESSAGE"){
        await _showNotification(id: 3, title: "Nouveau message", body: message.data["contentMessage"]);
      }
      else if (message.data['type'] == "POST_COMMMENT"){
        if(message.data["commentSendId"] != userProvider.getUserModel!.userId){
          await _showNotification(id: 6, title: "New comment on your post by ${message.data['senderName']}", body: '"${message.data["content"]}"');
        }
        else {
          print("no notifications");
        }
      }
      else if (message.data['type'] == "LIKE_COMMMENT"){
        String name = "";
        String type = "adhérent";
        print(message.data["likerId"]);
        if(message.data["likerId"] != userProvider.getUserModel!.userId){
          FirebaseFirestore.instance.collection('USERS').doc(message.data["likerId"]).get().then((doc) async {
            name = doc.get('fullName');
            type = doc.get('profil') == adherent ? "l'adhérent" : doc.get('profil') == doctor ? "le médecin" : "le prestataire";
            await _showNotification(id: 4, title: "Nouveau like", body: "Votre commentaire a été liké par $type $name");
          });
        }
        else {
          print("no notifications");
        }
        
      }
      else if (message.data['type'] == "FRIEND_REQUESTS"){
        String name = "";
        String type = "adhérent";
        FirebaseFirestore.instance.collection('USERS').doc(message.data["userWhoRquestFriendId"]).get().then((doc) async {
          name = doc.data()!['fullName'];
          type = doc.data()!['profil'] == adherent ? "de l'adhérent" : doc.data()!['profil'] == doctor ? "du médecin" : "du prestataire";
          await _showNotification(id: 7, title: "Demande d'amitié", body: "Nouvelle demande d'amitié de la part $type $name");
          notifications.addNotification(NotificationModel(
            messageId: message.messageId,
            title: "Demande d'amitié",
            description: "Nouvelle demande d'amitié de la part $type $name",
            type: message.data['type'],
            data: message.data,
            dateReceived: DateTime.now(),
            profileImgUrl: doc.data()!['imageUrl'],
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
      else if (message.data['type'] == "LIKE_GROUP_POST"){
        //String postId = message.data['postId'];
        String groupId = message.data['groupId'];
        if(message.data['groupId'] != null){
          FirebaseFirestore.instance.collection('GROUPS').doc(message.data['groupId']).get().then((doc) async {
            String groupName = doc.data()!['groupName'];
            await _showNotification(id: 5, title: "Nouveau like", body: "Nouveau like de votre publication dans le groupe $groupName");
          });
        }
      }
      else if (message.data['type'] == "LIKE_CLASSICAL_POST"){
        await _showNotification(id: 5, title: "Nouveau like", body: "Nouveau like d'une de vos publications");
      }
      else if (message.data['type'] == "DANAID_POST"){
        await _showNotification(id: 6, title: "Alerte: ${message.data['title']}", body: message.data['body']);
      }
      else {
        print("No type recognized");
      }

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);  
    
  }
  

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
    WidgetsBinding.instance!.addObserver(this);
    handleNotifications();
    initializeDateFormatting();
    loadCommonUserProfile();
    loadUserProfile();
    print("Before dynamic link");
    DynamicLinkHandler().fetchClassicLinkData(context);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    BottomAppBarControllerProvider bottomAppBarController = Provider.of<BottomAppBarControllerProvider>(context);
    int index = bottomAppBarController.getIndex;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [

          Container(
            child: getCurrentPage(),
          ),

          Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: BottomNavBarBackgroundClipper(),
                  child: Container(
                    color: Colors.grey.withOpacity(0.2),
                    height: hv*12,
                    width: double.infinity
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: BottomNavBarClipper(),
                  child: Container(
                    color: userProvider.getProfileType == serviceProvider ? kGold : kPrimaryColor,
                    height: hv*12,
                    width: double.infinity
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: height*12,
                  padding: EdgeInsets.symmetric(horizontal: width*1),
                  decoration: BoxDecoration(color: Colors.transparent,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      index == 0 ? iconActive(svgUrl: "assets/icons/Two-tone/Category.svg") : Container(),
                      index == 1 ? iconActive(svgUrl: "assets/icons/Two-tone/Home.svg") : Container(),
                      index == 2 ? iconActive(svgUrl: "assets/icons/Two-tone/Paper.svg") : Container(),
                      index == 3 ? iconActive(svgUrl: "assets/icons/Two-tone/Location.svg") : Container(),
                      index == 4 ? iconActive(svgUrl: userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary ? "assets/icons/Two-tone/3User.svg" : "assets/icons/Two-tone/Profile.svg") : Container(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: height*10,
                  padding: EdgeInsets.symmetric(horizontal: width*3, vertical: height*1.0),
                  decoration: BoxDecoration(color: Colors.transparent,),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      index == 0 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Category.svg", title: S.of(context).entraide, onTap: entraideTapped),
                      index == 1 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Home.svg", title: S.of(context).accueil, onTap: accueilTapped),
                      index == 2 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Paper.svg", title: S.of(context).carnet, onTap: carnetTapped),
                      index == 3 ? SizedBox(width: width*13,) : bottomIcon(svgUrl: "assets/icons/Two-tone/Location.svg", title: S.of(context).partenaire, onTap: partenaireTapped),
                      index == 4 ? SizedBox(width: width*13,) 
                        : bottomIcon(
                          svgUrl: userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary ? "assets/icons/Two-tone/3User.svg" : "assets/icons/Two-tone/Profile.svg", 
                          title: userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary ? S.of(context).famille : S.of(context).profile, 
                          onTap: familleTapped
                        ),
                    ],
                  ),
                ),
              ),
              
            ],
          )
        ],
      ),
    );
  }
  void entraideTapped(){
    Navigator.pushNamed(context, "/social-home");
  }
  void accueilTapped(){
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    controller.setIndex(1);
  }
  void carnetTapped(){
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    controller.setIndex(2);
  }
  void partenaireTapped(){
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    controller.setIndex(3);
  }
  void familleTapped(){
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    controller.setIndex(4);
  }

  bottomIcon({required String svgUrl, required String title, required Function() onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(svgUrl, width: inch*3, color: Colors.white.withOpacity(0.65)),
            Text(title, style: TextStyle(color: Colors.white.withOpacity(0.7)),)
          ],
        ),
      ),
    );
  }

  iconActive({required String svgUrl}){
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return CircleAvatar(
      radius: width*7.5,
      backgroundColor: userProvider.getProfileType == serviceProvider ? kGold : kPrimaryColor,
      child: CircleAvatar(
        radius: width*7.2,
        backgroundColor: Colors.white,
        child: SvgPicture.asset(svgUrl, width: inch*4, color: userProvider.getProfileType == serviceProvider ? kGold : kPrimaryColor.withOpacity(0.65)),
      ),
    );
  }

  getCurrentPage(){

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    DoctorTileModelProvider doctorTileProvider = Provider.of<DoctorTileModelProvider>(context, listen: false);

    if(controller.getIndex == 0){
      return SocialMediaHomePage();
    }
    else if(controller.getIndex == 1){
      return HelloScreen();
    }
    else if(controller.getIndex == 2){
      return HealthBookScreen();
    }
    else if(controller.getIndex == 3){
      return  PartnersScreen();
    }
    else if(controller.getIndex == 4){
      userProvider.getProfileType == doctor ?  doctorTileProvider.setDoctorModel(doctorProvider.getDoctor!) : print("waouu");
      return userProvider.getProfileType == adherent || userProvider.getProfileType == beneficiary ?  MyFamilyScreen() : userProvider.getProfileType == serviceProvider  ? PrestataireProfilePage(): DoctorProfilePage();
    }
  }

}