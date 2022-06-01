import 'package:danaid/views/adhrent_views/add_beneficiary_form.dart';
import 'package:danaid/views/adhrent_views/edit_beneficiary.dart';
import 'package:danaid/views/adhrent_views/appointment_form.dart';
import 'package:danaid/views/adhrent_views/usecases.dart';
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
import 'package:danaid/views/adhrent_views/loan_details.dart';
import 'package:danaid/views/adhrent_views/comparePlans.dart';
import 'package:danaid/views/adhrent_views/contributions.dart';
import 'package:danaid/views/intro_slides.dart';
import 'package:danaid/views/adhrent_views/payment.dart';
import 'package:danaid/views/adhrent_views/family_points_page.dart';
import 'package:danaid/views/adhrent_views/family_badge_page.dart';
import 'package:danaid/views/adhrent_views/family_documents_page.dart';
import 'package:danaid/views/adhrent_views/family_stats_page.dart';
import 'package:danaid/views/doctor_views/appointement_approuve.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/add_patient_views.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/inactive_account_views.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/owner_userList_View.dart';
import 'package:danaid/views/doctor_views/paiementHistory/prestationHistory.dart';
import 'package:danaid/views/doctor_views/paiementHistory/detailspaiement.dart';
import 'package:danaid/views/screens/onboard_screen.dart';
import 'package:danaid/views/serviceprovider/Ordonance.dart';
import 'package:danaid/views/serviceprovider/OrdonancePatient.dart';
import 'package:danaid/views/serviceprovider/PrestationsEnCours.dart';
import 'package:danaid/views/serviceprovider/ScanPatient.dart';
import 'package:danaid/views/serviceprovider/create_Quote.dart';
import 'package:danaid/views/serviceprovider/edit-prestatire-profilt.dart';
import 'package:danaid/views/serviceprovider/paiementHistory/PrestationHistoryForProvider.dart';
import 'package:danaid/views/serviceprovider/services_provider_views/OwnerUserListViewServicesProviders.dart';
import 'package:danaid/views/social_network_views/ambassador_dashboard.dart';
import 'package:danaid/views/serviceprovider/services_provider_views/add_patient_views_service_Providers.dart';
import 'package:danaid/views/serviceprovider/services_provider_views/inactive_account_views_Providers.dart';
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
import 'package:danaid/views/adhrent_views/productDetails.dart';
import 'package:danaid/views/adhrent_views/partners_search_screen.dart';
import 'package:danaid/views/adhrent_views/notifications.dart';
import 'package:danaid/views/doctor_views/prestataire_profil_page.dart';
import 'package:danaid/views/doctor_views/doctor_profile_edit.dart';
import 'package:danaid/views/serviceprovider/serviceprovider_profile_edit.dart';
import 'package:danaid/views/social_network_views/conversation.dart';
import 'package:danaid/views/social_network_views/create_publication.dart';
import 'package:danaid/views/social_network_views/create_group.dart';
import 'package:danaid/views/social_network_views/create_group_final.dart';
import 'package:danaid/views/social_network_views/friend_requests.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../views/auths_views/email_login_view.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  "/": (context) => SplashScreen(),
  "/splash": (context) => SplashScreen(),
  "/intro-view": (context) => OnboardScreen(),
  "/home": (context) => HomePageView(),
  "/login": (context) => LoginView(),
  "/login-email": (context) => const EmailLoginView(),
  "/register": (context) => RegisterView(),
  "/otp": (context) =>  OtpView(),
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
  "/loan-details": (context) => LoanDetails(),
  "/coverage-payment": (context) => CoveragePayment(),
  "/compare-plans": (context) => ComparePlans(),
  "/contributions": (context) => Contributions(),
  "/intro-slides": (context) => IntroSlides(),
  "/family-points-page": (context) => FamilyPointsPage(),
  "/family-badge-page": (context) => FamilyBadgePage(),
  "/family-documents-page": (context) => FamilyDocumentsPage(),
  "/family-stats-page": (context) => FamilyStatsPage(),
  "/product-details": (context) => ProductDetails(),
  "/partners-search": (context) => PartnersSearchScreen(),
  "/friend-requests": (context) => FriendRequests(),
  "/notifications": (context) => Notifications(),
  "/usecases": (context) => UseCaseList(),
  //"/payment": (context) => Payment(),

  /**
   * Start section routes that concern the doctor activities in the
   * application system
   */
  "/doctor-home": (context) => DoctorBottomNavigationView(),
  "/doctor-profile-edit": (context) => DoctorProfileEdit(),
  "/doctor-add-patient": (context) => AddPatientView(isLaunchConsultation: true,),
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
  "/serviceprovider-profile-edit": (context) => EditPrestataire(),
  "/serviceprovider-profile": (context) => PrestataireProfilePage(),
  "/QuoteEmit-serviceprovider": (context) => CreateQuote(),
  "/history-prestation-serviceProvider": (context) => PrestationHistoryForProvider(),
  "/scanPatient-serviceprovider": (context) => ScanPatient(),
  "/prestationEncours-serviceprovider": (context) => PrestationEnCours(),
  "/ordonanceDuPatient-serviceprovider": (context) => OrdonanceDuPatient(),
  "/ordonance-serviceprovider": (context) => Ordonances(),
  "/serviceprovider-add-patient": (context) => AddPatientViewServiceProvider(),
  "/inactive-account-patient-serviceProviders": (context) => InactiveAccountProvider(),
  "/ownerList-patient-restataire": (context) => OwnerUserListViewServicesProviders(),

  // Social network screens
  "/social-home": (context) => SocialMediaHomePage(),
  "/conversation": (context) => Conversation(),
  "/chatroom": (context) => ChatRoom(),
  "/create-publication": (context) => CreatePublication(),
  "/search": (context) => Search(),
  "/create-group": (context) => CreateGroup(),
  "/create-group-final": (context) => CreateGroupFinalStep(),
  "/ambassador-dashboard": (context) => AmbassadorDashboard(),
};
  final  router = GoRouter(
    debugLogDiagnostics:true,
    urlPathStrategy: UrlPathStrategy.path,
    errorPageBuilder: (context, state)=> MaterialPage(
        key:state.pageKey,
        child: Text(state.error.toString())
      ),
    routes: [
      GoRoute(path: '/',pageBuilder: (context, state) =>  MaterialPage(
        key:state.pageKey,
        child: SplashScreen()
      ),), 
      GoRoute(path: '/splash',pageBuilder: (context, state) =>   MaterialPage(
        key:state.pageKey,
        child: Splashscreen(),)
      ),
      GoRoute(path: '/intro-view',builder: (context, state) =>  OnboardScreen(),),
      GoRoute(path: '/home',builder: (context, state) =>  HomePageView(),),
      GoRoute(path: '/login',builder: (context, state) =>  LoginView(),),
      GoRoute(path: '/RegisterView',builder: (context, state) =>  RegisterView(),),
      GoRoute(path: '/otp',builder: (context, state) =>   PasswordResetView(),),
      GoRoute(path: '/reset-password',builder: (context, state) =>  PasswordResetView(),),
      GoRoute(path: '/profile-type',builder: (context, state) =>  ProfileTypeView(),),
      GoRoute(path: '/profile-type-adherent',builder: (context, state) =>  AdherentPlanScreen(),),
      GoRoute(path: '/adherent-reg-form',builder: (context, state) =>  AdherentRegistrationFormm(),),
      GoRoute(path: '/profile-type-doctor',builder: (context, state) =>  DoctorFormView(),),
      GoRoute(path: '/profile-type-sprovider',builder: (context, state) =>  ServiceProviderForm(),),
      GoRoute(path: '/adherent-profile-edit',builder: (context, state) =>  ProfileEdit(),),
      GoRoute(path: '/doctor-profile',builder: (context, state) =>  DoctorProfilePage(),),
      GoRoute(path: '/add-beneficiary',builder: (context, state) => AddBeneficiaryForm(),),
      GoRoute(path: '/edit-beneficiary',builder: (context, state) => EditBeneficiary(),),
      GoRoute(path: '/rdv',builder: (context, state) => AppointmentForm(),),
      GoRoute(path: '/adherent-card',builder: (context, state) => AdherentCard(),),
      GoRoute(path: '/refund-form',builder: (context, state) => RefundForm(),),
      GoRoute(path: '/appointment',builder: (context, state) => Appointment(),),
      GoRoute(path: '/use-case',builder: (context, state) => UseCaseDetails(),),
      GoRoute(path: '/loans',builder: (context, state) => Loans(),),
      GoRoute(path: '/loans',builder: (context, state) => Loans(),),
      GoRoute(path: '/loan-form',builder: (context, state) => LoanForm(),),
      GoRoute(path: '/loan-details',builder: (context, state) => LoanDetails(),),
      GoRoute(path: '/coverage-payment',builder: (context, state) => CoveragePayment(),),
      GoRoute(path: '/compare-plans',builder: (context, state) => ComparePlans(),),
      GoRoute(path: '/contributions',builder: (context, state) => Contributions(),),
      GoRoute(path: '/intro-slides',builder: (context, state) => IntroSlides(),),
      GoRoute(path: '/family-points-page',builder: (context, state) => FamilyPointsPage(),),
      GoRoute(path: '/family-badge-page',builder: (context, state) => FamilyBadgePage(),),
      GoRoute(path: '/family-documents-page',builder: (context, state) => FamilyDocumentsPage(),),
      GoRoute(path: '/family-stats-page',builder: (context, state) => FamilyStatsPage(),),
      GoRoute(path: '/product-details',builder: (context, state) => ProductDetails(),),
      GoRoute(path: '/partners-search',builder: (context, state) => PartnersSearchScreen(),),
      GoRoute(path: '/friend-requests',builder: (context, state) => FriendRequests(),),
      GoRoute(path: '/notifications',builder: (context, state) => Notifications(),),
      GoRoute(path: '/usecases',builder: (context, state) => UseCaseList(),),
      /**
     * Start section routes that concern the doctor activities in the
     * application system
     */
      GoRoute(path: '/doctor-home',builder: (context, state) => DoctorBottomNavigationView(),),
      GoRoute(path: '/doctor-profile-edit',builder: (context, state) => DoctorProfileEdit(),),
      GoRoute(path: '/doctor-add-patient',builder: (context, state) => AddPatientView(isLaunchConsultation: true,),),
      GoRoute(path: '/inactive-account-patient',builder: (context, state) => InactiveAccount()),
      GoRoute(path: '/ownerList-patient',builder: (context, state) => OwnerUserListView()),
      GoRoute(path: '/history-prestation-doctor',builder: (context, state) => PrestationHistory()),
      GoRoute(path: '/details-history-prestation-doctor',builder: (context, state) => DetailsPrestationHistory()),
      GoRoute(path: '/appointment-apointement',builder: (context, state) => AppointmentDetails()),
      /**
     * Service provider routes (prestataire)
     */
      GoRoute(path: '/serviceprovider-profile-edit',builder: (context, state) => EditPrestataire(),),
      GoRoute(path: '/serviceprovider-profile',builder: (context, state) => PrestataireProfilePage(),),
      GoRoute(path: '/QuoteEmit-serviceprovider',builder: (context, state) => CreateQuote(),),
      GoRoute(path: '/history-prestation-serviceProvider',builder: (context, state) => PrestationHistoryForProvider(),),
      GoRoute(path: '/scanPatient-serviceprovider',builder: (context, state) => ScanPatient(),),
      GoRoute(path: '/prestationEncours-serviceprovider',builder: (context, state) => PrestationEnCours(),),
      GoRoute(path: '/ordonanceDuPatient-serviceprovider',builder: (context, state) => OrdonanceDuPatient(),),
      GoRoute(path: '/ordonance-serviceprovider',builder: (context, state) => Ordonances(),),
      GoRoute(path: '/serviceprovider-add-patient',builder: (context, state) => AddPatientViewServiceProvider(),),
      GoRoute(path: '/inactive-account-patient-serviceProviders',builder: (context, state) => InactiveAccountProvider(),),
      GoRoute(path: '/serviceprovider-add-patient',builder: (context, state) => OwnerUserListViewServicesProviders(),),
       /**
     * Social network screens
     */
      GoRoute(path: '/social-home',builder: (context, state) => SocialMediaHomePage(),),
      GoRoute(path: '/conversation',builder: (context, state) => Conversation(),),
      GoRoute(path: '/chatroom',builder: (context, state) => ChatRoom(),),
      GoRoute(path: '/create-publication',builder: (context, state) => CreatePublication(),),
      GoRoute(path: '/search',builder: (context, state) => Search(),),
      GoRoute(path: '/create-group',builder: (context, state) => CreateGroup(),),
      GoRoute(path: '/create-group-final',builder: (context, state) => CreateGroupFinalStep(),),
      GoRoute(path: '/ambassador-dashboard',builder: (context, state) => AmbassadorDashboard(),),
    ],
  );
