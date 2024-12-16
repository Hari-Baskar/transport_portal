
import 'package:intl/intl.dart';
String googleMapsApi="AIzaSyDtOzjLoQc0r8ABdx-PUs9hBaKl3yAMQyo";

DateTime currentDateTime=DateTime.now();
String date=DateFormat("dd-MM-yyyy").format(currentDateTime);
String yesterdayDate= DateFormat("dd-MM-yyyy").format(currentDateTime.subtract(Duration(days: 1)));

