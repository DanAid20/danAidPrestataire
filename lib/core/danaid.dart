import 'package:danaid/core/routes.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/status_bar.dart';
import 'package:danaid/helpers/strings.dart';
import 'package:danaid/helpers/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/phoneVerificationProvider.dart';
import 'package:danaid/core/providers/authProvider.dart';
import 'package:danaid/core/providers/devEnvironmentProvider.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/doctorTileModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderTileModelProvider.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/providers/conversationModelProvider.dart';
import 'package:danaid/core/providers/conversationChatModelProvider.dart';
import 'package:danaid/core/providers/usersListProvider.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
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
                  null, null, "", "", "", "", "", "", "", "", "237", "Cameroon", false, null
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
              ),
              ChangeNotifierProvider<AdherentModelProvider>(
                create: (_) => AdherentModelProvider(null),
              ),
              ChangeNotifierProvider<BottomAppBarControllerProvider>(
                create: (_) => BottomAppBarControllerProvider(1),
              ),
              ChangeNotifierProvider<DoctorModelProvider>(
                create: (_) => DoctorModelProvider(null),
              ),
              ChangeNotifierProvider<BeneficiaryModelProvider>(
                create: (_) => BeneficiaryModelProvider(BeneficiaryModel()),
              ),
              ChangeNotifierProvider<ServiceProviderModelProvider>(
                create: (_) => ServiceProviderModelProvider(null),
              ),
              ChangeNotifierProvider<ConversationModelProvider>(
                create: (_) => ConversationModelProvider(null),
              ),
              ChangeNotifierProvider<ConversationChatModelProvider>(
                create: (_) => ConversationChatModelProvider(null),
              ),
              ChangeNotifierProvider<DoctorTileModelProvider>(
                create: (_) => DoctorTileModelProvider(null),
              ),
              ChangeNotifierProvider<ServiceProviderTileModelProvider>(
                create: (_) => ServiceProviderTileModelProvider(null),
              ),
              ChangeNotifierProvider<UsersListProvider>(
                create: (_) => UsersListProvider([]),
              ),
            ],
            child: ScreenUtilInit(
                 builder: () => MaterialApp(
                title: Strings.APP_NAME,
                theme: theme(),
                debugShowCheckedModeBanner: false,
                routes: routes,
                initialRoute: '/splash',
                navigatorKey: locator<NavigationService>().navigatorKey,
              ),
            ),
          );
  }
}
