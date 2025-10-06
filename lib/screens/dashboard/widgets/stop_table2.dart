import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackweaving/models/get_machinelog_model.dart';
import 'package:trackweaving/utils/app_colors.dart';

class StopDataTable2 extends StatelessWidget {
  final StopsData stopsData;
  const StopDataTable2({super.key, required this.stopsData});

  @override
  Widget build(BuildContext context) {
    // Defines the 6 categories for the data columns
    const List<String> categories = [
      'Warp',
      'Weft',
      'Feeder',
      'Manual',
      'Other',
      'Total',
    ];

    // Constant styling parameters
    const double cellPaddingW = 5;
    const double cellPaddingH = 2;

    // A reusable function for creating styled table cells
    Widget buildTableCell({
      required String text,
      Color? textColor,
      FontWeight? fontWeight,
      Color? backgroundColor,
      TextAlign align = TextAlign.center,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: cellPaddingW,
          vertical: cellPaddingH,
        ),

        child: Text(
          text,
          textAlign: align,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: textColor,
            fontWeight: fontWeight,
            fontSize: 10,
          ),
        ),
      );
    }

    // Wrapping the entire widget in the requested 8.0 padding
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        // Removed SingleChildScrollView and NeverScrollableScrollPhysics
        child: Table(
          border: TableBorder.all(
            color: Colors.grey,
            width: 0.5,
            borderRadius: BorderRadius.circular(5),
          ),
          // *** Key for responsiveness: Use columnWidths with FlexColumnWidth ***
          columnWidths: const {
            // Column 0 (Label: 'stops', 'Count', 'Time') gets slightly more width
            0: FlexColumnWidth(0.8),
            // Columns 1-6 (Data categories) are equally distributed
            1: FlexColumnWidth(0.8),
            2: FlexColumnWidth(0.8),
            3: FlexColumnWidth(1.0), // Feeder
            4: FlexColumnWidth(1.10), // Manual
            5: FlexColumnWidth(0.85), // Other
            6: FlexColumnWidth(0.85), // Total
          },
          children: [
            // Header Row
            TableRow(
              children: [
                // Column 0: Header label ('stops')
                buildTableCell(
                  text: 'stops'.tr,
                  backgroundColor: const Color(0xFF424242),
                  textColor: Colors.white,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.left,
                ),
                // Columns 1-6: Category names
                for (var category in categories)
                  buildTableCell(
                    text: category.tr,
                    backgroundColor: const Color(0xFF424242),
                    textColor: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              ],
            ),
            // Count Row
            TableRow(
              children: [
                // Column 0: Row label ('Count')
                buildTableCell(
                  text: 'Count'.tr,
                  backgroundColor: const Color(0xFFE0E0E0),
                  fontWeight: FontWeight.bold,
                  align: TextAlign.left,
                ),
                // Columns 1-6: Count values
                buildTableCell(
                  text: stopsData.warp.count.toString(),
                  textColor: AppColors.mainColor,
                  fontWeight: FontWeight.bold,
                ),
                buildTableCell(
                  text: stopsData.weft.count.toString(),
                  textColor: AppColors.mainColor,
                  fontWeight: FontWeight.bold,
                ),
                buildTableCell(
                  text: stopsData.feeder.count.toString(),
                  textColor: AppColors.mainColor,
                  fontWeight: FontWeight.bold,
                ),
                buildTableCell(
                  text: stopsData.manual.count.toString(),
                  textColor: AppColors.mainColor,
                  fontWeight: FontWeight.bold,
                ),
                buildTableCell(
                  text: stopsData.other.count.toString(),
                  textColor: AppColors.mainColor,
                  fontWeight: FontWeight.bold,
                ),
                buildTableCell(
                  text: stopsData.total.count.toString(),
                  textColor: AppColors.mainColor,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            // Time Row
            TableRow(
              children: [
                // Column 0: Row label ('Time')
                buildTableCell(
                  text: 'Time'.tr,
                  backgroundColor: const Color(0xFFE0E0E0),
                  fontWeight: FontWeight.bold,
                  align: TextAlign.left,
                ),
                // Columns 1-6: Duration values
                buildTableCell(text: stopsData.warp.duration),
                buildTableCell(text: stopsData.weft.duration),
                buildTableCell(text: stopsData.feeder.duration),
                buildTableCell(text: stopsData.manual.duration),
                buildTableCell(text: stopsData.other.duration),
                buildTableCell(text: stopsData.total.duration),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
