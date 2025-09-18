import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/controllers/machine_controller.dart';
import 'package:flutter_texmunimx/controllers/report_controller.dart';
import 'package:flutter_texmunimx/screens/report_screen/report_result_screen.dart';
import 'package:flutter_texmunimx/screens/settings_screen/machine_configuration/widgets/machine_group_dropdown.dart';
import 'package:flutter_texmunimx/screens/settings_screen/shift_comments/widgets/shift_dropdown.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';
import 'package:get/get.dart';

class ProductionReportPage extends StatefulWidget {
  const ProductionReportPage({super.key});

  @override
  State<ProductionReportPage> createState() => _ProductionReportPageState();
}

class _ProductionReportPageState extends State<ProductionReportPage> {
  // State variables for form fields
  String _selectedReportType = 'Production Shiftwise Report';
  DateTime _fromDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  MachineController machineController = Get.find<MachineController>();
  ReportController reportController = Get.find<ReportController>();
  RxBool isLoading = false.obs;

  // Reusable widget for a title with a dropdown
  Widget _buildDropdownField(
    String title,
    String selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
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

  // Reusable widget for a date picker field
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        TextFormField(
          readOnly: true,
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
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.grey),
              onPressed: () async {
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
            ),
          ),
        ),
      ],
    );
  }

  // Reusable widget for a checkbox and text in a row
  Widget _buildCheckboxRow(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,

          activeColor: AppColors.mainColor,
        ),
        Text(title),
      ],
    );
  }

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
    loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 45),

            Card(
              elevation: 4,
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
                            _buildDropdownField(
                              'report_type'.tr,
                              _selectedReportType,
                              ['Production Shiftwise Report'],
                              (newValue) {
                                setState(() {
                                  _selectedReportType = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDateField(
                                    'from_date'.tr,
                                    _fromDate,
                                    (newDate) {
                                      setState(() {
                                        _fromDate = newDate;
                                        _endDate = newDate;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: _buildDateField(
                                    'end_date'.tr,
                                    _endDate,
                                    (newDate) {
                                      setState(() {
                                        _endDate = newDate;
                                      });
                                    },
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
                                  () => _buildCheckboxRow(
                                    'group_wise_machine'.tr,
                                    reportController.isGroupVisible.value,
                                    (value) {
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
                              () => _buildCheckboxRow(
                                'Select All',
                                reportController.selectAllMachines.value,
                                reportController.onSelectAllChanged,
                              ),
                            ),

                            Obx(
                              () => Wrap(
                                direction: Axis.horizontal,
                                children: reportController.checkboxMachineList
                                    .map((machine) {
                                      return _buildCheckboxRow(
                                        machine.machineCode,
                                        reportController.selectedMachineList
                                            .contains(machine),
                                        (value) {
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

                            ElevatedButton(
                              onPressed: () {
                                // Logic to show the report
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Showing Report...'),
                                  ),
                                );

                                Get.to(() => ReportResultScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.mainColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
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
