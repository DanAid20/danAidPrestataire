import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/clippers.dart';
import 'package:flutter/material.dart';

class DanAidDefaultHeader extends StatelessWidget {
  final bool showDanAidLogo;
  final Widget title;

  const DanAidDefaultHeader({Key key, this.showDanAidLogo = false, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      ClipPath(
        clipper: WaveClipperTop2(),
        child: Container(
          height: wv*42,
          decoration: BoxDecoration(
            color: Colors.grey[200]
          ),
        ),
      ),
      ClipPath(
        clipper: WaveClipperTop(),
        child: Container(
          height: wv*42,
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.9)
          ),
        ),
      ),
      Positioned(
        top: hv*5,
        left: wv*3,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: (){Navigator.pop(context);},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: wv*3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.arrow_back_ios_rounded, color: kDeepTeal,),
              ),
            ),
            SizedBox(width: wv*7,),
            showDanAidLogo ? Container(
              padding: EdgeInsets.symmetric(horizontal: wv*10),
              child: Image.asset('assets/icons/DanaidLogo.png')
            ) :
            title != null ? title : Container(),
          ],
        ),
      )
      ], alignment: AlignmentDirectional.topCenter,);
  }
}