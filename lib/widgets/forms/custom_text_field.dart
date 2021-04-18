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
  final Widget prefixIcon;
  final bool enabled;
  final Function editAction;
  final List<TextInputFormatter> inputFormatters;

<<<<<<< Updated upstream
  const CustomTextField({Key key, this.label, this.hintText, this.controller, this.svgIcon, this.validator, this.keyboardType, this.prefixIcon, this.enabled = true, this.editAction, this.inputFormatters}) : super(key: key);
=======
  const CustomTextField(
      {Key key,
      this.label,
      this.hintText,
      this.controller,
      this.svgIcon,
      this.validator,
      this.keyboardType,
      this.prefixIcon,
      this.enabled = true,
      this.editAction,
      this.inputFormatters,
      this.multiLine = false})
      : super(key: key);
>>>>>>> Stashed changes
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: wv * 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: wv * 4, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 5,
          ),
          Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.center,
            children: [
              TextFormField(
                enabled: enabled,
                keyboardType: keyboardType,
                controller: controller,
                validator: this.validator,
                inputFormatters: inputFormatters,
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  prefixIcon: prefixIcon,
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red[300]),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  fillColor: Colors.grey[100],
                  //prefixIcon: Icon(Icons.search, color: kBrownCanyon,),
<<<<<<< Updated upstream
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
=======
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 5),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
              !enabled ?
                Positioned(
                  right: wv*2,
                  child: GestureDetector(
                    onTap: editAction,
                    child: CircleAvatar(
                        radius: wv*3.5,
                        backgroundColor: kDeepTeal,
                        child: Icon(Icons.edit, color: whiteColor, size: wv*4,),
                      ),
                  ),
                ) : Container()
=======
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
>>>>>>> Stashed changes
            ],
          ),
        ],
      ),
    );
  }
}
