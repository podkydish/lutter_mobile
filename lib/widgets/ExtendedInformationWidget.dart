import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled/styles/text_styles.dart';

class ExtendedInformationWidget extends StatelessWidget {
  final int index;
  final List information;

  const ExtendedInformationWidget(
      {super.key, required this.index, required this.information});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(
        height: 6,
      ),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              information[index].name.toString().isNotEmpty
                  ? Column(children: [
                      Row(children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: "Имя устройства: ",
                              style: AppTextStyles.rearTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text: information[index].name.toString(),
                                  style: AppTextStyles.underTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])
                    ])
                  : const SizedBox.shrink(),
              information[index].targetName.toString().isNotEmpty
                  ? Column(children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Row(children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: "Имя целевого объекта: ",
                              style: AppTextStyles.rearTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      information[index].targetName.toString(),
                                  style: AppTextStyles.linkText,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                                insetPadding:
                                                    const EdgeInsets.all(10),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: const SizedBox(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  // Установка ширины контейнера равной ширине экрана
                                                  child: SizedBox(
                                                      width: 150,
                                                      height: 150,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
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
                  : const SizedBox.shrink(),
              information[index].ip.toString().isNotEmpty
                  ? Column(children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                text: "IP-адрес: ",
                                style: AppTextStyles.rearTextStyle,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: information[index].ip,
                                    style: AppTextStyles.underTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ])
                  : const SizedBox.shrink(),
              information[index].alert.toString().isNotEmpty
                  ? Column(children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Row(children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: "Шаблон сигнала: ",
                              style: AppTextStyles.rearTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text: information[index].alert,
                                  style: AppTextStyles.underTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])
                    ])
                  : const SizedBox.shrink(),
              information[index].subalert.toString().isNotEmpty
                  ? Column(children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Row(children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: "Сигнал: ",
                              style: AppTextStyles.rearTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text: information[index].subalert,
                                  style: AppTextStyles.underTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])
                    ])
                  : const SizedBox.shrink(),
              information[index].value.toString().isNotEmpty
                  ? Column(children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Row(children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: "Значение: ",
                              style: AppTextStyles.rearTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text: information[index].value,
                                  style: AppTextStyles.underTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])
                    ])
                  : const SizedBox.shrink(),
              information[index].description.toString().isNotEmpty
                  ? Column(children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Row(children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: "Описание: ",
                              style: AppTextStyles.rearTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text: information[index].description,
                                  style: AppTextStyles.underTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])
                    ])
                  : const SizedBox.shrink(),
              information[index].label.toString().isNotEmpty
                  ? Column(children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Row(children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: "Метка: ",
                              style: AppTextStyles.rearTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text: information[index].label,
                                  style: AppTextStyles.underTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])
                    ])
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ]),
    ]);
  }
}
