import 'dart:convert';
import 'dart:math';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/appointmentModel.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/helpers/utils.dart';
import 'package:danaid/views/adhrent_views/video_room.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/doctor_info_cards.dart';
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:danaid/core/providers/appointmentProvider.dart';
import 'package:simple_tags/simple_tags.dart';
import 'package:http/http.dart' as http;

class AppointmentDetails extends StatefulWidget {
  final AdherentModel adherent;
  AppointmentDetails({Key key, this.adherent}):super(key:key);
  @override
  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {

  TextEditingController _symptomController = new TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey = new GlobalKey();

  DoctorModel doc;
  String reason = "";
  List<String> symptoms = [];

  String currentSymptomText = "";
  List<String> suggestions = [
    "Migraines",
    "Fatigue",
    "Diarrhée",
    "Fièvre",
    "Maux de tête",
    "Courbatures",
    "Maux de ventre"
  ];

  bool saveLoading = false;
  bool announceLoading = false;
  bool cancelLoading = false;
  var code;
  bool edit = false;

  initialization(){

    AppointmentModelProvider appointment = Provider.of<AppointmentModelProvider>(context, listen: false);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    if(doctorProvider.getDoctor != null){
      setState((){
        doc = doctorProvider.getDoctor;
      });
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
  code = getRandomString(4);
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    var result = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return 'YM' + result;
  }

  Future<String> createConsultationCode(QueryDocumentSnapshot adherent, id) async {
    DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);

    var date = DateTime.now();
    var newUseCase = FirebaseFirestore.instance.collection('USECASES').doc();
    newUseCase.set({
      'id': newUseCase.id,
      'idAppointement': id,
      'adherentId': adherent['adherentId'],
      'beneficiaryId': adherent['beneficiaryId'],
      'beneficiaryName': adherent['username'],
      'otherInfo': '',
      'establishment': doctorProvider.getDoctor.officeName,
      'consultationCode': code,
      'type': 'RDV',
      'amountToPay': doctorProvider.getDoctor.rate != null ? doctorProvider.getDoctor.rate["public"] : null,
      "consultationCost": doctorProvider.getDoctor.rate != null ? doctorProvider.getDoctor.rate["public"] : null,
      'status': 0,
      'canPay': 0,
      'createdDate': DateTime.now(),
      'enable': false,
    }, SetOptions(merge: true)).then((value) {
      setState(() {
        saveLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              S.of(context).leCodeCeConsultationCreerAvecSuccesCommeMdecinDe)));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        saveLoading = false;
      });
    });

    return newUseCase.id;
  }
  
   addCodeToAdherent(code,id) async {
    await FirebaseFirestore.instance.collection('ADHERENTS').doc(id).set({
      'CurrentcodeConsultation' : code
    },SetOptions(merge: true)).then((value) {
    });

  }
  facturationCode(id, adherent, idAppointement) async {
    DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('USECASES')
        .doc(id)
        .collection('FACTURATIONS')
        .doc(adherent['adherentId'])
        .set({
      'id': Utils.createCryptoRandomString(8),
      'idAppointement':idAppointement,
      'idAdherent': adherent['adherentId'],
      'idBeneficiairy': adherent['beneficiaryId'],
      'idMedecin': doctorProvider.getDoctor.id,
      'amountToPay':2000,
      'isSolve': false,
      'Type': adherent['appointment-type'],
      'createdAt': DateTime.now(),
    }, SetOptions(merge: true)).then((value) {
      setState(() {
        saveLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).laFactureABienEteGenererAvecSucces)));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        saveLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    AppointmentModelProvider appointment = Provider.of<AppointmentModelProvider>(context);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context);
    DateTime startTime = appointment.getAppointment.startTime.toDate();
    DateTime endTime = appointment.getAppointment.endTime.toDate();

    var options = BaseOptions(
      baseUrl: 'http://admin.danaid.org:3000/api/v1',
      method: 'GET',
      contentType: 'application/json',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = Dio(options);

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
                            onTap: () {
                            },
                          ) : Center(child: Loaders().buttonLoader(kSouthSeas)),
                        ],
                      ),
                    ),
                          
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).quelEnEstLaRaison, style: TextStyle(color: kTextBlue, fontSize: wv*4, fontWeight: FontWeight.w400)),
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

                          
                          symptoms.isNotEmpty ? SimpleTags(
                            content: symptoms,
                            wrapSpacing: 4,
                            wrapRunSpacing: 4,
                            tagContainerPadding: EdgeInsets.all(6),
                            tagTextStyle: TextStyle(color: textWhiteColor, fontWeight: FontWeight.bold),
                            tagContainerDecoration: BoxDecoration(
                              color: lightGreyColor.withOpacity(0.6),
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
            !edit ? Row(
              children: [
                SizedBox(width: wv*4,),
                Expanded(
                  flex: 7,
                  child: CustomTextButton(
                    noPadding: true,
                    isLoading: announceLoading,
                    enable:  appointment.getAppointment.status==1 ? false: true,
                    text: S.of(context).approuver,
                    action: () async {
                      setState(() {
                        announceLoading = true;
                      });
                      try {
                        String token;

                        if(appointment.getAppointment.consultationType == "Video"){
                          var url = Uri.parse('http://admin.danaid.org:3000/api/v1/getToken');
                          var response = await http.post(url, body: {"appID": agoraAppId, "appCertificate": agoraAppCertificate, "channelName": appointment.getAppointment.id, "uid": "20000", "roleApi" : "AUTHOR"}).catchError((e){print(e.toString());});
                          print(response.toString());
                          var body = jsonDecode(response.body);
                          print(body.toString());
                          token = body['data'];
                          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoRoom(token: token, channelName: appointment.getAppointment.id, uid: 20000,),),);
                        }
                        
                         final Map<String, dynamic> codes = {
                          'codeConsultation': code,
                          'createdDate': DateTime.now()
                         };
                         var data =  FirebaseFirestore.instance
                        .collection("APPOINTMENTS")
                        .where("doctorId", isEqualTo: doctorProvider.getDoctor.id)
                        .where("adherentId", isEqualTo:appointment.getAppointment.adherentId);
                        data.get().then((docSnapshot) async => {
                          if (docSnapshot.docs.isEmpty)
                            { // il  existe pas mais
                                 print("jhdsfjkhdsjkfd")
                            }
                          else
                            {
                              print("55555555555555555555555555"),
                              FirebaseFirestore.instance
                                  .collection("APPOINTMENTS")
                                  .doc(appointment.getAppointment.id)
                                  .set({
                                "status": 1,
                                "agoraToken": token
                              },  SetOptions(merge: true)).then((value) async {
                                 print('ok33333333333333333333333333333');
                                  var usecase= FirebaseFirestore.instance.collection('USECASES')
                                .where("idAppointement", isEqualTo: appointment.getAppointment.id).get(); 
                                usecase.then((value) async {
                                      if(value.docs.isEmpty){   
                                        var adherent=FirebaseFirestore.instance.collection('ADHERENTS').doc(appointment.getAppointment.adherentId).get();
                                        adherent.then((value) async {
                                          if(value.data()['CurrentcodeConsultation']!=null){
                                              
                                                Timestamp t = value.data()['CurrentcodeConsultation']['createdDate'];
                                                    DateTime d = t.toDate();
                                                   print(t);
                                                   print(d);
                                                  final date2 = DateTime.now(); 
                                                  final difference = date2.difference(d).inDays;
                                                  print(difference);
                                                  if( difference>14){
                                                    await createConsultationCode(docSnapshot.docs[0], appointment.getAppointment.id).then((value) async {
                                                    await facturationCode(value, docSnapshot.docs[0],  appointment.getAppointment.id);
                                                    await addCodeToAdherent(codes, docSnapshot.docs[0].id);
                                                    });
                                                  }
                                          }else{
                                              await createConsultationCode(docSnapshot.docs[0], appointment.getAppointment.id).then((value) async {
                                                    await facturationCode(value, docSnapshot.docs[0],  appointment.getAppointment.id);
                                                    await addCodeToAdherent(codes, docSnapshot.docs[0].id);
                                              });
                                          }

                                        });
                                       appointment.setAnnouncement(true);
                                      }else{
                                         ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(S.of(context).uneFactureADejaTGnererPourCetteConstultation)));
                                      }
                                });
                            
                             
                              setState(() {
                                announceLoading = false;
                                edit=false;
                                 appointment.getAppointment.status=1;
                              });
                              }).then((value) {
                                // Navigator.pop(context);
                              
                              })
                            },
                        });
                        // FirebaseFirestore.instance.collection("APPOINTMENTS").doc(appointment.getAppointment.id).set({
                        //   "status": 1
                        // },  SetOptions(merge: true)).then((value) async {
                        //    await createConsultationCode(widget.adherent)
                        //   .then((value) async {
                        //     await facturationCode(value, widget.adherent);
                        //   });
                        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Le rendez vous a été approuver..'),));
                        //   appointment.setAnnouncement(true);
                        //    setState(() {
                        //     announceLoading = false;
                        //     edit=false;
                        //     appointment.getAppointment.status=1;
                        //   });
                        // });
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
                    text: S.of(context).rejeter,
                    enable:  appointment.getAppointment.status==2 ? false: true,
                    isLoading: cancelLoading,
                    color: kSouthSeas,
                    action: (){
                      setState(() {
                        cancelLoading = true;
                      });
                      try {
                        FirebaseFirestore.instance.collection("APPOINTMENTS").doc(appointment.getAppointment.id).set({
                          "status": 2
                        },  SetOptions(merge: true)).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).lannonceATRejeter),));
                          appointment.setAnnouncement(false);
                           setState(() {
                            cancelLoading = false;
                            edit=false;
                            appointment.getAppointment.status=2;
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
            ) :
            Container(
              padding: EdgeInsets.symmetric(horizontal: wv*4),
              child: CustomTextButton(
                text: S.of(context).mettreEnAttente,
                isLoading: saveLoading,
                
                noPadding: true,
                action: (){
                  setState(() {
                    saveLoading = true;
                  });
                  try {
                    FirebaseFirestore.instance.collection("APPOINTMENTS").doc(appointment.getAppointment.id).set({
                      "status": 0
                    },  SetOptions(merge: true)).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).ceRendezvousATMisEnAttente),));
                      setState(() {
                            announceLoading = false;
                            edit=false;
                            appointment.getAppointment.status=0;
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