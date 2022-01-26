import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';

class FunctionWidgets {
  static chooseImageProvider({BuildContext? context, Function? gallery, Function? camera}){
    showModalBottomSheet(
      context: context!, 
      builder: (BuildContext bc){
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Gallerie'),
                    onTap: () {
                      gallery!();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    camera!();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  static termsAndConditionsDialog({BuildContext? context}){
    String termsAndConditions = "Le médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\n\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la s";
    TextStyle bold = TextStyle(fontWeight: FontWeight.bold);
    RichText content = RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.grey[600]),
        children: [
          TextSpan(text: S.of(context!).lastUpdated20210515nn),
          TextSpan(text: S.of(context).Introductionnn, style: bold),
          TextSpan(text: S.of(context).welcomeTo),
          TextSpan(text: S.of(context).danaid, style: bold),
          TextSpan(text: S.of(context).companyWeOurUsnn),
          TextSpan(text: S.of(context).theseTermsOfServiceTermsTermsOfServiceGovernYour),
          TextSpan(text: S.of(context).danaidnn, style: bold),
          TextSpan(text: S.of(context).ourPrivacyPolicyAlsoGovernsYourUseOfOurService),
          TextSpan(text: S.of(context).yourAgreementWithUsIncludesTheseTermsAndOurPrivacy),
          TextSpan(text: S.of(context).ifYouDoNotAgreeWithOrCannotComplyWith),
          TextSpan(text: S.of(context).danaid, style: bold),
          TextSpan(text: S.of(context).soWeCanTryToFindASolutionTheseTerms),
          TextSpan(text: S.of(context).Communicationsnn, style: bold),
          TextSpan(text: S.of(context).byUsingOurServiceYouAgreeToSubscribeToNewsletters),
          TextSpan(text: S.of(context).Purchasesnn, style: bold),
          TextSpan(text: S.of(context).ifYouWishToPurchaseAnyProductOrServiceMade),
          TextSpan(text: S.of(context).youRepresentAndWarrantThatIYouHaveTheLegal),
          TextSpan(text: S.of(context).weMayEmployTheUseOfThirdPartyServicesFor),
          TextSpan(text: S.of(context).weReserveTheRightToRefuseOrCancelYourOrder),
          TextSpan(text: S.of(context).weReserveTheRightToRefuseOrCancelYourOrder),
          TextSpan(text: S.of(context).ContestsSweepstakesAndPromotionsnn, style: bold),
          TextSpan(text: S.of(context).anyContestsSweepstakesOrOtherPromotionsCollectivelyPromotionsMadeAvailable),
          TextSpan(text: S.of(context).Subscriptionsnn, style: bold),
          TextSpan(text: S.of(context).somePartsOfServiceAreBilledOnASubscriptionBasis),
          TextSpan(text: S.of(context).atTheEndOfEachBillingCycleYourSubscriptionWill),
          TextSpan(text: S.of(context).aValidPaymentMethodIsRequiredToProcessThePayment),
          TextSpan(text: S.of(context).shouldAutomaticBillingFailToOccurForAnyReasonDanaid),
          TextSpan(text: S.of(context).FreeTrialnn, style: bold),
          TextSpan(text: S.of(context).danaidMayAtItsSoleDiscretionOfferASubscriptionWith),
          TextSpan(text: S.of(context).youMayBeRequiredToEnterYourBillingInformationIn),
          TextSpan(text: S.of(context).ifYouDoEnterYourBillingInformationWhenSigningUp),
          TextSpan(text: S.of(context).atAnyTimeAndWithoutNoticeDanaidReservesTheRight),
          TextSpan(text: S.of(context).FreeChangesNn, style: bold),
          TextSpan(text: S.of(context).danaidInItsSoleDiscretionAndAtAnyTimeMay),
          TextSpan(text: S.of(context).danaidWillProvideYouWithAReasonablePriorNoticeOf),
          TextSpan(text: S.of(context).yourContinuedUseOfServiceAfterSubscriptionFeeChangeComes),
          TextSpan(text: S.of(context).RefundsNn, style: bold),
          TextSpan(text: S.of(context).weIssueRefundsForContractsWithin),
          TextSpan(text: S.of(context).Days30, style: bold),
          TextSpan(text: S.of(context).ofTheOriginalPurchaseOfTheContractnn),
          TextSpan(text: S.of(context).Contentnn, style: bold),
          TextSpan(text: S.of(context).ourServiceAllowsYouToPostLinkStoreShareAnd),
          TextSpan(text: S.of(context).byPostingContentOnOrThroughServiceYouRepresentAnd),
          TextSpan(text: S.of(context).youRetainAnyAndAllOfYourRightsToAny),
          TextSpan(text: S.of(context).danaidHasTheRightButNotTheObligationToMonitor),
          TextSpan(text: S.of(context).inAdditionContentFoundOnOrThroughThisServiceAre),
          TextSpan(text: S.of(context).ProhibitedUsesnn, style: bold),
          TextSpan(text: S.of(context).youMayUseServiceOnlyForLawfulPurposesAndIn),
          TextSpan(text: S.of(context).InAnyWayThatViolatesAnyApplicableNationalOr),
          TextSpan(text: S.of(context).ForThePurposeOfExploitingHarmingOrAttemptingTo),
          TextSpan(text: S.of(context).ToTransmitOrProcureTheSendingOfAnyAdvertising),
          TextSpan(text: S.of(context).ToImpersonateOrAttemptToImpersonateCompanyACompany),
          TextSpan(text: S.of(context).InAnyWayThatInfringesUponTheRightsOf),
          TextSpan(text: S.of(context).ToEngageInAnyOtherConductThatRestrictsOr),
          TextSpan(text: S.of(context).additionallyYouAgreeNotTonn),
          TextSpan(text: S.of(context).UseServiceInAnyMannerThatCouldDisableOverburden),
          TextSpan(text: S.of(context).UseAnyRobotSpiderOrOtherAutomaticDeviceProcess),
          TextSpan(text: S.of(context).UseAnyManualProcessToMonitorOrCopyAny),
          TextSpan(text: S.of(context).UseAnyDeviceSoftwareOrRoutineThatInterferesWith),
          TextSpan(text: S.of(context).IntroduceAnyVirusesTrojanHorsesWormsLogicBombsOr),
          TextSpan(text: S.of(context).AttemptToGainUnauthorizedAccessToInterfereWithDamage),
          TextSpan(text: S.of(context).AttackServiceViaADenialofserviceAttackOrADistributed),
          TextSpan(text: S.of(context).TakeAnyActionThatMayDamageOrFalsifyCompany),
          TextSpan(text: S.of(context).OtherwiseAttemptToInterfereWithTheProperWorkingOf),
          TextSpan(text: S.of(context).Analyticsnn, style: bold),
          TextSpan(text: S.of(context).weMayUseThirdpartyServiceProvidersToMonitorAndAnalyze),
          TextSpan(text: S.of(context).NoUseByMinorsnn, style: bold),
          TextSpan(text: S.of(context).serviceIsIntendedOnlyForAccessAndUseByIndividuals),
          TextSpan(text: S.of(context).Accountsnn, style: bold),
          TextSpan(text: S.of(context).whenYouCreateAnAccountWithUsYouGuaranteeThat),
          TextSpan(text: S.of(context).youAreResponsibleForMaintainingTheConfidentialityOfYourAccount),
          TextSpan(text: S.of(context).youMayNotUseAsAUsernameTheNameOf),
          TextSpan(text: S.of(context).weReserveTheRightToRefuseServiceTerminateAccountsRemove),
          TextSpan(text: S.of(context).IntellectualPropertynn, style: bold),
          TextSpan(text: S.of(context).serviceAndItsOriginalContentExcludingContentProvidedByUsers),
          TextSpan(text: S.of(context).CopyrightPolicynn, style: bold),
          TextSpan(text: S.of(context).weRespectTheIntellectualPropertyRightsOfOthersItIs),
          TextSpan(text: S.of(context).ifYouAreACopyrightOwnerOrAuthorizedOnBehalf),
          TextSpan(text: S.of(context).youMayBeHeldAccountableForDamagesIncludingCostsAnd),
          TextSpan(text: S.of(context).DmcaNoticeAndProcedureForCopyrightInfringementClaimsnn, style: bold),
          TextSpan(text: S.of(context).youMaySubmitANotificationPursuantToTheDigitalMillennium),
          TextSpan(text: S.of(context).AnElectronicOrPhysicalSignatureOfThePersonAuthorized),
          TextSpan(text: S.of(context).ADescriptionOfTheCopyrightedWorkThatYouClaim),
          TextSpan(text: S.of(context).IdentificationOfTheUrlOrOtherSpecificLocationOn),
          TextSpan(text: S.of(context).YourAddressTelephoneNumberAndEmailAddressnn),
          TextSpan(text: S.of(context).AStatementByYouThatYouHaveAGood),
          TextSpan(text: S.of(context).AStatementByYouMadeUnderPenaltyOfPerjury),
          TextSpan(text: S.of(context).youCanContactOurCopyrightAgentViaEmailAtSupportdanaidorgnn),
          TextSpan(text: S.of(context).ErrorReportingAndFeedbacknn, style: bold),
          TextSpan(text: S.of(context).youMayProvideUsEitherDirectlyAtSupportdanaidorgOrVia),
          TextSpan(text: S.of(context).LinksToOtherWebSitesnn, style: bold),
          TextSpan(text: S.of(context).ourServiceMayContainLinksToThirdPartyWebSites),
          TextSpan(text: S.of(context).danaidHasNoControlOverAndAssumesNoResponsibilityFor),
          TextSpan(text: S.of(context).forExampleTheOutlinedTermsOfUseHaveBeenCreated),
          TextSpan(text: S.of(context).youAcknowledgeAndAgreeThatCompanyShallNotBeResponsible),
          TextSpan(text: S.of(context).weStronglyAdviseYouToReadTheTermsOfService),
          TextSpan(text: S.of(context).DisclaimerOfWarrantynn, style: bold),
          TextSpan(text: S.of(context).theseServicesAreProvidedByCompanyOnAnAsIs),
          TextSpan(text: S.of(context).neitherCompanyNorAnyPersonAssociatedWithCompanyMakesAny),
          TextSpan(text: S.of(context).companyHerebyDisclaimsAllWarrantiesOfAnyKindWhetherExpress),
          TextSpan(text: S.of(context).theForegoingDoesNotAffectAnyWarrantiesWhichCannotBe),
          TextSpan(text: S.of(context).LimitationOfLiabilitynn, style: bold),
          TextSpan(text: S.of(context).exceptAsProhibitedByLawYouWillHoldUsAnd),
          TextSpan(text: S.of(context).Terminationnn, style: bold),
          TextSpan(text: S.of(context).weMayTerminateOrSuspendYourAccountAndBarAccess),
          TextSpan(text: S.of(context).ifYouWishToTerminateYourAccountYouMaySimply),
          TextSpan(text: S.of(context).allProvisionsOfTermsWhichByTheirNatureShouldSurvive),
          TextSpan(text: S.of(context).GoverningLawnn, style: bold),
          TextSpan(text: S.of(context).theseTermsShallBeGovernedAndConstruedInAccordanceWith),
          TextSpan(text: S.of(context).ourFailureToEnforceAnyRightOrProvisionOfThese),
          TextSpan(text: S.of(context).ChangesToServicenn, style: bold),
          TextSpan(text: S.of(context).weReserveTheRightToWithdrawOrAmendOurService),
          TextSpan(text: S.of(context).AmendmentsToTermsnn, style: bold),
          TextSpan(text: S.of(context).weMayAmendTermsAtAnyTimeByPostingThe),
          TextSpan(text: S.of(context).yourContinuedUseOfThePlatformFollowingThePostingOf),
          TextSpan(text: S.of(context).byContinuingToAccessOrUseOurServiceAfterAny),
          TextSpan(text: S.of(context).WaiverAndSeverabilitynn, style: bold),
          TextSpan(text: S.of(context).noWaiverByCompanyOfAnyTermOrConditionSet),
          TextSpan(text: S.of(context).ifAnyProvisionOfTermsIsHeldByACourt),
          TextSpan(text: S.of(context).Acknowledgementnn, style: bold),
          TextSpan(text: S.of(context).byUsingServiceOrOtherServicesProvidedByUsYou),
          TextSpan(text: S.of(context).ContactUsnn, style: bold),
          TextSpan(text: S.of(context).pleaseSendYourFeedbackCommentsRequestsForTechnicalSupportBy),
        ]
      ),
    );
    showDialog(context: context, 
      builder: (BuildContext context){
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*1),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: hv*2,),
                      Text("TERMS AND CONDITIONS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kPrimaryColor),),
                      SizedBox(height: hv*2,),
                      Expanded(child: SingleChildScrollView(child: content, physics: BouncingScrollPhysics(),)),
                    ],
                  ),
                ),
                CustomTextButton(
                  text: "Fermer",
                  color: kPrimaryColor,
                  action: () => Navigator.pop(context),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}