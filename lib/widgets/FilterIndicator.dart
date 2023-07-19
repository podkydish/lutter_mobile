import 'package:flutter/material.dart';
import '../FilterData.dart';

class FilterIndicator extends StatelessWidget {
  final Function() readAndParseJson;
  final Map<Container, FilterData> filter;

  const FilterIndicator(
      {super.key, required this.filter, required this.readAndParseJson});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Container(
        alignment: Alignment.topLeft,
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
                      entry.value.booleanValue = false;
                      readAndParseJson();
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
                              entry.value.booleanValue = false;
                              readAndParseJson();
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
    );
  }
}
