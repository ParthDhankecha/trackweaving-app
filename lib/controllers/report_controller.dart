import 'package:flutter_texmunimx/models/machine_group_response_model.dart';
import 'package:flutter_texmunimx/models/machine_list_response_model.dart';
import 'package:flutter_texmunimx/models/shift_types_model.dart';
import 'package:get/get.dart';

class ReportController extends GetxController implements GetxService {
  RxBool selectAllMachines = false.obs;

  RxBool isGroupVisible = false.obs;

  RxList<Machine> selectedMachineList = RxList();
  RxList<Machine> availableMachineList = RxList();
  RxList<Machine> checkboxMachineList = RxList();

  RxList<MachineGroup> availableMachineGroupList = RxList();

  List<ShiftTypesModel> shiftTypeList = [
    ShiftTypesModel(type: 'all', title: 'all_shift'),
    ShiftTypesModel(type: 'day', title: 'day_shift'),
    ShiftTypesModel(type: 'night', title: 'night_shift'),
  ];

  Rx<ShiftTypesModel> selectedShift = ShiftTypesModel(
    type: 'all',
    title: 'All Shift',
  ).obs;

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

  filerMachineByGroup(String groupId) {
    checkboxMachineList.value = [];
    List<Machine> filterList = [];
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

  onSelectAllChanged(bool? value) {
    selectAllMachines.value = value ?? false;
    if (selectAllMachines.value) {
      selectedMachineList.value = List.from(availableMachineList);
      selectedMachineList.refresh();
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
}
