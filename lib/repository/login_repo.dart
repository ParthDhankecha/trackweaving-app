import 'package:trackweaving/models/login_auth_model.dart';
import 'package:trackweaving/repository/api_client.dart';
import 'package:trackweaving/utils/app_const.dart';
import 'package:trackweaving/utils/shared_pref.dart';
import 'package:get/get.dart';

class LoginRepo extends GetxService {
  final ApiClient apiClient;

  LoginRepo({required this.apiClient});

  final sp = Get.find<Sharedprefs>();

  //api to login with email and password
  Future<AuthData> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final reqBody = {'userName': email, 'password': password};
    String endPoint = AppConst.getUrl(AppConst.loginWithEmail);

    var data = await apiClient.request(
      endPoint,
      method: ApiType.post,
      headers: {},
      body: reqBody,
    );

    AuthData authData = loginAuthFromMap(data).data;
    return authData;
  }

  saveFcmToken(String token) async {
    sp.fcmToken = token;
    print("FCM Token saved: $token");
    var endPoint = AppConst.getUrl(AppConst.saveFcmToken);
    Map<String, String> body = {'fcmToken': token};
    var response = await apiClient.request(
      endPoint,
      method: ApiType.put,
      headers: {'Authorization': sp.userToken},
      body: body,
    );

    print("FCM Token response: $response");
  }

  deleFcmToken() async {
    sp.fcmToken = '';
    print("FCM Token deleted");
    var endPoint = AppConst.getUrl(AppConst.saveFcmToken);

    var response = await apiClient.request(
      endPoint,
      method: ApiType.delete,
      headers: {'Authorization': sp.userToken},
    );

    print("FCM Token delete response: $response");
  }
}
