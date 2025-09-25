import 'package:flutter/material.dart';
import 'package:trackweaving/models/shift_types_model.dart';
import 'package:get/get.dart';

class ShiftDropdown extends StatelessWidget {
  final String title;
  final ShiftTypesModel? selectedValue;
  final List<ShiftTypesModel> items;
  final ValueChanged<ShiftTypesModel?> onChanged;
  const ShiftDropdown({
    super.key,
    required this.title,
    this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ShiftTypesModel initialValue = selectedValue ?? items.first;

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
        DropdownButtonFormField<ShiftTypesModel>(
          initialValue: initialValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: items.map((ShiftTypesModel value) {
            return DropdownMenuItem<ShiftTypesModel>(
              value: value,
              child: Text(value.title.tr),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
