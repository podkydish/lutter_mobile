import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/styles/text_styles.dart';

import '../ColorChangingCircle.dart';
import '../FilterData.dart';
import 'PopUpMenuChecks.dart';

class FilterMenu extends StatefulWidget {
  final Function() readAndParseJsonCallback;
  final Map<Container, FilterData> filter;
  final GlobalKey popupMenuKey;
  final ColorChangingCircle colorChangingCircle;

  const FilterMenu(
      {super.key,
      required this.readAndParseJsonCallback,
      required this.filter,
      required this.popupMenuKey,
      required this.colorChangingCircle});

  @override
  _FilterPopupMenuState createState() => _FilterPopupMenuState();
}

class _FilterPopupMenuState extends State<FilterMenu> {
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

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onCanceled: () {
        widget.readAndParseJsonCallback();
      },
      constraints: const BoxConstraints.expand(width: 334, height: 230),
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
              return Column(
                children: [
                  const Text(
                    'Фильтры по состоянию',
                    style: AppTextStyles.defaultTextStyle,
                  ),
                  Row(children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.filter.values
                              .where((filterData) =>
                                  filterData.intValue == blueFilterIndex)
                              .forEach((filterData) {
                            filterData.booleanValue = !widget.filter.values
                                .firstWhere((filterData) =>
                                    filterData.intValue == blueFilterIndex)
                                .booleanValue;
                          });
                        });
                        widget.popupMenuKey.currentState?.setState(() {});
                      },
                      child: Row(children: [
                        Checkbox(
                          value: widget.filter.values
                              .firstWhere((filterData) =>
                                  filterData.intValue == blueFilterIndex)
                              .booleanValue,
                          onChanged: (bool? value) {
                            setState(() {
                              widget.filter.values
                                  .where((filterData) =>
                                      filterData.intValue == blueFilterIndex)
                                  .forEach((filterData) {
                                filterData.booleanValue = value!;
                              });
                            });
                            widget.popupMenuKey.currentState?.setState(() {});
                          },
                        ),
                        Container(
                          color: widget
                              .colorChangingCircle.colors[blueFilterIndex],
                          width: 16,
                          height: 16,
                        ),
                      ]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.filter.values
                                .where((filterData) =>
                                    filterData.intValue == greenFilterIndex)
                                .forEach((filterData) {
                              filterData.booleanValue = !widget.filter.values
                                  .firstWhere((filterData) =>
                                      filterData.intValue == greenFilterIndex)
                                  .booleanValue;
                            });
                          });
                          widget.popupMenuKey.currentState?.setState(() {});
                        },
                        child: Row(children: [
                          Checkbox(
                            value: widget.filter.values
                                .firstWhere((filterData) =>
                                    filterData.intValue == greenFilterIndex)
                                .booleanValue,
                            onChanged: (bool? value) {
                              setState(() {
                                widget.filter.values
                                    .where((filterData) =>
                                        filterData.intValue == greenFilterIndex)
                                    .forEach((filterData) {
                                  filterData.booleanValue = value!;
                                });
                              });
                            },
                          ),
                          Container(
                            color: widget
                                .colorChangingCircle.colors[greenFilterIndex],
                            width: 16,
                            height: 16,
                          ),
                        ])),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.filter.values
                                .where((filterData) =>
                                    filterData.intValue == yellowFilterIndex)
                                .forEach((filterData) {
                              filterData.booleanValue = !widget.filter.values
                                  .firstWhere((filterData) =>
                                      filterData.intValue == yellowFilterIndex)
                                  .booleanValue;
                            });
                          });
                          widget.popupMenuKey.currentState?.setState(() {});
                        },
                        child: Row(children: [
                          Checkbox(
                            value: widget.filter.values
                                .firstWhere((filterData) =>
                                    filterData.intValue == yellowFilterIndex)
                                .booleanValue,
                            onChanged: (bool? value) {
                              setState(() {
                                widget.filter.values
                                    .where((filterData) =>
                                        filterData.intValue ==
                                        yellowFilterIndex)
                                    .forEach((filterData) {
                                  filterData.booleanValue = value!;
                                });
                              });
                            },
                          ),
                          Container(
                            color: widget
                                .colorChangingCircle.colors[yellowFilterIndex],
                            width: 16,
                            height: 16,
                          ),
                        ])),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.filter.values
                              .where((filterData) =>
                                  filterData.intValue == redFilterIndex)
                              .forEach((filterData) {
                            filterData.booleanValue = !widget.filter.values
                                .firstWhere((filterData) =>
                                    filterData.intValue == redFilterIndex)
                                .booleanValue;
                          });
                        });
                        widget.popupMenuKey.currentState?.setState(() {});
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: widget.filter.values
                                .firstWhere((filterData) =>
                                    filterData.intValue == redFilterIndex)
                                .booleanValue,
                            onChanged: (bool? value) {
                              setState(() {
                                widget.filter.values
                                    .where((filterData) =>
                                        filterData.intValue == redFilterIndex)
                                    .forEach((filterData) {
                                  filterData.booleanValue = value!;
                                });
                              });
                            },
                          ),
                          Container(
                            color: widget
                                .colorChangingCircle.colors[redFilterIndex],
                            width: 16,
                            height: 16,
                          ),
                        ],
                      ),
                    )
                  ]),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.filter.values
                                  .where((filterData) =>
                                      filterData.intValue == purpleFilterIndex)
                                  .forEach((filterData) {
                                filterData.booleanValue = !widget.filter.values
                                    .firstWhere((filterData) =>
                                        filterData.intValue ==
                                        purpleFilterIndex)
                                    .booleanValue;
                              });
                            });
                            widget.popupMenuKey.currentState?.setState(() {});
                          },
                          child: Row(children: [
                            Checkbox(
                              value: widget.filter.values
                                  .firstWhere((filterData) =>
                                      filterData.intValue == purpleFilterIndex)
                                  .booleanValue,
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.filter.values
                                      .where((filterData) =>
                                          filterData.intValue ==
                                          purpleFilterIndex)
                                      .forEach((filterData) {
                                    filterData.booleanValue = value!;
                                  });
                                });
                              },
                            ),
                            Container(
                              color: widget.colorChangingCircle
                                  .colors[purpleFilterIndex],
                              width: 16,
                              height: 16,
                            ),
                          ])),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.filter.values
                                  .where((filterData) =>
                                      filterData.intValue == greyFilterIndex)
                                  .forEach((filterData) {
                                filterData.booleanValue = !widget.filter.values
                                    .firstWhere((filterData) =>
                                        filterData.intValue == greyFilterIndex)
                                    .booleanValue;
                              });
                            });
                            widget.popupMenuKey.currentState?.setState(() {});
                          },
                          child: Row(children: [
                            Checkbox(
                              value: widget.filter.values
                                  .firstWhere((filterData) =>
                                      filterData.intValue == greyFilterIndex)
                                  .booleanValue,
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.filter.values
                                      .where((filterData) =>
                                          filterData.intValue ==
                                          greyFilterIndex)
                                      .forEach((filterData) {
                                    filterData.booleanValue = value!;
                                  });
                                });
                              },
                            ),
                            Container(
                              color: widget
                                  .colorChangingCircle.colors[greyFilterIndex],
                              width: 16,
                              height: 16,
                            ),
                          ])),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.filter.values
                                  .where((filterData) =>
                                      filterData.intValue == skyFilterIndex)
                                  .forEach((filterData) {
                                filterData.booleanValue = !widget.filter.values
                                    .firstWhere((filterData) =>
                                        filterData.intValue == skyFilterIndex)
                                    .booleanValue;
                              });
                            });
                            widget.popupMenuKey.currentState?.setState(() {});
                          },
                          child: Row(children: [
                            Checkbox(
                              value: widget.filter.values
                                  .firstWhere((filterData) =>
                                      filterData.intValue == skyFilterIndex)
                                  .booleanValue,
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.filter.values
                                      .where((filterData) =>
                                          filterData.intValue == skyFilterIndex)
                                      .forEach((filterData) {
                                    filterData.booleanValue = value!;
                                  });
                                });
                              },
                            ),
                            Container(
                              color: widget
                                  .colorChangingCircle.colors[skyFilterIndex],
                              width: 16,
                              height: 16,
                            ),
                          ])),
                    ],
                  ),
                  Container(
                    height: 1,
                    color: const Color(0xFFE3E3E3),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.filter.values
                                  .where((filterData) =>
                                      filterData.intValue == c1FilterIndex)
                                  .forEach((filterData) {
                                filterData.booleanValue = !widget.filter.values
                                    .firstWhere((filterData) =>
                                        filterData.intValue == c1FilterIndex)
                                    .booleanValue;
                              });
                            });
                            widget.popupMenuKey.currentState?.setState(() {});
                          },
                          child: Row(children: [
                            Checkbox(
                              value: widget.filter.values
                                  .firstWhere((filterData) =>
                                      filterData.intValue == c1FilterIndex)
                                  .booleanValue,
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.filter.values
                                      .where((filterData) =>
                                          filterData.intValue == c1FilterIndex)
                                      .forEach((filterData) {
                                    filterData.booleanValue = value!;
                                  });
                                });
                              },
                            ),
                            const Text("C1"),
                          ])),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.filter.values
                                  .where((filterData) =>
                                      filterData.intValue == c2FilterIndex)
                                  .forEach((filterData) {
                                filterData.booleanValue = !widget.filter.values
                                    .firstWhere((filterData) =>
                                        filterData.intValue == c2FilterIndex)
                                    .booleanValue;
                              });
                            });
                            widget.popupMenuKey.currentState?.setState(() {});
                          },
                          child: Row(children: [
                            Checkbox(
                              value: widget.filter.values
                                  .firstWhere((filterData) =>
                                      filterData.intValue == c2FilterIndex)
                                  .booleanValue,
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.filter.values
                                      .where((filterData) =>
                                          filterData.intValue == c2FilterIndex)
                                      .forEach((filterData) {
                                    filterData.booleanValue = value!;
                                  });
                                });
                              },
                            ),
                            const Text('C2'),
                          ])),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.filter.values
                                  .where((filterData) =>
                                      filterData.intValue == c3FilterIndex)
                                  .forEach((filterData) {
                                filterData.booleanValue = !widget.filter.values
                                    .firstWhere((filterData) =>
                                        filterData.intValue == c3FilterIndex)
                                    .booleanValue;
                              });
                            });
                            widget.popupMenuKey.currentState?.setState(() {});
                          },
                          child: Row(children: [
                            Checkbox(
                              value: widget.filter.values
                                  .firstWhere((filterData) =>
                                      filterData.intValue == c3FilterIndex)
                                  .booleanValue,
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.filter.values
                                      .where((filterData) =>
                                          filterData.intValue == c3FilterIndex)
                                      .forEach((filterData) {
                                    filterData.booleanValue = value!;
                                  });
                                });
                              },
                            ),
                            const Text('C3'),
                          ])),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.filter.values
                                  .where((filterData) =>
                                      filterData.intValue == c4FilterIndex)
                                  .forEach((filterData) {
                                filterData.booleanValue = !widget.filter.values
                                    .firstWhere((filterData) =>
                                        filterData.intValue == c4FilterIndex)
                                    .booleanValue;
                              });
                            });
                            widget.popupMenuKey.currentState?.setState(() {});
                          },
                          child: Row(children: [
                            Checkbox(
                              value: widget.filter.values
                                  .firstWhere((filterData) =>
                                      filterData.intValue == c4FilterIndex)
                                  .booleanValue,
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.filter.values
                                      .where((filterData) =>
                                          filterData.intValue == c4FilterIndex)
                                      .forEach((filterData) {
                                    filterData.booleanValue = value!;
                                  });
                                });
                              },
                            ),
                            const Text('C4'),
                          ])),
                    ],
                  ),
                  Container(
                    height: 1,
                    color: const Color(0xFFE3E3E3),
                  ),
                  TextButton(
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
                        style: AppTextStyles.boldTextStyle,
                      ))
                ],
              );
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
