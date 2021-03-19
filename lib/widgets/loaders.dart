import 'package:danaid/core/utils/config_size.dart';
import 'package:flutter/material.dart';

class Loaders {
  Widget buttonLoader(Color color){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: hv*1.5),
      child: CircleAvatar(child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 1,),
      ), backgroundColor: color,),
    );
  }
}