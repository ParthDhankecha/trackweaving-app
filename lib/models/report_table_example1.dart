import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- 1. DATA MODELS ---

// Model for stop count and duration
class StopDetailModel {
  final int count;
  final String duration; // e.g., "00:45"

  StopDetailModel({required this.count, required this.duration});

  factory StopDetailModel.fromJson(Map<String, dynamic> json) {
    return StopDetailModel(
      count: json['count'] as int,
      duration: json['duration'] as String,
    );
  }
}

// Model for all stop types
class StopsDataModel {
  final StopDetailModel warp;
  final StopDetailModel weft;
  final StopDetailModel feeder;
  final StopDetailModel manual;
  final StopDetailModel other;

  StopsDataModel({
    required this.warp,
    required this.weft,
    required this.feeder,
    required this.manual,
    required this.other,
  });

  factory StopsDataModel.fromJson(Map<String, dynamic> json) {
    return StopsDataModel(
      warp: StopDetailModel.fromJson(json['warp'] as Map<String, dynamic>),
      weft: StopDetailModel.fromJson(json['weft'] as Map<String, dynamic>),
      feeder: StopDetailModel.fromJson(json['feeder'] as Map<String, dynamic>),
      manual: StopDetailModel.fromJson(json['manual'] as Map<String, dynamic>),
      other: StopDetailModel.fromJson(json['other'] as Map<String, dynamic>),
    );
  }

  // Helper to calculate total stop count
  int get totalCount =>
      warp.count + weft.count + feeder.count + manual.count + other.count;

  // Helper to calculate total stop duration (This is complex as duration is a string "HH:MM")
  // For simplicity, we assume duration is always in "MM:SS" or "HH:MM" format.
  String get totalDuration {
    int totalMinutes = 0;

    // Helper to convert "HH:MM" or "MM:SS" string to total seconds
    int durationToSeconds(String duration) {
      final parts = duration.split(':');
      if (parts.length == 2) {
        // Assuming "HH:MM" or "MM:SS"
        final h = int.tryParse(parts[0]) ?? 0;
        final m = int.tryParse(parts[1]) ?? 0;
        // Since we don't know if it's HH:MM or MM:SS, let's treat it as H:M for production data
        return (h * 60) + m; // Total minutes
      }
      return 0;
    }

    totalMinutes += durationToSeconds(warp.duration);
    totalMinutes += durationToSeconds(weft.duration);
    totalMinutes += durationToSeconds(feeder.duration);
    totalMinutes += durationToSeconds(manual.duration);
    totalMinutes += durationToSeconds(other.duration);

    // Convert total minutes back to "HH:MM" format for display
    final hours = (totalMinutes ~/ 60).toString().padLeft(2, '0');
    final minutes = (totalMinutes % 60).toString().padLeft(2, '0');

    return "$hours:$minutes";
  }
}

// Model for individual machine data within a shift
class ReportDetailModel {
  final String machineCode;
  final double pieceLengthM;
  final int picksCurrentShift;
  final double efficiencyPercent;
  final String runTime; // e.g., "06:30"
  final int beamLeft;
  final StopsDataModel stopsData;

  ReportDetailModel({
    required this.machineCode,
    required this.pieceLengthM,
    required this.picksCurrentShift,
    required this.efficiencyPercent,
    required this.runTime,
    required this.beamLeft,
    required this.stopsData,
  });

  factory ReportDetailModel.fromJson(Map<String, dynamic> json) {
    return ReportDetailModel(
      machineCode: json['machineCode'] as String,
      pieceLengthM: (json['pieceLengthM'] as num).toDouble(),
      picksCurrentShift: json['picksCurrentShift'] as int,
      efficiencyPercent: (json['efficiencyPercent'] as num).toDouble(),
      runTime: json['runTime'] as String,
      beamLeft: json['beamLeft'] as int,
      stopsData: StopsDataModel.fromJson(
        json['stopsData'] as Map<String, dynamic>,
      ),
    );
  }
}

// Model for Day/Night shift summary and machine list
class ShiftDataModel {
  final List<ReportDetailModel> list;
  final int totalPicks;
  final int efficiency; // Assuming this is rounded up or int
  final double prodMeter;
  final int avgPicks;

