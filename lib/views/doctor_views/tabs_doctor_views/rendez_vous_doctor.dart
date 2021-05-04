import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
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
   var _selectedDay=null;
   var _focusedDay=null;
   var startDays;
   var endDay;
   var now = new DateTime.now();
   final df = new DateFormat('dd-MMM-yyyy');
  
  @override
  void initState() { 
    super.initState();
    triggerGetPatient();
  }
  triggerGetPatient(){
      DateTime dateTimeNow = DateTime.now();
      String startDay= dateTimeNow.toString().substring(0,11);
      String firebaseFormatedDay= startDay+"00:00:00.000Z";
      String sendHours= startDay+"23:59:59.000Z";
      DateTime todayDate = DateTime.parse(sendHours); 
      print(firebaseFormatedDay);
      print(todayDate);
      print(sendHours);
      print(startDay);
      setState(() {startDays = firebaseFormatedDay;endDay=todayDate; _focusedDay = startDay;});
  }
  waitingRoomFuture( startDays, endDay,date, doctor){
    Stream<QuerySnapshot> query = FirebaseFirestore.instance
        .collection("APPOINTMENTS")
        .where("status",  isEqualTo: 1)
        .where("doctorId", isEqualTo: doctor)
        .where("start-time", isGreaterThan: startDays, isLessThan: endDay)
        .orderBy("start-time")
        .snapshots();
    return StreamBuilder(
        stream: query,
        builder: (context, snapshot) {
          print(snapshot.data.docs.length);
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }
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
              : Center(
                  child: Text(" Aucun patient en salee d'attente.."),
                );
        });

  }

  getListOfUser( startDays, endDay,date, doctorId) {
    Stream<QuerySnapshot> query = FirebaseFirestore.instance
        .collection("APPOINTMENTS")
        .where("doctorId", isEqualTo: doctorId)
        .where("status",  isEqualTo: 0)
        .where("start-time", isGreaterThan: startDays, isLessThan: endDay)
        .orderBy("start-time")
        .snapshots();
       
    return StreamBuilder(
        stream: query,
        builder: (context, snapshot) {
          print(snapshot.data.docs.length);
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }
          int lastIndex = snapshot.data.docs.length - 1;
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
                        return HomePageComponents().timeline(consultationtype: doc.data()["consultation-type"] , isPrestataire: false,age: "$differenceInDays ans" ,consultationDetails: '${doc.data()["title"]}',consultationType: "${doc.data()["appointment-type"]}",time:"${formattedTime}",userImage: '${data["imageUrl"]}',userName: '${data["prenom"]} ${data["nomFamille"]} ');
                      }
                      return Text("loading");
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
                      _focusedDay = focusedDay; // update `_focusedDay` here as well
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
                      setState(() {
                        triggerGetPatient();
                        print('l;kdufjdlksfjdlks');
                      });
                    },
                    child: Container(
                    margin: EdgeInsets.only(
                        left: wv * 4, right: wv * 1.5, top: hv * 0),
                    child: Text(
                      "Aujourd'hui",
                      style: TextStyle(
                         color: isPrestataire? kBlueForce :whiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: fontSize(size: wv * 4)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: wv * 1.5, right: wv * 1.5, top: hv * 0),
                  child: Text(
                    "Semaine",
                    style: TextStyle(
                        color: isPrestataire? kBlueForce :whiteColor,
                        fontWeight: FontWeight.w500,
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
                alignment: Alignment.center,
                child: userProvider.getProfileType==doctor && doctorProvider.getDoctor.id!=null && startDays!=null && endDay!=null ? getListOfUser( startDays, endDay,_selectedDay, doctorProvider.getDoctor.id):Text("loading"))
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
                          child:userProvider.getProfileType==doctor && doctorProvider.getDoctor.id!=null && startDays!=null && endDay!=null ? waitingRoomFuture( startDays, endDay,_selectedDay, doctorProvider.getDoctor.id):Text("xlkcvdlkfjsdl;fkdsfks")),
                     ],
                    ),
                  )
          ],
        ),
    );
    
  
     
  }
}
