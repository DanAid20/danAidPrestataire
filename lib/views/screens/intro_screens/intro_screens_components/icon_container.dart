import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconContainer extends StatelessWidget {
  const IconContainer({
    Key key, this.icon = 'assets/icons/Two-tone/Category.svg',
    this.sizeTop, this.sizeRight,
    this.containerBgColor = const Color(0xFFFAD427),
    this.iconColor = kFirstIntroColor,
  }) : super(key: key);

  final String icon ;
  final Color containerBgColor;
  final Color iconColor;
  final double sizeTop;
  final double sizeRight;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top(size: sizeTop ?? defSize * 47),
      right: right(size: sizeRight ?? defSize * 10),
      child: CircleAvatar(
        radius: defSize * 5,
        backgroundColor: containerBgColor,
        child: SvgPicture.asset(
          icon,
          color: iconColor,
          height: defSize * 4.7,
          width: defSize * 4.7,
        ),
      ),
    );
  }
}