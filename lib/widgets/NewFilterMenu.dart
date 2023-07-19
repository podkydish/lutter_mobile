import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/CardName.dart';
import 'package:untitled/styles/text_styles.dart';

import '../ColorChangingCircle.dart';
import '../FilterData.dart';
import 'PopUpMenuChecks.dart';

class NewFilterMenu extends StatefulWidget {
  final Function() readAndParseJsonCallback;
  final Map<Container, FilterData> filter;
  final GlobalKey popupMenuKey;
  final ColorChangingCircle colorChangingCircle;

  const NewFilterMenu(
      {super.key,
      required this.readAndParseJsonCallback,
      required this.filter,
      required this.popupMenuKey,
      required this.colorChangingCircle});

  @override
  _FilterPopupMenuState createState() => _FilterPopupMenuState();
}

class _FilterPopupMenuState extends State<NewFilterMenu> {
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

  bool isSignalExpanded = true;
  bool isClassExpanded = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      onCanceled: () {
        widget.readAndParseJsonCallback();
      },
      constraints:
          const BoxConstraints.expand(width: double.infinity, height: 600),
      padding: EdgeInsets.zero,
      key: widget.popupMenuKey,
      icon: hasTrueValue(widget.filter)
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
              return Column(children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          TextButton(
                            child: const Text(
                              'Сбросить',
                              style: AppTextStyles.additionalText,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.filter.values
                                    .where((filterData) =>
                                        filterData.booleanValue == true)
                                    .forEach((filterData) {
                                  filterData.booleanValue = false;
                                });
                                widget.popupMenuKey.currentState
                                    ?.setState(() {});
                              });
                            },
                          ),
                          const SizedBox(
                            width: 38,
                          ),
                          const Text(
                            'Фильтры',
                            style: AppTextStyles.boldTextStyle,
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignalExpanded = !isSignalExpanded;
                                    isClassExpanded = false;
                                  });
                                  widget.popupMenuKey.currentState
                                      ?.setState(() {});
                                },
                                child: Row(
                                  children: [
                                    const Text(
                                      'Сигналы',
                                      style: AppTextStyles.boldTextStyle,
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 24,
                                      icon: !isSignalExpanded
                                          ? const Icon(Icons.expand_more)
                                          : const Icon(Icons.expand_less),
                                      color: Colors.blue,
                                      onPressed: () {
                                        setState(() {
                                          isSignalExpanded = !isSignalExpanded;
                                          isClassExpanded = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              isSignalExpanded
                                  ? Column(
                                      children: [
                                        CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: VisualDensity.compact,
                                          title: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: widget
                                                          .colorChangingCircle
                                                          .colors[
                                                      purpleFilterIndex],
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                width: 16,
                                                height: 16,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4),
                                                child: Text(
                                                  CardName().settingNameToCard(
                                                      purpleFilterIndex),
                                                  style: AppTextStyles
                                                      .boldTextStyle,
                                                ),
                                              )
                                            ],
                                          ),
                                          value: widget.filter.values
                                              .firstWhere((filterData) =>
                                                  filterData.intValue ==
                                                  purpleFilterIndex)
                                              .booleanValue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              widget.filter.values
                                                  .where((filterData) =>
                                                      filterData.intValue ==
                                                      purpleFilterIndex)
                                                  .forEach((filterData) {
                                                filterData.booleanValue =
                                                    value!;
                                              });
                                            });
                                            widget.popupMenuKey.currentState
                                                ?.setState(() {});
                                          },
                                        ),
                                        CheckboxListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: widget
                                                        .colorChangingCircle
                                                        .colors[redFilterIndex],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  width: 16,
                                                  height: 16,
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4),
                                                    child: Text(
                                                      CardName()
                                                          .settingNameToCard(
                                                              redFilterIndex),
                                                      style: AppTextStyles
                                                          .boldTextStyle,
                                                    ))
                                              ],
                                            ),
                                            value: widget.filter.values
                                                .firstWhere((filterData) =>
                                                    filterData.intValue ==
                                                    redFilterIndex)
                                                .booleanValue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                widget.filter.values
                                                    .where((filterData) =>
                                                        filterData.intValue ==
                                                        redFilterIndex)
                                                    .forEach((filterData) {
                                                  filterData.booleanValue =
                                                      value!;
                                                });
                                              });
                                              widget.popupMenuKey.currentState
                                                  ?.setState(() {});
                                            }),
                                        CheckboxListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: widget
                                                        .colorChangingCircle
                                                        .colors[redFilterIndex],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  width: 16,
                                                  height: 16,
                                                  child: const Icon(
                                                    Icons.build,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 4),
                                                    child: Text(
                                                      'Не готов',
                                                      style: AppTextStyles
                                                          .boldTextStyle,
                                                    ))
                                              ],
                                            ),
                                            value: widget.filter.values
                                                .firstWhere((filterData) =>
                                                    filterData.intValue ==
                                                    redFilterIndex)
                                                .booleanValue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                widget.filter.values
                                                    .where((filterData) =>
                                                        filterData.intValue ==
                                                        redFilterIndex)
                                                    .forEach((filterData) {
                                                  filterData.booleanValue =
                                                      value!;
                                                });
                                              });
                                              widget.popupMenuKey.currentState
                                                  ?.setState(() {});
                                            }),
                                        CheckboxListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: widget
                                                            .colorChangingCircle
                                                            .colors[
                                                        yellowFilterIndex],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  width: 16,
                                                  height: 16,
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4),
                                                    child: Text(
                                                      CardName()
                                                          .settingNameToCard(
                                                              yellowFilterIndex),
                                                      style: AppTextStyles
                                                          .boldTextStyle,
                                                    ))
                                              ],
                                            ),
                                            value: widget.filter.values
                                                .firstWhere((filterData) =>
                                                    filterData.intValue ==
                                                    yellowFilterIndex)
                                                .booleanValue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                widget.filter.values
                                                    .where((filterData) =>
                                                        filterData.intValue ==
                                                        yellowFilterIndex)
                                                    .forEach((filterData) {
                                                  filterData.booleanValue =
                                                      value!;
                                                });
                                              });
                                              widget.popupMenuKey.currentState
                                                  ?.setState(() {});
                                            }),
                                        CheckboxListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: widget
                                                            .colorChangingCircle
                                                            .colors[
                                                        blueFilterIndex],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  width: 16,
                                                  height: 16,
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4),
                                                    child: Text(
                                                      CardName()
                                                          .settingNameToCard(
                                                              blueFilterIndex),
                                                      style: AppTextStyles
                                                          .boldTextStyle,
                                                    ))
                                              ],
                                            ),
                                            value: widget.filter.values
                                                .firstWhere((filterData) =>
                                                    filterData.intValue ==
                                                    blueFilterIndex)
                                                .booleanValue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                widget.filter.values
                                                    .where((filterData) =>
                                                        filterData.intValue ==
                                                        blueFilterIndex)
                                                    .forEach((filterData) {
                                                  filterData.booleanValue =
                                                      value!;
                                                });
                                              });
                                              widget.popupMenuKey.currentState
                                                  ?.setState(() {});
                                            }),
                                        CheckboxListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: widget
                                                            .colorChangingCircle
                                                            .colors[
                                                        blueFilterIndex],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  width: 16,
                                                  height: 16,
                                                  child: const Icon(
                                                    Icons.build,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 4),
                                                  child: Text(
                                                    "НТР",
                                                    style: AppTextStyles
                                                        .boldTextStyle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            value: widget.filter.values
                                                .firstWhere((filterData) =>
                                                    filterData.intValue ==
                                                    blueFilterIndex)
                                                .booleanValue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                widget.filter.values
                                                    .where((filterData) =>
                                                        filterData.intValue ==
                                                        blueFilterIndex)
                                                    .forEach((filterData) {
                                                  filterData.booleanValue =
                                                      value!;
                                                });
                                              });
                                              widget.popupMenuKey.currentState
                                                  ?.setState(() {});
                                            }),
                                        CheckboxListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: widget
                                                            .colorChangingCircle
                                                            .colors[
                                                        blueFilterIndex],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  width: 16,
                                                  height: 16,
                                                  child: const Icon(
                                                    Icons.settings,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 4),
                                                    child: Text(
                                                      "Регламентные работы",
                                                      style: AppTextStyles
                                                          .boldTextStyle,
                                                    )),
                                              ],
                                            ),
                                            value: widget.filter.values
                                                .firstWhere((filterData) =>
                                                    filterData.intValue ==
                                                    blueFilterIndex)
                                                .booleanValue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                widget.filter.values
                                                    .where((filterData) =>
                                                        filterData.intValue ==
                                                        blueFilterIndex)
                                                    .forEach((filterData) {
                                                  filterData.booleanValue =
                                                      value!;
                                                });
                                              });
                                              widget.popupMenuKey.currentState
                                                  ?.setState(() {});
                                            }),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isClassExpanded = !isClassExpanded;
                                    isSignalExpanded = false;
                                  });
                                  widget.popupMenuKey.currentState
                                      ?.setState(() {});
                                },
                                child: Row(
                                  children: [
                                    const Text(
                                      'Класс опасности',
                                      style: AppTextStyles.boldTextStyle,
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 24,
                                      icon: !isClassExpanded
                                          ? const Icon(Icons.expand_more)
                                          : const Icon(Icons.expand_less),
                                      color: Colors.blue,
                                      onPressed: () {
                                        setState(() {
                                          isClassExpanded = !isClassExpanded;
                                          isSignalExpanded = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              isClassExpanded
                                  ? Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "C1",
                                              style:
                                                  AppTextStyles.boldTextStyle,
                                            ),
                                            Checkbox(
                                              value: widget.filter.values
                                                  .firstWhere((filterData) =>
                                                      filterData.intValue ==
                                                      c1FilterIndex)
                                                  .booleanValue,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  widget.filter.values
                                                      .where((filterData) =>
                                                          filterData.intValue ==
                                                          c1FilterIndex)
                                                      .forEach((filterData) {
                                                    filterData.booleanValue =
                                                        value!;
                                                  });
                                                });
                                                widget.popupMenuKey.currentState
                                                    ?.setState(() {});
                                              },
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "C2",
                                              style:
                                                  AppTextStyles.boldTextStyle,
                                            ),
                                            Checkbox(
                                              value: widget.filter.values
                                                  .firstWhere((filterData) =>
                                                      filterData.intValue ==
                                                      c2FilterIndex)
                                                  .booleanValue,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  widget.filter.values
                                                      .where((filterData) =>
                                                          filterData.intValue ==
                                                          c2FilterIndex)
                                                      .forEach((filterData) {
                                                    filterData.booleanValue =
                                                        value!;
                                                  });
                                                });
                                                widget.popupMenuKey.currentState
                                                    ?.setState(() {});
                                              },
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "C3",
                                              style:
                                                  AppTextStyles.boldTextStyle,
                                            ),
                                            Checkbox(
                                              value: widget.filter.values
                                                  .firstWhere((filterData) =>
                                                      filterData.intValue ==
                                                      c3FilterIndex)
                                                  .booleanValue,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  widget.filter.values
                                                      .where((filterData) =>
                                                          filterData.intValue ==
                                                          c3FilterIndex)
                                                      .forEach((filterData) {
                                                    filterData.booleanValue =
                                                        value!;
                                                  });
                                                });
                                                widget.popupMenuKey.currentState
                                                    ?.setState(() {});
                                              },
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "C4",
                                              style:
                                                  AppTextStyles.boldTextStyle,
                                            ),
                                            Checkbox(
                                              value: widget.filter.values
                                                  .firstWhere((filterData) =>
                                                      filterData.intValue ==
                                                      c4FilterIndex)
                                                  .booleanValue,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  widget.filter.values
                                                      .where((filterData) =>
                                                          filterData.intValue ==
                                                          c4FilterIndex)
                                                      .forEach((filterData) {
                                                    filterData.booleanValue =
                                                        value!;
                                                  });
                                                });
                                                widget.popupMenuKey.currentState
                                                    ?.setState(() {});
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              //    Column(
                              //    children: [

                              //    ],
                              //  ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                !isClassExpanded && !isSignalExpanded
                    ? const SizedBox(
                        height: 384,
                      )
                    : const SizedBox.shrink(),
                isClassExpanded
                    ? const SizedBox(
                        height: 336,
                      )
                    : const SizedBox.shrink(),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: double.infinity,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            widget.readAndParseJsonCallback();
                            try {
                              Navigator.pop(context);
                            } catch (e) {
                              log('$e');
                            }
                          },
                          child: const Text(
                            'Применить',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ]);
            }),
          ),
        ];
      },
    );
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
