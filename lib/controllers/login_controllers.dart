import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/repository/api_exception.dart';
import 'package:flutter_texmunimx/repository/login_repo.dart';
import 'package:flutter_texmunimx/screens/auth_screens/login_screen.dart';
import 'package:flutter_texmunimx/screens/home/home_screen.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';

class LoginControllers extends GetxController implements GetxService {
  RxBool isLoading = false.obs;

  final LoginRepo repo;

  final Sharedprefs sp;

  RxBool showPassword = false.obs;

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  LoginControllers({required this.sp, required this.repo});

  void setLoading(bool load) {
    isLoading.value = load;
  }

  void saveHostUrl(String hostName) {
    sp.hostUrl = hostName;
  }

  String get hostUrl => sp.hostUrl;

  loginWithEmailPassword() async {
    try {
      isLoading.value = true;
      String userEmail = emailCont.text.trim();
      String userPassword = passwordCont.text.trim();

      var data = await repo.loginWithEmailPassword(
        email: userEmail,
        password: userPassword,
      );

      log('login response :::');

      log(data.token.accessToken);
      if (data.token.accessToken.isNotEmpty) {
        sp.userToken = data.token.accessToken;
        Get.to(() => HomeScreen());
      } else {}
    } on ApiException catch (e) {
      log('Login Error : $e');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    sp.userToken = '';
    Get.offAll(() => LoginScreen());
  }
}
