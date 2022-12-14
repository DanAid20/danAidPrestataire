import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/loanModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/loanModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/adhrent_views/health_book_screen.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/file_upload_card.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/forms/form_widget.dart';
import 'package:danaid/widgets/function_widgets.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:line_icons/line_icons.dart';
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:simple_tags/simple_tags.dart';

class LoanForm extends StatefulWidget {
  @override
  _LoanFormState createState() => _LoanFormState();
}

class _LoanFormState extends State<LoanForm> {
  TextEditingController _purposeController = new TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _avalistPhoneController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _employerController = TextEditingController();
  final TextEditingController _avalistNameController = TextEditingController();

  String matricule;
  int _duration = 6;
  bool _isSalaryMan;
  bool _avalist = false;
  bool _trustConditionAccepted = false;
  bool _serviceTermsAccepted = false;
  String phone;
  String avalistPhone;
  String initialCountry = 'CM';
  PhoneNumber number = PhoneNumber(isoCode: 'CM');

  
  File imageFileAvatar;
  bool imageLoading = false;
  bool buttonLoading = false;
  String avatarUrl;
  
  PageController controller = PageController(initialPage: 0, keepPage: false);
  int currentPageValue = 0;
  List<Widget> pageList;

  bool carnetUploaded = false;
  bool otherFileUploaded = false;
  bool carnetSpinner = false;
  bool otherFileSpinner = false;
  
