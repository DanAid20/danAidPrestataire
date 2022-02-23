import 'package:cloud_firestore/cloud_firestore.dart';

class AdherentBillModel {
  
  final String? billId, adherentId, paymentCategory, title, receivedNumber;
  final DateTime? dateCreated, startCoverageDate, endCoverageDate, paymentSettlementDate;
  final bool? validated;
  final num? amount, nbPersonSupplement, billTrimesterNber;
  final Map<String, dynamic>? contributionLevel;

  AdherentBillModel({this.billId, this.adherentId, this.paymentCategory, this.title, this.receivedNumber, this.dateCreated, this.startCoverageDate, this.endCoverageDate, this.paymentSettlementDate, this.validated, this.amount, this.nbPersonSupplement, this.billTrimesterNber, this.contributionLevel});

  factory AdherentBillModel.fromDocument(DocumentSnapshot doc, Map data){
    return AdherentBillModel(
      billId: doc.id,
      adherentId: data["idAdherent"],
      paymentCategory: data["categoriePaiement"],
      title: data["intitule"],
      receivedNumber: data["numeroRecu"],
      dateCreated: data["createdDate"],
      startCoverageDate: data["dateDebutCouvertureAdherent"],
      endCoverageDate: data["dateFinCouvertureAdherent"],
      paymentSettlementDate: data["dateReglementDuPaiement"],
      validated: data["etatValider"],
      amount: data["montant"],
      nbPersonSupplement: data["nbPersonneSupplement"],
      billTrimesterNber: data["numeroTrimestrielleFacture"],
      contributionLevel: data["niveauCotisation"],
    );
  }

}