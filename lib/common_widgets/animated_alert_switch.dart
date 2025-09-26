import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';

class AnimatedAlertSwitch extends StatelessWidget {
  final bool current;
  final String onTitle;
  final String offTitle;
  final Function(bool value) onChanged;
  const AnimatedAlertSwitch({
    super.key,
    required this.current,
    required this.onChanged,
    required this.onTitle,
    required this.offTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AnimatedToggleSwitch<bool>.dual(
        current: current,
        first: false,
        second: true,
        spacing: 2.0,

        style: const ToggleStyle(
          backgroundColor: Colors.white,
          borderColor: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1.5),
            ),
          ],
        ),
        borderWidth: 5.0,
        height: 40,
        onChanged: onChanged,
        styleBuilder: (b) =>
            ToggleStyle(indicatorColor: b ? Colors.green : Colors.grey),
        iconBuilder: (value) => value
            ? const Icon(
                Icons.notifications_active_outlined,
                color: Colors.white,
                size: 20,
              )
            : const Icon(
                Icons.notifications_none_outlined,
                color: Colors.white,
                size: 20,
              ),
        textBuilder: (value) => value
            ? Center(child: Text(onTitle, style: bodyStyle1))
            : Center(child: Text(offTitle, style: bodyStyle1)),
      ),
    );
  }
}
