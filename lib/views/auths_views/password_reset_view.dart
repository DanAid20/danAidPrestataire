import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/default_btn.dart';
import 'package:danaid/widgets/forms/form_widget.dart';
import 'package:danaid/widgets/texts/sign_in_up_tag.dart';
import 'package:danaid/widgets/texts/welcome_text_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class PasswordResetView extends StatefulWidget{
  @override
  _PasswordResetViewState createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<PasswordResetView> {
  final defaultSize = SizeConfig.defaultSize;
  final GlobalKey<FormState> _mFormKey = GlobalKey<FormState>();
  TextEditingController _mPhoneController, _mPasswordController, _mEmailController;
  bool _mIsPass = true;

  @override
  void initState() {
    _mPhoneController = TextEditingController();
    _mPasswordController = TextEditingController();
    _mEmailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
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
                          WelcomeHeader(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontal(size: 35)),
                            child: Text(S.of(context).reinitialisezVotreMotDePasseGrceVotreTlphoneEtAdresse,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: fontSize(size: 16)),
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
                            loginForm(),
                            DefaultBtn(formKey: _mFormKey, signText: S.of(context).reinitialiserMotDePasse, signRoute: '/home',),
                            SIgnInUpTag(title: '', subTitle: S.of(context).annuler, signRoute: '/login',),
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

  Container loginForm() {
    return Container(
      margin: EdgeInsets.only(top: top(size: 20)),
      child: Form(
        key: _mFormKey,
        child: Column(
          children: [
            KTextFormField  (
              controller: _mEmailController,
              labelText: 'Adresse E-mail',
              hintText: 'Entrez votre adresse email',
              prefixIcon:
              Icon(SimpleLineIcons.envelope),
              validator: (String mail) {
                return (mail.isEmpty)
                    ? kEmailNullErrorFr
                    : (!emailValidatorRegExp.hasMatch(mail))
                    ? kInvalidEmailError : null;
              },
            ),
            KTextFormField(
              controller: _mPhoneController,
              labelText: 'Téléphone',
              hintText:
              'Entrez votre numéro de téléphone',
              prefixIcon:
              Icon(SimpleLineIcons.phone),
              validator: (String phone) {
                return (phone.isEmpty)
                    ? kPhoneNumberNullError
                    : null;
              },
            ),
            KTextFormField(
              controller: _mPasswordController,
              isPassword: _mIsPass,
              labelText: 'Nouveau Mot de Passe',
              hintText:
              'Entrez votre nouveau mot de passe',
              prefixIcon:
              Icon(SimpleLineIcons.lock),
              validator: (String pwd) {
                return (pwd.isEmpty)
                    ? kPassNullErrorFr
                    : null;
              },
              suffixIcon: IconButton(
                icon: Icon(_mIsPass
                    ? SimpleLineIcons.eye
                    : Feather.eye_off),
                onPressed: () {
                  setState(() {
                    _mIsPass = !_mIsPass;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}