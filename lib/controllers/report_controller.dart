import 'dart:developer';

import 'package:trackweaving/common_widgets/show_error_snackbar.dart';
import 'package:trackweaving/models/machine_group_response_model.dart';
import 'package:trackweaving/models/machine_list_response_model.dart';
import 'package:trackweaving/models/report_response.dart';
import 'package:trackweaving/models/shift_types_model.dart';
import 'package:get/get.dart';
import 'package:trackweaving/repository/api_exception.dart';
import 'package:trackweaving/repository/report_repository.dart';
import 'package:trackweaving/utils/app_const.dart';
import 'package:trackweaving/utils/date_formate_extension.dart';

class ReportController extends GetxController implements GetxService {
  ReportRepository repository = Get.find<ReportRepository>();
  RxBool selectAllMachines = false.obs;

  RxBool isGroupVisible = false.obs;

  RxList<Machine> selectedMachineList = RxList();
  RxList<Machine> availableMachineList = RxList();
  RxList<Machine> checkboxMachineList = RxList();

  RxList<MachineGroup> availableMachineGroupList = RxList();
  RxString selectedMachineGroupId = 'select'.obs;

  List<ShiftTypesModel> shiftTypeList = [
    ShiftTypesModel(type: 'all', title: 'all_shift'),
    ShiftTypesModel(type: 'day', title: 'day_shift'),
    ShiftTypesModel(type: 'night', title: 'night_shift'),
  ];

  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().obs;

  Rx<ShiftTypesModel> selectedShift = ShiftTypesModel(
    type: 'all',
    title: 'All Shift',
  ).obs;

  RxBool isLoading = false.obs;

  changeShiftType(ShiftTypesModel? model) {
    selectedShift.value = model ?? shiftTypeList.first;
  }

  changeGroupVisible() {
    isGroupVisible.value = isGroupVisible.value ? false : true;
  }

  setAvailableMachines(List<Machine> machines) {
    availableMachineList.value = machines;
    checkboxMachineList.value = machines;
  }

  clearSelection() {
    selectedMachineList.clear();
    selectAllMachines.value = false;
    checkboxMachineList.clear();
    isGroupVisible.value = false;
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
    selectedShift.value = shiftTypeList.first;
  }

  filerMachineByGroup(String groupId) {
    checkboxMachineList.value = [];
    List<Machine> filterList = [];
    selectedMachineGroupId.value = groupId;
    if (groupId == 'select') {
      checkboxMachineList.value = List.from(availableMachineList);
    } else {
      for (var machine in availableMachineList) {
        if (machine.machineGroupId?.id == groupId) {
          filterList.add(machine);
        }
      }
      checkboxMachineList.value = filterList;
    }
  }

  setAvailableMachinesGroups(List<MachineGroup> list) {
    availableMachineGroupList.value = list;
  }

  onSelectAllChanged(bool? value, {String? groupId}) {
    selectAllMachines.value = value ?? false;
    if (selectAllMachines.value) {
      List<Machine> filterList = [];
      if (groupId != 'select' && groupId != 'all') {
        // if groupId is provided, filter by group
        for (var machine in availableMachineList) {
          if (machine.machineGroupId?.id == groupId) {
            filterList.add(machine);
          }
        }
        selectedMachineList.value = List.from(filterList);
        selectedMachineList.refresh();
      } else {
        // select all machines
        selectedMachineList.value = List.from(availableMachineList);
        selectedMachineList.refresh();
      }
    } else {
      selectedMachineList.clear();
    }
  }

  onMachineSelect(Machine machine, bool? value) {
    if (value == true) {
      selectedMachineList.add(machine);
    } else {
      selectedMachineList.remove(machine);
      selectAllMachines.value = false;
    }
  }

  //function to get report data
  Future<ReportsResponse?> getReportData() async {
    List<String> machineIds = [];
    List<int> shift = [];
    if (selectedShift.value.type == 'all') {
      shift = [AppConst.dayShift, AppConst.nightShift];
    } else if (selectedShift.value.type == 'day') {
      shift = [AppConst.dayShift];
    } else if (selectedShift.value.type == 'night') {
      shift = [AppConst.nightShift];
    }

    for (var machine in selectedMachineList) {
      machineIds.add(machine.id);
    }

    //validation
    if (machineIds.isEmpty) {
      log('Please select at least one machine');
      showErrorSnackbar('Please Select Machine *');
      return null;
    }

    if (startDate.value.isAfter(endDate.value)) {
      log('Start date cannot be after end date');
      return null;
    }

    try {
      isLoading.value = true;

      var data = await repository.getReportData(
        machineIds,
        startDate.value.yyyymmddFormat,
        endDate.value.yyyymmddFormat,
        shift,
        'productionShiftWise',
      );
      return data;
    } on ApiException catch (e) {
      log('Error in getReportData: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
