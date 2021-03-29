import 'package:flutter/material.dart';

class DevEnvironmentProvider with ChangeNotifier {

  String _env;
  
  DevEnvironmentProvider(this._env);

  String get getEnv => _env;

  void setEnv(String val){
    _env = val;
    notifyListeners();
  }

}