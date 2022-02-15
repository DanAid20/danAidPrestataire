import 'dart:math';

import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/ServicesProviderInvoice.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_tags/simple_tags.dart';
import 'package:qrscan2/qrscan2.dart' as scanner;
class IssuseAQuote extends StatefulWidget {
  IssuseAQuote({Key? key}) : super(key: key);

  @override
  _IssuseAQuoteState createState() => _IssuseAQuoteState();
}

class _IssuseAQuoteState extends State<IssuseAQuote> {
  final GlobalKey<FormState>? _form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState>? _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey =  GlobalKey();
   final TextEditingController? _ProduitOuServicesController = TextEditingController();
   final TextEditingController? _LibelleController = TextEditingController();
   final TextEditingController? _MontantController = TextEditingController();
   final TextEditingController? _descriptionController = TextEditingController();
   final TextEditingController? _phoneNumber = TextEditingController();
  PageController? controller = PageController(initialPage: 0, keepPage: false);
  AdherentModel? adherentInfos;
  BeneficiaryModel? adherentBeneficiaryInfos;
  int? currentPageValue = 0;
  List<Widget>? pageList;
  bool? buttonLoading = false, isUserExists=false;
  bool? confirmSpinner = false, isAllOk=false;
  String? initialCountry = 'CM';
   PhoneNumber? number = PhoneNumber(isoCode: 'CM');
  List<String>? description = [];
  String? type;
  String? famillyDoctorNAme;
  String? devis, phone, textForQrCode , currentAllergyText = "";
  String? getRandomString(int length) {
    const _chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random _rnd = Random();
    var result = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return 'Devis N.' + result;
  }
  initTextfields(){
     devis = getRandomString(7); 
    _LibelleController!.text=devis!;
   
  }
  @override
  void initState() {
    initTextfields();
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
     pageList = <Widget>[
      formLayout(getForm1(), true),
      formLayout(getForm2(), false),
      formLayout(userCard(adherentBeneficiaryInfos!), false),
    ];
    return WillPopScope(
      onWillPop: () async {
        if (currentPageValue == 0){
          Navigator.pop(context);
          return true;
        }else{
          controller!.previousPage(duration: const Duration(milliseconds: 500), curve:   Curves.ease);
          return true;
        }
      
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kBgTextColor,
        appBar: 
        AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: kDateTextColor,
              ),
              onPressed: () => Navigator.pop(context)),
          title: Align(
            alignment: Alignment.center,
            child: Container(
              child: Column(
                children: [
                  const Text("Créer un devis"),
                  Text(DateFormat('dd MMMM yyyy à h:mm').format(DateTime.now()))
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/Bulk/Search.svg',
                color: kSouthSeas,
              ),
              onPressed: () {},
              color: kSouthSeas,
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/Bulk/Drawer.svg',
                color: kSouthSeas,
              ),
              onPressed: () {},
              color: kSouthSeas,
            )
          ],
        ),
      
