import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/show_error_snackbar.dart';
import 'package:trackweaving/repository/api_exception.dart';
import 'package:trackweaving/repository/login_repo.dart';
import 'package:trackweaving/screens/auth_screens/login_screen.dart';
import 'package:trackweaving/screens/home/home_screen.dart';
import 'package:trackweaving/utils/shared_pref.dart';
import 'package:get/get.dart';

class LoginControllers extends GetxController implements GetxService {
  RxBool isLoading = false.obs;

  final LoginRepo repo;

  final Sharedprefs sp;

  RxBool showPassword = false.obs;

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  LoginControllers({required this.sp, required this.repo});

  String get usertID => sp.userID;

  void setLoading(bool load) {
    isLoading.value = load;
  }

  intialize() {
    emailCont.text = '';
    passwordCont.text = '';
    return 0;
  }

  loginWithEmailPassword() async {
    try {
      isLoading.value = true;
      String userEmail = emailCont.text.trim();
      String userPassword = passwordCont.text.trim();

      var data = await repo.loginWithEmailPassword(
        email: userEmail,
        password: userPassword,
      );

      log('login response ::: ${data.user.type}');

      log(data.token.accessToken);
      if (data.token.accessToken.isNotEmpty) {
        sp.currentLoginId = data.user.id;
        sp.userToken = data.token.accessToken;
        sp.userID = data.user.userId ?? '';
        sp.userType = data.user.type ?? 0;
        Get.offAll(() => HomeScreen());
      } else {}
    } on ApiException catch (e) {
      log('Login Error : $e');
      if (e.message.isNotEmpty) {
        showErrorSnackbar(e.message);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    sp.userToken = '';
    sp.fcmToken = '';
    repo.deleFcmToken();
    sp.clearAll();
    Get.offAll(() => LoginScreen());
  }
}
