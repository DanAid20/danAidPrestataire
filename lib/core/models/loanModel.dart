import 'package:cloud_firestore/cloud_firestore.dart';

class LoanModel {
  String id, carnetUrl, adherentId, otherDocUrl, avalistName, avalistPhone, employerName, employerPhone, purpose, docUrl;
  num amount, maxAmount, mensuality, totalToPay, monthlySalary, amountPaid;
  int duration, status;
  Timestamp firstPaymentDate, lastPaymentDate, dateCreated, mostRecentPaymentDate;
  List paymentDates, docsUrls;
  bool isSalaryMan, avalistAdded; 

  LoanModel({this.avalistName, this.avalistPhone, this.docsUrls, this.amountPaid, this.employerName, this.monthlySalary, this.employerPhone, this.purpose, this.docUrl, this.mensuality, this.totalToPay, this.duration, this.status, this.firstPaymentDate, this.lastPaymentDate, this.dateCreated, this.mostRecentPaymentDate, this.paymentDates, this.isSalaryMan, this.avalistAdded, this.id, this.amount, this.maxAmount, this.adherentId, this.carnetUrl, this.otherDocUrl});

  factory LoanModel.fromDocument(DocumentSnapshot doc){
    return LoanModel(
      id: doc.id,
      amount: doc.data()["amount"],
      adherentId: doc.data()["adherentId"],
      mensuality: doc.data()["mensuality"],
      totalToPay: doc.data()["totalToPay"],
      amountPaid: doc.data()["amountPaid"],
      firstPaymentDate: doc.data()["firstPaymentDate"],
      lastPaymentDate: doc.data()["lastPaymentDate"],
      dateCreated: doc.data()["createdDate"],
      mostRecentPaymentDate: doc.data()["mostRecentPaymentDate"],
      paymentDates: doc.data()["paymentDates"],
      avalistAdded: doc.data()["avalistAdded"],
      avalistName: doc.data()["avalistName"],
      avalistPhone: doc.data()["avalistPhone"],
      monthlySalary: doc.data()["monthlySalary"],
      isSalaryMan: doc.data()["isSalaryMan"],
      employerName: doc.data()["employerName"],
      employerPhone: doc.data()["employerPhone"],
      duration: doc.data()["frequency"],
      purpose: doc.data()["purpose"],
      docUrl: doc.data()["docUrl"],
      otherDocUrl: doc.data()["otherDocUrl"],
      docsUrls: doc.data()["docsUrls"],
      status: doc.data()["status"]
    );
  }
}