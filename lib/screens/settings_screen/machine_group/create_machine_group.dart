import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackweaving/common_widgets/show_error_snackbar.dart';
import 'package:get/get.dart';
import 'package:trackweaving/utils/app_colors.dart';

class CreateMachineGroup extends StatefulWidget {
  final String? initialName;
  final Function(String) onSave;

  const CreateMachineGroup({super.key, this.initialName, required this.onSave});

  @override
  State<CreateMachineGroup> createState() => _CreateMachineGroupState();
}

class _CreateMachineGroupState extends State<CreateMachineGroup> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.initialName == null
                  ? 'enter_group_name'.tr
                  : 'Update Group Name',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Device Group Name*',
                hintText: 'e.g., Weaving Machine 1',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'cancel'.tr,
                      style: GoogleFonts.poppins(color: AppColors.mainColor),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final name = _controller.text.trim();
                      if (name.isNotEmpty) {
                        widget.onSave(name);
                        Get.back();
                      } else {
                        showErrorSnackbar(
                          'Enter Group Name',
                          decs: 'Machine Group Name is mandatory.',
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      widget.initialName == null ? 'save'.tr : 'update'.tr,
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
