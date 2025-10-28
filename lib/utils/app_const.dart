import 'dart:developer';

class AppConst {
  static String host = 'trackweaving.com';
  static String defHost = 'trackweaving.com';
  //base url
  static String baseUrl = 'https://$host/api/v1/';

  //apis
  static String loginWithEmail = 'device/auth/sign-in';
  static String verifyOTP = 'device/auth/verify-mobile-otp';
  static String machineLogs = 'device/machine-logs/list';

  static String configuration = 'device/user/sync/data';

  //machine group CRUD
  static String machineGrp = 'device/machine-groups';

  //machines
  static String machines = 'device/machines';

  //maintenance category
  static String maintenanceCategories = 'device/maintenance-categories';

  //maintenance alert
  static String maintenanceAlert = 'device/alerts';

  //shift wise comment
  static String shiftWiseComment = 'device/shift-wise-comments';

  //reports
  static String reports = 'device/reports';

  //machine parts
  static String parts = 'device/part-change-logs';
  static String partsList = 'device/part-change-logs/parts-list';

  //save fcm token
  static String saveFcmToken = 'device/user/fcm-token'; //

  //users
  static String users = 'device/user/list';
  static String addUser = 'device/user';

  //notifications
  static String notifications = 'device/notifications';

  static String privacyPolicyUrl = 'https://trackweaving.com/privacy-policy';

  static String termsConditionsUrl =
      'https://trackweaving.com/terms-and-condition';

  static const String androidStoreUrl =
      'https://play.google.com/store/apps/details?id=com.app.trackweaving';
  static const String iosStoreUrl =
      'https://apps.apple.com/us/app/trackweaving/id123456789';

  static String getUrl(String api, {String host = 'trackweaving.com'}) =>
      'https://$host/api/v1/$api';

  //API LOG
  static void showLog({String tag = 'TAG', required String logText}) =>
      log('[$tag]-$logText');

  //shift types
  static int dayShift = 0;
  static int nightShift = 1;
}
