import 'package:flutter/material.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModelProvider with ChangeNotifier {
  
  DoctorModel _doctor;

  DoctorModelProvider(this._doctor);

  DoctorModel get getDoctor => _doctor;

  void setDoctorModel(DoctorModel val){
    _doctor = val;
    notifyListeners();
  }

  void setDoctorId(String val){
    _doctor.id = val;
    notifyListeners();
  }

  void setCniName(String val){
    _doctor.cniName = val;
    notifyListeners();
  }

  void setAddress(String val){
    _doctor.address = val;
    notifyListeners();
  }

  void setRate(Map val){
    _doctor.rate = val;
    notifyListeners();
  }

  void setServiceList(Map val){
    _doctor.serviceList = val;
    notifyListeners();
  }

  void setAvailability(Map val){
    _doctor.availability = val;
    notifyListeners();
  }

  void setFamilyName(String val){
    _doctor.familyName = val;
    notifyListeners();
  }

  void setAbout(String val){
    _doctor.about = val;
    notifyListeners();
  }

  void setSurname(String val){
    _doctor.surname = val;
    notifyListeners();
  }

  void personContactName(String val){
    _doctor.personContactName = val;
    notifyListeners();
  }

  void setPersonContactPhone(String val){
    _doctor.personContactPhone = val;
    notifyListeners();
  }

  void setImgUrl(String val){
    _doctor.avatarUrl = val;
    notifyListeners();
  }

  void setGender(String val){
    _doctor.gender = val;
    notifyListeners();
  }

  void setEmail(String val){
    _doctor.email = val;
    notifyListeners();
  }

  void setSpeciality(String val){
    _doctor.speciality = val;
    notifyListeners();
  }

  void setField(String val){
    _doctor.field = val;
    notifyListeners();
  }

  void setRegion(String val){
    _doctor.region = val;
    notifyListeners();
  }

  void setOfficeRegion(String val){
    _doctor.hospitalRegion = val;
    notifyListeners();
  }

  void setOfficeName(String val){
    _doctor.officeName = val;
    notifyListeners();
  }

  void setOrderRegistrationCertificate(String val){
    _doctor.orderRegistrationCertificate = val;
    notifyListeners();
  }

  void setOrderRegistrationCertificateUrl(String val){
    _doctor.orderRegistrationCertificateUrl = val;
    notifyListeners();
  }

  void setCNIUrl(String val){
    _doctor.cniUrl = val;
    notifyListeners();
  }

  void setTown(String val){
    _doctor.town = val;
    notifyListeners();
  }

  void setOfficeTown(String val){
    _doctor.hospitalTown = val;
    notifyListeners();
  }


  void setProfileEnableState(bool val){
    _doctor.profileEnabled = val;
    notifyListeners();
  }

  void setLocation(Map loc){
    _doctor.location = loc;
    notifyListeners();
  }

}