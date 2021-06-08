import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final String hintText;
  final String labelText;
  final bool isPassword;
  final bool isTextArea;
  final bool isBorderLess;
  final bool isComposed;
  final String helperText;
  final bool readOnly;
  final Function(String) validator;
  final String initialValue;
  final Function onTap;
  final Function(String) onChanged;
  final Function(String) onSaved;
  final Function(String) onFieldSubmitted;
  final List<TextInputFormatter> inputFormatters;
  final int maxLength;
  final int maxLines;
  final int minLines;
  final isExpands;
  final BorderSide borderSide;

  KTextFormField(
      {this.controller,
      this.hintText,
      this.labelText,
      this.isPassword = false,
      this.isTextArea = false,
      this.isBorderLess = true,
      this.isComposed = true,
      this.readOnly = false,
      this.keyboardType,
      this.prefixIcon,
      this.helperText,
      this.suffixIcon,
      this.validator,
      this.initialValue,
      this.onTap,
      this.onChanged,
      this.onSaved,
      this.maxLength,
      this.maxLines = 1,
      this.minLines = 1,
      this.inputFormatters,
      this.onFieldSubmitted,
      this.isExpands = false,
      this.borderSide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontal(size: 12),
          vertical: vertical(size: 15)),
      child: TextFormField(
        style: TextStyle(fontSize: 18, color: kTextColor),
        validator: validator,
        controller: controller,
        readOnly: this.readOnly,
        initialValue: initialValue,
        onTap: onTap,
        onSaved: onSaved,
        inputFormatters: inputFormatters,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.newline,
        expands: isExpands,
        maxLines: maxLines,
        minLines: minLines,
        obscureText: isPassword,
        maxLength: maxLength,
        decoration: InputDecoration(
          helperText: helperText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: labelText,
          hintText: hintText,
          counterText: "",
          hintStyle: TextStyle(fontSize: fontSize(size: 17)),
          labelStyle: TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.w800),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}


class ChoiceTile extends StatelessWidget {
  final bool isActive;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  ChoiceTile({this.isActive = false, this.onPressed, this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isActive ? Theme.of(context).primaryColor : Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                    icon,
                    size: 30,
                    color:
                    isActive ? Colors.white : kPrimaryColor
                ),
                SizedBox(height: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize(size: 15),
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? Colors.white
                        : kPrimaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDropDownButton extends StatelessWidget {
  final String label, initialText;
  final dynamic value;
  final Function(dynamic val) onChanged;
  final List<DropdownMenuItem<dynamic>> items;

  const CustomDropDownButton({Key key, this.label, this.value, this.initialText = "Choisir..", this.onChanged, this.items}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: kTextBlue),),
          SizedBox(height: 5,),
          Container(
            constraints: BoxConstraints(minWidth: wv*45),
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: ButtonTheme(alignedDropdown: true,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true, 
                  hint: Text(initialText), 
                  value: value,
                  items: items,
                  onChanged: onChanged)
              ),
            ),
          ),
      ],
    );
  }
}