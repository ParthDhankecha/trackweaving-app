import 'dart:developer';

import 'package:flutter_texmunimx/common_widgets/show_error_snackbar.dart';
import 'package:flutter_texmunimx/repository/api_exception.dart';
import 'package:flutter_texmunimx/repository/settings_repository.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController implements GetxService {
  final Sharedprefs sp;
  final SettingsRepository repository;

  SettingsController({required this.sp, required this.repository});

  RxBool isLoading = false.obs;
  //update device name
  Future<void> createMachineGroup(String name) async {
    try {
      isLoading.value = true;

      var data = await repository.createUpdateMachineGroup(name: name);
      print('on create ::: $data');
    } on ApiException catch (e) {
      log('error : $e');
      showErrorSnackbar('Error Creating Group Name');
    } finally {
      isLoading.value = false;
    }
  }
}
