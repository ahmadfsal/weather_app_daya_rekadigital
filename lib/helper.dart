import 'package:intl/intl.dart';
import 'package:weather_app_daya_rekadigital/model/cuaca_model.dart';

class MyHelper {
  static String dateToday() {
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd MMMM HH:mm').format(dateTime);

    return formattedDate;
  }

  static String formatTimeOnly(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formatOnlyTime = DateFormat('HH:mm').format(dateTime);

    return formatOnlyTime;
  }

  static bool isToday(String date) {
    DateTime now = DateTime.now();
    String formattedNow = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    DateTime parsedNow = DateTime.parse(formattedNow);

    DateTime fromParam = DateTime.parse(date);

    if (fromParam.isAfter(parsedNow)) {
      return false;
    }

    return true;
  }

  static CuacaModel getInitialCuaca(List<CuacaModel> list) {
    DateTime now = DateTime.now();
    int nowHour = int.parse(DateFormat('HH').format(now));
    int nowMinute = int.parse(DateFormat('mm').format(now));

    list.where((element) {
      DateTime dateTime = DateTime.parse(element.jamCuaca!);
      int itemHour = int.parse(DateFormat('HH').format(dateTime));
      int itemMinute = int.parse(DateFormat('mm').format(dateTime));

      return nowHour >= itemHour && nowMinute >= itemMinute;
    });

    return list.first;
  }
}
