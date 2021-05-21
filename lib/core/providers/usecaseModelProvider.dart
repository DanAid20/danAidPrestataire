import 'package:danaid/core/models/usecaseModel.dart';
import 'package:flutter/material.dart';

class UseCaseModelProvider with ChangeNotifier {
  
  UseCaseModel _useCase;
  UseCaseModelProvider(this._useCase);

  UseCaseModel get getUseCase => _useCase;

  void setUseCaseModel(UseCaseModel val){
    _useCase = val;
    notifyListeners();
  }

  void setAdherentId(String val){
    _useCase.adherentId = val;
    notifyListeners();
  }

}