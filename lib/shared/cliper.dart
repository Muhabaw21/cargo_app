import 'package:flutter/material.dart';

class HalfCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  HalfCircle(
      {required this.size, required this.color, required this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HalfCirclePainter(color: color, strokeWidth: strokeWidth),
      size: Size(size, size),
    );
  }
}

class HalfCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  HalfCirclePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width * 0.5,
    );

    canvas.drawArc(
        rect, 90 * (3.14159265 / 180), 180 * (3.14159265 / 300), false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
