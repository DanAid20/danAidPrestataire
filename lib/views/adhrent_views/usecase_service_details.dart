//import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/useCaseServiceModel.dart';
import 'package:danaid/core/models/usecaseModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/usecaseModelProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/file_upload_card.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:danaid/core/providers/pharmacyServiceProvider.dart';
import 'package:danaid/core/providers/hospitalizationServiceProvider.dart';
import 'package:danaid/core/providers/ambulanceServiceProvider.dart';
import 'package:danaid/core/providers/labServiceProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class UseCaseServiceDetails extends StatefulWidget {
  final UseCaseServiceModel? service;
  final String? type;
  const UseCaseServiceDetails({ Key? key, this.service, this.type }) : super(key: key);

  @override
  _UseCaseServiceDetailsState createState() => _UseCaseServiceDetailsState();
}

class _UseCaseServiceDetailsState extends State<UseCaseServiceDetails> {
  TextEditingController _doctorNameController = new TextEditingController();
  TextEditingController _establishmentController = new TextEditingController();
  TextEditingController _consultationCodeController = new TextEditingController();
  TextEditingController _costController = new TextEditingController();

  DateTime? selectedDate;

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

  bool edit = false;

  init() async {
    UseCaseModelProvider usecaseProvider = Provider.of<UseCaseModelProvider>(context, listen: false);
    AmbulanceServiceProvider ambulanceProvider = Provider.of<AmbulanceServiceProvider>(context, listen: false);
    PharmacyServiceProvider pharmacyProvider = Provider.of<PharmacyServiceProvider>(context, listen: false);
    HospitalizationServiceProvider hostoProvider = Provider.of<HospitalizationServiceProvider>(context, listen: false);
    LabServiceProvider labProvider = Provider.of<LabServiceProvider>(context, listen: false);
    if(widget.service == null){
      edit = true;
      setState((){});
    }
    if(usecaseProvider.getUseCase?.consultationCode != null){
      _consultationCodeController.text = usecaseProvider.getUseCase!.consultationCode!;
      setState((){});
    }
    if(usecaseProvider.getUseCase?.doctorName != null){
      _doctorNameController.text = usecaseProvider.getUseCase!.doctorName!;
      setState((){});
    }
    if(widget.service?.date != null){
      selectedDate = widget.service?.date?.toDate();
      setState((){});
    }
    if(usecaseProvider.getUseCase?.establishment != null){
      _establishmentController.text = widget.service?.establishment == null ? usecaseProvider.getUseCase!.establishment! : widget.service!.establishment!;
      setState((){});
    }
    if(widget.service != null){
      _costController.text = widget.service?.amount != null ? "${widget.service!.amount}" : '0';
      setState((){});
    }
    if(widget.type == pharmacy){
      _consultationCodeController.text = usecaseProvider.getUseCase!.consultationCode!;
      setState((){});
    }
    if(widget.type == consultation){
      print('hey');
      docs1Uploaded = usecaseProvider.getUseCase?.bookletUrls != null ? usecaseProvider.getUseCase!.bookletUrls!.length : 0;
      docs2Uploaded = usecaseProvider.getUseCase?.receiptUrls != null ? usecaseProvider.getUseCase!.receiptUrls!.length : 0;
      docs3Uploaded = usecaseProvider.getUseCase?.otherDocUrls != null ? usecaseProvider.getUseCase!.otherDocUrls!.length : 0;
      setState(() {});
    } else if(widget.type == ambulance && widget.service != null) {
      docs1Uploaded = widget.service?.bookletUrls != null ? widget.service!.bookletUrls!.length : 0;
      docs2Uploaded = widget.service?.receiptUrls != null ? widget.service!.receiptUrls!.length : 0;
      docs3Uploaded = widget.service?.drugsUrls != null ? widget.service!.drugsUrls!.length : 0;
      setState(() {});
    } else if(widget.type == hospitalization && widget.service != null) {
      docs1Uploaded = widget.service?.bookletUrls != null ? widget.service!.precriptionUrls!.length : 0;
      docs2Uploaded = widget.service?.receiptUrls != null ?  widget.service!.receiptUrls!.length : 0;
      docs3Uploaded = widget.service?.drugsUrls != null ? widget.service!.drugsUrls!.length : 0;
      setState(() {});
    } else if(widget.type == pharmacy && widget.service != null) {
      docs1Uploaded = widget.service?.precriptionUrls != null ? widget.service!.precriptionUrls!.length : 0;
      docs2Uploaded = widget.service?.receiptUrls != null ? widget.service!.receiptUrls!.length : 0;
      docs3Uploaded = widget.service?.drugsUrls != null ? widget.service!.drugsUrls!.length : 0;
      setState(() {});
    } else if(widget.type == labo && widget.service != null) {
      docs1Uploaded = widget.service?.precriptionUrls != null ? widget.service!.precriptionUrls!.length : 0;
      docs2Uploaded = widget.service?.receiptUrls != null ?  widget.service!.receiptUrls!.length : 0;
      docs3Uploaded = widget.service?.resultsUrls != null ? widget.service!.resultsUrls!.length : 0;
      setState(() {});
    }
  }
  @override
  void initState() {
    init();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    UseCaseModelProvider usecaseProvider = Provider.of<UseCaseModelProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    AdherentModel? adh = adherentProvider.getAdherent;
    UseCaseModel? usecase = usecaseProvider.getUseCase;
    String title = Algorithms.getUseCaseServiceName(type: widget.type, context: context);
    String doc1 = widget.type == consultation ? S.of(context).carnet : "Devis";
    String doc2 = "Recu";
    String doc3 = widget.type == consultation ? "Autre" : widget.type == labo ? "Resultat" : "Medicamment";

    if(widget.type == consultation){
      confirmEnable = _doctorNameController.text.isNotEmpty && _establishmentController.text.isNotEmpty && _costController.text.isNotEmpty ? true : false;
    } else if(widget.type == hospitalization || widget.type == ambulance){
      confirmEnable = _establishmentController.text.isNotEmpty ? true : false;
    } else if(widget.type == labo || widget.type == pharmacy){
      confirmEnable = selectedDate != null && _establishmentController.text.isNotEmpty && _costController.text.isNotEmpty ? true : false;
    }

    num danAidCov = 0;

    if(widget.service != null){
      if(adh?.adherentPlan != 0){
        danAidCov = (widget.service!.amount! * 0.7).round();
      } else {
        danAidCov = (widget.service!.amount! * 0.05).round();
      }
    }

    bool? closed = widget.service != null ? widget.service!.closed : false;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,), 
          onPressed: ()=>Navigator.pop(context)
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Détail Consultation", style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
            Text("Ajouter, modifier ou envoyer des pièces",  style: TextStyle(color: kPrimaryColor, fontSize: wv*3.8, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: SvgPicture.asset('assets/icons/Two-tone/InfoSquare.svg', color: kSouthSeas,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: (){})
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: hv*2,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*1),
            child: Row(
              children: [
                SvgPicture.asset(Algorithms.getUseCaseServiceIcon(type: widget.type), color: kDeepTeal, width: 25,),
                SizedBox(width: wv*2.5,),
                Text(title, style: TextStyle(color: kDeepTeal, fontSize: 25, fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: hv*1, left: 3, right: 3),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.grey[700]!.withOpacity(0.4), blurRadius: 3, spreadRadius: 1.5, offset: Offset(0,4))]
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: hv*1.5),
                          decoration: BoxDecoration(
                            color: kSouthSeas.withOpacity(0.3),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: HomePageComponents.header(label: "Pour le patient", title: adh!.surname! + " " + adh.familyName!, subtitle: adh.address.toString(), avatarUrl: adh.imgUrl, titleColor: kTextBlue)),
                                  widget.service != null ? HomePageComponents.getIconBox(iconPath: 'assets/icons/Bulk/Edit.svg', color: primaryColor, size: 25, action: ()=>setState((){edit = !edit;})) : Container(),
                                  SizedBox(width: wv*4,)
                                ],
                              ),
                              SizedBox(height: hv*2),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: wv*4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    widget.type == consultation ? Expanded(
                                      child: !edit ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Médecin", style: TextStyle(color: kTextBlue, fontSize: 17, fontWeight: FontWeight.bold)),
                                          Text(usecase?.doctorName != null && usecase?.doctorName != "" ? usecase!.doctorName! : "Non spécifié", style: TextStyle(color: kTextBlue, fontSize: 17)),
                                          Text("Médecin de famille", style: TextStyle(color: kTextBlue, fontSize: 14))
                                        ],
                                      ) : CustomTextField(
                                        label: "Médecin",
                                        labelColor: kTextBlue,
                                        fillColor: whiteColor,
                                        onChanged: (val)=>setState((){}),
                                        noPadding: true,
                                        controller: _doctorNameController,
                                      ),
                                    ) : Expanded(
                                      child: !edit ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Suite à : ${usecase?.consultationCode != null ? "Rendez-vous" : "Urgence"}", style: TextStyle(color: kTextBlue, fontSize: 17, fontWeight: FontWeight.bold)),
                                          Text("Etablissement", style: TextStyle(color: kTextBlue, fontSize: 14)),
                                          Text(widget.service?.establishment != null && widget.service?.establishment != "" ? widget.service!.establishment! : "Non spécifié", style: TextStyle(color: kTextBlue, fontSize: 17)),
                                        ],
                                      ) : CustomTextField(
                                        label: "Etablissement",
                                        labelColor: kTextBlue,
                                        fillColor: whiteColor,
                                        hintText: widget.type == hospitalization || widget.type == ambulance ? 'Seul champ obligatoire..' : '',
                                        onChanged: (val)=>setState((){}),
                                        noPadding: true,
                                        controller: _establishmentController,
                                      ),
                                    ),
                                    SizedBox(width: wv*2,),
                                    widget.type == consultation ? Expanded(
                                      child: !edit ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${usecase!.dateCreated!.toDate().day}/${usecase.dateCreated!.toDate().month.toString().padLeft(2, '0')}/${usecase.dateCreated!.toDate().year}", style: TextStyle(color: kTextBlue, fontSize: 15, fontWeight: FontWeight.bold)),
                                          Text("Etablissement", style: TextStyle(color: kTextBlue, fontSize: 17, fontWeight: FontWeight.bold)),
                                          Text(usecase.establishment != null && usecase.establishment != "" ? usecase.establishment! : "Non spécifié", style: TextStyle(color: kTextBlue, fontSize: 15)),
                                        ],
                                      ) : CustomTextField(
                                        label: "Etablissement",
                                        labelColor: kTextBlue,
                                        fillColor: whiteColor,
                                        onChanged: (val)=>setState((){}),
                                        noPadding: true,
                                        controller: _establishmentController,
                                      ),
                                    ) : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${usecase!.dateCreated!.toDate().day}/${usecase.dateCreated!.toDate().month.toString().padLeft(2, '0')}/${usecase.dateCreated!.toDate().year}", style: TextStyle(color: kTextBlue, fontSize: 15, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 5,),
                                        Text("Code de consultation", style: TextStyle(color: kTextBlue, fontSize: 15)),
                                        Text(usecase.consultationCode != null ? usecase.consultationCode! : "Non spécifié", style: TextStyle(color: kTextBlue, fontSize: 15, fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                        )),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
                          child: Row(
                            children: [
                              Expanded(
                                child: widget.type != consultation ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.type == hospitalization || widget.type == ambulance ? 'Date de sortie' : 'Date*', style: TextStyle(fontSize: 16, color: kTextBlue, fontWeight: FontWeight.w400),),
                                    SizedBox(height: 5,),
                                    GestureDetector(
                                      onTap: () => _selectDate(context),
                                      child: Container(
                                        width: wv*50,
                                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: hv*1.6),
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
                                ) : CustomTextField(
                                      controller: _consultationCodeController,
                                      label: 'Code de consultation',
                                      hintText: 'Pas obligatoire',
                                      labelColor: kTextBlue,
                                      seal: !edit || usecase?.consultationCode != null,
                                      onChanged: (val)=>setState((){}),
                                      noPadding: true,
                                    ),
                              ),
                              SizedBox(width: wv*2,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.type == hospitalization || widget.type == ambulance ? 'Montant démandé' : 'Frais Payés', style: TextStyle(fontSize: 15, color: kTextBlue)),
                                    SizedBox(height: 5),
                                    TextFormField(
                                      controller: _costController,
                                      onChanged: (val)=>setState((){}),
                                      enabled: edit && widget.type != hospitalization && widget.type != ambulance,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                                      ],
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),
                                      decoration: defaultInputDecoration(suffix: "f.", hintText: widget.type == hospitalization || widget.type == ambulance ? "Non Editable.." : "")
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  widget.service != null ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*1),
                    child: Column(
                      children: [
                        SizedBox(height: hv*2,),
                        Row(
                          children: [
                            Text("Couverture DanAid", style: TextStyle(color: kCardTextColor, fontSize: 16,)),
                            Spacer(),
                            Text("Copaiement", style: TextStyle(color: kCardTextColor, fontSize: 16,))
                          ],
                        ),
                        SizedBox(height: hv*1,),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.75),
                              decoration: BoxDecoration(
                                color: kSouthSeas.withOpacity(0.45),
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text("${widget.service!.amount! - danAidCov} f.", style: TextStyle(color: kCardTextColor, fontSize: 17,))
                                ],
                              ),
                            ),
                            Container(
                              width: wv*60,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                boxShadow: [BoxShadow(color: Colors.grey[500]!.withOpacity(0.3), blurRadius: 7, spreadRadius: 1, offset: Offset(0,4))]
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.75),
                                    decoration: BoxDecoration(
                                      color: kSouthSeas.withOpacity(0.65),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
                                    ),
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Text("$danAidCov f.", style: TextStyle(color: kCardTextColor, fontSize: 17, fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Expanded(
                                            child: Text(
                                               widget.service!.status == 2 ? 'Fournir les documents et patienter' : widget.service?.status == 0 ? 'Démande rejetée': widget.service?.status == 1 ? "Payé" : "Statut inconnu",
                                               style: TextStyle(color: widget.service?.status == 0 ? Colors.red : widget.service?.status == 1 ? kDeepTeal : primaryColor),
                                               textAlign: TextAlign.right,
                                            ),
                                          ),
                                          SizedBox(width: wv*1.5,),
                                          HomePageComponents.getStatusIndicator(status: widget.service!.status, size: 12)
                                        ],),
                                        widget.service?.adminFeedback != null ? Text(widget.service!.adminFeedback!, style: TextStyle(color: kPrimaryColor, fontSize: 15),) : Container()
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ) : Container(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 3, vertical: hv*2.5),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.grey[700]!.withOpacity(0.4), blurRadius: 3, spreadRadius: 1.5, offset: Offset(0,4))]
                    ),
                    child: Column(
                      children: [
                        widget.service != null ? widget.service?.type == hospitalization || widget.service?.type == ambulance ? Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*6, vertical: hv*2.5),
                          decoration: BoxDecoration(
                            color: kSouthSeas.withOpacity(0.3),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text("Avance versée par DanAid", style: TextStyle(color: kCardTextColor, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.left,)),
                                  SizedBox(width: wv*3,),
                                  Text(widget.service!.advance.toString()+" f.", style: TextStyle(color: kCardTextColor, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.right,)
                                ],
                              ),
                              SizedBox(height: hv*1.5,),
                              Row(
                                children: [
                                  Expanded(child: Text("Frais justifiés", style: TextStyle(color: kBlueDeep, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.left,)),
                                  SizedBox(width: wv*3,),
                                  Text(widget.service!.justifiedFees.toString()+" f.", style: TextStyle(color: kBlueDeep, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.right,)
                                ],
                              ),
                              SizedBox(height: hv*1.5,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Excédent versé*", style: TextStyle(color: kCardTextColor, fontSize: 17), textAlign: TextAlign.left,),
                                      Text("*Négatif = à embourser sous forme de prêt santé", style: TextStyle(color: kCardTextColor, fontSize: 13), textAlign: TextAlign.left,),
                                      Text("Positif = DanAid complètera le paiement", style: TextStyle(color: kCardTextColor, fontSize: 13), textAlign: TextAlign.left,),
                                    ],
                                  )),
                                  SizedBox(width: wv*2,),
                                  Text("${widget.service!.advance! - widget.service!.justifiedFees!} f.", style: TextStyle(color: kCardTextColor, fontSize: 17), textAlign: TextAlign.right,)
                                ],
                              ),
                            ],
                          ),
                        ) : Container() : Container(),
                        closed != true ? Container(
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
                                text: "Valider",
                                enable: confirmEnable,
                                isLoading: confirmSpinner,
                                noPadding: true,
                                action: () async {
                                  setState((){confirmSpinner = true;});
                                  print("aaa");
                                  if(widget.type == pharmacy || widget.type == labo){
                                    if(widget.service == null){
                                      FirebaseFirestore.instance.collection('USECASES').doc(usecase!.id).collection('PRESTATIONS').add({
                                        "usecaseId": usecase.id,
                                        "adherentId": usecase.adherentId,
                                        "status": 2,
                                        "title": Algorithms.getUseCaseServiceName(type: widget.type),
                                        "amountToPay": num.parse(_costController.text),
                                        "establishment": _establishmentController.text,
                                        "adminFeedback": null,
                                        "justifiedFees": null,
                                        "type": widget.type,
                                        "createdDate": DateTime.now(),
                                        "serviceDate": selectedDate,
                                        "precriptionUrls": FieldValue.arrayUnion(docs1List),
                                        "receiptUrls": FieldValue.arrayUnion(docs2List),
                                        "drugsUrls": widget.type == pharmacy ? FieldValue.arrayUnion(docs3List) : [],
                                        "resultsUrls": widget.type == labo ? FieldValue.arrayUnion(docs3List) : [],
                                        'closed': false,
                                        "precriptionIsValid": null,
                                        "receiptIsValid": null,
                                        "drugsIsValid": null,
                                        "resultsIsValid": null,
                                        "precriptionUploadDate": docs1List.length > 0 ? DateTime.now() : null,
                                        "receiptUploadDate": docs2List.length > 0 ? DateTime.now() : null,
                                        "drugsUploadDate": docs3List.length > 0 && widget.type == pharmacy ? DateTime.now() : null,
                                        "resultsUploadDate": docs3List.length > 0 && widget.type == labo ? DateTime.now() : null,
                                        "executed": docs2List.length > 0 ? true : false,
                                        "estimated": docs1List.length > 0 ? true : false
                                      }).then((doc) {
                                        FirebaseFirestore.instance.collection('USECASES').doc(usecase.id).update({
                                          "amountToPay": FieldValue.increment(num.parse(_costController.text)),
                                        });
                                        usecaseProvider.addAmount(num.parse(_costController.text));
                                        setState((){confirmSpinner = false;});
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nouvelle prestation ajoutée'),));
                                        Navigator.pop(context);
                                      }).onError((error, stackTrace) {
                                        setState((){confirmSpinner = false;});
                                      });
                                    } else {
                                      FirebaseFirestore.instance.collection('USECASES').doc(usecase!.id).collection('PRESTATIONS').doc(widget.service!.id).update({
                                        "amountToPay": num.parse(_costController.text),
                                        "establishment": _establishmentController.text,
                                        "serviceDate": selectedDate,
                                        "precriptionUrls": FieldValue.arrayUnion(docs1List),
                                        "receiptUrls": FieldValue.arrayUnion(docs2List),
                                        "drugsUrls": widget.type == pharmacy ? FieldValue.arrayUnion(docs3List) : FieldValue.arrayUnion([]),
                                        "resultsUrls": widget.type == labo ? FieldValue.arrayUnion(docs3List) : FieldValue.arrayUnion([]),
                                        "precriptionUploadDate": docs1List.length > 0 ? DateTime.now() : widget.service!.precriptionUploadDate,
                                        "receiptUploadDate": docs2List.length > 0 ? DateTime.now() : widget.service!.receiptUploadDate,
                                        "drugsUploadDate": docs3List.length > 0 ? DateTime.now() : widget.service!.drugsUploadDate,
                                        "resultsUploadDate": docs3List.length > 0 ? DateTime.now() : widget.service!.resultsUploadDate,
                                        "executed": docs2List.length > 0 || widget.service!.receiptUrls!.length > 0 ? true : false,
                                        "estimated": docs1List.length > 0 || widget.service!.precriptionUrls!.length > 0 ? true : false
                                      }).then((doc) {
                                        widget.service?.amount != num.parse(_costController.text) ? FirebaseFirestore.instance.collection('USECASES').doc(usecase.id).update({
                                          "amountToPay": FieldValue.increment((num.parse(_costController.text) - widget.service!.amount!)),
                                        }) : print("Dont update usecase amount");
                                        usecaseProvider.modifyServiceCost(oldVal: widget.service!.amount, newVal: num.parse(_costController.text));
                                        setState((){confirmSpinner = false;});
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mise à jour des informations de la prestation éfféctuée..'),));
                                        Navigator.pop(context); 
                                      });
                                    }
                                  }
                                  if(widget.type == hospitalization || widget.type == ambulance){
                                    if(widget.service == null){
                                      FirebaseFirestore.instance.collection('USECASES').doc(usecase!.id).collection('PRESTATIONS').add({
                                        "usecaseId": usecase.id,
                                        "adherentId": usecase.adherentId,
                                        "advance": 0,
                                        "status": 2,
                                        "title": Algorithms.getUseCaseServiceName(type: widget.type),
                                        "amountToPay": 0,
                                        "establishment": _establishmentController.text,
                                        "adminFeedback": null,
                                        "justifiedFees": 0,
                                        "type": widget.type,
                                        "createdDate": DateTime.now(),
                                        "serviceDate": selectedDate,
                                        "precriptionUrls": FieldValue.arrayUnion(docs1List),
                                        "receiptUrls": FieldValue.arrayUnion(docs2List),
                                        "drugsUrls": widget.type == pharmacy || widget.type == hospitalization || widget.type == ambulance ? FieldValue.arrayUnion(docs3List) : [],
                                        "resultsUrls": widget.type == labo ? FieldValue.arrayUnion(docs3List) : [],
                                        'closed': false,
                                        "precriptionIsValid": null,
                                        "receiptIsValid": null,
                                        "drugsIsValid": null,
                                        "resultsIsValid": null,
                                        "precriptionUploadDate": docs1List.length > 0 ? DateTime.now() : null,
                                        "receiptUploadDate": docs2List.length > 0 ? DateTime.now() : null,
                                        "drugsUploadDate": docs3List.length > 0 && (widget.type == pharmacy || widget.type == hospitalization || widget.type == ambulance) ? DateTime.now() : null,
                                        "resultsUploadDate": docs3List.length > 0 && widget.type == labo ? DateTime.now() : null,
                                        "executed": docs2List.length > 0 ? true : false,
                                        "estimated": docs1List.length > 0 ? true : false,
                                        "ongoing": true,
                                        "requested": docs1List.length > 0 ? true : false,
                                      }).then((doc) {
                                        FirebaseFirestore.instance.collection('USECASES').doc(usecase.id).update({
                                          "ambulanceId": widget.type == hospitalization ? usecase.ambulanceId : doc.id,
                                          "hospitalizationId": widget.type == hospitalization ? doc.id : usecase.hospitalizationId,
                                        }).then((value){
                                          widget.type == hospitalization ? usecaseProvider.setHospitalizationId(doc.id) : usecaseProvider.setAmbulanceId(doc.id);
                                          usecaseProvider.addAmount(num.parse(_costController.text));
                                        });
                                        
                                        setState((){confirmSpinner = false;});
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nouvelle prestation ajoutée'),));
                                        Navigator.pop(context);
                                      }).onError((error, stackTrace) {
                                        setState((){confirmSpinner = false;});
                                      });
                                    } else {
                                      FirebaseFirestore.instance.collection('USECASES').doc(usecase!.id).collection('PRESTATIONS').doc(widget.service!.id).update({
                                        "establishment": _establishmentController.text,
                                        "serviceDate": selectedDate,
                                        "precriptionUrls": FieldValue.arrayUnion(docs1List),
                                        "receiptUrls": FieldValue.arrayUnion(docs2List),
                                        "drugsUrls": widget.type == pharmacy || widget.type == hospitalization || widget.type == ambulance ? FieldValue.arrayUnion(docs3List) : [],
                                        "resultsUrls": widget.type == labo ? FieldValue.arrayUnion(docs3List) : [],
                                        "precriptionUploadDate": docs1List.length > 0 ? DateTime.now() : widget.service!.precriptionUploadDate,
                                        "receiptUploadDate": docs2List.length > 0 ? DateTime.now() : widget.service!.receiptUploadDate,
                                        "drugsUploadDate": docs3List.length > 0 ? DateTime.now() : widget.service!.drugsUploadDate,
                                        "resultsUploadDate": docs3List.length > 0 ? DateTime.now() : widget.service!.resultsUploadDate,
                                        "requested": docs1List.length > 0 || widget.service!.precriptionUrls!.length > 0 ? true : false
                                      }).then((doc) {
                                        widget.service!.amount != num.parse(_costController.text) ? FirebaseFirestore.instance.collection('USECASES').doc(usecase.id).update({
                                          "amountToPay": FieldValue.increment((num.parse(_costController.text) - widget.service!.amount!)),
                                        }) : print("Dont update usecase amount");
                                        
                                        setState((){confirmSpinner = false;});
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Prestation mise à jour...'),));
                                        Navigator.pop(context);

                                      });
                                    }
                                  }
                                  else if(widget.type == consultation) {
                                    print("ffff");
                                    await FirebaseFirestore.instance.collection('USECASES').doc(usecase!.id).update({
                                      "consultationCode" : _consultationCodeController.text,
                                      "consultationCost" : num.parse(_costController.text),
                                      "consultationId": usecase.id,
                                      "consultationStatus": 2,
                                      "amountToPay": usecase.consultationCost == null ? FieldValue.increment(num.parse(_costController.text)) : usecase.amount! - usecase.consultationCost! + num.parse(_costController.text),
                                      "establishment": _establishmentController.text,
                                      "doctorName": _doctorNameController.text,
                                      "bookletUrls": FieldValue.arrayUnion(docs1List),
                                      "receiptUrls": FieldValue.arrayUnion(docs2List),
                                      "otherDocUrls": FieldValue.arrayUnion(docs3List),
                                      "bookletIsValid": null,
                                      "receiptIsValid": null,
                                      "otherDocIsValid": null,
                                      "executed" : true,
                                    }).then((value) {
                                      print("done almost");
                                      usecaseProvider.setDoctorName(_doctorNameController.text);
                                      print("d1");
                                      usecaseProvider.setConsultationCost(num.parse(_costController.text));
                                      print("2");
                                      usecaseProvider.setConsultationId(usecase.id!);
                                      print("3");
                                      usecaseProvider.setEstablishment(_establishmentController.text);
                                      print("4");
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mise à jour des informations de consultation éfféctuée'),));
                                      Navigator.pop(context);
                                      setState((){confirmSpinner = false;});
                                    }).onError((error, stackTrace){
                                      setState((){confirmSpinner = false;});
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        ) : 
                        Container(
                          padding: EdgeInsets.symmetric(vertical: hv*2),
                          child: HomePageComponents.getInfoActionCard(
                            icon: HomePageComponents.getStatusIndicator(status: 0),
                            title: "Prestation vérouillée",
                            subtitle: "Les administrateurs ont vérouillés la prestation, vous ne pourrez plus apporter de modifications",
                            noAction: true
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    
      
    );
  }
  Future getDocFromGallery(String name) async {

    String doc1 = widget.type == consultation ? S.of(context).carnet : "Devis";
    String doc2 = "Recu";
    String doc3 = widget.type == consultation ? "Autre" : widget.type == labo ? "Resultat" : "Medicamment";

    setState(() {
      if (name == doc1){
        doc1Spinner = true;
      } else if(name == doc2){
        doc2Spinner = true;
      } else if(name == doc3) {
        doc3Spinner = true;
      }
    });
    
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc'],);
    if(result != null) {
      File file = File(result.files.single.path!);
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

  Future getDocFromPhone(String name) async {

    String doc1 = widget.type == consultation ? S.of(context).carnet : "Devis";
    String doc2 = "Recu";
    String doc3 = widget.type == consultation ? "Autre" : widget.type == labo ? "Resultat" : "Medicamment";

    setState(() {
      if (name == doc1){
        doc1Spinner = true;
      } else if(name == doc2){
        doc2Spinner = true;
      } else if(name == doc3) {
        doc3Spinner = true;
      }
    });
    
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 85);
    if(pickedFile != null) {
      File file = File(pickedFile.path);
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

  Future uploadDocumentToFirebase(File file, String name) async {

    AdherentModelProvider adherentModelProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    AmbulanceServiceProvider ambulanceProvider = Provider.of<AmbulanceServiceProvider>(context, listen: false);
    PharmacyServiceProvider pharmacyProvider = Provider.of<PharmacyServiceProvider>(context, listen: false);
    HospitalizationServiceProvider hostoProvider = Provider.of<HospitalizationServiceProvider>(context, listen: false);
    LabServiceProvider labProvider = Provider.of<LabServiceProvider>(context, listen: false);
    UseCaseModelProvider usecaseProvider = Provider.of<UseCaseModelProvider>(context, listen: false);
    
    String doc1 = widget.type == consultation ? S.of(context).carnet : "Devis";
    String doc2 = "Recu";
    String doc3 = widget.type == consultation ? "Autre" : widget.type == labo ? "Resultat" : "Medicamment";
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(S.of(context).aucuneImageSelectionne),));
      return null;
    }
    
    String? adherentId = adherentModelProvider.getAdherent?.adherentId;
    Reference storageReference = FirebaseStorage.instance.ref().child('demande_de_prise_en_charge/$adherentId/$name-'+DateTime.now().millisecondsSinceEpoch.toString()); //.child('photos/profils_adherents/$fileName');
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    });
    storageUploadTask.whenComplete(() async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name "+S.of(context).ajoute)));
      String url = await storageReference.getDownloadURL();
      if (name == doc1){
        if(widget.type == consultation){
          usecaseProvider.addBookletUrl(url);
        } else if(widget.type == ambulance) {
          ambulanceProvider.addPrescriptionUrl(url);
        } else if(widget.type == hospitalization) {
          hostoProvider.addPrescriptionUrl(url);
        } else if(widget.type == pharmacy) {
          pharmacyProvider.addPrescriptionUrl(url);
        } else if(widget.type == labo) {
          labProvider.addPrescriptionUrl(url);
        }
        setState(() {
          docs1Uploaded = docs1Uploaded + 1;
          docs1List.add(url);
          doc1Uploaded = true;
          doc1Spinner = false;
        });
      } else if(name == doc2){

        if(widget.type == consultation){
          usecaseProvider.addReceiptUrl(url);
        } else if(widget.type == ambulance) {
          ambulanceProvider.addReceiptUrl(url);
        } else if(widget.type == hospitalization) {
          hostoProvider.addReceiptUrl(url);
        } else if(widget.type == pharmacy) {
          pharmacyProvider.addReceiptUrl(url);
        } else if(widget.type == labo) {
          labProvider.addReceiptUrl(url);
        }
        setState(() {
          docs2Uploaded = docs2Uploaded + 1;
          docs2List.add(url);
          doc2Uploaded = true;
          doc2Spinner = false;
        });

      } else if(name == doc3) {

        if(widget.type == consultation){
          usecaseProvider.addOtherDocUrl(url);
        } else if(widget.type == ambulance) {
          ambulanceProvider.addDrugUrl(url);
        } else if(widget.type == hospitalization) {
          hostoProvider.addDrugUrl(url);
        } else if(widget.type == pharmacy) {
          pharmacyProvider.addDrugUrl(url);
        } else if(widget.type == labo) {
          labProvider.addResultUrl(url);
        }
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

  getDocument(BuildContext context){

    String doc1 = widget.type == consultation ? S.of(context).carnet : "Devis";
    String doc2 = "Recu";
    String doc3 = widget.type == consultation ? "Autre" : widget.type == labo ? "Resultat" : "Medicamment";

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
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}