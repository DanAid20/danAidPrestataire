import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    Key key,
    this.image, this.bgColor,
  }) : super(key: key);

  final String image;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: defSize * 37,
      width: defSize * 37,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor.withOpacity(.1)
      ),
      child: CircleAvatar(
        radius: defSize * 10,
        backgroundColor: Colors.transparent,
        child: Container(
          width: width(size: 375),
          height: height(size: 375),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(image), fit: BoxFit.cover)),
        ),
      ),
    );
  }
}