  ShiftDataModel({
    required this.list,
    required this.totalPicks,
    required this.efficiency,
    required this.prodMeter,
    required this.avgPicks,
  });

  factory ShiftDataModel.fromJson(Map<String, dynamic> json) {
    return ShiftDataModel(
      list: (json['list'] as List<dynamic>)
          .map((e) => ReportDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPicks: json['totalPicks'] as int,
      efficiency: json['efficiency'] as int,
      prodMeter: (json['prodMeter'] as num).toDouble(),
      avgPicks: json['avgPicks'] as int,
    );
  }
}

// Model for a single day's report
class ReportByDateModel {
  final DateTime reportDate;
  final ShiftDataModel dayShift;
  final ShiftDataModel nightShift;

  ReportByDateModel({
    required this.reportDate,
    required this.dayShift,
    required this.nightShift,
  });

  factory ReportByDateModel.fromJson(Map<String, dynamic> json) {
    // The main list item contains reportDate and reportData
    final reportData = json['reportData'] as Map<String, dynamic>;

    return ReportByDateModel(
      reportDate: DateTime.parse(json['reportDate'] as String),
      dayShift: ShiftDataModel.fromJson(
        reportData['dayShift'] as Map<String, dynamic>,
      ),
      nightShift: ShiftDataModel.fromJson(
        reportData['nightShift'] as Map<String, dynamic>,
      ),
    );
  }
}

// Top-level data structure inside the 'data' field
class ReportDataModel {
  final List<ReportByDateModel> list;
  final int totalPicks;
  final int totalEfficiency; // Assuming this is int
  final double avgProdMeter;
  final int avgPicks;

  ReportDataModel({
    required this.list,
    required this.totalPicks,
    required this.totalEfficiency,
    required this.avgProdMeter,
    required this.avgPicks,
  });

  factory ReportDataModel.fromJson(Map<String, dynamic> json) {
    return ReportDataModel(
      list: (json['list'] as List<dynamic>)
          .map((e) => ReportByDateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPicks: json['totalPicks'] as int,
      totalEfficiency: json['totalEfficiency'] as int,
      avgProdMeter: (json['avgProdMeter'] as num).toDouble(),
      avgPicks: json['avgPicks'] as int,
    );
  }
}

// The full API response structure
class ReportResponseModel {
  final String code;
  final String message;
  final ReportDataModel data;

  ReportResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ReportResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportResponseModel(
      code: json['code'] as String,
      message: json['message'] as String,
      data: ReportDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

// --- 2. REPORT TABLE WIDGET ---

class ReportTableWidget extends StatelessWidget {
  final ReportResponseModel reportResponse;

  const ReportTableWidget({super.key, required this.reportResponse});

  // Base style for table cells
  static const TextStyle _cellTextStyle = TextStyle(fontSize: 12);
  static const TextStyle _headerTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const Color _headerBgColor = Color(0xFF6200EE); // Deep Purple
  static const Color _shiftSummaryColor = Color(0xFFEFEFEF);
  static const Color _totalRowColor = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    // We use a SingleChildScrollView to make the whole table scrollable
    // and a Column inside to structure the header, body, and total.
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            // Table Header
            _buildHeaderRow(),

            // Table Body
            ...reportResponse.data.list.map((reportByDate) {
              return _buildReportGroup(reportByDate);
            }),

            // Table Total Row
            _buildTotalRow(reportResponse.data),
          ],
        ),
      ),
    );
  }

  // --- UI Builder Methods ---

  // Builds the top-level fixed header row
  Widget _buildHeaderRow() {
    // Define the column widths for consistency. Use flex factor for relative sizing.
    const double dateWidth = 100.0;
    const double shiftWidth = 100.0;
    const double stopTypeWidth = 60.0;

    // Headers for the main data columns (fixed width)
    final List<Widget> mainHeaders = [
      _headerCell('Machine', 80.0),
      _headerCell('Prod. [Mtrs]', 80.0),
      _headerCell('Picks', 80.0),
      _headerCell('Eff.', 50.0),
      _headerCell('Run Time', 70.0),
      _headerCell('Beam Left', 70.0),
    ];

    // Headers for the stops (count and duration)
    // final List<Widget> stopHeaders = [
    //   _headerCell('Count', stopTypeWidth),
    //   _headerCell('Duration', stopTypeWidth),
    // ];

    return IntrinsicHeight(
      child: Row(
        children: [
          // 1. Date Column (Static width)
          _headerCell('Date', dateWidth),

          // 2. Shift Column (Static width)
          _headerCell('Shift', shiftWidth),

          // 3. Main Data Columns (Dynamic width for the content)
          ...mainHeaders,

          // 4. Stops Sub-Header
          _buildStopTypeHeader('Warp Stop', 2 * stopTypeWidth),
          _buildStopTypeHeader('Weft Stop', 2 * stopTypeWidth),
          _buildStopTypeHeader('Feeder Stop', 2 * stopTypeWidth),
          _buildStopTypeHeader('Manual Stop', 2 * stopTypeWidth),
          _buildStopTypeHeader('Other Stop', 2 * stopTypeWidth),

          // 5. Total Stop Header
          _buildStopTypeHeader('Total Stop', 2 * stopTypeWidth),
        ],
      ),
    );
  }

  // Helper to build a standard header cell
  Widget _headerCell(String text, double width, {bool isSubHeader = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: _headerBgColor,
        border: Border.all(color: Colors.grey.shade600, width: 0.5),
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

  // Helper to build the nested Stop Type header (spans Count and Duration)
  Widget _buildStopTypeHeader(String title, double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: _headerBgColor,
        border: Border.all(color: Colors.grey.shade600, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: _headerTextStyle.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
          ),
          // Sub-header for Count and Duration
          IntrinsicHeight(
            child: Row(
              children: [
                _headerCell('Count', width / 2, isSubHeader: true),
                _headerCell('Duration', width / 2, isSubHeader: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builds the report rows for a single day (Date spanning multiple rows)
  Widget _buildReportGroup(ReportByDateModel report) {
    // List of rows for this date: [Day Shift Summary, Day Shift Details..., Night Shift Summary, Night Shift Details...]
    final List<Widget> dayRows = [];

    // 1. DAY SHIFT Summary Row
    dayRows.add(
      _buildShiftSummaryRow(
        report.dayShift,
        isDayShift: true,
        reportDate: report.reportDate,
      ),
    );

    // 2. DAY SHIFT Detail Rows (Machine level)
    for (var detail in report.dayShift.list) {
      dayRows.add(_buildDetailRow(detail, isDayShift: true));
    }

    // 3. NIGHT SHIFT Summary Row
    dayRows.add(_buildShiftSummaryRow(report.nightShift, isDayShift: false));

    // 4. NIGHT SHIFT Detail Rows (Machine level)
    for (var detail in report.nightShift.list) {
      dayRows.add(_buildDetailRow(detail, isDayShift: false));
    }

    return Column(children: dayRows);
  }

  // Builds a shift summary row (e.g., "26-Sep-2025 - Day Shift")
  Widget _buildShiftSummaryRow(
    ShiftDataModel shift, {
    required bool isDayShift,
    DateTime? reportDate,
  }) {
    const double dateWidth = 100.0;
    const double shiftWidth = 100.0;
    final String shiftName = isDayShift ? 'Day Shift' : 'Night Shift';

    // Display the date only on the first shift row of the group (Day Shift)
    final String dateText = reportDate != null
        ? DateFormat('dd-MMM-yyyy').format(reportDate)
        : '';

    final Color bgColor = isDayShift ? Colors.white : _shiftSummaryColor;

    // Use total data for the summary row
    final String picksAvg = 'Picks Avg: ${shift.avgPicks.toString()}';

    return Row(
      children: [
        // 1. Date Column (Only visible on Day Shift row)
        _dataCell(
          dateText,
          dateWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          borderColor: Colors.grey.shade300,
        ),

        // 2. Shift Column
        _dataCell(
          shiftName,
          shiftWidth,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          borderColor: Colors.grey.shade300,
        ),

        // 3. Machine Code (Empty or summary text)
        _dataCell(
          '',
          80.0,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 4. Prod. [Mtrs] (Total Production)
        _dataCell(
          shift.prodMeter.toStringAsFixed(2),
          80.0,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          borderColor: Colors.grey.shade300,
        ),

        // 5. Picks (Total Picks)
        _dataCell(
          NumberFormat('#,###').format(shift.totalPicks),
          80.0,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          borderColor: Colors.grey.shade300,
        ),

        // 6. Eff. (Total Efficiency)
        _dataCell(
          '${shift.efficiency}',
          50.0,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          borderColor: Colors.grey.shade300,
        ),

        // 7. Run Time (Picks Avg in the web image)
        _dataCell(
          picksAvg,
          70.0,
          bgColor: bgColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerLeft,
          borderColor: Colors.grey.shade300,
        ),

        // 8. Remaining Columns (All empty in the summary row)
        ...List.generate(
          11,
          (_) => _dataCell(
            '',
            60.0,
            bgColor: bgColor,
            borderColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  // Builds a detailed machine data row
  Widget _buildDetailRow(ReportDetailModel detail, {required bool isDayShift}) {
    const double dateWidth = 100.0;
    const double shiftWidth = 100.0;
    const double stopTypeWidth = 60.0;
    final Color bgColor = isDayShift ? Colors.white : _shiftSummaryColor;

    return Row(
      children: [
        // 1. Date Column (Empty for detail rows to simulate spanning)
        _dataCell(
          '',
          dateWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),

        // 2. Shift Column (Empty for detail rows to simulate spanning)
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

        // 9. Stops Data
        ..._buildStops(detail.stopsData, stopTypeWidth, bgColor),

        // 10. Total Stops (Calculated)
        _dataCell(
          '${detail.stopsData.totalCount}',
          stopTypeWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),
        _dataCell(
          detail.stopsData.totalDuration,
          stopTypeWidth,
          bgColor: bgColor,
          borderColor: Colors.grey.shade300,
        ),
      ],
    );
  }

  // Builds the total row at the bottom
  Widget _buildTotalRow(ReportDataModel totals) {
    const double dateWidth = 100.0;
    const double shiftWidth = 100.0;
    //const double stopTypeWidth = 60.0;

    // Combine the first two columns and Machine Code column for the 'Total' label
    final double totalLabelWidth = dateWidth + shiftWidth + 80.0;

    // Remaining columns: Prod [Mtrs], Picks, Eff, Run Time (Picks Avg) + Stops

    return Container(
      color: _totalRowColor,
      child: Row(
        children: [
          // 1. Total Label (Spanning Date, Shift, Machine)
          _dataCell(
            'Total',
            totalLabelWidth,
            bgColor: _totalRowColor,
            fontWeight: FontWeight.bold,
            alignment: Alignment.centerLeft,
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
            'Total Picks Avg: ${NumberFormat('#,###').format(totals.avgPicks)}',
            70.0,
            bgColor: _totalRowColor,
            fontWeight: FontWeight.bold,
            alignment: Alignment.centerLeft,
            borderColor: Colors.grey.shade500,
          ),

          // 6. Remaining 10 Stop columns (Empty for this total row)
          ...List.generate(
            11,
            (_) => _dataCell(
              '',
              60.0,
              bgColor: _totalRowColor,
              borderColor: Colors.grey.shade500,
            ),
          ),

          // The Beam Left column is also empty in the totals, so 11 cells total (70 + 10*60)
        ],
      ),
    );
  }

  // Helper to build stop count/duration pairs
  List<Widget> _buildStops(StopsDataModel stops, double width, Color bgColor) {
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

// --- 3. RUNNABLE EXAMPLE APP ---

// Dummy JSON response data (using the exact structure provided by the user)
const String _dummyJsonResponse = r'''
{
    "code": "OK",
    "message": "Operation is successfully executed",
    "data": {
        "list": [
            {
                "reportDate": "2025-09-26T00:00:00.000Z",
                "reportData": {
                    "dayShift": {
                        "list": [
                            {
                                "shift": 0,
                                "machineCode": "M1",
                                "pieceLengthM": 120.2,
                                "picksCurrentShift": 1520850,
                                "efficiencyPercent": 85.6,
                                "runTime": "06:30",
                                "beamLeft": 20,
                                "stopsData": {
                                    "warp": { "count": 10, "duration": "00:45" },
                                    "weft": { "count": 10, "duration": "00:45" },
                                    "feeder": { "count": 10, "duration": "00:45" },
                                    "manual": { "count": 10, "duration": "00:45" },
                                    "other": { "count": 10, "duration": "00:45" }
                                }
                            },
                            {
                                "shift": 0,
                                "machineCode": "M2",
                                "pieceLengthM": 43.89,
                                "picksCurrentShift": 100000,
                                "efficiencyPercent": 95.0,
                                "runTime": "07:00",
                                "beamLeft": 30,
                                "stopsData": {
                                    "warp": { "count": 5, "duration": "00:15" },
                                    "weft": { "count": 5, "duration": "00:15" },
                                    "feeder": { "count": 5, "duration": "00:15" },
                                    "manual": { "count": 5, "duration": "00:15" },
                                    "other": { "count": 5, "duration": "00:15" }
                                }
                            }
                        ],
                        "totalPicks": 704460,
                        "efficiency": 91,
                        "prodMeter": 164.09,
                        "avgPicks": 176115
                    },
                    "nightShift": {
                        "list": [
                            {
                                "shift": 0,
                                "machineCode": "M1",
                                "pieceLengthM": 120.2,
                                "picksCurrentShift": 1520850,
                                "efficiencyPercent": 85.6,
                                "runTime": "06:30",
                                "beamLeft": 20,
                                "stopsData": {
                                    "warp": { "count": 10, "duration": "00:45" },
                                    "weft": { "count": 10, "duration": "00:45" },
                                    "feeder": { "count": 10, "duration": "00:45" },
                                    "manual": { "count": 10, "duration": "00:45" },
                                    "other": { "count": 10, "duration": "00:45" }
                                }
                            }
                        ],
                        "totalPicks": 704460,
                        "efficiency": 91,
                        "prodMeter": 164.09,
                        "avgPicks": 176115
                    }
                }
            },
            {
                "reportDate": "2025-09-27T00:00:00.000Z",
                "reportData": {
                    "dayShift": {
                        "list": [
                            {
                                "shift": 0,
                                "machineCode": "M3",
                                "pieceLengthM": 50.0,
                                "picksCurrentShift": 500000,
                                "efficiencyPercent": 98.0,
                                "runTime": "08:00",
                                "beamLeft": 50,
                                "stopsData": {
                                    "warp": { "count": 2, "duration": "00:05" },
                                    "weft": { "count": 2, "duration": "00:05" },
                                    "feeder": { "count": 2, "duration": "00:05" },
                                    "manual": { "count": 2, "duration": "00:05" },
                                    "other": { "count": 2, "duration": "00:05" }
                                }
                            }
                        ],
                        "totalPicks": 500000,
                        "efficiency": 98,
                        "prodMeter": 50.0,
                        "avgPicks": 500000
                    },
                    "nightShift": {
                        "list": [
                            {
                                "shift": 0,
                                "machineCode": "M4",
                                "pieceLengthM": 75.5,
                                "picksCurrentShift": 600000,
                                "efficiencyPercent": 90.0,
                                "runTime": "07:30",
                                "beamLeft": 60,
                                "stopsData": {
                                    "warp": { "count": 8, "duration": "00:20" },
                                    "weft": { "count": 8, "duration": "00:20" },
                                    "feeder": { "count": 8, "duration": "00:20" },
                                    "manual": { "count": 8, "duration": "00:20" },
                                    "other": { "count": 8, "duration": "00:20" }
                                }
                            }
                        ],
                        "totalPicks": 600000,
                        "efficiency": 90,
                        "prodMeter": 75.5,
                        "avgPicks": 600000
                    }
                }
            }
        ],
        "totalPicks": 1408920,
        "totalEfficiency": 91,
        "avgProdMeter": 328.18,
        "avgPicks": 176115
    }
}
''';

// Main application widget for demonstration
class ReportApp extends StatelessWidget {
  const ReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Parse the dummy JSON into the model for demonstration
    final Map<String, dynamic> jsonMap = json.decode(_dummyJsonResponse);
    final ReportResponseModel reportData = ReportResponseModel.fromJson(
      jsonMap,
    );

    return MaterialApp(
      title: 'Production Report Table',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Production Shift Report',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF6200EE),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'Reports from ${DateFormat('dd-MMM-yyyy').format(reportData.data.list.first.reportDate)} to ${DateFormat('dd-MMM-yyyy').format(reportData.data.list.last.reportDate)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ReportTableWidget(reportResponse: reportData),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  // Use a simpler date formatter (optional)
  Intl.defaultLocale = 'en_US';
  runApp(const ReportApp());
}
