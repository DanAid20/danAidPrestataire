import 'package:cloud_firestore/cloud_firestore.dart';

class MiniInvoiceModel {
  final String id, label;
  final Timestamp startDate, endDate, paymentDate;
  final num amount, status, number;

  MiniInvoiceModel({this.id, this.label, this.startDate, this.endDate, this.paymentDate, this.amount, this.status, this.number});

  factory MiniInvoiceModel.fromDocument(DocumentSnapshot doc){
    return MiniInvoiceModel(
      id: doc.id,
      label: doc.data()['label'],
      startDate: doc.data()['startDate'],
      endDate: doc.data()['endDate'],
      paymentDate: doc.data()['paymentDate'],
      amount: doc.data()['amount'],
      status: doc.data()['status'],
      number: doc.data()['number']
    );
  }
}