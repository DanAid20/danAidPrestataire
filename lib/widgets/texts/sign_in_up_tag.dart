import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SIgnInUpTag extends StatelessWidget {
  const SIgnInUpTag({
    Key key, this.title, this.subTitle, this.signRoute = '/register',
  }) : super(key: key);

  final String title;
  final String subTitle;
  final String signRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text.rich(TextSpan(
          text: title ?? 'Pas encore membre? ',
          style: TextStyle(
              color: kBgColor,
              fontSize: fontSize(size: 19)),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = ()
              => navigateReplaceTo(context: context, routeName: signRoute),
                text: subTitle ?? "S'inscrire",
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: fontSize(size: 20),
                    fontWeight: FontWeight.w700))
          ])),
    );
  }
}