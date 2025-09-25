import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trackweaving/controllers/login_controllers.dart';
import 'package:get/get.dart';

class HostUrlDialog extends StatefulWidget {
  const HostUrlDialog({super.key});

  @override
  State<HostUrlDialog> createState() => _HostUrlDialogState();
}

class _HostUrlDialogState extends State<HostUrlDialog> {
  final TextEditingController _urlController = TextEditingController();
  final LoginControllers loginControllers = Get.find<LoginControllers>();

  @override
  void initState() {
    super.initState();
    _urlController.value = TextEditingValue(text: loginControllers.hostUrl);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save Host URL'),
      content: TextFormField(
        controller: _urlController,
        decoration: const InputDecoration(
          hintText: 'Enter Host URL',
          border: OutlineInputBorder(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Get.back(); // Close the dialog
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            // Here you would save the URL, e.g., to SharedPreferences or a controller
            final hostUrl = _urlController.text;
            loginControllers.saveHostUrl(hostUrl);
            log('Saved Host URL: $hostUrl');
            Get.back(); // Close the dialog
          },
        ),
      ],
    );
  }
}
