import 'package:danaid/core/models/step.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/helpers/strings.dart';
import 'package:danaid/helpers/styles.dart';
import 'package:danaid/views/screens/intro_screens/mutelle_intro_screen.dart';
import 'package:danaid/views/screens/intro_screens/network_intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'intro_screens/medecin_intro_screen.dart';

class OnboardScreen extends StatefulWidget {
  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  List<StepModel> list = StepModel.list;
  List<Widget> _mPages = [MutuelleIntroScreen(), NetworkIntroScreen(), MedecinIntroScreen()];
  var _controller = PageController();
  var initialPage = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    _controller = PageController(initialPage: initialPage);
    _controller.addListener(() {
      setState(() {
        initialPage = _controller.page!.round();
      });
    });

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _body(_controller),
          (initialPage != list.length - 1)
              ? Positioned(bottom: 0, child: _indicator())
              : Positioned(
                bottom: 0,
                child: Container(
                    margin: EdgeInsets.only(bottom: bottom(size: 30)),
                    child: ButtonTheme(
                      minWidth: width(size: 300),
                      height: height(size: 64),
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: kPrimaryColor,
                          onPressed: () => Navigator.of(context).pushNamed('/login'),
                          child: Text(
                            Strings.START_APP.toUpperCase(),
                            softWrap: true,
                            style: Styles.onboardTextStyle,
                          )),
                    ),
                  ),
              ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _appBar(),
          ),
        ],
      ),
    );
  }

  _appBar() {
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.defaultSize! * 1.4),
      padding: EdgeInsets.all(SizeConfig.defaultSize! * 1.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (initialPage > 0)
                _controller.animateToPage(initialPage - 1,
                    duration: Duration(microseconds: 500),
                    curve: Curves.easeIn);
            },
            child: Container(
              width: SizeConfig.defaultSize! * 5,
              height: SizeConfig.defaultSize! * 5,
              padding: EdgeInsets.symmetric(
                  horizontal: horizontal(size: 12)),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Icon(
                Feather.arrow_left,
                color: whiteColor,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              if (initialPage < list.length)
                _controller.animateToPage(list.length,
                    duration: Duration(microseconds: 500),
                    curve: Curves.easeInOut);
            },
            child: Text(
              "Skip",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: fontSize(size: 16),
                color: whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _body(PageController controller) {
    return PageView.builder(
      controller: controller,
      itemCount: _mPages.length,
      itemBuilder: (context, index) => _mPages.elementAt(index)
    );
  }

  _indicator() {
    return Container(
      width: SizeConfig.defaultSize! * 8,
      height: SizeConfig.defaultSize! * 8,
      margin: EdgeInsets.symmetric(vertical: vertical(size: 14)),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                value: (initialPage + 1) / (list.length + 1),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                if (initialPage < list.length)
                  _controller.animateToPage(initialPage + 1,
                      duration: Duration(microseconds: 500),
                      curve: Curves.easeIn);
              },
              child: Container(
                width: SizeConfig.defaultSize! * 5.8,
                height: SizeConfig.defaultSize! * 5.8,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
