import 'package:flutter/cupertino.dart';

import 'DashedLinePainter.dart';

class DashedLine extends StatelessWidget {
  final Color color;
  final double height;
  final double dashWidth;
  final double dashSpace;

  const DashedLine({super.key,
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
      child: SizedBox(
        width: 1.0,
        height: height,
      ),
    );
  }
}