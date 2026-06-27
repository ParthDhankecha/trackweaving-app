import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:trackweaving/utils/app_const.dart';

class StopDataTable extends StatelessWidget {
  final Map<String, Map> stopsData;
  const StopDataTable({super.key, required this.stopsData});

  @override
  Widget build(BuildContext context) {
    // Constant styling parameters
    const double cellPaddingW = 5;
    const double cellPaddingH = 2;

    // A reusable function for creating styled table cells
    Widget buildTableCell({
      required String text,
      Color? textColor,
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
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Table(
          border: TableBorder.all(
            color: Colors.grey,
            width: 0.5,
            borderRadius: BorderRadius.circular(5),
          ),
          children: [
            // Header Row
            TableRow(
              children: [
                // Column 0: Header label ('stops')
                buildTableCell(
                  text: 'stops'.tr,
                  backgroundColor: const Color(0xFF424242),
                  textColor: Colors.white,
                  align: TextAlign.left,
                ),
                // Columns 1-6: Category names
                for (var category in stopsData.keys)
                  buildTableCell(
                    text: category.titleCase.tr,
                    backgroundColor: const Color(0xFF424242),
                    textColor: Colors.white,
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
                  align: TextAlign.left,
                ),
                // Columns 1-6: Count values
                ...stopsData.values.map((entry) {
                  return buildTableCell(
                    text: (entry['count'] ?? 0).toString(),
                    textColor: AppColors.mainColor,
                  );
                }),
              ],
            ),
            // Time Row
            TableRow(
              children: [
                // Column 0: Row label ('Time')
                buildTableCell(
                  text: 'Time'.tr,
                  backgroundColor: const Color(0xFFE0E0E0),
                  align: TextAlign.left,
                ),
                // Columns 1-6: Duration values
                ...stopsData.values.map((entry) {
                  return buildTableCell(
                    text: (entry['duration'] ?? 0).toString(),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
