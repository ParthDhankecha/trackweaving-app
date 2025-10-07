import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/custom_progress_btn_.dart';
import 'package:trackweaving/common_widgets/main_btn.dart';
import 'package:trackweaving/controllers/machine_parts_controller.dart';
import 'package:get/get.dart';
import 'package:trackweaving/models/part_changelog_list_response.dart';
import 'package:trackweaving/screens/settings_screen/machine_parts/widgets/machine_dropdown.dart';
import 'package:trackweaving/screens/settings_screen/machine_parts/widgets/parts_search_dropdown.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:trackweaving/utils/date_formate_extension.dart';

class MachinePartsUpdate extends StatefulWidget {
  final PartChangeLog? partChangeLog;
  final int index;
  const MachinePartsUpdate({super.key, this.partChangeLog, this.index = -1});

  @override
  State<MachinePartsUpdate> createState() => _MachinePartsUpdateState();
}

class _MachinePartsUpdateState extends State<MachinePartsUpdate> {
  MachinePartsController controller = Get.find<MachinePartsController>();

  TextEditingController changeByNameController = TextEditingController();
  TextEditingController changeByPhoneController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    if (widget.partChangeLog != null) {
      controller.selectedPart.value = widget.partChangeLog!.partName;
      controller.selecteMachine.value = widget.partChangeLog!.machineId.id;
      controller.selectedCompleteDate.value = widget.partChangeLog!.changeDate;
      changeByNameController.text = widget.partChangeLog!.changedBy;
      changeByPhoneController.text =
          widget.partChangeLog!.changedByContact ?? '';
      notesController.text = widget.partChangeLog!.notes ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,

      appBar: AppBar(
        title: Text(
          widget.partChangeLog != null
              ? 'update_part_change_log'.tr
              : 'create_part_change_log'.tr,
        ),
      ),
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
                    Expanded(
                      child: Obx(
                        () => PartsSearchDropdown(
                          title: '${'select_part'.tr} *',
                          selectedValue: controller.selectedPart.value,
                          items: controller.availableParts
                              .map((e) => e)
                              .toList(),
                          onChanged: (value) {
                            controller.selectedPart.value = value!;
                          },
                          onNewPartAdded: (newPart) {
                            controller.addNewPart(newPart);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                MachineDropdown(
                  title: '${'select_machine'.tr} *',
                  selectedValue: controller.selecteMachine.value.isEmpty
                      ? null
                      : controller.availableMachines.firstWhere(
                          (machine) =>
                              machine.id == controller.selecteMachine.value,
                        ),
                  items: controller.availableMachines,
                  onChanged: (value) {
                    if (value?.machineCode == 'Select') {
                      controller.selecteMachine.value = '';
                      return;
                    }
                    controller.selectMachine(value?.id);
                  },
                ),
                SizedBox(height: 10),

                Obx(
                  () => _buildDateField(
                    '${'change_date'.tr} *',
                    controller.selectedCompleteDate.value,
                    (value) {
                      controller.changeCompleteDate(value);
                    },
                  ),
                ),
                SizedBox(height: 10),

                _buildInputField(
                  title: '${'change_by_name'.tr} *',
                  hintText: 'Name',
                  controller: changeByNameController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Name Field can not Empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _buildPhoneField(
                  title: 'change_by_phone'.tr,
                  hintText: 'Phone',
                  controller: changeByPhoneController,
                  validator: (String? value) {
                    if (value!.isNotEmpty) {
                      if (value!.length != 10) {
                        return 'Phone must be 10 Digit Number';
                      }
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                _buildInputField(
                  title: 'notes'.tr,
                  hintText: 'notes'.tr,
                  controller: notesController,
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
                              label: widget.partChangeLog == null
                                  ? 'save'.tr
                                  : 'update'.tr,
                              onTap: () {
                                if (controller.selectedPart.value == null ||
                                    controller.selectedPart.value.isEmpty) {
                                  Get.snackbar(
                                    'Part Required *',
                                    'Please select a part',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                if (controller.selecteMachine.value.isEmpty) {
                                  Get.snackbar(
                                    'Machine Required *',
                                    'Please select a machine',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }
                                if (formKey.currentState!.validate()) {
                                  controller.createChangeLog(
                                    name: changeByNameController.text,
                                    phone: changeByPhoneController.text,
                                    notes: notesController.text,
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
          controller: TextEditingController(text: selectedDate.ddmmyyFormat2),
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

  Widget _buildPhoneField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String? value) validator,
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
          keyboardType: TextInputType.phone,
          controller: controller,
          validator: validator,
          maxLength: 10,

          decoration: InputDecoration(
            counter: SizedBox.shrink(),
            // labelText: title,
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
