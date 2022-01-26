import 'package:danaid/core/models/devisModel.dart';
import 'package:danaid/core/models/invoiceModel.dart';
import 'package:danaid/core/models/loanModel.dart';
import 'package:danaid/core/models/notificationModel.dart';
import 'package:danaid/core/models/useCaseServiceModel.dart';
import 'package:danaid/core/providers/ServicesProviderInvoice.dart';
import 'package:danaid/core/providers/invoiceModelProvider.dart';
import 'package:danaid/core/routes.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/status_bar.dart';
import 'package:danaid/helpers/SizeConfig.dart';
import 'package:danaid/helpers/strings.dart';
import 'package:danaid/helpers/theme.dart';
import 'package:danaid/language/LanguageProvider.dart';
import 'package:danaid/language/Language_Helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:danaid/generated/l10n.dart';
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
import 'package:danaid/core/providers/notificationModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderTileModelProvider.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/providers/conversationModelProvider.dart';
import 'package:danaid/core/providers/conversationChatModelProvider.dart';
import 'package:danaid/core/providers/appointmentProvider.dart';
import 'package:danaid/core/providers/usecaseModelProvider.dart';
import 'package:danaid/core/providers/usersListProvider.dart';
import 'package:danaid/core/providers/loanModelProvider.dart';
import 'package:danaid/core/providers/planModelProvider.dart';
import 'package:danaid/core/providers/pharmacyServiceProvider.dart';
import 'package:danaid/core/providers/hospitalizationServiceProvider.dart';
import 'package:danaid/core/providers/ambulanceServiceProvider.dart';
import 'package:danaid/core/providers/labServiceProvider.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import '../locator.dart';

class Danaid extends StatelessWidget {
  final String? env;

  const Danaid({Key? key, this.env}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    statusBar.setColor(context: context);
    Intl.defaultLocale = 'fr_FR' ;
    final LanguageProvider currentData = LanguageProvider();
      return ChangeNotifierProvider(
      create: (context) => currentData,
      child: Consumer<LanguageProvider>(
        builder: (context, provider, child) => MultiProvider(
              providers: [
                ChangeNotifierProvider<DevEnvironmentProvider>(
                  create: (_) => DevEnvironmentProvider(env!),
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
                  create: (_) => BottomAppBarControllerProvider(1,1),
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
                ChangeNotifierProvider<AppointmentModelProvider>(
                  create: (_) => AppointmentModelProvider(null),
                ),
                ChangeNotifierProvider<UseCaseModelProvider>(
                  create: (_) => UseCaseModelProvider(null),
                ),
                ChangeNotifierProvider<LoanModelProvider>(
                  create: (_) => LoanModelProvider(LoanModel()),
                ),
                ChangeNotifierProvider<PlanModelProvider>(
                  create: (_) => PlanModelProvider(null),
                ),
                ChangeNotifierProvider<InvoiceModelProvider>(
                  create: (_) => InvoiceModelProvider(InvoiceModel()),
                ),
                ChangeNotifierProvider<NotificationModelProvider>(
                  create: (_) => NotificationModelProvider(<NotificationModel>[], 0),
                ),
                ChangeNotifierProvider<AmbulanceServiceProvider>(
                  create: (_) => AmbulanceServiceProvider(UseCaseServiceModel()),
                ),
                ChangeNotifierProvider<HospitalizationServiceProvider>(
                  create: (_) => HospitalizationServiceProvider(UseCaseServiceModel()),
                ),
                ChangeNotifierProvider<PharmacyServiceProvider>(
                  create: (_) => PharmacyServiceProvider(UseCaseServiceModel()),
                ),
                ChangeNotifierProvider<LabServiceProvider>(
                  create: (_) => LabServiceProvider(UseCaseServiceModel()),
                ),
                ChangeNotifierProvider<ServicesProviderInvoice>(
                  create: (_) => ServicesProviderInvoice(DevisModel()),
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
                  locale:context.watch<LanguageProvider>().locale==Locale('en', 'EN')?  Locale('en', 'EN') : Locale('fr', 'FR'),
                  localizationsDelegates: [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
                ),
              ),
            ),
      ));
    
  }
}
