import 'package:belay/main.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class Analytics {
  static Mixpanel? mixpanel;
  static Future initMixpanel() async {
    mixpanel = await Mixpanel.init('0032ebf6e4b631ac8d1ff03094aa89b2', optOutTrackingDefault: false);
  }

  // Landing page
  static void trackAppOpen() {
    try {
      trackAppOpenPixel();
    } catch (ex) {}
    mixpanel!.track('App Open');
  }

  static void trackUberSignUpClicked() {
    try {
      trackSignup();
    } catch (ex) {}
    mixpanel!.track('Uber sign up button press');
  }

  static void trackLyftSignUpClicked() {
    mixpanel!.track('Lyft sign up button press');
  }

  static void trackLyftWaitlist() {
    mixpanel!.track('Lyft join waitlist');
  }

  static void trackUberSignInClicked() {
    mixpanel!.track('Log in button press');
  }

  // How it works flow
  static void trackHIWConnectApps() {
    mixpanel!.track('View how it works - connect apps');
  }

  static void trackHIWScheduling() {
    mixpanel!.track('View how it works - scheduling');
  }

  static void trackHIWDayToDay() {
    mixpanel!.track('View how it works - day to day');
  }

  static void trackHIWPaymentSchedule() {
    mixpanel!.track('View how it works - payment schedule');
  }

  static void trackHowItWorksMoreDetail() {
    mixpanel!.track('How it works open more details');
  }

  static void trackHowItWorksFinishButtonClick() {
    mixpanel!.track('How it works finish button press');
  }

  // Uber SSO flow
  static void trackUberPhoneAttempt() {
    mixpanel!.track('Uber SSO attempt');
  }

  static void trackUberForgotPassword() {
    mixpanel!.track('Uber forgot password button press');
  }

  static void trackTermsAndConditionsButtonClick() {
    mixpanel!.track('Sign up terms and conditions open');
  }

  static void trackUberSMSOpen() {
    mixpanel!.track('Uber sms screen open');
  }

  static void trackUberPasswordAttempt() {
    mixpanel!.track('Uber password attempt');
  }

  static void trackUberEmailAttempt() {
    mixpanel!.track('Uber email pin attempt');
  }

  static void trackUberSMSAttempt() {
    try {
      trackUberSignIn();
    } catch (ex) {}
    mixpanel!.track('Uber sms attempt');
  }

  // free trial flow
  static void trackGeneratingOpen() {
    mixpanel!.track('Generating screen open');
  }

  static void trackNoValueNugget() {
    mixpanel!.track('Value nugget no data screen open');
  }

  static void trackShowValueNugget() {
    try {
      trackValueNugget();
    } catch (ex) {}
    mixpanel!.track('Value nugget screen open');
  }

  static void trackValueNuggetButtonPress() {
    mixpanel!.track('Value nugget button press');
  }

  static void trackCalendarInfoScreenButtonPress() {
    mixpanel!.track('Calendar info screen button press');
  }

  static void trackGuaranteeAccepted() {
    try {
      trackAccepted();
    } catch (ex) {}
    mixpanel!.track('Free trial guarantee accepted');
  }

  static void trackSignupFinish() {
    mixpanel!.track('Finish sign up');
  }

  // schedule builder
  static void trackViewScheduleTab() {
    mixpanel!.track('View schedule tab');
  }

  static void trackCalendayDayPicked() {
    mixpanel!.track('Calendar day picked');
  }

  static void trackCalendarDaysSubmitted() {
    mixpanel!.track('Calendar days submitted');
  }

  static void trackTimeBlocksSubmitted() {
    try {
      trackSession();
    } catch (ex) {}
    mixpanel!.track('Next day time blocks');
  }

  static void trackDaysSubmitted() {
    try {
      addToCart();
    } catch (ex) {}
    mixpanel!.track('Finish adding days');
  }

  static void trackEditSchedule() {
    mixpanel!.track('Edit schedule');
  }

  static void trackDoneEditing() {
    mixpanel!.track('Done editing schedule');
  }

  static void trackDeleteDay() {
    mixpanel!.track('Delete day');
  }

  static void trackEditDay() {
    mixpanel!.track('Edit day');
  }

  static void trackAddDays() {
    mixpanel!.track('Start adding days');
  }

  static void trackViewScheduleHistory() {
    mixpanel!.track('View schedule history');
  }

  static void trackViewUpcomingSchedule() {
    mixpanel!.track('View upcoming schedule');
  }

  static void trackViewDayInfo() {
    mixpanel!.track('View day info');
  }

  // handbook
  static void trackViewHandbook() {
    mixpanel!.track('View handbook tab');
  }

  static void trackViewDaytoDay() {
    mixpanel!.track('View handbook day to day operations');
  }

  static void trackViewMissingDays() {
    mixpanel!.track('View handbook missing days');
  }

  static void trackViewPaymentStructure() {
    mixpanel!.track('View handbook payment structure');
  }

  static void trackViewLatePayment() {
    mixpanel!.track('View handbook late payment');
  }

  static void trackViewRateChange() {
    mixpanel!.track('View handbook rate change');
  }

  static void trackViewQualification() {
    mixpanel!.track('View handbook qualification');
  }

  static void trackViewForecasting() {
    mixpanel!.track('View handbook forecasting');
  }

  // Home page
  static void trackViewDashboard() {
    mixpanel!.track('View dashboard tab');
  }

  static void trackViewReward() {
    mixpanel!.track('View reward info');
  }

  static void trackViewSummary() {
    mixpanel!.track('View weekly summary');
  }

  // settings
  static void trackViewSettings() {
    mixpanel!.track('View settings tab');
  }

  static void trackEnableInstantPayments() {
    mixpanel!.track('Enable instant payments button press');
  }

  static void trackAttemptConnectPlaid() {
    mixpanel!.track('Attempt connect plaid');
  }
}
