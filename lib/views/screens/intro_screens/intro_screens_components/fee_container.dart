import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeeContainer extends StatelessWidget {
  const FeeContainer({
    Key key, this.sizeLeft, this.sizeTop, this.feeBgColor,
  }) : super(key: key);

  final double sizeLeft;
  final double sizeTop;
  final Color feeBgColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top(size: sizeTop ?? defSize * 43),
      left: left(size: sizeLeft ?? defSize * 4),
      child: CircleAvatar(
        radius: defSize * 6.2,
        backgroundColor: feeBgColor ?? Color(0xFF57CECA),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Couverture à',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.robotoCondensed().fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize(size: defSize * 1.5)),
            ),
            Text(
              '70%',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.robotoCondensed().fontFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize(size: defSize * 3.7)),
            ),
          ],
        ),
      ),
    );
  }
}