  @override
  void initState() {
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
        return null;
      },
      child: Scaffold(
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
          title: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Aper??u de mon Pr??t Sant??", style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
              Text("Ajouter, modifier ou envoyer les pi??ces", 
                style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kSouthSeas,), onPressed: (){}),
            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), onPressed: (){})
          ],
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
                    itemCount: pageList.length,
                    onPageChanged: (int page) {
                      getChangedPageAndMoveBar(page);
                    },
                    controller: controller,
                    itemBuilder: (context, index) {
                      return pageList[index];
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: hv*3, top: hv*2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < pageList.length; i++)
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
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    LoanModelProvider loanProvider = Provider.of<LoanModelProvider>(context);
    AdherentModel adh = adherentProvider.getAdherent;
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(), children: [
            Container(
              padding: EdgeInsets.only(bottom: hv*1.5),
              decoration: BoxDecoration(
                color: kBrownCanyon.withOpacity(0.2),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: hv*1.5),
                    decoration: BoxDecoration(
                      color: kBrownCanyon.withOpacity(0.3),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                    ),
                    child: Column(
                      children: [
                        HomePageComponents.header(label: "Demandeur", title: adh.surname + " " + adh.familyName, subtitle: adh.address.toString(), avatarUrl: adh.imgUrl, titleColor: kTextBlue),
                        SizedBox(height: hv*2),
                        Row(
                          children: [
                            SizedBox(width: wv*4,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Montant du cr??dit", style: TextStyle(fontSize: 16, color: kTextBlue, fontWeight: FontWeight.w600)),
                                Text(loanProvider.getLoan.amount.toInt().toString() + " .f", style: TextStyle(fontSize: 25, color: kTextBlue, fontWeight: FontWeight.w400)),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Vos mensualit??s", style: TextStyle(fontSize: 16, color: kTextBlue, fontWeight: FontWeight.w600)),
                                Container(
                                  margin: EdgeInsets.only(top: hv*0.2),
                                  padding: EdgeInsets.symmetric(horizontal: wv*6, vertical: hv*0.25),
                                  decoration: BoxDecoration(
                                    color: kBrownCanyon.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Text(Algorithms.getFixedMonthlyMortgageRate(amount: loanProvider.getLoan.amount, rate: adherentProvider.getAdherent.adherentPlan == 0 ? 0.16/12 : 0.05/12, months: _duration).toInt().toString() + " .f", style: TextStyle(fontSize: 20, color: kTextBlue, fontWeight: FontWeight.bold))
                                ),
                              ],
                            ),
                            SizedBox(width: wv*4,),
                          ],
                        )
                      ],
                  )),
                  SizedBox(height: hv*1.5,),
                  Row(
                    children: [
                      SizedBox(width: wv*5),
                      SvgPicture.asset('assets/icons/Two-tone/Monochrome.svg'),
                      SizedBox(width: wv*2),
                      Expanded(child: Text("Rembourser ?? temps augmente votre niveau de cr??dit.", style: TextStyle(fontSize: 15, color: kTextBlue))),
                      SizedBox(width: wv*5)
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: hv*3,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: wv*4),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dur??e *", style: TextStyle(fontSize: 16, color: kTextBlue, fontWeight: FontWeight.w400),),
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
                              value: _duration,
                              items: [
                                DropdownMenuItem(
                                  child: Text("6 mois (6 paiements)", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                  value: 6,
                                ),
                                DropdownMenuItem(
                                  child: Text("12 mois (12 paiements)", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                  value: 12,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _duration = value;
                                });
                              }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: hv*2,),

            Container(
              padding: EdgeInsets.symmetric(horizontal: wv*1),
              child: CustomTextField(
                label: "Quelle en est la raison ?",
                labelColor: kTextBlue,
                hintText: "Raison du pr??t..",
                controller: _purposeController,
                onChanged: (val)=>setState((){}),
                validator: (String val) => (val.isEmpty) ? "Ce champ est obligatoire" : null
              ),
            ),

            SizedBox(height: hv*2,),

            Container(
              padding: EdgeInsets.symmetric(horizontal: wv*4),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: hv*3,),
                  Text("Scanner des justificatifs", style: TextStyle(color: kBlueDeep, fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: hv*0.5,),
                  Text("Un devis, une ordonnance ou tout autre pi??ce en appui..)", style: TextStyle(color: kBlueDeep, fontSize: 12, fontWeight: FontWeight.w400)),
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
                    title: "Carnet",
                    state: carnetUploaded,
                    loading: carnetSpinner,
                    action: () async {await getDocFromGallery('Carnet');}
                  ),
                  SizedBox(height: hv*1,),
                  FileUploadCard(
                    title: "Autre pi??ce justificative",
                    state: otherFileUploaded,
                    loading: otherFileSpinner,
                    action: () async {await getDocFromGallery('Pi??ce_Justificative_Suppl??mentaire');}
                  ),
                  SizedBox(height: hv*2,),
                ],
              ),
            ),

            
          ],),
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextButton(
                text: "Suivant",
                enable: _purposeController.text.isNotEmpty,
                action: (){
                    controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                },
              ),
            ),
            Expanded(
              child: CustomTextButton(
                text: "Annuler",
                color: kSouthSeas,
                action: (){
                    Navigator.pop(context);
                },
              ),
            ),
          ],
        )
      ],
    );
  }
  
  Widget getForm2(){
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    LoanModelProvider loanProvider = Provider.of<LoanModelProvider>(context);
    AdherentModel adh = adherentProvider.getAdherent;
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: hv*1.5),
            decoration: BoxDecoration(
              color: kBrownCanyon.withOpacity(0.3),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))
            ),
            child: Column(
              children: [
                HomePageComponents.header(label: "Demandeur", title: adh.surname + " " + adh.familyName, subtitle: adh.address.toString(), avatarUrl: adh.imgUrl, titleColor: kTextBlue),
              ],
          )),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Source de revenues", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w900)),
                    SizedBox(height: hv*2,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: "Revenue mensuel",
                            labelColor: kTextBlue,
                            noPadding: true,
                            controller: _salaryController,
                            keyboardType: TextInputType.number,
                            suffixIcon: Text("f."),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$')),
                            ],
                            onChanged: (val)=>setState((){}),
                          ),
                        ),
                        SizedBox(width: wv*3,),
                        Expanded(
                          child: CustomDropDownButton(
                            label: "Etes vous salari?? ?",
                            value: _isSalaryMan,
                            items: [
                                  DropdownMenuItem(
                                    child: Text("Oui", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                    value: true,
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Non", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                    value: false,
                                  ),
                            ],
                            onChanged: (val)=>setState((){_isSalaryMan = val;}),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: hv*2,),
                    CustomTextField(
                      label: "Employeur",
                      labelColor: kTextBlue,
                      noPadding: true,
                      controller: _employerController,
                      onChanged: (val)=>setState((){}),
                    ),
                    SizedBox(height: hv*2,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("T??l??phone", style: TextStyle(fontSize: 16, color: kTextBlue)),
                        SizedBox(height: 5,),
                        InternationalPhoneNumberInput(
                          validator: (String phone) {
                            return null;
                          },
                          onInputChanged: (PhoneNumber number) {
                            phone = number.phoneNumber;
                            setState((){});
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
                        ),
                      ],
                    ),
                    SizedBox(height: hv*2,),
                    CheckboxListTile(
                      title: Text("Souhaitez vous avoir un avaliste ?", style: TextStyle(fontSize: 16, color: kBlueDeep)),
                      subtitle: Text("Votre ??poux(se) est de facto solidaire de votre cr??dit, vous pouvez avoir un avaliste suppl??mentaitre.", style: TextStyle(fontSize: 13, color: kTextBlue)),
                      activeColor: kSouthSeas,
                      value: _avalist, 
                      onChanged: (val)=>setState((){_avalist = val;})
                    ),

                    _avalist ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: hv*2,),
                        CustomTextField(
                          labelColor: kTextBlue,
                          label: "Nom de l'avaliste",
                          noPadding: true,
                          controller: _avalistNameController,
                          onChanged: (val)=>setState((){}),
                        ),

                        SizedBox(height: hv*2,),

                        Text("T??l??phone", style: TextStyle(fontSize: 16, color: kTextBlue),),
                        SizedBox(height: hv*1,),
                        InternationalPhoneNumberInput(
                          validator: (String phone) {
                            return null;
                          },
                          onInputChanged: (PhoneNumber number) {
                            avalistPhone = number.phoneNumber;
                            setState((){});
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
                          textFieldController: _avalistPhoneController,
                          formatInput: true,
                          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                          inputDecoration: defaultInputDecoration(),
                        ),
                      ],
                    ) : Container()
                  ],
                ),
              ),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: CustomTextButton(
                text: "Suivant",
                enable: !_avalist ? _salaryController.text.isNotEmpty && _isSalaryMan != null && _employerController.text.isNotEmpty && _phoneController.text.isNotEmpty : _salaryController.text.isNotEmpty && _isSalaryMan != null && _employerController.text.isNotEmpty && _phoneController.text.isNotEmpty && _avalistNameController.text.isNotEmpty && _avalistPhoneController.text.isNotEmpty,
                action: (){
                    controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                },
              ),
            ),
            Expanded(
              child: CustomTextButton(
                text: "Annuler",
                color: kSouthSeas,
                action: (){
                    controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                },
              ),
            ),
          ],
        )
        ],
      ),
    );
  }

  getForm3(){
    DateTime now = DateTime.now();
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    LoanModelProvider loanProvider = Provider.of<LoanModelProvider>(context);
    LoanModel loan = loanProvider.getLoan;
    AdherentModel adh = adherentProvider.getAdherent;
    int mensuality = Algorithms.getFixedMonthlyMortgageRate(amount: loanProvider.getLoan.amount, rate: adherentProvider.getAdherent.adherentPlan == 0 ? 0.16/12 : 0.05/12, months: _duration).toInt();
    num totalToPay = mensuality * _duration;
    DateTime firstPaymentDate = DateTime(now.year, now.month + 1, now.day);
    DateTime lastPaymentDate = DateTime(now.year, now.month + _duration, now.day);
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(), children: [
            Container(
              padding: EdgeInsets.only(bottom: hv*1.5),
              decoration: BoxDecoration(
                color: kBrownCanyon.withOpacity(0.2),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: hv*1.5),
                    decoration: BoxDecoration(
                      color: kBrownCanyon.withOpacity(0.3),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                    ),
                    child: Column(
                      children: [
                        HomePageComponents.header(label: "Demandeur", title: adh.surname + " " + adh.familyName, subtitle: adh.address.toString(), avatarUrl: adh.imgUrl, titleColor: kTextBlue),
                        SizedBox(height: hv*2),
                        Row(
                          children: [
                            SizedBox(width: wv*4,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Montant du cr??dit", style: TextStyle(fontSize: 16, color: kTextBlue, fontWeight: FontWeight.w600)),
                                Text(loan.amount.toInt().toString() + " .f", style: TextStyle(fontSize: 25, color: kTextBlue, fontWeight: FontWeight.w400)),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Vos mensualit??s", style: TextStyle(fontSize: 16, color: kTextBlue, fontWeight: FontWeight.w600)),
                                Container(
                                  margin: EdgeInsets.only(top: hv*0.2),
                                  padding: EdgeInsets.symmetric(horizontal: wv*6, vertical: hv*0.25),
                                  decoration: BoxDecoration(
                                    color: kBrownCanyon.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Text(mensuality.toString() + " .f", style: TextStyle(fontSize: 20, color: kTextBlue, fontWeight: FontWeight.bold))
                                ),
                              ],
                            ),
                            SizedBox(width: wv*4,),
                          ],
                        )
                      ],
                  )),
                  SizedBox(height: hv*1.5,),
                  Row(
                    children: [
                      SizedBox(width: wv*5),
                      SvgPicture.asset('assets/icons/Two-tone/Monochrome.svg'),
                      SizedBox(width: wv*2),
                      Expanded(child: Text("Rembourser ?? temps augmente votre niveau de cr??dit.", style: TextStyle(fontSize: 15, color: kTextBlue))),
                      SizedBox(width: wv*5)
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: hv*2,),

            Container(
              padding: EdgeInsets.symmetric(horizontal: wv*4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Informations sur le remboursement", style: TextStyle(color: kBlueDeep, fontSize: 17, fontWeight: FontWeight.w600),),
                  SizedBox(height: hv*2,),
                  getTableRow(input: "Fr??quence :", output: "$_duration Mensualit??s"),
                  getTableRow(input: "taux d'int??r??t effectif :", output: adh.adherentPlan == 0 ? "16%" : "5%"),
                  getTableRow(input: "Montant total ?? rembourser :", output: "$totalToPay f."),
                  getTableRow(input: "Premier versement :", output: firstPaymentDate.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(firstPaymentDate)+" "+ firstPaymentDate.year.toString()),
                  getTableRow(input: "Dernier versement :", output: lastPaymentDate.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(lastPaymentDate)+" "+ lastPaymentDate.year.toString()),
                ],
              ),
            ),
            SizedBox(height: hv*3.5),

            HomePageComponents.confirmTermsTile(
              textColor: kTextBlue,
              action: ()=>FunctionWidgets.termsAndConditionsDialog(context: context),
              value: _trustConditionAccepted,
              activeColor: primaryColor,
              onChanged: (newValue) {
                setState(() {
                  _trustConditionAccepted = newValue;
                });
              },
            ),
            
            SizedBox(height: hv*1),

            HomePageComponents.termsAndConditionsTile(
              textColor: kTextBlue,
              action: ()=>FunctionWidgets.termsAndConditionsDialog(context: context),
              value: _serviceTermsAccepted,
              activeColor: primaryColor,
              onChanged: (newValue) {
                setState(() {
                  _serviceTermsAccepted = newValue;
                });
              },
            ),

            
          ],),
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextButton(
                  text: "Suivant", 
                  enable: _serviceTermsAccepted && _trustConditionAccepted,
                  isLoading: buttonLoading,
                  action: (){
                    try {
                      setState(() {
                        buttonLoading = true;
                      });
                      FirebaseFirestore.instance.collection("CREDITS").add({
                        "adherentId": adh.getAdherentId,
                        "amount": loan.amount,
                        "mensuality": mensuality,
                        "totalToPay": totalToPay,
                        "firstPaymentDate": firstPaymentDate,
                        "lastPaymentDate": lastPaymentDate,
                        "createdDate": now,
                        "mostRecentPaymentDate": null,
                        "paymentDates": [],
                        "avalistAdded": _avalist,
                        "avalistName": _avalistNameController.text,
                        "avalistPhone": avalistPhone,
                        "monthlySalary": double.parse(_salaryController.text),
                        "isSalaryMan": _isSalaryMan,
                        "employerName": _employerController.text,
                        "employerPhone": phone,
                        "frequency": _duration,
                        "purpose": _purposeController.text,
                        "docUrl": loan.carnetUrl,
                        "otherDocUrl": loan.otherDocUrl,
                        "status": 0
                      }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Votre demande de cr??dit a ??t?? enr??gistr??e'),));
                        setState(() {
                          buttonLoading = false;
                        });
                        Navigator.pop(context);
                      });
                    }
                    catch(e) {
                      setState(() {
                        buttonLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),));
                    }
                    
                  },
                ),
            ),
            Expanded(
              child: CustomTextButton(
                text: "Annuler",
                color: kSouthSeas,
                action: (){
                    controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  Widget formLayout(Widget content){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 3.0, spreadRadius: 1.0)]
      ),
      child: content,
    );
  }


  Future getDocFromPhone(String name) async {

    setState(() {
      if (name == "Carnet"){
        carnetSpinner = true;
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
          if (name == "Carnet"){
            carnetSpinner = false;
          } else {
            otherFileSpinner = false;
          }
        });
      }
    });
  }

  Future uploadDocumentToFirebase(File file, String name) async {
    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    LoanModelProvider loanProvider = Provider.of<LoanModelProvider>(context, listen: false);
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucune image selectionn??e'),));
      return null;
    }
    
    String adherentId = adherentModelProvider.getAdherent.adherentId;
    Reference storageReference = FirebaseStorage.instance.ref().child('demandes_de_credit/$adherentId/$name-'+DateTime.now().millisecondsSinceEpoch.toString()); //.child('photos/profils_adherents/$fileName');
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name ajout??e")));
      String url = await storageReference.getDownloadURL();
      if (name == "Carnet"){
        loanProvider.setCarnetUrl(url);
        setState(() {
          carnetUploaded = true;
          carnetSpinner = false;
        });
      }
      else {
        loanProvider.setotherDocUrl(url);
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
      if (name == "Carnet"){
        carnetSpinner = true;
      } else {
        otherFileSpinner = true;
      }
    });
    
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc'],);
    if(result != null) {
      File file = File(result.files.single.path);
      uploadDocumentToFirebase(file, name);
    } else {
      setState(() {
        if (name == "Carnet"){
          carnetSpinner = false;
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
                    title: new Text('Carnet', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600),),
                    onTap: () {
                      getDocFromPhone("Carnet");
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(LineIcons.certificate),
                  title: new Text('Autre pi??ce justificative', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                  onTap: () {
                    getDocFromPhone("Pi??ce_Justificative_Suppl??mentaire");
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

  Widget getTableRow({String input, String output}){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: hv*0.5),
      child: Row(
        children: [
          Text(input, style: TextStyle(color: kTextBlue, fontSize: 15)),
          Spacer(),
          Text(output, style: TextStyle(color: kTextBlue, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
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
}