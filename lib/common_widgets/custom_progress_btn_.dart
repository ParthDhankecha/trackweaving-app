import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';

class CustomProgressBtn extends StatelessWidget {
  const CustomProgressBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.mainColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(color: AppColors.whiteColor),
          ),
        ),
      ),
    );
  }
}
