import 'package:cloud_firestore/cloud_firestore.dart';

class UseCaseModel {
  String id, adherentId, consultationCode, beneficiaryId, doctorId, appointmentId, consultationId, hospitalizationId, ambulanceId, doctorName, beneficiaryName, establishment, otherInfo, title, type;
  Timestamp dateCreated;
  num amount, coverage, consultationCost;
  num status, consultationStatus;
  List bookletUrls, receiptUrls, otherDocUrls;
  bool closed, bookletIsValid, receiptIsValid, otherDocIsValid, executed;

  UseCaseModel({this.id, this.adherentId, this.doctorId, this.consultationCode, this.consultationStatus, this.ambulanceId, this.consultationId, this.hospitalizationId, this.executed, this.consultationCost, this.closed, this.coverage, this.doctorName, this.appointmentId, this.beneficiaryId, this.beneficiaryName, this.amount, this.establishment, this.otherInfo, this.title, this.type, this.dateCreated, this.status, this.bookletUrls, this.receiptUrls, this.otherDocUrls, this.bookletIsValid, this.receiptIsValid, this.otherDocIsValid});

  factory UseCaseModel.fromDocument(DocumentSnapshot doc){
    return UseCaseModel(
      id: doc.id,
      adherentId: doc.get("adherentId"),
      beneficiaryId: doc.get("beneficiaryId"),
      beneficiaryName: doc.get("beneficiaryName"),
      consultationCode: doc.get("consultationCode"),
      consultationCost: doc.get("consultationCost"),
      consultationId: doc.get("consultationId"),
      ambulanceId: doc.get("ambulanceId"),
      hospitalizationId: doc.get("hospitalizationId"),
      consultationStatus: doc.get("consultationStatus"),
      status: doc.get("status"),
      doctorId: doc.get("idMedecin"),
      title: doc.get("title"),
      amount: doc.get("amountToPay") != null ? double.parse(doc.get("amountToPay").toString()) : null,
      establishment: doc.get("establishment"),
      otherInfo: doc.get("otherInfo"),
      type: doc.get("type"),
      dateCreated: doc.get("createdDate"),
      doctorName: doc.get("doctorName"),
      coverage: doc.get("coverage"),
      bookletUrls: doc.get("bookletUrls"),
      receiptUrls: doc.get("receiptUrls"),
      otherDocUrls: doc.get("otherDocUrls"),
      bookletIsValid: doc.get("bookletIsValid"),
      receiptIsValid: doc.get("receiptIsValid"),
      otherDocIsValid: doc.get("otherDocIsValid"),
      executed: doc.get("executed"),
      closed: doc.get('closed')
    );
  }
}