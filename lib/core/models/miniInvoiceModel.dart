import 'package:cloud_firestore/cloud_firestore.dart';

class MiniInvoiceModel {
  final String id, label;
  final Timestamp startDate, endDate, paymentDate;
  final num amount, status, number;

  MiniInvoiceModel({this.id, this.label, this.startDate, this.endDate, this.paymentDate, this.amount, this.status, this.number});

  factory MiniInvoiceModel.fromDocument(DocumentSnapshot doc){
    return MiniInvoiceModel(
      id: doc.id,
      label: doc.get('label'),
      startDate: doc.get('startDate'),
      endDate: doc.get('endDate'),
      paymentDate: doc.get('paymentDate'),
      amount: doc.get('amount'),
      status: doc.get('status'),
      number: doc.get('number')
    );
  }
}