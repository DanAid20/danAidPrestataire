import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  String id, adherentId, beneficiaryId, avatarUrl, appointmentType, consultationType, username, doctorName, doctorId, title, token;
  Timestamp birthDate, endTime, startTime, dateCreated;
  bool announced, enabled, isNotWithDoctor;
  int status;
  double price;
  List symptoms;

  AppointmentModel({this.id, this.adherentId, this.beneficiaryId, this.status, this.dateCreated, this.isNotWithDoctor, this.token, this.enabled, this.avatarUrl, this.appointmentType, this.consultationType, this.username, this.doctorName, this.doctorId, this.title, this.birthDate, this.endTime, this.startTime, this.announced, this.price, this.symptoms});

  factory AppointmentModel.fromDocument(DocumentSnapshot doc){
    return AppointmentModel(
      id: doc.id,
      adherentId: doc.data()["adherentId"],
      beneficiaryId: doc.data()["beneficiaryId"],
      doctorId: doc.data()["doctorId"],
      doctorName: doc.data()["doctorName"],
      username: doc.data()["username"],
      title: doc.data()["title"],
      isNotWithDoctor: doc.data()["rdvPrestataire"],
      symptoms: doc.data()["symptoms"],
      avatarUrl: doc.data()["avatarUrl"],
      appointmentType: doc.data()["appointment-type"],
      announced: doc.data()["announced"],
      consultationType: doc.data()["consultation-type"],
      birthDate: doc.data()["birthDate"],
      dateCreated: doc.data()["createdDate"],
      startTime: doc.data()["start-time"],
      endTime: doc.data()["end-time"],
      enabled: doc.data()["enabled"],
      price: doc.data()["price"],
      status: doc.data()["status"],
      token: doc.data()["agoraToken"]
    );
  }
}