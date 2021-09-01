import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:flutter/material.dart';

class AdherentModelProvider with ChangeNotifier {

  AdherentModel _adherent;
  
  AdherentModelProvider(this._adherent);

  AdherentModel get getAdherent => _adherent;

  void setAdherentModel(AdherentModel val){
    _adherent = val;
    notifyListeners();
  }
  void setFamilyDoctor(DoctorModel val){
    _adherent.familyDoctor = val;
    notifyListeners();
  }
  void setLoanLimit(num val){
    _adherent.loanLimit = val;
    notifyListeners();
  }
  void updateLoanLimit(num val){
    _adherent.loanLimit = _adherent.loanLimit + val;
    notifyListeners();
  }
  void setInsuranceLimit(num val){
    _adherent.insuranceLimit = val;
    notifyListeners();
  }
  void updateInsuranceLimit(num val){
    _adherent.insuranceLimit = _adherent.insuranceLimit + val;
    notifyListeners();
  }
  void addVisit(DateTime date){
    _adherent.visitPoints = _adherent.visitPoints != null ? _adherent.visitPoints + 10 : 10;
    _adherent.visits.add(date);
    notifyListeners();
  }
  void setAdherentId(String val){
    _adherent.adherentId = val;
    notifyListeners();
  }
  void setFamilyDoctorId(String val){
    _adherent.familyDoctorId= val;
    notifyListeners();
  }
  void setCniName(String val){
    _adherent.cniName = val;
    notifyListeners();
  }
  void setAddress(String val){
    _adherent.address = val;
    notifyListeners();
  }
  void setOtherDocName(String val){
    _adherent.otherDocName = val;
    notifyListeners();
  }

  void setMarriageCertificateName(String val){
    _adherent.marriageCertificateName = val;
    notifyListeners();
  }

  void setFamilyName(String val){
    _adherent.familyName = val;
    notifyListeners();
  }

  void setSurname(String val){
    _adherent.surname = val;
    notifyListeners();
  }

  void setMatricule(String val){
    _adherent.matricule = val;
    notifyListeners();
  }

  void setImgUrl(String val){
    _adherent.imgUrl = val;
    notifyListeners();
  }

  void setGender(String val){
    _adherent.gender = val;
    notifyListeners();
  }

  void setEmail(String val){
    _adherent.email = val;
    notifyListeners();
  }

  void setHeight(var val){
    _adherent.height = val;
    notifyListeners();
  }

  void setWeight(var val){
    _adherent.weight = val;
    notifyListeners();
  }

  void setBloodGroup(String val){
    _adherent.bloodGroup = val;
    notifyListeners();
  }

  void setAllergies(List val){
    _adherent.allergies = [];
    for(int i=0; i < val.length; i++){
      _adherent.allergies.add(val[i]);
    }
    
    notifyListeners();
  }

  void setProfession(String val){
    _adherent.profession = val;
    notifyListeners();
  }

  void setRegionOfOrigin(String val){
    _adherent.regionOfOrigin = val;
    notifyListeners();
  }

  void setMarriageCertificateUrl(String val){
    _adherent.marriageCertificateUrl = val;
    notifyListeners();
  }

  void setOtherJustificativeDocsUrl(String val){
    _adherent.otherJustificativeDocsUrl = val;
    notifyListeners();
  }

  void setOfficialDocUrl(String val){
    _adherent.officialDocUrl = val;
    notifyListeners();
  }

  void setTown(String val){
    _adherent.town = val;
    notifyListeners();
  }

  void setAdherentPlan(int val){
    _adherent.adherentPlan = val;
    notifyListeners();
  }

  void setProfileType(String val){
    _adherent.profileType = val;
    notifyListeners();
  }

  void setDateCreated(DateTime val){
    _adherent.dateCreated = Timestamp.fromDate(val);
    notifyListeners();
  }

  void setValidityEndDate(DateTime val){
    _adherent.validityEndDate = Timestamp.fromDate(val);
    notifyListeners();
  }

  void setBirthDate(DateTime val){
    _adherent.birthDate = Timestamp.fromDate(val);
    notifyListeners();
  }

  void setProfileEnableState(bool val){
    _adherent.profileEnabled = val;
    notifyListeners();
  }

  void setEnableState(bool val){
    _adherent.enable = val;
    notifyListeners();
  }

  void setMatrimonialStatus(bool val){
    _adherent.isMarried = val;
    notifyListeners();
  }
  void setLocation(Map loc){
    _adherent.location = loc;
    notifyListeners();
  }
  void setHavePaidBefore(bool val){
    _adherent.havePaid = val;
    notifyListeners();
  }

}