import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/painters.dart';
import 'package:flutter/material.dart';

class AdvantageCard extends StatelessWidget {

  final String label, state, description, price;
  final Color color;
  final Function onTap;

  const AdvantageCard({Key key, this.label, this.state, this.description, this.price, this.onTap, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*1.5),
        constraints: BoxConstraints(maxWidth: wv*50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(inch*2), boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 7, offset: Offset(0, 3))
          ]
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(inch*2)),
                color: color,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: wv*7,),
                        Container(
                          width: wv*30,
                          height: wv*15,
                          child: CustomPaint(painter: AdvantageCardCurvePainter(),),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: inch*1, horizontal: inch*1.5),
                    child: Column(children: [
                      Row(children: [
                        Text(label, style: TextStyle(fontSize: inch*1.7, fontWeight: FontWeight.bold, color: Colors.white)),
                        Expanded(child: Container()),
                        Text("DanAid", style: TextStyle(fontSize: inch*1.5, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],),
                      Align(child: Text(state, style: TextStyle(fontSize: inch*1.7, fontWeight: FontWeight.w400, color: Colors.white)), alignment: Alignment.topLeft,),
                      Align(
                        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(price, style: TextStyle(fontSize: inch*2.2, fontWeight: FontWeight.bold, color: Colors.white70),),
                            SizedBox(height: hv*1,),
                            Container(
                              width: wv*25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(inch*1.5)),
                                color: Colors.white.withOpacity(0.80),
                              ),
                              padding: EdgeInsets.only(left: inch*1.5, right: inch*0.5, top: inch*0.3, bottom: inch*0.3),
                              child: Row(children: [
                                Text("Demander", style: TextStyle(fontSize: inch*1.6, fontWeight: FontWeight.bold, color: color)),
                                Icon(Icons.arrow_forward_ios, color: color,),
                              ],mainAxisAlignment: MainAxisAlignment.spaceBetween, )
                            )
                          ],
                        ), alignment: Alignment.bottomRight,),
                    ],),
                  )
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}