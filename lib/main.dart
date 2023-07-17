import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:untitled/ConfigReader.dart';
import 'package:untitled/widgets/FilterIndicator.dart';
import 'package:untitled/widgets/FilterMenu.dart';
import 'package:untitled/styles/text_styles.dart';

import 'CardItem.dart';
import 'CardName.dart';
import 'ColorChangingCircle.dart';
import 'widgets/DashedLine.dart';
import 'widgets/ExtendedInformationWidget.dart';
import 'FilterData.dart';

enum TimeRange { hour, today, yesterday, week, month, year }

void main() {
  //debugPaintSizeEnabled = true; // режим отладки стилей
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
        } else if (selectedTimeRange == TimeRange.week) {
          DateTime now = DateTime.now().toLocal();
          DateTime lastWeek = now.subtract(const Duration(days: 7));

          filteredInformation = allInformation
              .where((info) => DateTime.fromMillisecondsSinceEpoch(
                    int.parse(info['time_value']) * 1000,
                  ).isAfter(lastWeek))
              .toList();
        } else if (selectedTimeRange == TimeRange.month) {
          DateTime now = DateTime.now().toLocal();
          DateTime lastMonth = now.subtract(const Duration(days: 30));

          filteredInformation = allInformation
              .where((info) => DateTime.fromMillisecondsSinceEpoch(
                    int.parse(info['time_value']) * 1000,
                  ).isAfter(lastMonth))
              .toList();
        } else if (selectedTimeRange == TimeRange.year) {
          DateTime now = DateTime.now().toLocal();
          DateTime lastYear = now.subtract(const Duration(days: 365));

          filteredInformation = allInformation
              .where((info) => DateTime.fromMillisecondsSinceEpoch(
                    int.parse(info['time_value']) * 1000,
                  ).isAfter(lastYear))
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
            }
          }
        }
        setState(() {
          if (searchQuery.isNotEmpty && searchFilter.isEmpty) {
            information = [];
          } else if (searchFilter.isNotEmpty) {
            information =
                searchFilter.take(configReader.recordsOnPage).map((item) {
              return CardItem(
                state: item['state'],
                name: item['name'].toString(),
                targetName: item['target_name'].toString(),
                timeValue: item['time_value'],
                alert: item['alert_template'].toString(),
                subalert: item['subalert'].toString(),
                value: (item['value'] + item['units']).toString(),
                description: item['description'].toString(),
                label: item['label'].toString(),
                ip: item['ip'].toString(),
                isExpanded: false, // Изначально карточка свернута
              );
            }).toList();
          } else if (counter != 0) {
            information =
                colorFilter.take(configReader.recordsOnPage).map((item) {
              return CardItem(
                state: item['state'],
                name: item['name'].toString(),
                targetName: item['target_name'].toString(),
                timeValue: item['time_value'],
                alert: item['alert_template'].toString(),
                subalert: item['subalert'].toString(),
                value: (item['value'] + item['units']).toString(),
                description: item['description'].toString(),
                label: item['label'].toString(),
                ip: item['ip'].toString(),
                isExpanded: false, // Изначально карточка свернута
              );
            }).toList();
          } else {
            information = filteredInformation
                .take(configReader.recordsOnPage)
                .map((item) {
              return CardItem(
                state: item['state'],
                name: item['name'].toString(),
                targetName: item['target_name'].toString(),
                timeValue: item['time_value'],
                alert: item['alert_template'].toString(),
                subalert: item['subalert'].toString(),
                value: (item['value'] + item['units']).toString(),
                description: item['description'].toString(),
                label: item['label'].toString(),
                ip: item['ip'].toString(),
                isExpanded: false, // Изначально карточка свернута
              );
            }).toList();
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 100,
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
                              elevation: selectedTimeRange == TimeRange.hour
                                  ? 2.0
                                  : 0.0,
                              backgroundColor:
                                  selectedTimeRange == TimeRange.hour
                                      ? const Color(0xFF93959A)
                                      : const Color(0xFFF0F1F2),
                              foregroundColor:
                                  selectedTimeRange == TimeRange.hour
                                      ? const Color(0xFFF0F1F2)
                                      : const Color(0xFF93959A),
                              textStyle: AppTextStyles.defaultTextStyle,
                            ),
                            child: const Text('Час'),
                          )),
                      SizedBox(
                        width: 100,
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
                            elevation: selectedTimeRange == TimeRange.today
                                ? 2.0
                                : 0.0,
                            backgroundColor:
                                selectedTimeRange == TimeRange.today
                                    ? const Color(0xFF93959A)
                                    : const Color(0xFFF0F1F2),
                            foregroundColor:
                                selectedTimeRange == TimeRange.today
                                    ? const Color(0xFFF0F1F2)
                                    : const Color(0xFF93959A),
                            textStyle: AppTextStyles.defaultTextStyle,
                          ),
                          child: const Text('Сегодня'),
                        ),
                      ),
                      SizedBox(
                        width: 100,
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
                              elevation:
                                  selectedTimeRange == TimeRange.yesterday
                                      ? 2.0
                                      : 0.0,
                              textStyle: AppTextStyles.defaultTextStyle),
                          child: const Text('Вчера'),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedPage = 1;
                              selectedTimeRange = TimeRange.week;
                              _controller.text = selectedPage.toString();
                              _readAndParseJsonFile();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  selectedTimeRange == TimeRange.week
                                      ? const Color(0xFFF0F1F2)
                                      : const Color(0xFF93959A),
                              backgroundColor:
                                  selectedTimeRange == TimeRange.week
                                      ? const Color(0xFF93959A)
                                      : const Color(0xFFF0F1F2),
                              elevation: selectedTimeRange == TimeRange.week
                                  ? 2.0
                                  : 0.0,
                              textStyle: AppTextStyles.defaultTextStyle),
                          child: const Text('Неделя'),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedPage = 1;
                              selectedTimeRange = TimeRange.month;
                              _controller.text = selectedPage.toString();
                              _readAndParseJsonFile();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  selectedTimeRange == TimeRange.month
                                      ? const Color(0xFFF0F1F2)
                                      : const Color(0xFF93959A),
                              backgroundColor:
                                  selectedTimeRange == TimeRange.month
                                      ? const Color(0xFF93959A)
                                      : const Color(0xFFF0F1F2),
                              elevation: selectedTimeRange == TimeRange.month
                                  ? 2.0
                                  : 0.0,
                              textStyle: AppTextStyles.defaultTextStyle),
                          child: const Text('Месяц'),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedPage = 1;
                              selectedTimeRange = TimeRange.year;
                              _controller.text = selectedPage.toString();
                              _readAndParseJsonFile();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  selectedTimeRange == TimeRange.year
                                      ? const Color(0xFFF0F1F2)
                                      : const Color(0xFF93959A),
                              backgroundColor:
                                  selectedTimeRange == TimeRange.year
                                      ? const Color(0xFF93959A)
                                      : const Color(0xFFF0F1F2),
                              elevation: selectedTimeRange == TimeRange.year
                                  ? 2.0
                                  : 0.0,
                              textStyle: AppTextStyles.defaultTextStyle),
                          child: const Text('Год'),
                        ),
                      ),
                    ],
                  ),
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
                    child: FilterMenu(
                        readAndParseJsonCallback: _readAndParseJsonFile,
                        filter: filter,
                        popupMenuKey: popupMenuKey,
                        colorChangingCircle: colorChangingCircle),
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
            FilterIndicator(
                filter: filter, readAndParseJson: _readAndParseJsonFile),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GestureDetector(
                onHorizontalDragUpdate: _handleSwipe,
                child: ListView.builder(
                  itemCount: information.length,
                  itemBuilder: (context, index) {
                    int stateIndex = information[index].state;
                    final Color nowColor =
                        colorChangingCircle.colors[stateIndex];
                    return Container(
                      child: Card(
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        margin: const EdgeInsets.all(0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            border: Border(
                              bottom:
                                  const BorderSide(color: Color(0xFFE3E3E3)),
                              left: BorderSide(
                                color: nowColor,
                                width: 6,
                              ),
                            ),
                          ),
                          child: ListTile(
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              height: 16,
                                              width: 16,
                                              decoration: BoxDecoration(
                                                color: nowColor,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                              fit: FlexFit.tight,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8),
                                                  child: DashedLine(
                                                    //height: 700,
                                                    color: nowColor,
                                                    dashWidth: 1.0,
                                                    dashSpace: 1.0,
                                                  )))
                                          // DottedVerticalLine()
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
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              CardName().settingNameToCard(
                                                  information[index].state),
                                              style:
                                                  AppTextStyles.boldTextStyle,
                                            ),
                                            !information[index].isExpanded
                                                ? Column(children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      child: Text(
                                                        information[index]
                                                            .name
                                                            .toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: AppTextStyles
                                                            .rearTextStyle,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      child: Text(
                                                        information[index]
                                                            .targetName
                                                            .toString(),
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: AppTextStyles
                                                            .underTextStyle,
                                                      ),
                                                    )
                                                  ])
                                                : ExtendedInformationWidget(
                                                    information: information,
                                                    index: index),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 4, 0, 16),
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  CardName().getTimeText(
                                                    information[index]
                                                        .timeValue,
                                                    selectedTimeRange,
                                                  ),
                                                  style: AppTextStyles
                                                      .rearTextStyle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: IconButton(
                                          iconSize: 24,
                                          icon: !information[index].isExpanded
                                              ? const Icon(Icons.expand_more)
                                              : const Icon(Icons.expand_less),
                                          onPressed: () {
                                            setState(() {
                                              information[index].isExpanded =
                                                  !information[index]
                                                      .isExpanded;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onLongPress: () {
                                showDialog(
                                    //карточка подробной информации
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                          insetPadding:
                                              const EdgeInsets.all(10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: SizedBox(
                                              width: double.infinity,
                                              // Установка ширины контейнера равной ширине экрана
                                              child: SingleChildScrollView(
                                                  child: Column(children: [
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                IntrinsicHeight(
                                                    child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
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
                                                            decoration:
                                                                BoxDecoration(
                                                              color: nowColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          Flexible(
                                                              fit:
                                                                  FlexFit.tight,
                                                              child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          8),
                                                                  child:
                                                                      DashedLine(
                                                                    //height: 700,
                                                                    color:
                                                                        nowColor,
                                                                    dashWidth:
                                                                        1.0,
                                                                    dashSpace:
                                                                        1.0,
                                                                  )))
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                height: 16,
                                                              ),
                                                              Text(
                                                                CardName().settingNameToCard(
                                                                    information[
                                                                            index]
                                                                        .state),
                                                                style: AppTextStyles
                                                                    .boldTextStyle,
                                                              ),
                                                              const SizedBox(
                                                                height: 6,
                                                              ),
                                                              Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child: ExtendedInformationWidget(
                                                                          information:
                                                                              information,
                                                                          index:
                                                                              index),
                                                                    ),
                                                                  ]),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        4,
                                                                        0,
                                                                        16),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
                                                                  child: Text(
                                                                    CardName()
                                                                        .getTimeText(
                                                                      information[
                                                                              index]
                                                                          .timeValue,
                                                                      selectedTimeRange,
                                                                    ),
                                                                    style: AppTextStyles
                                                                        .rearTextStyle,
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          IconButton(
                                                            alignment: Alignment
                                                                .topCenter,
                                                            icon: const Icon(
                                                                Icons.close),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ]))
                                              ]))));
                                    });
                              } // onlongpress
                              ),
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

  bool _isValid = true;

  void updateSelectedPage(int newSelectedPage) {
    setState(() {
      selectedPage = newSelectedPage;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
}

/*Входные данный файл с json форматом, в котором для нормального функционирования должны иметься поля:
* 1. state
* 2. name
* 3. target_name
* 4. time-value
* 5. label*/
