import 'package:cloud_firestore/cloud_firestore.dart';

class UseCaseModel {
  String? id, adherentId, consultationCode, beneficiaryId, doctorId, appointmentId, consultationId, hospitalizationId, ambulanceId, doctorName, beneficiaryName, establishment, otherInfo, title, type;
  Timestamp? dateCreated;
  num? amount, coverage, consultationCost;
  num? status, consultationStatus;
  List? bookletUrls, receiptUrls, otherDocUrls;
  bool? closed, bookletIsValid, receiptIsValid, otherDocIsValid, executed;

  UseCaseModel({this.id, this.adherentId, this.doctorId, this.consultationCode, this.consultationStatus, this.ambulanceId, this.consultationId, this.hospitalizationId, this.executed, this.consultationCost, this.closed, this.coverage, this.doctorName, this.appointmentId, this.beneficiaryId, this.beneficiaryName, this.amount, this.establishment, this.otherInfo, this.title, this.type, this.dateCreated, this.status, this.bookletUrls, this.receiptUrls, this.otherDocUrls, this.bookletIsValid, this.receiptIsValid, this.otherDocIsValid});

  factory UseCaseModel.fromDocument(DocumentSnapshot doc, Map data){
    return UseCaseModel(
      id: doc.id,
      adherentId: data["adherentId"],
      beneficiaryId: data["beneficiaryId"],
      beneficiaryName: data["beneficiaryName"],
      consultationCode: data["consultationCode"],
      consultationCost: data["consultationCost"],
      consultationId: data["consultationId"],
      ambulanceId: data["ambulanceId"],
      hospitalizationId: data["hospitalizationId"],
      consultationStatus: data["consultationStatus"],
      status: data["status"],
      doctorId: data["idMedecin"],
      title: data["title"],
      amount: data["amountToPay"] != null ? double.parse(data["amountToPay"].toString()) : null,
      establishment: data["establishment"],
      otherInfo: data["otherInfo"],
      type: data["type"],
      dateCreated: data["createdDate"],
      doctorName: data["doctorName"],
      coverage: data["coverage"],
      bookletUrls: data["bookletUrls"],
      receiptUrls: data["receiptUrls"],
      otherDocUrls: data["otherDocUrls"],
      bookletIsValid: data["bookletIsValid"],
      receiptIsValid: data["receiptIsValid"],
      otherDocIsValid: data["otherDocIsValid"],
      executed: data["executed"],
      closed: data['closed']
    );
  }
}