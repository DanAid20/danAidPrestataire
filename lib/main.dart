import 'package:danaid/core/danaid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(Danaid());
}
