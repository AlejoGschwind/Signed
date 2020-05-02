import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Signature extends CustomPainter {
  Signature({this.points});
  final List<Offset> points;
  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = new Paint()
      ..color = Colors.black87
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.miter
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;


    for (int i= 0; i < points.length -1; i++) {
      // Draw a line     
      if (points[i] != null && points[i+1] != null) {
        canvas.drawLine(points[i], points[i+1], paint);
//        canvas.drawPoints(PointMode.polygon, points, paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}