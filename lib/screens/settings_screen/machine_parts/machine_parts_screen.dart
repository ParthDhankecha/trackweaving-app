import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/custom_appbar.dart';
import 'package:trackweaving/controllers/machine_parts_controller.dart';
import 'package:get/get.dart';
import 'package:trackweaving/screens/settings_screen/machine_parts/create_part_change.dart';
import 'package:trackweaving/screens/settings_screen/machine_parts/widgets/machine_parts_list_item.dart';
import 'package:trackweaving/screens/settings_screen/machine_parts/widgets/machine_search_dropdown.dart';
import 'package:trackweaving/utils/app_colors.dart';

class MachinePartsScreen extends StatefulWidget {
  const MachinePartsScreen({super.key});

  @override
  State<MachinePartsScreen> createState() => _MachinePartsScreenState();
}

class _MachinePartsScreenState extends State<MachinePartsScreen> {
  MachinePartsController controller = Get.find();

  // 1. Create a ScrollController
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Initialize the scroll controller
    _scrollController = ScrollController();

    // Add listener to check for scroll position
    _scrollController.addListener(_onScroll);

    // Initial data loading (kept from your original code, though onInit in controller is often cleaner)
    controller.getPartsList();
    controller.getMachineList();
    controller.getChangeLogList(isRefresh: true);
  }

  @override
  void dispose() {
    // 2. Dispose the controller to prevent memory leaks
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    controller.updateSelectedMachines([]);
    super.dispose();
  }

  // 3. Define the scroll listener logic
  void _onScroll() {
    // Check if the scroll is near the bottom (e.g., within 200 pixels)
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Check if there are more pages AND not currently fetching another page
      if (controller.hasNextPage.value && !controller.isPaginating.value) {
        // Trigger the next page load
        controller.getChangeLogList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      appBar: CustomAppbar(title: 'machine_parts'.tr),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        onPressed: () {
          controller.clearSelections();
          Get.to(() => MachinePartsUpdate());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // 4. Use a single main ListView for the entire body content
      body: Obx(() {
        // Show the main loading indicator while initial data is fetched
        if (controller.isLoading.value && controller.partChangeLogs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          controller: _scrollController, // Attach the scroll controller
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 80,
          ), // Add padding for FAB
          children: [
            // Machine Group Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // Note: Removed redundant Obx and Center here since
                  // the main body Obx handles the initial loading screen.
                  Expanded(
                    child: MachineSearchDropdown(
                      title: 'select_machines'.tr,
                      selectedValues: controller.selectedMachines,
                      items: controller.availableMachines,
                      onChanged: (value) {
                        controller.updateSelectedMachines(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // List of machine parts
            if (controller.partChangeLogs.isEmpty)
              // Show 'No Data' message if list is empty after loading
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text('No Change Logs Found'),
                ),
              )
            else
              // Use Column or List.generate to build items inside the main ListView
              ...List.generate(controller.partChangeLogs.length, (index) {
                final partLog = controller.partChangeLogs[index];
                return MachinePartsListItem(
                  partChangeLog: partLog,
                  onTap: () {
                    Get.to(
                      () => MachinePartsUpdate(
                        partChangeLog: partLog,
                        index: index,
                      ),
                    );
                  },
                );
              }),

            // Pagination Loader (only visible when fetching next page)
            if (controller.isPaginating.value)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),

            // End of list message
            if (!controller.hasNextPage.value &&
                controller.partChangeLogs.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('You have reached the end of the list.'),
                ),
              ),
          ],
        );
      }),
    );
  }
}
