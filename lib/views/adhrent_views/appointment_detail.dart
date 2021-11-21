import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/adhrent_views/video_room.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/doctor_info_cards.dart';
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:danaid/core/providers/appointmentProvider.dart';
import 'package:simple_tags/simple_tags.dart';
import 'package:http/http.dart' as http;
import 'package:danaid/helpers/constants.dart' as constants;

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {

  TextEditingController _symptomController = new TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey = new GlobalKey();

  DoctorModel doc;
  ServiceProviderModel sp;
  String reason = "";
  List<String> symptoms = [];

  String currentSymptomText = "";
  List<String> suggestions = [
    S.current.migraines,
    S.current.fatigue,
    S.current.diarrhe,
    S.current.fivre,
    S.current.mauxDeTte,
    S.current.courbatures,
    S.current.mauxDeVentre
  ];

  bool saveLoading = false;
  bool announceLoading = false;
  bool cancelLoading = false;

  bool edit = false;

  initialization(){

    AppointmentModelProvider appointment = Provider.of<AppointmentModelProvider>(context, listen: false);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    if(appointment.getAppointment.isNotWithDoctor == true){
      FirebaseFirestore.instance.collection(serviceProvider).doc(appointment.getAppointment.doctorId).get().then((docSnapshot) {
        ServiceProviderModel serviceP = ServiceProviderModel.fromDocument(docSnapshot);
        sp = serviceP;
        setState((){});
      });
    }
    else {
      if(doctorProvider.getDoctor != null){
        setState((){
          doc = doctorProvider.getDoctor;
        });
      }
    }

    setState(() {
      for(int i = 0; i < appointment.getAppointment.symptoms.length; i++){
        symptoms.add(appointment.getAppointment.symptoms[i]);
      }

      reason = appointment.getAppointment.title;
    });
    
  }

  @override
  void initState() {
    initialization();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AppointmentModelProvider appointment = Provider.of<AppointmentModelProvider>(context);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context);
    DateTime startTime = appointment.getAppointment.startTime.toDate();
    DateTime endTime = appointment.getAppointment.endTime.toDate();
    DateTime now = DateTime.now();
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,), 
            onPressed: ()=>Navigator.pop(context)
          ),
          title: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(S.of(context).dmandeDePriseEnCharge, style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
              Text(S.of(context).rendezvous, 
                style: TextStyle(color: kPrimaryColor, fontSize: wv*3.8, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kSouthSeas,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: (){})
          ],
        ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*3),
        padding: EdgeInsets.symmetric(vertical: hv*2.5),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 3.0, spreadRadius: 1.0, offset: Offset(0, 2))]
        ),
        child: Column(
          children: [
            Row(children: [
              SizedBox(width: wv*4,),
              Text(DateFormat('EEEE', 'fr_FR').format(startTime)+", "+ startTime.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(startTime)+" "+ startTime.year.toString(), style: TextStyle(color: kBlueDeep, fontSize: 16.5, fontWeight: FontWeight.w600)),
              Spacer(),
              Text(startTime.hour.toString().padLeft(2, '0')+ "H:"+startTime.minute.toString().padLeft(2, '0')+ " à "+ endTime.hour.toString().padLeft(2, '0') + "H:"+endTime.minute.toString().padLeft(2, '0'), style: TextStyle(color: kBlueDeep, fontSize: 14, fontWeight: FontWeight.w400)),
              SizedBox(width: wv*4,)
            ],),
            SizedBox(height: hv*2,),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: kSouthSeas.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: wv*4),
                                  decoration: BoxDecoration(
                                    //color: kSouthSeas.withOpacity(0.3),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: hv*1),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(S.of(context).pourLePatient, style: TextStyle(color: kTextBlue, fontSize: wv*4, fontWeight: FontWeight.w900)),
                                        SizedBox(height: hv*1,),
                                        Row(children: [
                                          CircleAvatar(
                                            backgroundImage: appointment.getAppointment.avatarUrl != null ? CachedNetworkImageProvider(appointment.getAppointment.avatarUrl) : null,
                                            backgroundColor: whiteColor,
                                            radius: wv*6,
                                            child: appointment.getAppointment.avatarUrl != null ? Container() : Icon(LineIcons.user, color: kSouthSeas.withOpacity(0.7), size: wv*10),
                                          ),
                                          SizedBox(width: wv*3,),
                                          Expanded(
                                            child: RichText(text: TextSpan(
                                              text: appointment.getAppointment.username + "\n",
                                              children: [
                                                TextSpan(text: (DateTime.now().year - appointment.getAppointment.birthDate.toDate().year).toString() + " ans", style: TextStyle(fontSize: wv*3.3)),
                                              ], style: TextStyle(color: kBlueDeep, fontSize: wv*4.2)),
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],),
                                        SizedBox(height: hv*0.5,)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              
                              GestureDetector(
                                onTap: ()=>setState((){edit = !edit;}),
                                child: Container(
                                  padding: EdgeInsets.all(wv*1.5),
                                  decoration: BoxDecoration(
                                    color: kGoldDeep.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: SvgPicture.asset('assets/icons/Bulk/Edit.svg', color: kGoldDeep, width: 20,),
                                ),
                              ),

                              SizedBox(width: wv*5),
                            ],
                          ),
                          SizedBox(height: hv*2.5,),
                          Text(S.of(context).rendezvousChez, style: TextStyle(color: kTextBlue, fontSize: wv*4, fontWeight: FontWeight.w900)),
                          SizedBox(height: hv*1.2,),
                          doc != null ? DoctorInfoCard(
                            noPadding: true,
                            avatarUrl: doc.avatarUrl,
                            name: doc.cniName,
                            title: S.of(context).medecinDeFamille + doc.field,
                            speciality: doc.speciality,
                            teleConsultation: doc.serviceList != null ? doc.serviceList["tele-consultation"] : false,
                            consultation: doc.serviceList != null ? doc.serviceList["consultation"] : false,
                            chat: doc.serviceList != null ? doc.serviceList["chat"] : false,
                            rdv: doc.serviceList != null ? doc.serviceList["rdv"] : false,
                            visiteDomicile: doc.serviceList != null ? doc.serviceList["visite-a-domicile"] : false,
                            field: doc.speciality,
                            officeName: doc.officeName,
                            isInRdvDetail: true,
                            appointmentState: appointment.getAppointment.status,
                            includeHospital: true,
                            service: "Consultation - " + appointment.getAppointment.consultationType,
                            onTap: () {
                            },
                          ) : 
                            sp != null ? DoctorInfoCard(
                              isServiceProvider: true,
                              noPadding: true,
                              avatarUrl: sp.avatarUrl,
                              name: sp.name,
                              title: sp.category,
                              speciality: sp.category,
                              //teleConsultation: doc.serviceList != null ? doc.serviceList["tele-consultation"] : false,
                              //consultation: doc.serviceList != null ? doc.serviceList["consultation"] : false,
                              //chat: doc.serviceList != null ? doc.serviceList["chat"] : false,
                              //rdv: doc.serviceList != null ? doc.serviceList["rdv"] : false,
                              //visiteDomicile: doc.serviceList != null ? doc.serviceList["visite-a-domicile"] : false,
                              field: sp.contactEmail,
                              officeName: sp.contactName,
                              isInRdvDetail: true,
                              appointmentState: appointment.getAppointment.status,
                              includeHospital: true,
                              onTap: () {
                              },
                            ) 
                            : Center(child: Loaders().buttonLoader(kSouthSeas)),
                        ],
                      ),
                    ),
                          
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).raison, style: TextStyle(color: kTextBlue, fontSize: wv*4, fontWeight: FontWeight.w400)),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: hv*0.5),
                            padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1.5),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Text(reason, style: TextStyle(color: kTextBlue, fontSize: wv*4, fontWeight: FontWeight.w900)),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: hv*2),
                            child: Text(S.of(context).symptmes, style: TextStyle(color: kTextBlue, fontSize: wv*4, fontWeight: FontWeight.w400)),
                          ),

                          edit ? Container(
                            margin: EdgeInsets.only(bottom: hv*1.5),
                            child: Stack(
                              children: [
                                SimpleAutoCompleteTextField(
                                  key: autoCompleteKey, 
                                  suggestions: suggestions,
                                  controller: _symptomController,
                                  decoration: defaultInputDecoration(),
                                  textChanged: (text) => currentSymptomText = text,
                                  clearOnSubmit: false,
                                  submitOnSuggestionTap: false,
                                  textSubmitted: (text) {
                                    if (text != "") {
                                      !symptoms.contains(_symptomController.text) ? symptoms.add(_symptomController.text) : print("yo"); 
                                    }
                                    
                                  }
                                ),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    onPressed: (){
                                      if (_symptomController.text.isNotEmpty) {
                                      setState(() {
                                        !symptoms.contains(_symptomController.text) ? symptoms.add(_symptomController.text) : print("yo");
                                        _symptomController.clear();
                                      });
                                    }
                                    },
                                    icon: CircleAvatar(child: Icon(Icons.add, color: whiteColor), backgroundColor: kSouthSeas,),),
                                )
                              ],
                            ),
                          ) : Container(),

                          symptoms.isNotEmpty ? SimpleTags(
                            content: symptoms,
                            wrapSpacing: 4,
                            wrapRunSpacing: 4,
                            onTagPress: (tag) {
                              setState(() {
                                symptoms.remove(tag);
                              });
                            },
                            tagContainerPadding: EdgeInsets.all(6),
                            tagTextStyle: TextStyle(color: kPrimaryColor),
                            tagIcon: Icon(Icons.clear, size: wv*3, color: kDeepTeal,),
                            tagContainerDecoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ) :
                          Text(S.of(context).aucunSymptmesMentions)
                        ],
                      ),
                    ),
                  ],
                ),),
            ),
            SizedBox(height: hv*1.5,),
            !edit ?  DateTime(now.year, now.month, now.day, 24).isAfter(DateTime(startTime.year, startTime.month, startTime.day)) ? Row(
                children: [
                  SizedBox(width: wv*4,),
                  Expanded(
                    flex: 7,
                    child: CustomTextButton(
                      noPadding: true,
                      isLoading: announceLoading,
                      enable: appointment.getAppointment.announced == false,
                      text: S.of(context).annoncerMaVenue,
                      action: (){
                        setState(() {
                          announceLoading = true;
                        });
                        try {
                          FirebaseFirestore.instance.collection("APPOINTMENTS").doc(appointment.getAppointment.id).set({
                            "announced": true
                          },  SetOptions(merge: true)).then((value) async {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).leRendezVousATAnnonc),));
                            appointment.setAnnouncement(true);
                            if(appointment.getAppointment.consultationType == "Video"){
                              if(appointment.getAppointment.token != null){
                                print("getting toke..");
                                var url = Uri.parse('http://admin.danaid.org:3000/api/v1/getToken');
                                var response = await http.post(url, body: {"appID": constants.agoraAppId, "appCertificate": constants.agoraAppCertificate, "channelName": appointment.getAppointment.id, "uid": "10000", "roleApi" : "SUBSCRIBER"}).catchError((e){print(e.toString());});
                                print(response.toString());
                                var body = jsonDecode(response.body);
                                print(body.toString());
                                String token = body['data'];
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoRoom(token: token, channelName: appointment.getAppointment.id, uid: 10000,),),);
                              }
                              else {
                                setState(() {
                                  announceLoading = false;
                                });
                                //Navigator.pushNamed(context, '/appointment');
                              }
                            } else {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/adherent-card');
                              setState(() {
                                announceLoading = false;
                              });
                            }
                            
                          });
                        }
                        catch(e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),)));
                          setState(() {
                            announceLoading = false;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: wv*2,),
                  Expanded(
                    flex: 3,
                    child: CustomTextButton(
                      noPadding: true,
                      text: S.of(context).annuler,
                      isLoading: cancelLoading,
                      enable: appointment.getAppointment.announced == true,
                      color: kSouthSeas,
                      action: (){
                        setState(() {
                          cancelLoading = true;
                        });
                        try {
                          FirebaseFirestore.instance.collection("APPOINTMENTS").doc(appointment.getAppointment.id).set({
                            "announced": false
                          },  SetOptions(merge: true)).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('L\'annonce a été annulée..'),));
                            appointment.setAnnouncement(false);
                            setState(() {
                              cancelLoading = false;
                            });
                          });
                        }
                        catch(e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),)));
                          setState(() {
                            cancelLoading = false;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: wv*4,),
                ],
              ) : Container(child: Text(S.of(context).noubliezPasDeRevenirIiAnnoncerVotreVenueLeJour, textAlign: TextAlign.center, style: TextStyle(color: kSouthSeas, fontSize: wv*4.2, fontWeight: FontWeight.bold)), padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),)
            :
            Container(
              padding: EdgeInsets.symmetric(horizontal: wv*4),
              child: CustomTextButton(
                text: "Sauvegarder",
                isLoading: saveLoading,
                noPadding: true,
                action: (){
                  setState(() {
                    saveLoading = true;
                  });
                  try {
                    FirebaseFirestore.instance.collection("APPOINTMENTS").doc(appointment.getAppointment.id).set({
                      "symptoms": symptoms
                    },  SetOptions(merge: true)).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).lesSymptmesOntTMisesJour),));
                      setState(() {
                        saveLoading = false;
                        edit = false;
                      });
                    });
                  }
                  catch(e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),)));
                    setState(() {
                      saveLoading = false;
                      edit = false;
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}