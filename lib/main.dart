import 'dart:io';
import 'package:danaid/core/danaid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  await Firebase.initializeApp();
  Hive.init(directory.path);
  setupLocator();
  runApp(Danaid());
}
