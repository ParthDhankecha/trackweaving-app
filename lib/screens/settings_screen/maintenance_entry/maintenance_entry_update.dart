import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:flutter_texmunimx/common_widgets/custom_progress_btn_.dart';
import 'package:flutter_texmunimx/common_widgets/main_btn.dart';
import 'package:flutter_texmunimx/controllers/maintenance_category_controller.dart';
import 'package:flutter_texmunimx/models/maintenance_alert_reponse.dart';
import 'package:get/get.dart';

class MaintenanceEntryUpdate extends StatefulWidget {
  final MaintenanceEntryModel maintenanceEntryModel;
  final Alert alert;
  const MaintenanceEntryUpdate({
    super.key,
    required this.maintenanceEntryModel,
    required this.alert,
  });

  @override
  State<MaintenanceEntryUpdate> createState() => _MaintenanceEntryUpdateState();
}

class _MaintenanceEntryUpdateState extends State<MaintenanceEntryUpdate> {
  MaintenanceCategoryController controller =
      Get.find<MaintenanceCategoryController>();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Maintenance Entry Update')),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('machine_name'.tr),

                    Text(
                      widget.maintenanceEntryModel.machineName,
                      style: bodyStyle,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('maintenance_category'.tr),
                    Text(widget.alert.categoryName, style: bodyStyle),
                  ],
                ),
                SizedBox(height: 10),
                Obx(
                  () => _buildDateField(
                    'Complete Date *',
                    controller.selectedCompleteDate.value,
                    (value) {
                      controller.changeCompleteDate(value);
                    },
                  ),
                ),
                SizedBox(height: 10),
                Obx(
                  () => _buildDateField(
                    'Next Maintenance Date*',
                    controller.selectedNextDate.value,
                    (value) {
                      controller.changeNextDate(value);
                    },
                  ),
                ),
                SizedBox(height: 10),
                _buildInputField(
                  title: 'Completed By *',
                  hintText: 'Name',
                  controller: controller.completedName,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Name Field can not Empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _buildInputField(
                  title: '',
                  hintText: 'Phone',
                  controller: controller.completedPhone,
                  inputType: TextInputType.phone,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone Field can not Empty';
                    }

                    if (value.length != 10) {
                      return 'Phone must be 10 Digit Number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _buildInputField(
                  title: 'Remark',
                  hintText: 'Remark',
                  controller: controller.remarkCont,
                  inputType: TextInputType.multiline,
                  validator: (String? value) {
                    return null;
                  },
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Obx(
                      () => controller.isLoading.value
                          ? CustomProgressBtn()
                          : MainBtn(
                              label: 'Update Entry',
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  controller.updateMaintenanceEntry(
                                    id: widget.alert.id,
                                  );
                                }
                              },
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(
    String title,
    DateTime selectedDate,
    ValueChanged<DateTime> onDateSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        TextFormField(
          readOnly: true,
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null && pickedDate != selectedDate) {
              onDateSelected(pickedDate);
            }
          },
          controller: TextEditingController(
            text:
                '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
          ),
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            suffixIcon: const Icon(Icons.calendar_month, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String? value) validator,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        TextFormField(
          keyboardType: inputType,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            // labelText: title,
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
