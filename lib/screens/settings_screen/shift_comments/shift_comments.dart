import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/controllers/machine_controller.dart';
import 'package:flutter_texmunimx/screens/settings_screen/shift_comments/widgets/machine_dropdown.dart';
import 'package:get/get.dart';

class ShiftComments extends StatefulWidget {
  const ShiftComments({super.key});

  @override
  State<ShiftComments> createState() => _ShiftCommentsState();
}

class _ShiftCommentsState extends State<ShiftComments> {
  MachineController machineController = Get.find();
  @override
  void initState() {
    super.initState();
    machineController.getMachineList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('shift_wise_comment_update'.tr)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: MachineDropdown(
              title: 'Select Machine',
              items: machineController.machineList,
              onChanged: (value) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),

            child: _buildDateField('Report Date', DateTime.now(), (value) {}),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    String title,
    DateTime selectedDate,
    ValueChanged<DateTime> onDateSelected,
  ) {
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
        TextFormField(
          readOnly: true,
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null && pickedDate != selectedDate) {
              onDateSelected(pickedDate);
            }
          },
          controller: TextEditingController(
            text:
                '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
          ),
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            suffixIcon: const Icon(Icons.calendar_month, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
