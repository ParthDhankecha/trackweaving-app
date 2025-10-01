import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/main_btn.dart';
import 'package:trackweaving/controllers/machine_controller.dart';
import 'package:trackweaving/controllers/shift_comment_controller.dart';
import 'package:trackweaving/screens/settings_screen/shift_comments/widgets/machine_dropdown.dart';
import 'package:trackweaving/screens/settings_screen/shift_comments/widgets/shift_dropdown.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:trackweaving/utils/date_formate_extension.dart';
import 'package:get/get.dart';

class ShiftComments extends StatefulWidget {
  const ShiftComments({super.key});

  @override
  State<ShiftComments> createState() => _ShiftCommentsState();
}

class _ShiftCommentsState extends State<ShiftComments> {
  MachineController machineController = Get.find();
  ShiftCommentController shiftCommentController = Get.find();
  @override
  void initState() {
    super.initState();
    machineController.getMachineList();
    shiftCommentController.clearMachineSelection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,

      appBar: AppBar(title: Text('shift_wise_comment_update'.tr)),
      body: Obx(
        () => machineController.isLoading.value
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: MachineDropdown(
                      title: 'machine'.tr,
                      selectedValue: shiftCommentController.machineCodes.isEmpty
                          ? null
                          : shiftCommentController.selectedMachine.value,
                      items: machineController.machineList,
                      onChanged: (value) {
                        if (value!.machineCode == 'Select All') {
                          shiftCommentController.selectAllMachine(
                            machineController.machineList,
                          );
                        } else {
                          shiftCommentController.selectMachine(value);
                          shiftCommentController.selectedMachineValue = value;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),

                    child: _buildDateField(
                      'report_date'.tr,
                      shiftCommentController.selectedDate.value,
                      (value) {
                        shiftCommentController.selectedDate.value = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),

                    child: ShiftDropdown(
                      title: 'shift'.tr,
                      items: shiftCommentController.shiftTypes,
                      onChanged: (value) {
                        shiftCommentController.selectShiftType(
                          value?.type ?? 'all',
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        MainBtn(
                          label: 'show_report'.tr,
                          onTap: () {
                            if (shiftCommentController.machineCodes.isEmpty) {
                              shiftCommentController.selectAllMachine(
                                machineController.machineList,
                              );
                            }

                            if (shiftCommentController.machineCodes.length ==
                                1) {
                              shiftCommentController
                                  .generateRecordsForSelectedMachine();
                            } else {
                              shiftCommentController.generateRecords();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
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
          controller: TextEditingController(text: selectedDate.ddmmyyFormat),
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
}
