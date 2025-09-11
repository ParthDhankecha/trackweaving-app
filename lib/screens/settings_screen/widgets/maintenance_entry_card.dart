import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';

class MaintenanceEntryCard extends StatelessWidget {
  const MaintenanceEntryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return //maintenance entry card
    Container(
      margin: EdgeInsets.only(left: 9, right: 9),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.successColor, width: 1.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.successColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('M1', style: titleStyle.copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
          //LIST OF ROWS
          ListView.builder(
            shrinkWrap: true,
            itemCount: 2,
            itemBuilder: (context, index) =>
                _buildRow(title: 'Oil change due', value: '19-Jun-2025'),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: bodyStyle1.copyWith(color: Colors.black)),
              Text(value, style: bodyStyle, textAlign: TextAlign.end),
            ],
          ),
        ),
      ),
    );
  }
}
