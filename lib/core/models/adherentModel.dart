import 'package:cloud_firestore/cloud_firestore.dart';
import 'adherentFacturationModel.dart';

class AdherentModel {
  final String adherentId, cniName, otherDocName, marriageCertificateName, familyName, surname, matricule, imgUrl, gender, email, profession, regionOfOrigin, marriageCertificateUrl, otherJustificativeDocsUrl, officialDocUrl, town, profileType;
  final DateTime dateCreated, validityEndDate, birthDate;
  final bool paymentIsMobile, profileEnabled, isMarried;
  final List<Map> phoneList;
  final List<AdherentBillModel> adherentNewBill;

  AdherentModel({this.adherentId, this.cniName, this.otherDocName, this.marriageCertificateName, this.familyName, this.surname, this.matricule, this.imgUrl, this.gender, this.email, this.profession, this.regionOfOrigin, this.marriageCertificateUrl, this.otherJustificativeDocsUrl, this.officialDocUrl, this.town, this.profileType, this.dateCreated, this.validityEndDate, this.birthDate, this.paymentIsMobile, this.profileEnabled, this.isMarried, this.phoneList, this.adherentNewBill});

  factory AdherentModel.fromDocument(DocumentSnapshot doc){
    return AdherentModel(
      adherentId: doc.id,
      cniName: doc.data()["cniName"],
      otherDocName: doc.data()["autrePieceName"],
      marriageCertificateName: doc.data()["acteMariageName"],
      familyName: doc.data()["nomFamille"],
      surname: doc.data()["prenom"],
      matricule: doc.data()["matricule"],
      imgUrl: doc.data()["imageUrl"],
      gender: doc.data()["genre"],
      email: doc.data()["emailAdress"],
      profession: doc.data()["profession"],
      regionOfOrigin: doc.data()["regionDorigione"],
      marriageCertificateUrl: doc.data()["urlActeMariage"],
      otherJustificativeDocsUrl: doc.data()["urlAutrePiecesJustificatif"],
      officialDocUrl: doc.data()["urlDocOficiel"],
      town: doc.data()["ville"],
      profileType: doc.data()["profil"],
      dateCreated: doc.data()["createdDate"],
      validityEndDate: doc.data()["datFinvalidite"],
      birthDate: doc.data()["dateNaissance"],
      paymentIsMobile: doc.data()["isRecptionPaiementMobile"],
      profileEnabled: doc.data()["profilEnabled"],
      isMarried: doc.data()["statuMatrimonialMarie"],
      phoneList: doc.data()["phoneList"],
      adherentNewBill: doc.data()["NEW_FACTURATIONS_ADHERENT"],
    );
  }
}