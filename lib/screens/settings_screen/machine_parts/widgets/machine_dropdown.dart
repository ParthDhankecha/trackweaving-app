import 'package:flutter/material.dart';
import 'package:trackweaving/models/machine_list_response_model.dart';

class MachineDropdown extends StatelessWidget {
  final String title;
  final Machine? selectedValue;
  final List<Machine> items;
  final ValueChanged<Machine?> onChanged;
  const MachineDropdown({
    super.key,
    required this.title,
    this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Machine machine = Machine(
      machineGroupId: null,
      id: 'all',
      serialNumber: 'all',
      machineCode: 'Select',
      machineName: 'Select',
      ip: '',
      isAlertActive: true,
    );
    var dropdownItems = [machine, ...items];

    var initialValue = selectedValue ?? dropdownItems.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        DropdownButtonFormField<Machine>(
          initialValue: initialValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: dropdownItems.map((Machine value) {
            return DropdownMenuItem<Machine>(
              value: value,
              child: Text(value.machineCode),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
