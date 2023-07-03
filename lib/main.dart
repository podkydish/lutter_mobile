import 'dart:convert';
import 'package:flutter/material.dart';
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
        primarySwatch: MaterialColor(
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List information = [];
  TimeRange selectedTimeRange = TimeRange.Hour;
  Color selectedColor = Colors.transparent;
  ColorChangingCircle colorChangingCircle = ColorChangingCircle(
      dataIndex: 0,
      colors: [
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
  }

  Future<void> _readAndParseJsonFile() async {
    try {
      String jsonString = await rootBundle.loadString('assets/jsonConsole.txt');
      if (jsonString.isNotEmpty) {
        List allInformation = json.decode(jsonString)['data']['alerts'];
        List filteredInformation = [];

        switch (selectedTimeRange) {
          case TimeRange.Hour:
            filteredInformation = allInformation
                .where((info) =>
            DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(
                int.parse(info['time_value']) * 1000,
              ),
            ) <
                Duration(hours: 1))
                .toList();
            break;
          case TimeRange.Today:
            filteredInformation = allInformation
                .where((info) =>
            DateTime.now().day == DateTime.fromMillisecondsSinceEpoch(
              int.parse(info['time_value']) * 1000,
            ).day)
                .toList();
            break;
          case TimeRange.Yesterday:
            filteredInformation = allInformation
                .where((info) =>
            DateTime.now().subtract(Duration(days: 1)).day ==
                DateTime.fromMillisecondsSinceEpoch(
                  int.parse(info['time_value']) * 1000,
                ).day)
                .toList();
            break;
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxWidth = 0.75 * screenWidth; //TODO применить для текста внутри карточки
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(),
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
                      child: Text('Час'),
                      style: ElevatedButton.styleFrom(
                        elevation: selectedTimeRange == TimeRange.Hour ? 2.0 : 0.0,
                        textStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        primary: selectedTimeRange == TimeRange.Hour
                            ? Color(0xFF93959A)
                            : Color(0xFFF0F1F2),
                      ),
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
                      child: Text('Сегодня'),
                      style: ElevatedButton.styleFrom(
                        elevation: selectedTimeRange == TimeRange.Today ? 2.0 : 0.0,
                        textStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        primary: selectedTimeRange == TimeRange.Today
                            ? Color(0xFF93959A)
                            : Color(0xFFF0F1F2),
                      ),
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
                      child: Text('Вчера'),
                      style: ElevatedButton.styleFrom(
                        elevation: selectedTimeRange == TimeRange.Yesterday ? 2.0 : 0.0,
                        textStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        primary: selectedTimeRange == TimeRange.Yesterday
                            ? Color(0xFF93959A)
                            : Color(0xFFF0F1F2)
                      ),
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
                    decoration: InputDecoration(
                      hintText: 'Поиск',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                PopupMenuButton<Color>(
                icon: Icon(Icons.filter_alt),
                initialValue: selectedColor,
                onSelected: (Color color) {
                setState(() {
                selectedColor = color;
                });
                },
                itemBuilder: (BuildContext context) {
                return colorChangingCircle.colors.map((Color color) {
                return PopupMenuItem<Color>(
                value: color,
                child: Text(color.toString()),
    );
    }).toList();
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
                          CardName().settingNameToCard(information[index]['state']),
                          style: TextStyle(
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
                        Text(
                          information[index]['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Color(0xFF71777C),
                          ),
                        ),
                        Text(information[index]['target_name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Color(0xFF93959A),)),
                        Text(
                          CardName().getTimeText(information[index]['time_value'],
                            selectedTimeRange,),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            color: Color(0xFF71777C),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Действие при нажатии на карточку
                    },
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
  String settingNameToCard(int index){
    switch(index){
      case 0: return 'Резерв';
      case 1: return 'Штатно';
      case 2: return 'Сигнализация';
      case 3: return 'Риск аварии';
      case 4: return 'Критические события';
      case 5: return 'Нет данных';
      case 6: return '';
      case 7: return 'Резерв';
      default: print('вышли из допустимых индексов');
      return '';
    }
  }

  String getTimeText(String timeValue, TimeRange selectedTimeRange) {
    if (selectedTimeRange == TimeRange.Hour) {
      final DateTime now = DateTime.now().toLocal().add(const Duration(hours: 3));
      final DateTime eventTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timeValue) * 1000).toUtc();
      final int minutesAgo = (now.millisecondsSinceEpoch - eventTime.millisecondsSinceEpoch)~/60000;

       if (minutesAgo < 60) {
        return '$minutesAgo минут назад';
      } else {
        return timeValue;
      }
    } else if (selectedTimeRange == TimeRange.Today) {
      var date = DateTime.fromMillisecondsSinceEpoch(int.parse(timeValue) * 1000).toUtc();
      final String formattedTime = DateFormat('HH:mm:ss').format(date);
      return formattedTime;
    } else if (selectedTimeRange == TimeRange.Yesterday) {
      final DateTime eventTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timeValue) * 1000).toUtc();
      final String formattedDateTime =
      DateFormat('dd.MM.yy hh:mm:ss').format(eventTime);
      return formattedDateTime;
    } else {
      return timeValue;
    }
  }

}