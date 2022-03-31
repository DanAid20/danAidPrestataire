import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/appointmentModel.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/appointmentProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/providers/usecaseModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/getPlatform.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/SizeConfig.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/helpers/utils.dart';
import 'package:danaid/views/doctor_views/appointement_approuve.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RendezVousDoctorView extends StatefulWidget {
  RendezVousDoctorView({Key? key}) : super(key: key);

  @override
  _RendezVousDoctorViewState createState() => _RendezVousDoctorViewState();
}

class _RendezVousDoctorViewState extends State<RendezVousDoctorView> {
  var calendarTextValue = 20.sp;
  var _selectedDay;
  var _focusedDay;
  var startDays;
  var endDay;

  var code;
  var now = new DateTime.now();
  final df = new DateFormat('dd-MMM-yyyy');
  var isSelected = 'Days';
  AdherentModelProvider? adherentModelProvider;
  ScrollController? scrollController;
  int userSelected = -1;
  BeneficiaryModel? adherentUserSelected;
  bool isloading = false;
  bool isRequestLaunch = false;
  UseCaseModelProvider? userCaprovider;
  @override
  void initState() {
    super.initState();
    triggerGetPatient();
    code = getRandomString(4);
  }

  String getRandomString(int length) {
    const _chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random _rnd = Random();
    var result = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return 'YM' + result;
  }

  Future<String> createConsultationCode(QueryDocumentSnapshot adherent, String idAppointemnt) async {
    DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);

