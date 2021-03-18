import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:danaid/widgets/clippers.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  bool autovalidate = false;
  String _gender = "H";
  bool _serviceTermsAccepted = false;
  String termsAndConditions = "Le médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\n\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la s";
  DateTime selectedDate = DateTime(1990);
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
                        height: wv*42,
                        decoration: BoxDecoration(
                          color: kPrimaryColor
                        ),
                      ),
                    ),
                    Positioned(
                      top: hv*5,
                      child: Stack(children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: wv*18,
                        ),
                        Positioned(
                          bottom: 2,
                          right: 5,
                          child: CircleAvatar(
                            backgroundColor: kDeepTeal,
                            radius: wv*4,
                          ),
                        )
                      ],),
                    ),
                    Positioned(
                      top: hv*2,
                      left: wv*3,
                      child: GestureDetector(
                        onTap: (){Navigator.pop(context);},
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: wv*3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(Icons.arrow_back_ios_rounded, color: kPrimaryColor,),
                        ),
                      ),
                    )
                  ], alignment: AlignmentDirectional.topCenter,)
                ],
              ),
            ),
            Form(
              key: _adherentFormKey,
              autovalidateMode: autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
              child: Column(children: [
                SizedBox(height: hv*6,),

                CustomTextField(
                  label: "Nom de Famille *",
                  hintText: "Entrez votre nom de famille",
                  controller: _familynameController,
                  validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                ),
                SizedBox(height: hv*2.5,),
                CustomTextField(
                  label: "Prénom (s)",
                  hintText: "Entrez votre prénom",
                  controller: _surnameController,
                  validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                ),
                SizedBox(height: hv*2.5,),
                Row(
                  children: [
                    SizedBox(width: wv*3,),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Genre *", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                          SizedBox(height: 5,),
                          Container(
                            constraints: BoxConstraints(minWidth: wv*45),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: _gender,
                                items: [
                                  DropdownMenuItem(
                                    child: Text("Masculin", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                    value: "H",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Féminin", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                    value: "F",
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                }),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: wv*5,),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date de naissance *", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                          SizedBox(height: 5,),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: Row(children: [
                                SvgPicture.asset("assets/icons/Bulk/CalendarLine.svg", color: kDeepTeal,),
                                VerticalDivider(),
                                Text( "${selectedDate.toLocal()}".split(' ')[0], style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.bold),),
                              ],),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: wv*3,),
                  ],
                ),
                SizedBox(height: hv*2.5,),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: CustomTextField(
                        label: "Adresse",
                        hintText: "ex: Carrefour Mboppi",
                        controller: _addressController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                        svgIcon: "assets/icons/Bulk/Discovery.svg",
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: CustomTextField(
                        label: "Commune",
                        hintText: "ex: Douala 5",
                        controller: _townAreaController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                      ),
                    ),
                  ],
                ),
              ],)
            ),
            SizedBox(height: hv*1,),
            CheckboxListTile(
              tristate: false,
              title: Row(children: [
                Text("Lu et accepté les "),
                InkWell(child: Text("termes des services", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600, decoration: TextDecoration.underline,)), 
                  onTap: (){
                    showDialog(context: context, 
                    builder: (BuildContext context){
                      return termsAndConditionsDialog();
                    }
                    );
                  },)
              ],),
              value: _serviceTermsAccepted,
              activeColor: primaryColor,
              onChanged: (newValue) {
                setState(() {
                  _serviceTermsAccepted = newValue;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            _serviceTermsAccepted ?  
            CustomTextButton(
              text: "Envoyer",
              color: kPrimaryColor,
              action: (){
                setState(() {
                  autovalidate = true;
                });
                String fname = _familynameController.text;
                String sname = _surnameController.text;
                String address = _addressController.text;
                String commune = _townAreaController.text;
                if (_adherentFormKey.currentState.validate()){
                  print("$fname, $sname, $address, $commune, $selectedDate, $_gender");
                }
              },
            ) :
            CustomDisabledTextButton(
              text: "Envoyer",
            )
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget termsAndConditionsDialog(){
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*1),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: hv*2,),
                  Text("Termes de services", style: TextStyle(fontSize: wv*6, fontWeight: FontWeight.w900, color: kPrimaryColor),),
                  SizedBox(height: hv*2,),
                  Expanded(child: SingleChildScrollView(child: Text(termsAndConditions), physics: BouncingScrollPhysics(),)),
                ],
              ),
            ),
            CustomTextButton(
              text: "Fermer",
              color: kPrimaryColor,
              action: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }

}