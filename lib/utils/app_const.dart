import 'dart:developer';

class AppConst {
  static String host = '192.168.29.74:3000';
  static String defHost = '192.168.29.74:3000';
  //base url
  static String baseUrl = 'http://$host/api/v1/';

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

  static String getUrl(String host, String api) => 'http://$host/api/v1/$api';

  //API LOG
  static void showLog({String tag = 'TAG', required String logText}) =>
      log('[$tag]-$logText');
}
