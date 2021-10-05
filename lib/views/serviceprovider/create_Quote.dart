import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
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
  String appontementId, userId, adherentId, beneficiaryId;
  int numberOfImagesuploaded=0;
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
    setState(() {
          prestataireInfos=prestatiaireObject;
        });
    return WillPopScope(
      onWillPop:()async{
         Navigator.pop(context);
      },
      child: Scaffold(
      key: _scaffoldKey,  
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
                      child: Text(S.of(context).codeDeConsultation, style: TextStyle(letterSpacing: 1, color: kSimpleForce, fontSize: wv*4.8, fontWeight: FontWeight.w500),)),
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
            Expanded(child:
             Column(
               children: [
                 Container(
                  margin: EdgeInsets.all(wv*5),
                   child:Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Container(
                      margin: EdgeInsets.only(left: wv*1),
                      child: Text(S.of(context).montantTotal, style: TextStyle(letterSpacing: 0.2, color: kSimpleForce, fontSize: wv*5.5, fontWeight: FontWeight.w500),)),
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
                         style: TextStyle(fontSize: 25, color: kBlueForce, fontWeight: FontWeight.w400),
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
                SizedBox( width: wv * 30,),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(hv*3),
                    child: Column(
                     mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center, 
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(left:hv*3),
                            width: double.infinity,
                            height: hv*45,
                            child: Column(
                              
                              crossAxisAlignment: CrossAxisAlignment.start, 
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).importerVosDevis, style: TextStyle(color: kFirstIntroColor, fontSize: fontSize(size: hv * 2)),),
                                    images.length>0?
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          images.clear();
                                        });
                                      },
                                      child: Text(S.of(context).effacer, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: fontSize(size: hv * 2)),))
                                      : SizedBox.shrink()
                                  ],
                                ),
                                 SizedBox( width: hv * 1,),
                                
                                 Container(
                                      margin: EdgeInsets.only(
                                          right: inch * 2,
                                          top: inch * 3),
                                      child: GestureDetector(
                                        onTap: () {
                                          getImage(context,images);
                                        },
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                            'assets/icons/Bulk/Scan.svg',
                                            color: kSouthSeas,
                                            height: hv * 8,
                                            width: wv * 8,
                                          ),
                                        ),
                                      ),
                                    ),
                                   SizedBox(height: hv*1.5,),
                                   Expanded(
                                     child: ListView.builder(
                                      itemCount: images.length,
                                      itemBuilder:(BuildContext ctxt, int index) {
                                        var e= images[index];
                                      return new Container(
                                      width: double.infinity,
                                      height: hv*5,
                                      // margin: EdgeInsets.only(left:wv*5, right: wv*5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                        Container(
                                        child: Text('${e.name}', style: TextStyle(color: kBlueForce, fontSize: hv*2.1),)),
                                        SizedBox(width: wv*4,),
                                        Container(
                                          child: Text('IMG', style: TextStyle(color: kDeepDarkTeal,  fontSize: hv*2.1),),
                                        )
                                      ],),
                                  );
                                      }),
                                   ),
                                  images.length>0 ? Center(
                                    child: Container(
                                      margin: EdgeInsets.only(top:inch*5),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: whiteColor.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [ BoxShadow(color: kShadowColor.withOpacity(0.2), spreadRadius: 0.9, blurRadius: 6)],
                                      ),
                                      child: Text("${images.length}"+S.of(context).imagesSlectionner, textScaleFactor: 1.0, style: TextStyle(color:kPrimaryColor, fontWeight: FontWeight.w500, fontSize: fontSize(size: 15))),
                                    ),
                                  ): SizedBox.shrink(),
                                 SizedBox(height: hv*2.5,),
                                 CustomTextButton(
                                  enable: true,
                                  text:  buttonLoading? S.of(context).envoie : isUploadingImg ? S.of(context).uploadDe+"${numberOfImagesuploaded} / ${images.length}"+S.of(context).images: S.of(context).envoyer, 
                                  action: () async =>{
                                    if( _codeConsultationController.text.isEmpty){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).entrezLeCodeDeConsultation),))
                                    }else if(_montantController.text.isEmpty){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).entrezLeMontantDuDevis),))

                                    }else if(images.isEmpty || images.length==0){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).importerLesImagesDuDevis),))
                                    }else{
                                    await checkIfDocExists( _codeConsultationController.text.toString()).then((value){
                                      if(value==true){
                                            setState((){isUploadingImg=true;});
                                            uploadFiles(images).then((url){
                                                setState((){
                                              isUploadingImg=false;
                                              buttonLoading = true;
                                            });
                                          // var data= [
                                          //         {
                                          //             "NomMedicaments": "1 AMOCLAN 8:1 500mg/62,5 Comp. B/10 1.000 f",
                                          //             "NonScientifique": "DCI (AMOXICILLINE/ACIDE CLAVULANIQUE)",
                                          //             "Prix": 10000,
                                          //             "PrixCOuvert": 7000,
                                          //         },
                                          //         {
                                          //             "NomMedicaments": "1 AMOCLAN  500mg/62,5 Comp. B/10 1.000 f",
                                          //             "NonScientifique": "DCI (AMOXICILLINE/ CLAVULANIQUE)",
                                          //             "Prix": 10000,
                                          //             "PrixCOuvert": 7000,
                                          //         },
                                          //         {
                                          //             "NomMedicaments": "1 AMOCLAN 8:1  Comp. B/10 1.000 f",
                                          //             "NonScientifique": " (AMOXICILLINE/ACIDE CLAVULANIQUE)",
                                          //             "Prix": 10000,
                                          //             "PrixCOuvert": 7000,
                                          //         },
                                          //     ];
                                         FirebaseFirestore.instance.collection("DEVIS")
                                          .doc().set({
                                            "intitule":devisId,
                                            "appointementId": appontementId,
                                            "adherentId" :adherentId,
                                            "beneficiaryId": beneficiaryId,
                                            "prestataireId":prestataireInfos.id,
                                            "consultationCode":  _codeConsultationController.text,
                                            "montant":  _montantController.text,
                                            "ispaid": false,
                                            "isAdminHasTreatedRequest": false,
                                            "urlImagesDevis": FieldValue.arrayUnion(url),
                                            "status": 0,
                                            "RequestTreatedList": FieldValue.arrayUnion(null) ,
                                            "PaiementCode":null,
                                            "type": 'DEVIS',
                                            "createdDate": DateTime.now(),
                                          }, SetOptions(merge: true)).then((value){
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('le dévis a bien été créer '),));
                                            setState(() {
                                              buttonLoading = false;
                                            });
                                            Navigator.pop(context);
                                          }).onError((error, stackTrace){
                                             print(error);
                                             print(stackTrace);
                                              setState(() {
                                              buttonLoading = false;
                                            });
                                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).uneErreurSestProduiteLorsDeLenvoie),));

                                          });
                                        });
                                      }else if(value==false){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).codeDeConsultationInvalide),));
                                      }
                                    })
                                     }
                                    
                                  },
                                 )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                )
               ],
             )
            ),
          ],
        ),
      )))
    );
  }

 Future<bool> checkIfDocExists(String code) async {
     bool result;
     await FirebaseFirestore.instance
          .collection('USECASES')
          .where('consultationCode', isEqualTo: code)
          .get()
          .then((value) {
          print(code);
        if (value.docs.isNotEmpty) {
           result= true;
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
           result= false;
        }
      }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("une erreur s'est produite "),));
      });
    
    return result;
 }
 Future<List<String>> uploadFiles(List<File> _images) async {
  var imageUrls = await Future.wait(_images.map((_image) => uploadFile(_image)));
  print(imageUrls);
  setState(() {
      numberOfImagesuploaded=0;
    });
  return imageUrls;
}

