import 'package:cloud_firestore/cloud_firestore.dart';

class PlanModel {
  final String? id, paymentMode, label;
  final num? monthlyAmount, registrationFee, coveragePercentage, maxCreditAmount, additionalFee, planNumber, annualLimit, creditRate;
  final bool? isSelected, familyDoctorIsFree, familyCoverage, canWinPoints, socialNetworkEnable;
  final Map? text;

  PlanModel({this.paymentMode, this.text, this.label, this.monthlyAmount, this.registrationFee, this.coveragePercentage, this.maxCreditAmount, this.additionalFee, this.planNumber, this.annualLimit, this.creditRate, this.isSelected, this.familyDoctorIsFree, this.familyCoverage, this.canWinPoints, this.socialNetworkEnable, this.id});

  factory PlanModel.fromDocument(DocumentSnapshot doc, Map data){
    return PlanModel(
      id: doc.id,
      monthlyAmount: data["cotisationMensuelleFondDSoint"],
      coveragePercentage: data["couverture"],
      text: data["descriptionText"],
      registrationFee: data["fraisIncription"],
      paymentMode: data["modeDePaiement"],
      maxCreditAmount: data["montantMaxPretSante"],
      additionalFee: data["montantPaiementSupplement"],
      label: data["nomNiveau"],
      planNumber: data["numeroNiveau"],
      annualLimit: data["plafondAnnuelle"],
      isSelected: data["userSelectedIt"],
      creditRate: data["rate"],
      familyDoctorIsFree: data["familyDoctorIsFree"],
      canWinPoints: data["canWinPoints"],
      familyCoverage: data["familyCoverage"],
      socialNetworkEnable: data["socialNetworkEnable"]
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