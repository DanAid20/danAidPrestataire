import 'package:cloud_firestore/cloud_firestore.dart';

class AdherentBillModel {
  
  final String billId, adherentId, paymentCategory, title, receivedNumber;
  final DateTime dateCreated, startCoverageDate, endCoverageDate, paymentSettlementDate;
  final bool validated;
  final num amount, nbPersonSupplement, billTrimesterNber;
  final Map<String, dynamic> contributionLevel;

  AdherentBillModel({this.billId, this.adherentId, this.paymentCategory, this.title, this.receivedNumber, this.dateCreated, this.startCoverageDate, this.endCoverageDate, this.paymentSettlementDate, this.validated, this.amount, this.nbPersonSupplement, this.billTrimesterNber, this.contributionLevel});

  factory AdherentBillModel.fromDocument(DocumentSnapshot doc){
    return AdherentBillModel(
      billId: doc.id,
      adherentId: doc.get("idAdherent"),
      paymentCategory: doc.get("categoriePaiement"),
      title: doc.get("intitule"),
      receivedNumber: doc.get("numeroRecu"),
      dateCreated: doc.get("createdDate"),
      startCoverageDate: doc.get("dateDebutCouvertureAdherent"),
      endCoverageDate: doc.get("dateFinCouvertureAdherent"),
      paymentSettlementDate: doc.get("dateReglementDuPaiement"),
      validated: doc.get("etatValider"),
      amount: doc.get("montant"),
      nbPersonSupplement: doc.get("nbPersonneSupplement"),
      billTrimesterNber: doc.get("numeroTrimestrielleFacture"),
      contributionLevel: doc.get("niveauCotisation"),
    );
  }

}