import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:flutter_texmunimx/common_widgets/custom_progress_btn_.dart';
import 'package:flutter_texmunimx/common_widgets/main_btn.dart';
import 'package:flutter_texmunimx/common_widgets/password_input.dart';
import 'package:flutter_texmunimx/controllers/login_controllers.dart';
import 'package:flutter_texmunimx/screens/auth_screens/widgets/host_url.dialog.dart';
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
  final formKey = GlobalKey<FormState>();

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.dialog(const HostUrlDialog());
                      },
                      child: Text(
                        'Change Base Url',
                        style: bodyStyle1.copyWith(color: AppColors.errorColor),
                      ),
                    ),
                  ],
                ),
                Text(
                  AppStrings.appName,
                  style: titleStyle.copyWith(fontSize: 20),
                ),
                SizedBox(height: 56),
                Text('Welcome'),
                Text('Login with User Name and Password.'),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: _buildInput(
                    hintText: 'Enter User Name',
                    labelText: 'User Name',
                    controller: loginController.emailCont,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an User Name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: PasswordTextField(
                    controller: loginController.passwordCont,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => loginController.isLoading.value
                            ? CustomProgressBtn()
                            : MainBtn(
                                label: 'Login',
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    loginController.loginWithEmailPassword();
                                  }
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

  Widget _buildInput({
    required String hintText,
    required String labelText,
    TextEditingController? controller,
    TextInputType? keyboardType,
    String? Function(String? value)? validator,
    void Function(String value)? onChange,
    bool isPassword = false,
  }) {
    return Stack(
      children: [
        SizedBox(
          child: TextFormField(
            controller: controller,
            onChanged: onChange,
            validator: validator,
            keyboardType: keyboardType,
            obscureText: isPassword,

            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              hintStyle: TextStyle(color: AppColors.blackColor),
              labelStyle: TextStyle(color: AppColors.blackColor),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),

        if (isPassword)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: IconButton(
              onPressed: () {},
              icon: Icon(isPassword ? Icons.visibility : Icons.visibility_off),
            ),
          ),
      ],
    );
  }
}
