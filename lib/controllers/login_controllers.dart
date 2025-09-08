import 'dart:async';

import 'package:flutter_texmunimx/common_widgets/show_error_snakbar.dart';
import 'package:flutter_texmunimx/repository/login_repo.dart';
import 'package:flutter_texmunimx/screens/auth_screens/verify_otp_screen.dart';
import 'package:flutter_texmunimx/screens/home/home_screen.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';

class LoginControllers extends GetxController implements GetxService {
  RxString phone = ''.obs;
  RxString otp = ''.obs;
  RxBool isLoading = false.obs;

  Timer? _timer;
  int timerSeconds = 60; // Initial countdown duration
  RxBool canResend = false.obs;
  RxString remainingTimer = ''.obs;

  LoginRepo repo = LoginRepo();

  final Sharedprefs sp;

  LoginControllers({required this.sp});

  void setPhoneNumber(String num) {
    phone.value = num;
  }

  void setOtp(String num) {
    otp.value = num;
  }

  void setLoading(bool load) {
    isLoading.value = load;
  }

  sendOtp() async {
    try {
      isLoading.value = true;
      startTimer();
      otp.value = '';
      int code = await repo.sendOtp(mobile: phone.value);
      if (code == 200) {
        Get.to(() => VerifyOtpScreen());
      }
    } catch (e) {
      print('send otp error : $e');
    } finally {
      isLoading.value = false;
    }
  }

  verifyOTP() async {
    try {
      isLoading.value = true;
      repo
          .verifyOTP(mobile: phone.value, otp: otp.value)
          .then((value) {
            sp.userToken = value.token.accessToken;
            Get.offAll(() => HomeScreen());
          })
          .onError((error, stackTrace) {
            showErrorSnackbar('Invalid OTP');
          });
    } finally {
      isLoading.value = false;
    }
  }

  void startTimer() {
    canResend.value = false;
    timerSeconds = 60; // Reset timer
    remainingTimer.value = 'in ${timerSeconds}s';
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerSeconds == 0) {
        canResend.value = true;
        remainingTimer.value = '';
        _timer?.cancel();
      } else {
        timerSeconds--;
        remainingTimer.value = 'in ${timerSeconds}s';
      }
    });
  }

  void timerDispose() {
    _timer?.cancel();
  }
}
