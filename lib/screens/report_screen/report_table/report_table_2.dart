import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackweaving/models/report_response.dart';
import 'package:trackweaving/utils/date_formate_extension.dart';

class ReportTableWidget2 extends StatelessWidget {
  final ReportsResponse reportResponse;

  const ReportTableWidget2({super.key, required this.reportResponse});

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

  // --- Fixed Column Widths ---
  static const double _dateWidth = 100.0;
  static const double _shiftWidth = 100.0;
  static const double _machineWidth = 80.0;
  static const double _prodMtrsWidth = 80.0;
  static const double _picksWidth = 80.0;
  static const double _effWidth = 50.0;
  static const double _runTimeWidth = 70.0;
  static const double _beamLeftWidth = 70.0;
  static const double _stopCellWidth = 60.0;

  // Calculated height of the header for padding the body
  static const double _headerHeight =
      55.0; // Approximate height of the header row

  @override
  Widget build(BuildContext context) {
    // 1. Compile all rows into a single list, including summaries and the final total
    final List<Widget> allRows = _buildAllRows(reportResponse.data);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: _calculateTotalTableWidth(),

              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: _headerHeight),
                    child: ConstrainedBox(
                      // This limits the vertical height of the scrollable content
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                        // Adjust as needed, e.g., 60% of screen height
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: allRows.length,
                        itemBuilder: (context, index) {
                          return allRows[index];
                        },

                        shrinkWrap: true,
                      ),
                    ),
                  ),

                  // --- Sticky Header ---
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _buildHeaderRow(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Calculates the fixed total width of the table
  double _calculateTotalTableWidth() {
    // 1. Main Columns (Date to Beam Left)
    const double mainColsWidth =
        _dateWidth +
        _shiftWidth +
        _machineWidth +
        _prodMtrsWidth +
        _picksWidth +
        _effWidth +
        _runTimeWidth +
        _beamLeftWidth;

    // 2. Stops Columns (5 types * 2 cells/type = 10 cells)
    const double stopsColsWidth = 10 * _stopCellWidth;

    // 3. Total Stops Columns (2 cells)
    const double totalStopsColsWidth = 2 * _stopCellWidth;

    return mainColsWidth + stopsColsWidth + totalStopsColsWidth;
  }

  // Combines all rows (summary, detail, and total) into one list
  List<Widget> _buildAllRows(Data data) {
    final List<Widget> rows = [];

    for (var reportByDate in data.list) {
      if (reportByDate.reportData.dayShift != null) {
        // 1. DAY SHIFT Detail Rows
        for (var detail in reportByDate.reportData.dayShift!.list) {
          var detailIndex = reportByDate.reportData.dayShift!.list.indexOf(
            detail,
          );
          if (detailIndex == 0) {
            rows.add(
              _buildDetailRow(
                detail,
                isDayShift: true,
                isFirst: true,
                reportDate: reportByDate.reportDate,
              ),
            );
          } else {
            rows.add(_buildDetailRow(detail, isDayShift: true));
          }
        }

        // 2. DAY SHIFT Summary Row

        rows.add(
          _buildShiftSummaryRow(
            reportByDate.reportData.dayShift!,
            isDayShift: true,
            reportDate: reportByDate.reportDate,
          ),
        );
      }

      if (reportByDate.reportData.nightShift != null) {
        // 3. NIGHT SHIFT Detail Rows
        for (var detail in reportByDate.reportData.nightShift!.list) {
          var detailIndex = reportByDate.reportData.nightShift!.list.indexOf(
            detail,
          );
          if (detailIndex == 0) {
            rows.add(
              _buildDetailRow(
                detail,
                isDayShift: false,
                isFirst: true,
                reportDate: reportByDate.reportDate,
              ),
            );
          } else {
            rows.add(_buildDetailRow(detail, isDayShift: false));
          }
        }
        // 4. NIGHT SHIFT Summary Row
        rows.add(
          _buildShiftSummaryRow(
            reportByDate.reportData.nightShift!,
            isDayShift: false,
            reportDate: reportByDate
                .reportDate, // Pass report date for shift name formatting
          ),
        );
      }

      //  rows.add(const SizedBox(height: 8.0)); // Space between different dates
    }

    // 5. Global Total Row (at the end of the scrollable content)
    rows.add(_buildTotalRow(data));

    return rows;
  }

  // Builds the top-level fixed header row
  Widget _buildHeaderRow() {
    return Container(
      // Ensure the header has a solid background color so the rows don't show through
      color: _headerBgColor,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // 1. Date Column
            _headerCell('Date', _dateWidth),

            // 2. Shift Column
            _headerCell('Shift', _shiftWidth),

            // 3. Main Data Columns
            _headerCell('Machine', _machineWidth),
            _headerCell('Prod. [Mtrs]', _prodMtrsWidth),
            _headerCell('Picks', _picksWidth),
            _headerCell('Eff. %', _effWidth),
            _headerCell('Run Time', _runTimeWidth),
            _headerCell('Beam Left', _beamLeftWidth),

            // 4. Stops Sub-Headers (10 columns: Count/Duration for 5 types)
            _buildStopTypeHeader('Warp', 2 * _stopCellWidth),
            _buildStopTypeHeader('Weft', 2 * _stopCellWidth),
            _buildStopTypeHeader('Feeder', 2 * _stopCellWidth),
            _buildStopTypeHeader('Manual', 2 * _stopCellWidth),
            _buildStopTypeHeader('Other', 2 * _stopCellWidth),

            // 5. Total Stop Header (2 columns: Count/Duration)
            _headerCell('Total Stops', 2 * _stopCellWidth),
          ],
        ),
      ),
    );
  }

  // Helper to build a standard header cell
  Widget _headerCell(String text, double width) {
    return Container(
      width: width,
      height: _headerHeight, // Fix the height for consistent spacing
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: _headerBgColor,
        border: Border.all(color: Colors.white, width: 0.5),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: _headerTextStyle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
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
          // border: Border.all(color: Colors.white, width: 0.1),
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

  // Builds the nested Stop Type header (spans Count and Duration)
  Widget _buildStopTypeHeader(String title, double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: _headerBgColor,
        border: Border.symmetric(
          vertical: BorderSide(color: Colors.white, width: 0.5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              title,
              style: _headerTextStyle.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(color: Colors.white, height: 1, thickness: 1),
          // Sub-header for Count and Duration
          IntrinsicHeight(
            child: Row(
              children: [
                _buildExpandedSubHeaderCell('Count'),
                VerticalDivider(
                  color: Colors.white,
                  width: 0.5,
                  thickness: 0.5,
                ),
                _buildExpandedSubHeaderCell('Duration'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builds a shift summary row (e.g., "26-Sep-2025 - Day Shift")
  Widget _buildShiftSummaryRow(
    Shift shift, {
    required bool isDayShift,
    DateTime? reportDate,
  }) {
    final String shiftName = isDayShift ? 'Day Shift' : 'Night Shift';
    final Color bgColor = isDayShift ? Colors.white : _shiftSummaryColor;

    // Date is displayed only on the Day Shift row. Night Shift row has an empty Date cell.
    final String dateText = reportDate != null ? reportDate.ddmmyyFormat : '';

    // Span Run Time and Beam Left columns for the Avg Picks text
    final double avgPicksWidth = _runTimeWidth + _beamLeftWidth;

    return Row(
      children: [
        // 1. Date Column
        _dataCell(
          // dateText,
          '',
          _dateWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          borderColor: Colors.grey.shade300,
        ),

        // 2. Shift Column
        _dataCell(
          //shiftName,
          '$dateText - $shiftName',
          _shiftWidth + _machineWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          borderColor: Colors.grey.shade300,
        ),

        // 3. Machine Code (Empty)
        // _dataCell(
        //   '',
        //   _machineWidth,
        //   bgColor: bgColor,
        //   borderColor: Colors.grey.shade300,
        // ),

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

        // 7. Run Time / Beam Left (Avg Picks shown here)
        _dataCell(
          'Avg: ${NumberFormat('#,###').format(shift.avgPicks)}',
          avgPicksWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerLeft,
          borderColor: Colors.grey.shade300,
        ),

        // 8. Remaining 12 Stop columns (Empty in the summary row)
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
  Widget _buildDetailRow(
    DayShiftList detail, {
    required bool isDayShift,
    DateTime? reportDate,
    isFirst = false,
  }) {
    final Color bgColor = isDayShift ? Colors.white : _shiftSummaryColor;

    // Calculate total stops data
    final totalStops = detail.stopsData;
    final int totalCount = totalStops.total.count;
    final String totalDuration = totalStops.total.duration;

    final String shiftName = isDayShift ? 'Day Shift' : 'Night Shift';

    // Date is displayed only on the Day Shift row. Night Shift row has an empty Date cell.
    final String dateText = reportDate != null ? reportDate.ddmmyyFormat : '';

    // Span Run Time and Beam Left columns for the Avg Picks text
    //final double avgPicksWidth = _runTimeWidth + _beamLeftWidth;

    return Row(
      children: [
        // 1. Date Column (Empty to align data to the right)
        _dataCell(
          isFirst ? dateText : '',
          _dateWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
          fontWeight: FontWeight.bold,
        ),

        // 2. Shift Column (Empty to align data to the right)
        _dataCell(
          isFirst ? shiftName : '',
          _shiftWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
          fontWeight: FontWeight.bold,
        ),

        // 3. Machine Code
        _dataCell(
          detail.machineCode,
          _machineWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 4. Prod. [Mtrs]
        _dataCell(
          detail.pieceLengthM.toStringAsFixed(2),
          _prodMtrsWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 5. Picks
        _dataCell(
          NumberFormat('#,###').format(detail.picksCurrentShift),
          _picksWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 6. Eff.
        _dataCell(
          detail.efficiencyPercent.toStringAsFixed(1),
          _effWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 7. Run Time
        _dataCell(
          detail.runTime,
          _runTimeWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 8. Beam Left
        _dataCell(
          '${detail.beamLeft}',
          _beamLeftWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 9. Individual Stops Data
        ..._buildStops(detail.stopsData, _stopCellWidth, bgColor),

        // 10. Total Stops
        _dataCell(
          '$totalCount',
          _stopCellWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.w600,
          borderColor: Colors.grey.shade300,
        ),
        _dataCell(
          totalDuration,
          _stopCellWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.w600,
          borderColor: Colors.grey.shade300,
        ),
      ],
    );
  }

  // Builds the total row at the bottom
  Widget _buildTotalRow(Data totals) {
    // Width of Date, Shift, and Machine columns combined for the 'Total' label
    final double totalLabelWidth = _dateWidth + _shiftWidth + _machineWidth;
    final double avgPicksWidth = _runTimeWidth + _beamLeftWidth;

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
            _prodMtrsWidth,
            bgColor: _totalRowColor,
            fontWeight: FontWeight.bold,
            borderColor: Colors.grey.shade500,
          ),

          // 3. Picks Total
          _dataCell(
            NumberFormat('#,###').format(totals.totalPicks),
            _picksWidth,
            bgColor: _totalRowColor,
            fontWeight: FontWeight.bold,
            borderColor: Colors.grey.shade500,
          ),

          // 4. Eff. Total
          _dataCell(
            '${totals.totalEfficiency}',
            _effWidth,
            bgColor: _totalRowColor,
            fontWeight: FontWeight.bold,
            borderColor: Colors.grey.shade500,
          ),

          // 5. Run Time (Picks Avg Total in the web image)
          _dataCell(
            'Total Avg: ${NumberFormat('#,###').format(totals.avgPicks)}',
            avgPicksWidth,
            bgColor: _totalRowColor,
            fontWeight: FontWeight.bold,
            alignment: Alignment.centerLeft,
            borderColor: Colors.grey.shade500,
          ),

          // 6. Remaining 12 Stop columns (Empty for this total row)
          // Total stop columns: 5 types * 2 cells/type = 10 cells + 2 total cells = 12 cells
          ...List.generate(
            12,
            (_) => _dataCell(
              '',
              _stopCellWidth,
              bgColor: _totalRowColor,
              borderColor: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build stop count/duration pairs
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

  static List<List<dynamic>> getExportData(Data data) {
    final List<List<dynamic>> exportData = [];

    // --- 1.1 Top Header Row (Spanning Titles for PDF Grouping) ---
    final List<String> mainHeaders = [
      'Date',
      'Shift',
      'Machine',
      'Prod. [Mtrs]',
      'Picks',
      'Eff. %',
      'Run Time',
      'Beam Left',
    ];
    final List<String> stopTypes = [
      'Warp',
      'Weft',
      'Feeder',
      'Manual',
      'Other',
    ];

    // Top Row: Main headers (span 2 rows), Stop types (span 1 row/2 columns)
    final List<dynamic> topHeader = [
      ...mainHeaders,
      ...stopTypes.expand((type) => [type, type]),
      'Total Stops', 'Total Stops', // Total Stops spans 2 columns
    ];
    exportData.add(topHeader);

    // --- 1.2 Bottom Header Row (Metrics) ---
    final List<dynamic> bottomHeader = [
      // Main headers are empty placeholders as they are spanned by the top row
      ...List.generate(mainHeaders.length, (_) => ''),

      // Stop Metrics (Count/Duration repeated 6 times)
      ...List.generate(6, (_) => ['Count', 'Duration']).expand((e) => e),
    ];
    exportData.add(bottomHeader);

    // --- 1.3 Data Rows (Grouped by Date and Shift) ---
    // ... (Data rows construction remains the same)
    for (var reportByDate in data.list) {
      final String reportDateStr = reportByDate.reportDate.ddmmyyFormat;

      void processShift(Shift shift, String shiftName) {
        // SUMMARY ROW
        final List<dynamic> summaryRow = [
          reportDateStr,
          shiftName,
          '',
          shift.prodMeter.toStringAsFixed(2),
          NumberFormat('#,###').format(shift.totalPicks),
          '${shift.efficiency}',
          'Avg: ${NumberFormat('#,###').format(shift.avgPicks)}',
          '',
          ...List.generate(12, (_) => ''), // Empty stop columns
        ];
        exportData.add(summaryRow);

        // DETAIL ROWS
        for (var detail in shift.list) {
          final totalStops = detail.stopsData;

          final List<dynamic> detailRow = [
            '', // Date (Empty)
            '', // Shift (Empty)
            detail.machineCode,
            detail.pieceLengthM.toStringAsFixed(2),
            NumberFormat('#,###').format(detail.picksCurrentShift),
            detail.efficiencyPercent.toStringAsFixed(1),
            detail.runTime,
            '${detail.beamLeft}',

            // Stops Data
            '${detail.stopsData.warp.count}', detail.stopsData.warp.duration,
            '${detail.stopsData.weft.count}', detail.stopsData.weft.duration,
            '${detail.stopsData.feeder.count}',
            detail.stopsData.feeder.duration,
            '${detail.stopsData.manual.count}',
            detail.stopsData.manual.duration,
            '${detail.stopsData.other.count}', detail.stopsData.other.duration,

            // Total Stops
            '${totalStops.total.count}', totalStops.total.duration,
          ];
          exportData.add(detailRow);
        }
      }

      reportByDate.reportData.dayShift != null
          ? processShift(reportByDate.reportData.dayShift!, 'Day Shift')
          : null;
      reportByDate.reportData.nightShift != null
          ? processShift(reportByDate.reportData.nightShift!, 'Night Shift')
          : null;
    }

    // --- 1.4 Total Row ---
    final List<dynamic> finalTotalRow = [
      'TOTAL',
      'Total Prod Avg: ${data.avgProdMeter.toStringAsFixed(2)}',
      'Total Picks: ${NumberFormat('#,###').format(data.totalPicks)}',
      'Total Eff: ${data.totalEfficiency}',
      'Total Avg Picks: ${NumberFormat('#,###').format(data.avgPicks)}',
      ...List.generate(15, (_) => ''), // Pad remaining columns
    ];
    exportData.add(finalTotalRow);

    return exportData;
  }

  static List<List<dynamic>> getExportDataCSV(Data data) {
    final List<List<dynamic>> exportData = [];

    final List<String> mainHeaders = [
      'Date',
      'Shift',
      'Machine',
      'Prod. [Mtrs]',
      'Picks',
      'Eff. %',
      'Run Time',
      'Beam Left',
    ];
    final List<String> stopTypes = [
      'Warp',
      'Weft',
      'Feeder',
      'Manual',
      'Other',
    ];

    // Top Row: Main headers (span 2 rows), Stop types (span 1 row/2 columns)
    final List<dynamic> topHeader = [
      ...mainHeaders,
      ...stopTypes.expand((type) => [type, type]),
      'Total Stops', 'Total Stops', // Total Stops spans 2 columns
    ];
    exportData.add(topHeader);

    // --- 1.2 Bottom Header Row (Metrics) ---
    final List<dynamic> bottomHeader = [
      // Main headers are empty placeholders as they are spanned by the top row
      ...List.generate(mainHeaders.length, (_) => ''),

      // Stop Metrics (Count/Duration repeated 6 times)
      ...List.generate(6, (_) => ['Count', 'Duration']).expand((e) => e),
    ];
    exportData.add(bottomHeader);

    // --- 1.3 Data Rows (Grouped by Date and Shift) ---
    // ... (Data rows construction remains the same)
    for (var reportByDate in data.list) {
      final String reportDateStr = reportByDate.reportDate.ddmmyyFormat;

      void processShift(Shift shift, String shiftName) {
        // SUMMARY ROW
        final List<dynamic> summaryRow = [
          reportDateStr,
          shiftName,
          '',
          shift.prodMeter.toStringAsFixed(2),
          NumberFormat('#,###').format(shift.totalPicks),
          '${shift.efficiency}',
          'Avg: ${NumberFormat('#,###').format(shift.avgPicks)}',
          '',
          ...List.generate(12, (_) => ''), // Empty stop columns
        ];
        exportData.add(summaryRow);

        // DETAIL ROWS
        for (var detail in shift.list) {
          final totalStops = detail.stopsData;

          final List<dynamic> detailRow = [
            '', // Date (Empty)
            '', // Shift (Empty)
            detail.machineCode,
            detail.pieceLengthM.toStringAsFixed(2),
            NumberFormat('#,###').format(detail.picksCurrentShift),
            detail.efficiencyPercent.toStringAsFixed(1),
            detail.runTime,
            '${detail.beamLeft}',

            // Stops Data
            '${detail.stopsData.warp.count}', detail.stopsData.warp.duration,
            '${detail.stopsData.weft.count}', detail.stopsData.weft.duration,
            '${detail.stopsData.feeder.count}',
            detail.stopsData.feeder.duration,
            '${detail.stopsData.manual.count}',
            detail.stopsData.manual.duration,
            '${detail.stopsData.other.count}', detail.stopsData.other.duration,

            // Total Stops
            '${totalStops.total.count}', totalStops.total.duration,
          ];
          exportData.add(detailRow);
        }
      }

      reportByDate.reportData.dayShift != null
          ? processShift(reportByDate.reportData.dayShift!, 'Day Shift')
          : null;
      reportByDate.reportData.nightShift != null
          ? processShift(reportByDate.reportData.nightShift!, 'Night Shift')
          : null;
    }

    // --- 1.4 Total Row ---
    final List<dynamic> finalTotalRow = [
      'TOTAL',
      'Total Prod Avg: ${data.avgProdMeter.toStringAsFixed(2)}',
      'Total Picks: ${NumberFormat('#,###').format(data.totalPicks)}',
      'Total Eff: ${data.totalEfficiency}',
      'Total Avg Picks: ${NumberFormat('#,###').format(data.avgPicks)}',
      ...List.generate(15, (_) => ''), // Pad remaining columns
    ];
    exportData.add(finalTotalRow);

    return exportData;
  }
}
