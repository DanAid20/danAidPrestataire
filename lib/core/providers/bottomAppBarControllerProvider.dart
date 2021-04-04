import 'package:flutter/material.dart';

class BottomAppBarControllerProvider with ChangeNotifier {

  int _index;

  BottomAppBarControllerProvider(this._index);

  int get getIndex => _index;

  void setIndex(int val){
    _index = val;
    notifyListeners();
  }

}