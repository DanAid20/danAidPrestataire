import 'package:danaid/core/routes.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/status_bar.dart';
import 'package:danaid/helpers/strings.dart';
import 'package:danaid/helpers/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/phoneVerificationProvider.dart';
import '../locator.dart';

class Danaid extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    statusBar.setColor(context: context);
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Checking for errors
        if (snapshot.hasError) {
          return Center(child: Text("Error occured"),);
        }

        // Once complete, show our application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<UserProvider>(
                create: (_) => UserProvider(
                  "", "", "", "", "", "", "", "", "237", "Cameroon", false, null
                ),
              ),
              ChangeNotifierProvider<AdherentProvider>(
                create: (_) => AdherentProvider(
                  "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", null, null, null, null, null, null, null, null, null
                ),
              ),
              ChangeNotifierProvider<PhoneVerificationProvider>(
                create: (_) => PhoneVerificationProvider(null),
              )
            ],
            child: MaterialApp(
              title: Strings.APP_NAME,
              theme: theme(),
              debugShowCheckedModeBanner: false,
              routes: routes,
              initialRoute: '/intro-view',
              navigatorKey: locator<NavigationService>().navigatorKey,
            ),
          );
        }
      }
    );
  }
}
