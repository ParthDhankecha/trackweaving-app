// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_log_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MachineLogResponse _$MachineLogResponseFromJson(Map<String, dynamic> json) =>
    MachineLogResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  aggregateReport: AggregateReport.fromJson(
    json['aggregateReport'] as Map<String, dynamic>,
  ),
  machineLogs: (json['machineLogs'] as List<dynamic>)
      .map((e) => MachineLog.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: const IntParser().fromJson(json['totalCount']),
);

AggregateReport _$AggregateReportFromJson(Map<String, dynamic> json) =>
    AggregateReport(
      efficiency: json['efficiency'] == null
          ? 0
          : const NumParser().fromJson(json['efficiency']),
      pick: json['pick'] == null ? 0 : const NumParser().fromJson(json['pick']),
      avgSpeed: json['avgSpeed'] == null
          ? 0
          : const NumParser().fromJson(json['avgSpeed']),
      avgPicks: json['avgPicks'] == null
          ? 0
          : const NumParser().fromJson(json['avgPicks']),
      running: json['running'] == null
          ? 0
          : const IntParser().fromJson(json['running']),
      stopped: json['stopped'] == null
          ? 0
          : const IntParser().fromJson(json['stopped']),
      all: json['all'] == null ? 0 : const IntParser().fromJson(json['all']),
    );

MachineLog _$MachineLogFromJson(Map<String, dynamic> json) => MachineLog(
  machineCode: json['machineCode'] as String,
  machineName: json['machineName'] as String,
  quality: json['quality'] as String? ?? '',
  runTime: json['runTime'] as String? ?? '-',
  efficiency: json['efficiency'] == null
      ? 0
      : const NumParser().fromJson(json['efficiency']),
  picks: json['picks'] == null ? 0 : const NumParser().fromJson(json['picks']),
  speed: json['speed'] == null ? 0 : const NumParser().fromJson(json['speed']),
  stopReason: json['stopReason'] as String,
  currentStop: json['currentStop'] == null
      ? 0
      : const NumParser().fromJson(json['currentStop']),
  pieceLengthM: json['pieceLengthM'] == null
      ? 0
      : const NumParser().fromJson(json['pieceLengthM']),
  stops: json['stops'] == null ? 0 : const NumParser().fromJson(json['stops']),
  beamLeft: json['beamLeft'] == null
      ? 0
      : const NumParser().fromJson(json['beamLeft']),
  setPicks: json['setPicks'] == null
      ? 0
      : const NumParser().fromJson(json['setPicks']),
  stopsData: (json['stopsData'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, e as Map<String, dynamic>),
  ),
  totalDuration: json['totalDuration'] as String,
  logTime: const DateNullParser().fromJson(json['logTime']),
);
