import 'dart:io';

import 'package:flutter_texmunimx/models/login_auth_model.dart';
import 'package:flutter_texmunimx/utils/app_const.dart';
import 'package:http/http.dart' as http;

class LoginRepo {
  //api to send otp
  Future<int> sendOtp({required String mobile}) async {
    var reqBody = {'mobile': mobile};
    var response = await http.post(
      Uri.parse((AppConst.loginWithMobile)),
      body: reqBody,
    );
    return response.statusCode;
  }

  Future<AuthData> verifyOTP({
    required String mobile,
    required String otp,
  }) async {
    var reqBody = {'mobile': mobile, 'otp': otp};
    var url = Uri.parse((AppConst.verifyOTP));
    var response = await http.post(url, body: reqBody);

    print('vrify otp ::::');
    print('${response.body}');

    print('${response.statusCode}');

    AuthData data = loginAuthFromMap(response.body).data;

    if (response.statusCode == 200) {
    } else {
      throw HttpException('invalid login', uri: url);
    }

    return data;
  }
}
