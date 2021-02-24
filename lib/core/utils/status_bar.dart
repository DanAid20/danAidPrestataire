import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBar {
  setColor({BuildContext context}) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          statusBarColor: kPrimaryColor,
          statusBarIconBrightness: Brightness.light),
    );
  }
}

final StatusBar statusBar = StatusBar();
