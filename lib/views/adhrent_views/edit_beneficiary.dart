import 'dart:io';

import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/danAid_default_header.dart';
import 'package:danaid/widgets/file_upload_card.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:danaid/widgets/function_widgets.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:simple_tags/simple_tags.dart';

class EditBeneficiary extends StatefulWidget {
  @override
  _EditBeneficiaryState createState() => _EditBeneficiaryState();
}

class _EditBeneficiaryState extends State<EditBeneficiary> {

  final GlobalKey<FormState> _editBeneficiaryFormKey = GlobalKey<FormState>();
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey = new GlobalKey();
  TextEditingController _familynameController = new TextEditingController();
  TextEditingController _surnameController = new TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _allergyController = TextEditingController();

  String? matricule;
  String? _relation;
  List<String> allergies = [];
  String currentAllergyText = "";
  String? phone;
  String initialCountry = 'CM';
  PhoneNumber number = PhoneNumber(isoCode: 'CM');

  
  File? imageFileAvatar;
  bool imageLoading = false;
  bool buttonLoading = false;
  String? avatarUrl;
  
  PageController controller = PageController(initialPage: 0, keepPage: false);
  int currentPageValue = 0;
  List<Widget>? introWidgetsList;

  String? _gender;
  String? _bloodGroup;
  bool male = false;
  bool female = false;

  bool _confirmFamily = true;
  bool marriageCertificateUploaded = false;
  bool birthCertificateUploaded = false;
  bool cniUploaded = false;
  bool otherFileUploaded = false;
  bool marriageCertificateSpinner = false;
  bool birthCertificateSpinner = false;
  bool cniSpinner = false;
  bool otherFileSpinner = false;
  bool imageSpinner = false;
  bool surnameEnabled = true;
  bool nameEnabled = true;
  bool heightEnabled = true;
  bool weightEnabled = true;
  bool phoneEnabled = false;

  List<String> suggestions = [
    "Lactose",
    "Pénicilline",
    "Pollen",
    "Abeille",
    "Feu",
    "Herbes",
    "Plastique"
  ];

  initTextfields(){

    BeneficiaryModelProvider beneficiaryModel = Provider.of<BeneficiaryModelProvider>(context, listen: false);
    if (beneficiaryModel.getBeneficiary.familyName != null){
      setState(() {
        _familynameController.text = beneficiaryModel.getBeneficiary.familyName!;
        nameEnabled = false;
      });
    }
    if (beneficiaryModel.getBeneficiary.surname != null){
      setState(() {
        _surnameController.text = beneficiaryModel.getBeneficiary.surname!;
        surnameEnabled = false;
      });
    }
    if (beneficiaryModel.getBeneficiary.height != null){
      setState(() {
        _heightController.text = beneficiaryModel.getBeneficiary.height.toString();
        heightEnabled = false;
      });
    }
    if (beneficiaryModel.getBeneficiary.weight != null){
      setState(() {
        _weightController.text = beneficiaryModel.getBeneficiary.weight.toString();
        weightEnabled = false;
      });
    }
    if (beneficiaryModel.getBeneficiary.phoneList?[0] != null){
      setState(() {
        phone = beneficiaryModel.getBeneficiary.phoneList?[0]["number"];
      });
    }
    if (beneficiaryModel.getBeneficiary.relationShip != null){
      setState(() {
        _relation = beneficiaryModel.getBeneficiary.relationShip;
      });
    }
    if (beneficiaryModel.getBeneficiary.bloodGroup != null){
      setState(() {
        _bloodGroup = beneficiaryModel.getBeneficiary.bloodGroup;
      });
    }
    if ((beneficiaryModel.getBeneficiary.cniUrl != null) & (beneficiaryModel.getBeneficiary.cniUrl != "")){
      setState(() {
        cniUploaded = true;
      });
    }
    if ((beneficiaryModel.getBeneficiary.birthCertificateUrl != null) & (beneficiaryModel.getBeneficiary.birthCertificateUrl != "")){
      setState(() {
        birthCertificateUploaded = true;
      });
    }
    if ((beneficiaryModel.getBeneficiary.marriageCertificateUrl != null) & (beneficiaryModel.getBeneficiary.marriageCertificateUrl != "")){
      setState(() {
        marriageCertificateUploaded = true;
      });
    }
    if ((beneficiaryModel.getBeneficiary.otherDocUrl != null) & (beneficiaryModel.getBeneficiary.otherDocUrl != "")){
      setState(() {
        otherFileUploaded = true;
      });
    }
    if (beneficiaryModel.getBeneficiary.allergies != null){
      setState(() {
        for (int i = 0; i < beneficiaryModel.getBeneficiary.allergies!.length; i++){
          allergies.add(beneficiaryModel.getBeneficiary.allergies?[i]);
        }
      });
    }
  }
  
