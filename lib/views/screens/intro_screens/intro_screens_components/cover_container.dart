import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';

class CoverContainer extends StatelessWidget {
  const CoverContainer({
    Key? key, this.sizePosition,
  }) : super(key: key);

  final double? sizePosition;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top(size: defSize! * 40),
      left: left(size: sizePosition ?? defSize! * 8),
      child: Container(
          height: defSize! * 34,
          width: defSize! * 34,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: kPrimaryColor.withAlpha(70))),
    );
  }
}