    var date = DateTime.now();
    var newUseCase = FirebaseFirestore.instance.collection('USECASES').doc();
    newUseCase.set({
      'id': newUseCase.id,
      'adherentId': adherent['adherentId'],
      'beneficiaryId': adherent['beneficiaryId'],
      'beneficiaryName': adherent['username'],
      'otherInfo': '',
      'idAppointement': idAppointemnt,
      'establishment': doctorProvider.getDoctor!.officeName,
      'consultationCode': code,
      'type': 'RDV',
      'amountToPay': doctorProvider.getDoctor!.rate!['public'],
      'status': 0,
      'createdDate': DateTime.now(),
      'enable': false,
    }, SetOptions(merge: true)).then((value) {
      setState(() {
        isloading = false;
      });
      userCaprovider!.getUseCase!.consultationCode = code;
      userCaprovider!.getUseCase!.dateCreated = Timestamp.fromDate(date);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Le Code ce consultation creer avec succes comme médecin de famille..")));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        isloading = false;
      });
    });

    return newUseCase.id;
  }

  facturationCode(id, adherent, idAppointemnt) async {
    DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('USECASES')
        .doc(id)
        .collection('FACTURATIONS')
        .doc(adherent['adherentId'])
        .set({
      'id': Utils.createCryptoRandomString(8),
      'idAdherent': adherent['adherentId'],
      'idBeneficiairy': adherent['beneficiaryId'],
      'idMedecin': doctorProvider.getDoctor!.id,
      'amountToPay': doctorProvider.getDoctor!.rate!['public'],
      'isSolve': false,
      'canPay': 0,
      'idAppointement': idAppointemnt,
      'Type': adherent['appointment-type'],
      'createdAt': DateTime.now(),
    }, SetOptions(merge: true)).then((value) {
      setState(() {
        isloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("La facture a bien ete generer avec succes ")));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        isloading = false;
      });
    });
  }

  //******* cette function get la date d'aujourd'hui en parametre et get la listes rendez-vous pour ce jour */
  triggerGetPatient() {
    var dates = DateTime.now();
    var start =  DateTime(dates.year, dates.month, dates.day, 00, 00);
    var end =  DateTime(dates.year, dates.month, dates.day, 23, 59);
    if (kDebugMode) {
      print(start);
      print(end);
    }
    setState(() {
      _selectedDay = dates;
      startDays = start;
      endDay = end;
      _focusedDay = dates; // update `_focusedDay` here as well
      isSelected = 'Days';
    });
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  //******* cette function get la d'aujourd'hui en parametre et get la listes rendez-vous pour la semaines  */
  triggerGetPatientForWeek() {
    var dates = DateTime.now();

    var start =  DateTime(dates.year, dates.month, dates.day.toInt());
    var end =  DateTime(dates.year, dates.month, dates.day.toInt() + 6);
    if (kDebugMode) {
      print(start);
    }
    print(end);
    setState(() {
      _selectedDay = dates;
      startDays = start;
      endDay = end;
      _focusedDay = dates; // update `_focusedDay` here as well
      isSelected = 'week';
    });
  }

  waitingRoomFuture(startDays, endDay, date, doctor) {
    Stream<QuerySnapshot> query = FirebaseFirestore.instance
        .collection("APPOINTMENTS")
        .where("appointment-type", isEqualTo: 'consult-today')
        .where("doctorId", isEqualTo: doctor)
        .where("start-time", isGreaterThan: startDays, isLessThan: endDay)
        .orderBy("start-time")
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: query,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && snapshot.hasData==false) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }
         
          return snapshot.connectionState == ConnectionState.done && snapshot.hasData==false
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  //shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    var component;
                    if(doc["adherentId"]! != doc["beneficiaryId"]!){
                       CollectionReference users =
                        FirebaseFirestore.instance.collection("ADHERENTS/${doc["adherentId"]}/BENEFICIAIRES");
                      component= FutureBuilder<DocumentSnapshot>(
                      future: users.doc(doc["beneficiaryId"]).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData==false) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPrimaryColor),
                            ),
                          );
                        }
                        
                        if (snapshot.hasError) {
                          return Text(S.of(context).somethingWentWrong);
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                          return HomePageComponents().waitingRoomListOfUser(
                              userImage: "${data["imageUrl"]}",
                              nom: "${data["prenom"]} ${data["nomFamille"]} ",
                              syntomes: '${doc["title"]}', 
                              isanounced: doc["announced"]==true? true: false);
                              
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        );
                      },
                    );
                    }else if(doc["adherentId"] == doc["beneficiaryId"]){
                         CollectionReference users =
                        FirebaseFirestore.instance.collection('ADHERENTS');
                    component= FutureBuilder<DocumentSnapshot>(
                      future: users.doc(doc["adherentId"]).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData==false) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPrimaryColor),
                            ),
                          );
                        }
                        
                        if (snapshot.hasError) {
                          return Text(S.of(context).somethingWentWrong);
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic> ;
                          return HomePageComponents().waitingRoomListOfUser(
                              userImage: "${data["imageUrl"]}",
                              nom: "${data["prenom"]} ${data["nomFamille"]} ",
                              syntomes: '${doc["title"]}', 
                              isanounced: doc["announced"]==true? true: false);
                              
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        );
                      },
                    );
                    }
                    return component;
                  })
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(S.of(context).aucunPatientEnSalleDattente),
                  ),
                );
        });
  }

  showAlertDialog(adherentId, doctorId) {
    // set up the buttons
    Future<bool> _willpop() async{
        Navigator.pop(context);
        return true;
    }
    Widget cancelButton =  TextButton(
      child: const Text("Sortir"),
      onPressed: _willpop,
    );
    Widget continueButton = TextButton(
        child: Text(S.of(context).ouiJapprouve,
            style: TextStyle(
              color: kBlueForce,
              fontWeight: FontWeight.w600,
              fontSize: fontSize(size: 19),
            )),
        onPressed: () async {
          var data = FirebaseFirestore.instance
              .collection("APPOINTMENTS")
              .where("doctorId", isEqualTo: doctorId)
              .where("adherentId", isEqualTo: adherentId);
          data.get().then((docSnapshot) => {
                if (docSnapshot.docs.isEmpty)
                  {
                    // ignore: avoid_print
                    print('fdfjsfjdsf')
                  }
                else
                  {
                    FirebaseFirestore.instance
                        .collection("APPOINTMENTS")
                        .doc(docSnapshot.docs[0].id)
                        .update({
                      "status": 1,
                    }).then((value) async {
                      await createConsultationCode(docSnapshot.docs[0], docSnapshot.docs[0].id)
                          .then((value) async {
                        await facturationCode(value, docSnapshot.docs[0], docSnapshot.docs[0].id);
                      });
                    }).then((value) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(S.of(context).rendevousApprouver)));
                    })
                  },
              });
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(S.of(context).infos,
          style: TextStyle(
            color: kBlueForce,
            fontWeight: FontWeight.w700,
            fontSize: fontSize(size: 21),
          )),
      content: Text(
          S.of(context).vousTesSurLePointDapprouverCeRendezvousTesvousSr,
          style: TextStyle(
            color: kBlueForce,
            fontWeight: FontWeight.w400,
            fontSize: fontSize(size: 18),
          )),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getListOfUser(startDays, endDay, date, doctorId) {
    Stream<QuerySnapshot> query = FirebaseFirestore.instance
        .collection("APPOINTMENTS")
        .where("doctorId", isEqualTo: doctorId)
        .where("appointment-type", isEqualTo: 'appointment')
        .where("start-time",
            isGreaterThanOrEqualTo: startDays, isLessThanOrEqualTo: endDay)
        .orderBy("start-time")
        .snapshots();
     UserProvider userProvider = Provider.of<UserProvider>(context);
    DoctorModelProvider doctor = Provider.of<DoctorModelProvider>(context);
    AppointmentModelProvider rendezVous = Provider.of<AppointmentModelProvider>(context);
    AppointmentModel? appointmentModel;
     adherentModelProvider = Provider.of<AdherentModelProvider>(context);
    AdherentModel? adherent = adherentModelProvider?.getAdherent;
     ServiceProviderModelProvider prestataire = Provider.of<ServiceProviderModelProvider>(context);
    bool isPrestataire =
        userProvider.getProfileType == serviceProvider ? true : false;
    return StreamBuilder<QuerySnapshot>(
        stream: query,
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting && snapshot.hasData==false) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }
          
          return snapshot.connectionState == ConnectionState.done  && snapshot.hasData
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    var widget;
                    // si doc["adherentId"] === doc["beneficiaryId"]
                    if(doc["adherentId"] == doc["beneficiaryId"]){
                      print("++++++++++++++++++++++++++++++++++++++++++");
                    CollectionReference users = FirebaseFirestore.instance.collection('ADHERENTS');
                        widget = FutureBuilder<DocumentSnapshot>(
                      future: users.doc(doc["adherentId"]).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData==false) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPrimaryColor),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text(S.of(context).somethingWentWrong);
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                          Timestamp t = data["dateNaissance"];
                          DateTime d = t.toDate();
                          DateTime dateTimeNow = DateTime.now();
                          final differenceInDays =
                              dateTimeNow.difference(d).inDays ~/ 365;
                          Timestamp day = doc["start-time"];
                          DateTime dateTime = day.toDate();
                          String formattedTime =DateFormat.Hm().format(dateTime);
                          return doc["status"]==2? SizedBox.shrink() : GestureDetector(
                                onTap: ()=>{
                                appointmentModel=AppointmentModel.fromDocument(doc, doc.data() as Map),
                                rendezVous.setAppointmentModel(appointmentModel!),
                                rendezVous.getAppointment!.adherentId=snapshot.data!.id,
                                rendezVous.getAppointment!.avatarUrl=data["imageUrl"],
                                rendezVous.getAppointment!.username='${data["prenom"]} ${data["nomFamille"]} ',
                                rendezVous.getAppointment!.birthDate=data["dateNaissance"],
                                
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AppointmentDetails(adherent: adherent),
                                      ),)
                                  
                                },
                                
                                child: HomePageComponents().timeline(
                                isanounced: doc["announced"],
                                adhrentId: doc["adherentId"],
                                doctorId: isPrestataire? prestataire.getServiceProvider!.id: doctor.getDoctor!.id,
                                consultationtype: doc["consultation-type"],
                                isPrestataire: isPrestataire,
                                age: "$differenceInDays ans",
                                consultationDetails: '${doc["title"]}',
                                consultationType:
                                    "${doc["appointment-type"]}",
                                time: "$formattedTime",
                                userImage: '${data["imageUrl"]}',
                                userName:
                                    '${data["prenom"]} ${data["nomFamille"]} '),
                          );
                        }
                        return const  Text(" ");
                      },
                    );
                    }else if (doc["adherentId"] != doc["beneficiaryId"]){
                       print("+++++++++++++++++++++");
                          CollectionReference users =
                        FirebaseFirestore.instance.collection("ADHERENTS/${doc["adherentId"]}/BENEFICIAIRES");
                       widget= FutureBuilder<DocumentSnapshot>(
                      future: users.doc(doc["beneficiaryId"]).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData==false) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPrimaryColor),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text(S.of(context).somethingWentWrong);
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                          Timestamp t = data["dateNaissance"];
                          DateTime d = t.toDate();
                          DateTime dateTimeNow = DateTime.now();
                          final differenceInDays =
                              dateTimeNow.difference(d).inDays ~/ 365;
                          Timestamp day = doc["start-time"];
                          DateTime dateTime = day.toDate();
                          String formattedTime =DateFormat.Hm().format(dateTime);
                          return doc["status"]==2? const SizedBox.shrink() : GestureDetector(
                                onTap: ()=>{
                                appointmentModel=AppointmentModel.fromDocument(doc, doc.data() as Map),
                                rendezVous.setAppointmentModel(appointmentModel!),
                                rendezVous.getAppointment!.adherentId=snapshot.data!.id,
                                rendezVous.getAppointment!.avatarUrl=data["imageUrl"],
                                rendezVous.getAppointment!.username= '${data["prenom"]} ${data["nomDFamille"]} ',
                                rendezVous.getAppointment!.birthDate=data["dateNaissance"],
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AppointmentDetails(adherent: adherent),
                                      ),)
                                },
                                
                                child: HomePageComponents().timeline(
                                isanounced: doc["announced"],
                                adhrentId: doc["adherentId"],
                                doctorId:  isPrestataire? prestataire.getServiceProvider!.id: doctor.getDoctor!.id,
                                consultationtype: doc["consultation-type"],
                                isPrestataire: false,
                                age: "$differenceInDays ans",
                                consultationDetails: '${doc["title"]}',
                                consultationType:
                                    "${doc["appointment-type"]}",
                                time: "$formattedTime",
                                userImage: '${data["imageUrl"]}',
                                userName:
                                    '${data["prenom"]} ${data["nomDFamille"]} '),
                          );
                        }
                        return Text(" ");
                      },
                      
                    );
                    }
                    // alors on affiche adherent
                    // sinom on affiche beneficiares 
                    return widget;
                  })
              : Center(
                  child: Text(S.of(context).aucunAdherentDisponiblePourLeMoment),
                );
        });
  }

  Widget calendar({bool? isPrestataire}) {
    return Column(children: [
      Container(
        constraints: BoxConstraints(
        maxWidth: Device.isSmartphone(context) ? wv*100 : 700,
        maxHeight: Device.isSmartphone(context) ? 145: 160
        ),
       
        decoration: BoxDecoration(
          color: isPrestataire! ? kGoldlight : kThirdIntroColor,
          boxShadow:const [
             BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
          ],
          borderRadius:const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            TableCalendar(
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                String startDay = selectedDay.toString().substring(0, 11);
                String sendHours = startDay + "23:59:59.000Z";
                DateTime todayDate = DateTime.parse(sendHours);
                setState(() {
                  _selectedDay = selectedDay;
                  startDays = selectedDay;
                  endDay = todayDate;
                  _focusedDay = focusedDay;
                  isSelected = 'Days'; // update `_focusedDay` here as well
                });
              },
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.week,
              daysOfWeekVisible: true,
              calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: isPrestataire ? kFirstIntroColor : kBlueForce,
                    borderRadius:const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  outsideTextStyle:TextStyle(
                      color: isPrestataire ? kBlueForce : whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize: Device.isSmartphone(context) ? calendarTextValue : 14  ) ,
                  rangeEndTextStyle: TextStyle(
                      color: isPrestataire ? kBlueForce : whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize: Device.isSmartphone(context) ? calendarTextValue : 14 ),
                  rangeStartTextStyle: TextStyle(
                      color: isPrestataire ? kBlueForce : whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize: Device.isSmartphone(context) ? calendarTextValue : 14 ),
                  weekendTextStyle: TextStyle(
                      color: isPrestataire ? kBlueForce : whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: Device.isSmartphone(context) ? calendarTextValue : 14 ),
                  defaultTextStyle: TextStyle(
                      color: isPrestataire ? kBlueForce : whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: Device.isSmartphone(context) ? calendarTextValue : 14 ),
                  holidayTextStyle: TextStyle(
                      color: isPrestataire ? kBlueForce : whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize: Device.isSmartphone(context) ? calendarTextValue : 14 ),
                  todayTextStyle: TextStyle(
                      color: isPrestataire ? kBlueForce : whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize: Device.isSmartphone(context) ? calendarTextValue : 14 )),
              headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  headerMargin: const EdgeInsets.only(left: 18),
                  headerPadding: const EdgeInsets.only(top: 10, bottom: 10),
                  rightChevronVisible: false,
                  leftChevronVisible: false,
                  titleTextStyle: TextStyle(
                      color: isPrestataire ? kBlueForce : whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize:  Device.isSmartphone(context) ? 18 : 16 )),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: isPrestataire ? kBlueForce : whiteColor,
                  fontWeight: FontWeight.w500,
                ),
                weekendStyle: TextStyle(
                  color: isPrestataire ? kBlueForce : whiteColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    triggerGetPatient();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: isSelected == 'Days'
                            ? kDeepTeal.withOpacity(0.4)
                            : kDeepTeal.withOpacity(0.0),
                        borderRadius: const BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.only(
                        left: wv * 1.5, right: wv * 1.5, top: hv * 1),
                    child: Text(
                      S.of(context).aujourdhui,
                      style: TextStyle(
                          color: isPrestataire ? kBlueForce : whiteColor,
                          fontWeight: isSelected == 'Days'
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize:  fontSize(size: Device.isSmartphone(context) ? wv * 4 : 5)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    triggerGetPatientForWeek();
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: isSelected == 'week'
                            ? kDeepTeal.withOpacity(0.4)
                            : kDeepTeal.withOpacity(0.0),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.only(
                        left: wv * 1.5, right: wv * 1.5, top: hv * 1),
                    child: Text(
                      S.of(context).semaine,
                      style: TextStyle(
                          color: isPrestataire ? kBlueForce : whiteColor,
                          fontWeight: isSelected == 'week'
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: fontSize(size: Device.isSmartphone(context) ? wv * 4 : 5 )),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const  EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: kBlueForce.withOpacity(0.6),
                      borderRadius: const  BorderRadius.all(Radius.circular(5))),
                  margin: EdgeInsets.only(
                      left: wv * 1.5, right: wv * 1.5, top: hv * 1),
                  child: Text(
                    isSelected == 'week'
                        ? DateFormat('dd MMM yyyy')
                                .format(startDays)
                                .toString() +
                            ' / ' +
                            DateFormat('dd MMM yyyy').format(endDay).toString()
                        : DateFormat('dd-MMM-yyyy').format(_selectedDay),
                    style: TextStyle(
                        color: isPrestataire ? kBlueForce : whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize(size:  Device.isSmartphone(context) ? wv * 4 : 5 )),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);
    bool isPrestataire =
        userProvider.getProfileType == serviceProvider ? true : false;
    ServiceProviderModelProvider prestataire = Provider.of<ServiceProviderModelProvider>(context);    
    return Container(
      child: Column(
        children: <Widget>[
          calendar(isPrestataire: isPrestataire),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(left: 20.h, right: 20.h),
                  alignment: Alignment.topCenter,
                  child: userProvider.getProfileType == doctor &&
                          doctorProvider.getDoctor?.id != null &&
                          startDays != null &&
                          endDay != null
                      ? getListOfUser(startDays, endDay, _selectedDay,
                          doctorProvider.getDoctor!.id)
                     
                      :  getListOfUser(startDays, endDay, _selectedDay,
                          userProvider.getAuthId)
                        )
                        ),
          Container(
            constraints: BoxConstraints(
            maxHeight: Device.isSmartphone(context) ? 120.h :150.h,
            maxWidth: Device.isSmartphone(context) ? double.infinity :190.w
            ),
            margin: EdgeInsets.only(bottom: 60.h),
            decoration: const BoxDecoration(
              color: whiteColor,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    right: 8.h,
                    left: 8.h,
                    top: 5.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).salleDattente,
                          style: TextStyle(
                              color: kBlueDeep,
                              fontWeight: FontWeight.w500,
                              fontSize: Device.isSmartphone(context) ?17.sp :16  )),
                      Text(S.of(context).voirPlus,
                          style: TextStyle(
                              color: kBrownCanyon,
                              fontWeight: FontWeight.w600,
                              fontSize: Device.isSmartphone(context) ?17.sp :16 )),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                      height: 90.h,
                      child: userProvider.getProfileType == doctor &&
                              doctorProvider.getDoctor!.id != null &&
                              startDays != null &&
                              endDay != null
                          ? waitingRoomFuture(startDays, endDay, _selectedDay,
                              doctorProvider.getDoctor?.id)
                          :  waitingRoomFuture(startDays, endDay, _selectedDay,
                               userProvider.getAuthId)
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
