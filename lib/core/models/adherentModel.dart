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

  factory AdherentModel.fromDocument(DocumentSnapshot doc, Map data) {
    return AdherentModel(
        adherentId: doc.id,
        authId: data["authId"],
        keywords: data["keywords"],
        familyDoctorId: data["familyDoctorId"],
        insuranceLimit: data["plafond"],
        loanLimit: data["creditLimit"],
        cniName: data["cniName"],
        visits: data["visits"],
        paid: data["paid"],
        havePaid: data["havePaidBefore"],
        visitPoints: data["visitPoints"],
        bloodGroup: data["bloodGroup"],
        lastDateVisited: data["lastDateVisited"],
        points: data["totalPoints"],
        otherDocName: data["autrePieceName"],
        marriageCertificateName: data["acteMariageName"],
        familyName: data["nomFamille"],
        enable: data["enabled"],
        surname: data["prenom"],
        matricule: data["matricule"],
        imgUrl: data["imageUrl"],
        gender: data["genre"],
        email: data["emailAdress"],
        profession: data["profession"],
        adherentPlan: data["protectionLevel"],
        regionOfOrigin: data["regionDorigione"],
        marriageCertificateUrl: data["urlActeMariage"],
        otherJustificativeDocsUrl: data["urlAutrePiecesJustificatif"],
        officialDocUrl: data["urlDocOficiel"],
        town: data["ville"],
        profileType: data["profil"],
        dateCreated: data["createdDate"],
        validityEndDate: data["datFinvalidite"],
        validityStartDate: data["datDebutvalidite"],
        birthDate: data["dateNaissance"],
        paymentIsMobile: data["isRecptionPaiementMobile"],
        profileEnabled: data["profilEnabled"],
        isMarried: data["statuMatrimonialMarie"],
        phoneList: data["phoneList"],
        adherentNewBill: data["NEW_FACTURATIONS_ADHERENT"],
        address: data["adresse"],
        location: data["localisation"],
        phoneKeywords: data["phoneKeywords"],
        firstInvoice: data["firstfacturationOfUser"],
        stateValidate: data["etatValider"],
        height: data["height"],
        weight: data["weight"],
        allergies: data["allergies"],
        codeConsult: data["CurrentcodeConsultation"],
        couponCodeUsed: data["couponCodeUsed"],
        invited: data["invited"],
        invitedBy: data["invitedBy"],
        countryName: data["userCountryName"],
        nameKeywords: data["nameKeywords"]
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
