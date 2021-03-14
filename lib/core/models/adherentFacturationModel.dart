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
      adherentId: doc.data()["idAdherent"],
      paymentCategory: doc.data()["categoriePaiement"],
      title: doc.data()["intitule"],
      receivedNumber: doc.data()["numeroRecu"],
      dateCreated: doc.data()["createdDate"],
      startCoverageDate: doc.data()["dateDebutCouvertureAdherent"],
      endCoverageDate: doc.data()["dateFinCouvertureAdherent"],
      paymentSettlementDate: doc.data()["dateReglementDuPaiement"],
      validated: doc.data()["etatValider"],
      amount: doc.data()["montant"],
      nbPersonSupplement: doc.data()["nbPersonneSupplement"],
      billTrimesterNber: doc.data()["numeroTrimestrielleFacture"],
      contributionLevel: doc.data()["niveauCotisation"],
    );
  }

}