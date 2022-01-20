import 'package:cloud_firestore/cloud_firestore.dart';

class MensualityModel {
  String id, loanId;
  num amount, number, status;
  Timestamp startDate, endDate, paymentDate;

  MensualityModel({this.status, this.id, this.amount, this.startDate, this.endDate, this.paymentDate, this.loanId, this.number});

  factory MensualityModel.fromDocument(DocumentSnapshot doc){
    return MensualityModel(
      id: doc.id,
      amount: doc.get("amount"),
      loanId: doc.get("loanId"),
      number: doc.get("number"),
      startDate: doc.get("startDate"),
      endDate: doc.get("endDate"),
      paymentDate: doc.get("paymentDate"),
      status: doc.get("status")
    );
  }
}