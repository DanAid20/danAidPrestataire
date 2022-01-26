import 'package:flutter/material.dart';
import 'package:danaid/core/models/planModel.dart';

class PlanModelProvider with ChangeNotifier {
  PlanModel? _plan;

  PlanModelProvider(this._plan);

  PlanModel? get getPlan => _plan;

  setPlanModel(PlanModel val){
    _plan = val;
    notifyListeners();
  }
}