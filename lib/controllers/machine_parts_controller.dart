import 'package:get/get.dart';

class MachinePartsController extends GetxController implements GetxService {
  final _machineParts = <String>[].obs;

  RxBool isLoading = false.obs;

  List<String> get machineParts => _machineParts;

  final RxList<String> availableParts = <String>[].obs;

  final RxString selectedPart = RxString(''); // Holds the single selected part

  Rx<DateTime> selectedCompleteDate = Rx<DateTime>(DateTime.now());

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
      // Optional: You might want to persist this new part to your backend here
    }
  }
}
