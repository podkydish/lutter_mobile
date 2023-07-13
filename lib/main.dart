import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/ConfigReader.dart';
import 'package:untitled/text_styles.dart';

import 'CardName.dart';
import 'ColorChangingCircle.dart';
import 'DashedLine.dart';
import 'FilterData.dart';
import 'PopUpMenuChecks.dart';

enum TimeRange {
  hour,
  today,
  yesterday,
}

void main() {
  //debugPaintSizeEnabled = true; // режим отладки
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFFFFFFFF,
          <int, Color>{
            50: Color(0xFFEAEAEA),
            100: Color(0xFFD4D4D4),
            200: Color(0xFFBEBEBE),
            300: Color(0xFFA8A8A8),
            400: Color(0xFF929292),
            500: Color(0xFF7C7C7C),
            600: Color(0xFF666666),
            700: Color(0xFF505050),
            800: Color(0xFF3A3A3A),
            900: Color(0xFF242424),
          },
        ),
        primaryColor: const Color(0xFFFFFFFF),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController
      _controller; //Контроллер поле ввода номера страницы
  ConfigReader configReader = ConfigReader(); //Глобальные переменные
  Timer? searchTimer; // Переменная для хранения таймера
  String searchQuery = ''; //Поле поиска по карточкам
  List information = []; //Список карточек из json
  String firstPage = 'assets/1.txt';
  String secondPage = 'assets/2.txt';
  int selectedPage = 1;
  bool _isValid = true;
  int countOfPages = 2; //типа пришло от сервера

  TimeRange selectedTimeRange = TimeRange.hour; //поле выбора временного фильтра
