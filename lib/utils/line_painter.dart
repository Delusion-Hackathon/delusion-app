import 'dart:ui';

import 'package:delusion_drag_and_drop/main.dart';
import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final List<Offset> points;
  final List<Color> lineColors;
  final Offset? startPoint;
  final Offset? endPoint;

  LinePainter(this.points, this.startPoint, this.endPoint, this.lineColors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length; i += 2) {
      paint.color = lineColors[i ~/ 2]; // Set color for this line
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    if (startPoint != null && endPoint != null) {
      paint.color =
          currentColor.cableColor; // Use current color for the line being drawn
      canvas.drawLine(startPoint!, endPoint!, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Return true to repaint when drag updates
  }
}