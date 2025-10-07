import 'package:flutter/material.dart';
import 'package:trackweaving/utils/app_colors.dart';

class BuildCheckboxRow extends StatelessWidget {
  const BuildCheckboxRow({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,

            activeColor: AppColors.mainColor,
          ),
          Text(title),
        ],
      ),
    );
  }
}
