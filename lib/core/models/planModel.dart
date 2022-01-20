import 'package:cloud_firestore/cloud_firestore.dart';

class PlanModel {
  final String? id, paymentMode, label;
  final num? monthlyAmount, registrationFee, coveragePercentage, maxCreditAmount, additionalFee, planNumber, annualLimit, creditRate;
  final bool? isSelected, familyDoctorIsFree, familyCoverage, canWinPoints, socialNetworkEnable;
  final Map? text;

  PlanModel({this.paymentMode, this.text, this.label, this.monthlyAmount, this.registrationFee, this.coveragePercentage, this.maxCreditAmount, this.additionalFee, this.planNumber, this.annualLimit, this.creditRate, this.isSelected, this.familyDoctorIsFree, this.familyCoverage, this.canWinPoints, this.socialNetworkEnable, this.id});

  factory PlanModel.fromDocument(DocumentSnapshot doc){
    return PlanModel(
      id: doc.id,
      monthlyAmount: doc.get("cotisationMensuelleFondDSoint"),
      coveragePercentage: doc.get("couverture"),
      text: doc.get("descriptionText"),
      registrationFee: doc.get("fraisIncription"),
      paymentMode: doc.get("modeDePaiement"),
      maxCreditAmount: doc.get("montantMaxPretSante"),
      additionalFee: doc.get("montantPaiementSupplement"),
      label: doc.get("nomNiveau"),
      planNumber: doc.get("numeroNiveau"),
      annualLimit: doc.get("plafondAnnuelle"),
      isSelected: doc.get("userSelectedIt"),
      creditRate: doc.get("rate"),
      familyDoctorIsFree: doc.get("familyDoctorIsFree"),
      canWinPoints: doc.get("canWinPoints"),
      familyCoverage: doc.get("familyCoverage"),
      socialNetworkEnable: doc.get("socialNetworkEnable")
    );
  }
}

  /** 
    "descriptionText": {
      "textCotisation" : "0 fcfa/mois/famille",
      "textPeriodeTypePaiement" : "Jamais",
      "textSuivi" : "Medecin de famille",
      "titreNiveau" : "Niveau 0: Découverte"
    },
  */