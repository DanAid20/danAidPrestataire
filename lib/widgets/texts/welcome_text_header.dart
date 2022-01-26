import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: top(size: 7)),
      child: Text.rich(TextSpan(
          text: 'Bienvenue ',
          style: TextStyle(
              color: whiteColor,
              fontSize: fontSize(size: 19)),
          children: [
            TextSpan(
                text: 'John Doe',
                style: TextStyle(
                    color: whiteColor,
                    fontSize: fontSize(size: 22),
                    fontWeight: FontWeight.w700))
          ])),
    );
  }
}