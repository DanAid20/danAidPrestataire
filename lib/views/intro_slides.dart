import 'package:danaid/core/services/getPlatform.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:coast/coast.dart';
import 'package:flutter_svg/flutter_svg.dart';


class IntroSlides extends StatefulWidget {
  @override
  _IntroSlidesState createState() => _IntroSlidesState();
}

class _IntroSlidesState extends State<IntroSlides> {

  int currentPageValue = 0;

  @override
  Widget build(BuildContext context) {
    final _pages = [
      Beach(builder: (context) => SlideA()),
      Beach(builder: (context) => SlideB()),
      Beach(builder: (context) => SlideC()),
    ];

    final _coastController = CoastController(initialPage: currentPageValue);

    return WillPopScope(
      onWillPop: () async {_coastController.animateTo(beach: currentPageValue-1, duration: Duration(milliseconds: 500)); return false;},
      child: Scaffold(
        body: AnimatedContainer(
          color: currentPageValue == 0 ? kBlueDeep : currentPageValue == 1 ? kBrownCanyon : kSouthSeas,
          duration: Duration(milliseconds: 200),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Coast(
                controller: _coastController,
                beaches: _pages,
                observers: [CrabController()],
                onPageChanged: (int page) {
                  getChangedPageAndMoveBar(page);
                },
              ),

              AnimatedPositioned(
                top: hv*10,
                duration: Duration(milliseconds: 300),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      height: hv*43,
                      width: hv*43,
                      decoration: BoxDecoration(
                        color: whiteColor.withOpacity(0.1),
                        shape: BoxShape.circle
                      ),
                    ),
                    Container(
                      height: hv*40,
                      width: hv*40,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(currentPageValue == 0 ? 'assets/images/image 7.png' : currentPageValue == 1 ? 'assets/images/image 8.png' : 'assets/images/image 9.png'), fit: BoxFit.cover),
                        shape: BoxShape.circle
                      ),
                    ),
                  ],
                ),
              ),

              AnimatedPositioned(
                top: currentPageValue == 0 ? hv*38 : currentPageValue == 1 ? hv*45 : hv*40,
                left: currentPageValue == 0 ? wv*15 : currentPageValue == 1 ? wv*3 : wv*3,
                duration: Duration(milliseconds: 300),
                child: Container(
                  height: wv*75,
                  width: wv*75,
                  padding: EdgeInsets.symmetric(horizontal: wv*2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    shape: BoxShape.circle
                  ),
                ),
              ),

              AnimatedPositioned(
                top: currentPageValue == 0 ? hv*40 : currentPageValue == 1 ? hv*43 : hv*35,
                left: currentPageValue == 0 ? Device.isSmartphone(context) ? wv*70 : 1000 : currentPageValue == 1 ? Device.isSmartphone(context) ? wv*48 : 1200 : Device.isSmartphone(context) ? wv*70 : 1100,
                duration: Duration(milliseconds: 300),
                child: Container(
                  width: wv*20,
                  padding: EdgeInsets.all(wv*4),
                  decoration: BoxDecoration(
                    color: currentPageValue == 0 ? Colors.transparent : currentPageValue == 1 ? primaryColor : Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle
                  ),
                  child: currentPageValue == 0 ? SvgPicture.asset('assets/icons/Bulk/Calling.svg', color: primaryColor, width: wv*15,) : currentPageValue == 1 ? SvgPicture.asset('assets/icons/Two-tone/Category.svg', color: kCardTextColor, width: wv*15,) : SvgPicture.asset('assets/icons/Two-tone/Activity.svg', color: kBrownCanyon, width: wv*15,),
                ),
              ),

              AnimatedPositioned(
                top: currentPageValue == 0 ? Device.isSmartphone(context) ? hv*35 : 200 : currentPageValue == 1 ? hv*30 : hv*4,
                left: currentPageValue == 0 ? Device.isSmartphone(context) ? wv*7 : 600 : currentPageValue == 1 ? Device.isSmartphone(context) ? wv*60 : 1100 : Device.isSmartphone(context) ? wv*5 : 700,
                duration: Duration(milliseconds: 300),
                child: Container(
                  height: 200,
                  padding: EdgeInsets.symmetric(horizontal: wv*2),
                  decoration: BoxDecoration(
                    color: currentPageValue == 2 ? kCardTextColor : kSouthSeas,
                    shape: BoxShape.circle
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).couverture, style: TextStyle(color: whiteColor, fontSize: 18, fontWeight: FontWeight.bold),),
                      Text(S.of(context).soixanteDixpourCent, style: TextStyle(color: whiteColor, fontSize: 50, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: Device.isSmartphone(context) ? hv*15 : 220,
                child: Container(
                  width: Device.isSmartphone(context) ? wv*95 : 600,
                  padding: EdgeInsets.symmetric(horizontal: wv*2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(currentPageValue == 0 ? S.of(context).laMutuelleSant100Mobile : currentPageValue == 1 ?  S.of(context).unRseauDentraide : S.of(context).unMdecinDeFamilleMeSuit, style: TextStyle(color: currentPageValue == 2 ? kCardTextColor : whiteColor, fontSize: Device.isSmartphone(context) ? wv*6.2 : 40, fontWeight: FontWeight.w900), textAlign: TextAlign.center,),
                      SizedBox(height: hv*2.5,),
                      SizedBox(
                        width: wv*90,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(color: currentPageValue == 2 ? kCardTextColor : whiteColor, fontSize: Device.isSmartphone(context) ? wv*5.7 : 35, fontWeight: FontWeight.w300),
                            children: [
                              TextSpan(text: currentPageValue == 0 ? S.of(context).avecVotreFamilleBnficiezDuneCouvertureSantDe : currentPageValue == 1 ? S.of(context).enCasDeBesoinObtenezLaideDesMembresDuRseau : S.of(context).monMdecinDeFamillePersonnelReuRapidementOrientSuiviLong),
                              TextSpan(text: currentPageValue == 0 ? S.of(context).soixanteDixpourCent : currentPageValue == 1 ?  S.of(context).prtSant : S.of(context).danaid, style: TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(text: currentPageValue == 0 ? S.of(context).deVosDpensesSantEn : currentPageValue == 1 ?  S.of(context).enQuelquesMinutes : S.of(context).veilleSurNotreSant),
                              TextSpan(text: currentPageValue == 0 ? S.of(context).UneHeure : currentPageValue == 1 ?  "" : "", style: TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(text: currentPageValue == 0 ? S.of(context).partout : currentPageValue == 1 ?  "" : ""),
                            ]
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: wv*4, right: wv*2, top: hv*5),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: ()=>_coastController.animateTo(beach: currentPageValue-1, duration: Duration(milliseconds: 500)),
                      child: Container(
                        padding: EdgeInsets.all(Device.isSmartphone(context) ? wv*3 : 40),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(Device.isSmartphone(context) ? 20 : 40),
                        ),
                        child: Icon(Icons.arrow_back_ios_rounded, color: kDeepTeal, size: Device.isSmartphone(context) ? wv*8 : 60,),
                      ),
                    ),
                    Spacer(),
                    currentPageValue == 2 ? SizedBox(width: wv*1,) : TextButton(
                      onPressed: (){_coastController.animateTo(beach: 2, duration: Duration(milliseconds: 500));}, 
                      child: Text(S.of(context).skip, style: TextStyle(color: whiteColor, fontSize: 19, fontWeight: FontWeight.bold),)
                    )
                  ],
                ),
              ),

              Positioned(
                bottom: hv*2,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    SizedBox(
                      width: Device.isSmartphone(context) ? wv*16 : 150,
                      height: Device.isSmartphone(context) ? wv*16 : 150,
                      child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: currentPageValue == 0 ? 0.35 : currentPageValue == 1 ? 0.7 : 1),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, _) => CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(kCardTextColor),
                            value: value
                          ),
                      ),
                    ),

                    MaterialButton(
                      onPressed: () {
                        if(currentPageValue == 2)
                          Navigator.of(context).pushNamed('/login');
                        else
                          _coastController.animateTo(beach: currentPageValue+1, duration: Duration(milliseconds: 800));
                      },
                      color: kCardTextColor,
                      textColor: Colors.white,
                      elevation: 0,
                      child: Icon(
                        currentPageValue == 2 ? Icons.check : Icons.arrow_forward_ios_rounded,
                        size: Device.isSmartphone(context) ? wv*5 : 50,
                      ),
                      padding: EdgeInsets.all(Device.isSmartphone(context) ? 16 : 40),
                      shape: CircleBorder(),
                    )

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }
}

class SlideA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
          children: [
            Positioned(
              top: 55,
              right: 0,
              child: SvgPicture.asset('assets/icons/zigzag1.svg')
            ),
          ],
      ),
    );
  }
}

class SlideB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
          children: [
            Positioned(
              top: 50,
              child: Row(
                children: [
                  Container(
                    height: 482,
                    width: wv*100,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: SvgPicture.asset('assets/icons/zigzag2.svg',)
                    ),
                  ),
                ],
              ),
            ),
          ],
      ),
    );
  }
}

class SlideC extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
          children: [
            Positioned(
              top: 100,
              child: SvgPicture.asset('assets/icons/zigzag3.svg')
            ),
          ],
      ),
    );
  }
}