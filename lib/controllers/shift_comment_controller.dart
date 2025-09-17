import 'dart:developer';

import 'package:flutter_texmunimx/common_widgets/show_error_snackbar.dart';
import 'package:flutter_texmunimx/models/machine_list_response_model.dart';
import 'package:flutter_texmunimx/models/shift_coment_update_model.dart';
import 'package:flutter_texmunimx/models/shift_comment_model.dart';
import 'package:flutter_texmunimx/models/shift_machine_model.dart';
import 'package:flutter_texmunimx/models/shift_types_model.dart';
import 'package:flutter_texmunimx/repository/api_exception.dart';
import 'package:flutter_texmunimx/repository/shift_comment_repository.dart';
import 'package:flutter_texmunimx/screens/auth_screens/login_screen.dart';
import 'package:flutter_texmunimx/screens/settings_screen/shift_comments/comment_show_report_screen.dart';
import 'package:flutter_texmunimx/utils/date_formate_extension.dart';
import 'package:get/get.dart';

class ShiftCommentController extends GetxController implements GetxService {
  final ShiftCommentRepository repository;
  RxBool loading = false.obs;

  RxList<ShiftMachineModel> machineCodes = <ShiftMachineModel>[].obs;

  RxString selectedShift = 'all'.obs; //day and night
  Rx<DateTime> selectedDate = Rx(DateTime.now());

  List<ShiftTypesModel> shiftTypes = [
    ShiftTypesModel(type: 'all', title: 'All'),
    ShiftTypesModel(type: 'day', title: 'Day Shift'),
    ShiftTypesModel(type: 'night', title: 'Night Shift'),
  ];

  RxList<ShiftCommentModel> shiftCommentList = RxList();

  List<CommentUpdateModel> commentUpdateList = [];

  ShiftCommentController({required this.repository});

  addNewComment() {}

  selectAllMachine(List<Machine> machines) {
    List<ShiftMachineModel> machineIDs = [];
    for (var machine in machines) {
      machineIDs.add(
        ShiftMachineModel(
          machineId: machine.id,
          machineCode: machine.machineCode,
          machineName: machine.machineName,
        ),
      );
    }
    machineCodes.value = machineIDs;
    log('Selected Machine : ${machineCodes.length}');
  }

  selectMachine(Machine machine) {
    List<ShiftMachineModel> machineIDs = [];

    machineIDs.add(
      ShiftMachineModel(
        machineId: machine.id,
        machineCode: machine.machineCode,
        machineName: machine.machineName,
      ),
    );

    machineCodes.value = machineIDs;
    log('Selected Machine : ${machineCodes.length}');
  }

  selectShiftType(String type) {
    selectedShift.value = type;
  }

  generateRecords() {
    List<ShiftCommentModel> list = [];

    for (var machine in machineCodes) {
      ShiftCommentModel model;
      if (selectedShift.value == 'day') {
        model = ShiftCommentModel(
          id: '${selectedDate.value.ddmmyyFormat}_day',
          machineCode: machine.machineCode,
          machineId: machine.machineId,
          shiftTime: selectedDate.value.ddmmyyFormat,
          shiftType: 'day',
        );
      } else if (selectedShift.value == 'night') {
        model = ShiftCommentModel(
          id: '${selectedDate.value.ddmmyyFormat}_night',
          machineCode: machine.machineCode,
          machineId: machine.machineId,
          shiftTime: selectedDate.value.ddmmyyFormat,
          shiftType: 'night',
        );
      } else {
        model = ShiftCommentModel(
          id: '${selectedDate.value.ddmmyyFormat}_all',
          machineCode: machine.machineCode,
          machineId: machine.machineId,
          shiftTime: selectedDate.value.ddmmyyFormat,
          shiftType: 'all',
        );
      }
      list.add(model);
    }

    shiftCommentList.value = list;
    Get.to(() => CommentShowReportScreen());
  }

  generateRecordsForSelectedMachine() {
    // for all month
    List<ShiftCommentModel> list = [];
    List<DateTime> datesList = getDatesInMonth(
      selectedDate.value,
    ).reversed.toList();

    for (var dates in datesList) {
      for (var machine in machineCodes) {
        ShiftCommentModel model;
        if (selectedShift.value == 'day') {
          model = ShiftCommentModel(
            id: '${selectedDate.value.ddmmyyFormat}_day',
            machineCode: machine.machineCode,
            machineId: machine.machineId,
            shiftTime: dates.ddmmyyFormat,
            shiftType: 'day',
          );
        } else if (selectedShift.value == 'night') {
          model = ShiftCommentModel(
            id: '${selectedDate.value.ddmmyyFormat}_night',
            machineCode: machine.machineCode,
            machineId: machine.machineId,
            shiftTime: dates.ddmmyyFormat,
            shiftType: 'night',
          );
        } else {
          model = ShiftCommentModel(
            id: '${selectedDate.value.ddmmyyFormat}_all',
            machineCode: machine.machineCode,
            machineId: machine.machineId,
            shiftTime: dates.ddmmyyFormat,
            shiftType: 'all',
          );
        }

        list.add(model);
      }
    }
    shiftCommentList.value = list;
    Get.to(() => CommentShowReportScreen());
  }

  updateShiftComment(Map<String, List<Map<String, dynamic>>> value) async {
    try {
      loading.value = true;

      var list = await repository.updateComments(value);

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
      loading.value = false;
    }
  }
}
