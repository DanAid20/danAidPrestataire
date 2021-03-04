import 'package:danaid/helpers/colors.dart';
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

class BottomNavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint();
    var path = Path();

    // Start Drawing
    paint.color = kPrimaryColor;
    paint.style = PaintingStyle.fill;

    path.moveTo(0,size.height*0.30);
    path.quadraticBezierTo(size.width*0.35, size.height*0.45, size.width*0.68, size.height*0.3);
    path.quadraticBezierTo(size.width*0.80, size.height*0.25, size.width, size.height*0.4);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    // End Drawing
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  } 
}

class BottomNavBarBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint();
    var path = Path();

    // Start Drawing
    paint.color = Colors.grey.withOpacity(0.2);
    paint.style = PaintingStyle.fill;

    path.moveTo(0,size.height*0.30);
    path.quadraticBezierTo(size.width*0.35, size.height*0.0, size.width*0.70, size.height*0.7);
    path.quadraticBezierTo(size.width*0.80, size.height*0.75, size.width, size.height*0.4);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    // End Drawing
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  } 
}