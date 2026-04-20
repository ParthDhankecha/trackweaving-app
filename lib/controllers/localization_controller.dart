import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackweaving/utils/shared_pref.dart';

class LocalizationController extends GetxController implements GetxService {
  final Sharedprefs sp;

  // Map language codes to display names
  final Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'हिंदी',
    'gu': 'ગુજરાતી',
  };

  LocalizationController({required this.sp});

  void changeLanguage(String languageCode) {
    sp.currentLanguage = languageCode;

    var locale = Locale(languageCode);
    Get.updateLocale(locale);
  }

  Future<void> initLanguage() async {
    var languageCode = sp.currentLanguage;
    var locale = Locale(languageCode);
    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    super.onInit();
    initLanguage();
  }
}
