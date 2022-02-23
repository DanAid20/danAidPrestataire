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
  
  factory BeneficiaryModel.fromDocument(DocumentSnapshot doc, Map data){
    return BeneficiaryModel(
      matricule: doc.id,
      adherentId: data["adherentId"],
      familyName: data["nomDFamille"],
      surname: data["prenom"],
      cniName: data["cniName"],
      bloodGroup: data["bloodGroup"],
      otherDocName: data["autrePieceName"],
      marriageCertificateName: data["acteMariageName"],
      avatarUrl: data["urlImage"],
      gender: data["genre"],
      marriageCertificateUrl: data["urlActeMariage"],
      otherDocUrl: data["urlAutrPiece"],
      cniUrl: data["urlCNI"],
      dateCreated: data["createdDate"],
      validityEndDate: data["datFinvalidite"],
      birthDate: data["dateNaissance"],
      enabled: data["enabled"],
      livesInSameHouse: data["ifVivreMemeDemeure"],
      phoneList: data["phoneList"],
      height: data["height"],
      weight: data["weight"],
      allergies: data["allergies"],
      relationShip: data["relation"],
      otherInfo: data["infoSupplementaire"],
      birthCertificateUrl: data["urlActeNaissance"],
      protectionLevel: data["protectionLevel"],
    );
  }
}
