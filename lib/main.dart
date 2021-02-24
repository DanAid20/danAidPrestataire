import 'package:danaid/core/danaid.dart';
import 'package:flutter/material.dart';

import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(Danaid());
}
