import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  String? id, adherentId, beneficiaryId, avatarUrl, appointmentType, consultationType, username, doctorName, doctorId, title, token;
  Timestamp? birthDate, endTime, startTime, dateCreated;
  bool? announced, enabled, isNotWithDoctor;
  int? status;
  double? price;
  List? symptoms;

  AppointmentModel({this.id, this.adherentId, this.beneficiaryId, this.status, this.dateCreated, this.isNotWithDoctor, this.token, this.enabled, this.avatarUrl, this.appointmentType, this.consultationType, this.username, this.doctorName, this.doctorId, this.title, this.birthDate, this.endTime, this.startTime, this.announced, this.price, this.symptoms});

  factory AppointmentModel.fromDocument(DocumentSnapshot doc, Map data){
    return AppointmentModel(
      id: doc.id,
      adherentId: data["adherentId"],
      beneficiaryId: data["beneficiaryId"],
      doctorId: data["doctorId"],
      doctorName: data["doctorName"],
      username: data["username"],
      title: data["title"],
      isNotWithDoctor: data["rdvPrestataire"],
      symptoms: data["symptoms"],
      avatarUrl: data["avatarUrl"],
      appointmentType: data["appointment-type"],
      announced: data["announced"],
      consultationType: data["consultation-type"],
      birthDate: data["birthDate"],
      dateCreated: data["createdDate"],
      startTime: data["start-time"],
      endTime: data["end-time"],
      enabled: data["enabled"],
      price: data["price"],
      status: data["status"],
      token: data["agoraToken"]
    );
  }
}