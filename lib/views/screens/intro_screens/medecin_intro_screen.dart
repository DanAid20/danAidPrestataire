import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';

import 'intro_screens_components/cover_container.dart';
import 'intro_screens_components/fee_container.dart';
import 'intro_screens_components/icon_container.dart';
import 'intro_screens_components/image_box.dart';
import 'intro_screens_components/intro_text.dart';

class MedecinIntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          color: kThirdIntroColor,
          child: Stack(
            children: [
              ImageBox(
                image: 'assets/images/image 9.png',
                bgColor: Colors.grey,
              ),
              IconContainer(
                sizeTop: defSize * 42,
                sizeRight: defSize * 4,
                containerBgColor: Colors.white70,
                iconColor: kPrimaryColor,
                icon: 'assets/icons/Two-tone/Activity.svg',
              ),
              CoverContainer(sizePosition: defSize),
              FeeContainer(
                sizeLeft: defSize * 2.5,
                sizeTop: defSize * 12,
                feeBgColor: kPrimaryColor,
              ),
              IntroText(title: 'Un médecin de Famille me suit ')
            ],
          ),
        ),
      ),
    );
  }
}
