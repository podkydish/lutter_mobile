import 'package:flutter/cupertino.dart';

import 'DashedLinePainter.dart';

class DashedLine extends StatelessWidget {
  final Color color;
  final double height;
  final double dashWidth;
  final double dashSpace;

  DashedLine({
    required this.color,
    required this.height,
    this.dashWidth = 1.0,
    this.dashSpace = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedLinePainter(
        color: color,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
      ),
      child: Container(
        width: 1.0,
        height: height,
      ),
    );
  }
}