import 'package:flutter/cupertino.dart';

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  DashedLinePainter(
      {required this.color, required this.dashWidth, required this.dashSpace});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dashCount = (size.height / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startY = i * (dashWidth + dashSpace);
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) => false;
}