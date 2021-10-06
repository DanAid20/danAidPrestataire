import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceModel{
  final String id, inscriptionId, label, trimester, type, status, invoiceNber;
  final num amount, planNumber, segments, amountPaid, monthsPaid;
  final List paymentDates, campaignsChosen;
  final Timestamp dateCreated, coverageStartDate, coverageEndDate, currentPaidStartDate, currentPaidEndDate, paymentDelayDate;
  final bool paid, stateValidate, invoiceIsSplitted, registrationPaid;

  InvoiceModel({this.label, this.inscriptionId, this.invoiceIsSplitted, this.campaignsChosen, this.registrationPaid, this.amountPaid, this.monthsPaid, this.paymentDates, this.currentPaidStartDate, this.currentPaidEndDate ,this.segments, this.trimester, this.type, this.status, this.stateValidate, this.invoiceNber, this.planNumber, this.dateCreated, this.coverageStartDate, this.coverageEndDate, this.paymentDelayDate, this.paid, this.id, this.amount});

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
      amountPaid: doc.data()["montantPayee"],
      monthsPaid: doc.data()["moisPayee"],
      amount: doc.data()["montant"],
      planNumber: doc.data()["numeroNiveau"],
      dateCreated: doc.data()["createdDate"],
      coverageEndDate: doc.data()["dateFinCouvertureAdherent"],
      coverageStartDate: doc.data()["dateDebutCouvertureAdherent"],
      currentPaidEndDate: doc.data()["currentPaidEndDate"],
      currentPaidStartDate: doc.data()["currentPaidStartDate"],
      paymentDelayDate: doc.data()["dateDelai"],
      paid: doc.data()["paid"],
      invoiceIsSplitted: doc.data()["invoiceIsSplitted"],
      paymentDates: doc.data()["paymentDates"],
      segments: doc.data()["segments"],
      registrationPaid: doc.data()["registrationPaid"],
      campaignsChosen: doc.data()["promos"]
    );
  }

}