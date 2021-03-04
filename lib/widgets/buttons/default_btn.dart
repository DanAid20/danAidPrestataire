import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';

class DefaultBtn extends StatelessWidget {
  const DefaultBtn({
    Key key, this.formKey, this.signText, this.signRoute = '/login',
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final String signText;
  final String signRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(size: 70),
      margin: EdgeInsets.symmetric(
          horizontal: horizontal(size: 15),
          vertical: vertical(size: 20)),
      child: RaisedButton(
        child: Text(
          signText ?? 'Connexion',
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.w800,
              fontSize: fontSize(size: 17)),
        ),
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)),
        onPressed: () => navigateReplaceTo(context: context, routeName: signRoute)
      ),
    );
  }
}