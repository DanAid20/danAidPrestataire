import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../core/services/getPlatform.dart';

class AdvantageCard extends StatelessWidget {

  final String? label, state, description, price;
  final Color? color;
  final bool? showLogo;
  final Function()? onTap;

  const AdvantageCard({Key? key, this.label, this.state, this.description, this.price, this.onTap, this.color, this.showLogo = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Device.isSmartphone(context) ? wv*2 : 10, vertical: Device.isSmartphone(context) ? hv*1.5 : 15),
        width: Device.isSmartphone(context) ? wv*50 : 400,
        height: Device.isSmartphone(context) ? wv*50/1.5 : 400/1.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(inch*2), boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 7, offset: Offset(0, 3))
          ]
        ),
        child: Column(
          children: [
            Container(
              width: Device.isSmartphone(context) ? wv*50 : 400,
              height: Device.isSmartphone(context) ? wv*50/1.5 : 400/1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(inch*2)),
                image: DecorationImage(image: AssetImage("assets/images/Plant.png"), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.2), BlendMode.dstATop)),
                color: color,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: wv*7,),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: inch*1, horizontal: inch*1.5),
                    child: Column(children: [
                      Row(children: [
                        Text(label!, style: TextStyle(fontSize: Device.isSmartphone(context) ? inch*1.7 : 25, fontWeight: FontWeight.bold, color: Colors.white)),
                        Expanded(child: Container()),
                        Text("DanAid", style: TextStyle(fontSize: Device.isSmartphone(context) ? inch*1.5 : 23, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],),
                      Align(child: Text(description == null ? state! : description!, style: TextStyle(fontSize: description == null ? 17 : 12, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.8))), alignment: Alignment.topLeft,),
                      Spacer(),
                      Align(
                        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(price!, style: TextStyle(fontSize: Device.isSmartphone(context) ? wv*7 : 45, fontWeight: FontWeight.bold, color: Colors.white),),
                            SizedBox(height: hv*1,),
                            SizedBox(
                              height: Device.isSmartphone(context) ? 30 : 50,
                              child: !showLogo! ? TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.90)),
                                  padding: MaterialStateProperty.all(EdgeInsets.only(left: Device.isSmartphone(context) ? inch*1.5 : 20, right: Device.isSmartphone(context) ? inch*0.5 : 10, top: 0, bottom: 0)),
                                  shape: MaterialStateProperty.all( RoundedRectangleBorder(borderRadius: BorderRadius.circular(inch*2)) )
                                ),
                                child: Row(children: [
                                  Text(S.of(context).demander, style: TextStyle(fontSize: Device.isSmartphone(context) ? inch*1.6 : 23, fontWeight: FontWeight.bold, color: color)),
                                  SizedBox(width: Device.isSmartphone(context) ? wv*1.5 : 10,),
                                  Icon(Icons.arrow_forward_ios, color: color, size: inch*2.3,),
                                ], mainAxisSize: MainAxisSize.min,),
                                onPressed: ()=>onTap,
                                ) : Align(child: Image.asset('assets/icons/DanaidLogo.png', width: wv*20,), alignment: Alignment.bottomRight,),
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