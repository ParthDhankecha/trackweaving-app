import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackbar(String title, {String decs = ''}) {
  Get.snackbar(
    title, // Title of the SnackBar
    decs, // Message content
    titleText: title.isEmpty
        ? Container()
        : Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
    messageText: decs.isEmpty ? SizedBox.shrink() : Text(decs),
    snackPosition: SnackPosition.TOP, // Position of the SnackBar
    backgroundColor: Colors.red, // Background color for error indication
    colorText: Colors.white, // Text color
    //icon: const Icon(Icons.error, color: Colors.white), // Optional icon
    duration: const Duration(seconds: 3), // Duration the SnackBar is visible
  );
}
