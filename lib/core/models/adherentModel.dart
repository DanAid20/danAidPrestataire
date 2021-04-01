import 'package:cloud_firestore/cloud_firestore.dart';
import 'adherentFacturationModel.dart';

class AdherentModel {
  String adherentId, cniName, otherDocName, marriageCertificateName, familyName, surname, matricule, imgUrl, gender, email, profession, regionOfOrigin, marriageCertificateUrl, otherJustificativeDocsUrl, officialDocUrl, town, profileType, address;
  Timestamp dateCreated, validityEndDate, birthDate;
  int adherentPlan;
  bool paymentIsMobile, profileEnabled, isMarried;
  var phoneList;
  List<AdherentBillModel> adherentNewBill;
  Map location;

  AdherentModel({this.adherentId, this.cniName, this.otherDocName, this.marriageCertificateName, this.familyName, this.surname, this.matricule, this.imgUrl, this.gender, this.email, this.profession, this.regionOfOrigin, this.marriageCertificateUrl, this.otherJustificativeDocsUrl, this.officialDocUrl, this.town, this.profileType, this.dateCreated, this.validityEndDate, this.birthDate, this.paymentIsMobile, this.profileEnabled, this.isMarried, this.phoneList, this.adherentNewBill, this.adherentPlan, this.address, this.location});

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
      location: doc.data()["localisation"]
    );
  }

  String get getAdherentId => adherentId;
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
  List<AdherentBillModel> get getAdherentNewBill => adherentNewBill;

  void setAdherentId(String val){
    this.adherentId = val;
  }
  /*
  void setCniName(String val){
    _cniName = val;
    notifyListeners();
  }

  void setOtherDocName(String val){
    _otherDocName = val;
    notifyListeners();
  }

  void setMarriageCertificateName(String val){
    _marriageCertificateName = val;
    notifyListeners();
  }

  void setFamilyName(String val){
    _familyName = val;
    notifyListeners();
  }

  void setSurname(String val){
    _surname = val;
    notifyListeners();
  }

  void setMatricule(String val){
    _matricule = val;
    notifyListeners();
  }

  void setImgUrl(String val){
    _imgUrl = val;
    notifyListeners();
  }

  void setGender(String val){
    _gender = val;
    notifyListeners();
  }

  void setEmail(String val){
    _email = val;
    notifyListeners();
  }

  void setProfession(String val){
    _profession = val;
    notifyListeners();
  }

  void setRegionOfOrigin(String val){
    _regionOfOrigin = val;
    notifyListeners();
  }

  void setMarriageCertificateUrl(String val){
    _marriageCertificateUrl = val;
    notifyListeners();
  }

  void setOtherJustificativeDocsUrl(String val){
    _otherJustificativeDocsUrl = val;
    notifyListeners();
  }

  void setOfficialDocUrl(String val){
    _officialDocUrl = val;
    notifyListeners();
  }

  void setTown(String val){
    _town = val;
    notifyListeners();
  }

  void setAdherentPlan(int val){
    _adherentPlan = val;
    notifyListeners();
  }

  void setProfileType(String val){
    _profileType = val;
    notifyListeners();
  }

  void setDateCreated(DateTime val){
    _dateCreated = val;
    notifyListeners();
  }

  void setValidityEndDate(DateTime val){
    _validityEndDate = val;
    notifyListeners();
  }

  void setBirthDate(DateTime val){
    _birthDate = val;
    notifyListeners();
  }

  void setProfileEnableState(bool val){
    _profileEnabled = val;
    notifyListeners();
  }

  void setMatrimonialStatus(bool val){
    _isMarried = val;
    notifyListeners();
  }

  void addPhone(String number, String mobileOperator, bool receivePayment) {
    
    Map newPhone = {
      "number": number,
      "operator": mobileOperator,
      "receptionPayement": receivePayment
    };

    _phoneList.add(newPhone);

    notifyListeners();
  }

  void addNewAdherentBill(AdherentBillModel val){
    _adherentNewBill.add(val);
    notifyListeners();
  }*/
}