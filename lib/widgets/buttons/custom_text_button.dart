import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Function action;
  final Color color;

  const CustomTextButton({Key key, this.text, this.action, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: wv*3.2, vertical: hv*2),
      child: TextButton(
        onPressed: action,
        child: Text(text, style: TextStyle(color: whiteColor, fontSize: wv*4.5, fontWeight: FontWeight.w600),),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15)),
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))
            )
          )
        ),
      ),
    );
  }
}