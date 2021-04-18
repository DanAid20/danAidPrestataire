import 'package:cloud_firestore/cloud_firestore.dart';

class BeneficiaryModel{

  String matricule, marriageCertificateName, adherentId, otherDocName, surname, familyName, cniName, gender, otherInfo, relationShip, cniUrl, marriageCertificateUrl, otherDocUrl, birthCertificateUrl, avatarUrl, bloodGroup;
  bool enabled, livesInSameHouse;
  Timestamp dateCreated, validityEndDate, birthDate;
  Map phoneList;
  List allergies;
  double height, weight;

  BeneficiaryModel({this.matricule, this.otherDocName, this.marriageCertificateName, this.adherentId, this.surname, this.familyName, this.cniName, this.gender, this.otherInfo, this.relationShip, this.cniUrl, this.marriageCertificateUrl, this.otherDocUrl, this.birthCertificateUrl, this.avatarUrl, this.bloodGroup, this.enabled, this.livesInSameHouse, this.dateCreated, this.validityEndDate, this.birthDate, this.phoneList, this.allergies, this.height, this.weight});
  
  factory BeneficiaryModel.fromDocument(DocumentSnapshot doc){
    return BeneficiaryModel(
      matricule: doc.id,
      adherentId: doc.data()["adherentId"],
      familyName: doc.data()["nomDFamille"],
      surname: doc.data()["prenom"],
      cniName: doc.data()["cniName"],
      bloodGroup: doc.data()["bloodGroup"],
      otherDocName: doc.data()["autrePieceName"],
      marriageCertificateName: doc.data()["acteMariageName"],
      avatarUrl: doc.data()["urlImage"],
      gender: doc.data()["genre"],
      marriageCertificateUrl: doc.data()["urlActeMariage"],
      otherDocUrl: doc.data()["urlAutrPiece"],
      cniUrl: doc.data()["urlCNI"],
      dateCreated: doc.data()["createdDate"],
      validityEndDate: doc.data()["datFinvalidite"],
      birthDate: doc.data()["dateNaissance"],
      enabled: doc.data()["enabled"],
      livesInSameHouse: doc.data()["ifVivreMemeDemeure"],
      phoneList: doc.data()["phoneList"],
      height: doc.data()["height"],
      weight: doc.data()["weight"],
      allergies: doc.data()["allergies"],
      relationShip: doc.data()["relation"],
      otherInfo: doc.data()["infoSupplementaire"],
    );
  }
}
