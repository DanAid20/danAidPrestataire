import 'package:danaid/core/models/step.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/helpers/strings.dart';
import 'package:danaid/helpers/styles.dart';
import 'package:flutter/material.dart';

class OnboardScreen extends StatefulWidget {
  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  List<StepModel> list = StepModel.list;
  var _controller = PageController();
  var initialPage = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    _controller.addListener(() {
      setState(() {
        initialPage = _controller.page.round();
      });
    });

    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(),
          _body(_controller),
          (initialPage != list.length - 1)
              ? _indicator()
              : Container(
                  margin: EdgeInsets.only(bottom: bottom(size: 30)),
                  child: ButtonTheme(
                    minWidth: width(size: 300),
                    height: height(size: 64),
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: kPrimaryColor,
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed('/login'),
                        child: Text(
                          Strings.START_APP.toUpperCase(),
                          softWrap: true,
                          style: Styles.onboardTextStyle,
                        )),
                  ),
                ),
        ],
      ),
    );
  }

  _appBar() {
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.defaultSize * 2.5),
      padding: EdgeInsets.all(SizeConfig.defaultSize * 1.2),
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
              width: SizeConfig.defaultSize * 5,
              height: SizeConfig.defaultSize * 5,
              padding: EdgeInsets.symmetric(
                  horizontal: horizontal(size: 12)),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(50),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                color: kPrimaryColor,
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
                fontWeight: FontWeight.bold,
                fontSize: fontSize(size: 16),
                color: darkGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _body(PageController controller) {
    return Expanded(
      child: PageView.builder(
        controller: controller,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              _displayImage(list[index].image),
              _displayText(list[index].text, list[index].title),
            ],
          );
        },
      ),
    );
  }

  _indicator() {
    return Container(
      width: SizeConfig.defaultSize * 9,
      height: SizeConfig.defaultSize * 9,
      margin: EdgeInsets.symmetric(vertical: vertical(size: 13)),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 90,
              height: 90,
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
                width: SizeConfig.defaultSize * 6.5,
                height: SizeConfig.defaultSize * 6.5,
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

  _displayText(String text, String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontal(size: 15)),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
              fontSize: fontSize(size: 25),
            ),
            textAlign: TextAlign.center,
          ),
          VerticalSpacing(of: 5),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: fontSize(size: 19),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _displayImage(String image) {
    return Image.asset(
      image,
      height: MediaQuery.of(context).size.height * .45,
    );
  }
}
