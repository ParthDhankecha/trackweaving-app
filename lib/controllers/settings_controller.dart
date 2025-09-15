import 'dart:developer';

import 'package:flutter_texmunimx/common_widgets/show_error_snackbar.dart';
import 'package:flutter_texmunimx/models/machine_group_response_model.dart';
import 'package:flutter_texmunimx/models/machine_list_response_model.dart';
import 'package:flutter_texmunimx/repository/api_exception.dart';
import 'package:flutter_texmunimx/repository/settings_repository.dart';
import 'package:flutter_texmunimx/screens/auth_screens/login_screen.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController implements GetxService {
  final Sharedprefs sp;
  final SettingsRepository repository;

  SettingsController({required this.sp, required this.repository});

  RxBool isLoading = false.obs;

  RxList<MachineGroup> machineGroupList = RxList();

  RxList<Machine> machineList = RxList();

  String selectedMachineId = '';

  setSelectedMachineId(String id) {
    selectedMachineId = id;
  }

  //get list
  getList() async {
    try {
      isLoading.value = true;

      var data = await repository.getMachineGroupList();
      machineGroupList.value = data;
      print('on create ::: $data');
    } on ApiException catch (e) {
      log('error : $e');
      showErrorSnackbar('Error Creating Group Name: ${e.message}');
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

      var data = await repository.createUpdateMachineGroup(
        name: name,
        id: selectedMachineId,
        isUpdate: true,
      );
      print('on Update ::: $data');
      getList();
    } on ApiException catch (e) {
      showErrorSnackbar('Error Updating Group Name: ${e.message}');
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

      var data = await repository.createUpdateMachineGroup(name: name);
      print('on create ::: $data');
      getList();
    } on ApiException catch (e) {
      log('error : $e');
      showErrorSnackbar('Error Creating Group Name: ${e.message}');
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

  ////get Machine list for machine configuration module
  getMachineList() async {
    try {
      isLoading.value = true;

      var data = await repository.getMachineList();
      machineList.value = data;
      print('on machine list load ::: $data');
    } on ApiException catch (e) {
      log('error : $e');
      showErrorSnackbar('Error machine list load: ${e.message}');
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