Future<String> uploadFile(File _image) async {
 Reference  storageReference = FirebaseStorage.instance
      .ref()
      .child('devis/PRESTATAIRES/${prestataireInfos.id}/$userId/Devis-${DateTime.now().millisecondsSinceEpoch.toString()}');
  UploadTask uploadTask = storageReference.putFile(_image);
  await uploadTask.whenComplete((){ setState(() {
      numberOfImagesuploaded++;
    });});
  print(numberOfImagesuploaded);
  return await storageReference.getDownloadURL();
}

  List<File> renameFile(List<File> fileList, prestatataireId,String idDuDevis) {
  int index=0;
  List<File> ingArray=[];
  fileList.forEach((f) {
    String newFileName = idDuDevis+'_'+index.toString()+'_'+DateTime.now().millisecondsSinceEpoch.toString()+path.extension(f.path);
    var img=changeFileNameOnlySync(f,newFileName);
    index++;
    print(img.name);
    ingArray.add(img);
  });
  return ingArray;
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
  Future getMultiplemage(List<File> images) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null && result.files.length<=10) {
      List<File> files = result.paths.map((path) => File(path)).toList();
      //print(files.length);
      //print(files.toString());
      List<File> fileRenamed= renameFile(files, prestataireInfos.id, devisId.replaceAll(" ", ""));
      //images.addAll(fileRenamed);
     setImageList(fileRenamed);
        
       
    } else if(result.files.length>5) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).vousNePouvezPasImporterPlusDe5Images),));
    }
     else{
       print('No image selected.');
    }
    // final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    // setState(() {
    //   if (pickedFile != null) {
    //     imageSpinner = true;
    //      images.add(File(pickedFile.path));
    //     //imageLoading = true;
    //   } else {
       
    //   }
    // });
    //uploadImageToFirebase(pickedFile);
  }


  getImage(BuildContext context, List<File> images){
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
                      getMultiplemage(images);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
        );
      }
    );
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
    // AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);

    // if (file == null) {
    //   ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(S.of(context).aucuneImageSelectionne),));
    //   return null;
    // }

    // String adherentId = adherentModelProvider.getAdherent.adherentId;
    // Reference storageReference = FirebaseStorage.instance.ref().child('Prestatires/devis/doc/$adherentId/'); //.child('photos/profils_adherents/$fileName');
    // final metadata = SettableMetadata(
    //   //contentType: 'image/jpeg',
    //   customMetadata: {'picked-file-path': file.path}
    // );

    // UploadTask storageUploadTask;
    // if (kIsWeb) {
    //   storageUploadTask = storageReference.putData(await file.readAsBytes(), metadata);
    // } else {
    //   storageUploadTask = storageReference.putFile(File(file.path), metadata);
    // }
    //  storageUploadTask.catchError((e){
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
    // });
    //storageUploadTask = storageReference.putFile(imageFileAvatar);
  }
}
extension FileExtention on FileSystemEntity {
  String get name {
    return this?.path?.split("/")?.last;
  }

  String get directoryPath {
    return this?.path?.replaceAll("/${name}", '');
  }
}