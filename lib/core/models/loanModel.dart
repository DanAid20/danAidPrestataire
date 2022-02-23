import 'package:cloud_firestore/cloud_firestore.dart';

class LoanModel {
  String? id, carnetUrl, adherentId, otherDocUrl, avalistName, avalistPhone, employerName, employerPhone, purpose, docUrl;
  num? amount, maxAmount, mensuality, totalToPay, monthlySalary, amountPaid;
  int? duration, status;
  Timestamp? firstPaymentDate, lastPaymentDate, dateCreated, mostRecentPaymentDate;
  List? paymentDates, docsUrls;
  bool? isSalaryMan, avalistAdded; 

  LoanModel({this.avalistName, this.avalistPhone, this.docsUrls, this.amountPaid, this.employerName, this.monthlySalary, this.employerPhone, this.purpose, this.docUrl, this.mensuality, this.totalToPay, this.duration, this.status, this.firstPaymentDate, this.lastPaymentDate, this.dateCreated, this.mostRecentPaymentDate, this.paymentDates, this.isSalaryMan, this.avalistAdded, this.id, this.amount, this.maxAmount, this.adherentId, this.carnetUrl, this.otherDocUrl});

  factory LoanModel.fromDocument(DocumentSnapshot doc, Map data){
    return LoanModel(
      id: doc.id,
      amount: data["amount"],
      adherentId: data["adherentId"],
      mensuality: data["mensuality"],
      totalToPay: data["totalToPay"],
      amountPaid: data["amountPaid"],
      firstPaymentDate: data["firstPaymentDate"],
      lastPaymentDate: data["lastPaymentDate"],
      dateCreated: data["createdDate"],
      mostRecentPaymentDate: data["mostRecentPaymentDate"],
      paymentDates: data["paymentDates"],
      avalistAdded: data["avalistAdded"],
      avalistName: data["avalistName"],
      avalistPhone: data["avalistPhone"],
      monthlySalary: data["monthlySalary"],
      isSalaryMan: data["isSalaryMan"],
      employerName: data["employerName"],
      employerPhone: data["employerPhone"],
      duration: data["frequency"],
      purpose: data["purpose"],
      docUrl: data["docUrl"],
      otherDocUrl: data["otherDocUrl"],
      docsUrls: data["docsUrls"],
      status: data["status"]
    );
  }
}