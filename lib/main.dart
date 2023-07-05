import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum TimeRange {
  Hour,
  Today,
  Yesterday,
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFFDEDEDE,
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
  Timer? searchTimer; // Переменная для хранения таймера
  String searchQuery = '';
  List information = [];
  TimeRange selectedTimeRange = TimeRange.Hour;
  Color selectedColor = Colors.transparent;
  List<bool?> checkBoxValues = [];
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
    checkBoxValues = List.generate(10, (index) => false);
  }

  Future<void> _readAndParseJsonFile() async {
    try {
      String jsonString = await rootBundle.loadString('assets/jsonConsole.txt');
      if (jsonString.isNotEmpty) {
        List allInformation = json.decode(jsonString)['data']['alerts'];
        List filteredInformation = [];





            if(selectedTimeRange==TimeRange.Hour) {
              filteredInformation = allInformation
                  .where((info) =>
              DateTime.now().difference(
                DateTime.fromMillisecondsSinceEpoch(
                  int.parse(info['time_value']) * 1000,
                ),
              ) <
                  const Duration(hours: 1))
                  .toList();
            } else if(selectedTimeRange==TimeRange.Today){
              filteredInformation = allInformation
                  .where((info) =>
              DateTime.now().day ==
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(info['time_value']) * 1000,
                  ).day)
                  .toList();
            } else if(selectedTimeRange==TimeRange.Yesterday){
              filteredInformation = allInformation
                  .where((info) =>
              DateTime.now().subtract(const Duration(days: 1)).day ==
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(info['time_value']) * 1000,
                  ).day)
                  .toList();
            }

        if(filteredInformation.isEmpty){
          filteredInformation = allInformation;
        }
        for (int i = 0; i < checkBoxValues.length; i++){//фильтр информации
          if(i<6){
            if(checkBoxValues[i]==true){
              filteredInformation += filteredInformation
                  .where((info) => info['state'] == i)
                  .toList();
            }
          } else if(5<i && i<10){
            filteredInformation += filteredInformation
                .where((info) => info['label'] == indexIntoLabel(i))
                .toList();
          }
        }

        setState(() {
          information = filteredInformation;
        });
      } else {
        print('не нашли файл(((');
      }
    } catch (e) {
      print('Ошибка при чтении и парсинге файла JSON: $e');
    }
  }

  String indexIntoLabel(int index){
    switch(index){
      case 6: return 'C1';
      case 7: return 'C2';
      case 8: return 'C3';
      case 9: return 'C4';
      default:
        print('вышли за пределы индексации');
        return '';
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Column(
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
                          selectedTimeRange = TimeRange.Hour;
                          _readAndParseJsonFile();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation:
                            selectedTimeRange == TimeRange.Hour ? 2.0 : 0.0,
                        backgroundColor: selectedTimeRange == TimeRange.Hour
                            ? const Color(0xFF93959A)
                            : const Color(0xFFF0F1F2),
                        foregroundColor: selectedTimeRange == TimeRange.Hour
                            ? const Color(0xFFF0F1F2)
                            : const Color(0xFF93959A),
                        textStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: Text('Час'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedTimeRange = TimeRange.Today;
                          _readAndParseJsonFile();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation:
                            selectedTimeRange == TimeRange.Today ? 2.0 : 0.0,
                        foregroundColor: selectedTimeRange == TimeRange.Today
                            ? const Color(0xFFF0F1F2)
                            : const Color(0xFF93959A),
                        textStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        primary: selectedTimeRange == TimeRange.Today
                            ? Color(0xFF93959A)
                            : Color(0xFFF0F1F2),
                      ),
                      child: const Text('Сегодня'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedTimeRange = TimeRange.Yesterday;
                          _readAndParseJsonFile();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor:
                              selectedTimeRange == TimeRange.Yesterday
                                  ? Color(0xFFF0F1F2)
                                  : Color(0xFF93959A),
                          elevation: selectedTimeRange == TimeRange.Yesterday
                              ? 2.0
                              : 0.0,
                          textStyle: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          primary: selectedTimeRange == TimeRange.Yesterday
                              ? Color(0xFF93959A)
                              : Color(0xFFF0F1F2)),
                      child: const Text('Вчера'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(0.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      //проверяем на таймер, и если нет, то запускаем
                      if (searchTimer != null && searchTimer!.isActive) {
                        searchTimer!.cancel();
                      }

                      searchTimer = Timer(const Duration(milliseconds: 500), () {
                        setState(() {
                          searchQuery = value;
                        });

                        _readAndParseJsonFile();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Поиск',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                PopupMenuButton<String>(       //окно фильтрации
                  icon: const Icon(Icons.filter_alt),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: checkBoxValues[0] ?? false,
                                  onChanged: (bool? value) {
                                    SchedulerBinding.instance.addPostFrameCallback((_) {
                                      setState(() {
                                        // Обновление состояния Checkbox
                                        checkBoxValues[0] = value ?? false;
                                      });
                                    });
                                  },
                                ),
                                Container(color: colorChangingCircle.colors[0],width: 16, height: 16,),
                                const SizedBox(
                                  width: 10,
                                ),
                                Checkbox(
                                  value: checkBoxValues[1] ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkBoxValues[1] = value ?? false;
                                    });
                                  },
                                ),
                                Container(color: colorChangingCircle.colors[1],width: 16, height: 16,),
                                const SizedBox(
                                  width: 10,
                                ),
                                Checkbox(
                                  value: checkBoxValues[2] ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkBoxValues[2] = value ?? false;
                                    });
                                  },
                                ),
                                Container(color: colorChangingCircle.colors[2],width: 16, height: 16,),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: checkBoxValues[3] ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkBoxValues[3] = value ?? false;
                                    });
                                  },
                                ),
                                Container(color: colorChangingCircle.colors[3],
                                width: 16, height: 16,),
                                const SizedBox(
                                  width: 10,
                                ),
                                Checkbox(
                                  value: checkBoxValues[4] ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkBoxValues[4] = value ?? false;
                                    });
                                  },
                                ),
                                Container(color: colorChangingCircle.colors[4],width: 16, height: 16,),
                                const SizedBox(
                                  width: 10,
                                ),
                                Checkbox(
                                  value: checkBoxValues[5] ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkBoxValues[5] = value ?? false;
                                    });
                                  },
                                ),
                                Container(color: colorChangingCircle.colors[5],width: 16, height: 16,),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: checkBoxValues[6] ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkBoxValues[6] = value ?? false;
                                    });
                                  },
                                ),
                                const Text("C1"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Checkbox(
                                  value: checkBoxValues[7] ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkBoxValues[7] = value ?? false;
                                    });
                                  },
                                ),
                                const Text('C2'),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: checkBoxValues[8] ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkBoxValues[8] = value ?? false;
                                    });
                                  },
                                ),
                                const Text('C3'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Checkbox(
                                  value: checkBoxValues[9] ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkBoxValues[9] = value ?? false;
                                    });
                                  },
                                ),
                                const Text('C4'),
                              ],
                            ),
                            TextButton(onPressed: (){

                            }, child: const Text('применить'))
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemExtent: 132,
              itemCount: information.length,
              itemBuilder: (context, index) {
                final String name = information[index]['name'].toString();
                final String targetName =
                    information[index]['target_name'].toString();
                final bool nameContainsQuery =
                    name.toLowerCase().contains(searchQuery.toLowerCase());
                final bool targetNameContainsQuery = targetName
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());

                if (searchQuery.isNotEmpty &&
                    !(nameContainsQuery || targetNameContainsQuery)) {
                  return SizedBox.shrink(); // прячем карточку
                }

                return Card(
                  child: ListTile(
                    leading: ColorChangingCircle(
                      dataIndex: information[index]['state'],
                      colors: const [
                        Color(0xFF4285F4),
                        Color(0xFF38C25D),
                        Color(0xFFFFCA31),
                        Color(0xFFEA4335),
                        Color(0xFFAD2C72),
                        Color(0xFF858B99),
                        Color(0xFFD9E2EC),
                        Color(0xFF4285F4),
                      ],
                    ),
                    title: Row(
                      children: [
                        Text(
                          CardName()
                              .settingNameToCard(information[index]['state']),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                            fontSize: 17,
                            color: Color(0xFF515357),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          information[index]['name'].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Color(0xFF515357),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            information[index]['target_name'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Color(0xFF93959A),
                            )),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          CardName().getTimeText(
                            information[index]['time_value'],
                            selectedTimeRange,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Color(0xFF515357),
                          ),
                        ),
                      ],
                    ),
                    onLongPress: () {
                      showDialog(             //карточка подробной информации
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          CardName().settingNameToCard(
                                              information[index]['state']),
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                  ListTile(
                                    title: Text(
                                        information[index]['name'].toString()),
                                  ),
                                  ListTile(
                                    title: Text(
                                      information[index]['target_name']
                                          .toString(),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      CardName().getTimeText(
                                        information[index]['time_value'],
                                        selectedTimeRange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }, //onlongpress
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ColorChangingCircle extends StatelessWidget {
  final int dataIndex;
  final List<Color> colors;

  const ColorChangingCircle({
    Key? key,
    required this.dataIndex,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors[dataIndex % colors.length],
      ),
    );
  }
}

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
        print('вышли из допустимых индексов');
        return '';
    }
  }

  String getTimeText(String timeValue, TimeRange selectedTimeRange) {
    if (selectedTimeRange == TimeRange.Hour) {
      final DateTime now =
          DateTime.now().toLocal().add(const Duration(hours: 3));
      final DateTime eventTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(timeValue) * 1000)
              .toUtc();
      final int minutesAgo =
          (now.millisecondsSinceEpoch - eventTime.millisecondsSinceEpoch) ~/
              60000;

      if (minutesAgo < 60) {
        return '$minutesAgo минут назад';
      } else {
        return timeValue;
      }
    } else if (selectedTimeRange == TimeRange.Today) {
      var date =
          DateTime.fromMillisecondsSinceEpoch(int.parse(timeValue) * 1000)
              .toUtc();
      final String formattedTime = DateFormat('HH:mm:ss').format(date);
      return formattedTime;
    } else if (selectedTimeRange == TimeRange.Yesterday) {
      final DateTime eventTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(timeValue) * 1000)
              .toUtc();
      final String formattedDateTime =
          DateFormat('dd.MM.yy hh:mm:ss').format(eventTime);
      return formattedDateTime;
    } else {
      return timeValue;
    }
  }
}

//todo фильтр по цветам и классам опасности (поле label)
//todo постранично показывать по 5 карточек + навигация по страницам
// todo стили
// todo сделать ограничение в 1 строку для первого параметра, 3 строки для второго параметра, а полная инфа при долгом удерживании
//todo хранение фильра в мапе, но только выбранные
//todo фильтрацию сначала по времени, затем по фильтрам
// todo сначала время, потом дата
// todo шапку снести