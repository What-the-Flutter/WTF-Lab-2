import 'package:intl/intl.dart';



extension MonthDateYear on DateTime{
  String mmddyy() {
     return  DateFormat.yMMMMd().format(this);
    }
}
