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
      adherentId: doc.data()["adherentId"],
      beneficiaryId: doc.data()["beneficiaryId"],
      beneficiaryName: doc.data()["beneficiaryName"],
      consultationCode: doc.data()["consultationCode"],
      consultationCost: doc.data()["consultationCost"],
      consultationId: doc.data()["consultationId"],
      ambulanceId: doc.data()["ambulanceId"],
      hospitalizationId: doc.data()["hospitalizationId"],
      consultationStatus: doc.data()["consultationStatus"],
      status: doc.data()["status"],
      doctorId: doc.data()["idMedecin"],
      title: doc.data()["title"],
      amount: doc.data()["amountToPay"] != null ? double.parse(doc.data()["amountToPay"].toString()) : null,
      establishment: doc.data()["establishment"],
      otherInfo: doc.data()["otherInfo"],
      type: doc.data()["type"],
      dateCreated: doc.data()["createdDate"],
      doctorName: doc.data()["doctorName"],
      coverage: doc.data()["coverage"],
      bookletUrls: doc.data()["bookletUrls"],
      receiptUrls: doc.data()["receiptUrls"],
      otherDocUrls: doc.data()["otherDocUrls"],
      bookletIsValid: doc.data()["bookletIsValid"],
      receiptIsValid: doc.data()["receiptIsValid"],
      otherDocIsValid: doc.data()["otherDocIsValid"],
      executed: doc.data()["executed"],
      closed: doc.data()['closed']
    );
  }
}