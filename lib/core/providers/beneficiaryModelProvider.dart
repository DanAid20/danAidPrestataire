import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';

class BeneficiaryModelProvider with ChangeNotifier {
  BeneficiaryModel _beneficiary;

  BeneficiaryModelProvider(this._beneficiary);

  BeneficiaryModel get getBeneficiary => _beneficiary;

  void setBeneficiaryModel(BeneficiaryModel val){
    _beneficiary = val;
    notifyListeners();
  }
  void setAdherentId(String val){
    _beneficiary.adherentId = val;
    notifyListeners();
  }
  void setCniName(String val){
    _beneficiary.cniName = val;
    notifyListeners();
  }
  void setOtherDocName(String val){
    _beneficiary.otherDocName = val;
    notifyListeners();
  }

  void setMarriageCertificateName(String val){
    _beneficiary.marriageCertificateName = val;
    notifyListeners();
  }

  void setFamilyName(String val){
    _beneficiary.familyName = val;
    notifyListeners();
  }

  void setSurname(String val){
    _beneficiary.surname = val;
    notifyListeners();
  }

  void setMatricule(String val){
    _beneficiary.matricule = val;
    notifyListeners();
  }

  void setAvatarUrl(String val){
    _beneficiary.avatarUrl = val;
    notifyListeners();
  }

  void setGender(String val){
    _beneficiary.gender = val;
    notifyListeners();
  }

  void setMarriageCertificateUrl(String val){
    _beneficiary.marriageCertificateUrl = val;
    notifyListeners();
  }

  void setBirthCertificateUrl(String val){
    _beneficiary.birthCertificateUrl = val;
    notifyListeners();
  }

  void setOtherDocUrl(String val){
    _beneficiary.otherDocUrl = val;
    notifyListeners();
  }

  void setcniUrl(String val){
    _beneficiary.cniUrl = val;
    notifyListeners();
  }

  void setDateCreated(DateTime val){
    _beneficiary.dateCreated = Timestamp.fromDate(val);
    notifyListeners();
  }

  void setValidityEndDate(DateTime val){
    _beneficiary.validityEndDate = Timestamp.fromDate(val);
    notifyListeners();
  }

  void setBirthDate(DateTime val){
    _beneficiary.birthDate = Timestamp.fromDate(val);
    notifyListeners();
  }

  void setEnableState(bool val){
    _beneficiary.enabled = val;
    notifyListeners();
  }

  void setHeight(double val){
    _beneficiary.height = val;
    notifyListeners();
  }

  void setWeight(double val){
    _beneficiary.weight = val;
    notifyListeners();
  }

  void setAllergies(List val){
    _beneficiary.allergies = val;
    notifyListeners();
  }

  void addAllergy(String val){
    _beneficiary.allergies.add(val);
    notifyListeners();
  }

}