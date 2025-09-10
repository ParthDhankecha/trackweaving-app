import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/screens/splash_screen.dart';
import 'package:flutter_texmunimx/utils/app_strings.dart';
import 'package:flutter_texmunimx/utils/app_translations.dart';
import 'package:flutter_texmunimx/utils/my_theme_controller.dart';
import 'package:get/get.dart';
import 'utils/get_di.dart' as getit;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getit.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      themeMode: themeController.themeMode,
      theme: themeController.lightTheme,
      darkTheme: themeController.darkTheme,
      translations: AppTranslations(), // Your translations
      locale: const Locale('en', 'US'), // Default locale
      fallbackLocale: const Locale(
        'en',
        'US',
      ), // Fallback for missing translations
      home: SplashScreen(),
    );
  }
}
