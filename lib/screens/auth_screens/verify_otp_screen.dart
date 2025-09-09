import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/main_btn.dart';
import 'package:flutter_texmunimx/controllers/login_controllers.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  LoginControllers loginControllers = Get.find<LoginControllers>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text(
                  'Verify Phone Number',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'We have sent OTP at ${loginControllers.phone.value}',
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          buildPinPut(),
          SizedBox(height: 14),
          buildResendBtn(),
          SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Obx(
                  () => loginControllers.isLoading.value
                      ? Center(
                          child: SizedBox(
                            height: 45,
                            width: 45,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : MainBtn(
                          label: 'Verify OTP',
                          onTap: loginControllers.otp.value.length == 6
                              ? loginControllers.verifyOTP
                              : null,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buildResendBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () => TextButton(
            onPressed: loginControllers.canResend.value
                ? loginControllers.sendOtp
                : null,
            child: Text(
              'Resend OTP ${loginControllers.remainingTimer.value}',
              style: TextStyle(
                fontSize: 14,
                color: loginControllers.canResend.value
                    ? AppColors.mainColor
                    : CupertinoColors.inactiveGray,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //otp view
  Widget buildPinPut() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Pinput(
          length: 6,
          onChanged: (value) {
            if (value.trim().length == 6) {
              loginControllers.setOtp(value);
            } else {
              loginControllers.setOtp('');
            }
          },
          onCompleted: (pin) {},
        ),
      ],
    );
  }
}
