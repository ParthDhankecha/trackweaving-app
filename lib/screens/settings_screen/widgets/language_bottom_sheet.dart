import 'package:flutter/material.dart';
import 'package:trackweaving/controllers/localization_controller.dart';
import 'package:trackweaving/utils/internationalization.dart';
import 'package:get/get.dart';

class LanguageBottomSheet extends StatelessWidget {
  LanguageBottomSheet({super.key});

  final LocalizationController localizationController =
      Get.find<LocalizationController>();

  @override
  Widget build(BuildContext context) {
    // List of supported locales
    final List<Locale> locales = AppTranslations().keys.keys.map((langCode) {
      final parts = langCode.split('_');
      return Locale(parts[0], parts[1]);
    }).toList();

    final languageNames = localizationController.languageNames;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Change Language'.tr,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ...locales.map((locale) {
            final languageCode = '${locale.languageCode}_${locale.countryCode}';
            return ListTile(
              title: Text(languageNames[languageCode]!),
              trailing: Get.locale == locale
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
              onTap: () {
                localizationController.changeLanguage(languageCode);
                // Get.updateLocale(locale);
                Get.back();
              },
            );
          }),
        ],
      ),
    );
  }
}
