import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

  InputDecoration defaultInputDecoration({String suffix}) {
    return InputDecoration(
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.red[300]),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      fillColor: Colors.grey[100],
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: kPrimaryColor.withOpacity(0.0)),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      suffixText: suffix != null ? suffix : "",
      hintStyle: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),
    );
  }