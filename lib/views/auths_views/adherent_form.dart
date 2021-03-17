import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:danaid/widgets/clippers.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';

class AdherentRegistrationFormm extends StatefulWidget {
  @override
  _AdherentRegistrationFormmState createState() => _AdherentRegistrationFormmState();
}

class _AdherentRegistrationFormmState extends State<AdherentRegistrationFormm> {
  final GlobalKey<FormState> _adherentFormKey = GlobalKey<FormState>();
  TextEditingController _familynameController = new TextEditingController();
  TextEditingController _surnameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _townAreaController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: kPrimaryColor
      ),
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Stack(clipBehavior: Clip.none, children: [
                    ClipPath(
                      clipper: WaveClipperTop(),
                      child: Container(
                        height: wv*35,
                        decoration: BoxDecoration(
                          color: kPrimaryColor
                        ),
                      ),
                    ),
                    Positioned(
                      top: hv*3,
                      child: Stack(children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: wv*15,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: kDeepTeal,
                            radius: wv*4,
                          ),
                        )
                      ],),
                    )
                  ], alignment: AlignmentDirectional.topCenter,)
                ],
              ),
            ),
            Form(
              key: _adherentFormKey,
              child: Column(children: [
                SizedBox(height: hv*4,),

                CustomTextField(
                  label: "Nom de Famille *",
                  hintText: "Entrez votre nom de famille",
                  controller: _familynameController,
                ),
                SizedBox(height: hv*2.5,),
                CustomTextField(
                  label: "Prénom (s)",
                  hintText: "Entrez votre prénom",
                  controller: _familynameController,
                ),
              ],)
            )
          ],
        ),
      ),
    );
  }
}