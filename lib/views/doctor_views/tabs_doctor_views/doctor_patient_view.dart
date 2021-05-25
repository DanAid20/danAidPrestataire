import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/add_patient_views.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DoctorPatientView extends StatefulWidget {
  DoctorPatientView({Key key}) : super(key: key);

  @override
  _DoctorPatientViewState createState() => _DoctorPatientViewState();
}

class _DoctorPatientViewState extends State<DoctorPatientView> {
  final NavigationService _navigationService = locator<NavigationService>();
  var startDays;
  var endDay;
  @override
  void initState() { 
    super.initState();
    triggerGetPatient();
  }
  triggerGetPatient(){
      var dates =  DateTime.now();
      var start= new DateTime(dates.year, dates.month, dates.day, 00, 00);
      var end= new DateTime(dates.year, dates.month, dates.day, 23, 59); 
      print(start);
      print(end);
                    setState(() {
                      startDays = start;
                      endDay=end;
                    });
  }
  Widget servicesList() {
  UserProvider userProvider = Provider.of<UserProvider>(context);
  ServiceProviderModelProvider prestataire = Provider.of<ServiceProviderModelProvider>(context);
  //print(prestataire.);
  bool isPrestataire=userProvider.getProfileType== serviceProvider ? true : false;
    return Container(
      margin: EdgeInsets.only(top: hv * 1.5, bottom: hv * 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          GestureDetector(
             onTap:(){
                Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddPatientView(
                                                    isLaunchConsultation: true,
                                                  )),
                                        );
             },
                      child: Container(
                margin:
                    EdgeInsets.only(left: wv * 1.5, right: wv * 1.5, top: 20.h),
                width: 330.w,
                height: 140.h, 
                decoration: BoxDecoration(
                  color:  isPrestataire ? kGold :kThirdIntroColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, spreadRadius: 0.5, blurRadius: 4),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(17),
                  ),
                ),
                padding: EdgeInsets.only(top: hv * 1),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(right: wv * 3.5, top: hv * 0.5),
                        child: SvgPicture.asset(
                          'assets/icons/Bulk/Bookmark.svg',
                          width: wv * 8,
                          color:isPrestataire ==true ?kBlueForce:kDeepTeal
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 20.w, right: hv * 1.5, top: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              isPrestataire ? 'Compléter une prise en charge' :'Démarrer une consultation',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: kCardTextColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 20.w, right: 60.w, top: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                             isPrestataire ? 'Vérifier le statut des paiements avant de réaliser les services à un adhérent':  'Accédez au Carnet de Santé digital de vos patients et déclenchez leur prise en charge',
                              textScaleFactor: 0.8,
                              style: TextStyle(
                                  color: kCardTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.5.sp),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.0),
            height: 110.r,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    isPrestataire?   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("un peu de patience cette partie sera bientôt disponible"))) :
                    Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddPatientView(
                                                    isLaunchConsultation: false,
                                                  )),
                                        );
                  },
                  child: displsOtherServices(
                      iconesUrl: isPrestataire? 'assets/icons/Bulk/Discount.svg' :'assets/icons/Bulk/Add User.svg',
                      title:  isPrestataire? 'Emettre un devis' :'Ajouter un Patient',
                      isPrestataire: isPrestataire,
                      ),
                ),
               GestureDetector(
                 onTap: (){
                    isPrestataire?   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("un peu de patience cette partie sera bientôt disponible"))) :  Navigator.pushNamed(context, '/history-prestation-doctor');
                 },
                 child: displsOtherServices(
                    iconesUrl: 'assets/icons/Bulk/Chart.svg',
                    title: 'Suivre mes paiements', 
                    isPrestataire: isPrestataire,),
               ),
               GestureDetector(
                 onTap: (){
                    isPrestataire?   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("un peu de patience cette partie sera bientôt disponible"))) :  Navigator.pushNamed(context, '/chatroom');
                 },
                 child:displsOtherServices(
                    iconesUrl: 'assets/icons/Bulk/Message.svg',
                    title: 'Mes Messages', 
                    isPrestataire: isPrestataire,),
               ),
               
              ],
            ),
          ),
        ],
      ),
    );
  }

  displsOtherServices({String iconesUrl, String title, bool isPrestataire=false}) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(
                left: 20.w, right: wv * 1.5, top: hv * 2, bottom: hv * 1),
            width: 125.r,
            height: 85.r,
            decoration: BoxDecoration(
              color: isPrestataire ==true ? kGoldlight :kThirdIntroColor,
              boxShadow: [
                BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding: EdgeInsets.only(top: hv * 0.3),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 10.w, top: 4.h),
                    child: SvgPicture.asset(
                      iconesUrl != null
                          ? iconesUrl
                          : 'assets/icons/Bulk/Bookmark.svg',
                      width: wv * 6,
                     color:isPrestataire ==true ?kBlueForce:kDeepTeal
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 10.w, right: wv * 1.5, top:1.h),
                  child: Row(
                    children: [
                      Container(
                        width: 90.r,
                        child: Text(
                          title != null ? title : 'Ajouter un Patient',
                          style: TextStyle(
                              color: kCardTextColor,
                              fontWeight: FontWeight.w800,
                              fontSize:  17.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
  
  
  getListOfUser(startDays, endDay, date, doctorId) {
    print(doctorId);
    Stream<QuerySnapshot> query = FirebaseFirestore.instance
        .collection("APPOINTMENTS")
        .where("doctorId", isEqualTo: doctorId)
        .where("status",  isEqualTo: 0)
        .where("start-time", isGreaterThan: startDays, isLessThan: endDay)
        .orderBy("start-time", descending: true)
        .snapshots();

    return StreamBuilder(
        stream: query,
        builder: (context, snapshot) {
          //print(snapshot.data.docs.length);
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }
          if(snapshot.data == null) return CircularProgressIndicator();
          return snapshot.data.docs.length >= 1
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data.docs[index];

                    CollectionReference users =
                        FirebaseFirestore.instance.collection('ADHERENTS');
                    return FutureBuilder<DocumentSnapshot>(
                      future: users.doc(doc.data()["adherentId"]).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState==ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                              ),
                            );
                          }
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data = snapshot.data.data();
                          Timestamp t = data["dateNaissance"];
                          DateTime d = t.toDate();
                          DateTime dateTimeNow = DateTime.now();
                         
                          Timestamp day = doc.data()["start-time"];
                          DateTime dateTime = day.toDate();
                          String formattedTime =
                              DateFormat.Hm().format(dateTime);
                         
                          return  HomePageComponents().patientsItem(
                          apointementDate: "$formattedTime",
                          apointementType: '${doc.data()["consultation-type"]}',
                          imgUrl: '${data["imageUrl"]}',
                          nom: '${data["prenom"]} ${data["nomFamille"]}',
                          subtitle: '${doc.data()["title"]}');
                        }
                        return Text("loading");
                      },
                    );
                  })
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                    child: Text(" Vous n'avez aucun rendez-vous pour le moment.."),
                  ),
              );
        });
  }

  patientOfTodyaList() {
     UserProvider userProvider = Provider.of<UserProvider>(context);
    DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);
    bool isPrestataire =
        userProvider.getProfileType == serviceProvider ? true : false;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column( mainAxisSize: MainAxisSize.min, children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.only(top: hv * 2, left: wv * 5, right: wv * 5),
          child: Row(
            children: [
              Text(
                "Demandes de RDV",
                style: TextStyle(
                    color: kFirstIntroColor, fontSize:  15.sp ,fontWeight: FontWeight.w500),
              ),
              Text("Voir plus..",style: TextStyle(
                    color: kBrownCanyon, fontSize:  15.sp, fontWeight: FontWeight.w700))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 2.0),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            userProvider.getProfileType == doctor &&
                          doctorProvider.getDoctor.id != null &&
                          startDays != null &&
                          endDay != null
                      ? getListOfUser(startDays, endDay, null,
                          doctorProvider.getDoctor.id): Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(child: Text(" aucun rendez-vous pour l'instant ... ")),
                          )
          ],)
        )
      ]),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
          color: kBgTextColor,
        ),
        child: Column(

          children: [servicesList(), patientOfTodyaList()],
        ),
      ),
    );
  }
}
