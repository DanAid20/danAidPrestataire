import 'package:cloud_firestore/cloud_firestore.dart';

class UseCaseServiceModel {
  String id, usecaseId, title, type, adminFeedback, establishment;
  Timestamp dateCreated, date, precriptionUploadDate, receiptUploadDate, drugsUploadDate, resultsUploadDate;
  num amount, advance, justifiedFees;
  num status;
  List precriptionUrls, receiptUrls, drugsUrls, resultsUrls, bookletUrls, otherDocUrls;
  bool closed, precriptionIsValid, receiptIsValid, drugsIsValid, resultsIsValid, bookletIsValid, otherDocIsValid, executed, estimate, ongoing, requested;

  UseCaseServiceModel({this.id, this.closed, this.amount, this.establishment, this.title, this.type, this.usecaseId, this.dateCreated, this.date, this.advance, this.justifiedFees, this.status, this.precriptionUrls, this.receiptUrls, this.drugsUrls, this.resultsUrls, this.otherDocUrls, this.bookletUrls, this.otherDocIsValid, this.bookletIsValid, this.precriptionIsValid, this.receiptIsValid, this.drugsIsValid, this.resultsIsValid, this.precriptionUploadDate, this.receiptUploadDate, this.drugsUploadDate, this.resultsUploadDate, this.adminFeedback, this.estimate, this.executed, this.ongoing, this.requested});

  factory UseCaseServiceModel.fromDocument(DocumentSnapshot doc){
    return UseCaseServiceModel(
      id: doc.id,
      usecaseId: doc.data()["usecaseId"],
      status: doc.data()["status"],
      title: doc.data()["title"],
      amount: doc.data()["amountToPay"] != null ? double.parse(doc.data()["amountToPay"].toString()) : null,
      advance: doc.data()["advance"],
      establishment: doc.data()["establishment"],
      adminFeedback: doc.data()["adminFeedback"],
      justifiedFees: doc.data()["justifiedFees"],
      type: doc.data()["type"],
      dateCreated: doc.data()["createdDate"],
      date: doc.data()["serviceDate"],
      precriptionUrls: doc.data()["precriptionUrls"],
      receiptUrls: doc.data()["receiptUrls"],
      drugsUrls: doc.data()["drugsUrls"],
      resultsUrls: doc.data()["resultsUrls"],
      closed: doc.data()['closed'],
      precriptionIsValid: doc.data()["precriptionIsValid"],
      receiptIsValid: doc.data()["receiptIsValid"],
      drugsIsValid: doc.data()["drugsIsValid"],
      resultsIsValid: doc.data()["resultsIsValid"],
      precriptionUploadDate: doc.data()["precriptionUploadDate"],
      receiptUploadDate: doc.data()["receiptUploadDate"],
      drugsUploadDate: doc.data()["drugsUploadDate"],
      resultsUploadDate: doc.data()["resultsUploadDate"],
      bookletUrls: doc.data()["bookletUrls"],
      otherDocUrls: doc.data()["otherDocUrls"],
      bookletIsValid: doc.data()["bookletIsValid"],
      otherDocIsValid: doc.data()["otherDocIsValid"],
      executed: doc.data()["executed"],
      estimate: doc.data()["estimated"],
      ongoing: doc.data()["ongoing"],
      requested: doc.data()["requested"]
    );
  }
}