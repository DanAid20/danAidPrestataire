import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class DefaultBtn extends StatelessWidget {
  DefaultBtn({
    Key? key, this.formKey,
    this.signText, this.signRoute = '/login', this.onPress, this.bgColor,
  }) : super(key: key);

  final GlobalKey<FormState>? formKey;
  final String? signText;
  final String? signRoute;
  final Function? onPress;
  final Color? bgColor;

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(size: 70),
      width: SizeConfig.screenWidth! * .9,
      margin: EdgeInsets.symmetric(
          horizontal: horizontal(size: 15),
          vertical: vertical(size: 25)),
      child: RaisedButton(
        child: Text(
          signText ?? S.of(context)!.connexion,
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.w800,
              fontSize: fontSize(size: 17)),
        ),
        color: bgColor ?? kPrimaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)),
        onPressed: ()=> onPress
      ),
    );
  }
}