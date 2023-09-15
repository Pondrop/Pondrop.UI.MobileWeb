import 'package:flutter_test/flutter_test.dart';
import 'package:pondrop/extensions/date_time_extensions.dart';

void main() {
  setUp(() {});

  test('get date only', () {
    final now = DateTime.now();
    final dateOnly = DateTime(now.year, now.month, now.day);

    expect(now.date(), dateOnly);
  });

  test('get time only', () {
    final now = DateTime.now();
    final timeOnly = Duration(
        hours: now.hour,
        minutes: now.minute,
        seconds: now.second,
        milliseconds: now.millisecond,
        microseconds: now.microsecond);

    expect(now.time(), timeOnly);
  });
}
