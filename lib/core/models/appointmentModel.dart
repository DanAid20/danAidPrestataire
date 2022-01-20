import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  String? id, adherentId, beneficiaryId, avatarUrl, appointmentType, consultationType, username, doctorName, doctorId, title, token;
  Timestamp? birthDate, endTime, startTime, dateCreated;
  bool? announced, enabled, isNotWithDoctor;
  int? status;
  double? price;
  List? symptoms;

  AppointmentModel({this.id, this.adherentId, this.beneficiaryId, this.status, this.dateCreated, this.isNotWithDoctor, this.token, this.enabled, this.avatarUrl, this.appointmentType, this.consultationType, this.username, this.doctorName, this.doctorId, this.title, this.birthDate, this.endTime, this.startTime, this.announced, this.price, this.symptoms});

  factory AppointmentModel.fromDocument(DocumentSnapshot doc){
    return AppointmentModel(
      id: doc.id,
      adherentId: doc.get("adherentId"),
      beneficiaryId: doc.get("beneficiaryId"),
      doctorId: doc.get("doctorId"),
      doctorName: doc.get("doctorName"),
      username: doc.get("username"),
      title: doc.get("title"),
      isNotWithDoctor: doc.get("rdvPrestataire"),
      symptoms: doc.get("symptoms"),
      avatarUrl: doc.get("avatarUrl"),
      appointmentType: doc.get("appointment-type"),
      announced: doc.get("announced"),
      consultationType: doc.get("consultation-type"),
      birthDate: doc.get("birthDate"),
      dateCreated: doc.get("createdDate"),
      startTime: doc.get("start-time"),
      endTime: doc.get("end-time"),
      enabled: doc.get("enabled"),
      price: doc.get("price"),
      status: doc.get("status"),
      token: doc.get("agoraToken")
    );
  }
}