import 'package:cloud_firestore/cloud_firestore.dart';

class MensualityModel {
  String? id, loanId;
  num? amount, number, status;
  Timestamp? startDate, endDate, paymentDate;

  MensualityModel({this.status, this.id, this.amount, this.startDate, this.endDate, this.paymentDate, this.loanId, this.number});

  factory MensualityModel.fromDocument(DocumentSnapshot doc, Map data){
    return MensualityModel(
      id: doc.id,
      amount: data["amount"],
      loanId: data["loanId"],
      number: data["number"],
      startDate: data["startDate"],
      endDate: data["endDate"],
      paymentDate: data["paymentDate"],
      status: data["status"]
    );
  }
}