import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceModel{
  final String? id, inscriptionId, label, trimester, type, status, invoiceNber;
  final num? amount, planNumber, segments, amountPaid, monthsPaid;
  final List? paymentDates, campaignsChosen;
  final Timestamp? dateCreated, coverageStartDate, coverageEndDate, currentPaidStartDate, currentPaidEndDate, paymentDelayDate;
  final bool? paid, stateValidate, invoiceIsSplitted, registrationPaid;

  InvoiceModel({this.label, this.inscriptionId, this.invoiceIsSplitted, this.campaignsChosen, this.registrationPaid, this.amountPaid, this.monthsPaid, this.paymentDates, this.currentPaidStartDate, this.currentPaidEndDate ,this.segments, this.trimester, this.type, this.status, this.stateValidate, this.invoiceNber, this.planNumber, this.dateCreated, this.coverageStartDate, this.coverageEndDate, this.paymentDelayDate, this.paid, this.id, this.amount});

  factory InvoiceModel.fromDocument(DocumentSnapshot doc, Map data){
    return InvoiceModel(
      id: doc.id,
      inscriptionId: data["inscriptionId"],
      label: data["intitule"],
      stateValidate: data["etatValider"],
      trimester: data["trimester"],
      type: data["categoriePaiement"],
      status: data["statut"],
      invoiceNber: data["numeroRecu"],
      amountPaid: data["montantPayee"],
      monthsPaid: data["moisPayee"],
      amount: data["montant"],
      planNumber: data["numeroNiveau"],
      dateCreated: data["createdDate"],
      coverageEndDate: data["dateFinCouvertureAdherent"],
      coverageStartDate: data["dateDebutCouvertureAdherent"],
      currentPaidEndDate: data["currentPaidEndDate"],
      currentPaidStartDate: data["currentPaidStartDate"],
      paymentDelayDate: data["dateDelai"],
      paid: data["paid"],
      invoiceIsSplitted: data["invoiceIsSplitted"],
      paymentDates: data["paymentDates"],
      segments: data["segments"],
      registrationPaid: data["registrationPaid"],
      campaignsChosen: data["promos"]
    );
  }

}