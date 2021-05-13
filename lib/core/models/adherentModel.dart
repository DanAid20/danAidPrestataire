import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'adherentFacturationModel.dart';

class AdherentModel {
  String adherentId, authId, familyDoctorId, cniName, otherDocName, marriageCertificateName, familyName, surname, matricule, imgUrl, gender, email, profession, regionOfOrigin, marriageCertificateUrl, otherJustificativeDocsUrl, officialDocUrl, town, profileType, address;
  Timestamp dateCreated, validityEndDate, birthDate, lastDateVisited;
  int adherentPlan, points, visitPoints;
  bool paymentIsMobile, profileEnabled, isMarried, enable;
  var phoneList;
  List<AdherentBillModel> adherentNewBill;
  List visits, keywords, phoneKeywords, nameKeywords;
  Map location;
  DoctorModel familyDoctor;

  AdherentModel({this.adherentId, this.authId, this.keywords, this.phoneKeywords, this.nameKeywords, this.lastDateVisited, this.visits, this.visitPoints, this.points, this.familyDoctorId, this.familyDoctor, this.cniName, this.enable, this.otherDocName, this.marriageCertificateName, this.familyName, this.surname, this.matricule, this.imgUrl, this.gender, this.email, this.profession, this.regionOfOrigin, this.marriageCertificateUrl, this.otherJustificativeDocsUrl, this.officialDocUrl, this.town, this.profileType, this.dateCreated, this.validityEndDate, this.birthDate, this.paymentIsMobile, this.profileEnabled, this.isMarried, this.phoneList, this.adherentNewBill, this.adherentPlan, this.address, this.location});

  factory AdherentModel.fromDocument(DocumentSnapshot doc) {
    return AdherentModel(
        adherentId: doc.id,
        authId: doc.data()["authId"],
        keywords: doc.data()["keywords"],
        familyDoctorId: doc.data()["familyDoctorId"],
        cniName: doc.data()["cniName"],
        visits: doc.data()["visits"],
        visitPoints: doc.data()["visitPoints"],
        lastDateVisited: doc.data()["lastDateVisited"],
        points: doc.data()["totalPoints"],
        otherDocName: doc.data()["autrePieceName"],
        marriageCertificateName: doc.data()["acteMariageName"],
        familyName: doc.data()["nomFamille"],
        enable: doc.data()["enabled"],
        surname: doc.data()["prenom"],
        matricule: doc.data()["matricule"],
        imgUrl: doc.data()["imageUrl"],
        gender: doc.data()["genre"],
        email: doc.data()["emailAdress"],
        profession: doc.data()["profession"],
        adherentPlan: doc.data()["protectionLevel"],
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
        address: doc.data()["adresse"],
        location: doc.data()["localisation"],
        phoneKeywords: doc.data()["phoneKeywords"],
        nameKeywords: doc.data()["nameKeywords"]
      );
  }

  String get getAdherentId => adherentId;
/*
  String get getCniName => cniName;
  String get getOtherDocName => otherDocName;
  String get getMarriageCertificateName => marriageCertificateName;
  String get getFamilyName => familyName;
  String get getSurname => surname;
  String get getMatricule => matricule;
  String get getImgUrl => imgUrl;
  String get getGender => gender;
  String get getEmail => email;
  String get getProfession => profession;
  String get getRegionOfOrigin => regionOfOrigin;
  String get getMarriageCertificateUrl => marriageCertificateUrl;
  String get getOtherJustificativeDocsUrl => otherJustificativeDocsUrl;
  String get getOfficialDocUrl => officialDocUrl;
  String get getTown => town;
  String get getProfileType => profileType;
  int get getAdherentPlan => adherentPlan;
  Timestamp get getDateCreated => dateCreated;
  Timestamp get getValidityEndDate => validityEndDate;
  Timestamp get getBirthDate => birthDate;
  bool get isPaymentMobile => paymentIsMobile;
  bool get isProfileEnabled => profileEnabled;
  bool get getMarriageState => isMarried;
  List<Map> get getPhoneList => phoneList;
  List<AdherentBillModel> get getAdherentNewBill => adherentNewBill;*/

  void setAdherentId(String val) {
    this.adherentId = val;
  }
}
