import 'package:cloud_firestore/cloud_firestore.dart';

class UseCaseServiceModel {
  String? id,adherentId,prestataireId,paiementCode, beneficiaryId,titleDuDEvis, consultationCode, idAppointement, usecaseId, title, type, adminFeedback, establishment;
  Timestamp? dateCreated, date, precriptionUploadDate, receiptUploadDate, drugsUploadDate, resultsUploadDate;
  num? amount, advance, justifiedFees;
  num? status;
  List? precriptionUrls, drugsList, receiptUrls, drugsUrls, resultsUrls, bookletUrls, otherDocUrls;
  bool? closed, paid, isConfirmDrugList, precriptionIsValid, receiptIsValid, drugsIsValid, resultsIsValid, bookletIsValid, otherDocIsValid, executed, estimate, ongoing, requested;

  UseCaseServiceModel({this.id, this.isConfirmDrugList, this.drugsList, this.prestataireId, this.paiementCode, this.adherentId, this.beneficiaryId, this.titleDuDEvis ,this.consultationCode, this.idAppointement, this.paid, this.closed, this.amount, this.establishment, this.title, this.type, this.usecaseId, this.dateCreated, this.date, this.advance, this.justifiedFees, this.status, this.precriptionUrls, this.receiptUrls, this.drugsUrls, this.resultsUrls, this.otherDocUrls, this.bookletUrls, this.otherDocIsValid, this.bookletIsValid, this.precriptionIsValid, this.receiptIsValid, this.drugsIsValid, this.resultsIsValid, this.precriptionUploadDate, this.receiptUploadDate, this.drugsUploadDate, this.resultsUploadDate, this.adminFeedback, this.estimate, this.executed, this.ongoing, this.requested});

  factory UseCaseServiceModel.fromDocument(DocumentSnapshot doc, Map data){
    return UseCaseServiceModel(
      id: doc.id,
      usecaseId: data["usecaseId"],
      status: data["status"],
      adherentId: data["adherentId"],
      beneficiaryId: data["beneficiaryId"],
      titleDuDEvis: data["titleDuDEvis"],
      paiementCode: data["PaiementCode"],
      idAppointement: data["appointementId"],
      prestataireId: data["prestataireId"],
      consultationCode: data["consultationCode"],
      isConfirmDrugList:data["isConfirmDrugList"],
      title: data["title"],
      paid: data["paid"],
      amount: data["amountToPay"] != null ? double.parse(data["amountToPay"].toString()) : null,
      advance: data["advance"],
      establishment: data["establishment"],
      adminFeedback: data["adminFeedback"],
      justifiedFees: data["justifiedFees"],
      type: data["type"],
      dateCreated: data["createdDate"],
      date: data["serviceDate"],
      precriptionUrls: data["precriptionUrls"],
      receiptUrls: data["receiptUrls"],
      drugsUrls: data["drugsUrls"],
      drugsList: data["drugsList"],
      resultsUrls: data["resultsUrls"],
      closed: data['closed'],
      precriptionIsValid: data["precriptionIsValid"],
      receiptIsValid: data["receiptIsValid"],
      drugsIsValid: data["drugsIsValid"],
      resultsIsValid: data["resultsIsValid"],
      precriptionUploadDate: data["precriptionUploadDate"],
      receiptUploadDate: data["receiptUploadDate"],
      drugsUploadDate: data["drugsUploadDate"],
      resultsUploadDate: data["resultsUploadDate"],
      bookletUrls: data["bookletUrls"],
      otherDocUrls: data["otherDocUrls"],
      bookletIsValid: data["bookletIsValid"],
      otherDocIsValid: data["otherDocIsValid"],
      executed: data["executed"],
      estimate: data["estimated"],
      ongoing: data["ongoing"],
      requested: data["requested"]
    );
  }
}