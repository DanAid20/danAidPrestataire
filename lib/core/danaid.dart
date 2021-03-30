import 'package:danaid/core/routes.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/status_bar.dart';
import 'package:danaid/helpers/strings.dart';
import 'package:danaid/helpers/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/phoneVerificationProvider.dart';
import 'package:danaid/core/providers/authProvider.dart';
import 'package:danaid/core/providers/devEnvironmentProvider.dart';
import '../locator.dart';

class Danaid extends StatelessWidget {
  final String env;

  const Danaid({Key key, this.env}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    statusBar.setColor(context: context);
    return MultiProvider(
            providers: [
              ChangeNotifierProvider<DevEnvironmentProvider>(
                create: (_) => DevEnvironmentProvider(env),
              ),
              ChangeNotifierProvider<UserProvider>(
                create: (_) => UserProvider(
                  null, "", "", "", "", "", "", "", "", "237", "Cameroon", false, null
                ),
              ),
              ChangeNotifierProvider<AdherentProvider>(
                create: (_) => AdherentProvider(
                  "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", null, null, null, null, null, null, null, null, null
                ),
              ),
              ChangeNotifierProvider<PhoneVerificationProvider>(
                create: (_) => PhoneVerificationProvider(null),
              ),
              ChangeNotifierProvider<AuthProvider>(
                create: (_) => AuthProvider(false, false),
              )
            ],
            child: MaterialApp(
              title: Strings.APP_NAME,
              theme: theme(),
              debugShowCheckedModeBanner: false,
              routes: routes,
              initialRoute: '/splash',
              navigatorKey: locator<NavigationService>().navigatorKey,
            ),
          );
  }
}
