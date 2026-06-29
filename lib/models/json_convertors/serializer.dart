import 'package:flutter/material.dart' show TimeOfDay;
import 'package:json_annotation/json_annotation.dart';

import '../../utils/extensions/num.extension.dart';

export 'package:json_annotation/json_annotation.dart';

part 'bool.parser.dart';
part 'date.parser.dart';
part 'double.parser.dart';
part 'duration.parser.dart';
part 'int.parser.dart';
part 'num.parser.dart';
part 'string.parser.dart';
part 'time.parser.dart';

/// This is custom json serializer which can fit almost 80% of our json responses. Use it instead of [JsonSerializable].
/// ^_^ with [CustomSerializer] all fields are considered snake case in json and which is written in camelCase in model.
// ignore: constant_identifier_names
const JsonSerializable CustomSerializer = JsonSerializable(
  createToJson: false,
  converters: [
    BoolParser.falseV(),
    IntParser(),
    DoubleParser(),
    NumParser(),
    DateParser(),
    DurationParser.full(),
    TimeParser(),
  ],
);

/// You can also extend our base serializer and modify it to fit those edge case models like this.
// final JsonSerializable categorySe = CustomSerializer..converters?.add(const DateParser());
