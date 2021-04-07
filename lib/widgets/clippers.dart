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