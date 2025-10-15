import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/animated_alert_switch.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';
import 'package:trackweaving/common_widgets/custom_progress_btn_.dart';
import 'package:trackweaving/common_widgets/main_btn.dart';
import 'package:trackweaving/controllers/machine_controller.dart';
import 'package:trackweaving/models/machine_list_response_model.dart';
import 'package:trackweaving/screens/settings_screen/machine_configuration/widgets/machine_group_dropdown.dart';
import 'package:get/get.dart';

class EditMachineConfiguration extends StatefulWidget {
  final Machine machine;
  const EditMachineConfiguration({super.key, required this.machine});

  @override
  State<EditMachineConfiguration> createState() =>
      _EditMachineConfigurationState();
}

class _EditMachineConfigurationState extends State<EditMachineConfiguration> {
  MachineController controller = Get.find<MachineController>();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller.setFields(
      name: widget.machine.machineName.capitalizeFirst!,
      code: widget.machine.machineCode,
      alert: widget.machine.isAlertActive,
      grpId: widget.machine.machineGroupId?.id,
      maxLimit: widget.machine.maxSpeedLimit ?? 0,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Machine Configuration')),
      body: Column(
        children: [
          Divider(height: 1, thickness: 0.2),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Sr. No:'),
                          SizedBox(width: 10),
                          Text(widget.machine.serialNumber, style: bodyStyle),
                        ],
                      ),
                      SizedBox(height: 12),
                      //
                      _buildInputField(
                        title: 'machine_company_name'.tr,
                        hintText: 'Enter Machine Company Name',
                        controller: controller.machineNameController,
                        isEnabled: false,
                        onValidation: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Machine Name Field can not be Empty';
                          // }
                          // return null;
                        },
                      ),
                      SizedBox(height: 12),

                      _buildInputField(
                        title: 'Machine Code',
                        hintText: 'Enter Machine Code',
                        controller: controller.machineCodeController,
                        onValidation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Machine Code Field can not be Empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),

                      MachineGroupDropdown(
                        title: 'Machine Group Name',
                        items: controller.machineGroupList,
                        selectedValue: controller.selectedMachineGrpId.value,
                        onChanged: (value) {
                          if (value?.groupName == 'Select') {
                            controller.selectedMachineGrpId.value = null;
                          } else {
                            controller.selectedMachineGrpId.value = value;
                          }
                        },
                      ),
                      SizedBox(height: 12),

                      _buildInputField(
                        title: 'machine_max_limit'.tr,
                        hintText: 'Enter Machine Max Limit',
                        controller: controller.maxLimitController,
                        inputType: TextInputType.number,
                      ),

                      SizedBox(height: 16),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Alert:  ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 46,
                            child: Obx(
                              () => AnimatedAlertSwitch(
                                current: controller.machineAlert.value,
                                onChanged: (value) {
                                  controller.changeMachineAlert();
                                },
                                onTitle: 'ON',
                                offTitle: 'OFF',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Obx(
                            () => controller.isLoading.value
                                ? CustomProgressBtn()
                                : MainBtn(
                                    label: 'Update',
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        controller.updateMachineConfig(
                                          widget.machine.id,
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
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String title,
    required String hintText,
    required TextEditingController controller,

    TextInputType inputType = TextInputType.text,
    String? Function(String?)? onValidation,
    bool isEnabled = true,
  }) {
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
          enabled: isEnabled,
          keyboardType: inputType,
          controller: controller,
          validator: onValidation,
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
