import 'package:flutter/material.dart';
import 'package:danaid/core/models/loanModel.dart';

class LoanModelProvider with ChangeNotifier {
  LoanModel _loan;

  LoanModelProvider(_loan);

  LoanModel get getLoan => _loan;

  setLoanModel(LoanModel val){
    _loan = val;
    notifyListeners();
  }

  setAmount(num val){
    _loan.amount = val;
    notifyListeners();
  }

  setMaxAmount(num val){
    _loan.maxAmount = val;
    notifyListeners();
  }
}