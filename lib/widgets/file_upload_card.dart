import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class FileUploadCard extends StatelessWidget {

  final String? title;
  final bool? state;
  final bool? loading;
  final bool? isMultiple;
  final Function? action;

  const FileUploadCard({Key? key, this.title, this.state, this.action, this.loading, this.isMultiple = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: wv*0.5),
      padding: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*1),
      decoration: BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(blurRadius: 2, spreadRadius: 1, color: Colors.grey[200]!)]
      ),
      child: Row(children: [
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: state! ? kDeepTeal : Colors.red[400],
                child: Icon(
                  state! ? isMultiple! ? LineIcons.medicalFile : LineIcons.file : LineIcons.times, 
                  color: Colors.white,
              )),
              SizedBox(width: wv*3,),
              Expanded(child: Container(child: Text(title!, overflow: TextOverflow.fade,), constraints: BoxConstraints(maxWidth: wv*60), )),
            ],
          ),
        ),
        Align(alignment: Alignment.centerRight,
          child: !loading! ? TextButton(
            onPressed: ()=>action, 
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kPrimaryColor),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
            child: Text(state! && !isMultiple! ? S.of(context)!.remplacer : S.of(context)!.ajouter, style: TextStyle(color: Colors.white),)) : 
            Padding(
              padding: EdgeInsets.all(4.0),
              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),
            )
        )
      ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
    );
  }
}