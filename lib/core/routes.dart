import 'package:danaid/views/auths_views/adherent_form.dart';
import 'package:danaid/views/auths_views/login_view.dart';
import 'package:danaid/views/auths_views/otp_view.dart';
import 'package:danaid/views/auths_views/password_reset_view.dart';
import 'package:danaid/views/auths_views/profile_type_view.dart';
import 'package:danaid/views/auths_views/register_view.dart';
import 'package:danaid/views/auths_views/service_provider_form.dart';
import 'package:danaid/views/doctor_views/doctor_form_view.dart';
import 'package:danaid/views/adhrent_views/home_page_view.dart';
import 'package:danaid/views/adhrent_views/adherents_plans_screen/adherent_plan_screen.dart';
import 'package:danaid/views/screens/onboard_screen.dart';
import 'package:danaid/views/screens/splashscreen.dart';
import 'package:danaid/views/splash_screen.dart';
import 'package:danaid/views/adhrent_views/profile_edit.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  "/": (context) => Splashscreen(),
  "/splash": (context) => SplashScreen(),
  "/intro-view": (context) => OnboardScreen(),
  "/home": (context) => HomePageView(),
  "/login": (context) => LoginView(),
  "/register": (context) => RegisterView(),
  "/otp": (context) => OtpView(),
  "/reset-password": (context) => PasswordResetView(),
  "/profile-type": (context) => ProfileTypeView(),
  "/profile-type-adherent": (context) => AdherentPlanScreen(),
  "/adherent-reg-form": (context) => AdherentRegistrationFormm(),
  "/profile-type-doctor": (context) => DoctorFormView(),
  "/profile-type-sprovider": (context) => ServiceProviderForm(),
  "/adherent-profile-edit": (context) => ProfileEdit(),
};
