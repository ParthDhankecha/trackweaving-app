import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';
import 'package:trackweaving/models/report_response.dart';
import 'package:trackweaving/screens/report_screen/report_table/report_table_2.dart';
import 'package:trackweaving/screens/report_screen/report_table/report_table_widget.dart';

class ReportResultScreen extends StatefulWidget {
  final ReportsResponse reportResponse;
  const ReportResultScreen({super.key, required this.reportResponse});

  @override
  State<ReportResultScreen> createState() => _ReportResultScreenState();
}

class _ReportResultScreenState extends State<ReportResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shiftwise Production Report')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            //date and title
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [Text('Date: 12-sep-2025 to 12-sep-2025')],
            // ),
            // Divider(),
            // _buildTotalBox(
            //   title: 'Total',
            //   picks: '1864818',
            //   eff: '90',
            //   prodAvg: '384.72',
            //   picksAvg: '155402',
            // ),

            // Row(
            //   children: [
            //     Expanded(
            //       child: _buildTotalBoxHorizontal(
            //         title: 'Day Shift Total',
            //         picks: '274275',
            //         eff: '90',
            //         prodAvg: '57.63',
            //         picksAvg: '68569',
            //       ),
            //     ),
            //     Expanded(
            //       child: _buildTotalBoxHorizontal(
            //         title: 'Night Shift Total',
            //         picks: '864442',
            //         eff: '90',
            //         prodAvg: '179.2',
            //         picksAvg: '216111',
            //       ),
            //     ),
            //   ],
            // ),

            // //data
            // ReportInfoCard(
            //   date: '12-sep-2025',
            //   shift: 'Night Shift',
            //   machine: 'm1',
            //   prodMTRS: '41.4',
            //   eff: '91',
            //   runtime: '11:49:00',
            //   beamLeft: '0',

            //   picks: '213477',
            // ),
            ReportTableWidget2(reportResponse: widget.reportResponse),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBoxHorizontal({
    required String title,
    required String picks,
    required String eff,
    required String prodAvg,
    required String picksAvg,
  }) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Text(title, style: normalTextStyle1),
              SizedBox(height: 6),
              _buildTotalBoxRow('Picks', picks),
              SizedBox(height: 6),
              _buildTotalBoxRow('Eff', eff),
              SizedBox(height: 6),
              _buildTotalBoxRow('Prod. Avg.', prodAvg),
              SizedBox(height: 6),
              _buildTotalBoxRow('Picks Avg.', picksAvg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalBox({
    required String title,
    required String picks,
    required String eff,
    required String prodAvg,
    required String picksAvg,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(title, style: normalTextStyle1)],
              ),
              SizedBox(height: 6),

              Row(
                children: [
                  Expanded(child: _buildTotalBoxRow('Picks', picks)),
                  SizedBox(width: 8),

                  Expanded(child: _buildTotalBoxRow('Eff. ', eff)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildTotalBoxRow('Prod.Avg.', prodAvg)),
                  SizedBox(width: 8),
                  Expanded(child: _buildTotalBoxRow('Picks Avg.', picksAvg)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalBoxRow(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: bodyStyle1),
            Text(value, style: bodyStyle),
          ],
        ),
      ),
    );
  }
}
