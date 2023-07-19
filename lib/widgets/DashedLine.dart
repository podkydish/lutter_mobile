import 'package:flutter/material.dart';

import 'DashedLinePainter.dart';

class DashedLine extends StatelessWidget {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const DashedLine({
    Key? key,
    required this.color,
    this.dashWidth = 1.0,
    this.dashSpace = 3.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedLinePainter(
        color: color,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
      ),
      child: SizedBox(width: 1.0),
    );
  }
}
