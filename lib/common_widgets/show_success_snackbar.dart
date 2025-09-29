import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSuccessSnackbar(String title, {String decs = ''}) {
  Get.snackbar(
    title, // Title of the SnackBar
    decs, // Message content
    messageText: decs.isNotEmpty
        ? Text(decs, style: const TextStyle(color: Colors.white))
        : Container(),
    snackPosition: SnackPosition.TOP, // Position of the SnackBar
    backgroundColor: Colors.green, // Background color for error indication
    colorText: Colors.white, // Text color
    icon: const Icon(Icons.error, color: Colors.white), // Optional icon
    duration: const Duration(seconds: 3), // Duration the SnackBar is visible
  );
}
