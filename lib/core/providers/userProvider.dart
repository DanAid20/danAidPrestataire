import 'package:danaid/core/models/userModel.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  
  UserModel _user;
  String _authId,_userId, _matricule, _fullName, _imgUrl, _email, _profileType, _regionOfOrigin, _cniUrl, _countryCode, _countryName;
  bool _enabled;
  List<Map> _phoneList;

  UserProvider(this._user, this._authId, this._userId, this._matricule, this._fullName, this._imgUrl, this._email, this._profileType, this._regionOfOrigin, this._cniUrl, this._countryCode, this._countryName, this._enabled, this._phoneList);

  UserModel get getUserModel => _user;
  String get getAuthId => _authId;
  String get getUserId => _userId;
  String get getMatricule => _matricule;
  String get getFullName => _fullName;
  String get getImgUrl => _imgUrl;
  String get getEmail => _email;
  String get getProfileType => _profileType;
  String get getRegionOfOrigin => _regionOfOrigin;
  String get getCniUrl => _cniUrl;
  String get getCountryCode => _countryCode;
  String get getCountryName => _countryName;
  bool get isEnabled => _enabled;
  List<Map> get getPhoneList => _phoneList;

  void setUserModel(UserModel val){
    _user = val;
    notifyListeners();
  }
  void setAuthId(String val) {
    _authId = val;
    notifyListeners();
  }
  void setUserId(String val) {
    _userId = val;
    notifyListeners();
  }
  void setMatricule(String val) {
    _matricule = val;
    notifyListeners();
  }
  
  void setFullName(String val) {
    _fullName = val;
    notifyListeners();
  }

  void setImgUrl(String val) {
    _imgUrl = val;
    notifyListeners();
  }

  void setEmail(String val) {
    _email = val;
    notifyListeners();
  }

  void setProfileType(String val) {
    _profileType = val;
    notifyListeners();
  }

  void setRegionOfOrigin(String val) {
    _regionOfOrigin = val;
    notifyListeners();
  }

  void setCniUrl(String val) {
    _cniUrl = val;
    notifyListeners();
  }

  void setCountryCode(String val) {
    _countryCode = val;
    notifyListeners();
  }

  void setCountryName(String val) {
    _countryName = val;
    notifyListeners();
  }

  void enable(bool val) {
    _user.enabled = val;
    notifyListeners();
  }

  void addPoints(int val) {
    _user.points = _user.points + 25;
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

}