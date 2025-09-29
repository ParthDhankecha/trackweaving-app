import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackweaving/models/report_response.dart';
import 'package:trackweaving/utils/date_formate_extension.dart';

class ReportTableWidget extends StatelessWidget {
  final ReportsResponse reportResponse;

  const ReportTableWidget({super.key, required this.reportResponse});

  // Base style and colors
  static const TextStyle _cellTextStyle = TextStyle(fontSize: 12);
  static const TextStyle _headerTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const Color _headerBgColor = Color(0xFF1D5C93); // Dark Blue
  static const Color _shiftSummaryColor = Color(0xFFE6F0F8); // Light Blue-Gray
  static const Color _subHeaderBgColor = Color(
    0xFF184970,
  ); // Slightly darker sub-header

  static const Color _totalRowColor = Color(0xFFD3D3D3); // Light Gray

  static const double _dateWidth = 100.0;
  static const double _shiftWidth = 100.0;
  static const double _machineWidth = 80.0;
  static const double _prodMtrsWidth = 80.0;
  static const double _picksWidth = 80.0;
  static const double _effWidth = 50.0;
  static const double _runTimeWidth = 70.0;
  static const double _beamLeftWidth = 70.0;
  static const double _stopCellWidth = 60.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Table Header
            _buildHeaderRow(),

            // Table Body (Grouped by Date)
            // Updated to use reportResponse.data.list and DataList
            Column(
              children: [
                ...reportResponse.data.list.map((reportByDate) {
                  return _buildReportGroup(reportByDate);
                }),
              ],
            ),

