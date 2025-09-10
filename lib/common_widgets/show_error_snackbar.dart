import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackbar(
  String title, {
  String decs = 'Something went wrong. Please try again.',
}) {
  Get.snackbar(
    title, // Title of the SnackBar
    decs, // Message content
    snackPosition: SnackPosition.TOP, // Position of the SnackBar
    backgroundColor: Colors.red, // Background color for error indication
    colorText: Colors.white, // Text color
    icon: const Icon(Icons.error, color: Colors.white), // Optional icon
    duration: const Duration(seconds: 3), // Duration the SnackBar is visible
  );
}
