import 'package:cloud_firestore/cloud_firestore.dart';

class PlanModel {
  final String id, paymentMode, label;
  final num monthlyAmount, registrationFee, coveragePercentage, maxCreditAmount, additionalFee, planNumber, annualLimit, creditRate;
  final bool isSelected, familyDoctorIsFree, familyCoverage, canWinPoints, socialNetworkEnable;
  final Map text;

  PlanModel({this.paymentMode, this.text, this.label, this.monthlyAmount, this.registrationFee, this.coveragePercentage, this.maxCreditAmount, this.additionalFee, this.planNumber, this.annualLimit, this.creditRate, this.isSelected, this.familyDoctorIsFree, this.familyCoverage, this.canWinPoints, this.socialNetworkEnable, this.id});

  factory PlanModel.fromDocument(DocumentSnapshot doc){
    return PlanModel(
      id: doc.id,
      monthlyAmount: doc.data()["cotisationMensuelleFondDSoint"],
      coveragePercentage: doc.data()["couverture"],
      text: doc.data()["descriptionText"],
      registrationFee: doc.data()["fraisIncription"],
      paymentMode: doc.data()["modeDePaiement"],
      maxCreditAmount: doc.data()["montantMaxPretSante"],
      additionalFee: doc.data()["montantPaiementSupplement"],
      label: doc.data()["nomNiveau"],
      planNumber: doc.data()["numeroNiveau"],
      annualLimit: doc.data()["plafondAnnuelle"],
      isSelected: doc.data()["userSelectedIt"],
      creditRate: doc.data()["rate"],
      familyDoctorIsFree: doc.data()["familyDoctorIsFree"],
      canWinPoints: doc.data()["canWinPoints"],
      familyCoverage: doc.data()["familyCoverage"],
      socialNetworkEnable: doc.data()["socialNetworkEnable"]
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