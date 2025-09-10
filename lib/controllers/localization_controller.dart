import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController {
  void changeLanguage(String languageCode) {
    var locale = Locale(languageCode);
    Get.updateLocale(locale);
  }
}
