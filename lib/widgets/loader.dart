import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/images/loading.gif"),
        Text("Please wait..."),
      ],
    );
  }
}
