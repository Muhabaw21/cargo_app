import 'package:flutter/material.dart';

class HalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pink
      ..strokeWidth = 5;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0,
      3.14159265,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(HalfCirclePainter oldDelegate) => false;
}