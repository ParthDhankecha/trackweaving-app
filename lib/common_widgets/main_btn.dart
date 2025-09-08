import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';

class MainBtn extends StatelessWidget {
  const MainBtn({super.key, required this.label, this.onTap});

  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainColor,
          foregroundColor: AppColors.whiteColor,
        ),
        onPressed: onTap,
        child: Text(label, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
