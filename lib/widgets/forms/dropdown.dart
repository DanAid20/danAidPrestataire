import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String? value, label, hintText;
  final List<DropdownMenuItem<String>>? items;
  final Function(String)? onChanged;

  const CustomDropdownButton({Key? key, this.value, this.label, this.items, this.onChanged, this.hintText = "Choisir.."}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label!, style: TextStyle(fontSize: 16, color: kTextBlue, fontWeight: FontWeight.w400),),
        SizedBox(height: 5,),
        Container(
          constraints: BoxConstraints(minWidth: wv*45),
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                hint: Text(hintText!),
                value: value,
                items: items,
                onChanged: (string)=>onChanged
              ),
            ),
          ),
        ),
      ],
    );
  }
}