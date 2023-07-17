import 'package:flutter/material.dart';

import '../ConfigReader.dart';
import '../styles/text_styles.dart';

class NavigationBarr extends StatefulWidget {
  final Function() readAndParseJsonCallback;
  final ConfigReader configReader;
  final TextEditingController controller;
  final Function(int) updateSelectedPage;
  final int countOfPages;
  final int selectedPage;
  const NavigationBarr({
    required this.readAndParseJsonCallback,
    required this.configReader,
    required this.controller,
    required this.updateSelectedPage,
    required this.selectedPage,
    required this.countOfPages,
     // Add this line
  });

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarr> {
  bool _isValid = true;
  @override
  Widget build(BuildContext context) {
   return Align(
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
                widget.updateSelectedPage(1);

              widget.readAndParseJsonCallback();
              widget.controller.text = widget.selectedPage.toString();
              });
            },
            icon: const Icon(Icons.keyboard_double_arrow_left),
            iconSize: 40,
          ),
          IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                if (widget.selectedPage != 1) {
                  widget.updateSelectedPage(widget.selectedPage - 1);
                }
                widget.readAndParseJsonCallback();
                widget.controller.text = widget.selectedPage.toString();
              });
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
              controller: widget.controller,
              onChanged: _validateInput,
              onSubmitted: _onSubmitted,
              style: AppTextStyles.boldTextStyle,
              keyboardType: TextInputType.number,
              textAlignVertical: TextAlignVertical.center,
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
            widget.countOfPages.toString(),
            style: AppTextStyles.boldTextStyle,
          ),
          IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                if (widget.selectedPage != widget.countOfPages) {
                  widget.updateSelectedPage(widget.selectedPage+1);
                }

              widget.readAndParseJsonCallback();
              widget.controller.text = widget.selectedPage.toString();
              });
            },
            icon: const Icon(Icons.chevron_right),
            iconSize: 40,
          ),
          IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                widget.updateSelectedPage(widget.countOfPages);

              widget.readAndParseJsonCallback();
              widget.controller.text = widget.selectedPage.toString();
              });
              },
            icon: const Icon(Icons.keyboard_double_arrow_right),
            iconSize: 40,
          ),
          Text('${widget.configReader.recordsOnPage}/30000'),
        ],
      ),
    );
  }
  void _validateInput(String value) {
    setState(() {
      if (value.isNotEmpty &&
          int.tryParse(value) != null &&
          int.parse(value) > 0 &&
          int.parse(value) <= widget.countOfPages) {
        _isValid = true;
      } else {
        _isValid = false;
      }
    });
  }
  void _onSubmitted(String value) {
    // Обработка значения, когда пользователь нажимает клавишу "Готово" на клавиатуре
    // Можно выполнить дополнительную обработку или переход на другую страницу
    setState(() {
      if (value.isNotEmpty &&
          int.tryParse(value) != null &&
          int.parse(value) >= 0 &&
          int.parse(value) <= widget.countOfPages) {
        widget.updateSelectedPage(int.parse(value));
      } else {
        widget.controller.text =
            widget.selectedPage.toString(); // Восстановление предыдущего значения
      }
    });
    widget.readAndParseJsonCallback();
  }
}
