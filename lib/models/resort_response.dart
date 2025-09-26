// To parse this JSON data, do
//
//     final reportsResponse = reportsResponseFromMap(jsonString);

import 'dart:convert';

ReportsResponse reportsResponseFromMap(String str) =>
    ReportsResponse.fromMap(json.decode(str));

String reportsResponseToMap(ReportsResponse data) => json.encode(data.toMap());

class ReportsResponse {
  String code;
  String message;
  Data data;

  ReportsResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ReportsResponse.fromMap(Map<String, dynamic> json) => ReportsResponse(
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
  List<DataList> list;
  int totalPicks;
  int totalEfficiency;
  double avgProdMeter;
  int avgPicks;

  Data({
    required this.list,
    required this.totalPicks,
    required this.totalEfficiency,
    required this.avgProdMeter,
    required this.avgPicks,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    list: List<DataList>.from(json["list"].map((x) => DataList.fromMap(x))),
    totalPicks: json["totalPicks"],
    totalEfficiency: json["totalEfficiency"],
    avgProdMeter: json["avgProdMeter"]?.toDouble(),
    avgPicks: json["avgPicks"],
  );

  Map<String, dynamic> toMap() => {
    "list": List<dynamic>.from(list.map((x) => x.toMap())),
    "totalPicks": totalPicks,
    "totalEfficiency": totalEfficiency,
    "avgProdMeter": avgProdMeter,
    "avgPicks": avgPicks,
  };
}

class DataList {
  DateTime reportDate;
  ReportData reportData;

  DataList({required this.reportDate, required this.reportData});

  factory DataList.fromMap(Map<String, dynamic> json) => DataList(
    reportDate: DateTime.parse(json["reportDate"]),
    reportData: ReportData.fromMap(json["reportData"]),
  );

  Map<String, dynamic> toMap() => {
    "reportDate": reportDate.toIso8601String(),
    "reportData": reportData.toMap(),
  };
}

class ReportData {
  Shift dayShift;
  Shift nightShift;

  ReportData({required this.dayShift, required this.nightShift});

  factory ReportData.fromMap(Map<String, dynamic> json) => ReportData(
    dayShift: Shift.fromMap(json["dayShift"]),
    nightShift: Shift.fromMap(json["nightShift"]),
  );

  Map<String, dynamic> toMap() => {
    "dayShift": dayShift.toMap(),
    "nightShift": nightShift.toMap(),
  };
}

class Shift {
  List<DayShiftList> list;
  int totalPicks;
  int efficiency;
  double prodMeter;
  int avgPicks;

  Shift({
    required this.list,
    required this.totalPicks,
    required this.efficiency,
    required this.prodMeter,
    required this.avgPicks,
  });

  factory Shift.fromMap(Map<String, dynamic> json) => Shift(
    list: List<DayShiftList>.from(
      json["list"].map((x) => DayShiftList.fromMap(x)),
    ),
    totalPicks: json["totalPicks"],
    efficiency: json["efficiency"],
    prodMeter: json["prodMeter"]?.toDouble(),
    avgPicks: json["avgPicks"],
  );

  Map<String, dynamic> toMap() => {
    "list": List<dynamic>.from(list.map((x) => x.toMap())),
    "totalPicks": totalPicks,
    "efficiency": efficiency,
    "prodMeter": prodMeter,
    "avgPicks": avgPicks,
  };
}

class DayShiftList {
  int shift;
  String machineCode;
  double pieceLengthM;
  int picksCurrentShift;
  double efficiencyPercent;
  String runTime;
  int beamLeft;
  StopsData stopsData;
  DateTime? reportDate;

  DayShiftList({
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

  factory DayShiftList.fromMap(Map<String, dynamic> json) => DayShiftList(
    shift: json["shift"],
    machineCode: json["machineCode"],
    pieceLengthM: json["pieceLengthM"]?.toDouble(),
    picksCurrentShift: json["picksCurrentShift"],
    efficiencyPercent: json["efficiencyPercent"]?.toDouble(),
    runTime: json["runTime"],
    beamLeft: json["beamLeft"],
    stopsData: StopsData.fromMap(json["stopsData"]),
    reportDate: json["reportDate"] == null
        ? null
        : DateTime.parse(json["reportDate"]),
  );

  Map<String, dynamic> toMap() => {
    "shift": shift,
    "machineCode": machineCode,
    "pieceLengthM": pieceLengthM,
    "picksCurrentShift": picksCurrentShift,
    "efficiencyPercent": efficiencyPercent,
    "runTime": runTime,
    "beamLeft": beamLeft,
    "stopsData": stopsData.toMap(),
    "reportDate": reportDate?.toIso8601String(),
  };
}

class StopsData {
  Feeder warp;
  Feeder weft;
  Feeder feeder;
  Feeder manual;
  Feeder other;

  StopsData({
    required this.warp,
    required this.weft,
    required this.feeder,
    required this.manual,
    required this.other,
  });

  factory StopsData.fromMap(Map<String, dynamic> json) => StopsData(
    warp: Feeder.fromMap(json["warp"]),
    weft: Feeder.fromMap(json["weft"]),
    feeder: Feeder.fromMap(json["feeder"]),
    manual: Feeder.fromMap(json["manual"]),
    other: Feeder.fromMap(json["other"]),
  );

  Map<String, dynamic> toMap() => {
    "warp": warp.toMap(),
    "weft": weft.toMap(),
    "feeder": feeder.toMap(),
    "manual": manual.toMap(),
    "other": other.toMap(),
  };
}

class Feeder {
  int count;
  Duration duration;

  Feeder({required this.count, required this.duration});

  factory Feeder.fromMap(Map<String, dynamic> json) => Feeder(
    count: json["count"],
    duration: durationValues.map[json["duration"]]!,
  );

  Map<String, dynamic> toMap() => {
    "count": count,
    "duration": durationValues.reverse[duration],
  };
}

enum Duration { THE_0045 }

final durationValues = EnumValues({"00:45": Duration.THE_0045});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
