import 'num.extension.dart';

extension StringifyDuration on Duration {
  String get stringify {
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    return [
      if (hours > 0) hours.padded(),
      if (minutes > 0) minutes.padded(),
      if (seconds > 0) seconds.padded(),
    ].join(':');
  }
}
