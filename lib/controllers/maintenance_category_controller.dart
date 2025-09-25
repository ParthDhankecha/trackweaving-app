import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/show_error_snackbar.dart';
import 'package:trackweaving/common_widgets/show_success_snackbar.dart';
import 'package:trackweaving/models/maintenance_alert_reponse.dart';
import 'package:trackweaving/models/maintenance_category_list_model.dart';
import 'package:trackweaving/repository/api_exception.dart';
import 'package:trackweaving/repository/maintenance_repo.dart';
import 'package:trackweaving/screens/auth_screens/login_screen.dart';
import 'package:trackweaving/utils/date_formate_extension.dart';
import 'package:trackweaving/utils/shared_pref.dart';
import 'package:get/get.dart';

class MaintenanceCategoryController extends GetxController
    implements GetxService {
  final Sharedprefs sp;
  final MaintenanceRepo repo;

  MaintenanceCategoryController({required this.sp, required this.repo});

  RxList<MaintenanceCategory> maintenanceList = RxList();
  RxBool isLoading = false.obs;

  RxList<MaintenanceEntryModel> maintenanceEntryList = RxList();

  Rx<DateTime> selectedCompleteDate = Rx(DateTime.now());
  Rx<DateTime> selectedNextDate = Rx(DateTime.now());

  //
  TextEditingController completedName = TextEditingController();
  TextEditingController completedPhone = TextEditingController();
  TextEditingController remarkCont = TextEditingController();

  changeCompleteDate(DateTime newDate) {
    selectedCompleteDate.value = newDate;
  }

  changeNextDate(DateTime newdate) {
    selectedNextDate.value = newdate;
  }

  getMaintenanceCategoryList() async {
    try {
      isLoading.value = true;

      var list = await repo.getMaintenanceCategoryList();
      maintenanceList.value = list;
      log('getMaintenanceCategoryList ::: $list');
    } on ApiException catch (e) {
      log('error : $e');
      showErrorSnackbar('Error - Machine List Load');
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

  getMaintenanceEntryList() async {
    try {
      isLoading.value = true;

      var list = await repo.getMaintenanceAlert();
      maintenanceEntryList.value = list;
      log('getMaintenanceEntryList ::: $list');
    } on ApiException catch (e) {
      log('error : $e');
      showErrorSnackbar('Error - Maintenance List load');
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

  updateMaintenanceEntry({required String id}) async {
    try {
      isLoading.value = true;

      await repo.updateAlertEntry(
        id: id,
        lastMaintenanceDate: selectedCompleteDate.value.ddmmyyFormat,
        nextMaintenanceDate: selectedNextDate.value.ddmmyyFormat,
        completedBy: completedName.text.trim(),
        completedByMobile: completedPhone.text.trim(),
        remarks: remarkCont.text.trim(),
      );
      Get.back();
      showSuccessSnackbar('Entry Updated Successfully');

      getMaintenanceEntryList();
      completedName.text = '';
      completedPhone.text = '';
      remarkCont.text = '';
    } on ApiException catch (e) {
      log('error : $e');
      showErrorSnackbar('Error - Maintenance Entry List load');

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

  changeCategoryStatus(String id, bool status) async {
    try {
      isLoading.value = true;

      await repo.changeCategoryStatus(id: id, status: status);
      getMaintenanceCategoryList();
    } on ApiException catch (e) {
      log('error : $e');
      showErrorSnackbar('Error - Maintenance List load');
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
