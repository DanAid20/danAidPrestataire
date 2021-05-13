import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';

class FunctionWidgets {
  static chooseImageProvider({BuildContext context, Function gallery, Function camera}){
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext bc){
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Gallerie'),
                    onTap: () {
                      gallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    camera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  static termsAndConditionsDialog({BuildContext context}){
    String termsAndConditions = "Le médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\n\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la s";
    showDialog(context: context, 
      builder: (BuildContext context){
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
    );
  }
}