import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/show_success_snackbar.dart';
import 'package:trackweaving/models/machine_group_response_model.dart';
import 'package:trackweaving/models/machine_list_response_model.dart';
import 'package:trackweaving/repository/api_exception.dart';
import 'package:trackweaving/repository/machine_repository.dart';
import 'package:trackweaving/screens/auth_screens/login_screen.dart';
import 'package:trackweaving/utils/shared_pref.dart';
import 'package:get/get.dart';

class MachineController extends GetxController implements GetxService {
  final Sharedprefs sp;
  final MachineRepository repository;

  MachineController({required this.sp, required this.repository});

  RxBool isLoading = false.obs;

  RxList<MachineGroup> machineGroupList = RxList();

  RxList<Machine> machineList = RxList();

  String selectedMachineId = '';

  TextEditingController machineNameController = TextEditingController();
  TextEditingController machineCodeController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController maxLimitController = TextEditingController();

  RxBool machineAlert = false.obs;
  Rx<MachineGroup?> selectedMachineGrpId = Rx(null);

  changeMachineAlert() {
    if (machineAlert.value) {
      machineAlert.value = false;
    } else {
      machineAlert.value = true;
    }
  }

  setFields({
    String name = '',
    String code = '',
    bool alert = false,
    String? grpId,
    int maxLimit = 0,
  }) {
    machineCodeController.text = code;
    machineNameController.text = name;
    machineAlert.value = alert;
    maxLimitController.text = maxLimit == 0 ? '' : maxLimit.toString();
    if (grpId != null) {
      selectedMachineGrpId.value = getGroupFromID(grpId);
    } else {
      selectedMachineGrpId.value = machineGroupList.isNotEmpty
          ? machineGroupList[0]
          : null;
    }
  }

  disposeControllers() {
    machineCodeController.dispose();
    machineNameController.dispose();
    maxLimitController.dispose();
  }

  setSelectedMachineId(String id) {
    selectedMachineId = id;
  }

  //get list machine groups
  getList() async {
    try {
      isLoading.value = true;

      var data = await repository.getMachineGroupList();
      machineGroupList.value = data;
    } on ApiException catch (e) {
      log('error : $e');
      //showErrorSnackbar('Error Creating Group Name: ${e.message}');
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }

  //update device name
  Future<void> updateMachineGroup(String name) async {
    try {
      isLoading.value = true;

      await repository.createUpdateMachineGroup(
        name: name,
        id: selectedMachineId,
        isUpdate: true,
      );
      getList();
    } on ApiException catch (e) {
      //showErrorSnackbar('Error Updating Group Name: ${e.message}');
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createMachineGroup(String name) async {
    try {
      isLoading.value = true;

      await repository.createUpdateMachineGroup(name: name);
      getList();
    } on ApiException catch (e) {
      log('error : $e');
      //showErrorSnackbar('Error Creating Group Name: ${e.message}');
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }

  MachineGroup? getGroupFromID(String gID) {
    MachineGroup? machineGroup = machineGroupList.firstWhereOrNull(
      (element) => element.id == gID,
    );
    return machineGroup;
  }

  ////get Machine list for machine configuration module
  Future<void> getMachineList() async {
    try {
      isLoading.value = true;

      var dataGroupList = await repository.getMachineGroupList();
      machineGroupList.value = dataGroupList;

      var data = await repository.getMachineList();

      machineList.value = data;
    } on ApiException catch (e) {
      log('error : $e');
      //showErrorSnackbar('Error - Machine List Load');
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }

  //api to update machine configurations;
  updateMachineConfig(String id) async {
    try {
      isLoading.value = true;

      var data = await repository.updateMachineConfiguration(
        id: id,
        machineCode: machineCodeController.text.trim(),
        machineName: machineNameController.text.trim(),
        machineMaxLimit: maxLimitController.text.trim(),
        machineGroupId: selectedMachineGrpId.value?.id ?? '',
        isAlertActive: machineAlert.value,
      );

      log('onUpdateMAchinConfig ::: $data');
      Get.back();
      getMachineList();
      showSuccessSnackbar('Machine Configuration Updated');
    } on ApiException catch (e) {
      log('error:onUpdateMAchinConfig : $e');
      //showErrorSnackbar('Error - Something Went Wrong.');
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }

  updateMachineConfigAlert(String id, bool isOn) async {
    try {
      isLoading.value = true;

      var data = await repository.updateMachineConfigurationAlert(
        id: id,
        isAlertActive: isOn,
      );

      log('onUpdateMAchinConfig ::: $data');

      showSuccessSnackbar('Machine Alert Set ${isOn ? 'ON' : 'OFF'}');
      getMachineList();
    } on ApiException catch (e) {
      log('error:onUpdateMAchinConfig : $e');
      //showErrorSnackbar('Error - Something Went Wrong.');
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }
}
