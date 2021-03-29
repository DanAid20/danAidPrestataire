import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';

import 'image_container.dart';

class ImageBox extends StatelessWidget {
  const ImageBox({
    Key key, this.image, this.bgColor = kPrimaryColor,
  }) : super(key: key);

  final String image;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: top(size: defSize * 12),
        left: left(size: defSize * 3),
        child: Container(
          child: Stack(
            children: [
              ImageContainer(image: image, bgColor: bgColor,),
              Container(
                  height: defSize * 37,
                  width: defSize * 37,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bgColor.withAlpha(50)
                  )
              )
            ],
          ),
        )
    );
  }
}