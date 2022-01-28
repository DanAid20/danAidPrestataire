import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration:
              BoxDecoration(color: kPrimaryColor.withOpacity(.1)),
        ),
        Positioned(
          left: left(
              size: -(SizeConfig.screenHeight! * 0.5 -
                  SizeConfig.screenWidth! * 0.5)),
          bottom: bottom(size: 130),
          child: Container(
            width: SizeConfig.screenHeight,
            height: SizeConfig.screenHeight,
            decoration: BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
          ),
        ),
        Positioned(
          top: top(size: -SizeConfig.screenHeight! * 0.6),
          left: left(size: -SizeConfig.screenWidth! * 0.5),
          child: Container(
            width: SizeConfig.screenHeight! * 0.8,
            height: SizeConfig.screenHeight! * .8,
            decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(.8),
                shape: BoxShape.circle),
          ),
        ),
      ],
    );
  }
}
