import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/default_btn.dart';
import 'package:danaid/widgets/forms/form_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtpView extends StatefulWidget {
  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  FocusNode pin2FocusNode, pin3FocusNode, pin4FocusNode;
  FocusNode pin5FocusNode, pin6FocusNode;
  final defaultSize = SizeConfig.defaultSize;
  final GlobalKey<FormState> _mFormKey = GlobalKey<FormState>();
  bool _mIsPass = true;

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  height: SizeConfig.screenHeight * .45,
                  decoration: BoxDecoration(color: kPrimaryColor),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: SizeConfig.screenHeight * .3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: kPrimaryColor, width: 2.3),
                                shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage:
                              AssetImage('assets/images/male.png'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: top(size: 5)),
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontal(size: 35)),
                            child: Text(
                              'Vérification du numéro',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: fontSize(size: 22)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: SizeConfig.screenHeight * .8,
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(defaultSize * 2.5),
                                topRight: Radius.circular(defaultSize * 2.5)
                            )
                        ),
                        child: ListView(
                          children: [
                            SizedBox(height: SizeConfig.screenHeight * 0.05),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              alignment: Alignment.center,
                              child: Text(
                                  "Un code de validation a été envoyé par sms au:  +237 695 000 000",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: darkGreyColor,
                                  fontSize: fontSize(size: 17)
                                ),
                              ),
                            ),
                            buildTimer(),
                            otpForm(),
                            DefaultBtn(formKey: _mFormKey, signText: "Validez le code", signRoute: '/home',),
                            SizedBox(height: SizeConfig.screenHeight * .01),
                            GestureDetector(
                              onTap: () => navigateReplaceTo(context: context, routeName: '/register'),
                              child: Text(
                                "Renvoyez le code de validation",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: fontSize(size: 18),
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(height: height(size: 25),)
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  Container buildTimer() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Le code expire dans: ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: fontSize(size: 18))),
          TweenAnimationBuilder(
            tween: Tween(begin: 30.0, end: 0.0),
            duration: Duration(seconds: 30),
            builder: (_, value, child) => Text(
              "00:${value.toInt()}",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize(size: 18)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container otpForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontal(size: 20)),
      child: Form(
        key: _mFormKey,
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * .038),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(60),
                  child: TextFormField(
                    autofocus: true,
                    obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) => nextField(value, pin2FocusNode),
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(60),
                  child: TextFormField(
                    focusNode: pin2FocusNode,
                    obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) => nextField(value, pin3FocusNode),
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(60),
                  child: TextFormField(
                    focusNode: pin3FocusNode,
                    obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) => nextField(value, pin4FocusNode),
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(60),
                  child: TextFormField(
                    focusNode: pin4FocusNode,
                    obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) => nextField(value, pin5FocusNode),
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(60),
                  child: TextFormField(
                    focusNode: pin5FocusNode,
                    obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) => nextField(value, pin6FocusNode),
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(60),
                  child: TextFormField(
                    focusNode: pin6FocusNode,
                    obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      if (value.length == 1) {
                        pin6FocusNode.unfocus();
                        // Then you need to check is the code is correct or not
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.screenHeight * .05),
          ],
        ),
      ),
    );
  }
}
