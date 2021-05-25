import 'package:cloud_firestore/cloud_firestore.dart';

class LoanModel {
  String id;
  num amount, maxAmount;

  LoanModel({this.id, this.amount, this.maxAmount});

  factory LoanModel.fromDocument(DocumentSnapshot doc){
    return LoanModel(
      id: doc.id,
      amount: doc.data()["amount"],
    );
  }
}