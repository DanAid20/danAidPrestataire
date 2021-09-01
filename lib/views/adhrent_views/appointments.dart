import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/appointmentModel.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:danaid/core/models/usecaseModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/appointmentProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/usecaseModelProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/adhrent_views/video_room.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:danaid/helpers/constants.dart' as constants;
import 'package:http/http.dart' as http;

class AppointmentsList extends StatefulWidget {
  final DoctorModel doc;
  const AppointmentsList({ Key key, this.doc }) : super(key: key);

  @override
  _AppointmentsListState createState() => _AppointmentsListState();
}

class _AppointmentsListState extends State<AppointmentsList> {
  int limit = 20;
  @override
  Widget build(BuildContext context) {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDeepTeal,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, color: whiteColor,), onPressed: ()=>Navigator.pop(context)),
        title: Text("Liste de rendez-vous", style: TextStyle(color: whiteColor, fontSize: 18.5),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("APPOINTMENTS").where('adherentId', isEqualTo: adherentProvider.getAdherent.adherentId).orderBy('start-time', descending: true).limit(limit).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }
          int lastIndex = snapshot.data.docs.length - 1;

          return snapshot.data.docs.length >= 1
            ? NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                  var metrics = scrollEnd.metrics;
                  if (metrics.atEdge) {
                    if (metrics.pixels == 0) print('At top');
                    else setState(() {limit = limit + 5;});
                  }
                  return true;
                },
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot rdv = snapshot.data.docs[index];
                    AppointmentModel appointment = AppointmentModel.fromDocument(rdv);
                    return Padding(
                      padding: EdgeInsets.only(bottom: lastIndex == index ? hv * 7 : 0),
                      child: HomePageComponents().getMyDoctorAppointmentTile(
                        doctorName: "Dr. ${appointment.doctorName}"+S.of(context).mdcinDeFamille,
                        date: appointment.startTime.toDate(),
                        state: appointment.status,
                        type: Algorithms.getConsultationTypeLabel(appointment.consultationType),
                        label: Algorithms.getAppointmentReasonLabel(appointment.title),
                        action: () async {
                          AppointmentModelProvider appointmentProvider = Provider.of<AppointmentModelProvider>(context, listen: false);
                          appointmentProvider.setAppointmentModel(appointment);
                          widget.doc != null ? doctorProvider.setDoctorModel(widget.doc) : print("nope");
                          if(appointment.consultationType == "Video"){
                            /*if(appointment.startTime.toDate().isBefore(DateTime.now())){
                              Navigator.pushNamed(context, '/appointment');
                            } */
                            if(appointment.token != null){
                              print("getting toke..");
                              var url = Uri.parse('http://admin.danaid.org:3000/api/v1/getToken');
                            
                              //var response = await http.post(url, body: {"appID": constants.agoraAppId, "appCertificate": constants.agoraAppCertificate, "channelName": appointment.id, "uid": '112233', "roleApi" : "SUBSCRIBER"}).catchError((e){print(e.toString());});
                              
                              var response = await http.post(url, body: {"appID": constants.agoraAppId, "appCertificate": constants.agoraAppCertificate, "channelName": appointment.id, "uid": "10000", "roleApi" : "SUBSCRIBER"}).catchError((e){print(e.toString());});
                              print(response.toString());
                              var body = jsonDecode(response.body);
                              print(body.toString());
                              String token = body['data'];
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoRoom(token: token, channelName: appointment.id, uid: 10000,),),);
                            }
                            else {
                              Navigator.pushNamed(context, '/appointment');
                            }
                          }
                          else {
                            Navigator.pushNamed(context, '/appointment');
                          }
                          
                        }
                      ),
                    );
                  }),
            )
            : Center(
              child: Container(padding: EdgeInsets.only(bottom: hv*4),child: Text(S.of(context).aucunCasDutilisationEnrgistrPourLeMoment, textAlign: TextAlign.center)),
            );
        }
      ),
    );
  }
}