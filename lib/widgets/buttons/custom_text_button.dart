import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String? text;
  final Function? action;
  final Color? color;
  final Color? textColor;
  final Color? loaderColor;
  final bool? expand;
  final bool? noPadding;
  final bool? isLoading;
  final bool? enable;
  final double? fontSize;
  final double? borderRadius;

  const CustomTextButton({Key? key, this.text, this.action, this.isLoading = false, this.loaderColor = kPrimaryColor, this.color = kPrimaryColor, this.expand = true, this.textColor = whiteColor, this.noPadding = false, this.enable = true, this.fontSize = 18, this.borderRadius = 15}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return enable! ? !isLoading! ? Container(
      width: expand! ? double.infinity : null,
      padding: !noPadding! ? EdgeInsets.symmetric(horizontal: wv * 3.2, vertical: hv * 2) : EdgeInsets.zero,
      child: TextButton(
        onPressed: ()=>action,
        child: Text(text!, style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius!))))),
      ),
    ) : Center(child: Loaders().buttonLoader(color!))
     : 
    CustomDisabledTextButton(text: text!, noPadding: noPadding!, borderRadius: borderRadius!, fontSize: fontSize!);
  }
}

class CustomDisabledTextButton extends StatelessWidget {
  final String? text;
  final bool? noPadding;
  final bool? expand;
  final double? fontSize;
  final double? borderRadius;

  const CustomDisabledTextButton({Key? key, this.text, this.expand = true, this.noPadding = false, this.fontSize = 18, this.borderRadius = 15}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: expand! ? double.infinity : null,
      padding: !noPadding! ? EdgeInsets.symmetric(horizontal: wv * 3.2, vertical: hv * 2) : EdgeInsets.zero,
      child: TextButton(
        onPressed: null,
        child: Text(
          text!,
          style: TextStyle(color: Colors.grey[700], fontSize: fontSize, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
            backgroundColor: MaterialStateProperty.all(Colors.grey[400]),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius!))))),
      ),
    );
  }
}
