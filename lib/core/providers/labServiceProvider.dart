import 'package:danaid/core/models/useCaseServiceModel.dart';
import 'package:flutter/material.dart';

class LabServiceProvider with ChangeNotifier {
  
  UseCaseServiceModel _service;

  LabServiceProvider(this._service);

  UseCaseServiceModel get getService => _service;

  void setService(UseCaseServiceModel val){
    _service = val;
    notifyListeners();
  }

  void addPrescriptionUrl(String val){
    if(_service.precriptionUrls == null){
      _service.precriptionUrls = [];
    }
    _service.precriptionUrls.add(val);
    notifyListeners();
  }

  void addReceiptUrl(String val){
    if(_service.receiptUrls == null){
      _service.receiptUrls = [];
    }
    _service.receiptUrls.add(val);
    notifyListeners();
  }

  void addResultUrl(String val){
    if(_service.resultsUrls == null){
      _service.resultsUrls = [];
    }
    _service.resultsUrls.add(val);
    notifyListeners();
  }

}