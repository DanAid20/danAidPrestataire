import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/SizeConfig.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/file_upload_card.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
class CreateQuote extends StatefulWidget {
  CreateQuote({Key key}) : super(key: key);

  @override
  _CreateQuoteState createState() => _CreateQuoteState();
}

class _CreateQuoteState extends State<CreateQuote> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _codeConsultationController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  List<File> images=[];
  List<String> ImgUrl=[];
  bool imageSpinner, isUploadingImg=false;
  bool ordonancesUPloaded=false;
  bool ordonancesLoader = false;
  ServiceProviderModel  prestataireInfos;
  bool isAllOk=false;
  bool buttonLoading = false;
  String devisId;
  String categoriesType=consultation;
  String appontementId, userId, adherentId, beneficiaryId;
  int numberOfImagesuploaded=0;
   num danAidCov = 0;
  bool doc1Spinner = false;
  bool doc1Uploaded = false;
  bool doc2Spinner = false;
  bool doc2Uploaded = false;
  bool doc3Spinner = false;
  bool doc3Uploaded = false;

  bool confirmEnable = false;
  bool confirmSpinner = false;

  int docs1Uploaded = 0;
  int docs2Uploaded = 0;
  int docs3Uploaded = 0;

  List docs1List = [];
  List docs2List = [];
  List docs3List = [];
  @override
    void initState() {
      initTextfields();
      super.initState();
  }
  initTextfields(){
     devisId = getDevisId(7); 
   
  }
  setImageList(List<File> files){
    setState(() {
          images=files;
        });
  }
  String getDevisId(int length) {
    const _chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random _rnd = Random();
    var result = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return 'Devis N.' + result;
  }



  @override
  Widget build(BuildContext context) {
    MySize().init(context);
     ServiceProviderModelProvider prestataire = Provider.of<ServiceProviderModelProvider>(context);
    var prestatiaireObject= prestataire.getServiceProvider;
    String doc1 = categoriesType == consultation ? S.of(context).carnet : "Devis";
    String doc2 = "Recu";
    String doc3 = categoriesType == consultation ? "Autre" : categoriesType == labo ? "Resultat" : "Medicamment";

    setState(() {
          prestataireInfos=prestatiaireObject;
        });
    return WillPopScope(
      onWillPop:()async{
          Navigator.pop(context);
          return false;
      },
      child: Scaffold(
      key: _scaffoldKey,  
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
          backgroundColor:  kDeepYellow,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: kDateTextColor,
              ),
              onPressed: () => Navigator.pop(context)),
          title: Align(
            alignment: Alignment.center,
            child: Container(
              child: Column(
                children: [
                  Text(S.of(context).emettreUnDvis, style: TextStyle(color: kDateTextColor, fontSize: wv*4, fontWeight: FontWeight.w400), ),
                  Text(
                      '${DateFormat('dd MMMM yyyy à h:mm').format(DateTime.now())}', style: TextStyle(color: kDateTextColor, fontSize: wv*4, fontWeight: FontWeight.w400), )
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
      body: SafeArea(child: Container(
        child: Column(
          children: [
            Container(
              height: MySize.getScaledSizeHeight(90),
              width: double.infinity,
              padding: EdgeInsets.only(bottom: hv*1, left: wv*2),
              decoration: BoxDecoration( color: kDeepYellow),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Container(
                      margin: EdgeInsets.only(left: wv*1),
                      child: Text(S.of(context).codeDeConsultation, style: TextStyle( color: kSimpleForce, fontSize: wv*4.8, fontWeight: FontWeight.w500),)),
                    SizedBox(height: hv*0.3,),
                    Container(
                       width: MySize.getScaledSizeWidth(153),
                       height: MySize.getScaledSizeHeight(40),
                       child: TextFormField(
                         controller: _codeConsultationController,
                         keyboardType: TextInputType.text,
                         style: TextStyle(fontSize: 25, color: kBlueForce, fontWeight: FontWeight.w400),
                         decoration: InputDecoration(
                             fillColor: bgInputGray.withOpacity(0.6), 
                             hintText: ' Ex: AX11DEF',
                               enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.transparent),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                             hintStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w400),
                             focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.transparent),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                            contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                         ),
                       ),
                     ),
                ],
              )),
           
            Container(child: Row(
                 children: [
                 SizedBox(width: wv*3, height:hv*3),
                 Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child:Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    SizedBox(height: hv*1,),
                                    Container(
                                      margin: EdgeInsets.only(left: wv*1),
                                      child: Text(S.of(context).montantTotal, style: TextStyle(color: kSimpleForce, fontSize: 18, fontWeight: FontWeight.w500),)),
                                    SizedBox(height: hv*1,),
                                    Container(
                                      width: double.infinity,
                                      height: MySize.getScaledSizeHeight(42),
                                      child: TextFormField(
                                        controller:_montantController,
                                        inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                                          ],
                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 20, color: kBlueForce, fontWeight: FontWeight.w400),
                                        decoration: InputDecoration(
                                            fillColor: bgInputGray.withOpacity(0.6),
                                            hintText: ' Ex: 12000',
                                              enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.transparent),
                                              borderRadius: BorderRadius.all(Radius.circular(20))),
                                            hintStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w400),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.transparent),
                                              borderRadius: BorderRadius.all(Radius.circular(20))),
                                            contentPadding: EdgeInsets.only(right: wv*10),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                                ),
                              ],
                            ), 
                          )
                 ])
            ),
            Container(child: Row(
                 children: [
                 SizedBox(width: wv*3,),
                 Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5,),
                                 Container(
                                      margin: EdgeInsets.only(left: wv*1),
                                      child: Text("Type de devis", style: TextStyle(color: kBlueForce, fontSize: 18, fontWeight: FontWeight.w400),)),
                                    SizedBox(height: hv*1,),
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
                                        value: categoriesType,
                                        hint: Text("type de devis", style: TextStyle(color: kBlueForce, fontSize: 12, fontWeight: FontWeight.w400)),
                                        items: arrayOfServicesType.map((region){
                                          return DropdownMenuItem(
                                            child: SizedBox(child: Text(region["value"], style: TextStyle(color: kBlueForce, fontSize: 18, fontWeight: FontWeight.w400)), width: wv*50,),
                                            value: region["key"],
                                          );
                                        }).toList(),
                                        onChanged: (value) async {
                                          //List<String> reg = getTownNamesFromRegion(cities, value);
                                          setState(() {
                                           categoriesType=value;
                                          });
                                        }),
                                    ),
                                  ),
                                ),
                              ],
                            ), 
                          )
                 ])
            ),
            Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: hv*2.5),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.grey[700].withOpacity(0.4), blurRadius: 3, spreadRadius: 1.5, offset: Offset(0,4))]
                    ),
                    child:Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),
                          child: Column(
                            children: [
                              SizedBox(height: hv*2,),
                              Text(S.of(context).scannerDesJustificatifs, style: TextStyle(color: kBlueDeep, fontSize: 18, fontWeight: FontWeight.bold),),
                              SizedBox(height: hv*0.5,),
                              Text(S.of(context).unDevisUneOrdonnanceOuToutAutrePiceEnAppui, style: TextStyle(color: kBlueDeep, fontSize: 12, fontWeight: FontWeight.w400)),
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
                                title: doc1+" ($docs1Uploaded)",
                                state: doc1Uploaded,
                                isMultiple: true,
                                loading: doc1Spinner,
                                action: () async {await getDocFromGallery(doc1);}
                              ),
                              SizedBox(height: 5,),
                              FileUploadCard(
                                title: doc2+" ($docs2Uploaded)",
                                state: doc2Uploaded,
                                isMultiple: true,
                                loading: doc2Spinner,
                                action: () async {await getDocFromGallery(doc2);}
                              ),
                              SizedBox(height: 5,),
                              FileUploadCard(
                                title: doc3+" ($docs3Uploaded)",
                                state: doc3Uploaded,
                                isMultiple: true,
                                loading: doc3Spinner,
                                action: () async {await getDocFromGallery(doc3);}
                              ),

                              SizedBox(height: hv*2,),
                            CustomTextButton(
                                text: "créer",
                                enable: true,
                                isLoading: confirmSpinner,
                                noPadding: true,
                                action: () async {
                                  setState((){confirmSpinner = true;});
                                  print("aaa");
                                  var data= [
                                                  {
                                                      "NomMedicaments": "1 AMOCLAN 8:1 500mg/62,5 Comp. B/10 1.000 f",
                                                      "NonScientifique": "DCI (AMOXICILLINE/ACIDE CLAVULANIQUE)",
                                                      "Prix": 10000,
                                                      "PrixCOuvert": 7000,
                                                  },
                                                  {
                                                      "NomMedicaments": "1 AMOCLAN  500mg/62,5 Comp. B/10 1.000 f",
                                                      "NonScientifique": "DCI (AMOXICILLINE/ CLAVULANIQUE)",
                                                      "Prix": 10000,
                                                      "PrixCOuvert": 7000,
                                                  },
                                                  {
                                                      "NomMedicaments": "1 AMOCLAN 8:1  Comp. B/10 1.000 f",
                                                      "NonScientifique": " (AMOXICILLINE/ACIDE CLAVULANIQUE)",
                                                      "Prix": 10000,
                                                      "PrixCOuvert": 7000,
                                                  },
                                              ];
                                   await checkIfDocExists( _codeConsultationController.text.toString()).then((value){
                                    if(value!=null){ 
                                    if(categoriesType == pharmacy || categoriesType == labo){
                                     FirebaseFirestore.instance.collection('USECASES').doc(value["id"]).collection('PRESTATIONS').add({
                                        "usecaseId": value["id"],
                                        "adherentId": adherentId,
                                        "beneficiaryId": beneficiaryId,
                                        "isConfirmDrugList": false,
                                        "status": 2,
                                        "paid": false,
                                        "PaiementCode":null,
                                        "drugsList" : FieldValue.arrayUnion(data),
                                        "appointementId": value["idAppointement"],
                                        "title": Algorithms.getUseCaseServiceName(type: categoriesType),
                                        "titleDuDEvis":devisId,
                                        "consultationCode": _codeConsultationController.text.toString(),
                                        "amountToPay":num.parse(_montantController.text.toString()),
                                        "establishment": prestataireInfos.name,
                                        "prestataireId":prestataireInfos.id,
                                        "adminFeedback": null,
                                        "justifiedFees": null,
                                        "type": categoriesType,
                                        "createdDate": DateTime.now(),
                                        "serviceDate": null,
                                        "precriptionUrls": FieldValue.arrayUnion(docs1List),
                                        "receiptUrls": FieldValue.arrayUnion(docs2List),
                                        "drugsUrls": categoriesType == pharmacy ? FieldValue.arrayUnion(docs3List) : [],
                                        "resultsUrls": categoriesType == labo ? FieldValue.arrayUnion(docs3List) : [],
                                        'closed': true,
                                        "precriptionIsValid": null,
                                        "receiptIsValid": null,
                                        "drugsIsValid": null,
                                        "resultsIsValid": null,
                                        "precriptionUploadDate": docs1List.length > 0 ? DateTime.now() : null,
                                        "receiptUploadDate": docs2List.length > 0 ? DateTime.now() : null,
                                        "drugsUploadDate": docs3List.length > 0 && categoriesType == pharmacy ? DateTime.now() : null,
                                        "resultsUploadDate": docs3List.length > 0 && categoriesType == labo ? DateTime.now() : null,
                                        "executed": docs2List.length > 0 ? true : false,
                                        "estimated": docs1List.length > 0 ? true : false
                                      }).then((doc) {
                                        
                                        setState((){confirmSpinner = false;});
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nouvelle prestation ajoutée'),));
                                        Navigator.pop(context);
                                      }).onError((error, stackTrace) {
                                        setState((){confirmSpinner = false;});
                                      });
                                  }
                                  if(categoriesType == hospitalization || categoriesType == ambulance){
                                  
                                      FirebaseFirestore.instance.collection('USECASES').doc(value["id"]).collection('PRESTATIONS').add({
                                        "usecaseId": value["id"],
                                        "adherentId": adherentId,
                                        "beneficiaryId": beneficiaryId,
                                        "advance": 0,
                                        "status": 2,
                                        "paid": false,
                                        "isConfirmDrugList": false,
                                        "appointementId": value["idAppointement"],
                                        "title": Algorithms.getUseCaseServiceName(type: categoriesType),
                                        "drugsList" : FieldValue.arrayUnion(data),
                                        "titleDuDEvis":devisId,
                                        "consultationCode": _codeConsultationController.text.toString(),
                                        "amountToPay":num.parse(_montantController.text.toString()),
                                        "establishment": prestataireInfos.name,
                                        "adminFeedback": null,
                                        "justifiedFees": 0,
                                        "type": categoriesType,
                                        "createdDate": DateTime.now(),
                                        "serviceDate": null,
                                        "precriptionUrls": FieldValue.arrayUnion(docs1List),
                                        "receiptUrls": FieldValue.arrayUnion(docs2List),
                                        "drugsUrls": categoriesType == pharmacy || categoriesType == hospitalization || categoriesType == ambulance ? FieldValue.arrayUnion(docs3List) : [],
                                        "resultsUrls": categoriesType == labo ? FieldValue.arrayUnion(docs3List) : [],
                                        'closed': true,
                                        "precriptionIsValid": null,
                                        "receiptIsValid": null,
                                        "drugsIsValid": null,
                                        "resultsIsValid": null,
                                        "precriptionUploadDate": docs1List.length > 0 ? DateTime.now() : null,
                                        "receiptUploadDate": docs2List.length > 0 ? DateTime.now() : null,
                                        "drugsUploadDate": docs3List.length > 0 && (categoriesType == pharmacy || categoriesType == hospitalization || categoriesType == ambulance) ? DateTime.now() : null,
                                        "resultsUploadDate": docs3List.length > 0 && categoriesType == labo ? DateTime.now() : null,
                                        "executed": docs2List.length > 0 ? true : false,
                                        "estimated": docs1List.length > 0 ? true : false,
                                        "ongoing": true,
                                        "requested": docs1List.length > 0 ? true : false,
                                      }).then((doc) {
                                        setState((){confirmSpinner = false;});
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nouvelle prestation ajoutée'),));
                                        Navigator.pop(context);
                                      }).onError((error, stackTrace) {
                                        setState((){confirmSpinner = false;});
                                      });
                                    } 
                                  
                                  }else if(categoriesType==null){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("choisissez le type de devis")));
                                     setState((){confirmSpinner = false;});
                                  }else if(value==null){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).codeDeConsultationInvalide),));
                                     setState((){confirmSpinner = false;});
                                  }
                                });
                                 
                                },
                              )
                          ]))
                      ],
            )),
          ],
        ),
      )))
    );
  }
 
 Future<dynamic> checkIfDocExists(String code) async {
     var result=null;
     await FirebaseFirestore.instance
          .collection('USECASES')
          .where('consultationCode', isEqualTo: code)
          .get()
          .then((value) {
          print(code);
        if (value.docs.isNotEmpty) {
           result= value.docs[0].data();
          setState(() { 
            appontementId= value.docs[0].data()['idAppointement'];
            if(value.docs[0].data()['adherentId']==value.docs[0].data()['beneficiaryId']){
               userId=value.docs[0].data()['adherentId'];
            }else{
               userId=value.docs[0].data()['beneficiaryId'];
            }
            adherentId= value.docs[0].data()['adherentId'];
            beneficiaryId= value.docs[0].data()['beneficiaryId'];
           });
        } else {
           result= null;
        }
      }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("une erreur s'est produite "),));
      });
    
    return result;
 }


