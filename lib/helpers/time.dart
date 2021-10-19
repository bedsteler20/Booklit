import 'package:plexlit/plexlit.dart';
List<String> _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

extension DateTimeExtension on DateTime {
  String get monthDayString => "$monthString $day";
  String get monthString => _months[month - 1];
}
