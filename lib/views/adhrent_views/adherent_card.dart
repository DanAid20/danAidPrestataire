import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/danAid_default_header.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class AdherentCard extends StatefulWidget {
  @override
  _AdherentCardState createState() => _AdherentCardState();
}

class _AdherentCardState extends State<AdherentCard> {

  CarouselController beneficiaryCarouselController = CarouselController();

  List<Widget> beneficiaries;
  Uint8List bytes = Uint8List(0);
  TextStyle textStyle = TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 15);

  Future<Uint8List> _generateQRCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    return result;
  }

  getBeneficiaries() async {
      AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
      BeneficiaryModelProvider beneficiaryProvider = Provider.of<BeneficiaryModelProvider>(context, listen: false);
      FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection("BENEFICIAIRES").get().then((snapshot) async {
        print(snapshot.docs.length.toString());
        beneficiaries = [];
        BeneficiaryModel adherentBeneficiary = BeneficiaryModel(
          avatarUrl: adherentProvider.getAdherent.imgUrl,
          surname: adherentProvider.getAdherent.surname,
          familyName: adherentProvider.getAdherent.familyName,
          matricule: adherentProvider.getAdherent.matricule,
          gender: adherentProvider.getAdherent.gender
        );
        Uint8List adherentBytes = await _generateQRCode(adherentProvider.getAdherent.surname+" "+adherentProvider.getAdherent.familyName);
        Widget adherentBeneficiaryCard = getBeneficiaryCard(adherentModel: adherentProvider.getAdherent, beneficiary: adherentBeneficiary, qr: adherentBytes);
        beneficiaries.add(adherentBeneficiaryCard);
        for (int i = 0; i < snapshot.docs.length; i++){
          DocumentSnapshot doc = snapshot.docs[i];
          BeneficiaryModel beneficiary = BeneficiaryModel.fromDocument(doc);
          Uint8List beneficiaryBytes = await _generateQRCode(beneficiary.surname+" "+beneficiary.familyName);
          Widget content = getBeneficiaryCard(
            adherentModel: adherentProvider.getAdherent,
            beneficiary: beneficiary,
            qr: beneficiaryBytes
          );
          beneficiaries.add(content);
        }
        setState(() {
          
        });
      });
  }

  @override
  void initState() {
    getBeneficiaries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: whiteColor,), 
            onPressed: ()=>Navigator.pop(context),
          ),
        title: Image.asset('assets/icons/DanaidLogo.png'),
      ),*/
      body: Column(
        children: [
          DanAidDefaultHeader(showDanAidLogo: true,),
          beneficiaries != null ? Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: hv*3),
              child: CarouselSlider(
                carouselController: beneficiaryCarouselController,
                options: CarouselOptions(
                  scrollPhysics: BouncingScrollPhysics(),
                  height: hv * 65,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: beneficiaries
              ),
            ),
          ) : Center(child: Loaders().buttonLoader(kPrimaryColor)),
        ],
      ),
    );
  }
  Widget getBeneficiaryCard({BeneficiaryModel beneficiary, AdherentModel adherentModel, Uint8List qr}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: wv*6, vertical: hv*2),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [kPrimaryColor, kPrimaryColor, kPrimaryColor, kPrimaryColor.withOpacity(0.9), kPrimaryColor.withOpacity(0.8)])
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("Valide\njusqu'au", style: textStyle,),
                  Text(" 10/2021", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: whiteColor))
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(beneficiary.gender == "H" ? 'assets/icons/Two-tone/Male.svg' : 'assets/icons/Two-tone/Female.svg', width: wv*8),
                  SvgPicture.asset('assets/icons/Bulk/Shield Done.svg', width: wv*8,)
                ],
              )
            ],
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: wv*15,
                  backgroundColor: whiteColor,
                  backgroundImage: beneficiary.avatarUrl != null ? CachedNetworkImageProvider(beneficiary.avatarUrl) : null,
                  child: beneficiary.avatarUrl == null ? Icon(LineIcons.user, color: kPrimaryColor, size: wv*18,) : Container(),
                ),
                CircleAvatar(
                  radius: wv*15,
                  backgroundColor: Colors.red.withOpacity(0.3),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.grey[700], blurRadius: 2.0, spreadRadius: 1.0, offset: Offset(0,1.5))]
                    ),
                    child: Icon(MdiIcons.exclamation, color: whiteColor,),
                  ),
                ),
                RotationTransition(
                  turns: new AlwaysStoppedAnimation(330 / 360),
                  child: new Text("Compte\nInactif", style: TextStyle(fontSize: 23, color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                )
              ],
            ),
          ),
          SizedBox(height: hv*2,),
          Expanded(
            child: SingleChildScrollView(
              child: DefaultTextStyle(
                style: textStyle,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(text: TextSpan(
                        style: textStyle,
                        children: [
                          TextSpan(text: "Nom du bénéficiaire\n"),
                          TextSpan(text: beneficiary.surname.toString() + " "+ beneficiary.familyName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: whiteColor))
                        ]
                      )),
                      SizedBox(height: hv*1.5,),
                      RichText(text: TextSpan(
                        children: [
                          TextSpan(text: "Numéro matricule\n"),
                          TextSpan(text: beneficiary.matricule, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: whiteColor))
                        ]
                      )),
                      SizedBox(height: hv*1.5,),
                      RichText(text: TextSpan(
                        children: [
                          TextSpan(text: "Médecin de Famille\n"),
                          TextSpan(text: adherentModel.familyDoctorId != null ? adherentModel.familyDoctorId : "Aucun", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: whiteColor))
                        ]
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          qr.isEmpty
            ? Center(
                child: Text('Empty code ... ',
                    style: TextStyle(color: Colors.black38)),
              )
          : Container(
            width: hv*10,
            child: Image.memory(qr)
            ),
            SizedBox(height: hv*2.5,)
        ],
      ),
    );
  }
}