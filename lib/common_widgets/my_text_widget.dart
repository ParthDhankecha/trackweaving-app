import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTextWidget extends StatelessWidget {
  const MyTextWidget({
    super.key,
    required this.text,
    this.textStyle,
    this.textAlign,
    this.textColor = Colors.grey,
  });
  final String text;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr,
      textAlign: textAlign,
      style:
          textStyle ??
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
    );
  }
}
