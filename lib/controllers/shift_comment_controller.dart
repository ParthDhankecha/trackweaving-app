import 'dart:developer';

import 'package:trackweaving/common_widgets/show_error_snackbar.dart';
import 'package:trackweaving/models/machine_list_response_model.dart';
import 'package:trackweaving/models/shift_coment_update_model.dart';
import 'package:trackweaving/models/shift_comment_list_response.dart';
import 'package:trackweaving/models/shift_comment_model.dart';
import 'package:trackweaving/models/shift_machine_model.dart';
import 'package:trackweaving/models/shift_types_model.dart';
import 'package:trackweaving/repository/api_exception.dart';
import 'package:trackweaving/repository/shift_comment_repository.dart';
import 'package:trackweaving/screens/auth_screens/login_screen.dart';
import 'package:trackweaving/screens/settings_screen/shift_comments/comment_show_report_screen.dart';
import 'package:trackweaving/utils/app_const.dart';
import 'package:trackweaving/utils/date_formate_extension.dart';
import 'package:get/get.dart';

class ShiftCommentController extends GetxController implements GetxService {
  final ShiftCommentRepository repository;
  RxBool loading = false.obs;

  RxList<ShiftMachineModel> machineCodes = <ShiftMachineModel>[].obs;

  //for shift comments
  RxList<ShiftComment> availableComments = RxList<ShiftComment>();

  RxString selectedShift = 'all'.obs; //day and night
  Rx<DateTime> selectedDate = Rx(DateTime.now());

  List<ShiftTypesModel> shiftTypes = [
    ShiftTypesModel(type: 'all', title: 'All'),
    ShiftTypesModel(type: 'day', title: 'Day Shift'),
    ShiftTypesModel(type: 'night', title: 'Night Shift'),
  ];

  RxList<ShiftCommentModel> shiftCommentList = RxList();

  List<CommentUpdateModel> commentUpdateList = [];

  Rx<Machine?> selectedMachine = Rx<Machine?>(null);
  set selectedMachineValue(Machine? machine) {
    selectedMachine.value = machine;
  }

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

  String getComment(String machineId, String date, String type) {
    String commentFound = '';

    for (var element in availableComments) {
      print(
        '${element.machineId} - ${element.date.ddmmyyFormat} - ${element.shift} - ${element.comment}',
      );
    }

    ShiftComment? comment = availableComments.firstWhereOrNull(
      (element) =>
          element.date.ddmmyyFormat == date &&
          element.machineId == machineId &&
          element.shift == type,
    );

    if (comment != null) {
      log('Found @@@@@ ${comment.comment}');
      commentFound = comment.comment;
    }

    return commentFound;
  }

  //function to get all comments
  Future<void> getComments() async {
    try {
      loading.value = true;
      if (availableComments.isNotEmpty) {
        availableComments.value = [];
      }
      var list = await repository.getComments(
        date: selectedDate.value,
        shift: selectedShift.value,
        machineId: machineCodes.length == 1
            ? machineCodes.first.machineId
            : null,
      );
      availableComments.value = list.data.list;
    } on ApiException catch (e) {
      AppConst.showLog(logText: '$e', tag: 'getComments');
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

  clearMachineSelection() {
    machineCodes.value = [];
    selectedMachine.value = null;
    log('Cleared Machine Selection');
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

  generateRecords() async {
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
    await getComments();
    Get.to(() => CommentShowReportScreen());
  }

  generateRecordsForSelectedMachine() async {
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

    await getComments();
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
