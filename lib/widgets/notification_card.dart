import 'package:danaid/core/utils/config_size.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {

  final String instruction, description;
  final Function onTap;
  final bool  isprestataire;
  const NotificationCard({Key key,this.instruction, this.description, this.onTap, this.isprestataire}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*1.5),
        constraints: BoxConstraints(maxWidth: wv*60, minHeight: hv*22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(inch*2), 
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 7, offset: Offset(0, 3))
          ]
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isprestataire ? SizedBox.shrink() :  Container(
              height: hv*8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(inch*2), topRight: Radius.circular(inch*2)),
                image: DecorationImage(image: AssetImage("assets/images/detail_illustration.png"), fit: BoxFit.fitWidth)
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1),
              child: Column(children: [
                Container(child: Text(description, style: TextStyle(fontSize: inch*1.7), maxLines: 4, overflow: TextOverflow.ellipsis,)),
                SizedBox(height: hv*3,),
                Text(instruction, style: TextStyle(fontSize: inch*1.7, fontWeight: FontWeight.bold, color: Colors.teal[200])),
              ], crossAxisAlignment: CrossAxisAlignment.start,)
            )
          ],
        ),
      ),
    );
  }
}