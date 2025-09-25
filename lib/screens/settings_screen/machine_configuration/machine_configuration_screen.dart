import 'package:flutter/material.dart';
import 'package:trackweaving/controllers/machine_controller.dart';
import 'package:trackweaving/models/machine_list_response_model.dart';
import 'package:trackweaving/screens/settings_screen/machine_configuration/edit_machine_configuration.dart';
import 'package:trackweaving/screens/settings_screen/machine_configuration/machine_configuration_card.dart';
import 'package:get/get.dart';

class MachineConfigurationScreen extends StatefulWidget {
  const MachineConfigurationScreen({super.key});

  @override
  State<MachineConfigurationScreen> createState() =>
      _MachineConfigurationScreenState();
}

class _MachineConfigurationScreenState
    extends State<MachineConfigurationScreen> {
  MachineController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.getMachineList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('machine_configure'.tr)),
      body: Column(
        children: [
          //machine configuration card
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.machineList.length,
                itemBuilder: (context, index) {
                  Machine machine = controller.machineList[index];
                  return MachineConfigurationCard(
                    srNo: '#${machine.serialNumber}',
                    machineCode: machine.machineCode,
                    machineName: machine.machineName,
                    machineGroup:
                        controller
                            .getGroupFromID(machine.machineGroupId?.id ?? '')
                            ?.groupName ??
                        '',
                    udid: machine.ip,
                    alertEnabled: machine.isAlertActive,
                    onAlertChange: (isOn) {
                      controller.changeMachineAlert();
                      controller.updateMachineConfigAlert(machine.id);
                    },
                    onTap: () => Get.to(
                      () => EditMachineConfiguration(machine: machine),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
