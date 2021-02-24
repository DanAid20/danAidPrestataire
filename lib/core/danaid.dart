import 'package:danaid/core/routes.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/status_bar.dart';
import 'package:danaid/helpers/strings.dart';
import 'package:danaid/helpers/theme.dart';
import 'package:flutter/material.dart';

import '../locator.dart';

class Danaid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    statusBar.setColor(context: context);
    return MaterialApp(
      title: Strings.APP_NAME,
      theme: theme(),
      debugShowCheckedModeBanner: false,
      routes: routes,
      initialRoute: '/intro-view',
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
