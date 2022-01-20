import 'package:cloud_firestore/cloud_firestore.dart';

class LoanModel {
  String? id, carnetUrl, adherentId, otherDocUrl, avalistName, avalistPhone, employerName, employerPhone, purpose, docUrl;
  num? amount, maxAmount, mensuality, totalToPay, monthlySalary, amountPaid;
  int? duration, status;
  Timestamp? firstPaymentDate, lastPaymentDate, dateCreated, mostRecentPaymentDate;
  List? paymentDates, docsUrls;
  bool? isSalaryMan, avalistAdded; 

  LoanModel({this.avalistName, this.avalistPhone, this.docsUrls, this.amountPaid, this.employerName, this.monthlySalary, this.employerPhone, this.purpose, this.docUrl, this.mensuality, this.totalToPay, this.duration, this.status, this.firstPaymentDate, this.lastPaymentDate, this.dateCreated, this.mostRecentPaymentDate, this.paymentDates, this.isSalaryMan, this.avalistAdded, this.id, this.amount, this.maxAmount, this.adherentId, this.carnetUrl, this.otherDocUrl});

  factory LoanModel.fromDocument(DocumentSnapshot doc){
    return LoanModel(
      id: doc.id,
      amount: doc.get("amount"),
      adherentId: doc.get("adherentId"),
      mensuality: doc.get("mensuality"),
      totalToPay: doc.get("totalToPay"),
      amountPaid: doc.get("amountPaid"),
      firstPaymentDate: doc.get("firstPaymentDate"),
      lastPaymentDate: doc.get("lastPaymentDate"),
      dateCreated: doc.get("createdDate"),
      mostRecentPaymentDate: doc.get("mostRecentPaymentDate"),
      paymentDates: doc.get("paymentDates"),
      avalistAdded: doc.get("avalistAdded"),
      avalistName: doc.get("avalistName"),
      avalistPhone: doc.get("avalistPhone"),
      monthlySalary: doc.get("monthlySalary"),
      isSalaryMan: doc.get("isSalaryMan"),
      employerName: doc.get("employerName"),
      employerPhone: doc.get("employerPhone"),
      duration: doc.get("frequency"),
      purpose: doc.get("purpose"),
      docUrl: doc.get("docUrl"),
      otherDocUrl: doc.get("otherDocUrl"),
      docsUrls: doc.get("docsUrls"),
      status: doc.get("status")
    );
  }
}