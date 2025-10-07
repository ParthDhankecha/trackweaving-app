import 'package:flutter/material.dart';
import 'package:trackweaving/controllers/machine_controller.dart';
import 'package:trackweaving/controllers/report_controller.dart';
import 'package:trackweaving/screens/report_screen/report_result_screen.dart';
import 'package:trackweaving/screens/report_screen/widgets/build_checkbox_row.dart';
import 'package:trackweaving/screens/report_screen/widgets/build_datefield.dart';
import 'package:trackweaving/screens/settings_screen/machine_configuration/widgets/machine_group_dropdown.dart';
import 'package:trackweaving/screens/settings_screen/shift_comments/widgets/shift_dropdown.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:get/get.dart';

class ProductionReportPage extends StatefulWidget {
  const ProductionReportPage({super.key});

  @override
  State<ProductionReportPage> createState() => _ProductionReportPageState();
}

class _ProductionReportPageState extends State<ProductionReportPage> {
  // State variables for form fields
  String _selectedReportType = 'Production Shiftwise Report';

  MachineController machineController = Get.find<MachineController>();
  ReportController reportController = Get.find<ReportController>();
  RxBool isLoading = false.obs;

  loadAllData() async {
    isLoading.value = true;
    await machineController.getMachineList();
    await machineController.getList();
    reportController.setAvailableMachines(machineController.machineList);
    reportController.setAvailableMachinesGroups(
      machineController.machineGroupList,
    );
    reportController.changeShiftType(reportController.shiftTypeList.first);
    isLoading.value = false;
  }

  @override
  void initState() {
    super.initState();
    reportController.clearSelection();
    loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('reports'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(
                  () => isLoading.value
                      ? Center(
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            BuildDropdownField(
                              title: 'report_type'.tr,
                              selectedValue: _selectedReportType,
                              items: ['Production Shiftwise Report'],
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedReportType = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Obx(
                                  () => Expanded(
                                    child: BuildDatefield(
                                      context: context,
                                      title: 'from_date'.tr,
                                      selectedDate:
                                          reportController.startDate.value,
                                      onDateSelected: (newDate) {
                                        reportController.startDate.value =
                                            newDate;

                                        reportController.endDate.value =
                                            newDate;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Obx(
                                  () => Expanded(
                                    child: BuildDatefield(
                                      context: context,
                                      title: 'end_date'.tr,
                                      selectedDate:
                                          reportController.endDate.value,
                                      onDateSelected: (newDate) {
                                        reportController.endDate.value =
                                            newDate;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            ShiftDropdown(
                              title: 'shift'.tr,
                              items: reportController.shiftTypeList,
                              selectedValue:
                                  reportController.selectedShift.value,
                              onChanged: (value) {
                                reportController.changeShiftType(value);
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    bottom: 4.0,
                                  ),
                                  child: Text(
                                    '${'machine'.tr}: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => BuildCheckboxRow(
                                    title: 'group_wise_machine'.tr,
                                    value:
                                        reportController.isGroupVisible.value,
                                    onChanged: (value) {
                                      reportController.changeGroupVisible();
                                      reportController.filerMachineByGroup(
                                        'select',
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            Visibility(
                              visible: reportController.isGroupVisible.value,
                              child: MachineGroupDropdown(
                                title: 'machine_group'.tr,
                                items:
                                    reportController.availableMachineGroupList,
                                onChanged: (value) {
                                  if (value?.id == 'all') {
                                    reportController.filerMachineByGroup(
                                      'select',
                                    );
                                  } else {
                                    reportController.filerMachineByGroup(
                                      value!.id,
                                    );
                                  }
                                },
                              ),
                            ),

                            Obx(
                              () => BuildCheckboxRow(
                                title: 'Select All',
                                value: reportController.selectAllMachines.value,
                                onChanged: reportController.onSelectAllChanged,
                              ),
                            ),

                            Obx(
                              () => Wrap(
                                direction: Axis.horizontal,
                                children: reportController.checkboxMachineList
                                    .map((machine) {
                                      return BuildCheckboxRow(
                                        title: machine.machineCode,
                                        value: reportController
                                            .selectedMachineList
                                            .contains(machine),
                                        onChanged: (value) {
                                          reportController.onMachineSelect(
                                            machine,
                                            value,
                                          );
                                        },
                                      );
                                    })
                                    .toList(),
                              ),
                            ),

                            Obx(
                              () => reportController.isLoading.value
                                  ? Center(
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        var reportData = await reportController
                                            .getReportData();
                                        if (reportData != null) {
                                          Get.to(
                                            () => ReportResultScreen(
                                              reportResponse: reportData,
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.mainColor,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'show_report'.tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildDropdownField extends StatelessWidget {
  const BuildDropdownField({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  final String title;
  final String selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        DropdownButtonFormField<String>(
          initialValue: selectedValue,
          dropdownColor: Colors.white,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
