import 'package:danaid/core/models/useCaseServiceModel.dart';
import 'package:flutter/material.dart';

class AmbulanceServiceProvider with ChangeNotifier {
  
  UseCaseServiceModel _service;
  AmbulanceServiceProvider(this._service);

  UseCaseServiceModel get getService => _service;

  void setService(UseCaseServiceModel val){
    _service = val;
    notifyListeners();
  }

  void addPrescriptionUrl(String val){
    if(_service.precriptionUrls == null){
      _service.precriptionUrls = [];
    }
    _service.precriptionUrls?.add(val);
    notifyListeners();
  }

  void addReceiptUrl(String val){
    if(_service.receiptUrls == null){
      _service.receiptUrls = [];
    }
    _service.receiptUrls?.add(val);
    notifyListeners();
  }

  void addDrugUrl(String val){
    if(_service.drugsUrls == null){
      _service.drugsUrls = [];
    }
    _service.drugsUrls?.add(val);
    notifyListeners();
  }

}