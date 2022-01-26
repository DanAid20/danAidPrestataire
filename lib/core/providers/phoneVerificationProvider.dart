import 'package:flutter/material.dart';

class PhoneVerificationProvider with ChangeNotifier {

  String? _verificationId;
  
  PhoneVerificationProvider(this._verificationId);

  String? get getVerificationId => _verificationId;

  void setVerificationId(String val){
    _verificationId = val;
    notifyListeners();
  }

}