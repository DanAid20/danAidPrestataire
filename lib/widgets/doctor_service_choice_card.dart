import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoctorServiceChoiceCard extends StatelessWidget {
  final String service;
  final String icon;
  final bool chosen;
  final Function action;

  const DoctorServiceChoiceCard({Key key, this.service, this.icon, this.chosen = false, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: wv*0.75),
      child: GestureDetector(
        onTap: action,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*0.8),
          decoration: BoxDecoration(
            color: chosen ? kPrimaryColor : whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: !chosen ? Colors.grey[400].withOpacity(0.5) : whiteColor, blurRadius: 1.0, spreadRadius: 0.5)]
          ),
          child: Row(children: [
            SvgPicture.asset(icon, color: !chosen ? kPrimaryColor : whiteColor, width: 20),
            SizedBox(width: wv*1),
            Text(service, style: TextStyle(color: !chosen ? kPrimaryColor : whiteColor),)
          ], mainAxisAlignment: MainAxisAlignment.center,),
        ),
      ),
    );
  }
}