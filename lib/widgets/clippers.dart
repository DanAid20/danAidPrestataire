import 'package:flutter/material.dart';

class WaveClipperTop extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height / 1.35);
    var firstControlPoint = new Offset(size.width / 4, size.height / 1);
    var firstEndPoint = new Offset(size.width / 1.6, size.height / 1 - 50);
    var secondControlPoint = new Offset(size.width - (size.width / 5), size.height / 1 - 65);
    var secondEndPoint = new Offset(size.width, size.height / 1 - 40);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) 
  {
    return true;
  }
}

class WaveClipperTop2 extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height / 1.35);
    var firstControlPoint = new Offset(size.width / 5, size.height/2.5);
    var firstEndPoint = new Offset(size.width / 1.8, size.height - 25);
    var secondControlPoint = new Offset(size.width - (size.width / 5), size.height);
    var secondEndPoint = new Offset(size.width, size.height / 1 - 40);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) 
  {
    return true;
  }
}

class BottomNavBarClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();

    // Start Drawing

    path.moveTo(0,size.height*0.30);
    path.quadraticBezierTo(size.width*0.35, size.height*0.45, size.width*0.68, size.height*0.3);
    path.quadraticBezierTo(size.width*0.80, size.height*0.25, size.width, size.height*0.4);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    // End Drawing
    
    return path;

  }

  @override
  bool shouldReclip(CustomClipper oldDelegate){
    return true;
  } 
}

class BottomNavBarBackgroundClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();

    // Start Drawing

    path.moveTo(0,size.height*0.30);
    path.quadraticBezierTo(size.width*0.35, size.height*0.0, size.width*0.70, size.height*0.7);
    path.quadraticBezierTo(size.width*0.80, size.height*0.75, size.width, size.height*0.4);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // End Drawing
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldDelegate){
    return true;
  } 
}