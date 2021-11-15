
import 'package:danaid/core/models/devisModel.dart';
import 'package:flutter/material.dart';

class ServicesProviderInvoice with ChangeNotifier {
  DevisModel _invoice;
  DevisModel _invoiceItems;
  
  ServicesProviderInvoice(this._invoice);

  DevisModel get getInvoice => _invoice;

  DevisModel get getInvoiceItems => _invoiceItems;

  String get getId=> _invoiceItems.id;

  List<DevisModel> _devisList;
 
  List<DevisModel> get getdevisList => _devisList;
  
  void setInvoiceModel(DevisModel val){
    _invoice = val;
    notifyListeners();
  }
  void setModelListAllInvoice(List<DevisModel> list){
    _devisList.addAll(list);
    notifyListeners();
  }
  void addNewAdherentBill(DevisModel val){
    _devisList.add(val);
    notifyListeners();
  }
   void setId(String val){
    _invoiceItems.id = val;
    notifyListeners();
  }
   void setspecialDevisModel(DevisModel val){
    _invoiceItems = val;
    notifyListeners();
  }
}