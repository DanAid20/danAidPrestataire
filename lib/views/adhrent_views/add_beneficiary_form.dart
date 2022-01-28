import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/adhrent_views/health_book_screen.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/drawer.dart';
import 'package:danaid/widgets/file_upload_card.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
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
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:simple_tags/simple_tags.dart';

class AddBeneficiaryForm extends StatefulWidget {
  @override
  _AddBeneficiaryFormState createState() => _AddBeneficiaryFormState();
}

class _AddBeneficiaryFormState extends State<AddBeneficiaryForm> {
  final GlobalKey<FormState> _form1Key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey = new GlobalKey();
  TextEditingController _familynameController = new TextEditingController();
  TextEditingController _surnameController = new TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _allergyController = TextEditingController();

  String? matricule;
  String? _relation;
  DateTime? selectedDate;
  DateTime? initialDate;
  List<String> allergies = [];
  String currentAllergyText = "";
  String? phone;
  String? phoneCode;
  String initialCountry = 'CM';
  PhoneNumber number = PhoneNumber(isoCode: 'CM');

  
  File? imageFileAvatar;
  bool imageLoading = false;
  bool buttonLoading = false;
  String? avatarUrl;
  
  PageController controller = PageController(initialPage: 0, keepPage: false);
  int currentPageValue = 0;
  List<Widget>? pageList;

  String? _gender;
  String? _bloodGroup;
  bool male = false;
  bool female = false;

  bool _confirmFamily = false;
  bool marriageCertificateUploaded = false;
  bool birthCertificateUploaded = false;
  bool cniUploaded = false;
  bool otherFileUploaded = false;
  bool marriageCertificateSpinner = false;
  bool birthCertificateSpinner = false;
  bool cniSpinner = false;
  bool otherFileSpinner = false;

