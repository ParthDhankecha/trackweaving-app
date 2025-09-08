import 'package:flutter/material.dart';

class PrivacyBar extends StatelessWidget {
  const PrivacyBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Text('Privacy Policy', style: TextStyle(fontSize: 14)),
          ),
          Spacer(),
          InkWell(
            onTap: () {},
            child: Text('Terms and Conditions', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