      body: SafeArea(
        child: Container(
            child: Column( children: [
                Container(
                margin:const EdgeInsets.only(top: 10),
                child: Text(currentPageValue == 0 ? "1 / 3\n" : currentPageValue == 1 ? "2 / 3\n" : "3 / 3\n", style: const TextStyle(fontWeight: FontWeight.w700,color: kBlueDeep),),
              ),
              Expanded(
                child: PageView.builder(
                  pageSnapping: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                  margin: EdgeInsets.only(bottom: hv*5, top: hv*5),
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
            ])
        ),
      )
      ),
    );
  }
  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 10 : 6,
      width: isActive ? 10 : 6,
      decoration: BoxDecoration(
          color: isActive ? kDeepTeal : Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }
  Widget getForm2(){
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(children: [
               Container(
                
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: wv * 68,
                        height: hv*6,
                        decoration: const BoxDecoration(
                          color: kDeepTellow,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        padding: EdgeInsets.only(
                          left: wv * 1.9,
                          right: wv * 1.5,
                          top: hv * 1,

                        ),
                        child: Row(
                          children: [
                            Container(
                              child: SvgPicture.asset(
                                'assets/icons/Bulk/Add User.svg',
                                color: kSouthSeas,
                              ),
                            ),
                            SizedBox(
                              width: wv * 2,
                            ),
                            Text(
                              "Scanner La carte du patient",
                              style: TextStyle(
                                  fontSize: fontSize(size: wv * 5),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                  color: kFirstIntroColor),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: wv * 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: inch * 2, right: inch * 2, top: inch * 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                    margin: EdgeInsets.only(
                                        left: inch * 2,
                                        right: inch * 2,
                                        top: inch * 1),
                                    child: GestureDetector(
                                      onTap: () {
                                        _scan(isScanQrCode: true);
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          'assets/icons/Bulk/Scan.svg',
                                          color: kSouthSeas,
                                          height: hv * 16,
                                          width: wv * 16,
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(height: hv*4,),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: wv * 2),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          S.of(context).rechercherParNumeroDeTlphone,
                                          style: TextStyle(
                                              fontSize: wv * 4,
                                              color: kBlueForce),
                                        ),
                                      ),
                                      SizedBox(
                                        height: hv * 3,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                           boxShadow: [BoxShadow(color: (Colors.grey[300])!, blurRadius: 1.0, spreadRadius: 0.3)],
                                          borderRadius: const BorderRadius.all(Radius.circular(20))
                                        ),
                                        child: InternationalPhoneNumberInput(
                                          validator: (String? phone) {
                                            return (phone!.isEmpty)
                                                ? S.of(context).entrerUnNumeroDeTlphoneValide
                                                : null;
                                          },
                                          onInputChanged:
                                              (PhoneNumber number) {
                                            phone = number.phoneNumber;
                                            if (kDebugMode) {
                                              print(number.phoneNumber);
                                            }
                                          },
                                          onInputValidated: (bool value) {
                                            if (kDebugMode) {
                                              print(value);
                                            }
                                          },
                                          hintText: S.of(context).numeroDeTelephone,
                                          spaceBetweenSelectorAndTextField: 0,
                                          selectorConfig: const SelectorConfig(
                                            selectorType:
                                                PhoneInputSelectorType
                                                    .BOTTOM_SHEET,
                                          ),
                                          ignoreBlank: false,
                                          textStyle: const  TextStyle(
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                          autoValidateMode:
                                              AutovalidateMode.disabled,
                                          selectorTextStyle:
                                              const TextStyle(color: Colors.black),
                                          initialValue: number,
                                          textFieldController: _phoneNumber,
                                          formatInput: true,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                  signed: true,
                                                  decimal: true),
                                          inputDecoration: InputDecoration(
                                            errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: (Colors.red[300])!),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            fillColor: kBgTextColor,
                                            //prefixIcon: Icon(Icons.search, color: kBrownCanyon,),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 5),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: kPrimaryColor
                                                        .withOpacity(0.0)),
                                                borderRadius:
                                                  const  BorderRadius.all(
                                                        Radius.circular(20))),
                                            focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: kBgTextColor),
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(20))),
                                          ),
                                          onSaved: (PhoneNumber number) {
                                            if (kDebugMode) {
                                              print('On Saved: $number');
                                            }
                                          },
                                        ),
                                      ),
                                      
                                    ])),
                            SizedBox(
                              height: hv * 2,
                            ),
                            
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: hv * 2,
                ),
             
          ]
        )
      ),
      confirmSpinner! ?
       Center(child: Loaders().buttonLoader(kPrimaryColor)): isUserExists!?  CustomTextButton(
                    enable: true ,
                    text: S.of(context).suivant, 
                    action: () async {
                        await getFamillyDoctorName(adherentBeneficiaryInfos!.adherentId);
                        controller!.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
                      //  if(isUserExists)
                    }): CustomTextButton(
                    enable: true ,
                    text: S.of(context).rechercher, 
                    action: (){
                       _scan( isInput: true);
                    })
                  
    ]);
  }
  bool validateMobile(String? value) {
    String? pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    RegExp? regExp =  RegExp(pattern);
    return regExp.hasMatch(value!);
  }
  Future _scan({isScanQrCode=false, isInput=false}) async {
    if(isScanQrCode){
        await Permission.camera.request();
    String? barcode = await scanner.scan();
    if (barcode == null) {
      if (kDebugMode) {
        print('nothing return.');
      }
      setState(() {
        textForQrCode = barcode ?? S.of(context).codebarvide;
      });
    } else {
      setState(() {
        textForQrCode = barcode;
      });
      if (validateMobile(textForQrCode) == true) {
        if (kDebugMode) {
          print(textForQrCode);
        }
        setState(() {
          confirmSpinner = true;
        });
        await FirebaseFirestore.instance
            .collection('ADHERENTS')
            .doc(barcode)
            .get()
            .then((doc) {
          if (kDebugMode) {
            print(doc.exists);
          }
            setState(() {
              confirmSpinner = false;
            });
            if (doc.exists) {
               AdherentModelProvider adherentModelProvider =
                  Provider.of<AdherentModelProvider>(context, listen: false);
                 adherentInfos = AdherentModel.fromDocument(doc, doc.data() as Map);
                adherentModelProvider.setAdherentModel(adherentInfos!);
                BeneficiaryModel adherentBeneficiary = BeneficiaryModel(
                      avatarUrl: adherentInfos!.imgUrl,
                      surname: adherentInfos!.surname,
                      familyName: adherentInfos!.familyName,
                      matricule: adherentInfos!.matricule,
                      gender: adherentInfos!.gender,
                      adherentId: adherentInfos!.adherentId,
                      birthDate  : adherentInfos!.birthDate,
                      dateCreated: adherentInfos!.dateCreated,
                      enabled: adherentInfos!.enable,
                      height: null,
                      weight: null,
                      bloodGroup: null,
                      protectionLevel: adherentInfos!.adherentPlan!.toInt(),
                      cniName: adherentInfos!.cniName,
                      marriageCertificateName: adherentInfos!.marriageCertificateName,
                      marriageCertificateUrl:  adherentInfos!.marriageCertificateUrl,
                      validityEndDate: adherentInfos!.validityEndDate,
                      phoneList: adherentInfos!.phoneList,
                    );
                setState(() { 
                  isUserExists=true;
                  adherentBeneficiaryInfos= adherentBeneficiary;
                  });
            } else {
             
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(" cet utilisateur n'existe pas")));

            }
          
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(S.of(context).veuillezScannerUnnumeroDeTlphoneValideSvp)));
      }
      setState(() {
        confirmSpinner = false;
      });
    }
    }else if(isInput && _phoneNumber!.text.isNotEmpty){
     setState(() {
              confirmSpinner = true;
            });
       await FirebaseFirestore.instance
            .collection('ADHERENTS')
            .doc(phone)
            .get()
            .then((doc) {
          if (kDebugMode) {
            print(doc.exists);
          }
            setState(() {
              confirmSpinner = false;
            });
           
            if (doc.exists) {
                AdherentModelProvider adherentModelProvider =
                  Provider.of<AdherentModelProvider>(context, listen: false);
                 adherentInfos = AdherentModel.fromDocument(doc, doc.data() as Map);
                adherentModelProvider.setAdherentModel(adherentInfos!);
                BeneficiaryModel adherentBeneficiary = BeneficiaryModel(
                      avatarUrl: adherentInfos!.imgUrl,
                      surname: adherentInfos!.surname,
                      familyName: adherentInfos!.familyName,
                      matricule: adherentInfos!.matricule,
                      gender: adherentInfos!.gender,
                      adherentId: adherentInfos!.adherentId,
                      birthDate  : adherentInfos!.birthDate,
                      dateCreated: adherentInfos!.dateCreated,
                      enabled: adherentInfos!.enable,
                      height: null,
                      weight: null,
                      bloodGroup: null,
                      protectionLevel: adherentInfos!.adherentPlan!.toInt(),
                      cniName: adherentInfos!.cniName,
                      marriageCertificateName: adherentInfos!.marriageCertificateName,
                      marriageCertificateUrl:  adherentInfos!.marriageCertificateUrl,
                      validityEndDate: adherentInfos!.validityEndDate,
                      phoneList: adherentInfos!.phoneList,
                    );
                setState(() { 
                  isUserExists=true;
                  adherentBeneficiaryInfos= adherentBeneficiary;
                  });
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(" cet utilisateur 'existe ")));
                  
            
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const  SnackBar(content: Text(" cet utilisateur n'existe pas")));

            }
          
        });
    }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                 Text("entrer le numéro de téléphone de l'adhérent avant de le rechercher")));
    }
    
  }
  Widget getForm1(){
    return Form(
      key: _form,
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              SizedBox(height: hv*2,),
               CustomTextField(
                prefixIcon: const Icon(LineIcons.tag, color: kPrimaryColor),
                label:"Libélle",
                hintText: "fdfdsf",
                controller: _LibelleController!,
                enabled: false,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: hv*2,),
               CustomTextField(
                prefixIcon: const Icon(LineIcons.moneyBill, color: kPrimaryColor),
                label:"Montant",
                keyboardType: TextInputType.number,
                hintText: "",
                controller: _MontantController!,
              ),
              SizedBox(height: hv*2,),
               CustomTextField(
                prefixIcon: const Icon(LineIcons.audioDescription, color: kPrimaryColor),
                label:"Description",
                hintText: "entrez une description",
                multiLine: true,
                keyboardType: TextInputType.text,
                controller: _descriptionController!,
              ),
               SizedBox(height: hv*2,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: wv * 3),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Type dévis", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                          const SizedBox(height: 5,),
                          Container(
                            constraints: BoxConstraints(minWidth: wv*45),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: const BorderRadius.all(Radius.circular(20))
                            ),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text(S.of(context).choisir),
                                  value: type,
                                  items:  [
                                   const DropdownMenuItem(
                                      child: Text("Suivie", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                      value: "suivie",
                                    ),
                                    const DropdownMenuItem(
                                      child: Text("Nouvelle consultation", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                      value: "Nouvelle consultation",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Achats", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                      value: S.of(context).sibling,
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      type = value.toString();
                                    });
                                  }),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
                    
               Divider(height: hv*4,),

              Container(
                margin:  EdgeInsets.symmetric(horizontal: wv * 3),
                height: hv*10,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("listez vos produits ", style:  TextStyle(fontSize: 18, color: kTextBlue),), SizedBox(width: wv*3,),
                      Expanded(
                        child: Stack(
                          children: [
                            SimpleAutoCompleteTextField(
                              key: autoCompleteKey, 
                              suggestions: suggestions,
                              controller: _ProduitOuServicesController,
                              decoration: defaultInputDecoration(),
                              textChanged: (text) => currentAllergyText = text,
                              clearOnSubmit: false,
                              submitOnSuggestionTap: false,
                              textSubmitted: (text) {
                                if (text != "") {
                                  !description!.contains(_ProduitOuServicesController!.text) ? description!.add(_ProduitOuServicesController!.text) : print("yo"); 
                                }
                                
                              }
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                onPressed: (){
                                  if (_ProduitOuServicesController!.text.isNotEmpty) {
                                  setState(() {
                                    !description!.contains(_ProduitOuServicesController!.text) ? description!.add(_ProduitOuServicesController!.text) : print("yo");
                                    _ProduitOuServicesController!.clear();
                                  });
                                }
                                },
                                icon: const CircleAvatar(child: Icon(Icons.add, color: whiteColor), backgroundColor: kSouthSeas,),),
                            )
                          ],
                        ),
                      )
                    ],),
              ),
            
                  SizedBox(height: hv*1),

                  Container(
                     margin:  EdgeInsets.symmetric(horizontal: wv * 3),
                    child: SimpleTags(
                      content: description!,
                      wrapSpacing: 4,
                      wrapRunSpacing: 4,
                      onTagPress: (tag) {
                        setState(() {
                          description!.remove(tag);
                        });
                      },
                      tagContainerPadding: const  EdgeInsets.all(6),
                      tagTextStyle: const TextStyle(color: kPrimaryColor),
                      tagIcon: const  Icon(Icons.clear, size: 15, color: kPrimaryColor,),
                      tagContainerDecoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
            ]
            ),
          ),

          CustomTextButton(
            enable:  _MontantController!.text.isNotEmpty &&
           _descriptionController!.text.isNotEmpty && 
           description!.isNotEmpty && type!.isNotEmpty ? true : false,
            text: S.of(context).suivant, 
            action: (){
                if (kDebugMode) {
                  print("jfdklfjdsklf");
                }
                controller!.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
             
            })
          
        ]
      ),
      );
    }
 
  Widget userCard(BeneficiaryModel adherentBeneficiaryInfos){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: wv*2),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: hv*2.5,),
                  adherentBeneficiaryInfos!=null? HomePageComponents().getAdherentsListForPrestataire(adherent: adherentBeneficiaryInfos, doctorName: famillyDoctorNAme!) : const SizedBox.shrink()
                ])
              )
            ),
          
          buttonLoading!? Center(child: Loaders().buttonLoader(kPrimaryColor)):
           CustomTextButton(
              text: "Sauvegarder", 
             action: (){
                 setState(() {
                buttonLoading = true;
              });
                UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
               FirebaseFirestore.instance.collection("DEVIS")
                .doc(userProvider.getUserId).set({
                  "PrestataireId": userProvider.getUserId,
                  "intitule":  _LibelleController!.text,
                  "description":  _descriptionController!.text,
                  "userId": adherentBeneficiaryInfos.adherentId,
                  "montant":  _MontantController!.text,
                  "paid": false,
                  "status": 0,
                  "type": type,
                  "createdDate": DateTime.now(),
                }, SetOptions(merge: true)).then((value){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('le dévis a bien été créer '),));
                  setState(() {
                    buttonLoading = false;
                  });
                  Navigator.pop(context);
                });
                controller!.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
              }) 
          ]
        )
      );
  }

  getFamillyDoctorName(id)  {
    var newUseCase = FirebaseFirestore.instance.collection('MEDECINS').doc(id);
    newUseCase.get().then((value){
      if(value.exists){
        setState(() {
          famillyDoctorNAme=value.data()!['cniName'] ?? '';
        });
        
      }
    });
     
   print(famillyDoctorNAme);
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

 
   Widget formLayout(Widget content, bool isPadding){
    return Container(
      padding: isPadding? EdgeInsets.symmetric(horizontal: wv*2): EdgeInsets.zero,
      margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: (Colors.grey[300])!, blurRadius: 3.0, spreadRadius: 1.0)]
      ),
      child: content,
    );
  }
}