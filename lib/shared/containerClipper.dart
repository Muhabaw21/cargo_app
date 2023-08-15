import 'dart:math';

import 'package:flutter/material.dart';

class QuarterCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Color:
    Colors.white;
    final path = Path();
    final radius = min(size.width, size.height);
    path.lineTo(radius, 0.0);
    path.arcTo(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      -pi / 2,
      -pi / 2,
      false,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
