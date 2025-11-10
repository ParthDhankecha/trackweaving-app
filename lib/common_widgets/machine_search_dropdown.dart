import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:trackweaving/models/machine_list_response_model.dart';

class MachineSearchDropdown extends StatefulWidget {
  final String title;
  final List<Machine> selectedValues;
  final List<Machine> items;
  final ValueChanged<List<Machine>> onChanged;

  const MachineSearchDropdown({
    super.key,
    required this.title,
    required this.selectedValues,
    required this.items,
    required this.onChanged,
  });

  @override
  State<MachineSearchDropdown> createState() => _MachineSearchDropdownState();
}

class _MachineSearchDropdownState extends State<MachineSearchDropdown> {
  // Utility method to display the selected machines nicely
  String _getDisplayString(List<Machine> selected) {
    if (selected.isEmpty) {
      return 'Select Machines';
    }
    if (selected.length == widget.items.length) {
      return 'All Machines Selected';
    }
    return selected.map((m) => m.machineCode).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        InkWell(
          onTap: () => _showMultiSelect(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _getDisplayString(widget.selectedValues),
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.selectedValues.isEmpty
                          ? Colors.black54
                          : Colors.black87,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMultiSelect(BuildContext context) async {
    final List<Machine> initialSelectedList = List.from(widget.selectedValues);

    final List<Machine>? result = await showModalBottomSheet<List<Machine>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        // Use a stateful builder for the internal state of the sheet
        return _MultiSelectSheet(
          items: widget.items,
          initialSelected: initialSelectedList,
          title: widget.title,
        );
      },
    );

    if (result != null) {
      widget.onChanged(result);
    }
  }
}

// Inner widget for the bottom sheet content
class _MultiSelectSheet extends StatefulWidget {
  final List<Machine> items;
  final List<Machine> initialSelected;
  final String title;

  const _MultiSelectSheet({
    required this.items,
    required this.initialSelected,
    required this.title,
  });

  @override
  _MultiSelectSheetState createState() => _MultiSelectSheetState();
}

class _MultiSelectSheetState extends State<_MultiSelectSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Machine> _filteredItems = [];
  late List<Machine> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = widget.initialSelected;
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where(
              (machine) =>
                  machine.machineName.toLowerCase().contains(query) ||
                  machine.machineCode.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  void _onToggleItem(Machine machine, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(machine);
      } else {
        _selectedItems.removeWhere((item) => item.id == machine.id);
      }
    });
  }

  void _selectAll() {
    setState(() {
      // Check if all current filtered items are already selected
      final allSelected = _filteredItems.every(
        (fItem) => _selectedItems.any((sItem) => sItem.id == fItem.id),
      );

      if (allSelected) {
        // Deselect all filtered items
        _selectedItems.removeWhere(
          (sItem) => _filteredItems.any((fItem) => fItem.id == sItem.id),
        );
      } else {
        // Select all filtered items that aren't already selected
        for (var fItem in _filteredItems) {
          if (!_selectedItems.any((sItem) => sItem.id == fItem.id)) {
            _selectedItems.add(fItem);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine if all filtered items are currently selected for the header checkbox
    final bool allFilteredSelected =
        _filteredItems.isNotEmpty &&
        _filteredItems.every(
          (fItem) => _selectedItems.any((sItem) => sItem.id == fItem.id),
        );

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select ${widget.title}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by Name or Code...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
            ),
            // Header for selecting all visible items
            CheckboxListTile(
              title: Text(
                _filteredItems.isEmpty
                    ? 'No results'
                    : 'Select/Deselect All (${_filteredItems.length})',
              ),
              value: allFilteredSelected,
              onChanged: _filteredItems.isNotEmpty
                  ? (bool? value) => _selectAll()
                  : null,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const Divider(height: 1),
            // List of searchable machines
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final machine = _filteredItems[index];
                  final isSelected = _selectedItems.any(
                    (item) => item.id == machine.id,
                  );

                  return CheckboxListTile(
                    title: Text(machine.machineName.capitalizeFirst!),
                    subtitle: Text(machine.machineCode),
                    value: isSelected,
                    onChanged: (bool? value) => _onToggleItem(machine, value!),
                  );
                },
              ),
            ),
            // Apply Button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _selectedItems),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Apply Selection (${_selectedItems.length})'),
              ),
            ),
          ],
        );
      },
    );
  }
}
