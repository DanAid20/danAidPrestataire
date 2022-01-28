import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/screens/intro_screens/intro_screens_components/intro_text.dart';
import 'package:flutter/material.dart';

import 'intro_screens_components/cover_container.dart';
import 'intro_screens_components/fee_container.dart';
import 'intro_screens_components/icon_container.dart';
import 'intro_screens_components/image_box.dart';

class MutuelleIntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          color: kFirstIntroColor,
          height: SizeConfig.screenHeight,
          child: Stack(
            children: [
              ImageBox(image: 'assets/images/image 7.png'),
              IconContainer(
                sizeTop: defSize! * 40,
                sizeRight: defSize! * 1.5,
                icon: 'assets/icons/Bulk/Calling.svg',
                containerBgColor: Colors.transparent,
                iconColor: Color(0xFFFAD427),
              ),
              CoverContainer(),
              FeeContainer(),
              IntroText(title: S.of(context)!.laMutuelleSant100Mobile, rank: 1,)
            ],
          ),
        ),
      ),
    );
  }
}








