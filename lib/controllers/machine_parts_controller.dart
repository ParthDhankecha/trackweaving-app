import 'dart:developer';

import 'package:get/get.dart';
import 'package:trackweaving/common_widgets/show_success_snackbar.dart';
import 'package:trackweaving/models/machine_list_response_model.dart';
import 'package:trackweaving/models/part_changelog_list_response.dart';
import 'package:trackweaving/repository/api_exception.dart';
import 'package:trackweaving/repository/machine_parts_repo.dart';
import 'package:trackweaving/repository/machine_repository.dart';
import 'package:trackweaving/screens/auth_screens/login_screen.dart';

class MachinePartsController extends GetxController implements GetxService {
  MachinePartsRepo repo = Get.find<MachinePartsRepo>();
  MachineRepository machineRepository = Get.find<MachineRepository>();

  final _machineParts = <String>[].obs;

  RxBool isLoading = false.obs;
  // Pagination State
  RxInt currentPage = 1.obs; // Start at page 1
  RxBool hasNextPage = true.obs; // Flag to stop loading when no more data
  RxBool isPaginating =
      false.obs; // Flag for loading footer (when fetching next page)

  List<String> get machineParts => _machineParts;

  final RxList<String> availableParts = <String>[].obs;

  final RxString selectedPart = RxString(
    'Select Part',
  ); // Holds the single selected part
  final RxString selecteMachine = RxString(''); // Holds the selected machine

  Rx<DateTime> selectedCompleteDate = Rx<DateTime>(DateTime.now());

  RxList<Machine> availableMachines = <Machine>[].obs;

  RxList<Machine> selectedMachines = <Machine>[].obs;

  RxList<PartChangeLog> partChangeLogs = <PartChangeLog>[].obs;

  void clearSelections() {
    selectedPart.value = '';
    selecteMachine.value = '';
    selectedCompleteDate.value = DateTime.now();
    selectedMachines.clear();
  }

  void updateSelectedMachines(List<Machine> machines) {
    selectedMachines.value = machines;
    getChangeLogList(isRefresh: true);
  }

  void changeCompleteDate(DateTime date) {
    selectedCompleteDate.value = date;
  }

  void addMachinePart(String part) {
    _machineParts.add(part);
  }

  void removeMachinePart(String part) {
    _machineParts.remove(part);
  }

  void clearMachineParts() {
    _machineParts.clear();
  }

  /// Handles single selection change
  void onPartSelectionChanged(String? newSelection) {
    selectedPart.value = newSelection ?? '';
  }

  /// Handles adding a brand new part to the list
  void addNewPart(String newPartName) {
    if (!availableParts.contains(newPartName)) {
      availableParts.add(newPartName);
      selectedPart.value = newPartName; // Select the newly added part
    }
  }

  void selectMachine(String? newSelection) {
    selecteMachine.value = newSelection ?? '';
  }

  Future<void> getMachineList() async {
    try {
      isLoading.value = true;

      var machineList = await machineRepository.getMachineList();
      availableMachines.value = machineList;
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

  getPartsList() async {
    try {
      isLoading(true);
      List<String> parts = await repo.fetchPartsList();
      availableParts.value = parts;
    } on ApiException catch (e) {
      log('Error: ${e.message}', name: 'MachinePartsController');
      if (e.statusCode == 401) {
        // Handle unauthorized error, e.g., redirect to login
        Get.offAll(() => LoginScreen());
      }
    } finally {
      isLoading(false);
    }
  }

  // get machine change log list
  // getChangeLogList({bool isRefresh = false}) async {
  //   try {
  //     isLoading.value = true;

  //     if (isRefresh) {
  //       hasNextPage.value = true;
  //       partChangeLogs.clear();
  //     }

  //     var data = await repo.getchangeLogs(
  //       selectedMachines.map((e) => e.id).toList(),
  //       (partChangeLogs.length ~/ 10) + 1,
  //     );

  //     log('onUpdateMAchinConfig ::: $data');
  //     partChangeLogs.addAll(data);
  //   } on ApiException catch (e) {
  //     log('error:onUpdateMAchinConfig : $e');
  //     //showErrorSnackbar('Error - Something Went Wrong.');
  //     switch (e.statusCode) {
  //       case 401:
  //         Get.offAll(() => LoginScreen());
  //         break;
  //       default:
  //     }
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // get machine change log list
  Future<void> getChangeLogList({bool isRefresh = false}) async {
    // 1. Check if we should stop loading (i.e., no next page and not a refresh)
    if (!hasNextPage.value && !isRefresh) {
      log('No more pages to load.', name: 'MachinePartsController');
      return;
    }

    // Determine the loading state flag
    if (isRefresh) {
      isLoading.value = true; // Use primary loader for initial/refresh
      currentPage.value = 1;
      partChangeLogs.clear();
      hasNextPage.value = true;
    } else {
      isPaginating.value = true; // Use secondary loader for subsequent pages
      currentPage.value++;
    }

    try {
      // API call using the current page number
      var data = await repo.getchangeLogs(
        selectedMachines.map((e) => e.id).toList(),
        currentPage.value, // Pass the page number
      );

      log('Loaded page ${currentPage.value} with ${data.length} records.');

      // 3. Process the results
      if (data.isEmpty) {
        hasNextPage.value = false; // Stop further calls
        // Decrement page if nothing was loaded to stay on the last valid page
        if (!isRefresh) currentPage.value--;
      } else {
        partChangeLogs.addAll(data);
      }
    } on ApiException catch (e) {
      log('error:onUpdateMAchinConfig : $e');
      if (!isRefresh) currentPage.value--; // Revert page on failure
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      // Turn off the appropriate loader
      if (isRefresh) {
        isLoading.value = false;
      } else {
        isPaginating.value = false;
      }
    }
  }

  // create machine part change log
  createChangeLog({
    String? id,
    required String name,
    String? phone,
    String? notes,
    bool isUpdate = false,
    int index = -1,
  }) async {
    try {
      isLoading.value = true;

      if (isUpdate) {
        var partChangeLog = await repo.updatePartChangeLog(
          id: id ?? '',
          machineId: selecteMachine.value,
          partName: selectedPart.value,
          name: name,
          changeDate: selectedCompleteDate.value,
          notes: notes,
          phone: phone,
        );

        partChangeLogs[index] = partChangeLog;
        Get.back();
        showSuccessSnackbar('Part Change Log Updated Successfully');
        clearSelections();
      } else {
        var data = await repo.createPartChangeLog(
          machineId: selecteMachine.value,
          partName: selectedPart.value,
          name: name,
          changeDate: selectedCompleteDate.value,
          phone: phone,
          notes: notes,
        );

        //log('onUpdateMAchinConfig ::: $data');
        if (data) {
          Get.back();
          showSuccessSnackbar('Part Change Log Created Successfully');
          getChangeLogList(isRefresh: true);
          clearSelections();
        }
      }
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
