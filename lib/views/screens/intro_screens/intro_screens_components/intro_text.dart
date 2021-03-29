import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';

class IntroText extends StatelessWidget {
  const IntroText({
    Key key, this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom(size: defSize * 13),
      left: 0,
      right: 0,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: horizontal(size: defSize * 5)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize(size: defSize * 2.32),
                  fontWeight: FontWeight.w600
              ),
            ),
            VerticalSpacing(of: inch * 1.18),
            Text.rich(
              TextSpan(
                  text: 'Avec votre famille, bénéficiez d’une couverture de ',
                  children: [
                    TextSpan(
                        text: '70% ',
                        style: TextStyle(fontWeight: FontWeight.w700)
                    ),
                    TextSpan(text: 'en '),
                    TextSpan(
                        text: '1 heures, ',
                        style: TextStyle(fontWeight: FontWeight.w700)
                    ),
                    TextSpan(text: 'partout au Cameroun. '),
                  ]
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  height: 1.5,
                  letterSpacing: .72,
                  fontSize: fontSize(size: defSize * 1.8)),
            ),
          ],
        ),
      ),
    );
  }
}