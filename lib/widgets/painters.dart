import 'package:flutter/material.dart';

class AdvantageCardCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint();
    var path = Path();

    // Start Drawing
    paint.color = Colors.white24;
    paint.style = PaintingStyle.fill;

    path.moveTo(size.width*0.0, size.height*1);
    path.quadraticBezierTo(size.width*0.25, size.height*1, size.width*0.5, size.height*1);
    path.quadraticBezierTo(size.width*1, size.height*0.6, size.width*1, size.height*1);
    path.quadraticBezierTo(size.width*1, size.height*1, size.width*1, size.height*1);
    path.quadraticBezierTo(size.width*1.0, size.height*1, size.width*1.0, size.height*0.0);
    path.lineTo(0, size.height);
    // End Drawing
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }
}