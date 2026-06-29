import 'package:get/get.dart';

import 'json_convertors/serializer.dart';

part 'report_response.g.dart';

@CustomSerializer
class ReportsResponse {
  String code;
  String message;
  Reports data;

  ReportsResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ReportsResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportsResponseFromJson(json);
}

@CustomSerializer
class Reports {
  List<DataList> list;
  int totalPicks;
  int totalEfficiency;
  num avgProdMeter;
  int avgPicks;

  Reports({
    required this.list,
    required this.totalPicks,
    required this.totalEfficiency,
    required this.avgProdMeter,
    required this.avgPicks,
  });

  factory Reports.fromJson(Map<String, dynamic> json) =>
      _$ReportsFromJson(json);

  List<String> get stopTypes {
    final data = list.firstWhereOrNull((e) {
      final shift = e.reportData.dayShift ?? e.reportData.nightShift;
      return shift?.list.firstOrNull?.stopsData.isNotEmpty ?? false;
    });
    final shift = data?.reportData.dayShift ?? data?.reportData.nightShift;
    return shift?.list.first.stopsData.keys.toList() ?? [];
  }

  int get stopTypeCount {
    final data = list.firstWhereOrNull((e) {
      final shift = e.reportData.dayShift ?? e.reportData.nightShift;
      return shift?.list.firstOrNull?.stopsData.isNotEmpty ?? false;
    });
    final shift = data?.reportData.dayShift ?? data?.reportData.nightShift;
    return shift?.list.first.stopsData.length ?? 0;
  }
}

@CustomSerializer
class DataList {
  DateTime reportDate;
  ReportData reportData;

  DataList({required this.reportDate, required this.reportData});

  factory DataList.fromJson(Map<String, dynamic> json) =>
      _$DataListFromJson(json);
}

@CustomSerializer
class ReportData {
  Shift? dayShift;
  Shift? nightShift;

  ReportData({required this.dayShift, required this.nightShift});

  factory ReportData.fromJson(Map<String, dynamic> json) =>
      _$ReportDataFromJson(json);
}

@CustomSerializer
class Shift {
  List<ShiftList> list;
  int totalPicks;
  num efficiency;
  num prodMeter;
  int avgPicks;

  Shift({
    required this.list,
    required this.totalPicks,
    required this.efficiency,
    required this.prodMeter,
    required this.avgPicks,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
}

@CustomSerializer
class ShiftList {
  ShiftList({
    required this.shift,
    required this.machineCode,
    required this.pieceLengthM,
    required this.picksCurrentShift,
    required this.efficiencyPercent,
    required this.runTime,
    required this.beamLeft,
    required this.stopsData,
    this.reportDate,
  });

  int shift;
  String machineCode;
  num pieceLengthM;
  int picksCurrentShift;
  num efficiencyPercent;
  String runTime;
  int beamLeft;
  Map<String, Map> stopsData;
  @DateNullParser()
  DateTime? reportDate;

  factory ShiftList.fromJson(Map<String, dynamic> json) =>
      _$ShiftListFromJson(json);
}
