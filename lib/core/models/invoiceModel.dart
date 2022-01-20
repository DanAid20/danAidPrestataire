import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceModel{
  final String? id, inscriptionId, label, trimester, type, status, invoiceNber;
  final num? amount, planNumber, segments, amountPaid, monthsPaid;
  final List? paymentDates, campaignsChosen;
  final Timestamp? dateCreated, coverageStartDate, coverageEndDate, currentPaidStartDate, currentPaidEndDate, paymentDelayDate;
  final bool? paid, stateValidate, invoiceIsSplitted, registrationPaid;

  InvoiceModel({this.label, this.inscriptionId, this.invoiceIsSplitted, this.campaignsChosen, this.registrationPaid, this.amountPaid, this.monthsPaid, this.paymentDates, this.currentPaidStartDate, this.currentPaidEndDate ,this.segments, this.trimester, this.type, this.status, this.stateValidate, this.invoiceNber, this.planNumber, this.dateCreated, this.coverageStartDate, this.coverageEndDate, this.paymentDelayDate, this.paid, this.id, this.amount});

  factory InvoiceModel.fromDocument(DocumentSnapshot doc){
    return InvoiceModel(
      id: doc.id,
      inscriptionId: doc.get("inscriptionId"),
      label: doc.get("intitule"),
      stateValidate: doc.get("etatValider"),
      trimester: doc.get("trimester"),
      type: doc.get("categoriePaiement"),
      status: doc.get("statut"),
      invoiceNber: doc.get("numeroRecu"),
      amountPaid: doc.get("montantPayee"),
      monthsPaid: doc.get("moisPayee"),
      amount: doc.get("montant"),
      planNumber: doc.get("numeroNiveau"),
      dateCreated: doc.get("createdDate"),
      coverageEndDate: doc.get("dateFinCouvertureAdherent"),
      coverageStartDate: doc.get("dateDebutCouvertureAdherent"),
      currentPaidEndDate: doc.get("currentPaidEndDate"),
      currentPaidStartDate: doc.get("currentPaidStartDate"),
      paymentDelayDate: doc.get("dateDelai"),
      paid: doc.get("paid"),
      invoiceIsSplitted: doc.get("invoiceIsSplitted"),
      paymentDates: doc.get("paymentDates"),
      segments: doc.get("segments"),
      registrationPaid: doc.get("registrationPaid"),
      campaignsChosen: doc.get("promos")
    );
  }

}