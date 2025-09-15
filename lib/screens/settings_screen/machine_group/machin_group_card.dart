import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:flutter_texmunimx/common_widgets/my_text_widget.dart';

class MachineGroupCard extends StatelessWidget {
  const MachineGroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: MyTextWidget(text: '#1', textStyle: bodyStyle),
          ),
          Expanded(
            flex: 4,
            child: MyTextWidget(
              textAlign: TextAlign.left,
              text: 'Jacquard',
              textStyle: bodyStyle,
            ),
          ),
          TextButton(onPressed: () {}, child: Text('Edit')),
        ],
      ),
    );
  }
}
