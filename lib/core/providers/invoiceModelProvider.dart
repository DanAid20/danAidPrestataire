import 'package:danaid/core/models/invoiceModel.dart';
import 'package:flutter/material.dart';

class InvoiceModelProvider with ChangeNotifier {
  InvoiceModel _invoice;
  
  InvoiceModelProvider(this._invoice);

  InvoiceModel get getInvoice => _invoice;

  void setInvoiceModel(InvoiceModel val){
    _invoice = val;
    notifyListeners();
  }
}