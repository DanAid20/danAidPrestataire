import 'package:cloud_firestore/cloud_firestore.dart';

class UseCaseServiceModel {
  String? id,adherentId,prestataireId,paiementCode, beneficiaryId,titleDuDEvis, consultationCode, idAppointement, usecaseId, title, type, adminFeedback, establishment;
  Timestamp? dateCreated, date, precriptionUploadDate, receiptUploadDate, drugsUploadDate, resultsUploadDate;
  num? amount, advance, justifiedFees;
  num? status;
  List? precriptionUrls, drugsList, receiptUrls, drugsUrls, resultsUrls, bookletUrls, otherDocUrls;
  bool? closed, paid, isConfirmDrugList, precriptionIsValid, receiptIsValid, drugsIsValid, resultsIsValid, bookletIsValid, otherDocIsValid, executed, estimate, ongoing, requested;

  UseCaseServiceModel({this.id, this.isConfirmDrugList, this.drugsList, this.prestataireId, this.paiementCode, this.adherentId, this.beneficiaryId, this.titleDuDEvis ,this.consultationCode, this.idAppointement, this.paid, this.closed, this.amount, this.establishment, this.title, this.type, this.usecaseId, this.dateCreated, this.date, this.advance, this.justifiedFees, this.status, this.precriptionUrls, this.receiptUrls, this.drugsUrls, this.resultsUrls, this.otherDocUrls, this.bookletUrls, this.otherDocIsValid, this.bookletIsValid, this.precriptionIsValid, this.receiptIsValid, this.drugsIsValid, this.resultsIsValid, this.precriptionUploadDate, this.receiptUploadDate, this.drugsUploadDate, this.resultsUploadDate, this.adminFeedback, this.estimate, this.executed, this.ongoing, this.requested});

  factory UseCaseServiceModel.fromDocument(DocumentSnapshot doc){
    return UseCaseServiceModel(
      id: doc.id,
      usecaseId: doc.get("usecaseId"),
      status: doc.get("status"),
      adherentId: doc.get("adherentId"),
      beneficiaryId: doc.get("beneficiaryId"),
      titleDuDEvis: doc.get("titleDuDEvis"),
      paiementCode: doc.get("PaiementCode"),
      idAppointement: doc.get("appointementId"),
      prestataireId: doc.get("prestataireId"),
      consultationCode: doc.get("consultationCode"),
      isConfirmDrugList:doc.get("isConfirmDrugList"),
      title: doc.get("title"),
      paid: doc.get("paid"),
      amount: doc.get("amountToPay") != null ? double.parse(doc.get("amountToPay").toString()) : null,
      advance: doc.get("advance"),
      establishment: doc.get("establishment"),
      adminFeedback: doc.get("adminFeedback"),
      justifiedFees: doc.get("justifiedFees"),
      type: doc.get("type"),
      dateCreated: doc.get("createdDate"),
      date: doc.get("serviceDate"),
      precriptionUrls: doc.get("precriptionUrls"),
      receiptUrls: doc.get("receiptUrls"),
      drugsUrls: doc.get("drugsUrls"),
      drugsList: doc.get("drugsList"),
      resultsUrls: doc.get("resultsUrls"),
      closed: doc.get('closed'),
      precriptionIsValid: doc.get("precriptionIsValid"),
      receiptIsValid: doc.get("receiptIsValid"),
      drugsIsValid: doc.get("drugsIsValid"),
      resultsIsValid: doc.get("resultsIsValid"),
      precriptionUploadDate: doc.get("precriptionUploadDate"),
      receiptUploadDate: doc.get("receiptUploadDate"),
      drugsUploadDate: doc.get("drugsUploadDate"),
      resultsUploadDate: doc.get("resultsUploadDate"),
      bookletUrls: doc.get("bookletUrls"),
      otherDocUrls: doc.get("otherDocUrls"),
      bookletIsValid: doc.get("bookletIsValid"),
      otherDocIsValid: doc.get("otherDocIsValid"),
      executed: doc.get("executed"),
      estimate: doc.get("estimated"),
      ongoing: doc.get("ongoing"),
      requested: doc.get("requested")
    );
  }
}