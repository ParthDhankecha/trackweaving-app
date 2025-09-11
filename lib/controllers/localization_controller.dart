import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController {
  final Sharedprefs sp;

  // Map language codes to display names
  final Map<String, String> languageNames = {
    'en_US': 'English',
    'hi_IN': 'हिंदी',
    'gu_IN': 'ગુજરાતી',
  };

  LocalizationController({required this.sp});

  void changeLanguage(String languageCode) {
    print('change lan : $languageCode');
    sp.currentLanguage = languageCode;
    print('change lan sp: ${sp.currentLanguage}}');

    var locale = Locale(languageCode);
    Get.updateLocale(locale);
  }

  Future<void> initLanguage() async {
    var languageCode = sp.currentLanguage;
    print('already Found $languageCode');
    var locale = Locale(languageCode);
    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    super.onInit();
    initLanguage();
  }
}