  initTextfields(){
    AdherentModelProvider adherentModel = Provider.of<AdherentModelProvider>(context, listen: false);
    if (adherentModel.getAdherent!.familyName != null){
      setState(() {
        _familynameController.text = adherentModel.getAdherent!.familyName!;
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
    pageList = <Widget>[
      formLayout(getForm1()),
      formLayout(getForm2()),
      formLayout(getForm3())
    ];
    return WillPopScope(
      onWillPop: () async {
        if (currentPageValue == 0)
          Navigator.pop(context);
        else
          controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,), 
            onPressed: (){
              if (currentPageValue == 0)
                Navigator.pop(context);
              else
                controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
            }
          ),
          title: Text(S.of(context).ajouterUnBnficiaire, style: TextStyle(color: kPrimaryColor, fontSize: wv*4.5, fontWeight: FontWeight.w500),),
          centerTitle: true,
          actions: [
            //IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kSouthSeas,), onPressed: (){}),
            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), onPressed: () => _scaffoldKey.currentState!.openEndDrawer())
          ],
        ),
        endDrawer: DefaultDrawer(
          entraide: (){Navigator.pop(context); Navigator.pop(context);},
          accueil: (){Navigator.pop(context); Navigator.pop(context);},
          carnet: (){Navigator.pop(context); Navigator.pop(context);},
          partenaire: (){Navigator.pop(context); Navigator.pop(context);},
          famille: (){Navigator.pop(context); Navigator.pop(context);},
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(currentPageValue == 0 ? "1 / 3\n" : currentPageValue == 1 ? "2 / 3\n" : "3 / 3\n", style: TextStyle(fontWeight: FontWeight.w700,color: kBlueDeep),),
                ),
                Expanded(
                  child: PageView.builder(
                    pageSnapping: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: pageList!.length,
                    onPageChanged: (int page) {
                      getChangedPageAndMoveBar(page);
                    },
                    controller: controller,
                    itemBuilder: (context, index) {
                      return pageList![index];
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: hv*3, top: hv*2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < pageList!.length; i++)
                        if (i == currentPageValue) ...[circleBar(true)] else
                          circleBar(false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getForm1(){
    return Form(
      key: _form1Key,
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [

              SizedBox(height: hv*2,),

              Center(
                child: Stack(children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: wv*14,
                        child: imageFileAvatar == null ? Icon(LineIcons.user, color: Colors.white, size: wv*20,) : Container(),
                        backgroundImage: imageFileAvatar == null ? null : FileImage(imageFileAvatar!),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: kDeepTeal,
                          radius: wv*4,
                          child: IconButton(padding: EdgeInsets.all(0),icon: Icon(Icons.add, color: whiteColor,), color: kPrimaryColor, onPressed: (){getImage(context);}),
                        ),
                      )
                    ],),
              ),

              SizedBox(height: hv*2,),

              CustomTextField(
                prefixIcon: Icon(LineIcons.userFriends, color: kPrimaryColor),
                label: S.of(context).nomDeFamille,
                hintText: S.of(context).entrezVotreNomDeFamille,
                controller: _familynameController,
                validator: (String? val) => (val!.isEmpty) ? S.of(context).ceChampEstObligatoire : null,
              ),

              SizedBox(height: hv*2,),

              CustomTextField(
                prefixIcon: Icon(LineIcons.user, color: kPrimaryColor),
                label: S.of(context).prnom,
                hintText: S.of(context).entrezVotrePrnom,
                controller: _surnameController,
                validator: (String? val) => (val!.isEmpty) ? S.of(context).ceChampEstObligatoire : null
              ),

              SizedBox(height: hv*2,),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: wv*2),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).numroMobile, style: TextStyle(fontSize: wv*4),),
                    SizedBox(height: hv*1,),
                    InternationalPhoneNumberInput(
                      validator: (String? phone) {
                        return null;
                      },
                      onInputChanged: (PhoneNumber number) {
                        phone = number.phoneNumber;
                        phoneCode = number.isoCode;
                        print(number.phoneNumber);
                        print(number.isoCode);
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
                    ),

                    SizedBox(height: hv*2,),

                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).relationAvecLadhrent, style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
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
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(S.of(context).choisir),
                                value: _relation,
                                items: [
                                  DropdownMenuItem(
                                    child: Text(S.of(context).enfant, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                    value: S.of(context).child,
                                  ),
                                  DropdownMenuItem(
                                    child: Text(S.of(context).conjointe, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                    value: S.of(context).spouse,
                                  ),
                                  DropdownMenuItem(
                                    child: Text(S.of(context).frresoeur, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                    value: S.of(context).sibling,
                                  ),
                                  DropdownMenuItem(
                                    child: Text(S.of(context).parent, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                    value: S.of(context).parent,
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _relation = value;
                                  });
                                }),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: hv*2,),

                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).dateDeNaissance, style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                        SizedBox(height: 5,),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            width: wv*50,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Row(children: [
                              SvgPicture.asset("assets/icons/Bulk/CalendarLine.svg", color: kDeepTeal,),
                              VerticalDivider(),
                              Text( selectedDate != null ? "${selectedDate!.toLocal()}".split(' ')[0] : S.of(context).choisir, style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.bold),),
                            ],),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: hv*2,),

              
            ],),
          ),
          ((selectedDate != null) & (_relation != null)) ? CustomTextButton(
            text: S.of(context).suivant,
            action: (){
              if (_form1Key.currentState!.validate()){
                controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
              }
            },
          ) : CustomDisabledTextButton(text: S.of(context).suivant,)
        ],
      ),
    );
  }
  
  Widget getForm2(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: wv*2),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: hv*2.5,),
                  Center(child: Text(S.of(context).genre, style: TextStyle(fontSize: 18, color: kTextBlue))),
                  SizedBox(height: hv*1,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _gender = "F"; male = false; female = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: wv*6, vertical: hv*2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _gender != "F" ? whiteColor : kSouthSeas,
                          boxShadow: [BoxShadow(blurRadius: 2.0, spreadRadius: 1.0, color: Colors.grey[300]!, offset: Offset(0, 1))]
                        ),
                        child: SvgPicture.asset('assets/icons/Bulk/Woman.svg', width: wv*8, color: _gender != "F" ? kSouthSeas : whiteColor,),
                      ),
                    ),
                    SizedBox(width: wv*3,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _gender = "H"; male = true; female = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: wv*6, vertical: hv*2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _gender != "H" ? whiteColor : kSouthSeas,
                          boxShadow: [BoxShadow(blurRadius: 2.0, spreadRadius: 1.0, color: Colors.grey[300]!, offset: Offset(0, 1))]
                        ),
                        child: SvgPicture.asset('assets/icons/Bulk/Man.svg', width: wv*8, color: _gender != "H" ? kSouthSeas : whiteColor,),
                      ),
                    )
                  ],),
                  Divider(height: hv*4,),
                  Text(S.of(context).groupeSanguin, style: TextStyle(fontSize: 18, color: kTextBlue),),
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
                        child: DropdownButton<String>(isExpanded: true, hint: Text(S.of(context).choisir), value: _bloodGroup,
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
                          onChanged: (value) => setState(() {_bloodGroup = value;})
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: hv*3),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    Column(children: [
                      Text(S.of(context).taille, style: TextStyle(fontSize: 18, color: kTextBlue),), SizedBox(height: hv*0.5,),
                      Row(children: [
                        Container(child: SvgPicture.asset('assets/icons/Bulk/row-height.svg', width: wv*8,)),
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
                      Text(S.of(context).poids, style: TextStyle(fontSize: 18, color: kTextBlue),), SizedBox(height: hv*0.5,),
                      Row(children: [
                        Container(child: SvgPicture.asset('assets/icons/Bulk/weight.svg', width: wv*8,)),
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

                  Divider(height: hv*4,),

                  Row(children: [
                    Text(S.of(context).allergies, style: TextStyle(fontSize: 18, color: kTextBlue),), SizedBox(width: wv*3,),
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
                              icon: CircleAvatar(child: Icon(Icons.add, color: whiteColor), backgroundColor: kSouthSeas,),),
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

                ],
              ),
            ),
          ),
          Container(
            child: ((_gender != null) & (_heightController.text.isNotEmpty)) 
              ? CustomTextButton(action: (){
                AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);
                matricule = Algorithms().getMatricule(selectedDate!, adherentModelProvider.getAdherent!.regionOfOrigin!, _gender!);
                controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                }, text: S.of(context).suivant,) 
              : CustomDisabledTextButton(text: S.of(context).suivant,),
          )
        ],
      ),
    );
  }

  getForm3(){
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: wv*3),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: hv*3,),
                  Text(S.of(context).tlchargerLesPicesJustificatives, style: TextStyle(color: kBlueDeep, fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: hv*1,),
                  Text(S.of(context).scannerLesDocumentsJustificatifsCniActesDeNaissancesEtc, style: TextStyle(color: kBlueDeep, fontSize: 12, fontWeight: FontWeight.w400)),
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
                    title: S.of(context).scanDeLaCni,
                    state: cniUploaded,
                    loading: cniSpinner,
                    action: () async {await getDocFromGallery('CNI');}
                  ),
                  SizedBox(height: hv*1,),
                  FileUploadCard(
                    title: S.of(context).acteDeNaissance,
                    state: birthCertificateUploaded,
                    loading: birthCertificateSpinner,
                    action: () async {await getDocFromGallery('Acte_De_Naissance');}
                  ),
                  SizedBox(height: hv*1,),
                  FileUploadCard(
                    title: S.of(context).acteDeMarriage,
                    state: marriageCertificateUploaded,
                    loading: marriageCertificateSpinner,
                    action: () async {await getDocFromGallery('Acte_De_Marriage');}
                  ),
                  SizedBox(height: hv*1,),
                  FileUploadCard(
                    title: S.of(context).autrePiceJustificative,
                    state: otherFileUploaded,
                    loading: otherFileSpinner,
                    action: () async {await getDocFromGallery('Pièce_Justificative_Supplémentaire');}
                  ),
                  SizedBox(height: hv*2,),

                  Text(S.of(context).dclaration, style: TextStyle(color: kDeepTeal, fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: hv*0.5,),
                  Text(S.of(context).pourLesBnficiairesSansFiliationDirecte, style: TextStyle(color: kDeepTeal, fontSize: 16, fontWeight: FontWeight.w400)),
                  SizedBox(height: hv*2,),
                  CheckboxListTile(
                    value: _confirmFamily,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: kDeepTeal,
                    tristate: false,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    onChanged: (val)=> setState((){_confirmFamily = val!;}),
                    title: Text(S.of(context).jeConfirmeParLaPrsenteQueLaPersonneSusciteEst, style: TextStyle(color: kTextBlue, fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(height: hv*3,),
                ],
              ),
            ),
          ),
        ),
        ((_confirmFamily == true) && (birthCertificateUploaded == true) && _gender != null)
          ? CustomTextButton(
            text: S.of(context).suivant, 
            isLoading: buttonLoading,
            action: (){
              setState(() {
                buttonLoading = true;
              });
              AdherentModelProvider adherentModel = Provider.of<AdherentModelProvider>(context, listen: false);
              BeneficiaryModelProvider beneficiary = Provider.of<BeneficiaryModelProvider>(context, listen: false);
              FirebaseFirestore.instance.collection("ADHERENTS")
                .doc(adherentModel.getAdherent!.getAdherentId)
                .collection("BENEFICIAIRES").doc(matricule)
                .set({
                  "adherentId": adherentModel.getAdherent!.getAdherentId,
                  "nomDFamille" : _familynameController.text,
                  "prenom": _surnameController.text,
                  "cniName": "${_familynameController.text} ${_surnameController.text}",
                  "bloodGroup": _bloodGroup,
                  "autrePieceName": "${_familynameController.text} ${_surnameController.text}",
                  "acteMariageName": "${_familynameController.text} ${_surnameController.text}",
                  "urlImage": avatarUrl,
                  "genre": _gender,
                  "urlActeMariage": beneficiary.getBeneficiary.marriageCertificateUrl,
                  "urlAutrPiece": beneficiary.getBeneficiary.otherDocUrl,
                  "urlCNI": beneficiary.getBeneficiary.cniUrl,
                  "urlActeNaissance": beneficiary.getBeneficiary.birthCertificateUrl,
                  "createdDate": DateTime.now(),
                  "datFinvalidite": adherentModel.getAdherent!.validityEndDate,
                  "dateNaissance": selectedDate,
                  "enabled": false,
                  "ifVivreMemeDemeure": _confirmFamily,
                  "phoneList": [{"number": phone}],
                  "height": _heightController.text,
                  "weight": _weightController.text,
                  "allergies": allergies,
                  "relation": _relation,
                }, SetOptions(merge: true)).then((value) async {
                  if(beneficiary.getBeneficiary.phoneList![0] != null){
                    if(phone == null){
                      setState(() {
                        phone = beneficiary.getBeneficiary.phoneList![0]["number"];
                      });
                    }
                  }
                  if(phone != null) {
                    await FirebaseFirestore.instance.collection("USERS").doc(phone).set({
                      "authId": null,
                      "adherentId": adherentModel.getAdherent!.getAdherentId,
                      'createdDate': DateTime.now(),
                      'emailAdress': null,
                      'enabled': false,
                      "phoneList": FieldValue.arrayUnion([{"number": phone}]),
                      "urlCNI": null,
                      "profilEnabled": false,
                      "userCountryCodeIso": phoneCode,
                      "userCountryName": "Cameroon",
                      'fullName': "${_familynameController.text} ${_surnameController.text}",
                      "imageUrl" : avatarUrl,
                      "points": 500,
                      "visitPoints": 0,
                      "matricule": matricule,
                      "profil": "BENEFICIAIRE",
                      "regionDorigione": adherentModel.getAdherent!.regionOfOrigin,
                      "phoneKeywords": Algorithms.getKeyWords(phone!),
                      "nameKeywords": Algorithms.getKeyWords(_familynameController.text + " "+ _surnameController.text)
                    }, SetOptions(merge: true));
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_surnameController.text} ajouté comme bénéficiaire'),));
                  setState(() {
                    buttonLoading = false;
                  });
                  Navigator.pop(context);
                });
            },
          )
          : CustomDisabledTextButton(text: S.of(context).suivant,)
      ],
    );
  }

  List<String> suggestions = [
    S.current.lactose,
    S.current.pnicilline,
    S.current.pollen,
    S.current.abeille,
    S.current.feu,
    S.current.herbes,
    S.current.plastique
  ];

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  Widget formLayout(Widget content){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: wv*2),
      margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 3.0, spreadRadius: 1.0)]
      ),
      child: content,
    );
  }

  Future uploadImageToFirebase(PickedFile file) async {

    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).aucuneImageSelectionne),));
      return null;
    }
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    BeneficiaryModelProvider beneficiary = Provider.of<BeneficiaryModelProvider>(context, listen: false);
    setState(() {
      imageLoading = true;
    });
    String folder = userProvider.getUserId!;
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
                    title: new Text(S.of(context).gallerie),
                    onTap: () {
                      getImageFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(S.of(context).camera),
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
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(S.of(context).aucuneImageSelectionne),));
      return null;
    }
    
    String adherentId = adherentModelProvider.getAdherent!.adherentId!;
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name"+S.of(context).ajoute)));
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
                    title: new Text(S.of(context).cniOuPasseport, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600),),
                    onTap: () {
                      getDocFromPhone("CNI");
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(MdiIcons.babyFaceOutline),
                  title: new Text(S.of(context).acteDeNaissance, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                  onTap: () {
                    getDocFromPhone("Acte_De_Naissance");
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(LineIcons.ring),
                  title: new Text(S.of(context).acteDeMarriage, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                  onTap: () {
                    getDocFromPhone("Acte_De_Marriage");
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(LineIcons.certificate),
                  title: new Text(S.of(context).autrePiceJustificative, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
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

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 10 : 6,
      width: isActive ? 10 : 6,
      decoration: BoxDecoration(
          color: isActive ? kDeepTeal : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}