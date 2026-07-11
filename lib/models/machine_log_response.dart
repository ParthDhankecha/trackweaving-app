import 'package:trackweaving/models/json_convertors/serializer.dart';

part 'machine_log_response.g.dart';

@CustomSerializer
class MachineLogResponse {
  String code;
  String message;
  Data data;

  MachineLogResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory MachineLogResponse.fromJson(Map<String, dynamic> json) =>
      _$MachineLogResponseFromJson(json);
}

@CustomSerializer
class Data {
  AggregateReport aggregateReport;
  List<MachineLog> machineLogs;
  int totalCount;

  Data({
    required this.aggregateReport,
    required this.machineLogs,
    required this.totalCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@CustomSerializer
class AggregateReport {
  num efficiency;
  num pick;
  num avgSpeed;
  num avgPicks;
  int running;
  int stopped;
  int all;

  AggregateReport({
    this.efficiency = 0,
    this.pick = 0,
    this.avgSpeed = 0,
    this.avgPicks = 0,
    this.running = 0,
    this.stopped = 0,
    this.all = 0,
  });

  factory AggregateReport.fromJson(Map<String, dynamic> json) =>
      _$AggregateReportFromJson(json);
}

@CustomSerializer
class MachineLog {
  String machineCode;
  String machineName;
  num efficiency;
  num picks;
  num speed;
  String stopReason;
  num currentStop;
  num pieceLengthM;
  num stops;
  num beamLeft;
  num setPicks;
  Map<String, Map> stopsData;
  String totalDuration;
  @DateNullParser()
  DateTime? logTime;

  MachineLog({
    required this.machineCode,
    required this.machineName,
    this.efficiency = 0,
    this.picks = 0,
    this.speed = 0,
    required this.stopReason,
    this.currentStop = 0,
    this.pieceLengthM = 0,
    this.stops = 0,
    this.beamLeft = 0,
    this.setPicks = 0,
    required this.stopsData,
    required this.totalDuration,
    this.logTime,
  });

  factory MachineLog.fromJson(Map<String, dynamic> json) =>
      _$MachineLogFromJson(json);
}
