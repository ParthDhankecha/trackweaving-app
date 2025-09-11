import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:flutter_texmunimx/common_widgets/main_btn.dart';
import 'package:flutter_texmunimx/controllers/login_controllers.dart';
import 'package:flutter_texmunimx/screens/auth_screens/widgets/privacy_bar.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';
import 'package:flutter_texmunimx/utils/app_strings.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey formKey = GlobalKey<FormState>();

  TextEditingController phoneInputCont = TextEditingController();

  LoginControllers loginController = Get.find<LoginControllers>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.appName,
                  style: titleStyle.copyWith(fontSize: 20),
                ),
                SizedBox(height: 56),
                Text('Welcome'),
                Text('Please Enter your 10 digit phone number.'),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(children: [Expanded(child: _buildPhoneInput())]),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Obx(
                        () => MainBtn(
                          label: 'Get OTP',
                          onTap: loginController.phone.value.isEmpty
                              ? null
                              : () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  //Get.to(() => VerifyOtpScreen());
                                  loginController.sendOtp();
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(bottom: 16, left: 0, right: 0, child: PrivacyBar()),
        ],
      ),
    );
  }

  TextFormField _buildPhoneInput() {
    return TextFormField(
      controller: phoneInputCont,
      onChanged: (value) {
        if (value.trim().length == 10) {
          loginController.setPhoneNumber(phoneInputCont.text.trim());
        } else {
          loginController.setPhoneNumber('');
        }
      },
      validator: (value) {
        if (value.toString().isEmpty) {
          return 'Enter Valid Phone Number.';
        }

        if (value.toString().length != 10) {
          return 'Enter valid 10 digit phone number.';
        }

        return null;
      },
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: 'Enter 10 digit number',
        labelText: 'Phone Number',
        hintStyle: TextStyle(color: AppColors.blackColor),
        labelStyle: TextStyle(color: AppColors.blackColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
