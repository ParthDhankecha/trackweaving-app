import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';

class ProductionReportPage extends StatefulWidget {
  const ProductionReportPage({super.key});

  @override
  State<ProductionReportPage> createState() => _ProductionReportPageState();
}

class _ProductionReportPageState extends State<ProductionReportPage> {
  // State variables for form fields
  String _selectedReportType = 'Production Shiftwise Report';
  String _selectedShift = 'All Shift';
  DateTime _fromDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool _groupWiseMachine = false;
  bool _selectAllMachines = false;
  List<String> _selectedMachines = [];
  final List<String> _availableMachines = ['M1', 'M2', 'M3', 'M4'];

  // Reusable widget for a title with a dropdown
  Widget _buildDropdownField(
    String title,
    String selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        DropdownButtonFormField<String>(
          initialValue: selectedValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Reusable widget for a date picker field
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        TextFormField(
          readOnly: true,
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
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.grey),
              onPressed: () async {
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
            ),
          ),
        ),
      ],
    );
  }

  // Reusable widget for a checkbox and text in a row
  Widget _buildCheckboxRow(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,

          activeColor: AppColors.mainColor,
        ),
        Text(title),
      ],
    );
  }

  // Function to handle "Select All" checkbox logic
  void _onSelectAllChanged(bool? value) {
    setState(() {
      _selectAllMachines = value ?? false;
      if (_selectAllMachines) {
        _selectedMachines = List.from(_availableMachines);
      } else {
        _selectedMachines.clear();
      }
    });
  }

  // Function to handle individual machine checkbox logic
  void _onMachineChanged(String machine, bool? value) {
    setState(() {
      if (value == true) {
        _selectedMachines.add(machine);
      } else {
        _selectedMachines.remove(machine);
        _selectAllMachines = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDropdownField(
                  'Report Type',
                  _selectedReportType,
                  ['Production Shiftwise Report'],
                  (newValue) {
                    setState(() {
                      _selectedReportType = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField('From Date', _fromDate, (newDate) {
                        setState(() {
                          _fromDate = newDate;
                          _endDate = newDate;
                        });
                      }),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildDateField('End Date', _endDate, (newDate) {
                        setState(() {
                          _endDate = newDate;
                        });
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                _buildDropdownField(
                  'Shift',
                  _selectedShift,
                  ['All Shift', 'Day Shift', 'Night Shift'],
                  (newValue) {
                    setState(() {
                      _selectedShift = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                      child: Text(
                        'Machine:',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    _buildCheckboxRow('Group Wise Machine', _groupWiseMachine, (
                      value,
                    ) {
                      setState(() {
                        _groupWiseMachine = value!;
                      });
                    }),
                  ],
                ),

                _buildCheckboxRow(
                  'Select All',
                  _selectAllMachines,
                  _onSelectAllChanged,
                ),
                Wrap(
                  //spacing: 8.0,
                  //unSpacing: 4.0,
                  direction: Axis.horizontal,
                  children: _availableMachines.map((machine) {
                    return _buildCheckboxRow(
                      machine,
                      _selectedMachines.contains(machine),
                      (value) {
                        _onMachineChanged(machine, value);
                      },
                    );
                  }).toList(),
                ),

                ElevatedButton(
                  onPressed: () {
                    // Logic to show the report
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Showing Report...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Show Report',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
