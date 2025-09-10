import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/utils/app_translations.dart';
import 'package:get/get.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // List of supported locales
    final List<Locale> locales = AppTranslations().keys.keys.map((langCode) {
      final parts = langCode.split('_');
      return Locale(parts[0], parts[1]);
    }).toList();

    // Map language codes to display names
    final Map<String, String> languageNames = {
      'en_US': 'English',
      'hi_IN': 'हिंदी',
      'gu_IN': 'ગુજરાતી',
    };

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
                Get.updateLocale(locale);
                Get.back();
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
