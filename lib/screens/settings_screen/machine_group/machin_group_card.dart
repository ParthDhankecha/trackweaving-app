import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';
import 'package:trackweaving/common_widgets/my_text_widget.dart';
import 'package:trackweaving/models/machine_group_response_model.dart';

class MachineGroupCard extends StatelessWidget {
  final MachineGroup machineGroup;
  final int index;
  final Function() onEdit;
  const MachineGroupCard({
    super.key,
    required this.machineGroup,
    required this.index,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: MyTextWidget(text: '#${index + 1}', textStyle: bodyStyle),
          ),
          Expanded(
            flex: 4,
            child: MyTextWidget(
              textAlign: TextAlign.left,
              text: machineGroup.groupName,
              textStyle: bodyStyle,
            ),
          ),
          TextButton(onPressed: () => onEdit(), child: Text('Edit')),
        ],
      ),
    );
  }
}
