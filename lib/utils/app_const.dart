import 'dart:developer';

class AppConst {
  static String host = 'https://trackweaving.com';
  // static String host = 'http://192.168.1.2:3000';
  //base url
  static String baseUrl = '$host/api/v1/';

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
      'https://apps.apple.com/in/app/trackweaving/id6753007448';

  static String getUrl(String api, {String? customHost}) =>
      '${customHost ?? host}/api/v1/$api';

  //API LOG
  static void showLog({String tag = 'TAG', required String logText}) =>
      log('[$tag]-$logText');

  //shift types
  static int dayShift = 0;
  static int nightShift = 1;
}

extension StringUtils on String {
  String get titleCase {
    return split(RegExp(r'[\s_-]')).map((e) => e.capitalize).join(' ');
  }

  String get capitalize {
    if (length < 2) return toUpperCase();
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
