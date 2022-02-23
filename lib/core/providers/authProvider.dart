import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {

  bool _isSignedIn;
  bool _isRegistered;
  
  AuthProvider(this._isSignedIn, this._isRegistered);

  bool get getSignInState => _isSignedIn;
  bool get getRegisterState => _isRegistered;

  void setSignInState(bool? val){
    if(val == null){
      _isSignedIn = false;
    }
    else {
      _isSignedIn = val;
    }
    
    notifyListeners();
  }

  void setRegisterState(bool? val){
    if(val == null){
      _isRegistered = false;
    }
    else {
      _isRegistered = val;
    }
    notifyListeners();
  }

}