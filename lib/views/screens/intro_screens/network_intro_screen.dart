import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';

import 'intro_screens_components/cover_container.dart';
import 'intro_screens_components/fee_container.dart';
import 'intro_screens_components/icon_container.dart';
import 'intro_screens_components/image_box.dart';
import 'intro_screens_components/intro_text.dart';

class NetworkIntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          color: kSecIntroColor,
          height: SizeConfig.screenHeight,
          child: Stack(
            children: [
              ImageBox(
                  image: 'assets/images/image 8.png',
                  bgColor: Colors.grey,
              ),
              IconContainer(),
              CoverContainer(sizePosition: defSize),
              FeeContainer(sizeLeft: defSize * 29, sizeTop: defSize * 40,),
              IntroText(title: S.of(context).unRseauDentraideSant, rank: 2,)
            ],
          ),
        ),
      ),
    );
  }
}
