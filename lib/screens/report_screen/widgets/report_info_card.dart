import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';
import 'package:trackweaving/common_widgets/my_text_widget.dart';
import 'package:trackweaving/utils/app_colors.dart';

class ReportInfoCard extends StatelessWidget {
  final String date;
  final String shift;
  final String machine;
  final String prodMTRS;
  final String picks;

  final String eff;
  final String runtime;
  final String beamLeft;

  const ReportInfoCard({
    super.key,
    required this.date,
    required this.shift,
    required this.machine,
    required this.prodMTRS,
    required this.eff,
    required this.runtime,
    required this.beamLeft,

    required this.picks,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildInfoRow('Date', date), _buildInfoRow('', shift)],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Machine', machine),
            const SizedBox(height: 8),
            _buildInfoRow('Prod.(Mtrs)', prodMTRS),
            const SizedBox(height: 8),
            _buildInfoRow('picks', picks),
            const SizedBox(height: 8),
            _buildInfoRow('Eff.', eff),
            const SizedBox(height: 8),
            _buildInfoRow('Runtime', runtime),
            const SizedBox(height: 8),
            _buildInfoRow('Beam Left', beamLeft),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildBoxItem('Wrap', '24', '00:50'),
                SizedBox(width: 4),
                _buildBoxItem('Weft', '19', '00:14'),
                SizedBox(width: 4),
                _buildBoxItem('Feeder', '24', '00:50'),
                SizedBox(width: 4),
                _buildBoxItem('Manual', '19', '00:14'),
                SizedBox(width: 4),
                _buildBoxItem('Other', '24', '00:50'),
                SizedBox(width: 4),
                _buildBoxItem('Total', '19', '00:14'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildBoxItem(String title, String value, String time) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: bodyStyle1),
            Text(value, style: bodyStyle1.copyWith(color: AppColors.mainColor)),
            Text(time, style: bodyStyle1.copyWith(color: AppColors.mainColor)),
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
