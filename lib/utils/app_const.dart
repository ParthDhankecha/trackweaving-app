class AppConst {
  static String host = '192.168.29.74:3000';
  static String defHost = '192.168.29.74:3000';
  //base url
  static String baseUrl = 'http://$host/api/v1/';

  //apis
  static String loginWithEmail = 'device/auth/sign-in';
  static String verifyOTP = 'device/auth/verify-mobile-otp';
  static String machineLogs = 'device/machine-logs/list';

  static String getUrl(String host, String api) => 'http://$host/api/v1/$api';
}