File changeFileNameOnlySync(File file, String newFileName) {
  var path = file.path;
  var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
  var newPath = path.substring(0, lastSeparator + 1) + newFileName;
  return file.renameSync(newPath);
}
  Future getImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        imageSpinner = true;
        images.add(File(pickedFile.path));
        //imageLoading = true;
      } else {
        print('No image selected.');
      }
    });
   // uploadImageToFirebase(pickedFile);
  }

  Future getImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        imageSpinner = true;
         images.add(File(pickedFile.path));
        //imageLoading = true;
      } else {
        print('No image selected.');
      }
    });
    //uploadImageToFirebase(pickedFile);
  }

  Future getDocFromPhone(String name) async {

    setState(() {
       if (name == "Ordonances"){
        ordonancesUPloaded = true;
      }
    });
    
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc'],);
    if(result != null) {
      File file = File(result.files.single.path);
      uploadDocumentToFirebase(file, name);
    } else {
      setState(() {
        if (name == "CNI"){
          ordonancesLoader = false;
        }
      });
    }
  }

Future uploadDocumentToFirebase(File file, String name) async {
   
    String doc1 =categoriesType == consultation ? S.of(context).carnet : "Devis";
    String doc2 = "Recu";
    String doc3 =categoriesType == consultation ? "Autre" :categoriesType == labo ? "Resultat" : "Medicamment";
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(S.of(context).aucuneImageSelectionne),));
      return null;
    }
    Reference storageReference = FirebaseStorage.instance.ref()
      .child('devis/PRESTATAIRES/${prestataireInfos.id}/$userId/Devis-${DateTime.now().millisecondsSinceEpoch.toString()}');//.child('photos/profils_adherents/$fileName');
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name "+S.of(context).ajoute)));
      String url = await storageReference.getDownloadURL();
      if (name == doc1){
        setState(() {
          docs1Uploaded = docs1Uploaded + 1;
          docs1List.add(url);
          doc1Uploaded = true;
          doc1Spinner = false;
        });
      } else if(name == doc2){
        setState(() {
          docs2Uploaded = docs2Uploaded + 1;
          docs2List.add(url);
          doc2Uploaded = true;
          doc2Spinner = false;
        });

      } else if(name == doc3) {
        setState(() {
          docs3Uploaded = docs3Uploaded + 1;
          docs3List.add(url);
          doc3Uploaded = true;
          doc3Spinner = false;
        });

      }
      
      print("download url: $url");
    }).catchError((e){
      print(e.toString());
  });
}
  Future getDocFromGallery(String name) async {

    String doc1 = categoriesType == consultation ? S.of(context).carnet : "Devis";
    String doc2 = "Recu";
    String doc3 = categoriesType == consultation ? "Autre" : categoriesType == labo ? "Resultat" : "Medicamment";

    setState(() {
      if (name == doc1){
        doc1Spinner = true;
      } else if(name == doc2){
        doc2Spinner = true;
      } else if(name == doc3) {
        doc3Spinner = true;
      }
    });
    
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc'],);
    if(result != null) {
      File file = File(result.files.single.path);
      uploadDocumentToFirebase(file, name);
    } else {
      setState(() {
        if (name == doc1){
          doc1Spinner = false;
        } else if(name == doc2){
          doc2Spinner = false;
        } else if(name == doc3) {
          doc3Spinner = false;
        }
      });
    }
  }
  getDocument(BuildContext context){

    String doc1 =categoriesType == consultation ? S.of(context).carnet : "Devis";
    String doc2 = "Recu";
    String doc3 =categoriesType == consultation ? "Autre" : categoriesType== labo ? "Resultat" : "Medicamment";

    showModalBottomSheet(
      context: context, 
      builder: (BuildContext bc){
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(LineIcons.certificate),
                    title: new Text(doc1+" ($docs1Uploaded)", style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600),),
                    onTap: () {
                      getDocFromPhone(doc1);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(LineIcons.certificate),
                  title: new Text(doc2+" ($docs2Uploaded)", style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                  onTap: () {
                    getDocFromPhone(doc2);
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(LineIcons.certificate),
                  title: new Text(doc3+" ($docs3Uploaded)", style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                  onTap: () {
                    getDocFromPhone(doc3);
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