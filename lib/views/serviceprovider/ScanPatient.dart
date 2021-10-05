
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/models/devisModel.dart';
import 'package:danaid/core/providers/ServicesProviderInvoice.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/serviceprovider/Ordonance.dart';
import 'package:danaid/views/serviceprovider/OrdonancePatient.dart';
import 'package:danaid/views/serviceprovider/PrestationsEnCours.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
class ScanPatient extends StatefulWidget {
  ScanPatient({Key key}) : super(key: key);

  @override
  _ScanPatientState createState() => _ScanPatientState();
}

class _ScanPatientState extends State<ScanPatient> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    AdherentModel adherentInfos;
   PhoneNumber number = PhoneNumber(isoCode: 'CM');
    final TextEditingController _phoneNumber = TextEditingController();
    String phone, textForQrCode;
    bool isUserExists=false, confirmSpinner = false;
   BeneficiaryModel adherentBeneficiaryInfos;
  DevisModel devis;
  @override
  Widget build(BuildContext context) {
      ServicesProviderInvoice devisProvider = Provider.of<ServicesProviderInvoice>(context,listen: false);
  ServiceProviderModelProvider prestataire = Provider.of<ServiceProviderModelProvider>(context);
    var prestatiaireObject= prestataire.getServiceProvider;

    return WillPopScope(
      onWillPop: () async {
          Navigator.pop(context);
      
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kGoldlightYellow,
        appBar: 
        AppBar(
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
                  Text(S.of(context).crerUnDevis),
                  Text(
                      '${DateFormat('dd MMMM yyyy à h:mm').format(DateTime.now())}')
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
        body: Container(
           margin: EdgeInsets.only(top: hv*10, left: wv*10, right: wv*10),
          child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
          Expanded(
          child: ListView(children: [
           Container(
              width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: kGoldlightYellow.withOpacity(0.6), blurRadius: 1.0, spreadRadius:1)],
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: wv * 68,
                    height: hv*6,
                    decoration: BoxDecoration(
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
                          S.of(context).scannerLaCarteDuPatient,
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
                                    _scan(context, prestatiaireObject.id);
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
                                      S.of(context).ouInscrireLeCodeDePaiement,
                                      style: TextStyle(
                                          fontSize: wv * 4,
                                          color: kBlueForce),
                                    ),
                                  ),
                                  SizedBox(
                                    height: hv * 3,
                                  ),
                                  Container(
                                    height: hv*4,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                       boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 1.0, spreadRadius: 0.3)],
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: 
                                   TextFormField (
                                       
                                      controller:_phoneNumber,
                                      keyboardType: TextInputType.phone,
                                      style: TextStyle(fontSize: 25, color: kBlueForce, fontWeight: FontWeight.w400),
                                      decoration: InputDecoration(
                                          prefixIcon: SvgPicture.asset(
                                          'assets/icons/Bulk/searchFill.svg',
                                          color: kSouthSeas,
                                          height: hv * 1.5,
                                          width: wv * 2,
                                        ),
                                          fillColor: bgInputGray.withOpacity(0.6),
                                          hintText: 'ex: 213345868',
                                            enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: Colors.transparent),
                                            borderRadius: BorderRadius.all(Radius.circular(20))),
                                          hintStyle: TextStyle(color: kBlueForce, fontWeight: FontWeight.w400),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: Colors.transparent),
                                            borderRadius: BorderRadius.all(Radius.circular(20))),
                                          contentPadding: EdgeInsets.only(right: wv*10),
                                      ),
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
              height: hv * 5,
            ),
              CustomTextButton(
                expand: false,
                          noPadding: true,
        enable: adherentBeneficiaryInfos!=null || _phoneNumber.text!=null? true: false ,
        text: S.of(context).envoyer, 
        action: () async {
          if(_phoneNumber.text!=null){
            await checkIfDocExists( _phoneNumber.text.toString()).then((value){
               if(value==true){
                 Navigator.push(context,MaterialPageRoute(builder: (context) =>Ordonances(devis: devisProvider.getInvoice)));
               }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Code de paiements invalide"),));
               }
            });
          }else{
            Navigator.push(context,MaterialPageRoute(builder: (context) =>PrestationEnCours(
                  data: adherentBeneficiaryInfos ,
                  userId: adherentInfos.adherentId,
                )));
          }
        }),
          ]
          )
      ),
      ]),
        )));

  }
 Future<bool> checkIfDocExists(String code) async {
       ServicesProviderInvoice devisProvider = Provider.of<ServicesProviderInvoice>(context,listen: false);

     bool result;
     await FirebaseFirestore.instance
          .collection('DEVIS')
          .where('PaiementCode', isEqualTo: code)
          .get()
          .then((value) {
        
        if (value.docs.isNotEmpty) {
           result= true;
           setState(() { 
            devis=DevisModel.fromDocument(value.docs[0]);
            print(devis.toString());
            devisProvider.setInvoiceModel(devis);
          });
        } else {
           result= false;
        }
      }).onError((error, stackTrace) {
        print(error);
        print(stackTrace);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).uneErreurSestProduite),));
      });
    
    return result;
 }
 bool validateMobile(String value) {
    String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
 Future _scan(BuildContext context, String prestataire) async {
   
        await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
      setState(() {
        textForQrCode = barcode == null ? 'Qr code invaldie' : barcode;
      });
       ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.of(context).qrCodeInvaldie)));

    } else {
      setState(() {
        textForQrCode = barcode;
      });
      
      if (validateMobile(textForQrCode) == true) {
        print(textForQrCode);
        setState(() {
          confirmSpinner = true;
        });
        await FirebaseFirestore.instance
            .collection('DEVIS')
            // .doc('${barcode}')
            .where('adherentId', isEqualTo: barcode)
            .where('prestataireId', isEqualTo: prestataire)
            .get()
            .then((doc) {
            setState(() {
              confirmSpinner = false;
            });
            if (doc.docs.isNotEmpty) {
                Navigator.push(context,MaterialPageRoute(builder: (context) =>PrestationEnCours(userId: barcode, isbeneficiare: false ,))                                       );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).cetUtilisateurNexistePas)));
            }
          
        });
      } else {
         setState(() {
          confirmSpinner = true;
        });
        await FirebaseFirestore.instance
            .collection('DEVIS')
            // .doc('${barcode}')
            .where('beneficiaryId', isEqualTo: barcode)
            .where('prestataireId', isEqualTo: prestataire)
            .get()
            .then((doc) {
            setState(() {
              confirmSpinner = false;
            });
            if (doc.docs.isNotEmpty) {
                Navigator.push(context,MaterialPageRoute(builder: (context) =>PrestationEnCours(userId: barcode, isbeneficiare: true,))                                       );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.of(context).cetUtilisateurNexistePas)));

            }
          
        }).onError((error, stackTrace){
          print(error);
          print(stackTrace);
           ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.of(context).uneErreurEstSurvenue)));

        });
      }
      setState(() {
        confirmSpinner = false;
      });
    }
  }
}