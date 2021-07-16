import 'package:cloud_firestore/cloud_firestore.dart';

class MensualityModel {
  String id, loanId;
  num amount, number, status;
  Timestamp startDate, endDate, paymentDate;

  MensualityModel({this.status, this.id, this.amount, this.startDate, this.endDate, this.paymentDate, this.loanId, this.number});

  factory MensualityModel.fromDocument(DocumentSnapshot doc){
    return MensualityModel(
      id: doc.id,
      amount: doc.data()["amount"],
      loanId: doc.data()["loanId"],
      number: doc.data()["number"],
      startDate: doc.data()["startDate"],
      endDate: doc.data()["endDate"],
      paymentDate: doc.data()["paymentDate"],
      status: doc.data()["status"]
    );
  }
}