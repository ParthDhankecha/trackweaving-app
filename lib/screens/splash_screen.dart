import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackweaving/controllers/splash_controller.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:trackweaving/utils/app_images.dart';
import 'package:trackweaving/utils/app_strings.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashController splashController = Get.find();

  @override
  void initState() {
    super.initState();
    splashController.checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.appBg,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppImages.splashLogo, height: 140, width: 140),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.appName,
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            Text(
              AppStrings.appTagLine,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: AppColors.mainColor,

                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
