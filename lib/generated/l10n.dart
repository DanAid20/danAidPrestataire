// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

<<<<<<< HEAD
  static Future<S>? load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
=======
  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
>>>>>>> bfc741bbc8e58f632ef37bde68a5429b144da125
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `you have no appointment for the moment ..`
  String get vousNavezAucunRendezvousPourLeMoment {
    return Intl.message(
      'you have no appointment for the moment ..',
      name: 'vousNavezAucunRendezvousPourLeMoment',
      desc: '',
      args: [],
    );
  }

  /// `loading`
  String get loading {
    return Intl.message(
      'loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Add a Patient`
  String get ajouterUnPatient {
    return Intl.message(
      'Add a Patient',
      name: 'ajouterUnPatient',
      desc: '',
      args: [],
    );
  }

  /// `My Messages`
  String get mesMessages {
    return Intl.message(
      'My Messages',
      name: 'mesMessages',
      desc: '',
      args: [],
    );
  }

  /// `Follow my payments`
  String get suivreMesPaiements {
    return Intl.message(
      'Follow my payments',
      name: 'suivreMesPaiements',
      desc: '',
      args: [],
    );
  }

  /// `a little patience this part will be available soon`
  String get unPeuDePatienceCettePartieSeraBienttDisponible {
    return Intl.message(
      'a little patience this part will be available soon',
      name: 'unPeuDePatienceCettePartieSeraBienttDisponible',
      desc: '',
      args: [],
    );
  }

  /// `issue a quote`
  String get emettreUnDevis {
    return Intl.message(
      'issue a quote',
      name: 'emettreUnDevis',
      desc: '',
      args: [],
    );
  }

  /// `access the digital health record of your patients and initiate their care`
  String get accdezAuCarnetDeSantDigitalDeVosPatientsEt {
    return Intl.message(
      'access the digital health record of your patients and initiate their care',
      name: 'accdezAuCarnetDeSantDigitalDeVosPatientsEt',
      desc: '',
      args: [],
    );
  }

  /// `Check the status of payments before performing services to a member`
  String get vrifierLeStatutDesPaiementsAvantDeRaliserLesServices {
    return Intl.message(
      'Check the status of payments before performing services to a member',
      name: 'vrifierLeStatutDesPaiementsAvantDeRaliserLesServices',
      desc: '',
      args: [],
    );
  }

  /// `Start a consultation`
  String get dmarrerUneConsultation {
    return Intl.message(
      'Start a consultation',
      name: 'dmarrerUneConsultation',
      desc: '',
      args: [],
    );
  }

  /// `complete a support`
  String get complterUnePriseEnCharge {
    return Intl.message(
      'complete a support',
      name: 'complterUnePriseEnCharge',
      desc: '',
      args: [],
    );
  }

  /// `Appointment requests`
  String get demandesDeRdv {
    return Intl.message(
      'Appointment requests',
      name: 'demandesDeRdv',
      desc: '',
      args: [],
    );
  }

  /// `See more ..`
  String get voirPlus {
    return Intl.message(
      'See more ..',
      name: 'voirPlus',
      desc: '',
      args: [],
    );
  }

  /// `no appointment for the moment ...`
  String get aucunRendezvousPourLinstant {
    return Intl.message(
      'no appointment for the moment ...',
      name: 'aucunRendezvousPourLinstant',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `complete`
  String get completer {
    return Intl.message(
      'complete',
      name: 'completer',
      desc: '',
      args: [],
    );
  }

  /// `please complete your profile information to help us get to know you better`
  String get veuillezCompleterLesInformationsRelaifAVotreProfilPourNous {
    return Intl.message(
      'please complete your profile information to help us get to know you better',
      name: 'veuillezCompleterLesInformationsRelaifAVotreProfilPourNous',
      desc: '',
      args: [],
    );
  }

  /// `No Notification`
  String get aucuneNotification {
    return Intl.message(
      'No Notification',
      name: 'aucuneNotification',
      desc: '',
      args: [],
    );
  }

  /// `Question to the Doctor`
  String get questionAuDocteur {
    return Intl.message(
      'Question to the Doctor',
      name: 'questionAuDocteur',
      desc: '',
      args: [],
    );
  }

  /// `yes I approve`
  String get ouiJapprouve {
    return Intl.message(
      'yes I approve',
      name: 'ouiJapprouve',
      desc: '',
      args: [],
    );
  }

  /// `make you approve`
  String get rendevousApprouver {
    return Intl.message(
      'make you approve',
      name: 'rendevousApprouver',
      desc: '',
      args: [],
    );
  }

  /// `Infos`
  String get infos {
    return Intl.message(
      'Infos',
      name: 'infos',
      desc: '',
      args: [],
    );
  }

  /// `you are about to approve this appointment, are you sure of this operation?`
  String get vousTesSurLePointDapprouverCeRendezvousTesvousSr {
    return Intl.message(
      'you are about to approve this appointment, are you sure of this operation?',
      name: 'vousTesSurLePointDapprouverCeRendezvousTesvousSr',
      desc: '',
      args: [],
    );
  }

  /// `No Member available for the moment ..`
  String get aucunAdherentDisponiblePourLeMoment {
    return Intl.message(
      'No Member available for the moment ..',
      name: 'aucunAdherentDisponiblePourLeMoment',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get aujourdhui {
    return Intl.message(
      'Today',
      name: 'aujourdhui',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get semaine {
    return Intl.message(
      'Week',
      name: 'semaine',
      desc: '',
      args: [],
    );
  }

  /// `No appointment in sight for the moment`
  String get aucunRendezvousEnVuePourLinstant {
    return Intl.message(
      'No appointment in sight for the moment',
      name: 'aucunRendezvousEnVuePourLinstant',
      desc: '',
      args: [],
    );
  }

  /// `waiting room`
  String get salleDattente {
    return Intl.message(
      'waiting room',
      name: 'salleDattente',
      desc: '',
      args: [],
    );
  }

  /// `No activity has been recorded for the moment ...`
  String get aucuneActivitNasTEnregistrerPourLinstant {
    return Intl.message(
      'No activity has been recorded for the moment ...',
      name: 'aucuneActivitNasTEnregistrerPourLinstant',
      desc: '',
      args: [],
    );
  }

  /// `The Code this consultation successfully created as a family doctor ..`
  String get leCodeCeConsultationCreerAvecSuccesCommeMdecinDe {
    return Intl.message(
      'The Code this consultation successfully created as a family doctor ..',
      name: 'leCodeCeConsultationCreerAvecSuccesCommeMdecinDe',
      desc: '',
      args: [],
    );
  }

  /// `The invoice was successfully generated`
  String get laFactureABienEteGenererAvecSucces {
    return Intl.message(
      'The invoice was successfully generated',
      name: 'laFactureABienEteGenererAvecSucces',
      desc: '',
      args: [],
    );
  }

  /// `support request`
  String get dmandeDePriseEnCharge {
    return Intl.message(
      'support request',
      name: 'dmandeDePriseEnCharge',
      desc: '',
      args: [],
    );
  }

  /// `Rendezvous`
  String get rendezvous {
    return Intl.message(
      'Rendezvous',
      name: 'rendezvous',
      desc: '',
      args: [],
    );
  }

  /// `For the patient`
  String get pourLePatient {
    return Intl.message(
      'For the patient',
      name: 'pourLePatient',
      desc: '',
      args: [],
    );
  }

  /// `    Rendezvous at`
  String get rendezvousChez {
    return Intl.message(
      '    Rendezvous at',
      name: 'rendezvousChez',
      desc: '',
      args: [],
    );
  }

  /// `Family doctor, `
  String get medecinDeFamille {
    return Intl.message(
      'Family doctor, ',
      name: 'medecinDeFamille',
      desc: '',
      args: [],
    );
  }

  /// `what is the reason? `
  String get quelEnEstLaRaison {
    return Intl.message(
      'what is the reason? ',
      name: 'quelEnEstLaRaison',
      desc: '',
      args: [],
    );
  }

  /// `Symptoms`
  String get symptmes {
    return Intl.message(
      'Symptoms',
      name: 'symptmes',
      desc: '',
      args: [],
    );
  }

  /// `No symptoms mentioned`
  String get aucunSymptmesMentions {
    return Intl.message(
      'No symptoms mentioned',
      name: 'aucunSymptmesMentions',
      desc: '',
      args: [],
    );
  }

  /// `Approve`
  String get approuver {
    return Intl.message(
      'Approve',
      name: 'approuver',
      desc: '',
      args: [],
    );
  }

  /// `An invoice has already been generated for this constultation`
  String get uneFactureADejaTGnererPourCetteConstultation {
    return Intl.message(
      'An invoice has already been generated for this constultation',
      name: 'uneFactureADejaTGnererPourCetteConstultation',
      desc: '',
      args: [],
    );
  }

  /// `Reject `
  String get rejeter {
    return Intl.message(
      'Reject ',
      name: 'rejeter',
      desc: '',
      args: [],
    );
  }

  /// `The advertisement has been rejected ..`
  String get lannonceATRejeter {
    return Intl.message(
      'The advertisement has been rejected ..',
      name: 'lannonceATRejeter',
      desc: '',
      args: [],
    );
  }

  /// `put on hold`
  String get mettreEnAttente {
    return Intl.message(
      'put on hold',
      name: 'mettreEnAttente',
      desc: '',
      args: [],
    );
  }

  /// `this appointment has been put on hold ..`
  String get ceRendezvousATMisEnAttente {
    return Intl.message(
      'this appointment has been put on hold ..',
      name: 'ceRendezvousATMisEnAttente',
      desc: '',
      args: [],
    );
  }

  /// `mutual aid`
  String get entraide {
    return Intl.message(
      'mutual aid',
      name: 'entraide',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get accueil {
    return Intl.message(
      'Home',
      name: 'accueil',
      desc: '',
      args: [],
    );
  }

  /// `My Patients`
  String get mesPatients {
    return Intl.message(
      'My Patients',
      name: 'mesPatients',
      desc: '',
      args: [],
    );
  }

  /// `Partners`
  String get partenaires {
    return Intl.message(
      'Partners',
      name: 'partenaires',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `The DanAid family doctor ensures the long-term follow-up of your family's health. His action allows you to benefit from quality care at a controlled cost. \ nThe family doctor will be the first point of contact for your family. your family with health services. \ nThe DanAid family doctor ensures the long-term follow-up of your family's health. His action allows you to benefit from quality care at a controlled cost. \ nThe family doctor will be the Your family's first point of contact with health services. \ n \ nThe DanAid family doctor provides long-term monitoring of your family's health, and its action allows you to benefit from quality care at a controlled cost. \ nThe family doctor will be your family's first point of contact with health services. \ nThe DanAid family doctor ensures the long-term follow-up of your family's health. quality to co is under control. \ nThe family doctor will be your family's first point of contact with health services. \ nThe DanAid family doctor provides long-term follow-up of the s `
  String get leMdecinDeFamilleDanaidAssureLeSuiviLongTerme {
    return Intl.message(
      'The DanAid family doctor ensures the long-term follow-up of your family\'s health. His action allows you to benefit from quality care at a controlled cost. \\ nThe family doctor will be the first point of contact for your family. your family with health services. \\ nThe DanAid family doctor ensures the long-term follow-up of your family\'s health. His action allows you to benefit from quality care at a controlled cost. \\ nThe family doctor will be the Your family\'s first point of contact with health services. \\ n \\ nThe DanAid family doctor provides long-term monitoring of your family\'s health, and its action allows you to benefit from quality care at a controlled cost. \\ nThe family doctor will be your family\'s first point of contact with health services. \\ nThe DanAid family doctor ensures the long-term follow-up of your family\'s health. quality to co is under control. \\ nThe family doctor will be your family\'s first point of contact with health services. \\ nThe DanAid family doctor provides long-term follow-up of the s ',
      name: 'leMdecinDeFamilleDanaidAssureLeSuiviLongTerme',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continuer {
    return Intl.message(
      'Continue',
      name: 'continuer',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get retour {
    return Intl.message(
      'Return',
      name: 'retour',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get envoyer {
    return Intl.message(
      'Send',
      name: 'envoyer',
      desc: '',
      args: [],
    );
  }

  /// `Last Name *`
  String get nomDeFamille {
    return Intl.message(
      'Last Name *',
      name: 'nomDeFamille',
      desc: '',
      args: [],
    );
  }

  /// `Enter your last name`
  String get entrezVotreNomDeFamille {
    return Intl.message(
      'Enter your last name',
      name: 'entrezVotreNomDeFamille',
      desc: '',
      args: [],
    );
  }

  /// `This field is require`
  String get ceChampEstObligatoire {
    return Intl.message(
      'This field is require',
      name: 'ceChampEstObligatoire',
      desc: '',
      args: [],
    );
  }

  /// `Firstname (s)`
  String get prnomS {
    return Intl.message(
      'Firstname (s)',
      name: 'prnomS',
      desc: '',
      args: [],
    );
  }

  /// `Enter your first name`
  String get entrezVotrePrnom {
    return Intl.message(
      'Enter your first name',
      name: 'entrezVotrePrnom',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get entrezVotreAddresseEmail {
    return Intl.message(
      'Enter your email address',
      name: 'entrezVotreAddresseEmail',
      desc: '',
      args: [],
    );
  }

  /// `Genre *`
  String get genre {
    return Intl.message(
      'Genre *',
      name: 'genre',
      desc: '',
      args: [],
    );
  }

  /// `male`
  String get masculin {
    return Intl.message(
      'male',
      name: 'masculin',
      desc: '',
      args: [],
    );
  }

  /// `female`
  String get fminin {
    return Intl.message(
      'female',
      name: 'fminin',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth *`
  String get dateDeNaissance {
    return Intl.message(
      'Date of birth *',
      name: 'dateDeNaissance',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get choisir {
    return Intl.message(
      'Choose',
      name: 'choisir',
      desc: '',
      args: [],
    );
  }

  /// `Are you a generalist or specialist?`
  String get tesVousGnralisteOuSpcialiste {
    return Intl.message(
      'Are you a generalist or specialist?',
      name: 'tesVousGnralisteOuSpcialiste',
      desc: '',
      args: [],
    );
  }

  /// `Généraliste`
  String get gnraliste {
    return Intl.message(
      'Généraliste',
      name: 'gnraliste',
      desc: '',
      args: [],
    );
  }

  /// `Specialist`
  String get spcialiste {
    return Intl.message(
      'Specialist',
      name: 'spcialiste',
      desc: '',
      args: [],
    );
  }

  /// `Specialty`
  String get spcialit {
    return Intl.message(
      'Specialty',
      name: 'spcialit',
      desc: '',
      args: [],
    );
  }

  /// `eg: Pediatrician`
  String get exPdiatre {
    return Intl.message(
      'eg: Pediatrician',
      name: 'exPdiatre',
      desc: '',
      args: [],
    );
  }

  /// `Hospital name`
  String get nomDeLhpital {
    return Intl.message(
      'Hospital name',
      name: 'nomDeLhpital',
      desc: '',
      args: [],
    );
  }

  /// `eg: Hôpitale Générale`
  String get exHpitaleGnrale {
    return Intl.message(
      'eg: Hôpitale Générale',
      name: 'exHpitaleGnrale',
      desc: '',
      args: [],
    );
  }

  /// `Type of establishment`
  String get typeDtablissement {
    return Intl.message(
      'Type of establishment',
      name: 'typeDtablissement',
      desc: '',
      args: [],
    );
  }

  /// `Public`
  String get publique {
    return Intl.message(
      'Public',
      name: 'publique',
      desc: '',
      args: [],
    );
  }

  /// `PUBLIC`
  String get public {
    return Intl.message(
      'PUBLIC',
      name: 'public',
      desc: '',
      args: [],
    );
  }

  /// `Confessional`
  String get confessionel {
    return Intl.message(
      'Confessional',
      name: 'confessionel',
      desc: '',
      args: [],
    );
  }

  /// `Private`
  String get priv {
    return Intl.message(
      'Private',
      name: 'priv',
      desc: '',
      args: [],
    );
  }

  /// `PRIVATE`
  String get private {
    return Intl.message(
      'PRIVATE',
      name: 'private',
      desc: '',
      args: [],
    );
  }

  /// `Profile Physician created ..`
  String get profilMdcinCre {
    return Intl.message(
      'Profile Physician created ..',
      name: 'profilMdcinCre',
      desc: '',
      args: [],
    );
  }

  /// `No selected image`
  String get aucuneImageSelectionne {
    return Intl.message(
      'No selected image',
      name: 'aucuneImageSelectionne',
      desc: '',
      args: [],
    );
  }

  /// `Profile photo added`
  String get photoDeProfilAjoute {
    return Intl.message(
      'Profile photo added',
      name: 'photoDeProfilAjoute',
      desc: '',
      args: [],
    );
  }

  /// `Terms of service`
  String get termesDeServices {
    return Intl.message(
      'Terms of service',
      name: 'termesDeServices',
      desc: '',
      args: [],
    );
  }

  /// `Fermer`
  String get fermer {
    return Intl.message(
      'Fermer',
      name: 'fermer',
      desc: '',
      args: [],
    );
  }

  /// `Name as on the CNI`
  String get nomTelQueSurLaCni {
    return Intl.message(
      'Name as on the CNI',
      name: 'nomTelQueSurLaCni',
      desc: '',
      args: [],
    );
  }

  /// `CNI name`
  String get nomCni {
    return Intl.message(
      'CNI name',
      name: 'nomCni',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get aPropos {
    return Intl.message(
      'About',
      name: 'aPropos',
      desc: '',
      args: [],
    );
  }

  /// `Speak briefly about yourself ..`
  String get parlezBrivementDeVous {
    return Intl.message(
      'Speak briefly about yourself ..',
      name: 'parlezBrivementDeVous',
      desc: '',
      args: [],
    );
  }

  /// `Your address`
  String get votreAddresse {
    return Intl.message(
      'Your address',
      name: 'votreAddresse',
      desc: '',
      args: [],
    );
  }

  /// `Eg: Carrefour TKC, Biyem-Assi`
  String get exCarrefourTkcBiyemassi {
    return Intl.message(
      'Eg: Carrefour TKC, Biyem-Assi',
      name: 'exCarrefourTkcBiyemassi',
      desc: '',
      args: [],
    );
  }

  /// `GPS:`
  String get gps {
    return Intl.message(
      'GPS:',
      name: 'gps',
      desc: '',
      args: [],
    );
  }

  /// `Lat: `
  String get lat {
    return Intl.message(
      'Lat: ',
      name: 'lat',
      desc: '',
      args: [],
    );
  }

  /// `     Lng: `
  String get lng {
    return Intl.message(
      '     Lng: ',
      name: 'lng',
      desc: '',
      args: [],
    );
  }

  /// `Add my location`
  String get ajouterMaLocalisation {
    return Intl.message(
      'Add my location',
      name: 'ajouterMaLocalisation',
      desc: '',
      args: [],
    );
  }

  /// `NB: The addition of the rental is required for the validation of the form`
  String get nbLajoutDeLaLocationEstRquisePourLaValidation {
    return Intl.message(
      'NB: The addition of the rental is required for the validation of the form',
      name: 'nbLajoutDeLaLocationEstRquisePourLaValidation',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get statut {
    return Intl.message(
      'Status',
      name: 'statut',
      desc: '',
      args: [],
    );
  }

  /// `ex: Surgeon`
  String get exChirurgien {
    return Intl.message(
      'ex: Surgeon',
      name: 'exChirurgien',
      desc: '',
      args: [],
    );
  }

  /// `Order registration number`
  String get numroDenrgistrementLordre {
    return Intl.message(
      'Order registration number',
      name: 'numroDenrgistrementLordre',
      desc: '',
      args: [],
    );
  }

  /// `Your number`
  String get votreMatricule {
    return Intl.message(
      'Your number',
      name: 'votreMatricule',
      desc: '',
      args: [],
    );
  }

  /// `Your price per hour`
  String get votreTarifParHeure {
    return Intl.message(
      'Your price per hour',
      name: 'votreTarifParHeure',
      desc: '',
      args: [],
    );
  }

  /// `ex: 3500`
  String get ex3500 {
    return Intl.message(
      'ex: 3500',
      name: 'ex3500',
      desc: '',
      args: [],
    );
  }

  /// `Name of your establishment`
  String get nomDeVotreTablissement {
    return Intl.message(
      'Name of your establishment',
      name: 'nomDeVotreTablissement',
      desc: '',
      args: [],
    );
  }

  /// `ex: District Hospital of Limbé`
  String get exHpitalDeDistrictDeLimb {
    return Intl.message(
      'ex: District Hospital of Limbé',
      name: 'exHpitalDeDistrictDeLimb',
      desc: '',
      args: [],
    );
  }

  /// `Select your schedules`
  String get slectionnezVosHoraires {
    return Intl.message(
      'Select your schedules',
      name: 'slectionnezVosHoraires',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get jours {
    return Intl.message(
      'Days',
      name: 'jours',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get dbut {
    return Intl.message(
      'Start',
      name: 'dbut',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get fin {
    return Intl.message(
      'End',
      name: 'fin',
      desc: '',
      args: [],
    );
  }

  /// `Monday to Friday`
  String get lundiVendredi {
    return Intl.message(
      'Monday to Friday',
      name: 'lundiVendredi',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get samedi {
    return Intl.message(
      'Saturday',
      name: 'samedi',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get dimanche {
    return Intl.message(
      'Sunday',
      name: 'dimanche',
      desc: '',
      args: [],
    );
  }

  /// `Select your services`
  String get slectionnezVosServices {
    return Intl.message(
      'Select your services',
      name: 'slectionnezVosServices',
      desc: '',
      args: [],
    );
  }

  /// `Consultation`
  String get consultation {
    return Intl.message(
      'Consultation',
      name: 'consultation',
      desc: '',
      args: [],
    );
  }

  /// `Remote consultation`
  String get tlconsultation {
    return Intl.message(
      'Remote consultation',
      name: 'tlconsultation',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `Home visit`
  String get visiteDomicile {
    return Intl.message(
      'Home visit',
      name: 'visiteDomicile',
      desc: '',
      args: [],
    );
  }

  /// `Supporting documents`
  String get picesJustificatives {
    return Intl.message(
      'Supporting documents',
      name: 'picesJustificatives',
      desc: '',
      args: [],
    );
  }

  /// `Scan of the identity document (CNI, Passport, etc.)`
  String get scanDeLaPiceDidentitCniPassportEtc {
    return Intl.message(
      'Scan of the identity document (CNI, Passport, etc.)',
      name: 'scanDeLaPiceDidentitCniPassportEtc',
      desc: '',
      args: [],
    );
  }

  /// `Certificate of registration to order`
  String get certificatDenrgistrementLordre {
    return Intl.message(
      'Certificate of registration to order',
      name: 'certificatDenrgistrementLordre',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get mettreJour {
    return Intl.message(
      'Update',
      name: 'mettreJour',
      desc: '',
      args: [],
    );
  }

  /// `Information updates ..`
  String get informationsMisesJour {
    return Intl.message(
      'Information updates ..',
      name: 'informationsMisesJour',
      desc: '',
      args: [],
    );
  }

  /// `No document selected`
  String get aucunDocumentSelectionne {
    return Intl.message(
      'No document selected',
      name: 'aucunDocumentSelectionne',
      desc: '',
      args: [],
    );
  }

  /// `added`
  String get ajoute {
    return Intl.message(
      'added',
      name: 'ajoute',
      desc: '',
      args: [],
    );
  }

  /// `Saved Document`
  String get documentSauvegard {
    return Intl.message(
      'Saved Document',
      name: 'documentSauvegard',
      desc: '',
      args: [],
    );
  }

  /// `Services Offered`
  String get servicesOfferts {
    return Intl.message(
      'Services Offered',
      name: 'servicesOfferts',
      desc: '',
      args: [],
    );
  }

  /// `January to March`
  String get janvierMars {
    return Intl.message(
      'January to March',
      name: 'janvierMars',
      desc: '',
      args: [],
    );
  }

  /// `April to June `
  String get avrilJuin {
    return Intl.message(
      'April to June ',
      name: 'avrilJuin',
      desc: '',
      args: [],
    );
  }

  /// `July to September`
  String get juilletSeptembre {
    return Intl.message(
      'July to September',
      name: 'juilletSeptembre',
      desc: '',
      args: [],
    );
  }

  /// `October to December`
  String get octobreDcembre {
    return Intl.message(
      'October to December',
      name: 'octobreDcembre',
      desc: '',
      args: [],
    );
  }

  /// `H`
  String get h {
    return Intl.message(
      'H',
      name: 'h',
      desc: '',
      args: [],
    );
  }

  /// `F`
  String get f {
    return Intl.message(
      'F',
      name: 'f',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get region {
    return Intl.message(
      'Region',
      name: 'region',
      desc: '',
      args: [],
    );
  }

  /// `Choose a region`
  String get choisirUneRegion {
    return Intl.message(
      'Choose a region',
      name: 'choisirUneRegion',
      desc: '',
      args: [],
    );
  }

  /// `Choose City`
  String get choixDeLaVille {
    return Intl.message(
      'Choose City',
      name: 'choixDeLaVille',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get ville {
    return Intl.message(
      'City',
      name: 'ville',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallerie {
    return Intl.message(
      'Gallery',
      name: 'gallerie',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get chercher {
    return Intl.message(
      'Search...',
      name: 'chercher',
      desc: '',
      args: [],
    );
  }

  /// `Select your country`
  String get selectionnezVotrePays {
    return Intl.message(
      'Select your country',
      name: 'selectionnezVotrePays',
      desc: '',
      args: [],
    );
  }

  /// `Select your country`
  String get slectionnezVotrePays {
    return Intl.message(
      'Select your country',
      name: 'slectionnezVotrePays',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid phone number`
  String get entrerUnNumeroDeTlphoneValide {
    return Intl.message(
      'Enter a valid phone number',
      name: 'entrerUnNumeroDeTlphoneValide',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get numroDeTlphone {
    return Intl.message(
      'Phone number',
      name: 'numroDeTlphone',
      desc: '',
      args: [],
    );
  }

  /// `Phone number automatically verified and user signed in:`
  String get phoneNumberAutomaticallyVerifiedAndUserSignedIn {
    return Intl.message(
      'Phone number automatically verified and user signed in:',
      name: 'phoneNumberAutomaticallyVerifiedAndUserSignedIn',
      desc: '',
      args: [],
    );
  }

  /// `Please check your phone for the verification code.`
  String get pleaseCheckYourPhoneForTheVerificationCode {
    return Intl.message(
      'Please check your phone for the verification code.',
      name: 'pleaseCheckYourPhoneForTheVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Le code viens d'arriver, patientez encore unpeu ...`
  String get leCodeViensDarriverPatientezEncoreUnpeu {
    return Intl.message(
      'Le code viens d\'arriver, patientez encore unpeu ...',
      name: 'leCodeViensDarriverPatientezEncoreUnpeu',
      desc: '',
      args: [],
    );
  }

  /// `Failed to Verify Phone Number:`
  String get phoneNumberVerificationFailedCode {
    return Intl.message(
      'Failed to Verify Phone Number:',
      name: 'phoneNumberVerificationFailedCode',
      desc: '',
      args: [],
    );
  }

  /// `verification code: `
  String get verificationCode {
    return Intl.message(
      'verification code: ',
      name: 'verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `A validation code has been sent by sms to: `
  String get unCodeDeValidationATEnvoyParSmsAu {
    return Intl.message(
      'A validation code has been sent by sms to: ',
      name: 'unCodeDeValidationATEnvoyParSmsAu',
      desc: '',
      args: [],
    );
  }

  /// `Validate the code`
  String get validezLeCode {
    return Intl.message(
      'Validate the code',
      name: 'validezLeCode',
      desc: '',
      args: [],
    );
  }

  /// `Return the validation code`
  String get renvoyezLeCodeDeValidation {
    return Intl.message(
      'Return the validation code',
      name: 'renvoyezLeCodeDeValidation',
      desc: '',
      args: [],
    );
  }

  /// `The code expires in:  `
  String get leCodeExpireDans {
    return Intl.message(
      'The code expires in:  ',
      name: 'leCodeExpireDans',
      desc: '',
      args: [],
    );
  }

  /// `Successfully signed in UID: `
  String get successfullySignedInUid {
    return Intl.message(
      'Successfully signed in UID: ',
      name: 'successfullySignedInUid',
      desc: '',
      args: [],
    );
  }

  /// `Failed to sign in: `
  String get failedToSignIn {
    return Intl.message(
      'Failed to sign in: ',
      name: 'failedToSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Reset your password with your phone and email address,`
  String get reinitialisezVotreMotDePasseGrceVotreTlphoneEtAdresse {
    return Intl.message(
      'Reset your password with your phone and email address,',
      name: 'reinitialisezVotreMotDePasseGrceVotreTlphoneEtAdresse',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get reinitialiserMotDePasse {
    return Intl.message(
      'Reset password',
      name: 'reinitialiserMotDePasse',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get annuler {
    return Intl.message(
      'Cancel',
      name: 'annuler',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get utilisateur {
    return Intl.message(
      'User',
      name: 'utilisateur',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get mdcin {
    return Intl.message(
      'Doctor',
      name: 'mdcin',
      desc: '',
      args: [],
    );
  }

  /// `healthprovider`
  String get prestataireSant {
    return Intl.message(
      'healthprovider',
      name: 'prestataireSant',
      desc: '',
      args: [],
    );
  }

  /// `Enter your information to create your and become a member of the Danaid community.`
  String get entrezVosInformationsAfinDeCrerVotreCompteEt {
    return Intl.message(
      'Enter your information to create your and become a member of the Danaid community.',
      name: 'entrezVosInformationsAfinDeCrerVotreCompteEt',
      desc: '',
      args: [],
    );
  }

  /// `Already a member?`
  String get djMembre {
    return Intl.message(
      'Already a member?',
      name: 'djMembre',
      desc: '',
      args: [],
    );
  }

  /// `Sign in.`
  String get seConnecter {
    return Intl.message(
      'Sign in.',
      name: 'seConnecter',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get tlphone {
    return Intl.message(
      'Phone',
      name: 'tlphone',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get entrezVotreNumroDeTlphone {
    return Intl.message(
      'Enter your phone number',
      name: 'entrezVotreNumroDeTlphone',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get nom {
    return Intl.message(
      'Name',
      name: 'nom',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get entrezVotreNom {
    return Intl.message(
      'Enter your name',
      name: 'entrezVotreNom',
      desc: '',
      args: [],
    );
  }

  /// `E-mail address`
  String get adresseEmail {
    return Intl.message(
      'E-mail address',
      name: 'adresseEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get entrezVotreAdresseEmail {
    return Intl.message(
      'Enter your email address',
      name: 'entrezVotreAdresseEmail',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get sinscrire {
    return Intl.message(
      'Sign up',
      name: 'sinscrire',
      desc: '',
      args: [],
    );
  }

  /// `Failed to Verify Phone Number: `
  String get failedToVerifyPhoneNumber {
    return Intl.message(
      'Failed to Verify Phone Number: ',
      name: 'failedToVerifyPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Name of the establishment  *`
  String get nomDeLtablissement {
    return Intl.message(
      'Name of the establishment  *',
      name: 'nomDeLtablissement',
      desc: '',
      args: [],
    );
  }

  /// `Full name of the contact *`
  String get nomCompletDuContact {
    return Intl.message(
      'Full name of the contact *',
      name: 'nomCompletDuContact',
      desc: '',
      args: [],
    );
  }

  /// `e.g.: Hôpial Centrale`
  String get exHpialCentrale {
    return Intl.message(
      'e.g.: Hôpial Centrale',
      name: 'exHpialCentrale',
      desc: '',
      args: [],
    );
  }

  /// `Contact email`
  String get emailDuContact {
    return Intl.message(
      'Contact email',
      name: 'emailDuContact',
      desc: '',
      args: [],
    );
  }

  /// `Hôpital`
  String get hpital {
    return Intl.message(
      'Hôpital',
      name: 'hpital',
      desc: '',
      args: [],
    );
  }

  /// `Pharmacy`
  String get pharmacie {
    return Intl.message(
      'Pharmacy',
      name: 'pharmacie',
      desc: '',
      args: [],
    );
  }

  /// `Laboratory`
  String get laboratoire {
    return Intl.message(
      'Laboratory',
      name: 'laboratoire',
      desc: '',
      args: [],
    );
  }

  /// `Read and accepted the `
  String get luEtAcceptLes {
    return Intl.message(
      'Read and accepted the ',
      name: 'luEtAcceptLes',
      desc: '',
      args: [],
    );
  }

  /// `Read and accepted the `
  String get termesDesServices {
    return Intl.message(
      'Read and accepted the ',
      name: 'termesDesServices',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email address`
  String get entrerUneAddresseEmailValide {
    return Intl.message(
      'Enter a valid email address',
      name: 'entrerUneAddresseEmailValide',
      desc: '',
      args: [],
    );
  }

  /// `In the office`
  String get encabinet {
    return Intl.message(
      'In the office',
      name: 'encabinet',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `codeBar Empty`
  String get codebarvide {
    return Intl.message(
      'codeBar Empty',
      name: 'codebarvide',
      desc: '',
      args: [],
    );
  }

  /// `this member does not exist `
  String get cetAdherentNexistePas {
    return Intl.message(
      'this member does not exist ',
      name: 'cetAdherentNexistePas',
      desc: '',
      args: [],
    );
  }

  /// `Please specify the type of consultation`
  String get veuillezPreciserLeTypeDeConsultation {
    return Intl.message(
      'Please specify the type of consultation',
      name: 'veuillezPreciserLeTypeDeConsultation',
      desc: '',
      args: [],
    );
  }

  /// `please scan a valid phone number`
  String get veuillezScannerUnnumeroDeTlphoneValideSvp {
    return Intl.message(
      'please scan a valid phone number',
      name: 'veuillezScannerUnnumeroDeTlphoneValideSvp',
      desc: '',
      args: [],
    );
  }

  /// `Videos`
  String get vidos {
    return Intl.message(
      'Videos',
      name: 'vidos',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get dmarrer {
    return Intl.message(
      'Start',
      name: 'dmarrer',
      desc: '',
      args: [],
    );
  }

  /// `Choose the type of consultation `
  String get choisirLeTypeDeConsultation {
    return Intl.message(
      'Choose the type of consultation ',
      name: 'choisirLeTypeDeConsultation',
      desc: '',
      args: [],
    );
  }

  /// `In the office`
  String get enCabinet {
    return Intl.message(
      'In the office',
      name: 'enCabinet',
      desc: '',
      args: [],
    );
  }

  /// `Select or add the patient `
  String get selectionnerOuAjouterLePatient {
    return Intl.message(
      'Select or add the patient ',
      name: 'selectionnerOuAjouterLePatient',
      desc: '',
      args: [],
    );
  }

  /// `Search by phone number`
  String get rechercherParNumeroDeTlphone {
    return Intl.message(
      'Search by phone number',
      name: 'rechercherParNumeroDeTlphone',
      desc: '',
      args: [],
    );
  }

  /// ` phone number`
  String get numeroDeTelephone {
    return Intl.message(
      ' phone number',
      name: 'numeroDeTelephone',
      desc: '',
      args: [],
    );
  }

  /// `Or scan a membership card`
  String get ouScannerUneCarteDadherent {
    return Intl.message(
      'Or scan a membership card',
      name: 'ouScannerUneCarteDadherent',
      desc: '',
      args: [],
    );
  }

  /// `does not exist `
  String get existePas {
    return Intl.message(
      'does not exist ',
      name: 'existePas',
      desc: '',
      args: [],
    );
  }

  /// `REFERENCEMENT`
  String get referencement {
    return Intl.message(
      'REFERENCEMENT',
      name: 'referencement',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get rechercher {
    return Intl.message(
      'Search',
      name: 'rechercher',
      desc: '',
      args: [],
    );
  }

  /// `This member has been created.`
  String get cetAdherentABienTCrer {
    return Intl.message(
      'This member has been created.',
      name: 'cetAdherentABienTCrer',
      desc: '',
      args: [],
    );
  }

  /// `The Number`
  String get leNumro {
    return Intl.message(
      'The Number',
      name: 'leNumro',
      desc: '',
      args: [],
    );
  }

  /// `Member's Account`
  String get leCompteDeLadherent {
    return Intl.message(
      'Member\'s Account',
      name: 'leCompteDeLadherent',
      desc: '',
      args: [],
    );
  }

  /// ` is inative`
  String get estInatif {
    return Intl.message(
      ' is inative',
      name: 'estInatif',
      desc: '',
      args: [],
    );
  }

  /// `Not yet a member of DanAid Mutual Health Insurance. Recommend DanAid Mutual Health Insurance and become your patient's family doctor.`
  String get nestPasEncoreAdherentALaMutuelleSanteDanaidrecommncerLa {
    return Intl.message(
      'Not yet a member of DanAid Mutual Health Insurance. Recommend DanAid Mutual Health Insurance and become your patient\'s family doctor.',
      name: 'nestPasEncoreAdherentALaMutuelleSanteDanaidrecommncerLa',
      desc: '',
      args: [],
    );
  }

  /// `If the member is not up to date with his contributions, you will not benefit from the compensation in the DanAid care plan.`
  String get ladhrentNetantPasJourDeSesCotisationVousNeBnficierez {
    return Intl.message(
      'If the member is not up to date with his contributions, you will not benefit from the compensation in the DanAid care plan.',
      name: 'ladhrentNetantPasJourDeSesCotisationVousNeBnficierez',
      desc: '',
      args: [],
    );
  }

  /// `You will receive the DanAid compensation (2.000 Cfa) if the family adheres to the mutual insurance`
  String get vousRecevrezLaCompensationDanaid2000CfaSiLaFamilleAdherent {
    return Intl.message(
      'You will receive the DanAid compensation (2.000 Cfa) if the family adheres to the mutual insurance',
      name: 'vousRecevrezLaCompensationDanaid2000CfaSiLaFamilleAdherent',
      desc: '',
      args: [],
    );
  }

  /// `Continue the consultation outside the DanAid care pathway`
  String get poursuivezLaConsultationHorsParcoursDeSoinDanaid {
    return Intl.message(
      'Continue the consultation outside the DanAid care pathway',
      name: 'poursuivezLaConsultationHorsParcoursDeSoinDanaid',
      desc: '',
      args: [],
    );
  }

  /// `Add a family`
  String get ajouterUneFamille {
    return Intl.message(
      'Add a family',
      name: 'ajouterUneFamille',
      desc: '',
      args: [],
    );
  }

  /// `Continue off course`
  String get poursuivreHorsParcours {
    return Intl.message(
      'Continue off course',
      name: 'poursuivreHorsParcours',
      desc: '',
      args: [],
    );
  }

  /// `Familly`
  String get famille {
    return Intl.message(
      'Familly',
      name: 'famille',
      desc: '',
      args: [],
    );
  }

  /// `An invoice has just been created for this ...`
  String get uneFactureVientDtreCrerPourCette {
    return Intl.message(
      'An invoice has just been created for this ...',
      name: 'uneFactureVientDtreCrerPourCette',
      desc: '',
      args: [],
    );
  }

  /// `Redirection to the booklet ! ...`
  String get redirtectionVersLeCarnet {
    return Intl.message(
      'Redirection to the booklet ! ...',
      name: 'redirtectionVersLeCarnet',
      desc: '',
      args: [],
    );
  }

  /// `Redirection to the booklet  ...`
  String get redirectionVersLeCarnet {
    return Intl.message(
      'Redirection to the booklet  ...',
      name: 'redirectionVersLeCarnet',
      desc: '',
      args: [],
    );
  }

  /// `Select a beneficiary before validating`
  String get selectionerUnBeneficiaireAvantDeValider {
    return Intl.message(
      'Select a beneficiary before validating',
      name: 'selectionerUnBeneficiaireAvantDeValider',
      desc: '',
      args: [],
    );
  }

  /// `booklet of `
  String get carnetDe {
    return Intl.message(
      'booklet of ',
      name: 'carnetDe',
      desc: '',
      args: [],
    );
  }

  /// `Access to the health booklet`
  String get accederAuCarnetDeSante {
    return Intl.message(
      'Access to the health booklet',
      name: 'accederAuCarnetDeSante',
      desc: '',
      args: [],
    );
  }

  /// `Health booklet  `
  String get carnetDeSant {
    return Intl.message(
      'Health booklet  ',
      name: 'carnetDeSant',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get feminin {
    return Intl.message(
      'Female',
      name: 'feminin',
      desc: '',
      args: [],
    );
  }

  /// `years`
  String get ans {
    return Intl.message(
      'years',
      name: 'ans',
      desc: '',
      args: [],
    );
  }

  /// `data like weight and height are missing to display this section please complete this profile `
  String get lesDonnesCommeLePoidsEtLaTailleSontManquantes {
    return Intl.message(
      'data like weight and height are missing to display this section please complete this profile ',
      name: 'lesDonnesCommeLePoidsEtLaTailleSontManquantes',
      desc: '',
      args: [],
    );
  }

  /// `Please be patient, this part is under development. Thank you for your understanding`
  String get unPeutDePatienceCettePartieEstEnCourDe {
    return Intl.message(
      'Please be patient, this part is under development. Thank you for your understanding',
      name: 'unPeutDePatienceCettePartieEstEnCourDe',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profil {
    return Intl.message(
      'Profile',
      name: 'profil',
      desc: '',
      args: [],
    );
  }

  /// `Detailed`
  String get dtaill {
    return Intl.message(
      'Detailed',
      name: 'dtaill',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming`
  String get prochains {
    return Intl.message(
      'Upcoming',
      name: 'prochains',
      desc: '',
      args: [],
    );
  }

  /// `Follows`
  String get suiveDes {
    return Intl.message(
      'Follows',
      name: 'suiveDes',
      desc: '',
      args: [],
    );
  }

  /// `Care`
  String get soins {
    return Intl.message(
      'Care',
      name: 'soins',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming `
  String get suiviDes {
    return Intl.message(
      'Upcoming ',
      name: 'suiviDes',
      desc: '',
      args: [],
    );
  }

  /// `Data `
  String get donnes {
    return Intl.message(
      'Data ',
      name: 'donnes',
      desc: '',
      args: [],
    );
  }

  /// `Vital`
  String get vitales {
    return Intl.message(
      'Vital',
      name: 'vitales',
      desc: '',
      args: [],
    );
  }

  /// `Notes from  `
  String get notesDu {
    return Intl.message(
      'Notes from  ',
      name: 'notesDu',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get mdecin {
    return Intl.message(
      'Doctor',
      name: 'mdecin',
      desc: '',
      args: [],
    );
  }

  /// `Consultation Code `
  String get codeDeConsultation {
    return Intl.message(
      'Consultation Code ',
      name: 'codeDeConsultation',
      desc: '',
      args: [],
    );
  }

  /// `History of services`
  String get historiqueDesPrestations {
    return Intl.message(
      'History of services',
      name: 'historiqueDesPrestations',
      desc: '',
      args: [],
    );
  }

  /// `Your consultations & payment`
  String get vosConsultationsPaiement {
    return Intl.message(
      'Your consultations & payment',
      name: 'vosConsultationsPaiement',
      desc: '',
      args: [],
    );
  }

  /// `Payment Status `
  String get statusDesPaiements {
    return Intl.message(
      'Payment Status ',
      name: 'statusDesPaiements',
      desc: '',
      args: [],
    );
  }

  /// `updated beneficiaries`
  String get beneficiaresJours {
    return Intl.message(
      'updated beneficiaries',
      name: 'beneficiaresJours',
      desc: '',
      args: [],
    );
  }

  /// `Referrals`
  String get rfrencements {
    return Intl.message(
      'Referrals',
      name: 'rfrencements',
      desc: '',
      args: [],
    );
  }

  /// `Registered persons`
  String get personnesInscrites {
    return Intl.message(
      'Registered persons',
      name: 'personnesInscrites',
      desc: '',
      args: [],
    );
  }

  /// `Yearly total`
  String get totalAnnuel {
    return Intl.message(
      'Yearly total',
      name: 'totalAnnuel',
      desc: '',
      args: [],
    );
  }

  /// `Paid `
  String get pay {
    return Intl.message(
      'Paid ',
      name: 'pay',
      desc: '',
      args: [],
    );
  }

  /// `Remainder to pay `
  String get restePayer {
    return Intl.message(
      'Remainder to pay ',
      name: 'restePayer',
      desc: '',
      args: [],
    );
  }

  /// `No Transactions for this year `
  String get aucuneTransactionPourCetteAnne {
    return Intl.message(
      'No Transactions for this year ',
      name: 'aucuneTransactionPourCetteAnne',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get bienvenue {
    return Intl.message(
      'Welcome',
      name: 'bienvenue',
      desc: '',
      args: [],
    );
  }

  /// `My Cover`
  String get maCouverture {
    return Intl.message(
      'My Cover',
      name: 'maCouverture',
      desc: '',
      args: [],
    );
  }

  /// `My Doctor`
  String get monDocteur {
    return Intl.message(
      'My Doctor',
      name: 'monDocteur',
      desc: '',
      args: [],
    );
  }

  /// `My Services`
  String get mesServices {
    return Intl.message(
      'My Services',
      name: 'mesServices',
      desc: '',
      args: [],
    );
  }

  /// `My Appointments`
  String get mesRendezvous {
    return Intl.message(
      'My Appointments',
      name: 'mesRendezvous',
      desc: '',
      args: [],
    );
  }

  /// ` No patients in the waiting room.`
  String get aucunPatientEnSalleDattente {
    return Intl.message(
      ' No patients in the waiting room.',
      name: 'aucunPatientEnSalleDattente',
      desc: '',
      args: [],
    );
  }

  /// `Booklet`
  String get carnet {
    return Intl.message(
      'Booklet',
      name: 'carnet',
      desc: '',
      args: [],
    );
  }

  /// `partner`
  String get partenaire {
    return Intl.message(
      'partner',
      name: 'partenaire',
      desc: '',
      args: [],
    );
  }

  /// `Add a beneficiary `
  String get ajouterUnBnficiaire {
    return Intl.message(
      'Add a beneficiary ',
      name: 'ajouterUnBnficiaire',
      desc: '',
      args: [],
    );
  }

  /// `First name *`
  String get prnom {
    return Intl.message(
      'First name *',
      name: 'prnom',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number`
  String get numroMobile {
    return Intl.message(
      'Mobile number',
      name: 'numroMobile',
      desc: '',
      args: [],
    );
  }

  /// `Relationship with the member *`
  String get relationAvecLadhrent {
    return Intl.message(
      'Relationship with the member *',
      name: 'relationAvecLadhrent',
      desc: '',
      args: [],
    );
  }

  /// `Child`
  String get enfant {
    return Intl.message(
      'Child',
      name: 'enfant',
      desc: '',
      args: [],
    );
  }

  /// `CHILD`
  String get child {
    return Intl.message(
      'CHILD',
      name: 'child',
      desc: '',
      args: [],
    );
  }

  /// `Spouse`
  String get conjointe {
    return Intl.message(
      'Spouse',
      name: 'conjointe',
      desc: '',
      args: [],
    );
  }

  /// `SPOUSE`
  String get spouse {
    return Intl.message(
      'SPOUSE',
      name: 'spouse',
      desc: '',
      args: [],
    );
  }

  /// `Brother/Sister`
  String get frresoeur {
    return Intl.message(
      'Brother/Sister',
      name: 'frresoeur',
      desc: '',
      args: [],
    );
  }

  /// `SIBLING`
  String get sibling {
    return Intl.message(
      'SIBLING',
      name: 'sibling',
      desc: '',
      args: [],
    );
  }

  /// `PARENT`
  String get parent {
    return Intl.message(
      'PARENT',
      name: 'parent',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get suivant {
    return Intl.message(
      'Next',
      name: 'suivant',
      desc: '',
      args: [],
    );
  }

  /// `Blood type`
  String get groupeSanguin {
    return Intl.message(
      'Blood type',
      name: 'groupeSanguin',
      desc: '',
      args: [],
    );
  }

  /// `Height`
  String get taille {
    return Intl.message(
      'Height',
      name: 'taille',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get poids {
    return Intl.message(
      'Weight',
      name: 'poids',
      desc: '',
      args: [],
    );
  }

  /// `Allergy`
  String get allergies {
    return Intl.message(
      'Allergy',
      name: 'allergies',
      desc: '',
      args: [],
    );
  }

  /// `Download supporting documents`
  String get tlchargerLesPicesJustificatives {
    return Intl.message(
      'Download supporting documents',
      name: 'tlchargerLesPicesJustificatives',
      desc: '',
      args: [],
    );
  }

  /// `Scan the supporting documents (CNI, Birth certificates, etc..)`
  String get scannerLesDocumentsJustificatifsCniActesDeNaissancesEtc {
    return Intl.message(
      'Scan the supporting documents (CNI, Birth certificates, etc..)',
      name: 'scannerLesDocumentsJustificatifsCniActesDeNaissancesEtc',
      desc: '',
      args: [],
    );
  }

  /// `Scan of the CNI`
  String get scanDeLaCni {
    return Intl.message(
      'Scan of the CNI',
      name: 'scanDeLaCni',
      desc: '',
      args: [],
    );
  }

  /// `Birth certificate *`
  String get acteDeNaissance {
    return Intl.message(
      'Birth certificate *',
      name: 'acteDeNaissance',
      desc: '',
      args: [],
    );
  }

  /// `Marriage Certificate`
  String get acteDeMarriage {
    return Intl.message(
      'Marriage Certificate',
      name: 'acteDeMarriage',
      desc: '',
      args: [],
    );
  }

  /// `Other supporting document`
  String get autrePiceJustificative {
    return Intl.message(
      'Other supporting document',
      name: 'autrePiceJustificative',
      desc: '',
      args: [],
    );
  }

  /// `Declaration`
  String get dclaration {
    return Intl.message(
      'Declaration',
      name: 'dclaration',
      desc: '',
      args: [],
    );
  }

  /// `For beneficiaries without direct affiliation`
  String get pourLesBnficiairesSansFiliationDirecte {
    return Intl.message(
      'For beneficiaries without direct affiliation',
      name: 'pourLesBnficiairesSansFiliationDirecte',
      desc: '',
      args: [],
    );
  }

  /// `I hereby confirm that the above-mentioned person is my dependent and resides in my home`
  String get jeConfirmeParLaPrsenteQueLaPersonneSusciteEst {
    return Intl.message(
      'I hereby confirm that the above-mentioned person is my dependent and resides in my home',
      name: 'jeConfirmeParLaPrsenteQueLaPersonneSusciteEst',
      desc: '',
      args: [],
    );
  }

  /// `Lactose`
  String get lactose {
    return Intl.message(
      'Lactose',
      name: 'lactose',
      desc: '',
      args: [],
    );
  }

  /// `Penicillin`
  String get pnicilline {
    return Intl.message(
      'Penicillin',
      name: 'pnicilline',
      desc: '',
      args: [],
    );
  }

  /// `Pollen`
  String get pollen {
    return Intl.message(
      'Pollen',
      name: 'pollen',
      desc: '',
      args: [],
    );
  }

  /// `Bee`
  String get abeille {
    return Intl.message(
      'Bee',
      name: 'abeille',
      desc: '',
      args: [],
    );
  }

  /// `Feu`
  String get feu {
    return Intl.message(
      'Feu',
      name: 'feu',
      desc: '',
      args: [],
    );
  }

  /// `Herbs`
  String get herbes {
    return Intl.message(
      'Herbs',
      name: 'herbes',
      desc: '',
      args: [],
    );
  }

  /// `Plastic`
  String get plastique {
    return Intl.message(
      'Plastic',
      name: 'plastique',
      desc: '',
      args: [],
    );
  }

  /// `CNI (or passport)`
  String get cniOuPasseport {
    return Intl.message(
      'CNI (or passport)',
      name: 'cniOuPasseport',
      desc: '',
      args: [],
    );
  }

  /// `Headaches`
  String get migraines {
    return Intl.message(
      'Headaches',
      name: 'migraines',
      desc: '',
      args: [],
    );
  }

  /// `Tiredness`
  String get fatigue {
    return Intl.message(
      'Tiredness',
      name: 'fatigue',
      desc: '',
      args: [],
    );
  }

  /// `Diarrhée`
  String get diarrhe {
    return Intl.message(
      'Diarrhée',
      name: 'diarrhe',
      desc: '',
      args: [],
    );
  }

  /// `Diarrhea`
  String get fivre {
    return Intl.message(
      'Diarrhea',
      name: 'fivre',
      desc: '',
      args: [],
    );
  }

  /// `Headaches`
  String get mauxDeTte {
    return Intl.message(
      'Headaches',
      name: 'mauxDeTte',
      desc: '',
      args: [],
    );
  }

  /// `Aches`
  String get courbatures {
    return Intl.message(
      'Aches',
      name: 'courbatures',
      desc: '',
      args: [],
    );
  }

  /// `Stomach aches`
  String get mauxDeVentre {
    return Intl.message(
      'Stomach aches',
      name: 'mauxDeVentre',
      desc: '',
      args: [],
    );
  }

  /// `Requesting care`
  String get dmanderUnePriseEnCharge {
    return Intl.message(
      'Requesting care',
      name: 'dmanderUnePriseEnCharge',
      desc: '',
      args: [],
    );
  }

  /// `Declare an emergency`
  String get dclarerUneUrgence {
    return Intl.message(
      'Declare an emergency',
      name: 'dclarerUneUrgence',
      desc: '',
      args: [],
    );
  }

  /// `The guide assists you`
  String get leGuideVousAssiste {
    return Intl.message(
      'The guide assists you',
      name: 'leGuideVousAssiste',
      desc: '',
      args: [],
    );
  }

  /// `Choose the date and period`
  String get choisirLaDateEtLaPriode {
    return Intl.message(
      'Choose the date and period',
      name: 'choisirLaDateEtLaPriode',
      desc: '',
      args: [],
    );
  }

  /// `Reason and symptom`
  String get raisonEtSymptme {
    return Intl.message(
      'Reason and symptom',
      name: 'raisonEtSymptme',
      desc: '',
      args: [],
    );
  }

  /// `Fill in the establishment`
  String get renseignezLtablissement {
    return Intl.message(
      'Fill in the establishment',
      name: 'renseignezLtablissement',
      desc: '',
      args: [],
    );
  }

  /// `Choose a family doctor`
  String get choisissezUnMedecinDeFamille {
    return Intl.message(
      'Choose a family doctor',
      name: 'choisissezUnMedecinDeFamille',
      desc: '',
      args: [],
    );
  }

  /// `What do you want to do?\n`
  String get queSouhaitezVousFairen {
    return Intl.message(
      'What do you want to do?\n',
      name: 'queSouhaitezVousFairen',
      desc: '',
      args: [],
    );
  }

  /// `Select your choice`
  String get slectionnerVotreChoix {
    return Intl.message(
      'Select your choice',
      name: 'slectionnerVotreChoix',
      desc: '',
      args: [],
    );
  }

  /// `Consult today`
  String get consulterAujourdhui {
    return Intl.message(
      'Consult today',
      name: 'consulterAujourdhui',
      desc: '',
      args: [],
    );
  }

  /// `Make an appointment`
  String get prendreRendezvous {
    return Intl.message(
      'Make an appointment',
      name: 'prendreRendezvous',
      desc: '',
      args: [],
    );
  }

  /// `Call the mutual`
  String get appelerLaMutuelle {
    return Intl.message(
      'Call the mutual',
      name: 'appelerLaMutuelle',
      desc: '',
      args: [],
    );
  }

  /// `phone:`
  String get tel {
    return Intl.message(
      'phone:',
      name: 'tel',
      desc: '',
      args: [],
    );
  }

  /// `or - Register the institution\n`
  String get ouRenseignerLtablissementn {
    return Intl.message(
      'or - Register the institution\n',
      name: 'ouRenseignerLtablissementn',
      desc: '',
      args: [],
    );
  }

  /// `Select the patient`
  String get slectionerLePatient {
    return Intl.message(
      'Select the patient',
      name: 'slectionerLePatient',
      desc: '',
      args: [],
    );
  }

  /// `Hôpital de préférence`
  String get hpitalDePrfrence {
    return Intl.message(
      'Hôpital de préférence',
      name: 'hpitalDePrfrence',
      desc: '',
      args: [],
    );
  }

  /// `Emergency to\n`
  String get urgenceN {
    return Intl.message(
      'Emergency to\n',
      name: 'urgenceN',
      desc: '',
      args: [],
    );
  }

  /// `What is the reason?`
  String get quelleEstLaRaison {
    return Intl.message(
      'What is the reason?',
      name: 'quelleEstLaRaison',
      desc: '',
      args: [],
    );
  }

  /// `Household Accident`
  String get accidentDomestique {
    return Intl.message(
      'Household Accident',
      name: 'accidentDomestique',
      desc: '',
      args: [],
    );
  }

  /// `Road accidents`
  String get accidentRoutier {
    return Intl.message(
      'Road accidents',
      name: 'accidentRoutier',
      desc: '',
      args: [],
    );
  }

  /// `Sudden illness`
  String get maladieSubite {
    return Intl.message(
      'Sudden illness',
      name: 'maladieSubite',
      desc: '',
      args: [],
    );
  }

  /// `Others`
  String get autre {
    return Intl.message(
      'Others',
      name: 'autre',
      desc: '',
      args: [],
    );
  }

  /// `Additional information`
  String get informationSupplmentaire {
    return Intl.message(
      'Additional information',
      name: 'informationSupplmentaire',
      desc: '',
      args: [],
    );
  }

  /// `The emergency has been registered`
  String get lurgenceABienTEnrgistre {
    return Intl.message(
      'The emergency has been registered',
      name: 'lurgenceABienTEnrgistre',
      desc: '',
      args: [],
    );
  }

  /// `Request an appointment at\n`
  String get demanderUnRendezvousChezn {
    return Intl.message(
      'Request an appointment at\n',
      name: 'demanderUnRendezvousChezn',
      desc: '',
      args: [],
    );
  }

  /// `Select doctor`
  String get slectionnerLeMdecin {
    return Intl.message(
      'Select doctor',
      name: 'slectionnerLeMdecin',
      desc: '',
      args: [],
    );
  }

  /// `at home`
  String get domicile {
    return Intl.message(
      'at home',
      name: 'domicile',
      desc: '',
      args: [],
    );
  }

  /// `Family Doctor,`
  String get mdecinDeFamille {
    return Intl.message(
      'Family Doctor,',
      name: 'mdecinDeFamille',
      desc: '',
      args: [],
    );
  }

  /// `Service`
  String get service {
    return Intl.message(
      'Service',
      name: 'service',
      desc: '',
      args: [],
    );
  }

  /// `Choose a schedule:`
  String get choisirUnHoraire {
    return Intl.message(
      'Choose a schedule:',
      name: 'choisirUnHoraire',
      desc: '',
      args: [],
    );
  }

  /// `Selection`
  String get selection {
    return Intl.message(
      'Selection',
      name: 'selection',
      desc: '',
      args: [],
    );
  }

  /// `is not available on`
  String get nestPasDisponibleLes {
    return Intl.message(
      'is not available on',
      name: 'nestPasDisponibleLes',
      desc: '',
      args: [],
    );
  }

  /// `Choose a day for the appointment`
  String get choisissezUnJourPourLeRendezvous {
    return Intl.message(
      'Choose a day for the appointment',
      name: 'choisissezUnJourPourLeRendezvous',
      desc: '',
      args: [],
    );
  }

  /// `Appointment\n`
  String get rendezvousn {
    return Intl.message(
      'Appointment\n',
      name: 'rendezvousn',
      desc: '',
      args: [],
    );
  }

  /// `What is the reason`
  String get quelleEnEstLaRaison {
    return Intl.message(
      'What is the reason',
      name: 'quelleEnEstLaRaison',
      desc: '',
      args: [],
    );
  }

  /// `New Consultation`
  String get nouvelleConsultation {
    return Intl.message(
      'New Consultation',
      name: 'nouvelleConsultation',
      desc: '',
      args: [],
    );
  }

  /// `Tracking`
  String get suivi {
    return Intl.message(
      'Tracking',
      name: 'suivi',
      desc: '',
      args: [],
    );
  }

  /// `Referencing`
  String get rfrencement {
    return Intl.message(
      'Referencing',
      name: 'rfrencement',
      desc: '',
      args: [],
    );
  }

  /// `Examination result`
  String get rsultatDexamen {
    return Intl.message(
      'Examination result',
      name: 'rsultatDexamen',
      desc: '',
      args: [],
    );
  }

  /// `new consultation`
  String get nouvelleconsultation {
    return Intl.message(
      'new consultation',
      name: 'nouvelleconsultation',
      desc: '',
      args: [],
    );
  }

  /// `exam-result`
  String get resultatexamen {
    return Intl.message(
      'exam-result',
      name: 'resultatexamen',
      desc: '',
      args: [],
    );
  }

  /// `List your symptoms`
  String get listezVosSymptmes {
    return Intl.message(
      'List your symptoms',
      name: 'listezVosSymptmes',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get terminer {
    return Intl.message(
      'Finish',
      name: 'terminer',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, this schedule is not available, please choose another one`
  String get dsolCetteHoraireNestPasDisponibleChoisissezEnUnAutre {
    return Intl.message(
      'Sorry, this schedule is not available, please choose another one',
      name: 'dsolCetteHoraireNestPasDisponibleChoisissezEnUnAutre',
      desc: '',
      args: [],
    );
  }

  /// `NONE PROVIDED`
  String get aucunFourni {
    return Intl.message(
      'NONE PROVIDED',
      name: 'aucunFourni',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get sauvegarder {
    return Intl.message(
      'Save',
      name: 'sauvegarder',
      desc: '',
      args: [],
    );
  }

  /// `Inactive\nAccount`
  String get compteninactif {
    return Intl.message(
      'Inactive\nAccount',
      name: 'compteninactif',
      desc: '',
      args: [],
    );
  }

  /// `Name of the beneficiary \n`
  String get nomDuBnficiairen {
    return Intl.message(
      'Name of the beneficiary \n',
      name: 'nomDuBnficiairen',
      desc: '',
      args: [],
    );
  }

  /// `Identification number\n`
  String get numroMatriculen {
    return Intl.message(
      'Identification number\n',
      name: 'numroMatriculen',
      desc: '',
      args: [],
    );
  }

  /// `Family Doctor\n`
  String get mdecinDeFamillen {
    return Intl.message(
      'Family Doctor\n',
      name: 'mdecinDeFamillen',
      desc: '',
      args: [],
    );
  }

  /// `Nothing`
  String get aucun {
    return Intl.message(
      'Nothing',
      name: 'aucun',
      desc: '',
      args: [],
    );
  }

  /// `Reason`
  String get raison {
    return Intl.message(
      'Reason',
      name: 'raison',
      desc: '',
      args: [],
    );
  }

  /// `Announce my coming`
  String get annoncerMaVenue {
    return Intl.message(
      'Announce my coming',
      name: 'annoncerMaVenue',
      desc: '',
      args: [],
    );
  }

  /// `The appointment was announced...`
  String get leRendezVousATAnnonc {
    return Intl.message(
      'The appointment was announced...',
      name: 'leRendezVousATAnnonc',
      desc: '',
      args: [],
    );
  }

  /// `The announcement has been cancelled.`
  String get lannonceATAnnule {
    return Intl.message(
      'The announcement has been cancelled.',
      name: 'lannonceATAnnule',
      desc: '',
      args: [],
    );
  }

  /// `Don't forget to come back here to announce your arrival on the day of the meeting`
  String get noubliezPasDeRevenirIiAnnoncerVotreVenueLeJour {
    return Intl.message(
      'Don\'t forget to come back here to announce your arrival on the day of the meeting',
      name: 'noubliezPasDeRevenirIiAnnoncerVotreVenueLeJour',
      desc: '',
      args: [],
    );
  }

  /// `The symptoms have been updated...`
  String get lesSymptmesOntTMisesJour {
    return Intl.message(
      'The symptoms have been updated...',
      name: 'lesSymptmesOntTMisesJour',
      desc: '',
      args: [],
    );
  }

  /// `Compare services`
  String get comparerLesServices {
    return Intl.message(
      'Compare services',
      name: 'comparerLesServices',
      desc: '',
      args: [],
    );
  }

  /// `Modify my cover`
  String get modifierMaCouverture {
    return Intl.message(
      'Modify my cover',
      name: 'modifierMaCouverture',
      desc: '',
      args: [],
    );
  }

  /// `You are covered until `
  String get vousTesCouvertsJusquau {
    return Intl.message(
      'You are covered until ',
      name: 'vousTesCouvertsJusquau',
      desc: '',
      args: [],
    );
  }

  /// `per family / Month`
  String get parFamilleMois {
    return Intl.message(
      'per family / Month',
      name: 'parFamilleMois',
      desc: '',
      args: [],
    );
  }

  /// ` Cfa\n`
  String get cfan {
    return Intl.message(
      ' Cfa\n',
      name: 'cfan',
      desc: '',
      args: [],
    );
  }

  /// `Level 0`
  String get niveau0 {
    return Intl.message(
      'Level 0',
      name: 'niveau0',
      desc: '',
      args: [],
    );
  }

  /// `Level  I`
  String get niveauI {
    return Intl.message(
      'Level  I',
      name: 'niveauI',
      desc: '',
      args: [],
    );
  }

  /// `Level  II`
  String get niveauIi {
    return Intl.message(
      'Level  II',
      name: 'niveauIi',
      desc: '',
      args: [],
    );
  }

  /// `Level  III`
  String get niveauIii {
    return Intl.message(
      'Level  III',
      name: 'niveauIii',
      desc: '',
      args: [],
    );
  }

  /// `Health coverage`
  String get couvertureSant {
    return Intl.message(
      'Health coverage',
      name: 'couvertureSant',
      desc: '',
      args: [],
    );
  }

  /// `Annual Ceiling`
  String get plafondAnnuel {
    return Intl.message(
      'Annual Ceiling',
      name: 'plafondAnnuel',
      desc: '',
      args: [],
    );
  }

  /// `Health loan`
  String get prtSant {
    return Intl.message(
      'Health loan',
      name: 'prtSant',
      desc: '',
      args: [],
    );
  }

  /// `interest rate`
  String get tauxDintrt {
    return Intl.message(
      'interest rate',
      name: 'tauxDintrt',
      desc: '',
      args: [],
    );
  }

  /// `Free family doctor`
  String get mdecinDeFamilleGratuit {
    return Intl.message(
      'Free family doctor',
      name: 'mdecinDeFamilleGratuit',
      desc: '',
      args: [],
    );
  }

  /// `Self-help network`
  String get rseauDentraide {
    return Intl.message(
      'Self-help network',
      name: 'rseauDentraide',
      desc: '',
      args: [],
    );
  }

  /// `Earn points`
  String get gagnezDesPoints {
    return Intl.message(
      'Earn points',
      name: 'gagnezDesPoints',
      desc: '',
      args: [],
    );
  }

  /// `Family coverage`
  String get couvertureFamiliale {
    return Intl.message(
      'Family coverage',
      name: 'couvertureFamiliale',
      desc: '',
      args: [],
    );
  }

  /// `Up to 5 people`
  String get jusqua5Personnes {
    return Intl.message(
      'Up to 5 people',
      name: 'jusqua5Personnes',
      desc: '',
      args: [],
    );
  }

  /// `Change level`
  String get changerDeNiveau {
    return Intl.message(
      'Change level',
      name: 'changerDeNiveau',
      desc: '',
      args: [],
    );
  }

  /// `Payment History`
  String get historiqueDesPaiements {
    return Intl.message(
      'Payment History',
      name: 'historiqueDesPaiements',
      desc: '',
      args: [],
    );
  }

  /// `You are on Level 0`
  String get vousTesAuNiveau0 {
    return Intl.message(
      'You are on Level 0',
      name: 'vousTesAuNiveau0',
      desc: '',
      args: [],
    );
  }

  /// `Discovery`
  String get dcouverte {
    return Intl.message(
      'Discovery',
      name: 'dcouverte',
      desc: '',
      args: [],
    );
  }

  /// `  My last bills`
  String get mesDerniresFactures {
    return Intl.message(
      '  My last bills',
      name: 'mesDerniresFactures',
      desc: '',
      args: [],
    );
  }

  /// `No contribution registered for the moment.`
  String get aucuneCtisationEnrgistrePourLeMoment {
    return Intl.message(
      'No contribution registered for the moment.',
      name: 'aucuneCtisationEnrgistrePourLeMoment',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get inscription {
    return Intl.message(
      'Registration',
      name: 'inscription',
      desc: '',
      args: [],
    );
  }

  /// `Coasting`
  String get ctisation {
    return Intl.message(
      'Coasting',
      name: 'ctisation',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get montant {
    return Intl.message(
      'Amount',
      name: 'montant',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paye {
    return Intl.message(
      'Paid',
      name: 'paye',
      desc: '',
      args: [],
    );
  }

  /// `Late!`
  String get enRetard {
    return Intl.message(
      'Late!',
      name: 'enRetard',
      desc: '',
      args: [],
    );
  }

  /// `Validation in progress`
  String get validationEnCours {
    return Intl.message(
      'Validation in progress',
      name: 'validationEnCours',
      desc: '',
      args: [],
    );
  }

  /// `Stand by!`
  String get enAttente {
    return Intl.message(
      'Stand by!',
      name: 'enAttente',
      desc: '',
      args: [],
    );
  }

  /// `Time of payment`
  String get dlaiDePaiement {
    return Intl.message(
      'Time of payment',
      name: 'dlaiDePaiement',
      desc: '',
      args: [],
    );
  }

  /// `Pay`
  String get payer {
    return Intl.message(
      'Pay',
      name: 'payer',
      desc: '',
      args: [],
    );
  }

  /// `Important !!`
  String get important {
    return Intl.message(
      'Important !!',
      name: 'important',
      desc: '',
      args: [],
    );
  }

  /// `Our payment system is currently being updated, so payments will be made manually for the time being, make mobile transfers to the numbers provided and then validate the payment, don't forget to complete your profile first. A DanAid agent will get back to you for confirmation`
  String get notreDispositifDePaiementEstEnCoursDeMiseJour {
    return Intl.message(
      'Our payment system is currently being updated, so payments will be made manually for the time being, make mobile transfers to the numbers provided and then validate the payment, don\'t forget to complete your profile first. A DanAid agent will get back to you for confirmation',
      name: 'notreDispositifDePaiementEstEnCoursDeMiseJour',
      desc: '',
      args: [],
    );
  }

  /// `Quarter:`
  String get trimestre {
    return Intl.message(
      'Quarter:',
      name: 'trimestre',
      desc: '',
      args: [],
    );
  }

  /// `Registration fee:`
  String get fraisDinscription {
    return Intl.message(
      'Registration fee:',
      name: 'fraisDinscription',
      desc: '',
      args: [],
    );
  }

  /// `Quarterly payment:`
  String get paiementTrimestrielle {
    return Intl.message(
      'Quarterly payment:',
      name: 'paiementTrimestrielle',
      desc: '',
      args: [],
    );
  }

  /// `Total to be paid:`
  String get totalPayer {
    return Intl.message(
      'Total to be paid:',
      name: 'totalPayer',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirmer {
    return Intl.message(
      'Confirm',
      name: 'confirmer',
      desc: '',
      args: [],
    );
  }

  /// `Have you already made a mobile money transfer?`
  String get avezvousDjFfectuLeVirementMobile {
    return Intl.message(
      'Have you already made a mobile money transfer?',
      name: 'avezvousDjFfectuLeVirementMobile',
      desc: '',
      args: [],
    );
  }

  /// `After confirmation, an agent will come back to you within 24 hours for validation of the invoice`
  String get aprsConfirmationUnAgentReviendraVersVousSous24hPour {
    return Intl.message(
      'After confirmation, an agent will come back to you within 24 hours for validation of the invoice',
      name: 'aprsConfirmationUnAgentReviendraVersVousSous24hPour',
      desc: '',
      args: [],
    );
  }

  /// `My doctor`
  String get monMdecin {
    return Intl.message(
      'My doctor',
      name: 'monMdecin',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get modifier {
    return Intl.message(
      'Edit',
      name: 'modifier',
      desc: '',
      args: [],
    );
  }

  /// `Consultations`
  String get consultations {
    return Intl.message(
      'Consultations',
      name: 'consultations',
      desc: '',
      args: [],
    );
  }

  /// `Tele-Consultations`
  String get tlconsultations {
    return Intl.message(
      'Tele-Consultations',
      name: 'tlconsultations',
      desc: '',
      args: [],
    );
  }

  /// `Write`
  String get ecrire {
    return Intl.message(
      'Write',
      name: 'ecrire',
      desc: '',
      args: [],
    );
  }

  /// `R.A.S`
  String get ras {
    return Intl.message(
      'R.A.S',
      name: 'ras',
      desc: '',
      args: [],
    );
  }

  /// `Registered staff`
  String get personnelInscrit {
    return Intl.message(
      'Registered staff',
      name: 'personnelInscrit',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get horaire {
    return Intl.message(
      'Schedule',
      name: 'horaire',
      desc: '',
      args: [],
    );
  }

  /// `Adresse`
  String get adresse {
    return Intl.message(
      'Adresse',
      name: 'adresse',
      desc: '',
      args: [],
    );
  }

  /// `Cameroon`
  String get cameroon {
    return Intl.message(
      'Cameroon',
      name: 'cameroon',
      desc: '',
      args: [],
    );
  }

  /// `Cameroon`
  String get cameroun {
    return Intl.message(
      'Cameroon',
      name: 'cameroun',
      desc: '',
      args: [],
    );
  }

  /// `Public rate `
  String get tarifPublique {
    return Intl.message(
      'Public rate ',
      name: 'tarifPublique',
      desc: '',
      args: [],
    );
  }

  /// `DanAid coverage`
  String get couvertureDanaid {
    return Intl.message(
      'DanAid coverage',
      name: 'couvertureDanaid',
      desc: '',
      args: [],
    );
  }

  /// `Members : `
  String get adhrents {
    return Intl.message(
      'Members : ',
      name: 'adhrents',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to choose the `
  String get voulezVousChoisirLe {
    return Intl.message(
      'Do you want to choose the ',
      name: 'voulezVousChoisirLe',
      desc: '',
      args: [],
    );
  }

  /// `NB: After confirmation, you will not be able to change this setting by yourself`
  String get nbAprsConfirmationVousNePourrezPlusModifierCeParamtre {
    return Intl.message(
      'NB: After confirmation, you will not be able to change this setting by yourself',
      name: 'nbAprsConfirmationVousNePourrezPlusModifierCeParamtre',
      desc: '',
      args: [],
    );
  }

  /// `Badges`
  String get badges {
    return Intl.message(
      'Badges',
      name: 'badges',
      desc: '',
      args: [],
    );
  }

  /// `Covered`
  String get couvert {
    return Intl.message(
      'Covered',
      name: 'couvert',
      desc: '',
      args: [],
    );
  }

  /// `You Have Optimal, Access, Assist or Serenity Health Coverage`
  String get vousAvezUneCouvertureSantOptimaleAccsAssistOuSrnit {
    return Intl.message(
      'You Have Optimal, Access, Assist or Serenity Health Coverage',
      name: 'vousAvezUneCouvertureSantOptimaleAccsAssistOuSrnit',
      desc: '',
      args: [],
    );
  }

  /// `Seniority`
  String get anciennet {
    return Intl.message(
      'Seniority',
      name: 'anciennet',
      desc: '',
      args: [],
    );
  }

  /// `You have been a member for more than one year without interruption`
  String get vousTesAdhrentDepuisPlusDunAnSansDiscontinuer {
    return Intl.message(
      'You have been a member for more than one year without interruption',
      name: 'vousTesAdhrentDepuisPlusDunAnSansDiscontinuer',
      desc: '',
      args: [],
    );
  }

  /// `Contributor`
  String get contributeur {
    return Intl.message(
      'Contributor',
      name: 'contributeur',
      desc: '',
      args: [],
    );
  }

  /// `You are a regular contributor to the DanAid support network`
  String get vousTesUnContributeurRgulierAansLeRseauDentraideDanaid {
    return Intl.message(
      'You are a regular contributor to the DanAid support network',
      name: 'vousTesUnContributeurRgulierAansLeRseauDentraideDanaid',
      desc: '',
      args: [],
    );
  }

  /// `No doctor available for the moment.`
  String get aucunMedecinDisponiblePourLeMoment {
    return Intl.message(
      'No doctor available for the moment.',
      name: 'aucunMedecinDisponiblePourLeMoment',
      desc: '',
      args: [],
    );
  }

  /// `Update your profile and your GPS location`
  String get mettezJourVotreProfilAinsiQueVotreLocationGps {
    return Intl.message(
      'Update your profile and your GPS location',
      name: 'mettezJourVotreProfilAinsiQueVotreLocationGps',
      desc: '',
      args: [],
    );
  }

  /// `  Order by:  `
  String get ordonnerPar {
    return Intl.message(
      '  Order by:  ',
      name: 'ordonnerPar',
      desc: '',
      args: [],
    );
  }

  /// `Distance`
  String get distance {
    return Intl.message(
      'Distance',
      name: 'distance',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get name {
    return Intl.message(
      'name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Documents`
  String get documents {
    return Intl.message(
      'Documents',
      name: 'documents',
      desc: '',
      args: [],
    );
  }

  /// `Overview & download of DanAid administrative documents`
  String get aperuTlchargementDesDocumentsAdministratifsDanaid {
    return Intl.message(
      'Overview & download of DanAid administrative documents',
      name: 'aperuTlchargementDesDocumentsAdministratifsDanaid',
      desc: '',
      args: [],
    );
  }

  /// `Scroll down to get\nthe summary`
  String get dfilezPourAvoirnleRsum {
    return Intl.message(
      'Scroll down to get\nthe summary',
      name: 'dfilezPourAvoirnleRsum',
      desc: '',
      args: [],
    );
  }

  /// `You are at Level I:`
  String get vousTesAuNiveauI {
    return Intl.message(
      'You are at Level I:',
      name: 'vousTesAuNiveauI',
      desc: '',
      args: [],
    );
  }

  /// `You are at Level II`
  String get vousTesAuNiveauIi {
    return Intl.message(
      'You are at Level II',
      name: 'vousTesAuNiveauIi',
      desc: '',
      args: [],
    );
  }

  /// `You are at Level III`
  String get vousTesAuNiveauIii {
    return Intl.message(
      'You are at Level III',
      name: 'vousTesAuNiveauIii',
      desc: '',
      args: [],
    );
  }

  /// `Access`
  String get accs {
    return Intl.message(
      'Access',
      name: 'accs',
      desc: '',
      args: [],
    );
  }

  /// ` Assist`
  String get assist {
    return Intl.message(
      ' Assist',
      name: 'assist',
      desc: '',
      args: [],
    );
  }

  /// ` Serenity`
  String get srnit {
    return Intl.message(
      ' Serenity',
      name: 'srnit',
      desc: '',
      args: [],
    );
  }

  /// `Member since`
  String get adhrentDepuis {
    return Intl.message(
      'Member since',
      name: 'adhrentDepuis',
      desc: '',
      args: [],
    );
  }

  /// `You are at the level `
  String get vousTesAuNiveau {
    return Intl.message(
      'You are at the level ',
      name: 'vousTesAuNiveau',
      desc: '',
      args: [],
    );
  }

  /// `Your Consumption`
  String get votreConsommation {
    return Intl.message(
      'Your Consumption',
      name: 'votreConsommation',
      desc: '',
      args: [],
    );
  }

  /// `of health costs`
  String get deFraisSant {
    return Intl.message(
      'of health costs',
      name: 'deFraisSant',
      desc: '',
      args: [],
    );
  }

  /// `Medicine & Care`
  String get mdecineSoin {
    return Intl.message(
      'Medicine & Care',
      name: 'mdecineSoin',
      desc: '',
      args: [],
    );
  }

  /// `Drugs`
  String get mdicaments {
    return Intl.message(
      'Drugs',
      name: 'mdicaments',
      desc: '',
      args: [],
    );
  }

  /// `Others`
  String get autres {
    return Intl.message(
      'Others',
      name: 'autres',
      desc: '',
      args: [],
    );
  }

  /// `Your Statistics`
  String get vosStatistiques {
    return Intl.message(
      'Your Statistics',
      name: 'vosStatistiques',
      desc: '',
      args: [],
    );
  }

  /// `You are at the Discovery Level like 40% of our members`
  String get vousTesAuNiveauDcouverteComme40DeNosAdhrents {
    return Intl.message(
      'You are at the Discovery Level like 40% of our members',
      name: 'vousTesAuNiveauDcouverteComme40DeNosAdhrents',
      desc: '',
      args: [],
    );
  }

  /// `You are at the Discovery Level like 30% of our members`
  String get vousTesAuNiveauAccsComme30DeNosAdhrents {
    return Intl.message(
      'You are at the Discovery Level like 30% of our members',
      name: 'vousTesAuNiveauAccsComme30DeNosAdhrents',
      desc: '',
      args: [],
    );
  }

  /// `You are at the Discovery Level like 20% of our members`
  String get vousTesAuNiveauAssistComme20DeNosAdhrents {
    return Intl.message(
      'You are at the Discovery Level like 20% of our members',
      name: 'vousTesAuNiveauAssistComme20DeNosAdhrents',
      desc: '',
      args: [],
    );
  }

  /// `You are at the Discovery Level like 10% of our members`
  String get vousTesAuNiveauSrnitComme10DeNosAdhrents {
    return Intl.message(
      'You are at the Discovery Level like 10% of our members',
      name: 'vousTesAuNiveauSrnitComme10DeNosAdhrents',
      desc: '',
      args: [],
    );
  }

  /// `Temporary settings: Logout`
  String get paramtresTemporairesDconnexion {
    return Intl.message(
      'Temporary settings: Logout',
      name: 'paramtresTemporairesDconnexion',
      desc: '',
      args: [],
    );
  }

  /// `Disconnecting`
  String get seDconnecter {
    return Intl.message(
      'Disconnecting',
      name: 'seDconnecter',
      desc: '',
      args: [],
    );
  }

  /// `Overview of my Health Loan`
  String get aperuDeMonPrtSant {
    return Intl.message(
      'Overview of my Health Loan',
      name: 'aperuDeMonPrtSant',
      desc: '',
      args: [],
    );
  }

  /// `Add, modify or send parts`
  String get ajouterModifierOuEnvoyerLesPices {
    return Intl.message(
      'Add, modify or send parts',
      name: 'ajouterModifierOuEnvoyerLesPices',
      desc: '',
      args: [],
    );
  }

  /// `Requestor`
  String get demandeur {
    return Intl.message(
      'Requestor',
      name: 'demandeur',
      desc: '',
      args: [],
    );
  }

  /// `Your monthly payments`
  String get vosMensualits {
    return Intl.message(
      'Your monthly payments',
      name: 'vosMensualits',
      desc: '',
      args: [],
    );
  }

  /// ` Month`
  String get mois {
    return Intl.message(
      ' Month',
      name: 'mois',
      desc: '',
      args: [],
    );
  }

  /// `End date`
  String get dateDeFin {
    return Intl.message(
      'End date',
      name: 'dateDeFin',
      desc: '',
      args: [],
    );
  }

  /// `   Status of the loans`
  String get statutDesEmprunts {
    return Intl.message(
      '   Status of the loans',
      name: 'statutDesEmprunts',
      desc: '',
      args: [],
    );
  }

  /// `In progress`
  String get enCours {
    return Intl.message(
      'In progress',
      name: 'enCours',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get effectus {
    return Intl.message(
      'Done',
      name: 'effectus',
      desc: '',
      args: [],
    );
  }

  /// `Credit amount`
  String get montantDuCrdit {
    return Intl.message(
      'Credit amount',
      name: 'montantDuCrdit',
      desc: '',
      args: [],
    );
  }

  /// `Paying back on time increases your credit rating.`
  String get rembourserTempsAugmenteVotreNiveauDeCrdit {
    return Intl.message(
      'Paying back on time increases your credit rating.',
      name: 'rembourserTempsAugmenteVotreNiveauDeCrdit',
      desc: '',
      args: [],
    );
  }

  /// `Duration *`
  String get dure {
    return Intl.message(
      'Duration *',
      name: 'dure',
      desc: '',
      args: [],
    );
  }

  /// `payments`
  String get paiements {
    return Intl.message(
      'payments',
      name: 'paiements',
      desc: '',
      args: [],
    );
  }

  /// `Reason for the loan`
  String get raisonDuPrt {
    return Intl.message(
      'Reason for the loan',
      name: 'raisonDuPrt',
      desc: '',
      args: [],
    );
  }

  /// `Scanning receipts`
  String get scannerDesJustificatifs {
    return Intl.message(
      'Scanning receipts',
      name: 'scannerDesJustificatifs',
      desc: '',
      args: [],
    );
  }

  /// `An estimate, a prescription or any other supporting document)`
  String get unDevisUneOrdonnanceOuToutAutrePiceEnAppui {
    return Intl.message(
      'An estimate, a prescription or any other supporting document)',
      name: 'unDevisUneOrdonnanceOuToutAutrePiceEnAppui',
      desc: '',
      args: [],
    );
  }

  /// `Multiple additional parts`
  String get picesSupplmentairesMultiples {
    return Intl.message(
      'Multiple additional parts',
      name: 'picesSupplmentairesMultiples',
      desc: '',
      args: [],
    );
  }

  /// `Multiple documents`
  String get documentsMultiples {
    return Intl.message(
      'Multiple documents',
      name: 'documentsMultiples',
      desc: '',
      args: [],
    );
  }

  /// `Source of revenue`
  String get sourceDeRevenues {
    return Intl.message(
      'Source of revenue',
      name: 'sourceDeRevenues',
      desc: '',
      args: [],
    );
  }

  /// `Monthly revenue`
  String get revenueMensuel {
    return Intl.message(
      'Monthly revenue',
      name: 'revenueMensuel',
      desc: '',
      args: [],
    );
  }

  /// `Are you an employee ?`
  String get etesVousSalari {
    return Intl.message(
      'Are you an employee ?',
      name: 'etesVousSalari',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get oui {
    return Intl.message(
      'Yes',
      name: 'oui',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get non {
    return Intl.message(
      'No',
      name: 'non',
      desc: '',
      args: [],
    );
  }

  /// `Employer`
  String get employeur {
    return Intl.message(
      'Employer',
      name: 'employeur',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to have an avalist ?`
  String get souhaitezVousAvoirUnAvaliste {
    return Intl.message(
      'Would you like to have an avalist ?',
      name: 'souhaitezVousAvoirUnAvaliste',
      desc: '',
      args: [],
    );
  }

  /// `Your spouse is de facto joint and several on your credit, you can have an additional creditor.`
  String get votrePouxseEstDeFactoSolidaireDeVotreCrditVous {
    return Intl.message(
      'Your spouse is de facto joint and several on your credit, you can have an additional creditor.',
      name: 'votrePouxseEstDeFactoSolidaireDeVotreCrditVous',
      desc: '',
      args: [],
    );
  }

  /// `Name of the avalist`
  String get nomDeLavaliste {
    return Intl.message(
      'Name of the avalist',
      name: 'nomDeLavaliste',
      desc: '',
      args: [],
    );
  }

  /// `Reimbursement Information`
  String get informationsSurLeRemboursement {
    return Intl.message(
      'Reimbursement Information',
      name: 'informationsSurLeRemboursement',
      desc: '',
      args: [],
    );
  }

  /// `Frequency :`
  String get frquence {
    return Intl.message(
      'Frequency :',
      name: 'frquence',
      desc: '',
      args: [],
    );
  }

  /// `effective interest rate :`
  String get tauxDintrtEffectif {
    return Intl.message(
      'effective interest rate :',
      name: 'tauxDintrtEffectif',
      desc: '',
      args: [],
    );
  }

  /// `Total amount to be repaid :`
  String get montantTotalRembourser {
    return Intl.message(
      'Total amount to be repaid :',
      name: 'montantTotalRembourser',
      desc: '',
      args: [],
    );
  }

  /// `First payment :`
  String get premierVersement {
    return Intl.message(
      'First payment :',
      name: 'premierVersement',
      desc: '',
      args: [],
    );
  }

  /// `Last payment :`
  String get dernierVersement {
    return Intl.message(
      'Last payment :',
      name: 'dernierVersement',
      desc: '',
      args: [],
    );
  }

  /// `Health Loan`
  String get prtDeSant {
    return Intl.message(
      'Health Loan',
      name: 'prtDeSant',
      desc: '',
      args: [],
    );
  }

  /// `MAXIMUM AVAILABLE`
  String get maximumDisponible {
    return Intl.message(
      'MAXIMUM AVAILABLE',
      name: 'maximumDisponible',
      desc: '',
      args: [],
    );
  }

  /// `AVAILABLE`
  String get disponible {
    return Intl.message(
      'AVAILABLE',
      name: 'disponible',
      desc: '',
      args: [],
    );
  }

  /// `fast`
  String get rapide {
    return Intl.message(
      'fast',
      name: 'rapide',
      desc: '',
      args: [],
    );
  }

  /// `for all`
  String get pourTous {
    return Intl.message(
      'for all',
      name: 'pourTous',
      desc: '',
      args: [],
    );
  }

  /// `Simple`
  String get simple {
    return Intl.message(
      'Simple',
      name: 'simple',
      desc: '',
      args: [],
    );
  }

  /// `I wish to borrow`
  String get jeSouhaiteEmprunter {
    return Intl.message(
      'I wish to borrow',
      name: 'jeSouhaiteEmprunter',
      desc: '',
      args: [],
    );
  }

  /// `Enter the amount`
  String get entrerLeMontant {
    return Intl.message(
      'Enter the amount',
      name: 'entrerLeMontant',
      desc: '',
      args: [],
    );
  }

  /// `Apply for credit`
  String get dmanderUnCrdit {
    return Intl.message(
      'Apply for credit',
      name: 'dmanderUnCrdit',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, your current plan does not allow you to borrow more than `
  String get dsolVotrePlanActuelNeVousPermetPasDemprunterPlus {
    return Intl.message(
      'Sorry, your current plan does not allow you to borrow more than ',
      name: 'dsolVotrePlanActuelNeVousPermetPasDemprunterPlus',
      desc: '',
      args: [],
    );
  }

  /// `Borrowing costs money`
  String get emprunterCoteDeLargent {
    return Intl.message(
      'Borrowing costs money',
      name: 'emprunterCoteDeLargent',
      desc: '',
      args: [],
    );
  }

  /// `A loan commits you and must be repaid. Check your ability to repay before committing yourself`
  String get unCrditVousEngageEtDoitTreRemboursVrifiezVos {
    return Intl.message(
      'A loan commits you and must be repaid. Check your ability to repay before committing yourself',
      name: 'unCrditVousEngageEtDoitTreRemboursVrifiezVos',
      desc: '',
      args: [],
    );
  }

  /// `F.A.Q`
  String get faq {
    return Intl.message(
      'F.A.Q',
      name: 'faq',
      desc: '',
      args: [],
    );
  }

  /// `Complete your profile first`
  String get completezDabordVotreProfil {
    return Intl.message(
      'Complete your profile first',
      name: 'completezDabordVotreProfil',
      desc: '',
      args: [],
    );
  }

  /// `Provide the information and documents required for borrowing`
  String get fournirLesInformationsEtPicesDmandesPourPouvoirEmprunter {
    return Intl.message(
      'Provide the information and documents required for borrowing',
      name: 'fournirLesInformationsEtPicesDmandesPourPouvoirEmprunter',
      desc: '',
      args: [],
    );
  }

  /// `Complete my profile`
  String get complterMonProfil {
    return Intl.message(
      'Complete my profile',
      name: 'complterMonProfil',
      desc: '',
      args: [],
    );
  }

  /// `you must refer 3 friends & acquaintances to borrow`
  String get vousDevezRferer3AmisConnaissancesPourPouvoirEmprunter {
    return Intl.message(
      'you must refer 3 friends & acquaintances to borrow',
      name: 'vousDevezRferer3AmisConnaissancesPourPouvoirEmprunter',
      desc: '',
      args: [],
    );
  }

  /// `Invite friends`
  String get inviterDesAmis {
    return Intl.message(
      'Invite friends',
      name: 'inviterDesAmis',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get achevs {
    return Intl.message(
      'Completed',
      name: 'achevs',
      desc: '',
      args: [],
    );
  }

  /// `No credit applications on file \n for the moment`
  String get aucuneDemandeDeCrditEnrgistrenpourLeMoment {
    return Intl.message(
      'No credit applications on file \n for the moment',
      name: 'aucuneDemandeDeCrditEnrgistrenpourLeMoment',
      desc: '',
      args: [],
    );
  }

  /// `Starting a care`
  String get dmarrerUnePriseEnCharge {
    return Intl.message(
      'Starting a care',
      name: 'dmarrerUnePriseEnCharge',
      desc: '',
      args: [],
    );
  }

  /// `Are you sick? Start here \n to obtain coverage for your expenses`
  String get vousTesMaladesCommencezIcinpourObtenirLaCouvertureDeVos {
    return Intl.message(
      'Are you sick? Start here \n to obtain coverage for your expenses',
      name: 'vousTesMaladesCommencezIcinpourObtenirLaCouvertureDeVos',
      desc: '',
      args: [],
    );
  }

  /// `Show my membership card`
  String get prsenterMaCarteDadhrant {
    return Intl.message(
      'Show my membership card',
      name: 'prsenterMaCarteDadhrant',
      desc: '',
      args: [],
    );
  }

  /// `Track my contributions`
  String get suivreMesCtisations {
    return Intl.message(
      'Track my contributions',
      name: 'suivreMesCtisations',
      desc: '',
      args: [],
    );
  }

  /// `Request a refund`
  String get demanderUnRemboursement {
    return Intl.message(
      'Request a refund',
      name: 'demanderUnRemboursement',
      desc: '',
      args: [],
    );
  }

  /// `Usage`
  String get utilisation {
    return Intl.message(
      'Usage',
      name: 'utilisation',
      desc: '',
      args: [],
    );
  }

  /// `No use cases registered for the moment`
  String get aucunCasDutilisationEnrgistrPourLeMoment {
    return Intl.message(
      'No use cases registered for the moment',
      name: 'aucunCasDutilisationEnrgistrPourLeMoment',
      desc: '',
      args: [],
    );
  }

  /// `Not specified`
  String get nonspcifi {
    return Intl.message(
      'Not specified',
      name: 'nonspcifi',
      desc: '',
      args: [],
    );
  }

  /// `More details`
  String get plusDeDtails {
    return Intl.message(
      'More details',
      name: 'plusDeDtails',
      desc: '',
      args: [],
    );
  }

  /// `Family Doctor`
  String get mdcinDeFamille {
    return Intl.message(
      'Family Doctor',
      name: 'mdcinDeFamille',
      desc: '',
      args: [],
    );
  }

  /// `No appointments scheduled for the moment.`
  String get aucunRendezvousEnrgistrPourLeMoment {
    return Intl.message(
      'No appointments scheduled for the moment.',
      name: 'aucunRendezvousEnrgistrPourLeMoment',
      desc: '',
      args: [],
    );
  }

  /// `Choose your \n`
  String get choisissezVotren {
    return Intl.message(
      'Choose your \n',
      name: 'choisissezVotren',
      desc: '',
      args: [],
    );
  }

  /// `My Benefits`
  String get mesAvantages {
    return Intl.message(
      'My Benefits',
      name: 'mesAvantages',
      desc: '',
      args: [],
    );
  }

  /// `Skincare base`
  String get fondDeSoin {
    return Intl.message(
      'Skincare base',
      name: 'fondDeSoin',
      desc: '',
      args: [],
    );
  }

  /// `Open Page...`
  String get ouvrirLaPage {
    return Intl.message(
      'Open Page...',
      name: 'ouvrirLaPage',
      desc: '',
      args: [],
    );
  }

  /// `Update your profile to take full advantage of your DanAid benefits`
  String get mettezJourVotreProfilPourPouvoirPleinementProfiterDeVos {
    return Intl.message(
      'Update your profile to take full advantage of your DanAid benefits',
      name: 'mettezJourVotreProfilPourPouvoirPleinementProfiterDeVos',
      desc: '',
      args: [],
    );
  }

  /// `Add your family members to your list of beneficiaries`
  String get ajouterLesMembresDeVotreFamilleVotreListeDeBnficiaires {
    return Intl.message(
      'Add your family members to your list of beneficiaries',
      name: 'ajouterLesMembresDeVotreFamilleVotreListeDeBnficiaires',
      desc: '',
      args: [],
    );
  }

  /// `Choose your DanAid family doctor`
  String get choisissezVotreMdecinDeFamilleDanaid {
    return Intl.message(
      'Choose your DanAid family doctor',
      name: 'choisissezVotreMdecinDeFamilleDanaid',
      desc: '',
      args: [],
    );
  }

  /// `You have not yet paid your subscription`
  String get vousNavezPasEncorePayVotreSouscription {
    return Intl.message(
      'You have not yet paid your subscription',
      name: 'vousNavezPasEncorePayVotreSouscription',
      desc: '',
      args: [],
    );
  }

  /// `No notifications for the moment`
  String get aucuneNotificationsPourLeMoment {
    return Intl.message(
      'No notifications for the moment',
      name: 'aucuneNotificationsPourLeMoment',
      desc: '',
      args: [],
    );
  }

  /// `Overview of your coverage`
  String get aperuDeVotreCouverture {
    return Intl.message(
      'Overview of your coverage',
      name: 'aperuDeVotreCouverture',
      desc: '',
      args: [],
    );
  }

  /// `You benefit from a `
  String get vousBnficiezDune {
    return Intl.message(
      'You benefit from a ',
      name: 'vousBnficiezDune',
      desc: '',
      args: [],
    );
  }

  /// `5% discount`
  String get rmiseDe5 {
    return Intl.message(
      '5% discount',
      name: 'rmiseDe5',
      desc: '',
      args: [],
    );
  }

  /// ` in some pharmacies and labs of the DanAid network`
  String get dansCertainesPharmaciesLabosDuRseauDanaid {
    return Intl.message(
      ' in some pharmacies and labs of the DanAid network',
      name: 'dansCertainesPharmaciesLabosDuRseauDanaid',
      desc: '',
      args: [],
    );
  }

  /// `Get comprehensive coverage at 70% !`
  String get obtenezUneCouvertureComplte70 {
    return Intl.message(
      'Get comprehensive coverage at 70% !',
      name: 'obtenezUneCouvertureComplte70',
      desc: '',
      args: [],
    );
  }

  /// `Account settings`
  String get paramtresDuCompte {
    return Intl.message(
      'Account settings',
      name: 'paramtresDuCompte',
      desc: '',
      args: [],
    );
  }

  /// `My statistics`
  String get mesStatistiques {
    return Intl.message(
      'My statistics',
      name: 'mesStatistiques',
      desc: '',
      args: [],
    );
  }

  /// `Primary residence`
  String get domicilePrincipale {
    return Intl.message(
      'Primary residence',
      name: 'domicilePrincipale',
      desc: '',
      args: [],
    );
  }

  /// `Consult...`
  String get consulter {
    return Intl.message(
      'Consult...',
      name: 'consulter',
      desc: '',
      args: [],
    );
  }

  /// `Points and badges`
  String get pointsEtBadges {
    return Intl.message(
      'Points and badges',
      name: 'pointsEtBadges',
      desc: '',
      args: [],
    );
  }

  /// `Consult and use its benefits.`
  String get consulterEtUtiliserSesBnfices {
    return Intl.message(
      'Consult and use its benefits.',
      name: 'consulterEtUtiliserSesBnfices',
      desc: '',
      args: [],
    );
  }

  /// `Change your service level`
  String get changezDeNiveauDeService {
    return Intl.message(
      'Change your service level',
      name: 'changezDeNiveauDeService',
      desc: '',
      args: [],
    );
  }

  /// `Compare levels and choose`
  String get comparerLesNiveauxEtChoisir {
    return Intl.message(
      'Compare levels and choose',
      name: 'comparerLesNiveauxEtChoisir',
      desc: '',
      args: [],
    );
  }

  /// `Change your family doctor`
  String get changezDeMedecinDeFamille {
    return Intl.message(
      'Change your family doctor',
      name: 'changezDeMedecinDeFamille',
      desc: '',
      args: [],
    );
  }

  /// `Make a request`
  String get faitesUneDemande {
    return Intl.message(
      'Make a request',
      name: 'faitesUneDemande',
      desc: '',
      args: [],
    );
  }

  /// `DanAid Documents`
  String get documentsDanaid {
    return Intl.message(
      'DanAid Documents',
      name: 'documentsDanaid',
      desc: '',
      args: [],
    );
  }

  /// `contracts, documents, guides`
  String get contratsDocumentsGuides {
    return Intl.message(
      'contracts, documents, guides',
      name: 'contratsDocumentsGuides',
      desc: '',
      args: [],
    );
  }

  /// `Find a Health Care Provider`
  String get trouverUnPrestataireDeSant {
    return Intl.message(
      'Find a Health Care Provider',
      name: 'trouverUnPrestataireDeSant',
      desc: '',
      args: [],
    );
  }

  /// `Search by entering the name of the practitioner or health care facility directly. You can also search for providers by selecting the groups below.`
  String get recherchezEnInscrivantDirectementLeNomDuPraticienOuDe {
    return Intl.message(
      'Search by entering the name of the practitioner or health care facility directly. You can also search for providers by selecting the groups below.',
      name: 'recherchezEnInscrivantDirectementLeNomDuPraticienOuDe',
      desc: '',
      args: [],
    );
  }

  /// `Other Specialists`
  String get autresSpcialistes {
    return Intl.message(
      'Other Specialists',
      name: 'autresSpcialistes',
      desc: '',
      args: [],
    );
  }

  /// `Hospital or clinic`
  String get hpitalOuClinique {
    return Intl.message(
      'Hospital or clinic',
      name: 'hpitalOuClinique',
      desc: '',
      args: [],
    );
  }

  /// `No doctor with the name `
  String get aucunMdecinAvecPourNom {
    return Intl.message(
      'No doctor with the name ',
      name: 'aucunMdecinAvecPourNom',
      desc: '',
      args: [],
    );
  }

  /// `Enter the name..`
  String get entrezLeNom {
    return Intl.message(
      'Enter the name..',
      name: 'entrezLeNom',
      desc: '',
      args: [],
    );
  }

  /// `Search for physicians`
  String get rechercheDeMdecins {
    return Intl.message(
      'Search for physicians',
      name: 'rechercheDeMdecins',
      desc: '',
      args: [],
    );
  }

  /// `Quantity:`
  String get quantit {
    return Intl.message(
      'Quantity:',
      name: 'quantit',
      desc: '',
      args: [],
    );
  }

  /// `Points to be deducted:`
  String get pointsDduire {
    return Intl.message(
      'Points to be deducted:',
      name: 'pointsDduire',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get commander {
    return Intl.message(
      'Order',
      name: 'commander',
      desc: '',
      args: [],
    );
  }

  /// `Name on the social network`
  String get nomSurLeRseauSocial {
    return Intl.message(
      'Name on the social network',
      name: 'nomSurLeRseauSocial',
      desc: '',
      args: [],
    );
  }

  /// `Profession`
  String get profession {
    return Intl.message(
      'Profession',
      name: 'profession',
      desc: '',
      args: [],
    );
  }

  /// `e.g.: Mechanic`
  String get exMchanicien {
    return Intl.message(
      'e.g.: Mechanic',
      name: 'exMchanicien',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get addresse {
    return Intl.message(
      'Address',
      name: 'addresse',
      desc: '',
      args: [],
    );
  }

  /// `eg: carrefour Obili`
  String get exCarrefourObili {
    return Intl.message(
      'eg: carrefour Obili',
      name: 'exCarrefourObili',
      desc: '',
      args: [],
    );
  }

  /// `Marital status`
  String get statutMatrimoniale {
    return Intl.message(
      'Marital status',
      name: 'statutMatrimoniale',
      desc: '',
      args: [],
    );
  }

  /// `Single`
  String get clibataire {
    return Intl.message(
      'Single',
      name: 'clibataire',
      desc: '',
      args: [],
    );
  }

  /// `Married `
  String get marriE {
    return Intl.message(
      'Married ',
      name: 'marriE',
      desc: '',
      args: [],
    );
  }

  /// `Finalization...`
  String get finalisation {
    return Intl.message(
      'Finalization...',
      name: 'finalisation',
      desc: '',
      args: [],
    );
  }

  /// `Request for reimbursement`
  String get dmandeDeRemboursement {
    return Intl.message(
      'Request for reimbursement',
      name: 'dmandeDeRemboursement',
      desc: '',
      args: [],
    );
  }

  /// `   Selecting the patient`
  String get slectionnerLePatient {
    return Intl.message(
      '   Selecting the patient',
      name: 'slectionnerLePatient',
      desc: '',
      args: [],
    );
  }

  /// `Start date *`
  String get dateDeDbut {
    return Intl.message(
      'Start date *',
      name: 'dateDeDbut',
      desc: '',
      args: [],
    );
  }

  /// `Circumstance`
  String get circonstance {
    return Intl.message(
      'Circumstance',
      name: 'circonstance',
      desc: '',
      args: [],
    );
  }

  /// `Emergency`
  String get urgence {
    return Intl.message(
      'Emergency',
      name: 'urgence',
      desc: '',
      args: [],
    );
  }

  /// `Establishment`
  String get etablissement {
    return Intl.message(
      'Establishment',
      name: 'etablissement',
      desc: '',
      args: [],
    );
  }

  /// `Scanning supporting documents`
  String get scannerLesDocumentsJustificatifs {
    return Intl.message(
      'Scanning supporting documents',
      name: 'scannerLesDocumentsJustificatifs',
      desc: '',
      args: [],
    );
  }

  /// `Receipt of payment *`
  String get reuDePaiement {
    return Intl.message(
      'Receipt of payment *',
      name: 'reuDePaiement',
      desc: '',
      args: [],
    );
  }

  /// `Request from `
  String get dmandeDu {
    return Intl.message(
      'Request from ',
      name: 'dmandeDu',
      desc: '',
      args: [],
    );
  }

  /// `Add benefits and receipts`
  String get ajouterDesPrestationsEtJustificatifs {
    return Intl.message(
      'Add benefits and receipts',
      name: 'ajouterDesPrestationsEtJustificatifs',
      desc: '',
      args: [],
    );
  }

  /// `Status of the request`
  String get statutDeLaDemande {
    return Intl.message(
      'Status of the request',
      name: 'statutDeLaDemande',
      desc: '',
      args: [],
    );
  }

  /// ` Approved`
  String get approuv {
    return Intl.message(
      ' Approved',
      name: 'approuv',
      desc: '',
      args: [],
    );
  }

  /// ` Rejected`
  String get rjt {
    return Intl.message(
      ' Rejected',
      name: 'rjt',
      desc: '',
      args: [],
    );
  }

  /// ` Closed`
  String get cltur {
    return Intl.message(
      ' Closed',
      name: 'cltur',
      desc: '',
      args: [],
    );
  }

  /// `Choose a service level`
  String get choisirUnNiveauDeServices {
    return Intl.message(
      'Choose a service level',
      name: 'choisirUnNiveauDeServices',
      desc: '',
      args: [],
    );
  }

  /// `Ceiling of`
  String get plafondDe {
    return Intl.message(
      'Ceiling of',
      name: 'plafondDe',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get niveau {
    return Intl.message(
      'Level',
      name: 'niveau',
      desc: '',
      args: [],
    );
  }

  /// `cover to`
  String get couverture {
    return Intl.message(
      'cover to',
      name: 'couverture',
      desc: '',
      args: [],
    );
  }

  /// `of expenses\n + Ceiling of care at`
  String get desFraisnPlafondDeSoins {
    return Intl.message(
      'of expenses\n + Ceiling of care at',
      name: 'desFraisnPlafondDeSoins',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get commencer {
    return Intl.message(
      'Start',
      name: 'commencer',
      desc: '',
      args: [],
    );
  }

  /// `Ask`
  String get demander {
    return Intl.message(
      'Ask',
      name: 'demander',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get posts {
    return Intl.message(
      'Posts',
      name: 'posts',
      desc: '',
      args: [],
    );
  }

  /// `Q&R`
  String get qr {
    return Intl.message(
      'Q&R',
      name: 'qr',
      desc: '',
      args: [],
    );
  }

  /// `Discussions`
  String get discussions {
    return Intl.message(
      'Discussions',
      name: 'discussions',
      desc: '',
      args: [],
    );
  }

  /// `Start a conversation...`
  String get commencezUneConversation {
    return Intl.message(
      'Start a conversation...',
      name: 'commencezUneConversation',
      desc: '',
      args: [],
    );
  }

  /// `Create a group`
  String get crerUnGroupe {
    return Intl.message(
      'Create a group',
      name: 'crerUnGroupe',
      desc: '',
      args: [],
    );
  }

  /// `wait`
  String get wait {
    return Intl.message(
      'wait',
      name: 'wait',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get image {
    return Intl.message(
      'Image',
      name: 'image',
      desc: '',
      args: [],
    );
  }

  /// `Sticker`
  String get sticker {
    return Intl.message(
      'Sticker',
      name: 'sticker',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get you {
    return Intl.message(
      'You',
      name: 'you',
      desc: '',
      args: [],
    );
  }

  /// `Write your comment`
  String get ecrireVotreCommentaire {
    return Intl.message(
      'Write your comment',
      name: 'ecrireVotreCommentaire',
      desc: '',
      args: [],
    );
  }

  /// `content`
  String get content {
    return Intl.message(
      'content',
      name: 'content',
      desc: '',
      args: [],
    );
  }

  /// `Aucun utilisateur avec pour nom`
  String get aucunUtilisateurAvecPourNom {
    return Intl.message(
      'Aucun utilisateur avec pour nom',
      name: 'aucunUtilisateurAvecPourNom',
      desc: '',
      args: [],
    );
  }

  /// `Search for users`
  String get cherchezDesUtilisateurs {
    return Intl.message(
      'Search for users',
      name: 'cherchezDesUtilisateurs',
      desc: '',
      args: [],
    );
  }

  /// `Add a photo`
  String get ajouterUnePhoto {
    return Intl.message(
      'Add a photo',
      name: 'ajouterUnePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Name of the group`
  String get nomDuGroupe {
    return Intl.message(
      'Name of the group',
      name: 'nomDuGroupe',
      desc: '',
      args: [],
    );
  }

  /// `Description of the group`
  String get descriptionDuGroupe {
    return Intl.message(
      'Description of the group',
      name: 'descriptionDuGroupe',
      desc: '',
      args: [],
    );
  }

  /// `Everyone can see, each entity can add members`
  String get toutLeMondePeutVoirChaqueIntitPeutAjouterDes {
    return Intl.message(
      'Everyone can see, each entity can add members',
      name: 'toutLeMondePeutVoirChaqueIntitPeutAjouterDes',
      desc: '',
      args: [],
    );
  }

  /// `Only guests can see, only the admin can add members.`
  String get seulsLesInvitsPeuventVoirSeulLadminPeutAjouterDes {
    return Intl.message(
      'Only guests can see, only the admin can add members.',
      name: 'seulsLesInvitsPeuventVoirSeulLadminPeutAjouterDes',
      desc: '',
      args: [],
    );
  }

  /// `Type of group *`
  String get typeDeGroupe {
    return Intl.message(
      'Type of group *',
      name: 'typeDeGroupe',
      desc: '',
      args: [],
    );
  }

  /// `Family Doctor Network`
  String get rseauMdecinDeFamille {
    return Intl.message(
      'Family Doctor Network',
      name: 'rseauMdecinDeFamille',
      desc: '',
      args: [],
    );
  }

  /// `MDF`
  String get mdf {
    return Intl.message(
      'MDF',
      name: 'mdf',
      desc: '',
      args: [],
    );
  }

  /// `ASSOCIATION`
  String get association {
    return Intl.message(
      'ASSOCIATION',
      name: 'association',
      desc: '',
      args: [],
    );
  }

  /// `ENTREPRISE`
  String get entreprise {
    return Intl.message(
      'ENTREPRISE',
      name: 'entreprise',
      desc: '',
      args: [],
    );
  }

  /// `SPONSOR`
  String get sponsor {
    return Intl.message(
      'SPONSOR',
      name: 'sponsor',
      desc: '',
      args: [],
    );
  }

  /// `Name of the organization`
  String get nomDeLorganisation {
    return Intl.message(
      'Name of the organization',
      name: 'nomDeLorganisation',
      desc: '',
      args: [],
    );
  }

  /// `Personne contact`
  String get personneContact {
    return Intl.message(
      'Personne contact',
      name: 'personneContact',
      desc: '',
      args: [],
    );
  }

  /// `Service provider`
  String get prestataire {
    return Intl.message(
      'Service provider',
      name: 'prestataire',
      desc: '',
      args: [],
    );
  }

  /// `Member`
  String get adhrent {
    return Intl.message(
      'Member',
      name: 'adhrent',
      desc: '',
      args: [],
    );
  }

  /// `Enter the names of the users to add...`
  String get entrezLesNomsDesUtilisateursAjouter {
    return Intl.message(
      'Enter the names of the users to add...',
      name: 'entrezLesNomsDesUtilisateursAjouter',
      desc: '',
      args: [],
    );
  }

  /// `Health`
  String get sant {
    return Intl.message(
      'Health',
      name: 'sant',
      desc: '',
      args: [],
    );
  }

  /// `Politics`
  String get politique {
    return Intl.message(
      'Politics',
      name: 'politique',
      desc: '',
      args: [],
    );
  }

  /// `Drug`
  String get mdicament {
    return Intl.message(
      'Drug',
      name: 'mdicament',
      desc: '',
      args: [],
    );
  }

  /// `Relaxation`
  String get dtente {
    return Intl.message(
      'Relaxation',
      name: 'dtente',
      desc: '',
      args: [],
    );
  }

  /// `Games`
  String get jeux {
    return Intl.message(
      'Games',
      name: 'jeux',
      desc: '',
      args: [],
    );
  }

  /// `DanAid`
  String get danaid {
    return Intl.message(
      'DanAid',
      name: 'danaid',
      desc: '',
      args: [],
    );
  }

  /// `Create a publication`
  String get crerUnePublication {
    return Intl.message(
      'Create a publication',
      name: 'crerUnePublication',
      desc: '',
      args: [],
    );
  }

  /// `Hello `
  String get bonjour {
    return Intl.message(
      'Hello ',
      name: 'bonjour',
      desc: '',
      args: [],
    );
  }

  /// `Question to a doctor`
  String get questionUnMdecin {
    return Intl.message(
      'Question to a doctor',
      name: 'questionUnMdecin',
      desc: '',
      args: [],
    );
  }

  /// `New Discussion`
  String get nouvelleDiscussion {
    return Intl.message(
      'New Discussion',
      name: 'nouvelleDiscussion',
      desc: '',
      args: [],
    );
  }

  /// `Fundraising`
  String get leveDeFonds {
    return Intl.message(
      'Fundraising',
      name: 'leveDeFonds',
      desc: '',
      args: [],
    );
  }

  /// ` Deadlines`
  String get dlais {
    return Intl.message(
      ' Deadlines',
      name: 'dlais',
      desc: '',
      args: [],
    );
  }

  /// ` Title`
  String get titre {
    return Intl.message(
      ' Title',
      name: 'titre',
      desc: '',
      args: [],
    );
  }

  /// `What do you mean...`
  String get queVoulezVousDire {
    return Intl.message(
      'What do you mean...',
      name: 'queVoulezVousDire',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get tags {
    return Intl.message(
      'Tags',
      name: 'tags',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get ajouter {
    return Intl.message(
      'Add',
      name: 'ajouter',
      desc: '',
      args: [],
    );
  }

  /// `Photo`
  String get photo {
    return Intl.message(
      'Photo',
      name: 'photo',
      desc: '',
      args: [],
    );
  }

  /// `Doc`
  String get doc {
    return Intl.message(
      'Doc',
      name: 'doc',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get vido {
    return Intl.message(
      'Video',
      name: 'vido',
      desc: '',
      args: [],
    );
  }

  /// `Audio`
  String get audio {
    return Intl.message(
      'Audio',
      name: 'audio',
      desc: '',
      args: [],
    );
  }

  /// `Publish`
  String get publier {
    return Intl.message(
      'Publish',
      name: 'publier',
      desc: '',
      args: [],
    );
  }

  /// `No discussion for the moment`
  String get aucuneDiscussionPourLeMoment {
    return Intl.message(
      'No discussion for the moment',
      name: 'aucuneDiscussionPourLeMoment',
      desc: '',
      args: [],
    );
  }

  /// `Il ya `
  String get ilYa {
    return Intl.message(
      'Il ya ',
      name: 'ilYa',
      desc: '',
      args: [],
    );
  }

  /// `No group for the moment`
  String get aucunGroupePourLeMoment {
    return Intl.message(
      'No group for the moment',
      name: 'aucunGroupePourLeMoment',
      desc: '',
      args: [],
    );
  }

  /// `Edition of the Post`
  String get editionDuPost {
    return Intl.message(
      'Edition of the Post',
      name: 'editionDuPost',
      desc: '',
      args: [],
    );
  }

  /// `   Replace`
  String get remplacer {
    return Intl.message(
      '   Replace',
      name: 'remplacer',
      desc: '',
      args: [],
    );
  }

  /// `Post Modified`
  String get postModifi {
    return Intl.message(
      'Post Modified',
      name: 'postModifi',
      desc: '',
      args: [],
    );
  }

  /// `Add a group`
  String get ajouterUnGroupe {
    return Intl.message(
      'Add a group',
      name: 'ajouterUnGroupe',
      desc: '',
      args: [],
    );
  }

  /// ` members`
  String get membres {
    return Intl.message(
      ' members',
      name: 'membres',
      desc: '',
      args: [],
    );
  }

  /// `News \n`
  String get nouvellesn {
    return Intl.message(
      'News \n',
      name: 'nouvellesn',
      desc: '',
      args: [],
    );
  }

  /// `Conversations`
  String get conversations {
    return Intl.message(
      'Conversations',
      name: 'conversations',
      desc: '',
      args: [],
    );
  }

  /// `News  \n`
  String get nouvellesN {
    return Intl.message(
      'News  \n',
      name: 'nouvellesN',
      desc: '',
      args: [],
    );
  }

  /// `Friendship requests`
  String get demandesDamiti {
    return Intl.message(
      'Friendship requests',
      name: 'demandesDamiti',
      desc: '',
      args: [],
    );
  }

  /// `No request for friendship`
  String get aucuneDmandeDamiti {
    return Intl.message(
      'No request for friendship',
      name: 'aucuneDmandeDamiti',
      desc: '',
      args: [],
    );
  }

  /// `Don't hesitate to make a friend request`
  String get nhsitezPasFaireUneDemandeDami {
    return Intl.message(
      'Don\'t hesitate to make a friend request',
      name: 'nhsitezPasFaireUneDemandeDami',
      desc: '',
      args: [],
    );
  }

  /// `No posts for the moment`
  String get aucunPostsPourLeMoment {
    return Intl.message(
      'No posts for the moment',
      name: 'aucunPostsPourLeMoment',
      desc: '',
      args: [],
    );
  }

  /// `No description provided`
  String get aucuneDescriptionFournie {
    return Intl.message(
      'No description provided',
      name: 'aucuneDescriptionFournie',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favoris {
    return Intl.message(
      'Favorites',
      name: 'favoris',
      desc: '',
      args: [],
    );
  }

  /// `Discover`
  String get dcouvrir {
    return Intl.message(
      'Discover',
      name: 'dcouvrir',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the DanAid Support Network`
  String get bienvenueAuRseauDentraideDanaid {
    return Intl.message(
      'Welcome to the DanAid Support Network',
      name: 'bienvenueAuRseauDentraideDanaid',
      desc: '',
      args: [],
    );
  }

  /// `What do you want to share?`
  String get queVoulezVousPartager {
    return Intl.message(
      'What do you want to share?',
      name: 'queVoulezVousPartager',
      desc: '',
      args: [],
    );
  }

  /// `News`
  String get actualits {
    return Intl.message(
      'News',
      name: 'actualits',
      desc: '',
      args: [],
    );
  }

  /// `Friends   `
  String get amis {
    return Intl.message(
      'Friends   ',
      name: 'amis',
      desc: '',
      args: [],
    );
  }

  /// `Groups`
  String get groupes {
    return Intl.message(
      'Groups',
      name: 'groupes',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get commenter {
    return Intl.message(
      'Comment',
      name: 'commenter',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get partager {
    return Intl.message(
      'Share',
      name: 'partager',
      desc: '',
      args: [],
    );
  }

  /// `like`
  String get aimer {
    return Intl.message(
      'like',
      name: 'aimer',
      desc: '',
      args: [],
    );
  }

  /// `Activity`
  String get activit {
    return Intl.message(
      'Activity',
      name: 'activit',
      desc: '',
      args: [],
    );
  }

  /// `Publications`
  String get publications {
    return Intl.message(
      'Publications',
      name: 'publications',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get commentaires {
    return Intl.message(
      'Comments',
      name: 'commentaires',
      desc: '',
      args: [],
    );
  }

  /// `Remove friend`
  String get rtirerLami {
    return Intl.message(
      'Remove friend',
      name: 'rtirerLami',
      desc: '',
      args: [],
    );
  }

  /// `Cancel request`
  String get annulerLaDemande {
    return Intl.message(
      'Cancel request',
      name: 'annulerLaDemande',
      desc: '',
      args: [],
    );
  }

  /// `Add a friend`
  String get ajouterUnAmi {
    return Intl.message(
      'Add a friend',
      name: 'ajouterUnAmi',
      desc: '',
      args: [],
    );
  }

  /// `Request cancelled`
  String get demandeAnnule {
    return Intl.message(
      'Request cancelled',
      name: 'demandeAnnule',
      desc: '',
      args: [],
    );
  }

  /// `Request sent`
  String get demandeEnvoye {
    return Intl.message(
      'Request sent',
      name: 'demandeEnvoye',
      desc: '',
      args: [],
    );
  }

  /// `Only friends can talk`
  String get seulsLesAmisPeuventConverser {
    return Intl.message(
      'Only friends can talk',
      name: 'seulsLesAmisPeuventConverser',
      desc: '',
      args: [],
    );
  }

  /// `Search for other users`
  String get cherchezDautresUtilisateurs {
    return Intl.message(
      'Search for other users',
      name: 'cherchezDautresUtilisateurs',
      desc: '',
      args: [],
    );
  }

  /// `70%`
  String get soixanteDixpourCent {
    return Intl.message(
      '70%',
      name: 'soixanteDixpourCent',
      desc: '',
      args: [],
    );
  }

  /// `The 100% Mobile Health Insurance`
  String get laMutuelleSant100Mobile {
    return Intl.message(
      'The 100% Mobile Health Insurance',
      name: 'laMutuelleSant100Mobile',
      desc: '',
      args: [],
    );
  }

  /// `A network of mutual aid`
  String get unRseauDentraide {
    return Intl.message(
      'A network of mutual aid',
      name: 'unRseauDentraide',
      desc: '',
      args: [],
    );
  }

  /// `A family doctor is following me`
  String get unMdecinDeFamilleMeSuit {
    return Intl.message(
      'A family doctor is following me',
      name: 'unMdecinDeFamilleMeSuit',
      desc: '',
      args: [],
    );
  }

  /// `With your family, benefit from a health coverage of `
  String get avecVotreFamilleBnficiezDuneCouvertureSantDe {
    return Intl.message(
      'With your family, benefit from a health coverage of ',
      name: 'avecVotreFamilleBnficiezDuneCouvertureSantDe',
      desc: '',
      args: [],
    );
  }

  /// `of your health expenses in `
  String get deVosDpensesSantEn {
    return Intl.message(
      'of your health expenses in ',
      name: 'deVosDpensesSantEn',
      desc: '',
      args: [],
    );
  }

  /// `1 hour, `
  String get UneHeure {
    return Intl.message(
      '1 hour, ',
      name: 'UneHeure',
      desc: '',
      args: [],
    );
  }

  /// ` everywhere!`
  String get partout {
    return Intl.message(
      ' everywhere!',
      name: 'partout',
      desc: '',
      args: [],
    );
  }

  /// `If you need help, get help from network members or a `
  String get enCasDeBesoinObtenezLaideDesMembresDuRseau {
    return Intl.message(
      'If you need help, get help from network members or a ',
      name: 'enCasDeBesoinObtenezLaideDesMembresDuRseau',
      desc: '',
      args: [],
    );
  }

  /// `My personal family doctor: received quickly, referred, long-term follow-up, a family doctor `
  String get monMdecinDeFamillePersonnelReuRapidementOrientSuiviLong {
    return Intl.message(
      'My personal family doctor: received quickly, referred, long-term follow-up, a family doctor ',
      name: 'monMdecinDeFamillePersonnelReuRapidementOrientSuiviLong',
      desc: '',
      args: [],
    );
  }

  /// `in a few minutes.`
  String get enQuelquesMinutes {
    return Intl.message(
      'in a few minutes.',
      name: 'enQuelquesMinutes',
      desc: '',
      args: [],
    );
  }

  /// `watches over our health`
  String get veilleSurNotreSant {
    return Intl.message(
      'watches over our health',
      name: 'veilleSurNotreSant',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `your function  `
  String get votreFunction {
    return Intl.message(
      'your function  ',
      name: 'votreFunction',
      desc: '',
      args: [],
    );
  }

  /// `Pharmacist (e)`
  String get pharmaciene {
    return Intl.message(
      'Pharmacist (e)',
      name: 'pharmaciene',
      desc: '',
      args: [],
    );
  }

  /// `Précisez l'emplacement de l'organisation`
  String get preciserLemplacementDeLorganisation {
    return Intl.message(
      'Précisez l\'emplacement de l\'organisation',
      name: 'preciserLemplacementDeLorganisation',
      desc: '',
      args: [],
    );
  }

  /// `ex:face pharmacie du lac`
  String get exfacePharmacieDuLac {
    return Intl.message(
      'ex:face pharmacie du lac',
      name: 'exfacePharmacieDuLac',
      desc: '',
      args: [],
    );
  }

  /// `Ambulances`
  String get ambulances {
    return Intl.message(
      'Ambulances',
      name: 'ambulances',
      desc: '',
      args: [],
    );
  }

  /// `Phamarmacy`
  String get phamarmacie {
    return Intl.message(
      'Phamarmacy',
      name: 'phamarmacie',
      desc: '',
      args: [],
    );
  }

  /// `Hospitalization`
  String get hospitalisation {
    return Intl.message(
      'Hospitalization',
      name: 'hospitalisation',
      desc: '',
      args: [],
    );
  }

  /// `Connection`
  String get connexion {
    return Intl.message(
      'Connection',
      name: 'connexion',
      desc: '',
      args: [],
    );
  }

  /// `Post reported!`
  String get postSignal {
    return Intl.message(
      'Post reported!',
      name: 'postSignal',
      desc: '',
      args: [],
    );
  }

  /// `Post successfully deleted!`
  String get postSupprimAvecSuccs {
    return Intl.message(
      'Post successfully deleted!',
      name: 'postSupprimAvecSuccs',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get editer {
    return Intl.message(
      'Edit',
      name: 'editer',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get signaler {
    return Intl.message(
      'Report',
      name: 'signaler',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get supprimer {
    return Intl.message(
      'Delete',
      name: 'supprimer',
      desc: '',
      args: [],
    );
  }

  /// `View the profile`
  String get voirLeProfil {
    return Intl.message(
      'View the profile',
      name: 'voirLeProfil',
      desc: '',
      args: [],
    );
  }

  /// `Please wait...`
  String get pleaseWait {
    return Intl.message(
      'Please wait...',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Service requested`
  String get serviceDemand {
    return Intl.message(
      'Service requested',
      name: 'serviceDemand',
      desc: '',
      args: [],
    );
  }

  /// `Other doctor...`
  String get autreMdecin {
    return Intl.message(
      'Other doctor...',
      name: 'autreMdecin',
      desc: '',
      args: [],
    );
  }

  /// `      Your appointment request is `
  String get votreDemandeDeRdvEst {
    return Intl.message(
      '      Your appointment request is ',
      name: 'votreDemandeDeRdvEst',
      desc: '',
      args: [],
    );
  }

  /// `Friendship requests`
  String get demandesDamitis {
    return Intl.message(
      'Friendship requests',
      name: 'demandesDamitis',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Use`
  String get conditionsndutilisation {
    return Intl.message(
      'Terms of Use',
      name: 'conditionsndutilisation',
      desc: '',
      args: [],
    );
  }

  /// ` reduce`
  String get readLess {
    return Intl.message(
      ' reduce',
      name: 'readLess',
      desc: '',
      args: [],
    );
  }

  /// ` ...read more`
  String get readMore {
    return Intl.message(
      ' ...read more',
      name: 'readMore',
      desc: '',
      args: [],
    );
  }

  /// `Beneficiary \n`
  String get bnficiairesn {
    return Intl.message(
      'Beneficiary \n',
      name: 'bnficiairesn',
      desc: '',
      args: [],
    );
  }

  /// `Who is sick? \n`
  String get quiEstMaladen {
    return Intl.message(
      'Who is sick? \n',
      name: 'quiEstMaladen',
      desc: '',
      args: [],
    );
  }

  /// ` persons`
  String get personnes {
    return Intl.message(
      ' persons',
      name: 'personnes',
      desc: '',
      args: [],
    );
  }

  /// `Coverage level 0: Discovery`
  String get couvertureNiveau0Dcouverte {
    return Intl.message(
      'Coverage level 0: Discovery',
      name: 'couvertureNiveau0Dcouverte',
      desc: '',
      args: [],
    );
  }

  /// `Coverage level I: Access`
  String get couvertureNiveauIAccs {
    return Intl.message(
      'Coverage level I: Access',
      name: 'couvertureNiveauIAccs',
      desc: '',
      args: [],
    );
  }

  /// `Level II coverage: Assist`
  String get couvertureNiveauIiAssist {
    return Intl.message(
      'Level II coverage: Assist',
      name: 'couvertureNiveauIiAssist',
      desc: '',
      args: [],
    );
  }

  /// `Level III coverage: Serenity`
  String get couvertureNiveauIiiSrnit {
    return Intl.message(
      'Level III coverage: Serenity',
      name: 'couvertureNiveauIiiSrnit',
      desc: '',
      args: [],
    );
  }

  /// `We were waiting for you...`
  String get nousVousAttendions {
    return Intl.message(
      'We were waiting for you...',
      name: 'nousVousAttendions',
      desc: '',
      args: [],
    );
  }

  /// `validate`
  String get valider {
    return Intl.message(
      'validate',
      name: 'valider',
      desc: '',
      args: [],
    );
  }

  /// `rejected`
  String get rejett {
    return Intl.message(
      'rejected',
      name: 'rejett',
      desc: '',
      args: [],
    );
  }

  /// `Audit`
  String get auditer {
    return Intl.message(
      'Audit',
      name: 'auditer',
      desc: '',
      args: [],
    );
  }

  /// `Valid until `
  String get valideJusquau {
    return Intl.message(
      'Valid until ',
      name: 'valideJusquau',
      desc: '',
      args: [],
    );
  }

  /// `Not defined`
  String get pasDefini {
    return Intl.message(
      'Not defined',
      name: 'pasDefini',
      desc: '',
      args: [],
    );
  }

  /// `Inactive Account`
  String get compteInactif {
    return Intl.message(
      'Inactive Account',
      name: 'compteInactif',
      desc: '',
      args: [],
    );
  }

  /// `Name of the beneficiary`
  String get nonDuBeneficiaire {
    return Intl.message(
      'Name of the beneficiary',
      name: 'nonDuBeneficiaire',
      desc: '',
      args: [],
    );
  }

  /// `Matricule number`
  String get numeroMatricule {
    return Intl.message(
      'Matricule number',
      name: 'numeroMatricule',
      desc: '',
      args: [],
    );
  }

  /// `Not defined `
  String get pasDefinie {
    return Intl.message(
      'Not defined ',
      name: 'pasDefinie',
      desc: '',
      args: [],
    );
  }

  /// ` posed a`
  String get aPosUne {
    return Intl.message(
      ' posed a',
      name: 'aPosUne',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message(
      'Question',
      name: 'question',
      desc: '',
      args: [],
    );
  }

  /// `Docta, what do you recommend in case of a fever of more than 40° in a child? And what are the measures taken in case of complications of the disease?  `
  String get doctaQueReccomendezVousEnCasDeFivreDePlus {
    return Intl.message(
      'Docta, what do you recommend in case of a fever of more than 40° in a child? And what are the measures taken in case of complications of the disease?  ',
      name: 'doctaQueReccomendezVousEnCasDeFivreDePlus',
      desc: '',
      args: [],
    );
  }

  /// ` ... reduce`
  String get reduire {
    return Intl.message(
      ' ... reduce',
      name: 'reduire',
      desc: '',
      args: [],
    );
  }

  /// `I hereby acknowledge that in the event of non-payment I am liable to`
  String get jeReconnaisParLaPrsenteQuenCasDeDfautDe {
    return Intl.message(
      'I hereby acknowledge that in the event of non-payment I am liable to',
      name: 'jeReconnaisParLaPrsenteQuenCasDeDfautDe',
      desc: '',
      args: [],
    );
  }

  /// `Legal proceedings \n`
  String get desPoursuiteJudiciairesn {
    return Intl.message(
      'Legal proceedings \n',
      name: 'desPoursuiteJudiciairesn',
      desc: '',
      args: [],
    );
  }

  /// `registration in the public file of bad payers `
  String get incriptionAuFichierPublicDesMauvaisPayeurs {
    return Intl.message(
      'registration in the public file of bad payers ',
      name: 'incriptionAuFichierPublicDesMauvaisPayeurs',
      desc: '',
      args: [],
    );
  }

  /// `Credit Risk Cameroun`
  String get creditRiskCameroun {
    return Intl.message(
      'Credit Risk Cameroun',
      name: 'creditRiskCameroun',
      desc: '',
      args: [],
    );
  }

  /// `A health support network`
  String get unRseauDentraideSant {
    return Intl.message(
      'A health support network',
      name: 'unRseauDentraideSant',
      desc: '',
      args: [],
    );
  }

  /// `Your consultations & detailed payment`
  String get vosConsultationsPaiementDetaill {
    return Intl.message(
      'Your consultations & detailed payment',
      name: 'vosConsultationsPaiementDetaill',
      desc: '',
      args: [],
    );
  }

  /// `Last updated: 2021-05-15 \n \n`
  String get lastUpdated20210515nn {
    return Intl.message(
      'Last updated: 2021-05-15 \n \n',
      name: 'lastUpdated20210515nn',
      desc: '',
      args: [],
    );
  }

  /// `1. Introduction\n\n`
  String get Introductionnn {
    return Intl.message(
      '1. Introduction\n\n',
      name: 'Introductionnn',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to `
  String get welcomeTo {
    return Intl.message(
      'Welcome to ',
      name: 'welcomeTo',
      desc: '',
      args: [],
    );
  }

  /// `("Company", "we", "our", "us")!\n\n`
  String get companyWeOurUsnn {
    return Intl.message(
      '("Company", "we", "our", "us")!\n\n',
      name: 'companyWeOurUsnn',
      desc: '',
      args: [],
    );
  }

  /// `These Terms of Service (“Terms”, “Terms of Service”) govern your use of our website located at danaid.org (together or individually “Service”) operated by `
  String get theseTermsOfServiceTermsTermsOfServiceGovernYour {
    return Intl.message(
      'These Terms of Service (“Terms”, “Terms of Service”) govern your use of our website located at danaid.org (together or individually “Service”) operated by ',
      name: 'theseTermsOfServiceTermsTermsOfServiceGovernYour',
      desc: '',
      args: [],
    );
  }

  /// `DanAid.\n\n`
  String get danaidnn {
    return Intl.message(
      'DanAid.\n\n',
      name: 'danaidnn',
      desc: '',
      args: [],
    );
  }

  /// `Our Privacy Policy also governs your use of our Service and explains how we collect, safeguard and disclose information that results from your use of our web pages.\n\n`
  String get ourPrivacyPolicyAlsoGovernsYourUseOfOurService {
    return Intl.message(
      'Our Privacy Policy also governs your use of our Service and explains how we collect, safeguard and disclose information that results from your use of our web pages.\n\n',
      name: 'ourPrivacyPolicyAlsoGovernsYourUseOfOurService',
      desc: '',
      args: [],
    );
  }

  /// `Your agreement with us includes these Terms and our Privacy Policy (“Agreements”). You acknowledge that you have read and understood Agreements, and agree to be bound of them.\n\n`
  String get yourAgreementWithUsIncludesTheseTermsAndOurPrivacy {
    return Intl.message(
      'Your agreement with us includes these Terms and our Privacy Policy (“Agreements”). You acknowledge that you have read and understood Agreements, and agree to be bound of them.\n\n',
      name: 'yourAgreementWithUsIncludesTheseTermsAndOurPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `If you do not agree with (or cannot comply with) Agreements, then you may not use the Service, but please let us know by emailing at `
  String get ifYouDoNotAgreeWithOrCannotComplyWith {
    return Intl.message(
      'If you do not agree with (or cannot comply with) Agreements, then you may not use the Service, but please let us know by emailing at ',
      name: 'ifYouDoNotAgreeWithOrCannotComplyWith',
      desc: '',
      args: [],
    );
  }

  /// `so we can try to find a solution. These Terms apply to all visitors, users and others who wish to access or use Service.\n\n`
  String get soWeCanTryToFindASolutionTheseTerms {
    return Intl.message(
      'so we can try to find a solution. These Terms apply to all visitors, users and others who wish to access or use Service.\n\n',
      name: 'soWeCanTryToFindASolutionTheseTerms',
      desc: '',
      args: [],
    );
  }

  /// `2. Communications\n\n`
  String get Communicationsnn {
    return Intl.message(
      '2. Communications\n\n',
      name: 'Communicationsnn',
      desc: '',
      args: [],
    );
  }

  /// `By using our Service, you agree to subscribe to newsletters, marketing or promotional materials and other information we may send. However, you may opt out of receiving any, or all, of these communications from us by following the unsubscribe link or by emailing at support@danaid.org.\n\n`
  String get byUsingOurServiceYouAgreeToSubscribeToNewsletters {
    return Intl.message(
      'By using our Service, you agree to subscribe to newsletters, marketing or promotional materials and other information we may send. However, you may opt out of receiving any, or all, of these communications from us by following the unsubscribe link or by emailing at support@danaid.org.\n\n',
      name: 'byUsingOurServiceYouAgreeToSubscribeToNewsletters',
      desc: '',
      args: [],
    );
  }

  /// `3. Purchases\n\n`
  String get Purchasesnn {
    return Intl.message(
      '3. Purchases\n\n',
      name: 'Purchasesnn',
      desc: '',
      args: [],
    );
  }

  /// `If you wish to purchase any product or service made available through Service (“Purchase”), you may be asked to supply certain information relevant to your Purchase including but not limited to, your credit or debit card number, the expiration date of your card, your billing address, and your shipping information.\n\n`
  String get ifYouWishToPurchaseAnyProductOrServiceMade {
    return Intl.message(
      'If you wish to purchase any product or service made available through Service (“Purchase”), you may be asked to supply certain information relevant to your Purchase including but not limited to, your credit or debit card number, the expiration date of your card, your billing address, and your shipping information.\n\n',
      name: 'ifYouWishToPurchaseAnyProductOrServiceMade',
      desc: '',
      args: [],
    );
  }

  /// `You represent and warrant that: (i) you have the legal right to use any card(s) or other payment method(s) in connection with any Purchase; and that (ii) the information you supply to us is true, correct and complete.\n\n`
  String get youRepresentAndWarrantThatIYouHaveTheLegal {
    return Intl.message(
      'You represent and warrant that: (i) you have the legal right to use any card(s) or other payment method(s) in connection with any Purchase; and that (ii) the information you supply to us is true, correct and complete.\n\n',
      name: 'youRepresentAndWarrantThatIYouHaveTheLegal',
      desc: '',
      args: [],
    );
  }

  /// `We may employ the use of third party services for the purpose of facilitating payment and the completion of Purchases. By submitting your information, you grant us the right to provide the information to these third parties subject to our Privacy Policy.\n\n`
  String get weMayEmployTheUseOfThirdPartyServicesFor {
    return Intl.message(
      'We may employ the use of third party services for the purpose of facilitating payment and the completion of Purchases. By submitting your information, you grant us the right to provide the information to these third parties subject to our Privacy Policy.\n\n',
      name: 'weMayEmployTheUseOfThirdPartyServicesFor',
      desc: '',
      args: [],
    );
  }

  /// `We reserve the right to refuse or cancel your order at any time for reasons including but not limited to: product or service availability, errors in the description or price of the product or service, error in your order or other reasons.\n\n`
  String get weReserveTheRightToRefuseOrCancelYourOrder {
    return Intl.message(
      'We reserve the right to refuse or cancel your order at any time for reasons including but not limited to: product or service availability, errors in the description or price of the product or service, error in your order or other reasons.\n\n',
      name: 'weReserveTheRightToRefuseOrCancelYourOrder',
      desc: '',
      args: [],
    );
  }

  /// `4. Contests, Sweepstakes and Promotions\n\n`
  String get ContestsSweepstakesAndPromotionsnn {
    return Intl.message(
      '4. Contests, Sweepstakes and Promotions\n\n',
      name: 'ContestsSweepstakesAndPromotionsnn',
      desc: '',
      args: [],
    );
  }

  /// `Any contests, sweepstakes or other promotions (collectively, “Promotions”) made available through Service may be governed by rules that are separate from these Terms of Service. If you participate in any Promotions, please review the applicable rules as well as our Privacy Policy. If the rules for a Promotion conflict with these Terms of Service, Promotion rules will apply.\n\n`
  String
      get anyContestsSweepstakesOrOtherPromotionsCollectivelyPromotionsMadeAvailable {
    return Intl.message(
      'Any contests, sweepstakes or other promotions (collectively, “Promotions”) made available through Service may be governed by rules that are separate from these Terms of Service. If you participate in any Promotions, please review the applicable rules as well as our Privacy Policy. If the rules for a Promotion conflict with these Terms of Service, Promotion rules will apply.\n\n',
      name:
          'anyContestsSweepstakesOrOtherPromotionsCollectivelyPromotionsMadeAvailable',
      desc: '',
      args: [],
    );
  }

  /// `5. Subscriptions\n\n`
  String get Subscriptionsnn {
    return Intl.message(
      '5. Subscriptions\n\n',
      name: 'Subscriptionsnn',
      desc: '',
      args: [],
    );
  }

  /// `Some parts of Service are billed on a subscription basis ("Subscription(s)"). You will be billed in advance on a recurring and periodic basis ("Billing Cycle"). Billing cycles will be set depending on the type of subscription plan you select when purchasing a Subscription.\n\n`
  String get somePartsOfServiceAreBilledOnASubscriptionBasis {
    return Intl.message(
      'Some parts of Service are billed on a subscription basis ("Subscription(s)"). You will be billed in advance on a recurring and periodic basis ("Billing Cycle"). Billing cycles will be set depending on the type of subscription plan you select when purchasing a Subscription.\n\n',
      name: 'somePartsOfServiceAreBilledOnASubscriptionBasis',
      desc: '',
      args: [],
    );
  }

  /// `At the end of each Billing Cycle, your Subscription will automatically renew under the exact same conditions unless you cancel it or DanAid cancels it. You may cancel your Subscription renewal either through your online account management page or by contacting support@danaid.org customer support team.\n\n`
  String get atTheEndOfEachBillingCycleYourSubscriptionWill {
    return Intl.message(
      'At the end of each Billing Cycle, your Subscription will automatically renew under the exact same conditions unless you cancel it or DanAid cancels it. You may cancel your Subscription renewal either through your online account management page or by contacting support@danaid.org customer support team.\n\n',
      name: 'atTheEndOfEachBillingCycleYourSubscriptionWill',
      desc: '',
      args: [],
    );
  }

  /// `A valid payment method is required to process the payment for your subscription. You shall provide DanAid with accurate and complete billing information that may include but not limited to full name, address, state, postal or zip code, telephone number, and a valid payment method information. By submitting such payment information, you automatically authorize DanAid to charge all Subscription fees incurred through your account to any such payment instruments.\n\n`
  String get aValidPaymentMethodIsRequiredToProcessThePayment {
    return Intl.message(
      'A valid payment method is required to process the payment for your subscription. You shall provide DanAid with accurate and complete billing information that may include but not limited to full name, address, state, postal or zip code, telephone number, and a valid payment method information. By submitting such payment information, you automatically authorize DanAid to charge all Subscription fees incurred through your account to any such payment instruments.\n\n',
      name: 'aValidPaymentMethodIsRequiredToProcessThePayment',
      desc: '',
      args: [],
    );
  }

  /// `Should automatic billing fail to occur for any reason, DanAid reserves the right to terminate your access to the Service with immediate effect.\n\n`
  String get shouldAutomaticBillingFailToOccurForAnyReasonDanaid {
    return Intl.message(
      'Should automatic billing fail to occur for any reason, DanAid reserves the right to terminate your access to the Service with immediate effect.\n\n',
      name: 'shouldAutomaticBillingFailToOccurForAnyReasonDanaid',
      desc: '',
      args: [],
    );
  }

  /// `6. Free Trial\n\n`
  String get FreeTrialnn {
    return Intl.message(
      '6. Free Trial\n\n',
      name: 'FreeTrialnn',
      desc: '',
      args: [],
    );
  }

  /// `DanAid may, at its sole discretion, offer a Subscription with a free trial for a limited period of time ("Free Trial").\n\n`
  String get danaidMayAtItsSoleDiscretionOfferASubscriptionWith {
    return Intl.message(
      'DanAid may, at its sole discretion, offer a Subscription with a free trial for a limited period of time ("Free Trial").\n\n',
      name: 'danaidMayAtItsSoleDiscretionOfferASubscriptionWith',
      desc: '',
      args: [],
    );
  }

  /// `You may be required to enter your billing information in order to sign up for Free Trial.\n\n`
  String get youMayBeRequiredToEnterYourBillingInformationIn {
    return Intl.message(
      'You may be required to enter your billing information in order to sign up for Free Trial.\n\n',
      name: 'youMayBeRequiredToEnterYourBillingInformationIn',
      desc: '',
      args: [],
    );
  }

  /// `If you do enter your billing information when signing up for Free Trial, you will not be charged by DanAid until Free Trial has expired. On the last day of Free Trial period, unless you cancelled your Subscription, you will be automatically charged the applicable Subscription fees for the type of Subscription you have selected.\n\n`
  String get ifYouDoEnterYourBillingInformationWhenSigningUp {
    return Intl.message(
      'If you do enter your billing information when signing up for Free Trial, you will not be charged by DanAid until Free Trial has expired. On the last day of Free Trial period, unless you cancelled your Subscription, you will be automatically charged the applicable Subscription fees for the type of Subscription you have selected.\n\n',
      name: 'ifYouDoEnterYourBillingInformationWhenSigningUp',
      desc: '',
      args: [],
    );
  }

  /// `At any time and without notice, DanAid reserves the right to (i) modify Terms of Service of Free Trial offer, or (ii) cancel such Free Trial offer.\n\n`
  String get atAnyTimeAndWithoutNoticeDanaidReservesTheRight {
    return Intl.message(
      'At any time and without notice, DanAid reserves the right to (i) modify Terms of Service of Free Trial offer, or (ii) cancel such Free Trial offer.\n\n',
      name: 'atAnyTimeAndWithoutNoticeDanaidReservesTheRight',
      desc: '',
      args: [],
    );
  }

  /// `7. Free Changes \n\n`
  String get FreeChangesNn {
    return Intl.message(
      '7. Free Changes \n\n',
      name: 'FreeChangesNn',
      desc: '',
      args: [],
    );
  }

  /// `DanAid, in its sole discretion and at any time, may modify Subscription fees for the Subscriptions. Any Subscription fee change will become effective at the end of the then-current Billing Cycle.\n\n`
  String get danaidInItsSoleDiscretionAndAtAnyTimeMay {
    return Intl.message(
      'DanAid, in its sole discretion and at any time, may modify Subscription fees for the Subscriptions. Any Subscription fee change will become effective at the end of the then-current Billing Cycle.\n\n',
      name: 'danaidInItsSoleDiscretionAndAtAnyTimeMay',
      desc: '',
      args: [],
    );
  }

  /// `DanAid will provide you with a reasonable prior notice of any change in Subscription fees to give you an opportunity to terminate your Subscription before such change becomes effective.\n\n`
  String get danaidWillProvideYouWithAReasonablePriorNoticeOf {
    return Intl.message(
      'DanAid will provide you with a reasonable prior notice of any change in Subscription fees to give you an opportunity to terminate your Subscription before such change becomes effective.\n\n',
      name: 'danaidWillProvideYouWithAReasonablePriorNoticeOf',
      desc: '',
      args: [],
    );
  }

  /// `Your continued use of Service after Subscription fee change comes into effect constitutes your agreement to pay the modified Subscription fee amount.\n\n`
  String get yourContinuedUseOfServiceAfterSubscriptionFeeChangeComes {
    return Intl.message(
      'Your continued use of Service after Subscription fee change comes into effect constitutes your agreement to pay the modified Subscription fee amount.\n\n',
      name: 'yourContinuedUseOfServiceAfterSubscriptionFeeChangeComes',
      desc: '',
      args: [],
    );
  }

  /// `8. Refunds \n\n`
  String get RefundsNn {
    return Intl.message(
      '8. Refunds \n\n',
      name: 'RefundsNn',
      desc: '',
      args: [],
    );
  }

  /// `We issue refunds for Contracts within `
  String get weIssueRefundsForContractsWithin {
    return Intl.message(
      'We issue refunds for Contracts within ',
      name: 'weIssueRefundsForContractsWithin',
      desc: '',
      args: [],
    );
  }

  /// `30 days`
  String get Days30 {
    return Intl.message(
      '30 days',
      name: 'Days30',
      desc: '',
      args: [],
    );
  }

  /// ` of the original purchase of the Contract.\n\n`
  String get ofTheOriginalPurchaseOfTheContractnn {
    return Intl.message(
      ' of the original purchase of the Contract.\n\n',
      name: 'ofTheOriginalPurchaseOfTheContractnn',
      desc: '',
      args: [],
    );
  }

  /// `9. Content\n\n`
  String get Contentnn {
    return Intl.message(
      '9. Content\n\n',
      name: 'Contentnn',
      desc: '',
      args: [],
    );
  }

  /// `Our Service allows you to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material (“Content”). You are responsible for Content that you post on or through Service, including its legality, reliability, and appropriateness.`
  String get ourServiceAllowsYouToPostLinkStoreShareAnd {
    return Intl.message(
      'Our Service allows you to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material (“Content”). You are responsible for Content that you post on or through Service, including its legality, reliability, and appropriateness.',
      name: 'ourServiceAllowsYouToPostLinkStoreShareAnd',
      desc: '',
      args: [],
    );
  }

  /// `By posting Content on or through Service, You represent and warrant that: (i) Content is yours (you own it) and/or you have the right to use it and the right to grant us the rights and license as provided in these Terms, and (ii) that the posting of your Content on or through Service does not violate the privacy rights, publicity rights, copyrights, contract rights or any other rights of any person or entity. We reserve the right to terminate the account of anyone found to be infringing on a copyright.`
  String get byPostingContentOnOrThroughServiceYouRepresentAnd {
    return Intl.message(
      'By posting Content on or through Service, You represent and warrant that: (i) Content is yours (you own it) and/or you have the right to use it and the right to grant us the rights and license as provided in these Terms, and (ii) that the posting of your Content on or through Service does not violate the privacy rights, publicity rights, copyrights, contract rights or any other rights of any person or entity. We reserve the right to terminate the account of anyone found to be infringing on a copyright.',
      name: 'byPostingContentOnOrThroughServiceYouRepresentAnd',
      desc: '',
      args: [],
    );
  }

  /// `You retain any and all of your rights to any Content you submit, post or display on or through Service and you are responsible for protecting those rights. We take no responsibility and assume no liability for Content you or any third party posts on or through Service. However, by posting Content using Service you grant us the right and license to use, modify, publicly perform, publicly display, reproduce, and distribute such Content on and through Service. You agree that this license includes the right for us to make your Content available to other users of Service, who may also use your Content subject to these Terms.`
  String get youRetainAnyAndAllOfYourRightsToAny {
    return Intl.message(
      'You retain any and all of your rights to any Content you submit, post or display on or through Service and you are responsible for protecting those rights. We take no responsibility and assume no liability for Content you or any third party posts on or through Service. However, by posting Content using Service you grant us the right and license to use, modify, publicly perform, publicly display, reproduce, and distribute such Content on and through Service. You agree that this license includes the right for us to make your Content available to other users of Service, who may also use your Content subject to these Terms.',
      name: 'youRetainAnyAndAllOfYourRightsToAny',
      desc: '',
      args: [],
    );
  }

  /// `DanAid has the right but not the obligation to monitor and edit all Content provided by users.`
  String get danaidHasTheRightButNotTheObligationToMonitor {
    return Intl.message(
      'DanAid has the right but not the obligation to monitor and edit all Content provided by users.',
      name: 'danaidHasTheRightButNotTheObligationToMonitor',
      desc: '',
      args: [],
    );
  }

  /// `In addition, Content found on or through this Service are the property of DanAid or used with permission. You may not distribute, modify, transmit, reuse, download, repost, copy, or use said Content, whether in whole or in part, for commercial purposes or for personal gain, without express advance written permission from us.\n\n`
  String get inAdditionContentFoundOnOrThroughThisServiceAre {
    return Intl.message(
      'In addition, Content found on or through this Service are the property of DanAid or used with permission. You may not distribute, modify, transmit, reuse, download, repost, copy, or use said Content, whether in whole or in part, for commercial purposes or for personal gain, without express advance written permission from us.\n\n',
      name: 'inAdditionContentFoundOnOrThroughThisServiceAre',
      desc: '',
      args: [],
    );
  }

  /// `10. Prohibited Uses\n\n`
  String get ProhibitedUsesnn {
    return Intl.message(
      '10. Prohibited Uses\n\n',
      name: 'ProhibitedUsesnn',
      desc: '',
      args: [],
    );
  }

  /// `You may use Service only for lawful purposes and in accordance with Terms. You agree not to use Service:\n\n`
  String get youMayUseServiceOnlyForLawfulPurposesAndIn {
    return Intl.message(
      'You may use Service only for lawful purposes and in accordance with Terms. You agree not to use Service:\n\n',
      name: 'youMayUseServiceOnlyForLawfulPurposesAndIn',
      desc: '',
      args: [],
    );
  }

  /// `0.1. In any way that violates any applicable national or international law or regulation.\n\n`
  String get InAnyWayThatViolatesAnyApplicableNationalOr {
    return Intl.message(
      '0.1. In any way that violates any applicable national or international law or regulation.\n\n',
      name: 'InAnyWayThatViolatesAnyApplicableNationalOr',
      desc: '',
      args: [],
    );
  }

  /// `0.2. For the purpose of exploiting, harming, or attempting to exploit or harm minors in any way by exposing them to inappropriate content or otherwise.\n\n`
  String get ForThePurposeOfExploitingHarmingOrAttemptingTo {
    return Intl.message(
      '0.2. For the purpose of exploiting, harming, or attempting to exploit or harm minors in any way by exposing them to inappropriate content or otherwise.\n\n',
      name: 'ForThePurposeOfExploitingHarmingOrAttemptingTo',
      desc: '',
      args: [],
    );
  }

  /// `0.3. To transmit, or procure the sending of, any advertising or promotional material, including any “junk mail”, “chain letter,” “spam,” or any other similar solicitation.\n\n`
  String get ToTransmitOrProcureTheSendingOfAnyAdvertising {
    return Intl.message(
      '0.3. To transmit, or procure the sending of, any advertising or promotional material, including any “junk mail”, “chain letter,” “spam,” or any other similar solicitation.\n\n',
      name: 'ToTransmitOrProcureTheSendingOfAnyAdvertising',
      desc: '',
      args: [],
    );
  }

  /// `0.4. To impersonate or attempt to impersonate Company, a Company employee, another user, or any other person or entity.\n\n`
  String get ToImpersonateOrAttemptToImpersonateCompanyACompany {
    return Intl.message(
      '0.4. To impersonate or attempt to impersonate Company, a Company employee, another user, or any other person or entity.\n\n',
      name: 'ToImpersonateOrAttemptToImpersonateCompanyACompany',
      desc: '',
      args: [],
    );
  }

  /// `0.5. In any way that infringes upon the rights of others, or in any way is illegal, threatening, fraudulent, or harmful, or in connection with any unlawful, illegal, fraudulent, or harmful purpose or activity.\n\n`
  String get InAnyWayThatInfringesUponTheRightsOf {
    return Intl.message(
      '0.5. In any way that infringes upon the rights of others, or in any way is illegal, threatening, fraudulent, or harmful, or in connection with any unlawful, illegal, fraudulent, or harmful purpose or activity.\n\n',
      name: 'InAnyWayThatInfringesUponTheRightsOf',
      desc: '',
      args: [],
    );
  }

  /// `0.6. To engage in any other conduct that restricts or inhibits anyone’s use or enjoyment of Service, or which, as determined by us, may harm or offend Company or users of Service or expose them to liability.\n\n`
  String get ToEngageInAnyOtherConductThatRestrictsOr {
    return Intl.message(
      '0.6. To engage in any other conduct that restricts or inhibits anyone’s use or enjoyment of Service, or which, as determined by us, may harm or offend Company or users of Service or expose them to liability.\n\n',
      name: 'ToEngageInAnyOtherConductThatRestrictsOr',
      desc: '',
      args: [],
    );
  }

  /// `Additionally, you agree not to:\n\n`
  String get additionallyYouAgreeNotTonn {
    return Intl.message(
      'Additionally, you agree not to:\n\n',
      name: 'additionallyYouAgreeNotTonn',
      desc: '',
      args: [],
    );
  }

  /// `0.1. Use Service in any manner that could disable, overburden, damage, or impair Service or interfere with any other party’s use of Service, including their ability to engage in real time activities through Service.\n\n`
  String get UseServiceInAnyMannerThatCouldDisableOverburden {
    return Intl.message(
      '0.1. Use Service in any manner that could disable, overburden, damage, or impair Service or interfere with any other party’s use of Service, including their ability to engage in real time activities through Service.\n\n',
      name: 'UseServiceInAnyMannerThatCouldDisableOverburden',
      desc: '',
      args: [],
    );
  }

  /// `0.2. Use any robot, spider, or other automatic device, process, or means to access Service for any purpose, including monitoring or copying any of the material on Service.\n\n`
  String get UseAnyRobotSpiderOrOtherAutomaticDeviceProcess {
    return Intl.message(
      '0.2. Use any robot, spider, or other automatic device, process, or means to access Service for any purpose, including monitoring or copying any of the material on Service.\n\n',
      name: 'UseAnyRobotSpiderOrOtherAutomaticDeviceProcess',
      desc: '',
      args: [],
    );
  }

  /// `0.3. Use any manual process to monitor or copy any of the material on Service or for any other unauthorized purpose without our prior written consent.\n\n`
  String get UseAnyManualProcessToMonitorOrCopyAny {
    return Intl.message(
      '0.3. Use any manual process to monitor or copy any of the material on Service or for any other unauthorized purpose without our prior written consent.\n\n',
      name: 'UseAnyManualProcessToMonitorOrCopyAny',
      desc: '',
      args: [],
    );
  }

  /// `0.4. Use any device, software, or routine that interferes with the proper working of Service.\n\n`
  String get UseAnyDeviceSoftwareOrRoutineThatInterferesWith {
    return Intl.message(
      '0.4. Use any device, software, or routine that interferes with the proper working of Service.\n\n',
      name: 'UseAnyDeviceSoftwareOrRoutineThatInterferesWith',
      desc: '',
      args: [],
    );
  }

  /// `0.5. Introduce any viruses, trojan horses, worms, logic bombs, or other material which is malicious or technologically harmful.\n\n`
  String get IntroduceAnyVirusesTrojanHorsesWormsLogicBombsOr {
    return Intl.message(
      '0.5. Introduce any viruses, trojan horses, worms, logic bombs, or other material which is malicious or technologically harmful.\n\n',
      name: 'IntroduceAnyVirusesTrojanHorsesWormsLogicBombsOr',
      desc: '',
      args: [],
    );
  }

  /// `0.6. Attempt to gain unauthorized access to, interfere with, damage, or disrupt any parts of Service, the server on which Service is stored, or any server, computer, or database connected to Service.\n\n`
  String get AttemptToGainUnauthorizedAccessToInterfereWithDamage {
    return Intl.message(
      '0.6. Attempt to gain unauthorized access to, interfere with, damage, or disrupt any parts of Service, the server on which Service is stored, or any server, computer, or database connected to Service.\n\n',
      name: 'AttemptToGainUnauthorizedAccessToInterfereWithDamage',
      desc: '',
      args: [],
    );
  }

  /// `0.7. Attack Service via a denial-of-service attack or a distributed denial-of-service attack.\n\n`
  String get AttackServiceViaADenialofserviceAttackOrADistributed {
    return Intl.message(
      '0.7. Attack Service via a denial-of-service attack or a distributed denial-of-service attack.\n\n',
      name: 'AttackServiceViaADenialofserviceAttackOrADistributed',
      desc: '',
      args: [],
    );
  }

  /// `0.8. Take any action that may damage or falsify Company rating.\n\n`
  String get TakeAnyActionThatMayDamageOrFalsifyCompany {
    return Intl.message(
      '0.8. Take any action that may damage or falsify Company rating.\n\n',
      name: 'TakeAnyActionThatMayDamageOrFalsifyCompany',
      desc: '',
      args: [],
    );
  }

  /// `0.9. Otherwise attempt to interfere with the proper working of Service.\n\n`
  String get OtherwiseAttemptToInterfereWithTheProperWorkingOf {
    return Intl.message(
      '0.9. Otherwise attempt to interfere with the proper working of Service.\n\n',
      name: 'OtherwiseAttemptToInterfereWithTheProperWorkingOf',
      desc: '',
      args: [],
    );
  }

  /// `11. Analytics\n\n`
  String get Analyticsnn {
    return Intl.message(
      '11. Analytics\n\n',
      name: 'Analyticsnn',
      desc: '',
      args: [],
    );
  }

  /// `We may use third-party Service Providers to monitor and analyze the use of our Service.\n\n`
  String get weMayUseThirdpartyServiceProvidersToMonitorAndAnalyze {
    return Intl.message(
      'We may use third-party Service Providers to monitor and analyze the use of our Service.\n\n',
      name: 'weMayUseThirdpartyServiceProvidersToMonitorAndAnalyze',
      desc: '',
      args: [],
    );
  }

  /// `12. No Use By Minors\n\n`
  String get NoUseByMinorsnn {
    return Intl.message(
      '12. No Use By Minors\n\n',
      name: 'NoUseByMinorsnn',
      desc: '',
      args: [],
    );
  }

  /// `Service is intended only for access and use by individuals at least eighteen (18) years old. By accessing or using Service, you warrant and represent that you are at least eighteen (18) years of age and with the full authority, right, and capacity to enter into this agreement and abide by all of the terms and conditions of Terms. If you are not at least eighteen (18) years old, you are prohibited from both the access and usage of Service.\n\n`
  String get serviceIsIntendedOnlyForAccessAndUseByIndividuals {
    return Intl.message(
      'Service is intended only for access and use by individuals at least eighteen (18) years old. By accessing or using Service, you warrant and represent that you are at least eighteen (18) years of age and with the full authority, right, and capacity to enter into this agreement and abide by all of the terms and conditions of Terms. If you are not at least eighteen (18) years old, you are prohibited from both the access and usage of Service.\n\n',
      name: 'serviceIsIntendedOnlyForAccessAndUseByIndividuals',
      desc: '',
      args: [],
    );
  }

  /// `13. Accounts\n\n`
  String get Accountsnn {
    return Intl.message(
      '13. Accounts\n\n',
      name: 'Accountsnn',
      desc: '',
      args: [],
    );
  }

  /// `When you create an account with us, you guarantee that you are above the age of 18, and that the information you provide us is accurate, complete, and current at all times. Inaccurate, incomplete, or obsolete information may result in the immediate termination of your account on Service.\n\n`
  String get whenYouCreateAnAccountWithUsYouGuaranteeThat {
    return Intl.message(
      'When you create an account with us, you guarantee that you are above the age of 18, and that the information you provide us is accurate, complete, and current at all times. Inaccurate, incomplete, or obsolete information may result in the immediate termination of your account on Service.\n\n',
      name: 'whenYouCreateAnAccountWithUsYouGuaranteeThat',
      desc: '',
      args: [],
    );
  }

  /// `You are responsible for maintaining the confidentiality of your account and password, including but not limited to the restriction of access to your computer and/or account. You agree to accept responsibility for any and all activities or actions that occur under your account and/or password, whether your password is with our Service or a third-party service. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account.\n\n`
  String get youAreResponsibleForMaintainingTheConfidentialityOfYourAccount {
    return Intl.message(
      'You are responsible for maintaining the confidentiality of your account and password, including but not limited to the restriction of access to your computer and/or account. You agree to accept responsibility for any and all activities or actions that occur under your account and/or password, whether your password is with our Service or a third-party service. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account.\n\n',
      name: 'youAreResponsibleForMaintainingTheConfidentialityOfYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `You may not use as a username the name of another person or entity or that is not lawfully available for use, a name or trademark that is subject to any rights of another person or entity other than you, without appropriate authorization. You may not use as a username any name that is offensive, vulgar or obscene.\n\n`
  String get youMayNotUseAsAUsernameTheNameOf {
    return Intl.message(
      'You may not use as a username the name of another person or entity or that is not lawfully available for use, a name or trademark that is subject to any rights of another person or entity other than you, without appropriate authorization. You may not use as a username any name that is offensive, vulgar or obscene.\n\n',
      name: 'youMayNotUseAsAUsernameTheNameOf',
      desc: '',
      args: [],
    );
  }

  /// `We reserve the right to refuse service, terminate accounts, remove or edit content, or cancel orders in our sole discretion.\n\n`
  String get weReserveTheRightToRefuseServiceTerminateAccountsRemove {
    return Intl.message(
      'We reserve the right to refuse service, terminate accounts, remove or edit content, or cancel orders in our sole discretion.\n\n',
      name: 'weReserveTheRightToRefuseServiceTerminateAccountsRemove',
      desc: '',
      args: [],
    );
  }

  /// `14. Intellectual Property\n\n`
  String get IntellectualPropertynn {
    return Intl.message(
      '14. Intellectual Property\n\n',
      name: 'IntellectualPropertynn',
      desc: '',
      args: [],
    );
  }

  /// `Service and its original content (excluding Content provided by users), features and functionality are and will remain the exclusive property of DanAid and its licensors. Service is protected by copyright, trademark, and other laws of and foreign countries. Our trademarks may not be used in connection with any product or service without the prior written consent of DanAid.\n\n`
  String get serviceAndItsOriginalContentExcludingContentProvidedByUsers {
    return Intl.message(
      'Service and its original content (excluding Content provided by users), features and functionality are and will remain the exclusive property of DanAid and its licensors. Service is protected by copyright, trademark, and other laws of and foreign countries. Our trademarks may not be used in connection with any product or service without the prior written consent of DanAid.\n\n',
      name: 'serviceAndItsOriginalContentExcludingContentProvidedByUsers',
      desc: '',
      args: [],
    );
  }

  /// `15. Copyright Policy\n\n`
  String get CopyrightPolicynn {
    return Intl.message(
      '15. Copyright Policy\n\n',
      name: 'CopyrightPolicynn',
      desc: '',
      args: [],
    );
  }

  /// `We respect the intellectual property rights of others. It is our policy to respond to any claim that Content posted on Service infringes on the copyright or other intellectual property rights (“Infringement”) of any person or entity.\n\n`
  String get weRespectTheIntellectualPropertyRightsOfOthersItIs {
    return Intl.message(
      'We respect the intellectual property rights of others. It is our policy to respond to any claim that Content posted on Service infringes on the copyright or other intellectual property rights (“Infringement”) of any person or entity.\n\n',
      name: 'weRespectTheIntellectualPropertyRightsOfOthersItIs',
      desc: '',
      args: [],
    );
  }

  /// `If you are a copyright owner, or authorized on behalf of one, and you believe that the copyrighted work has been copied in a way that constitutes copyright infringement, please submit your claim via email to support@danaid.org, with the subject line: “Copyright Infringement” and include in your claim a detailed description of the alleged Infringement as detailed below, under “DMCA Notice and Procedure for Copyright Infringement Claims”\n\n`
  String get ifYouAreACopyrightOwnerOrAuthorizedOnBehalf {
    return Intl.message(
      'If you are a copyright owner, or authorized on behalf of one, and you believe that the copyrighted work has been copied in a way that constitutes copyright infringement, please submit your claim via email to support@danaid.org, with the subject line: “Copyright Infringement” and include in your claim a detailed description of the alleged Infringement as detailed below, under “DMCA Notice and Procedure for Copyright Infringement Claims”\n\n',
      name: 'ifYouAreACopyrightOwnerOrAuthorizedOnBehalf',
      desc: '',
      args: [],
    );
  }

  /// `You may be held accountable for damages (including costs and attorneys’ fees) for misrepresentation or bad-faith claims on the infringement of any Content found on and/or through Service on your copyright.\n\n`
  String get youMayBeHeldAccountableForDamagesIncludingCostsAnd {
    return Intl.message(
      'You may be held accountable for damages (including costs and attorneys’ fees) for misrepresentation or bad-faith claims on the infringement of any Content found on and/or through Service on your copyright.\n\n',
      name: 'youMayBeHeldAccountableForDamagesIncludingCostsAnd',
      desc: '',
      args: [],
    );
  }

  /// `16. DMCA Notice and Procedure for Copyright Infringement Claims\n\n`
  String get DmcaNoticeAndProcedureForCopyrightInfringementClaimsnn {
    return Intl.message(
      '16. DMCA Notice and Procedure for Copyright Infringement Claims\n\n',
      name: 'DmcaNoticeAndProcedureForCopyrightInfringementClaimsnn',
      desc: '',
      args: [],
    );
  }

  /// `You may submit a notification pursuant to the Digital Millennium Copyright Act (DMCA) by providing our Copyright Agent with the following information in writing (see 17 U.S.C 512(c)(3) for further detail):\n\n`
  String get youMaySubmitANotificationPursuantToTheDigitalMillennium {
    return Intl.message(
      'You may submit a notification pursuant to the Digital Millennium Copyright Act (DMCA) by providing our Copyright Agent with the following information in writing (see 17 U.S.C 512(c)(3) for further detail):\n\n',
      name: 'youMaySubmitANotificationPursuantToTheDigitalMillennium',
      desc: '',
      args: [],
    );
  }

  /// `0.1. an electronic or physical signature of the person authorized to act on behalf of the owner of the copyright’s interest;\n\n`
  String get AnElectronicOrPhysicalSignatureOfThePersonAuthorized {
    return Intl.message(
      '0.1. an electronic or physical signature of the person authorized to act on behalf of the owner of the copyright’s interest;\n\n',
      name: 'AnElectronicOrPhysicalSignatureOfThePersonAuthorized',
      desc: '',
      args: [],
    );
  }

  /// `0.2. a description of the copyrighted work that you claim has been infringed, including the URL (i.e., web page address) of the location where the copyrighted work exists or a copy of the copyrighted work;\n\n`
  String get ADescriptionOfTheCopyrightedWorkThatYouClaim {
    return Intl.message(
      '0.2. a description of the copyrighted work that you claim has been infringed, including the URL (i.e., web page address) of the location where the copyrighted work exists or a copy of the copyrighted work;\n\n',
      name: 'ADescriptionOfTheCopyrightedWorkThatYouClaim',
      desc: '',
      args: [],
    );
  }

  /// `0.3. identification of the URL or other specific location on Service where the material that you claim is infringing is located;\n\n`
  String get IdentificationOfTheUrlOrOtherSpecificLocationOn {
    return Intl.message(
      '0.3. identification of the URL or other specific location on Service where the material that you claim is infringing is located;\n\n',
      name: 'IdentificationOfTheUrlOrOtherSpecificLocationOn',
      desc: '',
      args: [],
    );
  }

  /// `0.4. your address, telephone number, and email address;\n\n`
  String get YourAddressTelephoneNumberAndEmailAddressnn {
    return Intl.message(
      '0.4. your address, telephone number, and email address;\n\n',
      name: 'YourAddressTelephoneNumberAndEmailAddressnn',
      desc: '',
      args: [],
    );
  }

  /// `0.5. a statement by you that you have a good faith belief that the disputed use is not authorized by the copyright owner, its agent, or the law;\n\n`
  String get AStatementByYouThatYouHaveAGood {
    return Intl.message(
      '0.5. a statement by you that you have a good faith belief that the disputed use is not authorized by the copyright owner, its agent, or the law;\n\n',
      name: 'AStatementByYouThatYouHaveAGood',
      desc: '',
      args: [],
    );
  }

  /// `0.6. a statement by you, made under penalty of perjury, that the above information in your notice is accurate and that you are the copyright owner or authorized to act on the copyright owner’s behalf.\n\n`
  String get AStatementByYouMadeUnderPenaltyOfPerjury {
    return Intl.message(
      '0.6. a statement by you, made under penalty of perjury, that the above information in your notice is accurate and that you are the copyright owner or authorized to act on the copyright owner’s behalf.\n\n',
      name: 'AStatementByYouMadeUnderPenaltyOfPerjury',
      desc: '',
      args: [],
    );
  }

  /// `You can contact our Copyright Agent via email at support@danaid.org.\n\n`
  String get youCanContactOurCopyrightAgentViaEmailAtSupportdanaidorgnn {
    return Intl.message(
      'You can contact our Copyright Agent via email at support@danaid.org.\n\n',
      name: 'youCanContactOurCopyrightAgentViaEmailAtSupportdanaidorgnn',
      desc: '',
      args: [],
    );
  }

  /// `17. Error Reporting and Feedback\n\n`
  String get ErrorReportingAndFeedbacknn {
    return Intl.message(
      '17. Error Reporting and Feedback\n\n',
      name: 'ErrorReportingAndFeedbacknn',
      desc: '',
      args: [],
    );
  }

  /// `You may provide us either directly at support@danaid.org or via third party sites and tools with information and feedback concerning errors, suggestions for improvements, ideas, problems, complaints, and other matters related to our Service (“Feedback”). You acknowledge and agree that: (i) you shall not retain, acquire or assert any intellectual property right or other right, title or interest in or to the Feedback; (ii) Company may have development ideas similar to the Feedback; (iii) Feedback does not contain confidential information or proprietary information from you or any third party; and (iv) Company is not under any obligation of confidentiality with respect to the Feedback. In the event the transfer of the ownership to the Feedback is not possible due to applicable mandatory laws, you grant Company and its affiliates an exclusive, transferable, irrevocable, free-of-charge, sub-licensable, unlimited and perpetual right to use (including copy, modify, create derivative works, publish, distribute and commercialize) Feedback in any manner and for any purpose.\n\n`
  String get youMayProvideUsEitherDirectlyAtSupportdanaidorgOrVia {
    return Intl.message(
      'You may provide us either directly at support@danaid.org or via third party sites and tools with information and feedback concerning errors, suggestions for improvements, ideas, problems, complaints, and other matters related to our Service (“Feedback”). You acknowledge and agree that: (i) you shall not retain, acquire or assert any intellectual property right or other right, title or interest in or to the Feedback; (ii) Company may have development ideas similar to the Feedback; (iii) Feedback does not contain confidential information or proprietary information from you or any third party; and (iv) Company is not under any obligation of confidentiality with respect to the Feedback. In the event the transfer of the ownership to the Feedback is not possible due to applicable mandatory laws, you grant Company and its affiliates an exclusive, transferable, irrevocable, free-of-charge, sub-licensable, unlimited and perpetual right to use (including copy, modify, create derivative works, publish, distribute and commercialize) Feedback in any manner and for any purpose.\n\n',
      name: 'youMayProvideUsEitherDirectlyAtSupportdanaidorgOrVia',
      desc: '',
      args: [],
    );
  }

  /// `18. Links To Other Web Sites\n\n`
  String get LinksToOtherWebSitesnn {
    return Intl.message(
      '18. Links To Other Web Sites\n\n',
      name: 'LinksToOtherWebSitesnn',
      desc: '',
      args: [],
    );
  }

  /// `Our Service may contain links to third party web sites or services that are not owned or controlled by DanAid.\n\n`
  String get ourServiceMayContainLinksToThirdPartyWebSites {
    return Intl.message(
      'Our Service may contain links to third party web sites or services that are not owned or controlled by DanAid.\n\n',
      name: 'ourServiceMayContainLinksToThirdPartyWebSites',
      desc: '',
      args: [],
    );
  }

  /// `DanAid has no control over, and assumes no responsibility for the content, privacy policies, or practices of any third party web sites or services. We do not warrant the offerings of any of these entities/individuals or their websites.\n\n`
  String get danaidHasNoControlOverAndAssumesNoResponsibilityFor {
    return Intl.message(
      'DanAid has no control over, and assumes no responsibility for the content, privacy policies, or practices of any third party web sites or services. We do not warrant the offerings of any of these entities/individuals or their websites.\n\n',
      name: 'danaidHasNoControlOverAndAssumesNoResponsibilityFor',
      desc: '',
      args: [],
    );
  }

  /// `For example, the outlined Terms of Use have been created using PolicyMaker.io, a free web application for generating high-quality legal documents. PolicyMaker’s Terms and Conditions generator is an easy-to-use free tool for creating an excellent standard Terms of Service template for a website, blog, e-commerce store or app.\n\n`
  String get forExampleTheOutlinedTermsOfUseHaveBeenCreated {
    return Intl.message(
      'For example, the outlined Terms of Use have been created using PolicyMaker.io, a free web application for generating high-quality legal documents. PolicyMaker’s Terms and Conditions generator is an easy-to-use free tool for creating an excellent standard Terms of Service template for a website, blog, e-commerce store or app.\n\n',
      name: 'forExampleTheOutlinedTermsOfUseHaveBeenCreated',
      desc: '',
      args: [],
    );
  }

  /// `YOU ACKNOWLEDGE AND AGREE THAT COMPANY SHALL NOT BE RESPONSIBLE OR LIABLE, DIRECTLY OR INDIRECTLY, FOR ANY DAMAGE OR LOSS CAUSED OR ALLEGED TO BE CAUSED BY OR IN CONNECTION WITH USE OF OR RELIANCE ON ANY SUCH CONTENT, GOODS OR SERVICES AVAILABLE ON OR THROUGH ANY SUCH THIRD PARTY WEB SITES OR SERVICES.\n\n`
  String get youAcknowledgeAndAgreeThatCompanyShallNotBeResponsible {
    return Intl.message(
      'YOU ACKNOWLEDGE AND AGREE THAT COMPANY SHALL NOT BE RESPONSIBLE OR LIABLE, DIRECTLY OR INDIRECTLY, FOR ANY DAMAGE OR LOSS CAUSED OR ALLEGED TO BE CAUSED BY OR IN CONNECTION WITH USE OF OR RELIANCE ON ANY SUCH CONTENT, GOODS OR SERVICES AVAILABLE ON OR THROUGH ANY SUCH THIRD PARTY WEB SITES OR SERVICES.\n\n',
      name: 'youAcknowledgeAndAgreeThatCompanyShallNotBeResponsible',
      desc: '',
      args: [],
    );
  }

  /// `WE STRONGLY ADVISE YOU TO READ THE TERMS OF SERVICE AND PRIVACY POLICIES OF ANY THIRD PARTY WEB SITES OR SERVICES THAT YOU VISIT.\n\n`
  String get weStronglyAdviseYouToReadTheTermsOfService {
    return Intl.message(
      'WE STRONGLY ADVISE YOU TO READ THE TERMS OF SERVICE AND PRIVACY POLICIES OF ANY THIRD PARTY WEB SITES OR SERVICES THAT YOU VISIT.\n\n',
      name: 'weStronglyAdviseYouToReadTheTermsOfService',
      desc: '',
      args: [],
    );
  }

  /// `19. Disclaimer Of Warranty\n\n`
  String get DisclaimerOfWarrantynn {
    return Intl.message(
      '19. Disclaimer Of Warranty\n\n',
      name: 'DisclaimerOfWarrantynn',
      desc: '',
      args: [],
    );
  }

  /// `THESE SERVICES ARE PROVIDED BY COMPANY ON AN “AS IS” AND “AS AVAILABLE” BASIS. COMPANY MAKES NO REPRESENTATIONS OR WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, AS TO THE OPERATION OF THEIR SERVICES, OR THE INFORMATION, CONTENT OR MATERIALS INCLUDED THEREIN. YOU EXPRESSLY AGREE THAT YOUR USE OF THESE SERVICES, THEIR CONTENT, AND ANY SERVICES OR ITEMS OBTAINED FROM US IS AT YOUR SOLE RISK.\n\n`
  String get theseServicesAreProvidedByCompanyOnAnAsIs {
    return Intl.message(
      'THESE SERVICES ARE PROVIDED BY COMPANY ON AN “AS IS” AND “AS AVAILABLE” BASIS. COMPANY MAKES NO REPRESENTATIONS OR WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, AS TO THE OPERATION OF THEIR SERVICES, OR THE INFORMATION, CONTENT OR MATERIALS INCLUDED THEREIN. YOU EXPRESSLY AGREE THAT YOUR USE OF THESE SERVICES, THEIR CONTENT, AND ANY SERVICES OR ITEMS OBTAINED FROM US IS AT YOUR SOLE RISK.\n\n',
      name: 'theseServicesAreProvidedByCompanyOnAnAsIs',
      desc: '',
      args: [],
    );
  }

  /// `NEITHER COMPANY NOR ANY PERSON ASSOCIATED WITH COMPANY MAKES ANY WARRANTY OR REPRESENTATION WITH RESPECT TO THE COMPLETENESS, SECURITY, RELIABILITY, QUALITY, ACCURACY, OR AVAILABILITY OF THE SERVICES. WITHOUT LIMITING THE FOREGOING, NEITHER COMPANY NOR ANYONE ASSOCIATED WITH COMPANY REPRESENTS OR WARRANTS THAT THE SERVICES, THEIR CONTENT, OR ANY SERVICES OR ITEMS OBTAINED THROUGH THE SERVICES WILL BE ACCURATE, RELIABLE, ERROR-FREE, OR UNINTERRUPTED, THAT DEFECTS WILL BE CORRECTED, THAT THE SERVICES OR THE SERVER THAT MAKES IT AVAILABLE ARE FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS OR THAT THE SERVICES OR ANY SERVICES OR ITEMS OBTAINED THROUGH THE SERVICES WILL OTHERWISE MEET YOUR NEEDS OR EXPECTATIONS.\n\n`
  String get neitherCompanyNorAnyPersonAssociatedWithCompanyMakesAny {
    return Intl.message(
      'NEITHER COMPANY NOR ANY PERSON ASSOCIATED WITH COMPANY MAKES ANY WARRANTY OR REPRESENTATION WITH RESPECT TO THE COMPLETENESS, SECURITY, RELIABILITY, QUALITY, ACCURACY, OR AVAILABILITY OF THE SERVICES. WITHOUT LIMITING THE FOREGOING, NEITHER COMPANY NOR ANYONE ASSOCIATED WITH COMPANY REPRESENTS OR WARRANTS THAT THE SERVICES, THEIR CONTENT, OR ANY SERVICES OR ITEMS OBTAINED THROUGH THE SERVICES WILL BE ACCURATE, RELIABLE, ERROR-FREE, OR UNINTERRUPTED, THAT DEFECTS WILL BE CORRECTED, THAT THE SERVICES OR THE SERVER THAT MAKES IT AVAILABLE ARE FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS OR THAT THE SERVICES OR ANY SERVICES OR ITEMS OBTAINED THROUGH THE SERVICES WILL OTHERWISE MEET YOUR NEEDS OR EXPECTATIONS.\n\n',
      name: 'neitherCompanyNorAnyPersonAssociatedWithCompanyMakesAny',
      desc: '',
      args: [],
    );
  }

  /// `COMPANY HEREBY DISCLAIMS ALL WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED, STATUTORY, OR OTHERWISE, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, AND FITNESS FOR PARTICULAR PURPOSE.\n\n`
  String get companyHerebyDisclaimsAllWarrantiesOfAnyKindWhetherExpress {
    return Intl.message(
      'COMPANY HEREBY DISCLAIMS ALL WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED, STATUTORY, OR OTHERWISE, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, AND FITNESS FOR PARTICULAR PURPOSE.\n\n',
      name: 'companyHerebyDisclaimsAllWarrantiesOfAnyKindWhetherExpress',
      desc: '',
      args: [],
    );
  }

  /// `THE FOREGOING DOES NOT AFFECT ANY WARRANTIES WHICH CANNOT BE EXCLUDED OR LIMITED UNDER APPLICABLE LAW.\n\n`
  String get theForegoingDoesNotAffectAnyWarrantiesWhichCannotBe {
    return Intl.message(
      'THE FOREGOING DOES NOT AFFECT ANY WARRANTIES WHICH CANNOT BE EXCLUDED OR LIMITED UNDER APPLICABLE LAW.\n\n',
      name: 'theForegoingDoesNotAffectAnyWarrantiesWhichCannotBe',
      desc: '',
      args: [],
    );
  }

  /// `20. Limitation Of Liability\n\n`
  String get LimitationOfLiabilitynn {
    return Intl.message(
      '20. Limitation Of Liability\n\n',
      name: 'LimitationOfLiabilitynn',
      desc: '',
      args: [],
    );
  }

  /// `EXCEPT AS PROHIBITED BY LAW, YOU WILL HOLD US AND OUR OFFICERS, DIRECTORS, EMPLOYEES, AND AGENTS HARMLESS FOR ANY INDIRECT, PUNITIVE, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGE, HOWEVER IT ARISES (INCLUDING ATTORNEYS’ FEES AND ALL RELATED COSTS AND EXPENSES OF LITIGATION AND ARBITRATION, OR AT TRIAL OR ON APPEAL, IF ANY, WHETHER OR NOT LITIGATION OR ARBITRATION IS INSTITUTED), WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE, OR OTHER TORTIOUS ACTION, OR ARISING OUT OF OR IN CONNECTION WITH THIS AGREEMENT, INCLUDING WITHOUT LIMITATION ANY CLAIM FOR PERSONAL INJURY OR PROPERTY DAMAGE, ARISING FROM THIS AGREEMENT AND ANY VIOLATION BY YOU OF ANY FEDERAL, STATE, OR LOCAL LAWS, STATUTES, RULES, OR REGULATIONS, EVEN IF COMPANY HAS BEEN PREVIOUSLY ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. EXCEPT AS PROHIBITED BY LAW, IF THERE IS LIABILITY FOUND ON THE PART OF COMPANY, IT WILL BE LIMITED TO THE AMOUNT PAID FOR THE PRODUCTS AND/OR SERVICES, AND UNDER NO CIRCUMSTANCES WILL THERE BE CONSEQUENTIAL OR PUNITIVE DAMAGES. SOME STATES DO NOT ALLOW THE EXCLUSION OR LIMITATION OF PUNITIVE, INCIDENTAL OR CONSEQUENTIAL DAMAGES, SO THE PRIOR LIMITATION OR EXCLUSION MAY NOT APPLY TO YOU.\n\n`
  String get exceptAsProhibitedByLawYouWillHoldUsAnd {
    return Intl.message(
      'EXCEPT AS PROHIBITED BY LAW, YOU WILL HOLD US AND OUR OFFICERS, DIRECTORS, EMPLOYEES, AND AGENTS HARMLESS FOR ANY INDIRECT, PUNITIVE, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGE, HOWEVER IT ARISES (INCLUDING ATTORNEYS’ FEES AND ALL RELATED COSTS AND EXPENSES OF LITIGATION AND ARBITRATION, OR AT TRIAL OR ON APPEAL, IF ANY, WHETHER OR NOT LITIGATION OR ARBITRATION IS INSTITUTED), WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE, OR OTHER TORTIOUS ACTION, OR ARISING OUT OF OR IN CONNECTION WITH THIS AGREEMENT, INCLUDING WITHOUT LIMITATION ANY CLAIM FOR PERSONAL INJURY OR PROPERTY DAMAGE, ARISING FROM THIS AGREEMENT AND ANY VIOLATION BY YOU OF ANY FEDERAL, STATE, OR LOCAL LAWS, STATUTES, RULES, OR REGULATIONS, EVEN IF COMPANY HAS BEEN PREVIOUSLY ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. EXCEPT AS PROHIBITED BY LAW, IF THERE IS LIABILITY FOUND ON THE PART OF COMPANY, IT WILL BE LIMITED TO THE AMOUNT PAID FOR THE PRODUCTS AND/OR SERVICES, AND UNDER NO CIRCUMSTANCES WILL THERE BE CONSEQUENTIAL OR PUNITIVE DAMAGES. SOME STATES DO NOT ALLOW THE EXCLUSION OR LIMITATION OF PUNITIVE, INCIDENTAL OR CONSEQUENTIAL DAMAGES, SO THE PRIOR LIMITATION OR EXCLUSION MAY NOT APPLY TO YOU.\n\n',
      name: 'exceptAsProhibitedByLawYouWillHoldUsAnd',
      desc: '',
      args: [],
    );
  }

  /// `21. Termination\n\n`
  String get Terminationnn {
    return Intl.message(
      '21. Termination\n\n',
      name: 'Terminationnn',
      desc: '',
      args: [],
    );
  }

  /// `We may terminate or suspend your account and bar access to Service immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever and without limitation, including but not limited to a breach of Terms.\n\n`
  String get weMayTerminateOrSuspendYourAccountAndBarAccess {
    return Intl.message(
      'We may terminate or suspend your account and bar access to Service immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever and without limitation, including but not limited to a breach of Terms.\n\n',
      name: 'weMayTerminateOrSuspendYourAccountAndBarAccess',
      desc: '',
      args: [],
    );
  }

  /// `If you wish to terminate your account, you may simply discontinue using Service.\n\n`
  String get ifYouWishToTerminateYourAccountYouMaySimply {
    return Intl.message(
      'If you wish to terminate your account, you may simply discontinue using Service.\n\n',
      name: 'ifYouWishToTerminateYourAccountYouMaySimply',
      desc: '',
      args: [],
    );
  }

  /// `All provisions of Terms which by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability.\n\n`
  String get allProvisionsOfTermsWhichByTheirNatureShouldSurvive {
    return Intl.message(
      'All provisions of Terms which by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability.\n\n',
      name: 'allProvisionsOfTermsWhichByTheirNatureShouldSurvive',
      desc: '',
      args: [],
    );
  }

  /// `22. Governing Law\n\n`
  String get GoverningLawnn {
    return Intl.message(
      '22. Governing Law\n\n',
      name: 'GoverningLawnn',
      desc: '',
      args: [],
    );
  }

  /// `These Terms shall be governed and construed in accordance with the laws of Denmark, which governing law applies to agreement without regard to its conflict of law provisions.\n\n`
  String get theseTermsShallBeGovernedAndConstruedInAccordanceWith {
    return Intl.message(
      'These Terms shall be governed and construed in accordance with the laws of Denmark, which governing law applies to agreement without regard to its conflict of law provisions.\n\n',
      name: 'theseTermsShallBeGovernedAndConstruedInAccordanceWith',
      desc: '',
      args: [],
    );
  }

  /// `Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms will remain in effect. These Terms constitute the entire agreement between us regarding our Service and supersede and replace any prior agreements we might have had between us regarding Service.\n\n`
  String get ourFailureToEnforceAnyRightOrProvisionOfThese {
    return Intl.message(
      'Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms will remain in effect. These Terms constitute the entire agreement between us regarding our Service and supersede and replace any prior agreements we might have had between us regarding Service.\n\n',
      name: 'ourFailureToEnforceAnyRightOrProvisionOfThese',
      desc: '',
      args: [],
    );
  }

  /// `23. Changes To Service\n\n`
  String get ChangesToServicenn {
    return Intl.message(
      '23. Changes To Service\n\n',
      name: 'ChangesToServicenn',
      desc: '',
      args: [],
    );
  }

  /// `We reserve the right to withdraw or amend our Service, and any service or material we provide via Service, in our sole discretion without notice. We will not be liable if for any reason all or any part of Service is unavailable at any time or for any period. From time to time, we may restrict access to some parts of Service, or the entire Service, to users, including registered users.\n\n`
  String get weReserveTheRightToWithdrawOrAmendOurService {
    return Intl.message(
      'We reserve the right to withdraw or amend our Service, and any service or material we provide via Service, in our sole discretion without notice. We will not be liable if for any reason all or any part of Service is unavailable at any time or for any period. From time to time, we may restrict access to some parts of Service, or the entire Service, to users, including registered users.\n\n',
      name: 'weReserveTheRightToWithdrawOrAmendOurService',
      desc: '',
      args: [],
    );
  }

  /// `24. Amendments To Terms\n\n`
  String get AmendmentsToTermsnn {
    return Intl.message(
      '24. Amendments To Terms\n\n',
      name: 'AmendmentsToTermsnn',
      desc: '',
      args: [],
    );
  }

  /// `We may amend Terms at any time by posting the amended terms on this site. It is your responsibility to review these Terms periodically.\n\n`
  String get weMayAmendTermsAtAnyTimeByPostingThe {
    return Intl.message(
      'We may amend Terms at any time by posting the amended terms on this site. It is your responsibility to review these Terms periodically.\n\n',
      name: 'weMayAmendTermsAtAnyTimeByPostingThe',
      desc: '',
      args: [],
    );
  }

  /// `Your continued use of the Platform following the posting of revised Terms means that you accept and agree to the changes. You are expected to check this page frequently so you are aware of any changes, as they are binding on you.\n\n`
  String get yourContinuedUseOfThePlatformFollowingThePostingOf {
    return Intl.message(
      'Your continued use of the Platform following the posting of revised Terms means that you accept and agree to the changes. You are expected to check this page frequently so you are aware of any changes, as they are binding on you.\n\n',
      name: 'yourContinuedUseOfThePlatformFollowingThePostingOf',
      desc: '',
      args: [],
    );
  }

  /// `By continuing to access or use our Service after any revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, you are no longer authorized to use Service.\n\n`
  String get byContinuingToAccessOrUseOurServiceAfterAny {
    return Intl.message(
      'By continuing to access or use our Service after any revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, you are no longer authorized to use Service.\n\n',
      name: 'byContinuingToAccessOrUseOurServiceAfterAny',
      desc: '',
      args: [],
    );
  }

  /// `25. Waiver And Severability\n\n`
  String get WaiverAndSeverabilitynn {
    return Intl.message(
      '25. Waiver And Severability\n\n',
      name: 'WaiverAndSeverabilitynn',
      desc: '',
      args: [],
    );
  }

  /// `No waiver by Company of any term or condition set forth in Terms shall be deemed a further or continuing waiver of such term or condition or a waiver of any other term or condition, and any failure of Company to assert a right or provision under Terms shall not constitute a waiver of such right or provision.\n\n`
  String get noWaiverByCompanyOfAnyTermOrConditionSet {
    return Intl.message(
      'No waiver by Company of any term or condition set forth in Terms shall be deemed a further or continuing waiver of such term or condition or a waiver of any other term or condition, and any failure of Company to assert a right or provision under Terms shall not constitute a waiver of such right or provision.\n\n',
      name: 'noWaiverByCompanyOfAnyTermOrConditionSet',
      desc: '',
      args: [],
    );
  }

  /// `If any provision of Terms is held by a court or other tribunal of competent jurisdiction to be invalid, illegal or unenforceable for any reason, such provision shall be eliminated or limited to the minimum extent such that the remaining provisions of Terms will continue in full force and effect.\n\n`
  String get ifAnyProvisionOfTermsIsHeldByACourt {
    return Intl.message(
      'If any provision of Terms is held by a court or other tribunal of competent jurisdiction to be invalid, illegal or unenforceable for any reason, such provision shall be eliminated or limited to the minimum extent such that the remaining provisions of Terms will continue in full force and effect.\n\n',
      name: 'ifAnyProvisionOfTermsIsHeldByACourt',
      desc: '',
      args: [],
    );
  }

  /// `26. Acknowledgement\n\n`
  String get Acknowledgementnn {
    return Intl.message(
      '26. Acknowledgement\n\n',
      name: 'Acknowledgementnn',
      desc: '',
      args: [],
    );
  }

  /// `BY USING SERVICE OR OTHER SERVICES PROVIDED BY US, YOU ACKNOWLEDGE THAT YOU HAVE READ THESE TERMS OF SERVICE AND AGREE TO BE BOUND BY THEM.\n\n`
  String get byUsingServiceOrOtherServicesProvidedByUsYou {
    return Intl.message(
      'BY USING SERVICE OR OTHER SERVICES PROVIDED BY US, YOU ACKNOWLEDGE THAT YOU HAVE READ THESE TERMS OF SERVICE AND AGREE TO BE BOUND BY THEM.\n\n',
      name: 'byUsingServiceOrOtherServicesProvidedByUsYou',
      desc: '',
      args: [],
    );
  }

  /// `27. Contact Us\n\n`
  String get ContactUsnn {
    return Intl.message(
      '27. Contact Us\n\n',
      name: 'ContactUsnn',
      desc: '',
      args: [],
    );
  }

  /// `Please send your feedback, comments, requests for technical support by email: support@danaid.org.\n\n`
  String get pleaseSendYourFeedbackCommentsRequestsForTechnicalSupportBy {
    return Intl.message(
      'Please send your feedback, comments, requests for technical support by email: support@danaid.org.\n\n',
      name: 'pleaseSendYourFeedbackCommentsRequestsForTechnicalSupportBy',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message(
      'Chats',
      name: 'chats',
      desc: '',
      args: [],
    );
  }

  /// `Create a quote`
  String get crerUnDevis {
    return Intl.message(
      'Create a quote',
      name: 'crerUnDevis',
      desc: '',
      args: [],
    );
  }

  /// `Scan the patient's card`
  String get scannerLaCarteDuPatient {
    return Intl.message(
      'Scan the patient\'s card',
      name: 'scannerLaCarteDuPatient',
      desc: '',
      args: [],
    );
  }

  /// `Or enter the payment code`
  String get ouInscrireLeCodeDePaiement {
    return Intl.message(
      'Or enter the payment code',
      name: 'ouInscrireLeCodeDePaiement',
      desc: '',
      args: [],
    );
  }

  /// `an error has occurred `
  String get uneErreurSestProduite {
    return Intl.message(
      'an error has occurred ',
      name: 'uneErreurSestProduite',
      desc: '',
      args: [],
    );
  }

  /// `invalid Qr code`
  String get qrCodeInvaldie {
    return Intl.message(
      'invalid Qr code',
      name: 'qrCodeInvaldie',
      desc: '',
      args: [],
    );
  }

  /// `this user does not exist`
  String get cetUtilisateurNexistePas {
    return Intl.message(
      'this user does not exist',
      name: 'cetUtilisateurNexistePas',
      desc: '',
      args: [],
    );
  }

  /// `an error has occurred`
  String get uneErreurEstSurvenue {
    return Intl.message(
      'an error has occurred',
      name: 'uneErreurEstSurvenue',
      desc: '',
      args: [],
    );
  }

  /// `Benefits in progress`
  String get prestationsEnCours {
    return Intl.message(
      'Benefits in progress',
      name: 'prestationsEnCours',
      desc: '',
      args: [],
    );
  }

  /// `no quote matched this patient`
  String get aucunDevisNeCorrespondACePatient {
    return Intl.message(
      'no quote matched this patient',
      name: 'aucunDevisNeCorrespondACePatient',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get ordonance {
    return Intl.message(
      'Order',
      name: 'ordonance',
      desc: '',
      args: [],
    );
  }

  /// `Copayment`
  String get copaiement {
    return Intl.message(
      'Copayment',
      name: 'copaiement',
      desc: '',
      args: [],
    );
  }

  /// `state unknouw`
  String get tatInconue {
    return Intl.message(
      'state unknouw',
      name: 'tatInconue',
      desc: '',
      args: [],
    );
  }

  /// `are you sure ?`
  String get tesvousSur {
    return Intl.message(
      'are you sure ?',
      name: 'tesvousSur',
      desc: '',
      args: [],
    );
  }

  /// `medicaments delete`
  String get medicamentsSupprimer {
    return Intl.message(
      'medicaments delete',
      name: 'medicamentsSupprimer',
      desc: '',
      args: [],
    );
  }

  /// `covered by Danaid`
  String get couvertParDanaid {
    return Intl.message(
      'covered by Danaid',
      name: 'couvertParDanaid',
      desc: '',
      args: [],
    );
  }

  /// `Niveau I Decouverte`
  String get niveauIDecouverte {
    return Intl.message(
      'Niveau I Decouverte',
      name: 'niveauIDecouverte',
      desc: '',
      args: [],
    );
  }

  /// `Validate The Benefit`
  String get validerLaPrestation {
    return Intl.message(
      'Validate The Benefit',
      name: 'validerLaPrestation',
      desc: '',
      args: [],
    );
  }

  /// `Not Editable..`
  String get nonEditable {
    return Intl.message(
      'Not Editable..',
      name: 'nonEditable',
      desc: '',
      args: [],
    );
  }

  /// `Amount paid`
  String get montantPercu {
    return Intl.message(
      'Amount paid',
      name: 'montantPercu',
      desc: '',
      args: [],
    );
  }

  /// `Issue a review`
  String get emettreUnDvis {
    return Intl.message(
      'Issue a review',
      name: 'emettreUnDvis',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get montantTotal {
    return Intl.message(
      'Total Amount',
      name: 'montantTotal',
      desc: '',
      args: [],
    );
  }

  /// `import your quotes`
  String get importerVosDevis {
    return Intl.message(
      'import your quotes',
      name: 'importerVosDevis',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get effacer {
    return Intl.message(
      'delete',
      name: 'effacer',
      desc: '',
      args: [],
    );
  }

  /// `upload of`
  String get uploadDe {
    return Intl.message(
      'upload of',
      name: 'uploadDe',
      desc: '',
      args: [],
    );
  }

  /// `send ...`
  String get envoie {
    return Intl.message(
      'send ...',
      name: 'envoie',
      desc: '',
      args: [],
    );
  }

  /// `image(s)`
  String get images {
    return Intl.message(
      'image(s)',
      name: 'images',
      desc: '',
      args: [],
    );
  }

  /// `image(s) select`
  String get imagesSlectionner {
    return Intl.message(
      'image(s) select',
      name: 'imagesSlectionner',
      desc: '',
      args: [],
    );
  }

  /// `enter the consultation code`
  String get entrezLeCodeDeConsultation {
    return Intl.message(
      'enter the consultation code',
      name: 'entrezLeCodeDeConsultation',
      desc: '',
      args: [],
    );
  }

  /// `enter the amount of the quote`
  String get entrezLeMontantDuDevis {
    return Intl.message(
      'enter the amount of the quote',
      name: 'entrezLeMontantDuDevis',
      desc: '',
      args: [],
    );
  }

  /// `import the image(s) of the quote`
  String get importerLesImagesDuDevis {
    return Intl.message(
      'import the image(s) of the quote',
      name: 'importerLesImagesDuDevis',
      desc: '',
      args: [],
    );
  }

  /// `an error occurred during the sending`
  String get uneErreurSestProduiteLorsDeLenvoie {
    return Intl.message(
      'an error occurred during the sending',
      name: 'uneErreurSestProduiteLorsDeLenvoie',
      desc: '',
      args: [],
    );
  }

  /// `invalid consultation code`
  String get codeDeConsultationInvalide {
    return Intl.message(
      'invalid consultation code',
      name: 'codeDeConsultationInvalide',
      desc: '',
      args: [],
    );
  }

  /// `you cannot import more than 10 images`
  String get vousNePouvezPasImporterPlusDe5Images {
    return Intl.message(
      'you cannot import more than 10 images',
      name: 'vousNePouvezPasImporterPlusDe5Images',
      desc: '',
      args: [],
    );
  }

  /// `Last services`
  String get derniresPrestations {
    return Intl.message(
      'Last services',
      name: 'derniresPrestations',
      desc: '',
      args: [],
    );
  }

  /// `Last Appointments`
  String get derniresRendezvous {
    return Intl.message(
      'Last Appointments',
      name: 'derniresRendezvous',
      desc: '',
      args: [],
    );
  }

  /// `Type of quote`
  String get typeDeDevis {
    return Intl.message(
      'Type of quote',
      name: 'typeDeDevis',
      desc: '',
      args: [],
    );
  }

  /// `New service added`
  String get nouvellePrestationAjoute {
    return Intl.message(
      'New service added',
      name: 'nouvellePrestationAjoute',
      desc: '',
      args: [],
    );
  }

  /// `choose the type of quote`
  String get choisissezLeTypeDeDevis {
    return Intl.message(
      'choose the type of quote',
      name: 'choisissezLeTypeDeDevis',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get alerte {
    return Intl.message(
      'Alert',
      name: 'alerte',
      desc: '',
      args: [],
    );
  }

  /// `Tracking of benefits`
  String get suivieDesPrestations {
    return Intl.message(
      'Tracking of benefits',
      name: 'suivieDesPrestations',
      desc: '',
      args: [],
    );
  }

  /// `Service Closing`
  String get prestationClturer {
    return Intl.message(
      'Service Closing',
      name: 'prestationClturer',
      desc: '',
      args: [],
    );
  }

  /// `in process... `
  String get enCoursDeTraitement {
    return Intl.message(
      'in process... ',
      name: 'enCoursDeTraitement',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get confirmation {
    return Intl.message(
      'Confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `are you sure you want to do this action`
  String get tesvousSurDffectuerCetteAction {
    return Intl.message(
      'are you sure you want to do this action',
      name: 'tesvousSurDffectuerCetteAction',
      desc: '',
      args: [],
    );
  }

  /// `SUPPRIMER`
  String get delete {
    return Intl.message(
      'SUPPRIMER',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Updated drugs`
  String get medicamentsMiseJour {
    return Intl.message(
      'Updated drugs',
      name: 'medicamentsMiseJour',
      desc: '',
      args: [],
    );
  }

  /// `An error has occurred`
  String get uneErreurEstSurvenu {
    return Intl.message(
      'An error has occurred',
      name: 'uneErreurEstSurvenu',
      desc: '',
      args: [],
    );
  }

  /// `please select a drug first`
  String get veuillezSelectionnerUnMdicamentAuPralable {
    return Intl.message(
      'please select a drug first',
      name: 'veuillezSelectionnerUnMdicamentAuPralable',
      desc: '',
      args: [],
    );
  }

  /// `Saving is only possible after deleting at least one element from the list`
  String get laSauvegardeNestPossibleQuapresAvoirSupprimerAuMoinsElement {
    return Intl.message(
      'Saving is only possible after deleting at least one element from the list',
      name: 'laSauvegardeNestPossibleQuapresAvoirSupprimerAuMoinsElement',
      desc: '',
      args: [],
    );
  }

  /// `this button will be active only after validation of the images by the administrator `
  String get ceButtonNeSeraActifQuaprsValidationDesImagesPar {
    return Intl.message(
      'this button will be active only after validation of the images by the administrator ',
      name: 'ceButtonNeSeraActifQuaprsValidationDesImagesPar',
      desc: '',
      args: [],
    );
  }

  /// `Saving is only possible after deleting at least one drug in the list`
  String get laSauvegardeNestPossibleQuapresAvoirSupprimerAuMoinUn {
    return Intl.message(
      'Saving is only possible after deleting at least one drug in the list',
      name: 'laSauvegardeNestPossibleQuapresAvoirSupprimerAuMoinUn',
      desc: '',
      args: [],
    );
  }

  /// `confirm list`
  String get confirmerLaListe {
    return Intl.message(
      'confirm list',
      name: 'confirmerLaListe',
      desc: '',
      args: [],
    );
  }

  /// `create`
  String get crer {
    return Intl.message(
      'create',
      name: 'crer',
      desc: '',
      args: [],
    );
  }

  /// `save`
  String get enregistrer {
    return Intl.message(
      'save',
      name: 'enregistrer',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `le patient a bien été ajouter `
  String get lePatientABienTAjouter {
    return Intl.message(
      'le patient a bien été ajouter ',
      name: 'lePatientABienTAjouter',
      desc: '',
      args: [],
    );
  }

  /// `une consultation en cours à été détecter pour ce patient donc il ne vous est pas possible de créer une nouvelle consultation dans un intervalle de deux semaines depuis sa dernière consultation. Pour plus d'informations contactez le service client. `
  String get uneConsultationEnCoursTDtecterPourCePatientDonc {
    return Intl.message(
      'une consultation en cours à été détecter pour ce patient donc il ne vous est pas possible de créer une nouvelle consultation dans un intervalle de deux semaines depuis sa dernière consultation. Pour plus d\'informations contactez le service client. ',
      name: 'uneConsultationEnCoursTDtecterPourCePatientDonc',
      desc: '',
      args: [],
    );
  }

  /// `le patient a bien été ajouter au systeme.`
  String get lePatientABienTAjouterAuSysteme {
    return Intl.message(
      'le patient a bien été ajouter au systeme.',
      name: 'lePatientABienTAjouterAuSysteme',
      desc: '',
      args: [],
    );
  }

  /// `une erreur est survenu veuillez contacter le service `
  String get uneErreurEstSurvenuVeuillezContacterLeService {
    return Intl.message(
      'une erreur est survenu veuillez contacter le service ',
      name: 'uneErreurEstSurvenuVeuillezContacterLeService',
      desc: '',
      args: [],
    );
  }

  /// `Ajouter ce patient`
  String get ajouterCePatient {
    return Intl.message(
      'Ajouter ce patient',
      name: 'ajouterCePatient',
      desc: '',
      args: [],
    );
  }

  /// `Nom du patient`
  String get nomDuPatient {
    return Intl.message(
      'Nom du patient',
      name: 'nomDuPatient',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr', countryCode: 'FR'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale)!;
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
