import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBar {
  setColor({required BuildContext context}) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light),
    );
  }
}

final StatusBar statusBar = StatusBar();
