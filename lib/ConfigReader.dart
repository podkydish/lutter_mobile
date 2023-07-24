import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';

class ConfigReader {
  int recordsOnPage = 1000;

  Future<void> readAndParseConfig() async {
    try {
      String jsonString;
      log('чтение конфигурационного файла');
      jsonString = await rootBundle.loadString('config/config.json');
      if (jsonString.isNotEmpty) {
        recordsOnPage = json.decode(jsonString)['config']['rec_on_page'];
        // log(recordsOnPage.toString());
      } else {
        log('не нашли конфигурационный файл файл(((${DateTime.now()}');
      }
    } catch (e) {
      log('Ошибка при чтении и парсинге файла JSON: $e');
    }
  }
}
