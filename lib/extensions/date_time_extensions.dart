import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  DateTime date() {
    if (isUtc) {
      return DateTime.utc(year, month, day);
    } else {
      return DateTime(year, month, day);
    }
  }

  Duration time() {
    return Duration(
        hours: hour,
        minutes: minute,
        seconds: second,
        milliseconds: millisecond,
        microseconds: microsecond);
  }

  String toShortString(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final is24Hour = MediaQuery.of(context).alwaysUse24HourFormat;
    final fmt = DateFormat.yMd(locale);

    if (is24Hour) {
      return fmt.add_Hm().format(this);
    } else {
      return fmt.add_jm().format(this);
    }
  }

  String toLongString(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final is24Hour = MediaQuery.of(context).alwaysUse24HourFormat;
    final fmt = DateFormat.yMd(locale);

    if (is24Hour) {
      return fmt.add_Hms().format(this);
    } else {
      return fmt.add_jms().format(this);
    }
  }
}
