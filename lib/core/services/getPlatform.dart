import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}

extension Target on Object {
  bool isAndroid() {
    return Platform.isAndroid;
  } 
  bool isIOS() {
    return Platform.isIOS;
  } 
  bool isLinux() {
  return Platform.isLinux;
  } 
  bool isWindows() {
  return Platform.isWindows; 
  }
  bool isMacOS() {
  return Platform.isMacOS; 
  }
  bool isWeb() {
  return kIsWeb; 
  }
  bool isComputerScreen(){
    return kIsWeb || Platform.isWindows;
  }
  bool isPhoneScreen(){
    return Platform.isAndroid || Platform.isIOS;
  }
  // ···
}

class Device {
  static bool get isDesktop => !isWeb && (isWindows || isLinux || isMacOS);
  static bool get isMobile => isAndroid || isIOS;
  static bool get isWeb => kIsWeb;
  
  static bool get isWindows => Platform.isWindows;
  static bool get isLinux => Platform.isLinux;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isAndroid => Platform.isAndroid;
  static bool get isFuchsia => Platform.isFuchsia;
  static bool get isIOS => Platform.isIOS;
  static double get _ppi => kIsWeb ? 96 : (Platform.isAndroid || Platform.isIOS) ? 150 : 96;
  static bool isLandscape(BuildContext c) => MediaQuery.of(c).orientation == Orientation.landscape;
  //PIXELS
  static Size size(BuildContext c) => MediaQuery.of(c).size;
  static double width(BuildContext c) => size(c).width;
  static double height(BuildContext c) => size(c).height;
  static double diagonal(BuildContext c) {
    Size s = size(c);
    return sqrt((s.width * s.width) + (s.height * s.height));
  }
  //INCHES
  static Size inches(BuildContext c) {
    Size pxSize = size(c);
    return Size(pxSize.width / _ppi, pxSize.height/ _ppi);
  }
  static double widthInches(BuildContext c) => inches(c).width;
  static double heightInches(BuildContext c) => inches(c).height;
  static double diagonalInches(BuildContext c) => diagonal(c) / _ppi;
  static bool isSmartphone(BuildContext c) => (diagonal(c)/_ppi) < 7;
  static bool isPC(BuildContext c) => diagonal(c) < 10;
  static bool isTablet(BuildContext c) => diagonal(c) >= 7 && diagonal(c) <= 10;
  //static bool isTabletOrPC(BuildContext c) => diagonal(c) < 10;
}

/* //HINTS

bool isLandscape = Screen.isLandscape(context)
bool isLargePhone = Screen.diagonal(context) > 720;
bool isTablet = Screen.diagonalInches(context) >= 7 && Screen.diagonalInches(context) < 10;
bool isDesktop = Screen.diagonalInches(context) >= 10;
*/