import 'package:danaid/views/adhrent_views/add_beneficiary_form.dart';
import 'package:danaid/views/adhrent_views/edit_beneficiary.dart';
import 'package:danaid/views/adhrent_views/appointment_form.dart';
import 'package:danaid/views/auths_views/adherent_form.dart';
import 'package:danaid/views/auths_views/login_view.dart';
import 'package:danaid/views/auths_views/otp_view.dart';
import 'package:danaid/views/auths_views/password_reset_view.dart';
import 'package:danaid/views/auths_views/profile_type_view.dart';
import 'package:danaid/views/auths_views/register_view.dart';
import 'package:danaid/views/auths_views/service_provider_form.dart';
import 'package:danaid/views/doctor_views/doctor_bottom_navigation_view.dart';
import 'package:danaid/views/doctor_views/doctor_form_view.dart';
import 'package:danaid/views/adhrent_views/home_page_view.dart';
import 'package:danaid/views/adhrent_views/adherents_plans_screen/adherent_plan_screen.dart';
import 'package:danaid/views/adhrent_views/appointment_detail.dart';
import 'package:danaid/views/adhrent_views/loans_view.dart';
import 'package:danaid/views/adhrent_views/loan_form.dart';
import 'package:danaid/views/adhrent_views/comparePlans.dart';
import 'package:danaid/views/adhrent_views/contributions.dart';
import 'package:danaid/views/adhrent_views/payment.dart';
import 'package:danaid/views/doctor_views/appointement_approuve.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/add_patient_views.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/inactive_account_views.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/owner_userList_View.dart';
import 'package:danaid/views/doctor_views/paiementHistory/prestationHistory.dart';
import 'package:danaid/views/doctor_views/paiementHistory/detailspaiement.dart';
import 'package:danaid/views/screens/onboard_screen.dart';
import 'package:danaid/views/screens/splashscreen.dart';
import 'package:danaid/views/social_network_views/chatroom.dart';
import 'package:danaid/views/social_network_views/home_page_social.dart';
import 'package:danaid/views/social_network_views/search.dart';
import 'package:danaid/views/splash_screen.dart';
import 'package:danaid/views/adhrent_views/profile_edit.dart';
import 'package:danaid/views/adhrent_views/doctor_profile.dart';
import 'package:danaid/views/adhrent_views/adherent_card.dart';
import 'package:danaid/views/adhrent_views/refund_form.dart';
import 'package:danaid/views/adhrent_views/use_case_details.dart';
import 'package:danaid/views/adhrent_views/coveragePayment.dart';
import 'package:danaid/views/doctor_views/prestataire_profil_page.dart';
import 'package:danaid/views/doctor_views/doctor_profile_edit.dart';
import 'package:danaid/views/serviceprovider/serviceprovider_profile_edit.dart';
import 'package:danaid/views/social_network_views/conversation.dart';
import 'package:danaid/views/social_network_views/create_publication.dart';
import 'package:danaid/views/social_network_views/create_group.dart';
import 'package:danaid/views/social_network_views/create_group_final.dart';
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
  "/doctor-profile": (context) => DoctorProfilePage(),
  "/add-beneficiary": (context) => AddBeneficiaryForm(),
  "/edit-beneficiary": (context) => EditBeneficiary(),
  "/rdv": (context) => AppointmentForm(),
  "/adherent-card": (context) => AdherentCard(),
  "/refund-form": (context) => RefundForm(),
  "/appointment": (context) => Appointment(),
  "/use-case": (context) => UseCaseDetails(),
  "/loans": (context) => Loans(),
  "/loan-form": (context) => LoanForm(),
  "/coverage-payment": (context) => CoveragePayment(),
  "/compare-plans": (context) => ComparePlans(),
  "/contributions": (context) => Contributions(),
  //"/payment": (context) => Payment(),

  /**
   * Start section routes that concern the doctor activities in the
   * application system
   */
  "/doctor-home": (context) => DoctorBottomNavigationView(),
  "/doctor-profile-edit": (context) => DoctorProfileEdit(),
  "/doctor-add-patient": (context) => AddPatientView(),
  "/inactive-account-patient": (context) => InactiveAccount(),
  "/ownerList-patient": (context) => OwnerUserListView(),
  "/history-prestation-doctor": (context) => PrestationHistory(),
  "/details-history-prestation-doctor": (context) => DetailsPrestationHistory(), 
 "/appointment-apointement": (context) => AppointmentDetails(),
  /**
   * End section routes that concern the doctor activities in the
   * application system
   */

  // Service provider routes (prestataire)
  "/serviceprovider-profile-edit": (context) => ServiceProviderProfileEdit(),
  "/serviceprovider-profile": (context) => PrestataireProfilePage(),

  // Social network screens
  "/social-home": (context) => SocialMediaHomePage(),
  "/conversation": (context) => Conversation(),
  "/chatroom": (context) => ChatRoom(),
  "/create-publication": (context) => CreatePublication(),
  "/search": (context) => Search(),
  "/create-group": (context) => CreateGroup(),
  "/create-group-final": (context) => CreateGroupFinalStep()
  
};
