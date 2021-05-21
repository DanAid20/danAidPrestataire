import 'package:flutter/material.dart';

class BottomAppBarControllerProvider with ChangeNotifier {

  int _index;
  int previousIndex = 1;

  BottomAppBarControllerProvider(this._index, this.previousIndex);

  int get getIndex => _index;

  void setIndex(int val){
    previousIndex = _index;
    _index = val;
    notifyListeners();
  }

  void toPreviousIndex(){
    _index = previousIndex;
    notifyListeners();
  }

}