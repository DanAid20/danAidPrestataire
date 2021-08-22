import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

  InputDecoration defaultInputDecoration({String suffix, Color fillColor, String hintText}) {
    return InputDecoration(
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.red[300]),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      fillColor: fillColor == null ? Colors.grey[100] : fillColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: kPrimaryColor.withOpacity(0.0)),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      suffixText: suffix != null ? suffix : "",
      hintStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
    );
  }