import 'package:cloud_firestore/cloud_firestore.dart';

class BeneficiaryModel{

  String? matricule, marriageCertificateName, adherentId, otherDocName, surname, familyName, cniName, gender, otherInfo, relationShip, cniUrl, marriageCertificateUrl, otherDocUrl, birthCertificateUrl, avatarUrl, bloodGroup;
  bool? enabled, livesInSameHouse;
  Timestamp? dateCreated, validityEndDate, birthDate;
  List? phoneList;
  int? protectionLevel;
  List? allergies;
  var height, weight;

  BeneficiaryModel({this.matricule, this.protectionLevel, this.otherDocName, this.marriageCertificateName, this.adherentId, this.surname, this.familyName, this.cniName, this.gender, this.otherInfo, this.relationShip, this.cniUrl, this.marriageCertificateUrl, this.otherDocUrl, this.birthCertificateUrl, this.avatarUrl, this.bloodGroup, this.enabled, this.livesInSameHouse, this.dateCreated, this.validityEndDate, this.birthDate, this.phoneList, this.allergies, this.height, this.weight});
  
  factory BeneficiaryModel.fromDocument(DocumentSnapshot doc){
    return BeneficiaryModel(
      matricule: doc.id,
      adherentId: doc.get("adherentId"),
      familyName: doc.get("nomDFamille"),
      surname: doc.get("prenom"),
      cniName: doc.get("cniName"),
      bloodGroup: doc.get("bloodGroup"),
      otherDocName: doc.get("autrePieceName"),
      marriageCertificateName: doc.get("acteMariageName"),
      avatarUrl: doc.get("urlImage"),
      gender: doc.get("genre"),
      marriageCertificateUrl: doc.get("urlActeMariage"),
      otherDocUrl: doc.get("urlAutrPiece"),
      cniUrl: doc.get("urlCNI"),
      dateCreated: doc.get("createdDate"),
      validityEndDate: doc.get("datFinvalidite"),
      birthDate: doc.get("dateNaissance"),
      enabled: doc.get("enabled"),
      livesInSameHouse: doc.get("ifVivreMemeDemeure"),
      phoneList: doc.get("phoneList"),
      height: doc.get("height"),
      weight: doc.get("weight"),
      allergies: doc.get("allergies"),
      relationShip: doc.get("relation"),
      otherInfo: doc.get("infoSupplementaire"),
      birthCertificateUrl: doc.get("urlActeNaissance"),
      protectionLevel: doc.get("protectionLevel"),
    );
  }
}
