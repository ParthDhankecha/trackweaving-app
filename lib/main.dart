import 'package:flutter/material.dart';
import 'package:trackweaving/controllers/localization_controller.dart';
import 'package:trackweaving/screens/splash_screen.dart';
import 'package:trackweaving/utils/app_strings.dart';
import 'package:trackweaving/utils/internationalization.dart';
import 'package:trackweaving/utils/my_theme_controller.dart';
import 'package:get/get.dart';
import 'utils/get_di.dart' as getit;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getit.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeController themeController = Get.put(ThemeController());

  final LocalizationController localizationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      themeMode: themeController.themeMode,
      theme: themeController.lightTheme,
      darkTheme: themeController.lightTheme,
      translations: AppTranslations(), // translations
      //locale: Locale('en', 'US'), // Default locale
      fallbackLocale: const Locale(
        'en',
        'US',
      ), // Fallback for missing translations
      home: SplashScreen(),
      //
    );
  }
}
