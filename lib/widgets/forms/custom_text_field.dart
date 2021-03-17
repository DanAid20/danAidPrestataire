import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label, hintText;
  final TextEditingController controller;

  const CustomTextField({Key key, this.label, this.hintText, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: wv*3),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w600),),
          SizedBox(height: 5,),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.red[300]),
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              fillColor: Colors.grey[100],
              //prefixIcon: Icon(Icons.search, color: kBrownCanyon,),
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: kPrimaryColor.withOpacity(0.0)),
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: kPrimaryColor.withOpacity(0.0)),
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              hintText: hintText,
              hintStyle: TextStyle(color: kBrownCanyon)
            ),
          ),
        ],
      ),
    );
  }
}