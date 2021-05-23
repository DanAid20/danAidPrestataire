import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/usecaseModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/helpers/utils.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class RendezVousDoctorView extends StatefulWidget {
  RendezVousDoctorView({Key key}) : super(key: key);

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
  var isSelected='Days';
   AdherentModelProvider adherentModelProvider;
  ScrollController scrollController;
  int userSelected=-1;
  BeneficiaryModel adherentUserSelected;
  bool isloading=false;
  bool isRequestLaunch=false;
  UseCaseModelProvider userCaprovider;
  @override
  void initState() { 
    super.initState();
    triggerGetPatient();
     code= getRandomString(4);
  }
String getRandomString(int length){
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    var result= String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)))); 
    return 'YM'+result;
  }

  Future<String> createConsultationCode(QueryDocumentSnapshot adherent) async {
     DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);
    
    
    var date= DateTime.now();
    var newUseCase =FirebaseFirestore.instance.collection('USECASES').doc();
     newUseCase.set({
      'id': newUseCase.id,
      'adherentId':  adherent['adherentId'],
      'beneficiaryId':  adherent['beneficiaryId'],
      'beneficiaryName': adherent['username'],
      'otherInfo':'',
      'establishment':doctorProvider.getDoctor.officeName,
      'consultationCode': code,
      'type': adherent['appointment-type'],
      'amountToPay': 2000,
      'status' : 0  ,
      'createdDate':  DateTime.now(),
      'enable': false,
    }, SetOptions(merge: true)).then((value) {
        setState(() {
          isloading = false;
        });
    userCaprovider.getUseCase.consultationCode=code;
    userCaprovider.getUseCase.dateCreated= Timestamp.fromDate(date);
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Le Code ce consultation creer avec succes comme médecin de famille..")));
        
      }).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          isloading = false;
        });
      });
    
    return newUseCase.id;
  }

  facturationCode(id, adherent) async {
    DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection('USECASES').doc(id)
    .collection('FACTURATIONS').doc(adherent['adherentId']).set({
      'id':Utils.createCryptoRandomString(8),
      'idAdherent':  adherent['adherentId'],
      'idBeneficiairy':adherent['beneficiaryId'],
      'idMedecin':doctorProvider.getDoctor.id,
      'amountToPay': 2000,
      'isSolve':false,
      'Type': adherent['appointment-type'] ,
      'createdAt':  DateTime.now(),
    }, SetOptions(merge: true)).then((value) {
        setState(() {
          isloading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("La facture a bien ete generer avec succes ")));
        
      }).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          isloading = false;
        });
      });
  }
  //******* cette function get la date d'aujourd'hui en parametre et get la listes rendez-vous pour ce jour */
  triggerGetPatient(){
      var dates =  DateTime.now();
      var start= new DateTime(dates.year, dates.month, dates.day, 00, 00);
      var end= new DateTime(dates.year, dates.month, dates.day, 23, 59); 
      print(start);
      print(end);
                    setState(() {
                      _selectedDay = dates;
                      startDays = start;
                      endDay=end;
                      _focusedDay = dates; // update `_focusedDay` here as well
                      isSelected='Days';
                    });
  }
   DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}
  //******* cette function get la d'aujourd'hui en parametre et get la listes rendez-vous pour la semaines  */
  triggerGetPatientForWeek(){
      var dates =  DateTime.now();
     
      var start=new DateTime(dates.year, dates.month, dates.day.toInt()) ;
      var end= new DateTime(dates.year, dates.month, dates.day.toInt()+6); 
      print(start);
      print(end);
                    setState(() {
                      _selectedDay = dates;
                      startDays = start;
                      endDay=end;
                      _focusedDay = dates; // update `_focusedDay` here as well
                      isSelected='week';
                    });
  }
  waitingRoomFuture( startDays, endDay,date, doctor){
    Stream<QuerySnapshot> query = FirebaseFirestore.instance
        .collection("APPOINTMENTS")
        .where("appointment-type",  isEqualTo: 'consult-today')
        .where("doctorId", isEqualTo: doctor)
        .where("start-time", isGreaterThan: startDays, isLessThan: endDay)
        .orderBy("start-time")
        .snapshots();
    return StreamBuilder(
        stream: query,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }
          print(snapshot.data.docs.length); 
          return snapshot.data.docs.length >= 1
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  //shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data.docs[index];
                  CollectionReference users = FirebaseFirestore.instance.collection('ADHERENTS');
                  return FutureBuilder<DocumentSnapshot>(
                    future: users.doc(doc.data()["adherentId"]).get(),
                    builder:
                        (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData==null) {
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
                        return HomePageComponents().waitingRoomListOfUser(userImage:"${data["imageUrl"]}" ,nom:"${data["prenom"]} ${data["nomFamille"]} ", syntomes: '${doc.data()["title"]}'   );
                      }
                      return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
                    },
                  );

                  })
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                    child: Text(" Aucun patient en salle d'attente.."),
                  ),
              );
        });

  }
  showAlertDialog(adherentId, doctorId) {
  
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Sortir"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("oui j'approuve", style: TextStyle(
                              color: kBlueForce,
                              fontWeight: FontWeight.w600,
                              fontSize: fontSize(size: 19),
                            )),
    onPressed:  () async {
        var data=await FirebaseFirestore.instance.collection("APPOINTMENTS")
         .where("doctorId", isEqualTo: "+237694160832")
         .where("adherentId", isEqualTo: adherentId); 
       data.get()
  .then((docSnapshot) => {
    if (docSnapshot.docs.isEmpty) {
     print('fdfjsfjdsf')
    } else {
       FirebaseFirestore.instance.collection("APPOINTMENTS")
        .doc(docSnapshot.docs[0].id)
        .update({
          "status": 1,
        }).then((value) async {
               await createConsultationCode(docSnapshot.docs[0]).then((value) async {
                    await facturationCode(value,docSnapshot.docs[0]);
                });
        }).then((value) {
            Navigator.pop(context);
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("rende-vous approuver ")));
        })
       
    },
  });
    });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Infos",  style: TextStyle(
                              color: kBlueForce,
                              fontWeight: FontWeight.w700,
                              fontSize: fontSize(size: 21),
                            ) ),
    content: Text("vous êtes sur le point d'approuver ce rendez-vous , êtes-vous sûr de cette operation ?", style: TextStyle(
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
  getListOfUser( startDays, endDay,date, doctorId) {
    Stream<QuerySnapshot> query = FirebaseFirestore.instance
        .collection("APPOINTMENTS")
         .where("doctorId", isEqualTo: doctorId)
        .where("appointment-type",  isEqualTo: 'appointment')
        .where("start-time", isGreaterThanOrEqualTo: startDays, isLessThanOrEqualTo: endDay)
        .orderBy("start-time")
        .snapshots();
  DoctorModelProvider doctor = Provider.of<DoctorModelProvider>(context);
  
    return StreamBuilder(
        stream: query,
        builder: (context, snapshot) {
          
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }
          print(snapshot.data.docs.length);
          return snapshot.data.docs.length >= 1
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data.docs[index];
                    
                  CollectionReference users = FirebaseFirestore.instance.collection('ADHERENTS');
                  return FutureBuilder<DocumentSnapshot>(
                    future: users.doc(doc.data()["adherentId"]).get(),
                    builder:
                        (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData==null) {
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
                        Timestamp t =data["dateNaissance"];
                        DateTime d = t.toDate();
                        DateTime dateTimeNow = DateTime.now();
                        final differenceInDays = dateTimeNow.difference(d).inDays ~/365;
                        Timestamp day =doc.data()["start-time"];
                        DateTime dateTime = day.toDate();
                        String formattedTime= DateFormat.Hm().format(dateTime);
                        return  HomePageComponents().timeline(isanounced: doc.data()["announced"], adhrentId: doc.data()["adherentId"], doctorId:doctor.getDoctor.id, approuveAppointement: showAlertDialog, consultationtype: doc.data()["consultation-type"] , isPrestataire: false,age: "$differenceInDays ans" ,consultationDetails: '${doc.data()["title"]}',consultationType: "${doc.data()["appointment-type"]}",time:"$formattedTime",userImage: '${data["imageUrl"]}',userName: '${data["prenom"]} ${data["nomFamille"]} ');
                      }
                      return Text(" ");
                    },
                  );

                  })
              : Center(
                  child: Text("Aucun Adherent  disponible pour le moment.."),
                );
        });
  }
  
  Widget calendar({
    bool isPrestataire
  }) {
    return Column(children: [
      Container(
        width: wv * 100,
        height: 145,
        decoration: BoxDecoration(
          color: isPrestataire? kGoldlight :kThirdIntroColor,
          boxShadow: [
            BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
          ],
          borderRadius: BorderRadius.only(
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
                    String startDay= selectedDay.toString().substring(0,11);
                    String sendHours= startDay+"23:59:59.000Z";
                    DateTime todayDate = DateTime.parse(sendHours); 
                    setState(() {
                      _selectedDay = selectedDay;
                      startDays = selectedDay;
                      endDay=todayDate;
                      _focusedDay = focusedDay;
                      isSelected= 'Days'; // update `_focusedDay` here as well
                    });
                    
                  },
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.week,
              daysOfWeekVisible: true,
              calendarStyle:  CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: isPrestataire? kFirstIntroColor :kBlueForce,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  rangeStartTextStyle: TextStyle(
                      color: isPrestataire? kBlueForce :whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize:calendarTextValue), 
                  weekendTextStyle: TextStyle(
                      color: isPrestataire? kBlueForce :whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize:calendarTextValue), 
                  defaultTextStyle: TextStyle(
                      color: isPrestataire? kBlueForce :whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize:calendarTextValue), 
                  holidayTextStyle: TextStyle(
                      color: isPrestataire? kBlueForce :whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize:calendarTextValue), 
                  todayTextStyle:  TextStyle(
                      color:isPrestataire? kBlueForce :whiteColor ,
                      fontWeight: FontWeight.w700,
                      fontSize: calendarTextValue)), 
              headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  headerMargin: const EdgeInsets.only(left: 18),
                  headerPadding: const EdgeInsets.only(top: 10, bottom: 10),
                  rightChevronVisible: false,
                  leftChevronVisible: false,
                  titleTextStyle:  TextStyle(
                      color: isPrestataire? kBlueForce :whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 18)),
              daysOfWeekStyle:  DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: isPrestataire? kBlueForce :whiteColor,
                  fontWeight: FontWeight.w500,
                ),
                weekendStyle: TextStyle(
                 color: isPrestataire? kBlueForce :whiteColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: (){
                    
                        triggerGetPatient();
                  
                    },
                    child:Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                       color:  isSelected=='Days' ? kDeepTeal.withOpacity(0.4)  : kDeepTeal.withOpacity(0.0)  ,
                      borderRadius:  BorderRadius.all(Radius.circular(5)) 
                    ),
                    margin: EdgeInsets.only(
                        left: wv * 1.5, right: wv * 1.5, top: hv * 1),
                    child: Text(
                      "Aujourd'hui",
                      style: TextStyle(
                          color: isPrestataire? kBlueForce :whiteColor,
                          fontWeight:  isSelected=='Days' ? FontWeight.w600 :FontWeight.w500,
                          fontSize: fontSize(size: wv * 4)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                      triggerGetPatientForWeek();
                  },
                                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                       color:  isSelected=='week' ? kDeepTeal.withOpacity(0.4)  : kDeepTeal.withOpacity(0.0)  ,
                      borderRadius:  BorderRadius.all(Radius.circular(5)) 
                    ),
                    margin: EdgeInsets.only(
                        left: wv * 1.5, right: wv * 1.5, top: hv * 1),
                    child: Text(
                      "Semaine",
                      style: TextStyle(
                          color: isPrestataire? kBlueForce :whiteColor,
                          fontWeight:  isSelected=='week' ? FontWeight.w600 :FontWeight.w500,
                          fontSize: fontSize(size: wv * 4)),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                       color:  kBlueForce.withOpacity(0.6)  ,
                      borderRadius:  BorderRadius.all(Radius.circular(5)) 
                    ),
                    margin: EdgeInsets.only(
                        left: wv * 1.5, right: wv * 1.5, top: hv * 1),
                    child: Text(
                      isSelected=='week' ?  DateFormat('dd MMM yyyy').format(startDays).toString()+' / '+ DateFormat('dd MMM yyyy').format(endDay).toString():  DateFormat('dd-MMM-yyyy').format(_selectedDay),
                      style: TextStyle(
                          color: isPrestataire? kBlueForce :whiteColor,
                          fontWeight:FontWeight.w600,
                          fontSize: fontSize(size: wv * 4)),
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
     DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);
     bool isPrestataire=userProvider.getProfileType== serviceProvider ? true : false;
    return Container(
      child: Column(
          children: <Widget>[
            calendar(isPrestataire:isPrestataire),
            Expanded(
              child: Container(
                 padding: EdgeInsets.only(left: 20.h, right: 20.h),
                alignment: Alignment.topCenter,
                child:userProvider.getProfileType==doctor && doctorProvider.getDoctor.id!=null && startDays!=null && endDay!=null ? getListOfUser( startDays, endDay,_selectedDay, doctorProvider.getDoctor.id):Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Aucun rendez-vous en vue pour l'instant"),
                )))
            ),
            
            Container(
                height: 120.h,
                margin: EdgeInsets.only(bottom: 60.h),
                decoration: BoxDecoration(
                color: whiteColor,
                ),
                child:Column(
                      children: [
                         Container(
                           padding: EdgeInsets.only(
                           
                             right: 8.h,
                             left: 8.h,
                             top: 5.h,
                           ),
                           child: Row(
                            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Salle d\'attente', style: TextStyle(
                                color: kBlueDeep,
                                fontWeight: FontWeight.w500,
                                fontSize:  17.sp)),
                              Text('Voir plus ..', style: TextStyle(
                                color: kBrownCanyon,
                                fontWeight: FontWeight.w600,
                                fontSize:  17.sp)),
                            ],
                        ),
                         ),
                        Container(
                          height: 90.h,
                          child:userProvider.getProfileType==doctor && doctorProvider.getDoctor.id!=null && startDays!=null && endDay!=null ? waitingRoomFuture( startDays, endDay,_selectedDay, doctorProvider.getDoctor.id):Center(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Aucune activite n'as été enregistrer pour l'instant... "),
                          ))),
                     ],
                    ),
                  )
          ],
        ),
    );
    
  
     
  }
}
