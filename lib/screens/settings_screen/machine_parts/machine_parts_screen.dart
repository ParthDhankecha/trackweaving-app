import 'package:flutter/material.dart';
import 'package:trackweaving/controllers/machine_controller.dart';
import 'package:trackweaving/controllers/machine_parts_controller.dart';
import 'package:get/get.dart';
import 'package:trackweaving/screens/settings_screen/machine_parts/create_part_change.dart';
import 'package:trackweaving/screens/settings_screen/machine_parts/widgets/machine_search_dropdown.dart';
import 'package:trackweaving/utils/app_colors.dart';

class MachinePartsScreen extends StatefulWidget {
  const MachinePartsScreen({super.key});

  @override
  State<MachinePartsScreen> createState() => _MachinePartsScreenState();
}

class _MachinePartsScreenState extends State<MachinePartsScreen> {
  MachinePartsController controller = Get.find();

  MachineController machineController = Get.find();

  @override
  void initState() {
    super.initState();
    machineController.getMachineList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      appBar: AppBar(title: Text('machine_parts'.tr)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        onPressed: () {
          Get.to(() => MachinePartsUpdate());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          //machine group card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Obx(
                  () => machineController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: MachineSearchDropdown(
                            title: 'Select Machine Parts',
                            selectedValues: [],
                            items: machineController.machineList,
                            onChanged: (value) {},
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
