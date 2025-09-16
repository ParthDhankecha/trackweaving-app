import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/animated_alert_switch.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:flutter_texmunimx/common_widgets/custom_progress_btn_.dart';
import 'package:flutter_texmunimx/common_widgets/main_btn.dart';
import 'package:flutter_texmunimx/controllers/machine_controller.dart';
import 'package:flutter_texmunimx/models/machine_group_response_model.dart';
import 'package:flutter_texmunimx/models/machine_list_response_model.dart';
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
      name: widget.machine.machineName,
      code: widget.machine.machineCode,
      alert: widget.machine.isAlertActive,
      grpId: widget.machine.machineGroupId?.id ?? 'NA',
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
      body: Padding(
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
                  title: 'Machine Name',
                  hintText: 'Enter Machine Name',
                  controller: controller.machineNameController,
                ),
                SizedBox(height: 12),

                _buildInputField(
                  title: 'Machine Code',
                  hintText: 'Enter Machine Code',
                  controller: controller.machineCodeController,
                ),
                SizedBox(height: 12),

                _buildDropdownField(
                  'Machine Group Name',
                  controller.selectedMachineGrpId.value,
                  controller.machineGroupList,
                  (value) {
                    controller.selectedMachineGrpId.value = value;
                  },
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
    );
  }

  Widget _buildInputField({
    required String title,
    required String hintText,
    required TextEditingController controller,

    TextInputType inputType = TextInputType.text,
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
          keyboardType: inputType,
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$title Field can not Empty';
            }
            return null;
          },
          decoration: InputDecoration(
            // labelText: title,
            //hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String title,
    MachineGroup? selectedValue,
    List<MachineGroup> items,
    ValueChanged<MachineGroup?> onChanged,
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
        Obx(
          () => DropdownButtonFormField<MachineGroup>(
            initialValue: selectedValue,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: items.map((MachineGroup value) {
              return DropdownMenuItem<MachineGroup>(
                value: value,
                child: Text(value.groupName),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
