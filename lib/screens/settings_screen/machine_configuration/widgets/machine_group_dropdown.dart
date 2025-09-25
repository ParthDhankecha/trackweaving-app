import 'package:flutter/material.dart';
import 'package:trackweaving/models/machine_group_response_model.dart';

class MachineGroupDropdown extends StatelessWidget {
  final String title;
  final MachineGroup? selectedValue;
  final List<MachineGroup> items;
  final ValueChanged<MachineGroup?> onChanged;
  const MachineGroupDropdown({
    super.key,
    required this.title,
    this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    MachineGroup machine = MachineGroup(
      id: 'all',
      groupName: 'Select',
      workspaceId: '',
      createdBy: '',
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
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
        DropdownButtonFormField<MachineGroup>(
          initialValue: initialValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: dropdownItems.map((MachineGroup value) {
            return DropdownMenuItem<MachineGroup>(
              value: value,
              child: Text(value.groupName),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
