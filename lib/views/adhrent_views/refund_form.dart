import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/file_upload_card.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/streams.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class RefundForm extends StatefulWidget {
  @override
  _RefundFormState createState() => _RefundFormState();
}

class _RefundFormState extends State<RefundForm> {
  final TextEditingController _consultationCodeController = TextEditingController();
  final TextEditingController _establishmentController = TextEditingController();

  bool healthBookUploaded = false;
  bool receiptUploaded = false;
  bool examResultUploaded = false;
  bool otherFileUploaded = false;
  bool healthBookSpinner = false;
  bool receiptSpinner = false;
  bool examResultSpinner = false;
  bool otherFileSpinner = false;
  String examResultUrl;
  String healthBookUrl;
  String receiptUrl;
  String otherFileUrl;

  DateTime selectedDate;
  String _circumstance;

  bool buttonLoading = false;

  @override
  Widget build(BuildContext context) {
    BeneficiaryModelProvider beneficiary = Provider.of<BeneficiaryModelProvider>(context);
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,), 
            onPressed: ()=>Navigator.pop(context)
          ),
          title: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Démande de remboursement", style: TextStyle(color: kTextBlue, fontSize: wv*4.2, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
              Text("18 janvier 2018" ,style: TextStyle(color: kTextBlue.withOpacity(0.75), fontSize: wv*3.8, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kSouthSeas,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: (){})
          ],
        ),
      body: Container(
        margin: EdgeInsets.only(top: hv*2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("   Sélectionner le patient", style: TextStyle(color: kBlueDeep, fontWeight: FontWeight.w600, fontSize: 16),),
            Container(
              padding: EdgeInsets.only(left: wv*2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: BeneficiaryStream(noLabel: true, standardUse: false,),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: wv*4),
                color: whiteColor,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: hv*3.5,),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              noPadding: true,
                              labelColor: kTextBlue,
                              controller: _consultationCodeController,
                              onChanged: (val)=>setState((){}),
                              label: "Code de consultation",
                            ),
                          ),
                          SizedBox(width: wv*2),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Date de début *", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: kTextBlue),),
                                  SizedBox(height: 5,),
                                  GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: Container(
                                      width: wv*45,
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
                          )
                        ],
                      ),
                      SizedBox(height: hv*2,),

                      Text("Circonstance", style: TextStyle(fontSize: 16, color: kTextBlue),),
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
                            child: DropdownButton(isExpanded: true, hint: Text("Choisir.."), value: _circumstance,
                              items: [
                                DropdownMenuItem(child: Text("Médecin de Famille", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)), value: "MDF",),
                                DropdownMenuItem(child: Text("Spécialiste", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),), value: "SP",),
                                DropdownMenuItem(child: Text("Urgence", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),), value: "URGENCE",),
                              ],
                              onChanged: (value) => setState(() {_circumstance = value;})
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: hv*3,),

                      CustomTextField(
                        noPadding: true,
                        labelColor: kTextBlue,
                        controller: _establishmentController,
                        onChanged: (val)=>setState((){}),
                        label: "Etablissement",
                      ),

                      SizedBox(height: hv*2),

                      beneficiary.getBeneficiary.matricule != null ? Column(
                        children: [
                          Center(child: Text("Scanner les documents justificatifs", style: TextStyle(color: kBlueDeep, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
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
                            state: healthBookUrl != null,
                            loading: healthBookSpinner,
                            action: () async {await getDocFromGallery('Carnet');}
                          ),
                          SizedBox(height: hv*1,),
                          FileUploadCard(
                            title: "Reçu de paiement *",
                            state: receiptUrl != null,
                            loading: receiptSpinner,
                            action: () async {await getDocFromGallery('Recu_De_Paiement');}
                          ),
                          SizedBox(height: hv*1,),
                          FileUploadCard(
                            title: "Résultat d'examen",
                            state: examResultUrl != null,
                            loading: examResultSpinner,
                            action: () async {await getDocFromGallery('Resultat_Examen');}
                          ),
                          SizedBox(height: hv*1,),
                          FileUploadCard(
                            title: "Autre pièce justificative",
                            state: otherFileUrl != null,
                            loading: otherFileSpinner,
                            action: () async {await getDocFromGallery('Pièce_Justificative_Supplémentaire');}
                          ),
                          SizedBox(height: hv*2,)
                        ],
                      ) : Center(child: Text("\nSelectionnez le bénéficiaire conçerné", textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),),
                    ],
                  ),
                ),
              )
            ),
            Container(
              color: whiteColor,
              child: CustomTextButton(
                text: "Envoyer",
                isLoading: buttonLoading,
                enable: _consultationCodeController.text.isNotEmpty && _establishmentController.text.isNotEmpty && _circumstance != null && receiptUrl != null && selectedDate != null && beneficiary.getBeneficiary.matricule != null,
                action: (){
                  setState(() {
                    buttonLoading = true;
                  });
                  AdherentModelProvider adherentModel = Provider.of<AdherentModelProvider>(context, listen: false);
                  FirebaseFirestore.instance.collection("REMBOURSEMENTS")
                    .doc(FirebaseAuth.instance.currentUser.uid+"-"+DateTime.now().toString())
                    .set({
                      "adherentId": adherentModel.getAdherent.getAdherentId,
                      "matricule": beneficiary.getBeneficiary.matricule,
                      "nomDFamille" : beneficiary.getBeneficiary.familyName,
                      "prenom": beneficiary.getBeneficiary.surname,
                      "phoneNumber": beneficiary.getBeneficiary.phoneList[0]["number"],
                      "urlImage": beneficiary.getBeneficiary.avatarUrl,
                      "statut": 0,
                      "codeDeConsultation": _consultationCodeController.text,
                      "etablissement": _establishmentController.text,
                      "dateDeDebut": selectedDate,
                      "circonstance": _circumstance,
                      "urlCarnet": healthBookUrl,
                      "urlRecu": receiptUrl,
                      "urlResultatExamen": examResultUrl,
                      "urlAutrePiece": otherFileUrl,
                      "createdDate": DateTime.now()
                    }, SetOptions(merge: true)).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Démande de remboursement enrégistrée'),));
                      setState(() {
                        buttonLoading = false;
                      });
                      Navigator.pop(context);
                    })
                    .catchError((e){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Une erreur est survénue: '+ e.toString()),));
                      setState(() {
                        buttonLoading = false;
                      });
                    });
                },
              ),
            )
          ],
        ),
      ),
    );
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
                    leading: new Icon(LineIcons.book),
                    title: new Text('Carnet', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600),),
                    onTap: () {
                      getDocFromPhone("Carnet");
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(LineIcons.receipt),
                  title: new Text('Reçu de paiement', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                  onTap: () {
                    getDocFromPhone("Recu_De_Paiement");
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(LineIcons.medicalNotes),
                  title: new Text('Résultat d\'examen', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
                  onTap: () {
                    getDocFromPhone("Resultat_Examen");
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(LineIcons.stickyNoteAlt),
                  title: new Text('Autre pièce justificative', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600)),
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

  Future getDocFromPhone(String name) async {

    setState(() {
      if (name == "Carnet") {
        healthBookSpinner = true;
      } else if (name == "Recu_De_Paiement"){
        receiptSpinner = true;
      } else if (name == "Resultat_Examen"){
        examResultSpinner = true;
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
          if (name == "Carnet") {
          healthBookSpinner = false;
          } else if (name == "Recu_De_Paiement"){
            receiptSpinner = false;
          } else if (name == "Resultat_Examen"){
            examResultSpinner = false;
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
    String matricule = beneficiary.getBeneficiary.matricule;
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucune image selectionnée'),));
      return null;
    }
    
    String adherentId = adherentModelProvider.getAdherent.adherentId;
    Reference storageReference = FirebaseStorage.instance.ref().child('demandes_de_remboursement/$adherentId/$matricule/$name'); //.child('photos/profils_adherents/$fileName');
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name ajoutée")));
      String url = await storageReference.getDownloadURL();
      if(name == "Carnet"){
        setState(() {
          healthBookUrl = url;
          healthBookUploaded = true;
          healthBookSpinner = false;
          });
      }
      else if(name == "Resultat_Examen"){
        setState(() {
          examResultUrl = url;
          examResultUploaded = true;
          examResultSpinner = false;
        });
      }
      else if (name == "Recu_De_Paiement"){
        setState(() {
          receiptUrl = url;
          receiptUploaded = true;
          receiptSpinner = false;
        });
      }
      else {
        setState(() {
          otherFileUrl = url;
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
      if (name == "Carnet") {
        healthBookSpinner = true;
      } else if (name == "Recu_De_Paiement"){
        receiptSpinner = true;
      } else if (name == "Resultat_Examen"){
        examResultSpinner = true;
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
        if (name == "Carnet") {
        healthBookSpinner = false;
        } else if (name == "Recu_De_Paiement"){
          receiptSpinner = false;
        } else if (name == "Resultat_Examen"){
          examResultSpinner = false;
        } else {
          otherFileSpinner = false;
        }
      });
    }
  }
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2021),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}