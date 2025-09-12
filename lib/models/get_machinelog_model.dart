// To parse this JSON data, do
//
//     final getMachineLogModel = getMachineLogModelFromMap(jsonString);

import 'dart:convert';

GetMachineLogModel getMachineLogModelFromMap(String str) =>
    GetMachineLogModel.fromMap(json.decode(str));

String getMachineLogModelToMap(GetMachineLogModel data) =>
    json.encode(data.toMap());

class GetMachineLogModel {
  String code;
  String message;
  Data data;

  GetMachineLogModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory GetMachineLogModel.fromMap(Map<String, dynamic> json) =>
      GetMachineLogModel(
        code: json["code"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class Data {
  AggregateReport aggregateReport;
  List<MachineLog> machineLogs;
  int totalCount;

  Data({
    required this.aggregateReport,
    required this.machineLogs,
    required this.totalCount,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    aggregateReport: AggregateReport.fromMap(json["aggregateReport"]),
    machineLogs: List<MachineLog>.from(
      json["machineLogs"].map((x) => MachineLog.fromMap(x)),
    ),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toMap() => {
    "aggregateReport": aggregateReport.toMap(),
    "machineLogs": List<dynamic>.from(machineLogs.map((x) => x.toMap())),
    "totalCount": totalCount,
  };
}

class AggregateReport {
  int efficiency;
  int pick;
  int avgSpeed;
  int avgPicks;
  int running;
  int stopped;
  int all;

  AggregateReport({
    required this.efficiency,
    required this.pick,
    required this.avgSpeed,
    required this.avgPicks,
    required this.running,
    required this.stopped,
    required this.all,
  });

  factory AggregateReport.fromMap(Map<String, dynamic> json) => AggregateReport(
    efficiency: json["efficiency"],
    pick: json["pick"],
    avgSpeed: json["avgSpeed"],
    avgPicks: json["avgPicks"],
    running: json["running"],
    stopped: json["stopped"],
    all: json["all"],
  );

  Map<String, dynamic> toMap() => {
    "efficiency": efficiency,
    "pick": pick,
    "avgSpeed": avgSpeed,
    "avgPicks": avgPicks,
    "running": running,
    "stopped": stopped,
    "all": all,
  };
}

class MachineLog {
  String machineName;
  int efficiency;
  int picks;
  int speed;
  double pieceLengthM;
  int stops;
  int beamLeft;
  int setPicks;
  StopsData stopsData;
  String totalDuration;

  MachineLog({
    required this.machineName,
    required this.efficiency,
    required this.picks,
    required this.speed,
    required this.pieceLengthM,
    required this.stops,
    required this.beamLeft,
    required this.setPicks,
    required this.stopsData,
    required this.totalDuration,
  });

  factory MachineLog.fromMap(Map<String, dynamic> json) => MachineLog(
    machineName: json["machineName"],
    efficiency: json["efficiency"],
    picks: json["picks"],
    speed: json["speed"],
    pieceLengthM: json["pieceLengthM"]?.toDouble(),
    stops: json["stops"],
    beamLeft: json["beamLeft"],
    setPicks: json["setPicks"],
    stopsData: StopsData.fromMap(json["stopsData"]),
    totalDuration: json["totalDuration"],
  );

  Map<String, dynamic> toMap() => {
    "machineName": machineName,
    "efficiency": efficiency,
    "picks": picks,
    "speed": speed,
    "pieceLengthM": pieceLengthM,
    "stops": stops,
    "beamLeft": beamLeft,
    "setPicks": setPicks,
    "stopsData": stopsData.toMap(),
    "totalDuration": totalDuration,
  };
}

class StopsData {
  Feeder warp;
  Feeder weft;
  Feeder feeder;
  Feeder manual;
  Feeder other;
  Feeder total;

  StopsData({
    required this.warp,
    required this.weft,
    required this.feeder,
    required this.manual,
    required this.other,
    required this.total,
  });

  factory StopsData.fromMap(Map<String, dynamic> json) => StopsData(
    warp: Feeder.fromMap(json["warp"]),
    weft: Feeder.fromMap(json["weft"]),
    feeder: Feeder.fromMap(json["feeder"]),
    manual: Feeder.fromMap(json["manual"]),
    other: Feeder.fromMap(json["other"]),
    total: Feeder.fromMap(json["total"]),
  );

  Map<String, dynamic> toMap() => {
    "warp": warp.toMap(),
    "weft": weft.toMap(),
    "feeder": feeder.toMap(),
    "manual": manual.toMap(),
    "other": other.toMap(),
    "total": total.toMap(),
  };
}

class Feeder {
  int count;
  String duration;

  Feeder({required this.count, required this.duration});

  factory Feeder.fromMap(Map<String, dynamic> json) =>
      Feeder(count: json["count"], duration: json["duration"] ?? '');

  Map<String, dynamic> toMap() => {"count": count, "duration": duration};
}
