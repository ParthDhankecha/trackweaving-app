import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserTypeDropdown extends StatelessWidget {
  final String title;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const UserTypeDropdown({
    super.key,
    required this.title,
    this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var dropdownItems = items;

    var initialValue = selectedValue ?? dropdownItems.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        DropdownButtonFormField<String>(
          initialValue: initialValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: dropdownItems.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value.tr),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
