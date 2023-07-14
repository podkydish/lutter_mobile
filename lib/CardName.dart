import 'dart:developer';

import 'package:intl/intl.dart';

import 'main.dart';

class CardName {
  String settingNameToCard(int index) {
    switch (index) {
      case 0:
        return 'Резерв';
      case 1:
        return 'Штатно';
      case 2:
        return 'Сигнализация';
      case 3:
        return 'Риск аварии';
      case 4:
        return 'Критические события';
      case 5:
        return 'Нет данных';
      case 6:
        return '';
      case 7:
        return 'Резерв';
      default:
        log('вышли из допустимых индексов');
        return '';
    }
  }

  String getTimeText(String timeValue, TimeRange selectedTimeRange) {
    if (selectedTimeRange == TimeRange.hour) {
      final DateTime now =
      DateTime.now().toLocal().add(const Duration(hours: 3));
      final DateTime eventTime =
      DateTime.fromMillisecondsSinceEpoch(int.parse(timeValue) * 1000)
          .toUtc();
      final int minutesAgo =
          (now.millisecondsSinceEpoch - eventTime.millisecondsSinceEpoch) ~/
              60000;

      return '$minutesAgo мин. назад';
    } else if (selectedTimeRange == TimeRange.today) {
      var date =
      DateTime.fromMillisecondsSinceEpoch(int.parse(timeValue) * 1000)
          .toUtc();
      final String formattedTime = DateFormat('HH:mm:ss').format(date);
      return formattedTime;
    } else if (selectedTimeRange == TimeRange.yesterday ||selectedTimeRange == TimeRange.week || selectedTimeRange == TimeRange.month || selectedTimeRange == TimeRange.year) {
      final DateTime eventTime =
      DateTime.fromMillisecondsSinceEpoch(int.parse(timeValue) * 1000)
          .toUtc();
      final String formattedDateTime =
      DateFormat('HH:mm:ss dd.MM.yy ').format(eventTime);
      return formattedDateTime;
    } else {
      return timeValue;
    }
  }
}