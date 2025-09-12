import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/models/get_machinelog_model.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';

class StopDataTable extends StatelessWidget {
  final StopsData stopsData;
  const StopDataTable({super.key, required this.stopsData});

  @override
  Widget build(BuildContext context) {
    // Sample data to populate the table
    const data = {
      'Warp': {'count': 0, 'time': '00:00'},
      'Weft': {'count': 10, 'time': '00:10'},
      'Feeder': {'count': 2, 'time': '00:02'},
      'Manual': {'count': 1, 'time': '00:04'},
      'Other': {'count': 0, 'time': '00:00'},
      'Total': {'count': 13, 'time': '00:17'},
    };

    const double cellPadding = 5.5;

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
        padding: const EdgeInsets.all(cellPadding),
        child: Text(
          text,
          textAlign: align,
          style: TextStyle(
            color: textColor,
            fontWeight: fontWeight,
            fontSize: 14,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(
            color: Colors.grey,
            width: 0.5,
            borderRadius: BorderRadius.circular(10),
          ),
          defaultColumnWidth: const IntrinsicColumnWidth(),
          children: [
            // Header Row
            TableRow(
              children: [
                buildTableCell(
                  text: 'Stops',
                  backgroundColor: const Color(0xFF424242),
                  textColor: Colors.white,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.left,
                ),
                for (var category in data.keys)
                  buildTableCell(
                    text: category,
                    backgroundColor: const Color(0xFF424242),
                    textColor: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              ],
            ),
            // Count Row
            TableRow(
              children: [
                buildTableCell(
                  text: 'Count',
                  backgroundColor: const Color(0xFFE0E0E0),
                  fontWeight: FontWeight.bold,
                  align: TextAlign.left,
                ),
                // for (var category in data.keys)
                //   buildTableCell(
                //     text: data[category]!['count'].toString(),
                //     textColor: AppColors.mainColor,
                //     fontWeight: FontWeight.bold,
                //   ),
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
                buildTableCell(
                  text: 'Time',
                  backgroundColor: const Color(0xFFE0E0E0),
                  fontWeight: FontWeight.bold,
                  align: TextAlign.left,
                ),
                // for (var category in data.keys)
                //   buildTableCell(text: data[category]!['time'].toString()),
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