//объявление индексов фильтров
  int blueFilterIndex = 0;
  int greenFilterIndex = 1;
  int yellowFilterIndex = 2;
  int redFilterIndex = 3;
  int purpleFilterIndex = 4;
  int greyFilterIndex = 5;
  int skyFilterIndex = 6;
  int c1FilterIndex = 7;
  int c2FilterIndex = 8;
  int c3FilterIndex = 9;
  int c4FilterIndex = 10;

  // список элементов фильтров
  late Map<Container, FilterData> filter;

  //список цветов
  ColorChangingCircle colorChangingCircle =
      const ColorChangingCircle(dataIndex: 0, colors: [
    Color(0xFF4285F4),
    Color(0xFF38C25D),
    Color(0xFFFFCA31),
    Color(0xFFEA4335),
    Color(0xFFAD2C72),
    Color(0xFF858B99),
    Color(0xFFD9E2EC),
    Color(0xFF4285F4),
  ]);

  @override
  void initState() {
    super.initState();
    _readAndParseJsonFile();
    configReader.readAndParseConfig();
    _controller = TextEditingController(text: selectedPage.toString());
    filter = {
      Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: colorChangingCircle.colors[blueFilterIndex],
        ),
      ): FilterData(false, 0),
      Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: colorChangingCircle.colors[greenFilterIndex],
        ),
      ): FilterData(false, 1),
      Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: colorChangingCircle.colors[yellowFilterIndex],
        ),
      ): FilterData(false, 2),
      Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: colorChangingCircle.colors[redFilterIndex],
        ),
      ): FilterData(false, 3),
      Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: colorChangingCircle.colors[purpleFilterIndex],
        ),
      ): FilterData(false, 4),
      Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: colorChangingCircle.colors[greyFilterIndex],
        ),
      ): FilterData(false, 5),
      Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: colorChangingCircle.colors[skyFilterIndex],
        ),
      ): FilterData(false, 6),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        height: 24,
        width: 24,
        child: const Text('C1'),
      ): FilterData(false, 7),
      Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: const Text('C2'),
      ): FilterData(false, 8),
      Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: const Text('C3'),
      ): FilterData(false, 9),
      Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: const Text('C4'),
      ): FilterData(false, 10),
    };
  }

  Future<void> _readAndParseJsonFile() async {
    log((DateTime.now().add(DateTime.now().timeZoneOffset)).toString());
    try {
      String jsonString;
      log('execute json with time filter $selectedTimeRange and page $selectedPage');
      if (selectedPage == 1) {
        jsonString = await rootBundle.loadString(firstPage);
      } else {
        jsonString = await rootBundle.loadString(secondPage);
      }

      if (jsonString.isNotEmpty) {
        List allInformation = json.decode(jsonString)['data']['alerts'];
        List filteredInformation = [];
        List colorFilter = [];
        List searchFilter = [];
        int counter = 0;
        int searchCounter = 0;

        if (selectedTimeRange == TimeRange.hour) {
          filteredInformation = allInformation
              .where((info) =>
                  DateTime.now()
                      .toLocal()
                      .add(const Duration(hours: 3))
                      .difference(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(info['time_value']) * 1000,
                        ),
                      ) <
                  const Duration(hours: 1))
              .toList();
        } else if (selectedTimeRange == TimeRange.today) {
          filteredInformation = allInformation
              .where((info) =>
                  DateTime.now().toLocal().add(const Duration(hours: 3)).day ==
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(info['time_value']) * 1000,
                  ).day)
              .toList();
        } else if (selectedTimeRange == TimeRange.yesterday) {
          filteredInformation = allInformation
              .where((info) =>
                  DateTime.now()
                      .toLocal()
                      .add(const Duration(hours: 3))
                      .subtract(const Duration(days: 1))
                      .day ==
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(info['time_value']) * 1000,
                  ).day)
              .toList();
        }
        if (filteredInformation.isNotEmpty) {
          for (int i = 0; i < filteredInformation.length; i++) {
            //фильтр информации
            var element = filteredInformation[i];
            for (int j = 0; j < filter.length; j++) {
              if (filter.values.elementAt(j).booleanValue == true) {
                counter++;
                if (j <= skyFilterIndex) {
                  if (element['state'] == j) {
                    colorFilter.add(element);
                    if (j == blueFilterIndex) {
                      colorFilter += filteredInformation
                          .where((info) => info['state'] == 7)
                          .toList();
                    }
                    break;
                  }
                } else if (c1FilterIndex <= j && j <= c4FilterIndex) {
                  if (element['label'] == indexIntoLabel(j)) {
                    colorFilter.add(element);
                    break;
                  }
                }
              }
            }
          }
        }
        if (filteredInformation.isNotEmpty && searchQuery.isNotEmpty) {
          if (colorFilter.isEmpty) {
            colorFilter = filteredInformation;
          }
          for (int i = 0; i < colorFilter.length; i++) {
            String name = colorFilter[i]['name'].toLowerCase();
            String targetName = colorFilter[i]['target_name'].toLowerCase();
            String query = searchQuery.toLowerCase();
            if (name.contains(query) || targetName.contains(query)) {
              searchFilter.add(colorFilter[i]);
              searchCounter++;
            }
          }
        }
        setState(() {
          if (searchQuery.isNotEmpty && searchFilter.isEmpty) {
            information = [];
          } else if (searchFilter.isNotEmpty) {
            information =
                searchFilter.take(configReader.recordsOnPage).toList();
          } else if (counter != 0) {
            information = colorFilter.take(configReader.recordsOnPage).toList();
          } else {
            information =
                filteredInformation.take(configReader.recordsOnPage).toList();
          }
        });
      } else {
        log('не нашли файл(((${DateTime.now()}');
      }
    } catch (e) {
      log('Ошибка при чтении и парсинге файла JSON: $e');
    }
  }

  String indexIntoLabel(int index) {
    switch (index) {
      case 7:
        return 'C1';
      case 8:
        return 'C2';
      case 9:
        return 'C3';
      case 10:
        return 'C4';
      default:
        log('вышли за пределы индексации');
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey popupMenuKey = GlobalKey();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTimeRange = TimeRange.hour;
                            selectedPage = 1;
                            _controller.text = selectedPage.toString();
                            _readAndParseJsonFile();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation:
                              selectedTimeRange == TimeRange.hour ? 2.0 : 0.0,
                          backgroundColor: selectedTimeRange == TimeRange.hour
                              ? const Color(0xFF93959A)
                              : const Color(0xFFF0F1F2),
                          foregroundColor: selectedTimeRange == TimeRange.hour
                              ? const Color(0xFFF0F1F2)
                              : const Color(0xFF93959A),
                          textStyle: AppTextStyles.defaultTextStyle,
                        ),
                        child: const Text('Час'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedPage = 1;
                            selectedTimeRange = TimeRange.today;
                            _controller.text = selectedPage.toString();
                            _readAndParseJsonFile();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation:
                              selectedTimeRange == TimeRange.today ? 2.0 : 0.0,
                          backgroundColor: selectedTimeRange == TimeRange.today
                              ? const Color(0xFF93959A)
                              : const Color(0xFFF0F1F2),
                          foregroundColor: selectedTimeRange == TimeRange.today
                              ? const Color(0xFFF0F1F2)
                              : const Color(0xFF93959A),
                          textStyle: AppTextStyles.defaultTextStyle,
                        ),
                        child: const Text('Сегодня'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedPage = 1;
                            selectedTimeRange = TimeRange.yesterday;
                            _controller.text = selectedPage.toString();
                            _readAndParseJsonFile();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor:
                                selectedTimeRange == TimeRange.yesterday
                                    ? const Color(0xFFF0F1F2)
                                    : const Color(0xFF93959A),
                            backgroundColor:
                                selectedTimeRange == TimeRange.yesterday
                                    ? const Color(0xFF93959A)
                                    : const Color(0xFFF0F1F2),
                            elevation: selectedTimeRange == TimeRange.yesterday
                                ? 2.0
                                : 0.0,
                            textStyle: AppTextStyles.defaultTextStyle),
                        child: const Text('Вчера'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: const Color(0xFFFFFFFF),
                        border: Border.all(
                          color: const Color(0xFFE3E3E3),
                          width: 1.0,
                        ),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          //проверяем на таймер, и если нет, то запускаем
                          if (searchTimer != null && searchTimer!.isActive) {
                            searchTimer!.cancel();
                          }

                          searchTimer =
                              Timer(const Duration(milliseconds: 500), () {
                            setState(() {
                              searchQuery = value;
                            });

                            _readAndParseJsonFile();
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Поиск',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF93959A),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1e000000),
                          offset: Offset(0, 4),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: PopupMenuButton<String>(
                      onCanceled: () {
                        _readAndParseJsonFile();
                      },
                      constraints: const BoxConstraints.expand(width: 334, height: 230),
                      padding: EdgeInsets.zero,
                      key: popupMenuKey,
                      icon: hasTrueValue(filter)
                          ? SvgPicture.asset(
                        'assets/filter_add.svg',
                        width: 24,
                        height: 24,
                      )
                          : const Icon(
                        Icons.filter_alt,
                        color: Color(0xFF93959A),
                      ),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopUpMenuChecks<String>(
                            child: StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return Column(
                                    children: [
                                      const Text('Фильтры по состоянию', style: AppTextStyles.defaultTextStyle,),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: filter.values
                                                .firstWhere((filterData) =>
                                            filterData.intValue == blueFilterIndex)
                                                .booleanValue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                filter.values
                                                    .where((filterData) =>
                                                filterData.intValue == blueFilterIndex)
                                                    .forEach((filterData) {
                                                  filterData.booleanValue = value;
                                                });
                                              });
                                              popupMenuKey.currentState?.setState(() {});
                                            },
                                          ),
                                          Container(
                                            color: colorChangingCircle.colors[blueFilterIndex],
                                            width: 16,
                                            height: 16,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                      Checkbox(
                                        value: filter.values
                                            .firstWhere((filterData) =>
                                                filterData.intValue ==
                                                greenFilterIndex)
                                            .booleanValue,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            filter.values
                                                .where((filterData) =>
                                                    filterData.intValue ==
                                                    greenFilterIndex)
                                                .forEach((filterData) {
                                              filterData.booleanValue = value;
                                            });
                                          });
                                        },
                                      ),
                                      Container(
                                        color: colorChangingCircle
                                            .colors[greenFilterIndex],
                                        width: 16,
                                        height: 16,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Checkbox(
                                        value: filter.values
                                            .firstWhere((filterData) =>
                                                filterData.intValue ==
                                                yellowFilterIndex)
                                            .booleanValue,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            filter.values
                                                .where((filterData) =>
                                                    filterData.intValue ==
                                                    yellowFilterIndex)
                                                .forEach((filterData) {
                                              filterData.booleanValue = value;
                                            });
                                          });
                                        },
                                      ),
                                      Container(
                                        color: colorChangingCircle
                                            .colors[yellowFilterIndex],
                                        width: 16,
                                        height: 16,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Checkbox(
                                        value: filter.values
                                            .firstWhere((filterData) =>
                                                filterData.intValue ==
                                                redFilterIndex)
                                            .booleanValue,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            filter.values
                                                .where((filterData) =>
                                                    filterData.intValue ==
                                                    redFilterIndex)
                                                .forEach((filterData) {
                                              filterData.booleanValue = value;
                                            });
                                          });
                                        },
                                      ),
                                      Container(
                                        color: colorChangingCircle
                                            .colors[redFilterIndex],
                                        width: 16,
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: filter.values
                                            .firstWhere((filterData) =>
                                                filterData.intValue ==
                                                purpleFilterIndex)
                                            .booleanValue,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            filter.values
                                                .where((filterData) =>
                                                    filterData.intValue ==
                                                    purpleFilterIndex)
                                                .forEach((filterData) {
                                              filterData.booleanValue = value;
                                            });
                                          });
                                        },
                                      ),
                                      Container(
                                        color: colorChangingCircle
                                            .colors[purpleFilterIndex],
                                        width: 16,
                                        height: 16,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Checkbox(
                                        value: filter.values
                                            .firstWhere((filterData) =>
                                                filterData.intValue ==
                                                greyFilterIndex)
                                            .booleanValue,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            filter.values
                                                .where((filterData) =>
                                                    filterData.intValue ==
                                                    greyFilterIndex)
                                                .forEach((filterData) {
                                              filterData.booleanValue = value;
                                            });
                                          });
                                        },
                                      ),
                                      Container(
                                        color: colorChangingCircle
                                            .colors[greyFilterIndex],
                                        width: 16,
                                        height: 16,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Checkbox(
                                        value: filter.values
                                            .firstWhere((filterData) =>
                                                filterData.intValue ==
                                                skyFilterIndex)
                                            .booleanValue,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            filter.values
                                                .where((filterData) =>
                                                    filterData.intValue ==
                                                    skyFilterIndex)
                                                .forEach((filterData) {
                                              filterData.booleanValue = value;
                                            });
                                          });
                                        },
                                      ),
                                      Container(
                                        color: colorChangingCircle
                                            .colors[skyFilterIndex],
                                        width: 16,
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: const Color(0xFFE3E3E3),
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: filter.values
                                            .firstWhere((filterData) =>
                                                filterData.intValue ==
                                                c1FilterIndex)
                                            .booleanValue,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            filter.values
                                                .where((filterData) =>
                                                    filterData.intValue ==
                                                    c1FilterIndex)
                                                .forEach((filterData) {
                                              filterData.booleanValue = value;
                                            });
                                          });
                                        },
                                      ),
                                      const Text("C1"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Checkbox(
                                        value: filter.values
                                            .firstWhere((filterData) =>
                                                filterData.intValue ==
                                                c2FilterIndex)
                                            .booleanValue,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            filter.values
                                                .where((filterData) =>
                                                    filterData.intValue ==
                                                    c2FilterIndex)
                                                .forEach((filterData) {
                                              filterData.booleanValue = value;
                                            });
                                          });
                                        },
                                      ),
                                      const Text('C2'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Checkbox(
                                        value: filter.values
                                            .firstWhere((filterData) =>
                                                filterData.intValue ==
                                                c3FilterIndex)
                                            .booleanValue,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            filter.values
                                                .where((filterData) =>
                                                    filterData.intValue ==
                                                    c3FilterIndex)
                                                .forEach((filterData) {
                                              filterData.booleanValue = value;
                                            });
                                          });
                                        },
                                      ),
                                      const Text('C3'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Checkbox(
                                        value: filter.values
                                            .firstWhere((filterData) =>
                                                filterData.intValue ==
                                                c4FilterIndex)
                                            .booleanValue,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            filter.values
                                                .where((filterData) =>
                                                    filterData.intValue ==
                                                    c4FilterIndex)
                                                .forEach((filterData) {
                                              filterData.booleanValue = value;
                                            });
                                          });
                                        },
                                      ),
                                      const Text('C4'),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: const Color(0xFFE3E3E3),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        _readAndParseJsonFile();
                                        try {
                                          Navigator.pop(context);
                                        } catch (e) {
                                          log('$e');
                                        }
                                      },
                                      child: const Text(
                                        'Применить',
                                        style: AppTextStyles.boldTextStyle,
                                      ))
                                ],
                              );
                            }),
                          ),
                        ];
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                alignment: Alignment.topLeft, // Align the Wrap to the top left
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: filter.entries
                      .where((entry) => entry.value.booleanValue == true)
                      .map(
                        (entry) => Material(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                entry.value.booleanValue = false;
                                _readAndParseJsonFile();
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 4),
                                  width: 24,
                                  height: 24,
                                  child: entry.key,
                                ),
                                const SizedBox(width: 4),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 24,
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        entry.value.booleanValue = false;
                                        _readAndParseJsonFile();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GestureDetector(
                onHorizontalDragUpdate: _handleSwipe, // Обработка свайпа
                child: ListView.builder(
                  itemExtent: 148,
                  itemCount: information.length,
                  itemBuilder: (context, index) {
                    int stateIndex = information[index]['state'];
                    final Color nowColor =
                        colorChangingCircle.colors[stateIndex];
                    return Card(
                      elevation: 0,
                      color: const Color(0xFFFFFFFF),
                      shadowColor: Colors.transparent,
                      margin: const EdgeInsets.all(0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          border: Border(
                            bottom: const BorderSide(color: Color(0xFFE3E3E3)),
                            left: BorderSide(
                              color: nowColor,
                              width: 6,
                            ),
                          ),
                        ),
                        child: ListTile(
                          subtitle: Row(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: 8,),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      height: 16,
                                      width: 16,
                                      decoration: BoxDecoration(
                                        color: nowColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1,
                                    child: Column(
                                      children: [
                                        DashedLine(
                                          color: nowColor,
                                          height: 116,
                                          dashWidth: 1.0,
                                          dashSpace: 1.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Column(
                                children: [
                                  SizedBox(
                                    width: 8,
                                  )
                                ],
                              ),
                              Expanded(
                                /*child: Align(
              alignment: Alignment.topLeft,*/
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8,),
                                    Text(
                                      CardName().settingNameToCard(
                                          information[index]['state']),
                                      style: AppTextStyles.boldTextStyle,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                      child: Text(
                                        information[index]['name'].toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.rearTextStyle,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.fromLTRB(0, 4, 0, 0),child:
                                    Text(
                                      information[index]['target_name']
                                          .toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.underTextStyle,
                                    ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 4, 0, 16),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          // Align the text at the bottom left
                                          child: Text(
                                            CardName().getTimeText(
                                              information[index]['time_value'],
                                              selectedTimeRange,
                                            ),
                                            style: AppTextStyles.rearTextStyle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //),
                              ),
                            ],
                          ),
                          onLongPress: () {
                            showDialog(
                              //карточка подробной информации
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: const EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    // Установка ширины контейнера равной ширине экрана
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  Container(
                                                    height: 16,
                                                    width: 16,
                                                    decoration: BoxDecoration(
                                                      color: nowColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  /*DashedLine(
                                                      //todo make dynamic height
                                                      color: nowColor,
                                                      height: 150)*/
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    Text(
                                                      CardName()
                                                          .settingNameToCard(
                                                              information[index]
                                                                  ['state']),
                                                      style: AppTextStyles.boldTextStyle,
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    information[index]['name']
                                                            .toString()
                                                            .isNotEmpty
                                                        ? Column(children: [
                                                            Row(children: [
                                                              Flexible(
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        "Имя устройства: ",
                                                                    style:
                                                                    AppTextStyles.boldTextStyle,
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: information[index]['name']
                                                                            .toString(),
                                                                        style:
                                                                        AppTextStyles.additionalText,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ])
                                                          ])
                                                        : const SizedBox
                                                            .shrink(),
                                                    information[index]
                                                                ['target_name']
                                                            .toString()
                                                            .isNotEmpty
                                                        ? Column(children: [
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Row(children: [
                                                              Flexible(
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        "Имя целевого объекта: ",
                                                                    style:
                                                                    AppTextStyles.boldTextStyle,
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: information[index]['target_name']
                                                                            .toString(),
                                                                        style:
                                                                          AppTextStyles.linkText,
                                                                        recognizer:
                                                                            TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                showDialog(
                                                                                    //карточка подробной информации
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return Dialog(
                                                                                          insetPadding: const EdgeInsets.all(10),
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                                          ),
                                                                                          child: SizedBox(
                                                                                            width: double.infinity,
                                                                                            height: double.infinity,
                                                                                            // Установка ширины контейнера равной ширине экрана
                                                                                            child: Container(
                                                                                                width: 150,
                                                                                                height: 150,
                                                                                                child: const Align(
                                                                                                  alignment: Alignment.center,
                                                                                                  child: Text('График'),
                                                                                                )),
                                                                                          ));
                                                                                    });
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ])
                                                          ])
                                                        : const SizedBox
                                                            .shrink(),
                                                    information[index]['ip']
                                                            .toString()
                                                            .isNotEmpty
                                                        ? Column(children: [
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          "IP-адрес: ",
                                                                      style:
                                                                      AppTextStyles.boldTextStyle,
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: information[index]
                                                                              [
                                                                              'ip'],
                                                                          style:
                                                                          AppTextStyles.additionalText,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ])
                                                        : const SizedBox
                                                            .shrink(),
                                                    information[index][
                                                                'alert_template']
                                                            .toString()
                                                            .isNotEmpty
                                                        ? Column(children: [
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Row(children: [
                                                              Flexible(
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        "Шаблон сигнала: ",
                                                                    style:
                                                                    AppTextStyles.boldTextStyle,
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: information[index]
                                                                            [
                                                                            'alert_template'],
                                                                        style:
                                                                        AppTextStyles.additionalText,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ])
                                                          ])
                                                        : const SizedBox.shrink(),
                                                    information[index]
                                                                ['subalert']
                                                            .toString()
                                                            .isNotEmpty
                                                        ? Column(children: [
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Row(children: [
                                                              Flexible(
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        "Сигнал: ",
                                                                    style:
                                                                    AppTextStyles.boldTextStyle,
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: information[index]
                                                                            [
                                                                            'subalert'],
                                                                        style:
                                                                        AppTextStyles.additionalText,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ])
                                                          ])
                                                        : const SizedBox.shrink(),
                                                    information[index]['value']
                                                            .toString()
                                                            .isNotEmpty
                                                        ? Column(children: [
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Row(children: [
                                                              Flexible(
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        "Значение: ",
                                                                    style:
                                                                    AppTextStyles.boldTextStyle,
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: information[index]['value'] +
                                                                            information[index]['units'],
                                                                        style:
                                                                        AppTextStyles.additionalText,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ])
                                                          ])
                                                        : const SizedBox.shrink(),
                                                    information[index]
                                                                ['description']
                                                            .toString()
                                                            .isNotEmpty
                                                        ? Column(children: [
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Row(children: [
                                                              Flexible(
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        "Описание: ",
                                                                    style:
                                                                    AppTextStyles.boldTextStyle,
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: information[index]
                                                                            [
                                                                            'description'],
                                                                        style:
                                                                        AppTextStyles.additionalText,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ])
                                                          ])
                                                        : const SizedBox.shrink(),
                                                    information[index]['label']
                                                            .toString()
                                                            .isNotEmpty
                                                        ? Column(children: [
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Row(children: [
                                                              Flexible(
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        "Метка: ",
                                                                    style:
                                                                    AppTextStyles.boldTextStyle,
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: information[index]
                                                                            [
                                                                            'label'],
                                                                        style:
                                                                        AppTextStyles.additionalText,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ])
                                                          ])
                                                        : const SizedBox.shrink(),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    Row(children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text: "Время: ",
                                                          style:
                                                          AppTextStyles.boldTextStyle,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: CardName()
                                                                  .getTimeText(
                                                                information[
                                                                        index][
                                                                    'time_value'],
                                                                selectedTimeRange,
                                                              ),
                                                              style:
                                                              AppTextStyles.additionalText,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    icon:
                                                        const Icon(Icons.close),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }, //onlongpress
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            //Поле навигации
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.max, // занимаем всю ширину экрана
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        selectedPage = 1;
                      });
                      _readAndParseJsonFile();
                      _controller.text = selectedPage.toString();
                    },
                    icon: const Icon(Icons.keyboard_double_arrow_left),
                    iconSize: 40,
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        if (selectedPage != 1) {
                          selectedPage -= 1;
                        }
                      });
                      _readAndParseJsonFile();
                      _controller.text = selectedPage.toString();
                    },
                    icon: const Icon(Icons.chevron_left),
                    iconSize: 40,
                  ),
                  const Text(
                    'Страница:',
                    style: AppTextStyles.boldTextStyle,
                  ),
                  Container(
                    // Используем SizedBox для установки ширины TextField
                    width: 20,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: TextField(
                      minLines: 1,
                      // Устанавливаем минимальное количество строк
                      maxLines: 1,
                      controller: _controller,
                      onChanged: _validateInput,
                      onSubmitted: _onSubmitted,
                      style: AppTextStyles.boldTextStyle,
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: _isValid
                              ? const BorderSide(color: Colors.grey)
                              : const BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: _isValid
                              ? const BorderSide(color: Colors.blue)
                              : const BorderSide(color: Colors.red),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 5), // Установка вертикального padding
                      ),
                    ),
                  ),
                  const Text(
                    ' из ',
                    style: AppTextStyles.boldTextStyle,
                  ),
                  Text(
                    countOfPages.toString(),
                    style: AppTextStyles.boldTextStyle,
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        if (selectedPage != countOfPages) {
                          selectedPage += 1;
                        }
                      });
                      _readAndParseJsonFile();
                      _controller.text = selectedPage.toString();
                    },
                    icon: const Icon(Icons.chevron_right),
                    iconSize: 40,
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        selectedPage = countOfPages;
                      });
                      _readAndParseJsonFile();
                      _controller.text = selectedPage.toString();
                    },
                    icon: const Icon(Icons.keyboard_double_arrow_right),
                    iconSize: 40,
                  ),
                  Text('${configReader.recordsOnPage}/30000'),
                  /*const SizedBox(
                      width: 16,
                    )*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateInput(String value) {
    setState(() {
      if (value.isNotEmpty &&
          int.tryParse(value) != null &&
          int.parse(value) > 0 &&
          int.parse(value) <= countOfPages) {
        _isValid = true;
      } else {
        _isValid = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmitted(String value) {
    // Обработка значения, когда пользователь нажимает клавишу "Готово" на клавиатуре
    // Можно выполнить дополнительную обработку или переход на другую страницу
    setState(() {
      if (value.isNotEmpty &&
          int.tryParse(value) != null &&
          int.parse(value) >= 0 &&
          int.parse(value) <= countOfPages) {
        selectedPage = int.parse(value);
      } else {
        _controller.text =
            selectedPage.toString(); // Восстановление предыдущего значения
      }
    });
    _readAndParseJsonFile();
  }

  void _handleSwipe(DragUpdateDetails details) {
    // Определение направления свайпа и изменение страницы в зависимости от направления
    if (details.primaryDelta != null) {
      if (details.primaryDelta! > 0) {
        // Свайп вправо
        setState(() {
          if (selectedPage != 1) {
            selectedPage--;
            _controller.text = selectedPage.toString();
          }
        });
        _readAndParseJsonFile();
      } else if (details.primaryDelta! < 0) {
        // Свайп влево
        setState(() {
          if (selectedPage != countOfPages) {
            selectedPage++;
            _controller.text = selectedPage.toString();
          }
        });
        _readAndParseJsonFile();
      }
    }
  }

  bool hasTrueValue(Map<Container, FilterData> filter) {
    for (final filterData in filter.values) {
      if (filterData.booleanValue == true) {
        return true;
      }
    }
    return false;
  }
}

// todo разобраться со временем now()
// стили до конца недели

/*Входные данный файл с json форматом, в котором для нормального функционирования должны иметься поля:
* 1. state
* 2. name
* 3. target_name
* 4. time-value
* 5. label*/
