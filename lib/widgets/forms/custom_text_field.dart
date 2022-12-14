import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends StatelessWidget {
  final String label, hintText, svgIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function validator;
  final Color fillColor, labelColor;
  final Widget prefixIcon, suffixIcon;
  final bool enabled;
  final bool multiLine, noPadding;
  final int minLines, maxLines;
  final Function editAction;
  final Function onChanged;
  final List<TextInputFormatter> inputFormatters;

  CustomTextField({Key key, this.label, this.hintText, this.controller, this.svgIcon, this.validator, this.keyboardType, this.prefixIcon, this.enabled = true, this.editAction, this.inputFormatters, this.multiLine = false, this.suffixIcon, this.fillColor, this.onChanged, this.minLines, this.maxLines, this.noPadding = false, this.labelColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: !noPadding ? EdgeInsets.symmetric(horizontal: wv * 3) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: labelColor ?? Colors.grey[600]),
          ),
          SizedBox(
            height: 5,
          ),
          Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.center,
            children: [
              TextFormField(
                minLines: multiLine ? minLines : 1,
                maxLines: multiLine ? maxLines : 1,
                enabled: enabled,
                keyboardType: keyboardType,
                controller: controller,
                validator: this.validator,
                inputFormatters: inputFormatters,
                onChanged: onChanged,
                style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  prefixIcon: prefixIcon,
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red[300]),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  fillColor: fillColor == null ? Colors.grey[100] : fillColor,
                  //prefixIcon: Icon(Icons.search, color: kBrownCanyon,),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: kPrimaryColor.withOpacity(0.0)),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: svgIcon != null
                      ? SvgPicture.asset(
                          svgIcon,
                          height: wv * 4,
                          color: Colors.teal,
                        )
                      : null,
                ),
              ),
              !enabled
                  ? Positioned(
                      right: wv * 0,
                      child: IconButton(
                        enableFeedback: false,
                        icon: CircleAvatar(
                          radius: wv * 3.5,
                          backgroundColor: kDeepTeal,
                          child: Icon(
                            Icons.edit,
                            color: whiteColor,
                            size: wv * 4,
                          ),
                        ),
                        onPressed: editAction,
                      ),
                    )
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}

InputDecoration socialDefaultDecoration({String hintText, Color color}){
  return InputDecoration(
    prefixIcon: SizedBox(width: wv*7,),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.red[300]),
        borderRadius: BorderRadius.all(Radius.circular(20))),
    fillColor: Colors.white.withOpacity(0.3),
    contentPadding: EdgeInsets.only(top: hv*1, bottom: hv*1, left: wv*3, right: wv*7),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: color.withOpacity(0.0)),
        borderRadius: BorderRadius.all(Radius.circular(20))),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.white.withOpacity(0.35)),
        borderRadius: BorderRadius.all(Radius.circular(20))),
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
  );
}
