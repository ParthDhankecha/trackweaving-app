import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:flutter_texmunimx/common_widgets/my_text_widget.dart';

class MachineConfigurationCard extends StatelessWidget {
  final String srNo;
  final String machineCode;
  final String machineName;
  final String machineGroup;
  final String udid;
  final bool alertEnabled;
  final String efficiencyLimit;
  final Function(bool isOn) onAlertChange;

  const MachineConfigurationCard({
    super.key,
    required this.srNo,
    required this.machineCode,
    required this.machineName,
    required this.machineGroup,
    required this.udid,
    required this.alertEnabled,
    required this.efficiencyLimit,
    required this.onAlertChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow('sr_no', srNo.toString()),
                Row(
                  children: [
                    _buildInfoRow('alert', ''),

                    SizedBox(
                      height: 20,
                      child: Switch(
                        value: alertEnabled,
                        onChanged: (bool value) => onAlertChange(value),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeThumbColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('machine_code', machineCode),
            const SizedBox(height: 8),
            _buildInfoRow('machine_name', machineName),
            const SizedBox(height: 8),
            _buildInfoRow('machine_group', machineGroup),
            const SizedBox(height: 8),
            _buildInfoRow('udid', udid),
            const SizedBox(height: 8),
            _buildInfoRow('efficiency_limit', '$efficiencyLimit%'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyTextWidget(
          text: title,
          textStyle: bodyStyle1.copyWith(fontWeight: FontWeight.normal),
        ),
        SizedBox(width: 10),
        MyTextWidget(
          text: value,
          textStyle: bodyStyle.copyWith(color: color),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
