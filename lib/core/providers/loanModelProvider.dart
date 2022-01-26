import 'package:flutter/material.dart';
import 'package:danaid/core/models/loanModel.dart';

class LoanModelProvider with ChangeNotifier {
  LoanModel? _loan;

  LoanModelProvider(_loan);

  LoanModel? get getLoan => _loan;

  setLoanModel(LoanModel val){
    _loan = val;
    notifyListeners();
  }

  setAmount(num val){
    _loan?.amount = val;
    notifyListeners();
  }

  addPaidAmount(num val){
    _loan?.amountPaid = _loan?.amountPaid == null ? val : (_loan?.amountPaid)! + val;
    notifyListeners();
  }

  setMaxAmount(num val){
    _loan?.maxAmount = val;
    notifyListeners();
  }

  setCarnetUrl(String val){
    _loan?.carnetUrl = val;
    notifyListeners();
  }

  addDocUrl(String val){
    _loan?.docsUrls!.add(val);
    notifyListeners();
  }

  setotherDocUrl(String val){
    _loan?.otherDocUrl = val;
    notifyListeners();
  }
}