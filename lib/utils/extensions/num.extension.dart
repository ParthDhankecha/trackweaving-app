import 'string.extension.dart';

extension NumExtension on num {
  num percent(num per) => this * per / 100;
  num savings(num reducedPrice) => (this - reducedPrice) * 100 / this;
  num addPercent(num per) => this + (this * per / 100);
  num subPercent(num per) => this - (this * per / 100);

  String padded([int padding = 2]) => '$this'.padLeft(2, '0');

  String toStringPro({int place = 2}) {
    return toStringAsFixed(place).replaceFirstMapped(RegExp(r'\.([1-9]?)0*$'), (
      match,
    ) {
      final value = match.group(1);
      return '${value.isNotEmpty ? '.' : ''}$value';
    });
  }
}
