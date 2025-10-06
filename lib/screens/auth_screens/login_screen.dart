import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackweaving/common_widgets/custom_progress_btn_.dart';
import 'package:trackweaving/common_widgets/main_btn.dart';
import 'package:trackweaving/common_widgets/password_input.dart';
import 'package:trackweaving/controllers/login_controllers.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:trackweaving/utils/app_images.dart';
import 'package:trackweaving/utils/app_strings.dart';
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
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     TextButton(
            //       onPressed: () {
            //         Get.dialog(const HostUrlDialog());
            //       },
            //       child: Text(
            //         'Change Base Url',
            //         style: bodyStyle1.copyWith(color: AppColors.errorColor),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppImages.splashLogo, height: 120, width: 120),
              ],
            ),
            SizedBox(height: 16),
            Text(
              AppStrings.appName,
              style: GoogleFonts.poppins(
                fontSize: 30,
                color: AppColors.mainColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

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
            style: GoogleFonts.poppins(color: AppColors.blackColor),
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
