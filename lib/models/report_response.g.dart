// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportsResponse _$ReportsResponseFromJson(Map<String, dynamic> json) =>
    ReportsResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      data: Reports.fromJson(json['data'] as Map<String, dynamic>),
    );

Reports _$ReportsFromJson(Map<String, dynamic> json) => Reports(
  list: (json['list'] as List<dynamic>)
      .map((e) => DataList.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPicks: const IntParser().fromJson(json['totalPicks']),
  totalEfficiency: const IntParser().fromJson(json['totalEfficiency']),
  avgProdMeter: const NumParser().fromJson(json['avgProdMeter']),
  avgPicks: const IntParser().fromJson(json['avgPicks']),
);

DataList _$DataListFromJson(Map<String, dynamic> json) => DataList(
  reportDate: const DateParser().fromJson(json['reportDate']),
  reportData: ReportData.fromJson(json['reportData'] as Map<String, dynamic>),
);

ReportData _$ReportDataFromJson(Map<String, dynamic> json) => ReportData(
  dayShift: json['dayShift'] == null
      ? null
      : Shift.fromJson(json['dayShift'] as Map<String, dynamic>),
  nightShift: json['nightShift'] == null
      ? null
      : Shift.fromJson(json['nightShift'] as Map<String, dynamic>),
);

Shift _$ShiftFromJson(Map<String, dynamic> json) => Shift(
  list: (json['list'] as List<dynamic>)
      .map((e) => ShiftList.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPicks: const IntParser().fromJson(json['totalPicks']),
  efficiency: const NumParser().fromJson(json['efficiency']),
  prodMeter: const NumParser().fromJson(json['prodMeter']),
  avgPicks: const IntParser().fromJson(json['avgPicks']),
);

ShiftList _$ShiftListFromJson(Map<String, dynamic> json) => ShiftList(
  shift: const IntParser().fromJson(json['shift']),
  machineCode: json['machineCode'] as String,
  pieceLengthM: const NumParser().fromJson(json['pieceLengthM']),
  picksCurrentShift: const IntParser().fromJson(json['picksCurrentShift']),
  efficiencyPercent: const NumParser().fromJson(json['efficiencyPercent']),
  runTime: json['runTime'] as String,
  beamLeft: const IntParser().fromJson(json['beamLeft']),
  stopsData: (json['stopsData'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, e as Map<String, dynamic>),
  ),
  reportDate: const DateNullParser().fromJson(json['reportDate']),
);
