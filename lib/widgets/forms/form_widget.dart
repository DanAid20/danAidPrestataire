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
      this.maxLength = 7,
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
          vertical: vertical(size: 10)),
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
          hintStyle:
              TextStyle(fontSize: getProportionateScreenWidth(17)),
          labelStyle: TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.w600),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
