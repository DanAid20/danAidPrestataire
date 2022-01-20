import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'adherentFacturationModel.dart';

class AdherentModel {
  String? adherentId, authId, familyDoctorId, cniName, countryName, bloodGroup, otherDocName, invitedBy, marriageCertificateName, familyName, surname, couponCodeUsed, matricule, imgUrl, gender, email, profession, regionOfOrigin, marriageCertificateUrl, otherJustificativeDocsUrl, officialDocUrl, town, profileType, address;
  Timestamp? dateCreated, validityEndDate, validityStartDate, birthDate, lastDateVisited;
  int?  points, visitPoints;
  num? insuranceLimit, adherentPlan, loanLimit;
  bool? paymentIsMobile, profileEnabled, isMarried, enable, havePaid, firstInvoice, paid, stateValidate, invited;
  var phoneList;
  List<AdherentBillModel>? adherentNewBill;
  List? visits, keywords, phoneKeywords, nameKeywords, allergies;
  Map? location;
  DoctorModel? familyDoctor;
  var height, weight;
  Map? codeConsult;

  AdherentModel({this.adherentId, this.codeConsult, this.authId, this.keywords, this.countryName, this.bloodGroup, this.invitedBy, this.insuranceLimit, this.invited, this.loanLimit, this.couponCodeUsed, this.firstInvoice, this.stateValidate, this.paid, this.havePaid, this.allergies, this.height, this.weight, this.validityStartDate, this.phoneKeywords, this.nameKeywords, this.lastDateVisited, this.visits, this.visitPoints, this.points, this.familyDoctorId, this.familyDoctor, this.cniName, this.enable, this.otherDocName, this.marriageCertificateName, this.familyName, this.surname, this.matricule, this.imgUrl, this.gender, this.email, this.profession, this.regionOfOrigin, this.marriageCertificateUrl, this.otherJustificativeDocsUrl, this.officialDocUrl, this.town, this.profileType, this.dateCreated, this.validityEndDate, this.birthDate, this.paymentIsMobile, this.profileEnabled, this.isMarried, this.phoneList, this.adherentNewBill, this.adherentPlan, this.address, this.location});

  factory AdherentModel.fromDocument(DocumentSnapshot doc) {
    return AdherentModel(
        adherentId: doc.id,
        authId: doc.get("authId"),
        keywords: doc.get("keywords"),
        familyDoctorId: doc.get("familyDoctorId"),
        insuranceLimit: doc.get("plafond"),
        loanLimit: doc.get("creditLimit"),
        cniName: doc.get("cniName"),
        visits: doc.get("visits"),
        paid: doc.get("paid"),
        havePaid: doc.get("havePaidBefore"),
        visitPoints: doc.get("visitPoints"),
        bloodGroup: doc.get("bloodGroup"),
        lastDateVisited: doc.get("lastDateVisited"),
        points: doc.get("totalPoints"),
        otherDocName: doc.get("autrePieceName"),
        marriageCertificateName: doc.get("acteMariageName"),
        familyName: doc.get("nomFamille"),
        enable: doc.get("enabled"),
        surname: doc.get("prenom"),
        matricule: doc.get("matricule"),
        imgUrl: doc.get("imageUrl"),
        gender: doc.get("genre"),
        email: doc.get("emailAdress"),
        profession: doc.get("profession"),
        adherentPlan: doc.get("protectionLevel"),
        regionOfOrigin: doc.get("regionDorigione"),
        marriageCertificateUrl: doc.get("urlActeMariage"),
        otherJustificativeDocsUrl: doc.get("urlAutrePiecesJustificatif"),
        officialDocUrl: doc.get("urlDocOficiel"),
        town: doc.get("ville"),
        profileType: doc.get("profil"),
        dateCreated: doc.get("createdDate"),
        validityEndDate: doc.get("datFinvalidite"),
        validityStartDate: doc.get("datDebutvalidite"),
        birthDate: doc.get("dateNaissance"),
        paymentIsMobile: doc.get("isRecptionPaiementMobile"),
        profileEnabled: doc.get("profilEnabled"),
        isMarried: doc.get("statuMatrimonialMarie"),
        phoneList: doc.get("phoneList"),
        adherentNewBill: doc.get("NEW_FACTURATIONS_ADHERENT"),
        address: doc.get("adresse"),
        location: doc.get("localisation"),
        phoneKeywords: doc.get("phoneKeywords"),
        firstInvoice: doc.get("firstfacturationOfUser"),
        stateValidate: doc.get("etatValider"),
        height: doc.get("height"),
        weight: doc.get("weight"),
        allergies: doc.get("allergies"),
        codeConsult: doc.get("CurrentcodeConsultation"),
        couponCodeUsed: doc.get("couponCodeUsed"),
        invited: doc.get("invited"),
        invitedBy: doc.get("invitedBy"),
        countryName: doc.get("userCountryName"),
        nameKeywords: doc.get("nameKeywords")
      );
  }

  String? get getAdherentId => adherentId;
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
