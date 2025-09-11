import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/screens/settings_screen/widgets/machine_configuration_card.dart';
import 'package:get/get.dart';

class MachineConfigurationScreen extends StatefulWidget {
  const MachineConfigurationScreen({super.key});

  @override
  State<MachineConfigurationScreen> createState() =>
      _MachineConfigurationScreenState();
}

class _MachineConfigurationScreenState
    extends State<MachineConfigurationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('machine_configure'.tr)),
      body: Column(
        children: [
          //machine configuration card
          Column(
            children: [
              MachineConfigurationCard(
                srNo: '1',
                machineCode: 'M1',
                machineName: 'M1',
                machineGroup: 'Jacquard',
                udid: 'ASJQ_10711',
                alertEnabled: true,
                efficiencyLimit: '90',
                onAlertChange: (isOn) {},
              ),
              MachineConfigurationCard(
                srNo: '1',
                machineCode: 'M1',
                machineName: 'M1',
                machineGroup: 'Jacquard',
                udid: 'ASJQ_10711',
                alertEnabled: false,
                efficiencyLimit: '90',
                onAlertChange: (isOn) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
