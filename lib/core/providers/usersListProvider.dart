import 'package:danaid/core/models/userModel.dart';
import 'package:flutter/material.dart';

class UsersListProvider with ChangeNotifier {
  
  List<UserModel> _users;

  UsersListProvider(this._users);

  List<UserModel> get getUsers => _users;

  void setUsers(List<UserModel> val){
    _users = val;
    notifyListeners();
  }

  void addUser(UserModel val){
    bool add = true;
    for(int i=0; i<_users.length; i++){
      if (val.userId == _users[i].userId){
        add = false;
        break;
      }
    }
    add ? _users.add(val) : print("already inside");
    notifyListeners();
  }

  void removeUser(UserModel val){
    _users.remove(val);
    notifyListeners();
  }

}