import 'package:danaid/core/models/usecaseModel.dart';
import 'package:flutter/material.dart';

class UseCaseModelProvider with ChangeNotifier {
  
  UseCaseModel? _useCase;
  UseCaseModelProvider(this._useCase);

  UseCaseModel? get getUseCase => _useCase;

  void setUseCaseModel(UseCaseModel val){
    _useCase = val;
    notifyListeners();
  }

  void setAdherentId(String val){
    _useCase?.adherentId = val;
    notifyListeners();
  }

  void setConsultationId(String val){
    _useCase?.consultationId = val;
    notifyListeners();
  }

  void setAmbulanceId(String val){
    _useCase?.ambulanceId = val;
    notifyListeners();
  }

  void setHospitalizationId(String val){
    _useCase?.hospitalizationId = val;
    notifyListeners();
  }

  void setConsultationCost(num val){
    if(_useCase?.consultationCost == null){
      _useCase?.amount = (_useCase?.amount)! + val;
    }
    else{
      _useCase?.amount = (_useCase?.amount)! - (_useCase?.consultationCost)! + val;
    }
    _useCase?.consultationCost = val;
    notifyListeners();
  }

  void addAmount(num val){
    _useCase?.amount = (_useCase?.amount)! + val;
    notifyListeners();
  }

  void modifyServiceCost({num? oldVal, num? newVal}){
    _useCase?.amount = (_useCase?.amount)! - oldVal! + newVal!;
    notifyListeners();
  }

  void setDoctorName(String val){
    _useCase?.doctorName = val;
    notifyListeners();
  }

  void setEstablishment(String val){
    _useCase?.establishment = val;
    notifyListeners();
  }

  void addBookletUrl(String val){
    if(_useCase?.bookletUrls == null){
      _useCase?.bookletUrls = [];
    }
    _useCase?.bookletUrls?.add(val);
    notifyListeners();
  }

  void addOtherDocUrl(String val){
    if(_useCase?.otherDocUrls == null){
      _useCase?.otherDocUrls = [];
    }
    _useCase?.otherDocUrls?.add(val);
    notifyListeners();
  }

  void addReceiptUrl(String val){
    if(_useCase?.receiptUrls == null){
      _useCase?.receiptUrls = [];
    }
    _useCase?.receiptUrls?.add(val);
    notifyListeners();
  }

}