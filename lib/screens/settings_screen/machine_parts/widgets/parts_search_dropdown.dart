import 'package:flutter/material.dart';

/// A custom widget for searchable and single-selectable parts dropdown.
/// It allows the user to select one existing part or add a new one.
class PartsSearchDropdown extends StatefulWidget {
  final String title;
  final String? selectedValue; // Now a single String, not a List
  final List<String> items;
  final ValueChanged<String?> onChanged; // Now accepts a single String or null
  final ValueChanged<String> onNewPartAdded; // New callback for custom parts

  const PartsSearchDropdown({
    super.key,
    required this.title,
    this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.onNewPartAdded,
  });

  @override
  State<PartsSearchDropdown> createState() => _PartsSearchDropdownState();
}

class _PartsSearchDropdownState extends State<PartsSearchDropdown> {
  // Utility method to display the selected part nicely
  String _getDisplayString(String? selected) {
    return selected == null || selected.isEmpty ? 'Select a Part' : selected;
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
          onTap: () => _showSingleSelectDialog(context),
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
                    _getDisplayString(widget.selectedValue),
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.selectedValue == null
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

  void _showSingleSelectDialog(BuildContext context) async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        // Use a stateful builder for the internal state of the dialog
        return _SingleSelectDialog(
          items: widget.items,
          initialSelected: widget.selectedValue,
          title: widget.title,
          onNewPartAdded: widget.onNewPartAdded,
        );
      },
    );

    if (result != null) {
      widget.onChanged(result);
    }
  }
}

// Inner widget for the single-select, searchable, and customizable dialog content
class _SingleSelectDialog extends StatefulWidget {
  final List<String> items;
  final String? initialSelected;
  final String title;
  final ValueChanged<String> onNewPartAdded;

  const _SingleSelectDialog({
    required this.items,
    this.initialSelected,
    required this.title,
    required this.onNewPartAdded,
  });

  @override
  _SingleSelectDialogState createState() => _SingleSelectDialogState();
}

class _SingleSelectDialogState extends State<_SingleSelectDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];
  String? _currentSelected;

  @override
  void initState() {
    super.initState();
    _currentSelected = widget.initialSelected;
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
            .where((part) => part.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _onSelect(String partName) {
    setState(() {
      _currentSelected = partName;
    });
    // Immediately close and return the result for single selection
    Navigator.pop(context, _currentSelected);
  }

  void _onAddNewPart(String newPartName) {
    // 1. Call the external callback to handle adding the part to the master list
    widget.onNewPartAdded(newPartName);

    // 2. Select the new part
    setState(() {
      _currentSelected = newPartName;
    });

    // 3. Close and return the newly added part
    Navigator.pop(context, _currentSelected);
  }

  @override
  Widget build(BuildContext context) {
    final String currentQuery = _searchController.text.trim();
    final bool showNewPartButton =
        currentQuery.isNotEmpty && !_filteredItems.contains(currentQuery);

    return AlertDialog(
      title: Text('Select ${widget.title}'),
      contentPadding: const EdgeInsets.only(top: 10),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search or type new Part name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
            ),
            if (showNewPartButton) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () => _onAddNewPart(currentQuery),
                  icon: const Icon(Icons.add_circle_outline),
                  label: Text('Add New Part: "$currentQuery"'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            const Divider(height: 1),
            Flexible(
              child: _filteredItems.isEmpty && !showNewPartButton
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('No parts found. Type to add a new one.'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final part = _filteredItems[index];
                        final isSelected = _currentSelected == part;

                        return ListTile(
                          title: Text(part),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.blueAccent,
                                )
                              : null,
                          onTap: () => _onSelect(part),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