            // Table Total Row
            _buildTotalRow(reportResponse.data),
          ],
        ),
      ),
    );
  }

  // Builds the top-level fixed header row
  Widget _buildHeaderRow() {
    // Define the column widths for consistency.
    const double dateWidth = 100.0;
    const double shiftWidth = 100.0;
    const double stopTypeWidth = 60.0;

    return IntrinsicHeight(
      child: Row(
        children: [
          // 1. Date Column
          _headerCell('Date', dateWidth),

          // 2. Shift Column
          _headerCell('Shift', shiftWidth),

          // 3. Main Data Columns
          _headerCell('Machine', 80.0),
          _headerCell('Prod. [Mtrs]', 80.0),
          _headerCell('Picks', 80.0),
          _headerCell('Eff. %', 50.0),
          _headerCell('Run Time', 70.0),
          _headerCell('Beam Left', 70.0),

          // 4. Stops Sub-Headers (10 columns: Count/Duration for 5 types)
          _buildStopTypeHeader('Warp', 2 * stopTypeWidth),
          _buildStopTypeHeader('Weft', 2 * stopTypeWidth),
          _buildStopTypeHeader('Feeder', 2 * stopTypeWidth),
          _buildStopTypeHeader('Manual', 2 * stopTypeWidth),
          _buildStopTypeHeader('Other', 2 * stopTypeWidth),

          // 5. Total Stop Header (2 columns: Count/Duration)
          _headerCell('Total Stops', 2 * stopTypeWidth, isSubHeader: false),
        ],
      ),
    );
  }

  // Helper to build a standard header cell
  Widget _headerCell(String text, double width, {bool isSubHeader = false}) {
    // Determine background color based on level
    final Color bgColor = isSubHeader
        ? _headerBgColor.withOpacity(0.8)
        : _headerBgColor;

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.white, width: 0.5),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: _headerTextStyle.copyWith(fontSize: isSubHeader ? 10 : 12),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStopTypeHeader(String title, double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: _headerBgColor,
        border: Border.all(color: Colors.white, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              title,
              style: _headerTextStyle.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
          // Sub-header for Count and Duration - FIXED THE OVERFLOW WITH EXPANDED
          IntrinsicHeight(
            child: Row(
              children: [
                _buildExpandedSubHeaderCell('Count'),
                _buildExpandedSubHeaderCell('Duration'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build a standard sub-header cell using Expanded
  Widget _buildExpandedSubHeaderCell(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.5, horizontal: 6.5),
        decoration: BoxDecoration(
          color:
              _subHeaderBgColor, // Use the slightly darker color for distinction
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: _headerTextStyle.copyWith(fontSize: 10),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // Builds the report rows for a single day
  // Updated to use DataList
  Widget _buildReportGroup(DataList report) {
    final List<Widget> dayRows = [];

    // 1. DAY SHIFT Summary Row
    dayRows.add(
      _buildShiftSummaryRow(
        report.reportData.dayShift,
        isDayShift: true,
        reportDate: report.reportDate,
      ),
    );

    // 2. DAY SHIFT Detail Rows (Machine level)
    for (var detail in report.reportData.dayShift.list) {
      dayRows.add(_buildDetailRow(detail, isDayShift: true));
    }

    // 3. NIGHT SHIFT Summary Row
    dayRows.add(
      _buildShiftSummaryRow(report.reportData.nightShift, isDayShift: false),
    );

    // 4. NIGHT SHIFT Detail Rows (Machine level)
    for (var detail in report.reportData.nightShift.list) {
      dayRows.add(_buildDetailRow(detail, isDayShift: false));
    }

    return Column(children: dayRows);
  }

  // Builds a shift summary row (e.g., "26-Sep-2025 - Day Shift")
  Widget _buildShiftSummaryRow(
    Shift shift, {
    required bool isDayShift,
    DateTime? reportDate,
  }) {
    final String shiftName = isDayShift ? 'Day Shift' : 'Night Shift';
    final Color bgColor = isDayShift ? Colors.white : _shiftSummaryColor;

    // Date is displayed only on the Day Shift row. Night Shift row uses a full-width shift cell.
    final String dateText = reportDate != null
        ? DateFormat('dd-MMM-yyyy').format(reportDate)
        : '';

    // The total width of the Date and Shift columns when combined (200.0)
    final double dateShiftCombinedWidth = _dateWidth + _shiftWidth;

    // The width for the first cell:
    // If it's a Day Shift, it holds the Date. If it's Night Shift, it's empty to visually span the date above.
    // The Shift column will hold the Shift name.

    return Row(
      children: [
        // 1. Date Column
        _dataCell(
          dateText,
          _dateWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          borderColor: Colors.grey.shade300,
        ),

        // 2. Shift Column
        _dataCell(
          shiftName,
          _shiftWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          borderColor: Colors.grey.shade300,
        ),

        // 3. Machine Code (Empty)
        _dataCell(
          '',
          _machineWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 4. Prod. [Mtrs] (Total Production)
        _dataCell(
          shift.prodMeter.toStringAsFixed(2),
          _prodMtrsWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          borderColor: Colors.grey.shade300,
        ),

        // 5. Picks (Total Picks)
        _dataCell(
          NumberFormat('#,###').format(shift.totalPicks),
          _picksWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          borderColor: Colors.grey.shade300,
        ),

        // 6. Eff. (Total Efficiency)
        _dataCell(
          '${shift.efficiency}',
          _effWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          borderColor: Colors.grey.shade300,
        ),

        // 7. Run Time (Picks Avg shown here)
        _dataCell(
          'Avg: ${NumberFormat('#,###').format(shift.avgPicks)}',
          _runTimeWidth + _beamLeftWidth, // Span Run Time and Beam Left columns
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerLeft,
          borderColor: Colors.grey.shade300,
        ),

        // 8. Remaining Columns (All empty in the summary row, for Stops/Total Stops columns)
        ...List.generate(
          12,
          (_) => _dataCell(
            '',
            _stopCellWidth,
            bgColor: bgColor,
            borderColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  // Builds a detailed machine data row
  Widget _buildDetailRow(DayShiftList detail, {required bool isDayShift}) {
    const double dateWidth = 100.0;
    const double shiftWidth = 100.0;
    const double stopTypeWidth = 60.0;
    final Color bgColor = isDayShift ? Colors.white : _shiftSummaryColor;

    // Calculate total stops data using the updated extension name
    final totalStops = detail.stopsData;
    final int totalCount = totalStops.totalCount;
    final String totalDuration = totalStops.totalDuration;

    return Row(
      children: [
        // 1. Date Column (Empty for detail rows)
        _dataCell(
          '',
          dateWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 2. Shift Column (Empty for detail rows)
        _dataCell(
          '',
          shiftWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 3. Machine Code
        _dataCell(
          detail.machineCode,
          80.0,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 4. Prod. [Mtrs]
        _dataCell(
          detail.pieceLengthM.toStringAsFixed(2),
          80.0,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 5. Picks
        _dataCell(
          NumberFormat('#,###').format(detail.picksCurrentShift),
          80.0,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 6. Eff.
        _dataCell(
          detail.efficiencyPercent.toStringAsFixed(1),
          50.0,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 7. Run Time
        _dataCell(
          detail.runTime,
          70.0,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 8. Beam Left
        _dataCell(
          '${detail.beamLeft}',
          70.0,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 9. Individual Stops Data
        ..._buildStops(detail.stopsData, stopTypeWidth, bgColor),

        // 10. Total Stops
        _dataCell(
          '$totalCount',
          stopTypeWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.w600,
          borderColor: Colors.grey.shade300,
        ),
        _dataCell(
          totalDuration,
          stopTypeWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.w600,
          borderColor: Colors.grey.shade300,
        ),
      ],
    );
  }

  // Builds the total row at the bottom
  // Updated to use Data
  Widget _buildTotalRow(Data totals) {
    const double dateWidth = 100.0;
    const double shiftWidth = 100.0;

    // Combine the first two columns and Machine Code column for the 'Total' label
    final double totalLabelWidth = dateWidth + shiftWidth + 80.0;

    return Container(
      color: _totalRowColor,
      child: Row(
        children: [
          // 1. Total Label (Spanning Date, Shift, Machine)
          _dataCell(
            'TOTAL',
            totalLabelWidth,
            bgColor: _totalRowColor,
            fontWeight: FontWeight.bold,
            alignment: Alignment.center,
            borderColor: Colors.grey.shade500,
          ),

          // 2. Prod. [Mtrs] Total
          _dataCell(
            totals.avgProdMeter.toStringAsFixed(2),
            80.0,
            bgColor: _totalRowColor,
            fontWeight: FontWeight.bold,
            borderColor: Colors.grey.shade500,
          ),

          // 3. Picks Total
          _dataCell(
            NumberFormat('#,###').format(totals.totalPicks),
            80.0,
            bgColor: _totalRowColor,
            fontWeight: FontWeight.bold,
            borderColor: Colors.grey.shade500,
          ),

          // 4. Eff. Total
          _dataCell(
            '${totals.totalEfficiency}',
            50.0,
            bgColor: _totalRowColor,
            fontWeight: FontWeight.bold,
            borderColor: Colors.grey.shade500,
          ),

          // 5. Run Time (Picks Avg Total in the web image)
          _dataCell(
            'Total Avg: ${NumberFormat('#,###').format(totals.avgPicks)}',
            _runTimeWidth + _beamLeftWidth,
            bgColor: _totalRowColor,
            fontWeight: FontWeight.bold,
            alignment: Alignment.centerLeft,
            borderColor: Colors.grey.shade500,
          ),

          // 6. Remaining 11 Stop columns (Empty for this total row)
          ...List.generate(
            12,
            (_) => _dataCell(
              '',
              60.0,
              bgColor: _totalRowColor,
              borderColor: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build stop count/duration pairs
  // Updated to use StopsData
  List<Widget> _buildStops(StopsData stops, double width, Color bgColor) {
    return [
      // Warp
      _dataCell(
        '${stops.warp.count}',
        width,
        bgColor: bgColor,
        borderColor: Colors.grey.shade300,
      ),
      _dataCell(
        stops.warp.duration,
        width,
        bgColor: bgColor,
        borderColor: Colors.grey.shade300,
      ),
      // Weft
      _dataCell(
        '${stops.weft.count}',
        width,
        bgColor: bgColor,
        borderColor: Colors.grey.shade300,
      ),
      _dataCell(
        stops.weft.duration,
        width,
        bgColor: bgColor,
        borderColor: Colors.grey.shade300,
      ),
      // Feeder
      _dataCell(
        '${stops.feeder.count}',
        width,
        bgColor: bgColor,
        borderColor: Colors.grey.shade300,
      ),
      _dataCell(
        stops.feeder.duration,
        width,
        bgColor: bgColor,
        borderColor: Colors.grey.shade300,
      ),
      // Manual
      _dataCell(
        '${stops.manual.count}',
        width,
        bgColor: bgColor,
        borderColor: Colors.grey.shade300,
      ),
      _dataCell(
        stops.manual.duration,
        width,
        bgColor: bgColor,
        borderColor: Colors.grey.shade300,
      ),
      // Other
      _dataCell(
        '${stops.other.count}',
        width,
        bgColor: bgColor,
        borderColor: Colors.grey.shade300,
      ),
      _dataCell(
        stops.other.duration,
        width,
        bgColor: bgColor,
        borderColor: Colors.grey.shade300,
      ),
    ];
  }

  // Helper to build a standard data cell
  Widget _dataCell(
    String text,
    double width, {
    Color bgColor = Colors.white,
    FontWeight fontWeight = FontWeight.normal,
    AlignmentGeometry alignment = Alignment.center,
    Color borderColor = const Color(0xFFEEEEEE),
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 0.5),
      ),
      alignment: alignment,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: _cellTextStyle.copyWith(fontWeight: fontWeight),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
