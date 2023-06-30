import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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


  @override
  void initState() {
    super.initState();
    _readAndParseJsonFile();
  }

  Future<void> _readAndParseJsonFile() async {
    try {
      // Путь к файлу
      String jsonString = await rootBundle.loadString('assets/jsonConsole.txt');
      if (jsonString.isNotEmpty) {
        // Чтение содержимого файла
        // String contents = await file.readAsString();
        // Декодирование JSON и обновление списка информации
        setState(() {
          information = json.decode(jsonString)['data']['alerts'];
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
    double maxWidth = 0.75 * screenWidth; // 75% of the screen width
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
                        // Action for "Час" button
                      },
                      child: Text('Час'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        textStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Action for "Сегодня" button
                      },
                      child: Text('Сегодня'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        textStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Action for "Вчера" button
                      },
                      child: Text('Вчера'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        textStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () {
                        // Action for IconButton
                      },
                      icon: Icon(Icons.chevron_right),
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
                IconButton(
                  icon: Icon(Icons.filter_alt),
                  onPressed: () {
                    // Действие для кнопки фильтра
                  },

                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemExtent: 132,
              itemCount: information.length, // Количество карточек
              itemBuilder: (context, index) {
                return Card(
                  //elevation: 0.0,
                  child: ListTile(
                    leading: ColorChangingCircle(
                      dataIndex: information[index]['state'],
                      colors: [
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
                        Text('Карточка ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                          fontSize: 17,
                          color: Color(0xFF515357),
                        ),),
                        const Spacer(flex: 1),
                        Text('код сообщения',style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                          fontSize: 17,
                          color: Color(0xFF515357),
                        ),),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(information[index]['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Color(0xFF515357),
                        )),
                        Text(information[index]['target_name'],
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Color(0xFF93959A),)),
                        Text(
                          ((DateTime.now().millisecondsSinceEpoch -
                              int.parse(information[index]['time_value']) *
                                  1000) ~/
                              60000)
                              .toString() + 'мин. назад',
                            style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 14,
                              color: Color(0xFF515357),
                        )),
                      ],
                    ),
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
class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dashHeight = 5;
    final dashSpace = 5;

    double startY = size.height / 2;
    double endY = size.height; // Extend to the bottom of the card

    while (startY < endY) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ColorChangingCircle extends StatelessWidget {
  final int dataIndex; // Индекс данных
  final List<Color> colors; // Список цветов
  final double circleSize; // Размер кружочка

  const ColorChangingCircle({
    Key? key,
    required this.dataIndex,
    required this.colors,
    this.circleSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color circleColor = colors[dataIndex % colors.length]; // Определение цвета в зависимости от индекса данных

    return SizedBox(
      height: circleSize,
      child: Container(
        width: circleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: circleColor,
        ),
      ),
    );
  }
}

