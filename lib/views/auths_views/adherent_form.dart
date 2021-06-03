import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/planModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/planModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/danAid_default_header.dart';
import 'package:danaid/widgets/function_widgets.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:danaid/widgets/clippers.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:provider/provider.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/core/services/getCities.dart';

class AdherentRegistrationFormm extends StatefulWidget {
  @override
  _AdherentRegistrationFormmState createState() => _AdherentRegistrationFormmState();
}

class _AdherentRegistrationFormmState extends State<AdherentRegistrationFormm> {
  final GlobalKey<FormState> _adherentFormKey = GlobalKey<FormState>();
  TextEditingController _familynameController = new TextEditingController();
  TextEditingController _surnameController = new TextEditingController();
  TextEditingController _regionController = new TextEditingController();
  TextEditingController _townController = new TextEditingController();
  bool autovalidate = false;
  String _gender = "H";
  String _region = "Centre";
  List<String> myCities = [];
  String _city;
  String _stateCode;
  bool regionChosen = false;
  bool cityChosen = false;
  bool _serviceTermsAccepted = false;
  String termsAndConditions = "Le médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\n\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la santé de votre famille. Son action vous permet de bénéficier de soins de qualité à coût maîtrisé.\nLe médecin de famille sera le premier point de contact de votre famille avec les services de santé.\nLe médecin de famille DanAid assure le suivi à long terme de la s";
  DateTime selectedDate;
  DateTime initialDate = DateTime(1990);
  File imageFileAvatar;
  bool imageLoading = false;
  bool buttonLoading = false;
  String avatarUrl;
  @override
  Widget build(BuildContext context) {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    PlanModelProvider planProvider = Provider.of<PlanModelProvider>(context, listen: false);

    DateTime now = DateTime.now();

    int months = 0;
    String trimester;
    DateTime start;
    DateTime end;
    PlanModel plan = planProvider.getPlan;
    
    if(now.month >= 1 && now.month < 4){
      trimester = "Janvier à Mars " + DateTime.now().year.toString();
      if (now.month != 3){
        months = (now.day < 25) ? 4 - now.month : 4 - now.month - 1;
      }
      else{
        if(now.day < 25){
          months = 1;
          trimester = "Janvier à Mars " + DateTime.now().year.toString();
        }
        else {
          months = 3;
          trimester = "Avril à Juin " + DateTime.now().year.toString();
        }
        trimester = (now.day < 25) ? "Janvier à Mars " + DateTime.now().year.toString() : "Avril à Juin " + DateTime.now().year.toString(); 
        months = (now.day < 25) ? 1 : 3;
      }
      if(now.month == 3 && now.day > 25){
        start = DateTime(now.year, 04, 01);
        end = DateTime(now.year, 07, 01);
      } else {
        start = DateTime(now.year, 01, 01);
        end = DateTime(now.year, 04, 01);
      }
    }

    else if(now.month >= 4 && now.month < 7){
      trimester = "Avril à Juin " + DateTime.now().year.toString();
      if (now.month != 6){months = (now.day < 25) ? 7 - now.month : 7 - now.month - 1;}
      else{
        trimester = (now.day < 25) ? "Avril à Juin " + DateTime.now().year.toString() : "Juillet à Septembre " + DateTime.now().year.toString(); 
        months = (now.day < 25) ? 1 : 3;
      }
      if(now.month == 6 && now.day > 25){
        start = DateTime(now.year, 07, 01);
        end = DateTime(now.year, 10, 01);
      } else {
        start = DateTime(now.year, 04, 01);
        end = DateTime(now.year, 07, 01);
      }
    }

    else if(now.month >= 7 && now.month < 10){
      trimester = "Juillet à Septembre " + DateTime.now().year.toString();
      if (now.month != 9){months = (now.day < 25) ? 10 - now.month : 10 - now.month - 1;}
      else{
        trimester = (now.day < 25) ? "Juillet à Septembre " + DateTime.now().year.toString() : "Octobre à Décembre " + DateTime.now().year.toString(); 
        months = (now.day < 25) ? 1 : 3;}

      if(now.month == 9 && now.day > 25){
        start = DateTime(now.year, 10, 01);
        end = DateTime(now.year, 12, 31);
      } else {
        start = DateTime(now.year, 07, 01);
        end = DateTime(now.year, 10, 01);
      }
    }

    else if(now.month >= 10 && now.month <= 12){
      trimester = "Octobre à Décembre " + DateTime.now().year.toString();
      
      if (now.month != 9){months = (now.day < 25) ? 12 - now.month : 12 - now.month - 1;}
      else{
        trimester = (now.day < 25) ? "Octobre à Décembre " + DateTime.now().year.toString() : "Janvier à Mars " + (DateTime.now().year+1).toString(); 
        months = (now.day < 25) ? 1 : 3;
      }

      if(now.month == 12 && now.day > 25){
        start = DateTime(now.year+1, 01, 01);
        end = DateTime(now.year+1, 04, 01);
      } else {
        start = DateTime(now.year, 10, 01);
        end = DateTime(now.year, 12, 31);
      }
    }

    num total = plan.monthlyAmount*months;
    num registrationFee = plan.registrationFee;

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: hv*2),
              child: Stack(clipBehavior: Clip.none, children: [
                DanAidDefaultHeader(),
                Positioned(
                  top: hv*5,
                  child: Stack(children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: wv*18,
                      child: imageFileAvatar == null ? Icon(LineIcons.user, color: Colors.white, size: wv*25,) : Container(),
                      backgroundImage: imageFileAvatar == null ? null : FileImage(imageFileAvatar),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 5,
                      child: CircleAvatar(
                        backgroundColor: kDeepTeal,
                        radius: wv*5,
                        child: IconButton(icon: Icon(Icons.add, color: whiteColor,), color: kPrimaryColor, onPressed: (){getImage(context);}),
                      ),
                    )
                  ],),
                ),
              ], alignment: AlignmentDirectional.topCenter,),
            ),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Form(
                    key: _adherentFormKey,
                    autovalidateMode: autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    child: Column(children: [
                      SizedBox(height: hv*3,),

                      CustomTextField(
                        label: "Nom de Famille *",
                        hintText: "Entrez votre nom de famille",
                        controller: _familynameController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                      ),
                      SizedBox(height: hv*1.5,),
                      CustomTextField(
                        label: "Prénom (s)",
                        hintText: "Entrez votre prénom",
                        controller: _surnameController,
                        validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                      ),
                      SizedBox(height: hv*1.5,),
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
                                      Text( selectedDate != null ? "${selectedDate.toLocal()}".split(' ')[0] : "Choisir", style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                    ],),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: wv*3,),
                        ],
                      ),
                      SizedBox(height: hv*1.5,),
                      Row(
                        children: [
                          SizedBox(width: wv*3,),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Region", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                                SizedBox(height: 5,),
                                Container(
                                  constraints: BoxConstraints(minWidth: wv*45),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: _stateCode,
                                        hint: Text("Choisir une region"),
                                        items: regions.map((region){
                                          return DropdownMenuItem(
                                            child: SizedBox(child: Text(region["value"], style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)), width: wv*50,),
                                            value: region["key"],
                                          );
                                        }).toList(),
                                        onChanged: (value) async {
                                          //List<String> reg = getTownNamesFromRegion(cities, value);
                                          adherentProvider.setRegionOfOrigin(Algorithms.getRegionFromStateCode(regions, value));
                                          setState(() {
                                            _stateCode = value;
                                            _region = Algorithms.getRegionFromStateCode(regions, value);
                                            _city = null;
                                            cityChosen = false;
                                            //myCities = reg;
                                            regionChosen = true;
                                          });
                                        }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: wv*3,),
                          regionChosen ? Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Choix de la ville", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                                SizedBox(height: 5,),
                                Container(
                                  constraints: BoxConstraints(minWidth: wv*45),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: _city,
                                        hint: Text("Ville"),
                                        items: Algorithms.getTownNamesFromRegion(cities, _stateCode).map((city){
                                          print("city: "+city);
                                          return DropdownMenuItem(
                                            child: Text(city, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                            value: city,
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          adherentProvider.setTown(value);
                                          setState(() {
                                            _city = value;
                                            cityChosen = true;
                                          });
                                        }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ) : Container(),
                          SizedBox(width: wv*3,),
                        ],
                      ),
                      SizedBox(height: hv*1.5,),
                      /*Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: CustomTextField(
                              label: "Region",
                              hintText: "ex: Centre",
                              controller: _regionController,
                              validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                              //svgIcon: "assets/icons/Bulk/Discovery.svg",
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: CustomTextField(
                              label: "Ville",
                              hintText: "ex: Yaoundé",
                              controller: _townController,
                              validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null,
                            ),
                          ),
                        ],
                      ),*/
                    ],)
                  ),
                  /*Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      List<String> myList = getTownNamesFromList(towns);
                      return myList.where((String option) {
                        return option.contains(textEditingValue.text.toLowerCase());
                      }).toList();
                    },
                    onSelected: (String selection) {
                      print('Selected $selection.');
                    },
                  ),*/

                  SizedBox(height: hv*1,),
                  HomePageComponents.termsAndConditionsTile(
                    action: ()=>FunctionWidgets.termsAndConditionsDialog(context: context),
                    value: _serviceTermsAccepted,
                    activeColor: primaryColor,
                    onChanged: (newValue) {
                      setState(() {
                        _serviceTermsAccepted = newValue;
                      });
                    },
                  ),
                  imageLoading ? Loaders().buttonLoader(kPrimaryColor) : Container(),
                  (_serviceTermsAccepted & cityChosen & (selectedDate != null)) ?  
                  !buttonLoading ? CustomTextButton(
                    text: "Envoyer",
                    color: kPrimaryColor,
                    action: () async {
                      Random random = new Random();
                      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                      adherentProvider.setAdherentId(userProvider.getUserId);
                      setState(() {
                        autovalidate = true;
                      });
                      String fname = _familynameController.text;
                      String sname = _surnameController.text;
                      if (_adherentFormKey.currentState.validate()){
                        setState(() {
                          buttonLoading = true;
                        });
                        AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
                        print("$fname, $sname, $selectedDate, $_gender, $avatarUrl");
                        print("${Algorithms().getMatricule(selectedDate, "Centre", _gender)}");
                        adherentProvider.setAdherentId(userProvider.getUserId);
                        adherentProvider.setFamilyName(fname);
                        adherentProvider.setSurname(sname);
                        adherentProvider.setBirthDate(selectedDate);
                        adherentProvider.setImgUrl(avatarUrl);
                        adherentProvider.setHavePaidBefore(false);
                        await FirebaseFirestore.instance.collection("USERS")
                          .doc(userProvider.getUserId)
                          .set({
                            "authId": FirebaseAuth.instance.currentUser.uid,
                            'createdDate': DateTime.now(),
                            'emailAdress': userProvider.getEmail,
                            'enabled': false,
                            "phoneList": FieldValue.arrayUnion([{"number": userProvider.getUserId}]),
                            "urlCNI": "",
                            "profilEnabled": false,
                            "userCountryCodeIso": userProvider.getCountryCode.toLowerCase(),
                            "userCountryName": userProvider.getCountryName,
                            'fullName': "$fname $sname",
                            "imageUrl" : avatarUrl,
                            "points": 500,
                            "visitPoints": 0,
                            "matricule": Algorithms().getMatricule(selectedDate, adherentProvider.getAdherent.regionOfOrigin, _gender),
                            "profil": "ADHERENT",
                            "regionDorigione": adherentProvider.getAdherent.regionOfOrigin,
                            "phoneKeywords": Algorithms.getKeyWords(userProvider.getUserId),
                            "nameKeywords": Algorithms.getKeyWords(fname + " "+ sname)
                          }, SetOptions(merge: true))
                          .then((value) async {
                            await FirebaseFirestore.instance.collection("ADHERENTS")
                              .doc(userProvider.getUserId)
                              .set({
                                "createdDate": DateTime.now(),
                                "havePaidBefore": false,
                                "authPhoneNumber": userProvider.getUserId,
                                "enabled": false,
                                "dateNaissance": selectedDate,
                                "authId": FirebaseAuth.instance.currentUser.uid,
                                "genre": _gender,
                                "imageUrl" : avatarUrl,
                                "matricule": Algorithms().getMatricule(selectedDate, adherentProvider.getAdherent.regionOfOrigin, _gender),
                                "phoneList": FieldValue.arrayUnion([{"number": userProvider.getUserId}]),
                                "nbBeneficiare": 0,
                                "nombreEnfant": 0,
                                "nomFamille": fname,
                                "prenom": sname,
                                "profil": "ADHERENT",
                                "profilEnabled": false,
                                "protectionLevel": adherentProvider.getAdherent.adherentPlan,
                                "regionDorigione": adherentProvider.getAdherent.regionOfOrigin,
                                "statuMatrimonialMarie": false,
                                "ville": adherentProvider.getAdherent.town,
                                "datDebutvalidite" : adherentProvider.getAdherent.adherentPlan == 0 ? DateTime.now() : start,
                                "datFinvalidite": adherentProvider.getAdherent.adherentPlan == 0 ? DateTime.now().add(Duration(days: 365)) : end,
                                "paid": false,
                                "phoneKeywords": Algorithms.getKeyWords(userProvider.getUserId),
                                "nameKeywords": Algorithms.getKeyWords(fname + " "+ sname)
                              }, SetOptions(merge: true))
                              .then((value) async {
                                adherentProvider.setValidityEndDate(end);
                                adherentProvider.setDateCreated(DateTime.now());

                                plan.planNumber != 0 ? await FirebaseFirestore.instance.collection("ADHERENTS").doc(userProvider.getUserId).collection('NEW_FACTURATIONS_ADHERENT').doc(DateTime.now().microsecondsSinceEpoch.toString()).set({
                                  "montant": total,
                                  "createdDate": DateTime.now(),
                                  "trimester": trimester,
                                  "intitule": "COSTISATION Q-"+start.year.toString(),
                                  "dateDebutCouvertureAdherent" : start,
                                  "dateFinCouvertureAdherent": end,
                                  "categoriePaiement" : "COTISATION_TRIMESTRIELLE",
                                  "dateDelai": start.add(Duration(days: 15)),
                                  "numeroRecu": start.year.toString()+"-"+random.nextInt(99999).toString(),
                                  "numeroNiveau": plan.planNumber,
                                  "paymentDate": null,
                                  "paid": false

                                }).then((doc) {

                                  adherentProvider.getAdherent.havePaid != true ? FirebaseFirestore.instance.collection("ADHERENTS").doc(userProvider.getUserId).collection('NEW_FACTURATIONS_ADHERENT').doc((DateTime.now().microsecondsSinceEpoch+1).toString()).set({
                                    "montant": registrationFee,
                                    "createdDate": DateTime.now(),
                                    "trimester": trimester,
                                    "categoriePaiement": "INSCRIPTION",
                                    "intitule": "COSTISATION Q-"+start.year.toString(),
                                    "dateDelai": start.add(Duration(days: 15)),
                                    "numeroNiveau": plan.planNumber,
                                    "paymentDate": null,
                                    "numeroRecu": start.year.toString()+"-"+random.nextInt(99999).toString(),
                                    "paid": false
                                  }) : print("Il a payé");

                                  adherentProvider.setAdherentPlan(plan.planNumber);
                                  adherentProvider.setValidityEndDate(end);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Factures enrégistrées",)));
                                }).catchError((e){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur",)));
                                }) 
                                : print("pas besoin");

                                await HiveDatabase.setRegisterState(true);
                                HiveDatabase.setAuthPhone(userProvider.getUserId);
                                HiveDatabase.setFamilyName(fname);
                                HiveDatabase.setSurname(sname);
                                HiveDatabase.setGender(_gender);
                                HiveDatabase.setImgUrl(avatarUrl);

                                setState(() {
                                  buttonLoading = false;
                                });

                                Navigator.pushNamed(context, '/home');
                              })
                              .catchError((e) {
                                print(e.toString());
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                setState(() {
                                  buttonLoading = false;
                                });
                              })
                              ;
                          })
                          .catchError((e){
                            print(e.toString());
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                            setState(() {
                              buttonLoading = false;
                            });
                          })
                          ;
                        
                      }
/*
                      await FirebaseFirestore.instance.collection("USERS")
                        .doc(userProvider.getUserId)
                        .set({
                          //'createdDate': DateTime.now(),
                          //'emailAdress': userProvider.getEmail,
                          //'enabled': userProvider.isEnabled,
                          'fullName': sname + ' ' + fname,
                          "imageUrl" : null,
                          "matricule": Algorithms().getMatricule(selectedDate, "Centre", _gender),
                          //"phoneList": FieldValue.arrayUnion([{"number": userProvider.getUserId}]),
                          "profil": "ADHERENT",
                          "regionDorigione": "",
                          //"urlCNI": "",
                          //"userCountryCodeIso": userProvider.getCountryCode.toLowerCase(),
                          //"userCountryName": userProvider.getCountryName
                        }, SetOptions(merge: true))
                        .then((value) => Navigator.pushNamed(context, '/home'));
*/

                    },
                  ) : Loaders().buttonLoader(kPrimaryColor) :
                  CustomDisabledTextButton(
                    text: "Envoyer",
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate, // Refer step 1
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

  Future uploadImageToFirebase(PickedFile file) async {

    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucune image selectionnée'),));
      return null;
    }
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      imageLoading = true;
    });
    String fileName = userProvider.getUserId;

    Reference storageReference = FirebaseStorage.instance.ref().child('photos/profils_adherents/$fileName'); //.child('photos/profils_adherents/$fileName');
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path}
    );

    UploadTask storageUploadTask;
    if (kIsWeb) {
      storageUploadTask = storageReference.putData(await file.readAsBytes(), metadata);
    } else {
      storageUploadTask = storageReference.putFile(File(file.path), metadata);
    }
    
    storageUploadTask = storageReference.putFile(imageFileAvatar);

    storageUploadTask.catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
    });
    storageUploadTask.whenComplete(() async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Photo de profil ajoutée")));
      String url = await storageReference.getDownloadURL();
      avatarUrl = url;
      print("download url: $url");
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("download url: $url")));
    });
    setState(() {
      imageLoading = false;
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        imageFileAvatar = File(pickedFile.path);
        //imageLoading = true;
      } else {
        print('No image selected.');
      }
    });
    uploadImageToFirebase(pickedFile);
  }

  Future getImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        imageFileAvatar = File(pickedFile.path);
        //imageLoading = true;
      } else {
        print('No image selected.');
      }
    });
    uploadImageToFirebase(pickedFile);
  }

  getImage(BuildContext context){
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
                      getImageFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    getImageFromCamera();
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


}