  @override
  void initState() {
    initTextfields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    BeneficiaryModelProvider beneficiary = Provider.of<BeneficiaryModelProvider>(context, listen: false);
    
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Column(children: [
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
                    child: ClipOval(
                      child: CachedNetworkImage(
                        height: wv*36,
                        width: wv*36,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          child: imageFileAvatar == null ? Center(child: Icon(LineIcons.user, color: Colors.white, size: wv*25,)) : Container(), //CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),
                          padding: EdgeInsets.all(20.0),
                        ),
                        imageUrl: beneficiary.getBeneficiary.avatarUrl!,),
                    ),
                      //backgroundImage: CachedNetworkImageProvider(adherentModelProvider.getAdherent.imgUrl),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 5,
                    child: CircleAvatar(
                      backgroundColor: kDeepTeal,
                      radius: wv*5,
                      child: IconButton(
                        icon: Icon(Icons.add, color: whiteColor,), 
                        color: kPrimaryColor, 
                        onPressed: (){FunctionWidgets.chooseImageProvider(context: context, gallery: getImageFromGallery, camera: getImageFromCamera);}
                      ),
                    ),
                  ),
                  
                  imageSpinner ? Positioned(
                    top: hv*7,
                    right: wv*13,
                    child: CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(whiteColor),)
                  ) : Container(),
                ],),
              ),
            ], alignment: AlignmentDirectional.topCenter,),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _editBeneficiaryFormKey,
                child: Column(children: [

                  SizedBox(height: hv*2,),
                  
                  CustomTextField(
                    prefixIcon: Icon(LineIcons.userFriends, color: kPrimaryColor),
                    label: "Nom de Famille *",
                    hintText: "Entrez votre nom de famille",
                    controller: _familynameController,
                    validator: (String? val) => (val!.isEmpty) ? "Ce champ est obligatoire" : null,
                    enabled: nameEnabled,
                    editAction: (){
                      setState(() {
                        nameEnabled = true;
                      });}
                  ),

                  SizedBox(height: hv*2,),

                  CustomTextField(
                    prefixIcon: Icon(LineIcons.user, color: kPrimaryColor),
                    label: "Prénom *",
                    hintText: "Entrez votre prénom",
                    controller: _surnameController,
                    validator: (String? val) => (val!.isEmpty) ? "Ce champ est obligatoire" : null,
                    enabled: surnameEnabled,
                    editAction: (){
                      setState(() {
                        surnameEnabled = true;
                      });}
                  ),

                  SizedBox(height: hv*2,),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: wv*3),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Relation avec l'adhérent *", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                        SizedBox(height: 5,),
                        Container(
                          constraints: BoxConstraints(minWidth: wv*45),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text("Choisir.."),
                                value: _relation,
                                items: [
                                  DropdownMenuItem(
                                    child: Text("Enfant", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                    value: "CHILD",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Conjoint(e)", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                    value: "SPOUSE",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Frère/Soeur", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                    value: "SIBLING",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Parent", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                    value: "PARENT",
                                  ),
                                ],
                                onChanged: (String? value) {
                                  setState(() {
                                    _relation = value;
                                  });
                                }),
                            ),
                          ),
                        ),
                        SizedBox(height: hv*2,),
                        Text("Groupe sanguin", style: TextStyle(fontSize: 17),),
                        SizedBox(height: hv*1,),
                        Container(
                          constraints: BoxConstraints(minWidth: wv*45),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: ButtonTheme(alignedDropdown: true,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(isExpanded: true, hint: Text("Choisir.."), value: _bloodGroup,
                                items: [
                                  DropdownMenuItem(child: Text("A+", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)), value: "A+",),
                                  DropdownMenuItem(child: Text("B+", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),), value: "B+",),
                                  DropdownMenuItem(child: Text("A-", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),), value: "A-",),
                                  DropdownMenuItem(child: Text("B-", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),), value: "B-",),
                                  DropdownMenuItem(child: Text("O-", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)), value: "O-",),
                                  DropdownMenuItem(child: Text("O+", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),), value: "O+",),
                                  DropdownMenuItem(child: Text("AB-", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),), value: "AB-",),
                                  DropdownMenuItem(child: Text("AB+", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),), value: "AB+",),
                                ],
                                onChanged: (String? value) => setState(() {_bloodGroup = value;})
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: hv*3),

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                          Column(children: [
                            Text("Taille", style: TextStyle(fontSize: 17)), SizedBox(height: hv*0.5,),
                            Row(children: [
                              Container(child: SvgPicture.asset('assets/icons/Bulk/row-height.svg', color: kDeepTeal, width: wv*8,)),
                              SizedBox(width: wv*2,),
                              Container(
                                width: wv*30,
                                child: TextFormField(
                                  controller: _heightController,
                                  onChanged: (val) => setState((){}),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                                  ],
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),
                                  decoration: defaultInputDecoration(suffix: "cm")
                                ),
                              ),
                            ]),
                          ],),

                          Column(children: [
                            Text(S.of(context)!.poids, style: TextStyle(fontSize: 17),), SizedBox(height: hv*0.5,),
                            Row(children: [
                              Container(child: SvgPicture.asset('assets/icons/Bulk/weight.svg', color: kDeepTeal, width: wv*8,)),
                              SizedBox(width: wv*2,),
                              Container(
                                width: wv*30,
                                child: TextFormField(
                                  controller: _weightController,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                                  ],
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),
                                  decoration: defaultInputDecoration(suffix: "Kg")
                                ),
                              ),
                            ]),
                          ],),
                        ],),
                        SizedBox(height: hv*2,),
                      ],
                    ),
                  ),
              
                  SizedBox(height: hv*2,),

                  !phoneEnabled ? Container(
                    margin: EdgeInsets.symmetric(horizontal: wv*3),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 2.0, spreadRadius: 1.0)]
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: wv*3),
                      title: Text(S.of(context)!.numroMobile, style: TextStyle(fontSize: wv*4, color: Colors.grey[600]),),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(phone == null ? S.of(context)!.aucunFourni : phone!, style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.bold),),
                      ),
                      trailing: IconButton(
                        enableFeedback: false,
                        icon: CircleAvatar(
                          radius: wv * 3.5,
                          backgroundColor: kDeepTeal,
                          child: Icon(
                            Icons.edit,
                            color: whiteColor,
                            size: wv * 4,
                          ),
                        ),
                        onPressed: ()=>setState((){phoneEnabled = true;}),
                      ),
                    ),
                  ):
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: wv*3),
                    child: Column(children: [
                      Text(S.of(context)!.numroMobile, style: TextStyle(fontSize: wv*4),),
                      SizedBox(height: hv*1,),
                      InternationalPhoneNumberInput(
                        validator: (String? phone) {
                          return (phone!.isEmpty)
                              ?  S.of(context)!.entrerUnNumeroDeTlphoneValide : null;
                        },
                        onInputChanged: (PhoneNumber nber) {
                          number = nber;
                          phone = number.phoneNumber;
                          print(number.phoneNumber);
                        },
                        onInputValidated: (bool value) {
                          print(value);
                        },
                        spaceBetweenSelectorAndTextField: 0,
                        selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET,),
                        ignoreBlank: false,
                        textStyle: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(color: Colors.black),
                        initialValue: number,
                        textFieldController: _phoneController,
                        formatInput: true,
                        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                        inputDecoration: defaultInputDecoration(),
                        onSaved: (PhoneNumber number) {
                          print('On Saved: $number');
                        }, 
                      )
                    ],crossAxisAlignment: CrossAxisAlignment.start,),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*3),
                    child: Column(
                      children: [
                        Row(children: [
                          Text(S.of(context)!.allergies, style: TextStyle(fontSize: 18, color: kTextBlue),), SizedBox(width: wv*3,),
                          Expanded(
                            child: Stack(
                              children: [
                                SimpleAutoCompleteTextField(
                                  key: autoCompleteKey,
                                  suggestions: suggestions,
                                  controller: _allergyController,
                                  decoration: defaultInputDecoration(),
                                  textChanged: (text) => currentAllergyText = text,
                                  clearOnSubmit: false,
                                  submitOnSuggestionTap: false,
                                  textSubmitted: (text) {
                                    if (text != "") {
                                      !allergies.contains(_allergyController.text) ? allergies.add(_allergyController.text) : print("yo"); 
                                    }
                                  }
                                ),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    onPressed: (){
                                      if (_allergyController.text.isNotEmpty) {
                                      setState(() {
                                        !allergies.contains(_allergyController.text) ? allergies.add(_allergyController.text) : print("yo");
                                        _allergyController.clear();
                                      });
                                    }
                                    },
                                    icon: CircleAvatar(child: Icon(Icons.add, color: whiteColor), backgroundColor: kDeepTeal,),),
                                )
                              ],
                            ),
                          )
                        ],),

                        SizedBox(height: hv*2),

                        SimpleTags(
                          content: allergies,
                          wrapSpacing: 4,
                          wrapRunSpacing: 4,
                          onTagPress: (tag) {
                            setState(() {
                              allergies.remove(tag);
                            });
                          },
                          tagContainerPadding: EdgeInsets.all(6),
                          tagTextStyle: TextStyle(color: kPrimaryColor),
                          tagIcon: Icon(Icons.clear, size: 15, color: kPrimaryColor,),
                          tagContainerDecoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        SizedBox(height: hv*5,),
                        Text(S.of(context)!.tlchargerLesPicesJustificatives, style: TextStyle(color: kBlueDeep, fontSize: 18, fontWeight: FontWeight.bold),),
                        SizedBox(height: hv*1,),
                        Text(S.of(context)!.scannerLesDocumentsJustificatifsCniActesDeNaissancesEtc, style: TextStyle(color: kBlueDeep, fontSize: 12, fontWeight: FontWeight.w400)),
                        Center(
                          child: InkWell(
                            onTap: (){getDocument(context);},
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: hv*2),
                              child: SvgPicture.asset('assets/icons/Bulk/Scan.svg', width: wv*20,),
                            ),
                          ),
                        ),
                        FileUploadCard(
                          title: S.of(context)!.scanDeLaCni,
                          state: cniUploaded,
                          loading: cniSpinner,
                          action: () async {await getDocFromPhone('CNI');}
                        ),
                        SizedBox(height: hv*1,),
                        FileUploadCard(
                          title: S.of(context)!.acteDeNaissance,
                          state: birthCertificateUploaded,
                          loading: birthCertificateSpinner,
                          action: () async {await getDocFromPhone('Acte_De_Naissance');}
                        ),
                        SizedBox(height: hv*1,),
                        FileUploadCard(
                          title: S.of(context)!.acteDeMarriage,
                          state: marriageCertificateUploaded,
                          loading: marriageCertificateSpinner,
                          action: () async {await getDocFromPhone('Acte_De_Marriage');}
                        ),
                        SizedBox(height: hv*1,),
                        FileUploadCard(
                          title: S.of(context)!.autrePiceJustificative,
                          state: otherFileUploaded,
                          loading: otherFileSpinner,
                          action: () async {await getDocFromPhone('Pièce_Justificative_Supplémentaire');}
                        ),
                        SizedBox(height: hv*4,),

                        Text(S.of(context)!.dclaration, style: TextStyle(color: kDeepTeal, fontSize: 18, fontWeight: FontWeight.bold),),
                        SizedBox(height: hv*0.5,),
                        Text(S.of(context)!.pourLesBnficiairesSansFiliationDirecte, style: TextStyle(color: kDeepTeal, fontSize: 16, fontWeight: FontWeight.w400)),
                        SizedBox(height: hv*2,),
                        CheckboxListTile(
                          value: _confirmFamily,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: kDeepTeal,
                          tristate: false,
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          onChanged: (val)=> setState((){_confirmFamily = val!;}),
                          title: Text(S.of(context)!.jeConfirmeParLaPrsenteQueLaPersonneSusciteEst, style: TextStyle(color: kTextBlue, fontSize: 16, fontWeight: FontWeight.w400)),
                        ),
                        SizedBox(height: hv*3,),
                      ],
                    ),
                  ),
                 
                ],),
              ),
            )
          ),
          Container(
            child: ((_confirmFamily == true))
            ? !buttonLoading ? CustomTextButton(
              text: S.of(context)!.sauvegarder, 
              action: (){
                if(_editBeneficiaryFormKey.currentState!.validate()){
                    setState(() {
                    buttonLoading = true;
                  });
                  AdherentModelProvider adherentModel = Provider.of<AdherentModelProvider>(context, listen: false);
                  BeneficiaryModelProvider beneficiary = Provider.of<BeneficiaryModelProvider>(context, listen: false);
                  FirebaseFirestore.instance.collection("ADHERENTS")
                    .doc(adherentModel.getAdherent!.getAdherentId)
                    .collection("BENEFICIAIRES").doc(beneficiary.getBeneficiary.matricule)
                    .set({
                      "adherentId": adherentModel.getAdherent!.getAdherentId,
                      "nomDFamille" : _familynameController.text,
                      "prenom": _surnameController.text,
                      "cniName": "${_familynameController.text} ${_surnameController.text}",
                      "bloodGroup": _bloodGroup,
                      "autrePieceName": "${_familynameController.text} ${_surnameController.text}",
                      "acteMariageName": "${_familynameController.text} ${_surnameController.text}",
                      "urlImage": avatarUrl,
                      "urlActeMariage": beneficiary.getBeneficiary.marriageCertificateUrl,
                      "urlAutrPiece": beneficiary.getBeneficiary.otherDocUrl,
                      "urlCNI": beneficiary.getBeneficiary.cniUrl,
                      "urlActeNaissance": beneficiary.getBeneficiary.birthCertificateUrl,
                      "datFinvalidite": adherentModel.getAdherent!.validityEndDate,
                      "enabled": false,
                      "ifVivreMemeDemeure": _confirmFamily,
                      "phoneList": [{"number": phone}],
                      "height": _heightController.text,
                      "weight": _weightController.text,
                      "allergies": allergies,
                      "relation": _relation,
                    }, SetOptions(merge: true)).then((value) async {
                      if(phone != null) {
                        await FirebaseFirestore.instance.collection("USERS").doc(phone).set({
                          "authId": null,
                          "adherentId": adherentModel.getAdherent!.getAdherentId,
                          'createdDate': beneficiary.getBeneficiary.dateCreated,
                          //'emailAdress': null,
                          'enabled': false,
                          "phoneList": FieldValue.arrayUnion([{"number": phone}]),
                          "urlCNI": beneficiary.getBeneficiary.cniUrl,
                          "profilEnabled": false,
                          "userCountryCodeIso": number.isoCode,
                          //"userCountryName": "Cameroon",
                          'fullName': "${_familynameController.text} ${_surnameController.text}",
                          "imageUrl" : avatarUrl,
                          "matricule": beneficiary.getBeneficiary.matricule,
                          "profil": "BENEFICIAIRE",
                          "regionDorigione": adherentModel.getAdherent!.regionOfOrigin,
                          "phoneKeywords": Algorithms.getKeyWords(phone!),
                          "nameKeywords": Algorithms.getKeyWords(_familynameController.text + " "+ _surnameController.text)
                        }, SetOptions(merge: true));
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Informations du bénéficiaire ${_surnameController.text} mises à jour..'),));
                      setState(() {
                        buttonLoading = false;
                      });
                      Navigator.pop(context);
                    });
                }
              },
            ) : Center(child: Loaders().buttonLoader(kPrimaryColor))
            : CustomDisabledTextButton(text: S.of(context)!.sauvegarder,),
          ) 
        ],
        ),
      ),
    );
  }

    Future uploadImageToFirebase(PickedFile file) async {

    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(S.of(context)!.aucuneImageSelectionne),));
      return null;
    }
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    BeneficiaryModelProvider beneficiary = Provider.of<BeneficiaryModelProvider>(context, listen: false);
    setState(() {
      imageLoading = true;
    });
    String? folder = userProvider.getUserId;
    String date = DateTime.now().toString();

    Reference storageReference = FirebaseStorage.instance.ref().child('photos/profils_beneficiaires/$folder/Beneficiaire-$date'); //.child('photos/profils_adherents/$fileName');
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
    
    storageUploadTask = storageReference.putFile(imageFileAvatar!);

    storageUploadTask.catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
    });
    storageUploadTask.whenComplete(() async {
      String url = await storageReference.getDownloadURL();
      beneficiary.setAvatarUrl(url);
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
    uploadImageToFirebase(pickedFile!);
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
    uploadImageToFirebase(pickedFile!);
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
                    title: new Text(S.of(context)!.gallerie),
                    onTap: () {
                      getImageFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(S.of(context)!.camera),
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

  Future getDocFromPhone(String name) async {

    setState(() {
      if (name == "Acte_De_Marriage") {
        marriageCertificateSpinner = true;
      } else if (name == "CNI"){
        cniSpinner = true;
      } else if (name == "Acte_De_Naissance"){
        birthCertificateSpinner = true;
      } else {
        otherFileSpinner = true;
      }
    });
    
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 85);
    setState(() {
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        uploadDocumentToFirebase(file, name);
      } else {
        print('No image selected.');
        setState(() {
          if (name == "Acte_De_Marriage") {
          marriageCertificateSpinner = false;
          } else if (name == "CNI"){
            cniSpinner = false;
          } else if (name == "Acte_De_Naissance"){
            birthCertificateSpinner = false;
          } else {
            otherFileSpinner = false;
          }
        });
      }
    });
  }

  Future uploadDocumentToFirebase(File file, String name) async {
    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    BeneficiaryModelProvider beneficiary = Provider.of<BeneficiaryModelProvider>(context, listen: false);
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(S.of(context)!.aucuneImageSelectionne),));
      return null;
    }
    
    String? adherentId = adherentModelProvider.getAdherent!.adherentId;
    Reference storageReference = FirebaseStorage.instance.ref().child('pieces_didentite/piece_beneficiaires/$adherentId/$matricule/$name'); //.child('photos/profils_adherents/$fileName');
    final metadata = SettableMetadata(
      //contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path}
    );

    UploadTask storageUploadTask;
    if (kIsWeb) {
      storageUploadTask = storageReference.putData(await file.readAsBytes(), metadata);
    } else {
      storageUploadTask = storageReference.putFile(File(file.path), metadata);
    }
    
    //storageUploadTask = storageReference.putFile(imageFileAvatar);

    storageUploadTask.catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
    });
    storageUploadTask.whenComplete(() async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name"+S.of(context)!.ajoute)));
      String url = await storageReference.getDownloadURL();
      if(name == "Acte_De_Marriage"){
        beneficiary.setMarriageCertificateUrl(url);
        setState(() {
            marriageCertificateUploaded = true;
            marriageCertificateSpinner = false;
          });
      }
      else if(name == "Acte_De_Naissance"){
        beneficiary.setBirthCertificateUrl(url);
        setState(() {
          birthCertificateUploaded = true;
          birthCertificateSpinner = false;
        });
      }
      else if (name == "CNI"){
        beneficiary.setcniUrl(url);
        setState(() {
          cniUploaded = true;
          cniSpinner = false;
        });
      }
      else {
        beneficiary.setOtherDocUrl(url);
        setState(() {
          otherFileUploaded = true;
          otherFileSpinner = false;
        });
      }
      
      print("download url: $url");
    }).catchError((e){
      print(e.toString());
    });
  }

  Future getDocFromGallery(String name) async {

    setState(() {
      if (name == "Acte_De_Marriage") {
        marriageCertificateSpinner = true;
      } else if (name == "CNI"){
        cniSpinner = true;
      } else if (name == "Acte_De_Naissance"){
        birthCertificateSpinner = true;
      } else {
        otherFileSpinner = true;
      }
    });
    
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc'],);
    if(result != null) {
      File file = File(result.files.single.path!);
      uploadDocumentToFirebase(file, name);
    } else {
      setState(() {
        if (name == "Acte_De_Marriage") {
        marriageCertificateSpinner = false;
        } else if (name == "CNI"){
          cniSpinner = false;
        } else if (name == "Acte_De_Naissance"){
          birthCertificateSpinner = false;
        } else {
          otherFileSpinner = false;
        }
      });
    }
  }

  getDocument(BuildContext context){
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext bc){
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(LineIcons.identificationCard),
                    title: new Text(S.of(context)!.cniOuPasseport, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600),),
                    onTap: () {
                      getDocFromPhone("CNI");
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(MdiIcons.babyFaceOutline),
                  title: new Text(S.of(context)!.acteDeNaissance, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                  onTap: () {
                    getDocFromPhone("Acte_De_Naissance");
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(LineIcons.ring),
                  title: new Text(S.of(context)!.acteDeMarriage, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                  onTap: () {
                    getDocFromPhone("Acte_De_Marriage");
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(LineIcons.certificate),
                  title: new Text(S.of(context)!.autrePiceJustificative, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                  onTap: () {
                    getDocFromPhone("Pièce_Justificative_Supplémentaire");
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