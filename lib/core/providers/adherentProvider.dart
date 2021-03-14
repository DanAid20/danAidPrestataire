import 'package:flutter/material.dart';
import '../models/adherentFacturationModel.dart';

class AdherentProvider with ChangeNotifier {
  String _adherentId, _cniName, _otherDocName, _marriageCertificateName, _familyName, _surname, _matricule, _imgUrl, _gender, _email, _profession, _regionOfOrigin, _marriageCertificateUrl, _otherJustificativeDocsUrl, _officialDocUrl, _town, _profileType;
  DateTime _dateCreated, _validityEndDate, _birthDate;
  bool _paymentIsMobile, _profileEnabled, _isMarried;
  List<Map> _phoneList;
  List<AdherentBillModel> _adherentNewBill;

  AdherentProvider(this._adherentId, this._cniName, this._otherDocName, this._marriageCertificateName, this._familyName, this._surname, this._matricule, this._imgUrl, this._gender, this._email, this._profession, this._regionOfOrigin, this._marriageCertificateUrl, this._otherJustificativeDocsUrl, this._officialDocUrl, this._town, this._profileType, this._dateCreated, this._validityEndDate, this._birthDate, this._paymentIsMobile, this._profileEnabled, this._isMarried, this._phoneList, this._adherentNewBill);

  String get getAdherentId => _adherentId;
  String get getCniName => _cniName;
  String get getOtherDocName => _otherDocName;
  String get getMarriageCertificateName => _marriageCertificateName;
  String get getFamilyName => _familyName;
  String get getSurname => _surname;
  String get getMatricule => _matricule;
  String get getImgUrl => _imgUrl;
  String get getGender => _gender;
  String get getEmail => _email;
  String get getProfession => _profession;
  String get getRegionOfOrigin => _regionOfOrigin;
  String get getMarriageCertificateUrl => _marriageCertificateUrl;
  String get getOtherJustificativeDocsUrl => _otherJustificativeDocsUrl;
  String get getOfficialDocUrl => _officialDocUrl;
  String get getTown => _town;
  String get getProfileType => _profileType;
  DateTime get getDateCreated => _dateCreated;
  DateTime get getValidityEndDate => _validityEndDate;
  DateTime get getBirthDate => _birthDate;
  bool get isPaymentMobile => _paymentIsMobile;
  bool get isProfileEnabled => _profileEnabled;
  bool get isMarried => _isMarried;
  List<Map> get getPhoneList => _phoneList;
  List<AdherentBillModel> get getAdherentNewBill => _adherentNewBill;
  
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
  }

}