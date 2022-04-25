import 'package:intl/intl.dart';

extension MonthDateYear on DateTime {
  String mmdd() {
    return DateFormat.MMMMd().format(this);
  }
}
