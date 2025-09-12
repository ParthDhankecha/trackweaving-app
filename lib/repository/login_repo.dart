import 'package:flutter_texmunimx/models/login_auth_model.dart';
import 'package:flutter_texmunimx/repository/api_client.dart';
import 'package:flutter_texmunimx/utils/app_const.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';

class LoginRepo {
  final ApiClient apiClient;

  LoginRepo({required this.apiClient});

  final sp = Get.find<Sharedprefs>();

  //api to login with email and password
  Future<AuthData> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final reqBody = {'userName': email, 'password': password};
    String endPoint = AppConst.getUrl(sp.hostUrl, AppConst.loginWithEmail);

    var data = await apiClient.request(
      endPoint,
      method: ApiType.post,
      body: reqBody,
    );

    AuthData authData = loginAuthFromMap(data).data;
    return authData;
  }
}
