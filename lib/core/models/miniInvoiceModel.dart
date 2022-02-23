import 'package:cloud_firestore/cloud_firestore.dart';

class MiniInvoiceModel {
  final String? id, label;
  final Timestamp? startDate, endDate, paymentDate;
  final num? amount, status, number;

  MiniInvoiceModel({this.id, this.label, this.startDate, this.endDate, this.paymentDate, this.amount, this.status, this.number});

  factory MiniInvoiceModel.fromDocument(DocumentSnapshot doc, Map data){
    return MiniInvoiceModel(
      id: doc.id,
      label: data['label'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      paymentDate: data['paymentDate'],
      amount: data['amount'],
      status: data['status'],
      number: data['number']
    );
  }
}