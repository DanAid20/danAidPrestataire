import 'package:danaid/views/auths_views/login_view.dart';
import 'package:danaid/views/auths_views/otp_view.dart';
import 'package:danaid/views/auths_views/password_reset_view.dart';
import 'package:danaid/views/auths_views/register_view.dart';
import 'package:danaid/views/home_page_view.dart';
import 'package:danaid/views/screens/onboard_screen.dart';
import 'package:danaid/views/screens/splashscreen.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  "/": (context) => Splashscreen(),
  "/intro-view": (context) => OnboardScreen(),
  "/home": (context) => HomePageView(),
  "/login": (context) => LoginView(),
  "/register": (context) => RegisterView(),
  "/otp": (context) => OtpView(),
  "/reset-password": (context) => PasswordResetView(),
};
