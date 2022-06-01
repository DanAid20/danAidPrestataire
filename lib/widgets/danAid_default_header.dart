import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/clippers.dart';
import 'package:flutter/material.dart';

import '../core/services/getPlatform.dart';

class DanAidDefaultHeader extends StatelessWidget {
  final bool showDanAidLogo, showBackButton;
  final Color? color;
  final Widget? title;

  const DanAidDefaultHeader({Key? key, this.showDanAidLogo = false, this.showBackButton = true, this.title, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      ClipPath(
        clipper: WaveClipperTop2(),
        child: Container(
          height: hv*22,
          decoration: BoxDecoration(
            color: Colors.grey[200]
          ),
        ),
      ),
      ClipPath(
        clipper: WaveClipperTop(),
        child: Container(
          height: hv*22,
          decoration: BoxDecoration(
            color: color ?? kPrimaryColor.withOpacity(0.9)
          ),
        ),
      ),
      Positioned(
        top: Device.isSmartphone(context) ? hv*5 : 20,
        left: Device.isSmartphone(context) ? wv*3 : 20,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            showBackButton ? GestureDetector(
              onTap: (){Navigator.pop(context);},
              child: Container(
                padding: EdgeInsets.all(Device.isSmartphone(context) ? wv*3 : 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(Device.isSmartphone(context) ? 20 : 30),
                ),
                child: Icon(Icons.arrow_back_ios_rounded, color: kDeepTeal, size: Device.isSmartphone(context) ? wv*8 : 40,),
              ),
            ) : Container(),
            SizedBox(width: Device.isSmartphone(context) ? wv*7 : 60,),
            showDanAidLogo ? Container(
              padding: Device.isSmartphone(context) ? EdgeInsets.symmetric(horizontal: wv*10) : EdgeInsets.zero,
              child: Image.asset('assets/icons/DanaidLogo.png')
            ) :
            title != null ? title! : Container(),
          ],
        ),
      )
      ], alignment: AlignmentDirectional.topCenter,);
  }
}