import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {

  bool _isSignedIn;
  bool _isRegistered;
  
  AuthProvider(this._isSignedIn, this._isRegistered);

  bool get getSignInState => _isSignedIn;
  bool get getRegisterState => _isRegistered;

  void setSignInState(bool val){
    _isSignedIn = val;
    notifyListeners();
  }

  void setRegisterState(bool val){
    _isRegistered = val;
    notifyListeners();
  }

}