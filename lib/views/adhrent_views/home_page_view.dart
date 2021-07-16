import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:danaid/core/models/planModel.dart';
import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/doctorTileModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/SizeConfig.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/adhrent_views/aid_network_screen.dart';
import 'package:danaid/views/adhrent_views/doctor_profile.dart';
import 'package:danaid/views/adhrent_views/health_book_screen.dart';
import 'package:danaid/views/adhrent_views/hello_screen.dart';
import 'package:danaid/views/adhrent_views/myfamily_screen.dart';
import 'package:danaid/views/adhrent_views/partners_screen.dart';
import 'package:danaid/views/doctor_views/tabs_doctor_views/profil_doctor_view.dart';
import 'package:danaid/views/doctor_views/prestataire_profil_page.dart';
import 'package:danaid/views/social_network_views/home_page_social.dart';
import 'package:danaid/widgets/clippers.dart';
import 'package:flutter/material.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  
  double width = SizeConfig.screenWidth / 100;
  double height = SizeConfig.screenHeight / 100;
  double inch = sqrt(SizeConfig.screenWidth*SizeConfig.screenWidth + SizeConfig.screenHeight*SizeConfig.screenHeight) / 100;

  //int index = 1;
  loadAdherentprofile() async {

    DateTime fullDate = DateTime.now();
    DateTime date = DateTime(fullDate.year, fullDate.month, fullDate.day);
    AdherentModel adherentModel;

    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if(userProvider.getUserId != null || userProvider.getUserId != ""){
      if(adherentModelProvider.getAdherent != null){
        adherentModel = adherentModelProvider.getAdherent;
        generateInvoice(adherentModel);
        }
        else {
          FirebaseFirestore.instance.collection('ADHERENTS').doc(userProvider.getUserId).get().then((docSnapshot) async {
            AdherentModel adherent = AdherentModel.fromDocument(docSnapshot);
            adherentModelProvider.setAdherentModel(adherent);
            adherentModel = adherent;
            generateInvoice(adherentModel);
          });
        }
    } else {
      String phone = await HiveDatabase.getAuthPhone();
      userProvider.setUserId(phone);
      if(adherentModelProvider.getAdherent != null){
        adherentModel = adherentModelProvider.getAdherent;
        generateInvoice(adherentModel);
          //
        }
        else {
          FirebaseFirestore.instance.collection('ADHERENTS').doc(phone).get().then((docSnapshot) {
            AdherentModel adherent = AdherentModel.fromDocument(docSnapshot);
            adherentModelProvider.setAdherentModel(adherent);
            userProvider.setUserId(adherent.adherentId);
            adherentModel = adherent;
            generateInvoice(adherentModel);
          });
        }
    }
  }

  generateInvoice(AdherentModel adhr){
    DateTime now = DateTime.now();
    Random random = new Random();
    if(now.isAfter(adhr.validityEndDate.toDate()) && adhr.adherentPlan != 0){
      FirebaseFirestore.instance.collection('FACTURATION_TRIMESTRIELLE').doc('facturation_en_cour').get().then((doc) {
        int trimesterUnit = doc.data()["trimestre"];
        int year = doc.data()["date"].toDate().year;
        Map data = Algorithms.getAutomaticCoveragePeriod(trimesterUnit: trimesterUnit, year: year);

        FirebaseFirestore.instance.collection("SERVICES_LEVEL_CONFIGURATION").doc(adhr.adherentPlan.toString()).get().then((serviceDoc){
          PlanModel plan = PlanModel.fromDocument(serviceDoc);
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
          DoctorModel doc = DoctorModel.fromDocument(docSnapshot);
          doctorModelProvider.setDoctorModel(doc);
        print("ok");
          userProvider.setUserId(doc.id);
        });

    } else {
          print("iiiiin2");
      String phone = await HiveDatabase.getAuthPhone();
      print("inside");
      print("inside"+phone.toString());
      if(doctorModelProvider.getDoctor != null){
          //
        }
        else {
          FirebaseFirestore.instance.collection('MEDECINS').doc(phone).get().then((docSnapshot) {
             DoctorModel doc = DoctorModel.fromDocument(docSnapshot);
            doctorModelProvider.setDoctorModel(doc);
            userProvider.setUserId(doc.id);
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
        ServiceProviderModel doc = ServiceProviderModel.fromDocument(docSnapshot);
        serviceProviderM.setServiceProviderModel(doc);
        print("ok");
      });
    } 
    else {
      String phone = await HiveDatabase.getAuthPhone();
      print("inside");
      print("inside"+phone.toString());
      if(serviceProviderM.getServiceProvider != null){
          //
      }
      else {
        FirebaseFirestore.instance.collection(serviceProvider).doc(phone).get().then((docSnapshot) {
          ServiceProviderModel doc = ServiceProviderModel.fromDocument(docSnapshot);
          serviceProviderM.setServiceProviderModel(doc);
          userProvider.setUserId(doc.id);
        });
      }
    }
    
     // print("service provider"+serviceProviderM.getServiceProvider.avatarUrl);
  }

  loadCommonUserProfile() async {

    DateTime fullDate = DateTime.now();
    DateTime date = DateTime(fullDate.year, fullDate.month, fullDate.day);

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.getUserModel == null) {
      await FirebaseFirestore.instance.collection('USERS').doc(userProvider.getUserId).get().then((docSnapshot) {
        UserModel user = UserModel.fromDocument(docSnapshot);
        userProvider.setUserModel(user);
      });
    }
    if(userProvider.getProfileType == adherent){
      String lastDateVisited = await HiveDatabase.getVisit();
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
        Timestamp serverLastDate = userProvider.getUserModel.lastDateVisited;
        lastDateVisited = userProvider.getUserModel.lastDateVisited != null ? DateTime(serverLastDate.toDate().year, serverLastDate.toDate().month, serverLastDate.toDate().day).toString() : DateTime(2000).toString();
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
    }
    else {
      String profile = await HiveDatabase.getProfileType();
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
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    initializeDateFormatting();
    loadCommonUserProfile();
    loadUserProfile();
    super.initState();
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
                      index == 4 ? iconActive(svgUrl: userProvider.getProfileType == adherent ? "assets/icons/Two-tone/3User.svg" : "assets/icons/Two-tone/Profile.svg") : Container(),
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
                          svgUrl: userProvider.getProfileType == adherent ? "assets/icons/Two-tone/3User.svg" : "assets/icons/Two-tone/Profile.svg", 
                          title: userProvider.getProfileType == adherent ? S.of(context).famille : S.of(context).profile, 
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
  entraideTapped(){
    Navigator.pushNamed(context, "/social-home");
  }
  accueilTapped(){
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    controller.setIndex(1);
  }
  carnetTapped(){
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    controller.setIndex(2);
  }
  partenaireTapped(){
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    controller.setIndex(3);
  }
  familleTapped(){
    BottomAppBarControllerProvider controller = Provider.of<BottomAppBarControllerProvider>(context, listen: false);
    controller.setIndex(4);
  }

  bottomIcon({String svgUrl, String title, Function onTap}){
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

  iconActive({String svgUrl}){
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
      return userProvider.getProfileType != serviceProvider ?  PartnersScreen() : ProfilDoctorView();
    }
    else if(controller.getIndex == 4){
      userProvider.getProfileType == doctor ?  doctorTileProvider.setDoctorModel(doctorProvider.getDoctor) : print("waouu");
      return userProvider.getProfileType == adherent ?  MyFamilyScreen() : userProvider.getProfileType == serviceProvider  ? PrestataireProfilePage(): DoctorProfilePage();
    }
  }

}