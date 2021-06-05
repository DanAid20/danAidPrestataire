import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceModel{
  final String id, inscriptionId, label, trimester, type, status, invoiceNber;
  final num amount, planNumber;
  final Timestamp dateCreated, coverageStartDate, coverageEndDate, paymentDelayDate;
  final bool paid, stateValidate;

  InvoiceModel({this.label, this.inscriptionId, this.trimester, this.type, this.status, this.stateValidate, this.invoiceNber, this.planNumber, this.dateCreated, this.coverageStartDate, this.coverageEndDate, this.paymentDelayDate, this.paid, this.id, this.amount});

  factory InvoiceModel.fromDocument(DocumentSnapshot doc){
    return InvoiceModel(
      id: doc.id,
      inscriptionId: doc.data()["inscriptionId"],
      label: doc.data()["intitule"],
      stateValidate: doc.data()["etatValider"],
      trimester: doc.data()["trimester"],
      type: doc.data()["categoriePaiement"],
      status: doc.data()["statut"],
      invoiceNber: doc.data()["numeroRecu"],
      amount: doc.data()["montant"],
      planNumber: doc.data()["numeroNiveau"],
      dateCreated: doc.data()["createdDate"],
      coverageEndDate: doc.data()["dateFinCouvertureAdherent"],
      coverageStartDate: doc.data()["dateDebutCouvertureAdherent"],
      paymentDelayDate: doc.data()["dateDelai"],
      paid: doc.data()["paid"],
    );
  }

}