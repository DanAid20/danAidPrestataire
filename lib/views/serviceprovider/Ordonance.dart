// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/models/devisModel.dart';
import 'package:danaid/core/models/useCaseServiceModel.dart';
import 'package:danaid/core/providers/ServicesProviderInvoice.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/SizeConfig.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Ordonances extends StatefulWidget {
   UseCaseServiceModel? devis;

  Ordonances({Key? key, this.devis}) : super(key: key);
  @override
  _OrdonanceDuPatientState createState() => _OrdonanceDuPatientState();
}

class _OrdonanceDuPatientState extends State<Ordonances> {
   final GlobalKey<ScaffoldState>? _scaffoldKey = GlobalKey<ScaffoldState>();
   TextEditingController? _costController =  TextEditingController();
   final GlobalKey<ExpansionTileCardState>? cardA =  GlobalKey();
  final GlobalKey<ExpansionTileCardState>? cardB =  GlobalKey();
  final GlobalKey<ExpansionTileCardState>? cardC =  GlobalKey(); 
  final GlobalKey<ExpansionTileCardState>? cardD =  GlobalKey(); 
   bool? edit=false, buttonLoading=false;
   DateTime? selectedDate;
   Timestamp? dateNaiss;
   num? prixDAnaid, prixpatient;
   String? userId, urlImage, username;
   List<String>? urlImg;
   List? deletedData=[];
  bool? isDeleteddrugsItems= false, isuserHasAccepteddrugsItems= false;
  bool? isUpdatatingDrugs= false, isconfirmgDrugs= false;
   final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  @override
  initState()  {
        setState(() {
              _costController!.text=widget.devis!.amount.toString();
              selectedDate= DateTime.fromMicrosecondsSinceEpoch(widget.devis!.dateCreated!.microsecondsSinceEpoch);
              prixDAnaid= (widget.devis!.amount!*70/100);
              prixpatient= widget.devis!.amount!-prixDAnaid!;
            
        });
    if (kDebugMode) {
      print(prixDAnaid);
      print(prixpatient);
    }
    super.initState();
     WidgetsBinding.instance?.addPostFrameCallback((_){
   
        getPatientInformation(widget.devis!.idAppointement!);
    });
  }
 
   Future<void> getPatientInformation(String code)  async {
     if (kDebugMode) {
       print("--------------------------------");
     }
     await FirebaseFirestore.instance
          .collection('APPOINTMENTS').doc(code).get()
          .then((value) {
          if (kDebugMode) {
            print(code);
            print(value.data().toString());
          }
        if (value.data()!=null) {
          setState(() {
           userId= code;
           dateNaiss= value.data()!['birthDate'];
           urlImage= value.data()!['avatarUrl'];
           username= value.data()!['username'];
          });
        }else {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).cetUtilisateurNexistePas),));
        }
      }).onError((error, stackTrace) {
          print(error);
          print(stackTrace);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).uneErreurSestProduite),));
      });
   print("--------------------------------");
 }
 
 showAlertDialog(BuildContext context, String title,  VoidCallback function) async {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(S.of(context).cancel),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text(S.of(context).supprimer),
    onPressed:  () {
      function();
    }
    
    
    
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(S.of(context).alerte),
    content: Text(title),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
     String doc1 =widget.devis!.type == consultation ? "Carnet" : "Devis";
    String doc2 = "Recu";
    String doc3 =widget.devis!.type == consultation ? "Autre" :widget.devis!.type == labo ? "Resultat" : "Medicamment";
   
    return      WillPopScope(
      onWillPop:()async{
         Navigator.pop(context);
         return true;
      },
      child: Scaffold(
      key: _scaffoldKey,  
      appBar: AppBar(
          backgroundColor:  kGoldlightYellow,
          leading:  IconButton(
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
                  Text(S.of(context).ordonance, style: TextStyle(color: kDateTextColor, fontSize: wv*4, fontWeight: FontWeight.w500), ),
                  Text("${widget.devis!.title}", style: TextStyle(color: kDateTextColor, fontSize: wv*4, fontWeight: FontWeight.w300), ),
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
      body:  SafeArea(child:
      StreamBuilder(
      stream:   FirebaseFirestore.instance.collection('USECASES').doc(widget.devis!.usecaseId).collection('PRESTATIONS').doc(widget.devis!.id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            //child: Text("Splash Screen Temporaire !!!\n${devEnv.getEnv}", textAlign: TextAlign.center,)
              width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: hv*2,),
                SizedBox(height: hv*5,),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kTextBlue),
                ),
                Text('Chargement...', style: TextStyle(color: Colors.grey[600], fontSize: 25, fontWeight: FontWeight.bold),),
              ],
            )
          ,);
        }
        var userDocument = snapshot.data as DocumentSnapshot<Object>;
        widget.devis= UseCaseServiceModel.fromDocument(userDocument);
           return Container(
             child:  SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
             mainAxisSize: MainAxisSize.min,
            children: [
              IntrinsicHeight(
                child: Container(
            color: kGoldlightYellow,
            height: hv*44.5, 
            child: Expanded(
                child: Column(
                  children: [
                    Container(
                            margin: EdgeInsets.only(top: hv*1, left: 5, right: 5),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: (Colors.grey[700])!.withOpacity(0.4), blurRadius: 3, spreadRadius: 1.5, offset: const Offset(0,4))]
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: hv*14.1,
                                  padding: EdgeInsets.only(bottom: hv*1.2),
                                  decoration: BoxDecoration(
                                    color: kGoldlightYellow.withOpacity(0.3),
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child:
                                           HomePageComponents.header(label: S.of(context).pourLePatient, title: username ?? S.of(context).pasDefini, subtitle: "${DateTime.now().year - DateTime.fromMicrosecondsSinceEpoch(widget.devis!.dateCreated!.microsecondsSinceEpoch).year}ans", avatarUrl: urlImage! , titleColor: kTextBlue)),
                                          HomePageComponents.getIconBox(iconPath: 'assets/icons/Bulk/Edit.svg', color: kDeepTeal, size: 25, action: ()=>setState((){
                                            if (kDebugMode) {
                                              print(edit);
                                            }
                                            edit = !edit!;
                                            })),
                                          SizedBox(width: wv*4,)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(S.of(context).codeDeConsultation,
                                style: TextStyle(
                                    fontSize: fontSize(size: wv * 5),
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.2,
                                    color: kFirstIntroColor),),
                                              Text("${widget.devis!.consultationCode}",
                                style: TextStyle(
                                    fontSize: fontSize(size: wv * 3.5),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                    color: kFirstIntroColor),),
                                            ],
                                          ),
                                          SizedBox(width: wv*4,)
                                        ],
                                      ),
                                       
                                    ],
                                )),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child:  Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text( 'Date*', style:  TextStyle(fontSize: 16, color: kTextBlue, fontWeight: FontWeight.w400),),
                                            const SizedBox(height: 3,),
                                            GestureDetector(
                                              onTap: () => _selectDate(context),
                                              child: Container(
                                                width: wv*50,
                                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: hv*1.6),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius: const BorderRadius.all(Radius.circular(20))
                                                ),
                                                child: Row(children: [
                                                  SvgPicture.asset("assets/icons/Bulk/CalendarLine.svg", color: kDeepTeal,),
                                                  const VerticalDivider(),
                                                  Text( selectedDate != null ? "${selectedDate!.toLocal()}".split(' ')[0] : S.of(context).choisir, style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                                ],),
                                              ),
                                            ),
                                          ],
                                        )
                                      ),
                                      SizedBox(width: wv*2,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(S.of(context).montantPercu, style:const  TextStyle(fontSize: 15, color: kTextBlue)),
                                            const SizedBox(height: 5),
                                            TextFormField(
                                              controller: _costController,
                                              onChanged: (val)=>setState((){}),
                                              enabled: edit,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                                              ],
                                              textAlign: TextAlign.end,
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),
                                              decoration: defaultInputDecoration(suffix: "f.", hintText: S.of(context).nonEditable)
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

                    Column(
                      children: [
                        Padding(
                           padding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*1),
                           child: Column(
                             children: [
                               SizedBox(height: hv*1,),
                               Row(
                                 children: [
                                    Text(S.of(context).couvertureDanaid, style:const TextStyle(color: kCardTextColor, fontSize: 16,)),
                                   const Spacer(),
                                   Text(S.of(context).copaiement, style: const TextStyle(color: kCardTextColor, fontSize: 16,))
                                 ],
                               ),
                               SizedBox(height: hv*1,),
                               Stack(
                                 children: [
                                   Container(
                                     padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.75),
                                     decoration: BoxDecoration(
                                       color: kLightWhite.withOpacity(0.45),
                                       borderRadius: BorderRadius.circular(15)
                                     ),
                                     child: Row(
                                       children: [
                                         const Spacer(),
                                         Text("${prixpatient!.toDouble().round().toString()}.f", style: const TextStyle(color: kCardTextColor, fontSize: 17,))
                                       ],
                                     ),
                                   ),
                                   Container(
                                     width: wv*60,
                                     decoration: BoxDecoration(
                                       color: whiteColor,
                                       borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                       boxShadow: [BoxShadow(color: (Colors.grey[500])!.withOpacity(0.3), blurRadius: 7, spreadRadius: 1, offset: const Offset(0,4))]
                                     ),
                                     child: Column(
                                       children: [
                                         Container(
                                           padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.75),
                                           decoration: BoxDecoration(
                                             color: kLightWhite.withOpacity(0.65),
                                             borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
                                           ),
                                           child: Row(
                                             children: [
                                               const Spacer(),
                                               Text('$prixDAnaid.f', style: const TextStyle(color: kCardTextColor, fontSize: 17, fontWeight: FontWeight.bold))
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
                                                      widget.devis!.status==0? S.of(context).enAttente : widget.devis!.status==1? S.of(context).pay: S.of(context).tatInconue ,
                                                      style: TextStyle(color:  widget.devis!.status==0? kBlueForce: widget.devis!.status==1? kDeepTeal: kDeepDarkTeal, fontWeight: FontWeight.bold),
                                                      textAlign: TextAlign.right,
                                                   ),
                                                 ),
                                                 SizedBox(width: wv*1.5,),
                                                 HomePageComponents.getStatusIndicator(status: widget.devis!.status!.toInt(), size: 12)
                                               ],)
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
                         ),
                        
                      ],
                    ), 
                  ],
                ),
            ),
          ),
              ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
                  decoration: const BoxDecoration(
                    color: whiteColor
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(S.of(context).suivieDesPrestations, style: const TextStyle(color: kBlueDeep, fontSize: 17, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: hv*1,),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IntrinsicHeight(
                             child: Stack(
                              children: [
                                Column(
                                  children: [
                                    widget.devis!.drugsUrls!.isNotEmpty?  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Expanded(
                                        child: getDetailOrdonanceDevis(
                                          title: doc1,
                                          service: widget.devis,
                                          cardA: cardA!,
                                         )
                                        ),
                                    ): Container(),
                                    
                                    widget.devis!.receiptUrls!.isNotEmpty?  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Expanded(
                                        child: getDetailReceipt(
                                          title: doc2,
                                          service: widget.devis,
                                          cardA: cardB!,
                                         )
                                        ),
                                    ): Container(),
                                    widget.devis!.resultsUrls!.isNotEmpty?  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Expanded(
                                        child: getDetailReultExamens(
                                          title: doc3,
                                          service: widget.devis,
                                          cardA: cardC!,
                                         )
                                        ),
                                    ): Container(),
                                    widget.devis!.precriptionUrls!.isNotEmpty?  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Expanded(
                                        child: getDetailPrescription(
                                          title: doc3,
                                          service: widget.devis,
                                          cardA: cardD!,
                                         )
                                        ),
                                    ): Container(),
                                
                                  ],
                                ),
                              ],
                            ),
                          ),
                         
                        
                        ],
                      ),
                    ],
                  ),
                ),
               Padding(
                   padding: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*1),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       Container(
                         width: wv*30,
                         height: hv*0.5,
                         decoration: BoxDecoration(
                           gradient: LinearGradient(
                             begin: Alignment.bottomLeft,
                             end: Alignment.topRight,
                             colors: [
                               (Colors.grey[200])!,
                               Colors.white,
                             ],
                           )),
                         child: const SizedBox.shrink(),
                           ),
                       Container(
                         width: double.infinity,
                         height: hv*4.5,
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           mainAxisSize: MainAxisSize.max,
                           children: [
                             Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Container(
                                   width: wv*65,
                                   child: Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Text("TOTAL", style: TextStyle(
                                 fontSize: fontSize(size: wv * 5),
                                 fontWeight: FontWeight.w600,
                                 letterSpacing: 0.3,
                                 color: kBlueForce)),
                                         Text("${widget.devis!.amount!}.f",style: TextStyle(
                                 fontSize: fontSize(size: wv * 5),
                                 fontWeight: FontWeight.w400,
                                 letterSpacing: 0.2,
                                 color: kBlueForce)),
                                       ],
                                     ),
                                   ),
                                 ),
                                 
                               ],
                             ),
                           ],
                         ),
                       ),
                    
                     ],
                   ),
                 ),
                
        Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Expanded(
          child:  buttonLoading==true?  Loaders().buttonLoader(kPrimaryColor) : 
       Padding(
          padding: EdgeInsets.only(left:wv*5, right: wv*5, top:hv*3),
          child:  buttonLoading==true? Center(child: Loaders().buttonLoader(kCardTextColor)) :
            CustomTextButton(
               borderRadius:60,
               text: S.of(context).validerLaPrestation,
               color: kBlueDeep,
               noPadding: true ,
               expand: true,
               action: () =>{
                 setState(() {
                        buttonLoading = true;
                 }),
                 print(widget.devis!.receiptUrls!.length),
                  
                  FirebaseFirestore.instance.collection('USECASES').doc(widget.devis!.usecaseId).collection('PRESTATIONS').doc(widget.devis!.id).update(
                    {
                      "closed":true,
                      "paid": true,
                    }).then((value) {
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).prestationClturer),));
                   setState(() {
                        buttonLoading = false;
                        deletedData=[];
                   });
                 })
               },
             ),
        ),),
         Expanded(
          child:  Padding(
          padding: EdgeInsets.only(left:wv*5.0, right: wv*5.0, top:hv*3),
          child: CustomTextButton(
             borderRadius:60,
             text: S.of(context).annuler,
             textColor: kBlueForce, 
             color: (Colors.grey[200])!,
             expand: false,
             action: () => Navigator.pop(context),
           ),
        )
        )
      
       
    
    ],)

          
         
            ],
          )
          
        ),
           );
         },
       ),
        
    )

      )
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

 
   Widget getDetailOrdonanceDevis({String? title, UseCaseServiceModel? service, List<dynamic>? array, GlobalKey<ExpansionTileCardState>? cardA, int? index,  Function? action}){
  var state= service!.drugsList==null? S.of(context).enCoursDeTraitement :"${Algorithms.getUseCaseServiceName(type: service.type!)}- ${service.drugsUrls!.length} images";
  if (kDebugMode) {
    print(service.drugsList);
    print("333333333333333333333333333333333333333333333333333333");
  }
 
  return ExpansionTileCard(duration:const Duration(milliseconds : 800),key: cardA,borderRadius: BorderRadius.circular(20),shadowColor:  (Colors.grey[200])!,expandedTextColor: Colors.red,
            leading: SvgPicture.asset(Algorithms.getUseCaseServiceIcon(type: service.type!), color: kDeepTeal, width: wv*8,),
            title:Text(title!, style: const TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(state),
            children: <Widget>[
              Container(width: double.infinity, height:hv*30,decoration: const BoxDecoration(color: Colors.white, ),
            child: Expanded(child: service.drugsList!.isNotEmpty && service.drugsUrls!.isNotEmpty?
            ListView.builder(
                 itemCount:  service.drugsList!.length,
                 itemBuilder: (BuildContext context, int index) {
                  var  item=  service.drugsList![0];
                  if (kDebugMode) {
                    print(item['Prix']);
                    print("66666666666666666666666666666666666666666");
                  }
                   return Dismissible(
                     key:  UniqueKey(), 
                      confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                            title:  Text(S.of(context).confirmation),
                            content: Text(S.of(context).tesvousSurDffectuerCetteAction),
                            actions: <Widget>[
                              TextButton(
                                onPressed: (){
                                  
                                    widget.devis!.amount= widget.devis!.amount!-widget.devis!.drugsList![index]['Prix'];
                                    prixDAnaid= (widget.devis!.amount!*70/100);
                                    prixpatient= widget.devis!.amount!-prixDAnaid!;
                                    deletedData?.add(widget.devis!.drugsList![index]);
                                    isDeleteddrugsItems=true; 
                                    var set1 = Set.from(deletedData!);
                                    var set2 = Set.from(service.drugsList!);
                                    service.drugsList=List.from(set2.difference(set1));
                                    widget.devis!.drugsList= service.drugsList;    
                                    if (kDebugMode) {
                                      print(widget.devis!.drugsList!.length);
                                      print(service.drugsList!.length);
                                    }
                                
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).medicamentsSupprimer)));
                                   Navigator.of(context).pop(true);
                                  
                                },
                                child: Text(S.of(context).delete)
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text(S.of(context).cancel),
                              ),
                            ],
                          );
                          });
                          
                        },
                      );
                      },
                     direction: DismissDirection.endToStart,
                     background: Container(color: Colors.red, child: 
                     Row(mainAxisAlignment: MainAxisAlignment.end,children: [ const Icon(Icons.delete,color: Colors.white,), SizedBox(width: wv*3,),],), ),
                     child: ListTile(title: Text(item['NomMedicaments'], style: const TextStyle(fontWeight: FontWeight.bold, color: kBlueForce),),
                     subtitle: Text(widget.devis!.drugsList![index]['NonScientifique'], style: const TextStyle(fontWeight: FontWeight.normal, color: kBlueForce),),
                       trailing: Column(mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text("${item['Prix'].toString()}.f", style: const TextStyle(fontWeight: FontWeight.bold, color: kBlueForce)),
                           Text("-${item['PrixCOuvert'].toString()}.f", style:const TextStyle(fontWeight: FontWeight.normal, color: kBlueForce))
                         ],
                       ),
                     ),
                   );
                 },) :ListView.builder(itemCount: service.drugsUrls!.length,itemBuilder: (BuildContext ctx, int index) {
                   return Padding(padding: const EdgeInsets.all(10),child: 
                   Card(shape:Border.all(width: 1,),elevation: 3,color: Colors.black,
                     child: Column( children: <Widget>[Image.network(service.drugsUrls![index]),],),),
                   );
                 },
               ),)  
         ),
         ButtonBar(alignment:  widget.devis!.drugsList!.isEmpty?  MainAxisAlignment.center: MainAxisAlignment.spaceAround, buttonHeight: 52.0,buttonMinWidth: 90.0,
        children: <Widget>[ 
          widget.devis!.drugsList!.isEmpty? 
           Container( alignment: Alignment.center, child: Center(child: TextButton( style: flatButtonStyle,onPressed: () { cardA!.currentState?.collapse();}, child: Column(children: const <Widget>[ const Icon(Icons.arrow_upward, color: Colors.red), Padding(padding: const EdgeInsets.symmetric(vertical: 2.0), ), Text('fermer', style: const TextStyle(color:  Colors.red)),], ),)))
           :
          TextButton( style: flatButtonStyle,onPressed: () { cardA!.currentState?.collapse();}, child: Column(children: const <Widget>[Icon(Icons.arrow_upward, color: Colors.red), Padding(padding: EdgeInsets.symmetric(vertical: 2.0), ), Text('fermer', style: TextStyle(color:  Colors.red)),], ),),
          widget.devis!.drugsList!.isEmpty? Container() :TextButton(
            style: flatButtonStyle,
            onPressed: () { 
              if(widget.devis!.drugsList!=null){
                if (kDebugMode) {
                  print(deletedData.toString());
                }
                  if(isDeleteddrugsItems==true  && deletedData!=null){
                      // setState(() {
                      //    isUpdatatingDrugs=true;
                      // });
                      if (kDebugMode) {
                        print("ffdsfdsfdsfdsf-----------------------");
                        print(deletedData);
                      }
                      
                    FirebaseFirestore.instance.collection('USECASES').doc(widget.devis!.usecaseId).collection('PRESTATIONS').doc(widget.devis!.id).update(
                       {
                         "drugsList": deletedData!=null ? FieldValue.arrayRemove(deletedData!) :FieldValue.arrayUnion(widget.devis!.drugsList!),
                         "amountToPay":widget.devis!.amount,
                       }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).medicamentsMiseJour),));
                      setState(() {
                           deletedData=[];
                         isUpdatatingDrugs=false;
                      });
                    }).catchError((onError){
                      setState(() {
                         isUpdatatingDrugs=false;
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).uneErreurEstSurvenu),));
                      });
                    });
                    }else if(deletedData==[]){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).veuillezSelectionnerUnMdicamentAuPralable),));
                    }
                    // else if(isDeleteddrugsItems==true && isuserHasAccepteddrugsItems==false){
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("veuillez confirmer la liste des médicaments auprès du client du client"),));
                    // }
                    else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).laSauvegardeNestPossibleQuapresAvoirSupprimerAuMoinsElement),));
                    }
              }else{
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).ceButtonNeSeraActifQuaprsValidationDesImagesPar),));
              }
                
            },
            child: isUpdatatingDrugs!? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kTextBlue),
                ) : Column( children: <Widget>[Icon(Icons.save, color: isDeleteddrugsItems==true? kBlueForce: Colors.grey),
                Padding( padding: const EdgeInsets.symmetric(vertical: 2.0),),
                Text('enregistrer', style: TextStyle(color: isDeleteddrugsItems==true? kBlueForce: Colors.grey )),
              ],
            ),
          ),
          widget.devis!.drugsList!.isEmpty? Container() : TextButton(
            style: flatButtonStyle,
            onPressed: () {
                if(isDeleteddrugsItems==true){
                  if (kDebugMode) {
                    print(deletedData);
                    print(service.drugsList);
                  }
                    setState(() {
                         isconfirmgDrugs=true;
                      });
                    FirebaseFirestore.instance.collection('USECASES').doc(widget.devis!.usecaseId).collection('PRESTATIONS').doc(widget.devis!.id).update(
                       {
                         "isConfirmDrugList": true,
                       }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).prestationClturer),));
                      setState(() {
                           widget.devis!.isConfirmDrugList=true;
                           buttonLoading = false;
                           deletedData=[];
                          isconfirmgDrugs=false;
                          isuserHasAccepteddrugsItems=true;
                      });
                    }).catchError((onError){
                      setState(() {
                         isconfirmgDrugs=false;
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).uneErreurEstSurvenu),));
                      });
                    });
                
                }else{
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).laSauvegardeNestPossibleQuapresAvoirSupprimerAuMoinUn),));
                }
            },
            child: isconfirmgDrugs!? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kTextBlue),
                ) : Column(
              children: <Widget>[
                Icon(Icons.thumb_up, color: kDeepTeal),
                Padding(  padding: const EdgeInsets.symmetric(vertical: 2.0), ),
                Text(S.of(context).confirmerLaListe, style: TextStyle(color:kDeepTeal )),
              ],
            ),
          )
      ],
    ),
            ]
  );
}
  Widget getDetailReceipt({String? title, UseCaseServiceModel? service, List<dynamic>? array, GlobalKey<ExpansionTileCardState>? cardA, int? index,  Function? action}){
  return ExpansionTileCard(duration:Duration(milliseconds : 800),key: cardA,borderRadius: BorderRadius.circular(20),shadowColor:  (Colors.grey[200])!,expandedTextColor: Colors.red,
            leading: SvgPicture.asset(Algorithms.getUseCaseServiceIcon(), color: kDeepTeal, width: wv*8,),
            title:Text(title!, style: TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(" ${service!.receiptUrls!.length} images"),
            children: <Widget>[
              Container(width: double.infinity, height:hv*50,decoration: BoxDecoration(color: Colors.white, ),
            child:ListView.builder(itemCount: service.receiptUrls!.length,itemBuilder: (BuildContext ctx, int index) {
                    return Padding(padding: EdgeInsets.all(10),child: 
                    Card(shape:Border.all(width: 1, ),elevation: 3,color: Colors.black,
                      child: Column( children: <Widget>[Image.network(service.receiptUrls![index]),],),),
                    );
                  },
                ),
         ),
         ButtonBar(alignment: MainAxisAlignment.spaceAround, buttonHeight: 52.0,buttonMinWidth: 90.0,
        children: <Widget>[ 
          TextButton( style: flatButtonStyle,onPressed: () { cardA!.currentState?.collapse();},
          child:  Column(
            children: const <Widget>[
               Icon(Icons.arrow_upward),
              Padding(padding: EdgeInsets.symmetric(vertical: 2.0), ),
              Text('Close'),
            ],
          ),
        ),
      ],
    ),
            ]
  );
  }
  Widget getDetailReultExamens({String? title, UseCaseServiceModel? service, List<dynamic>? array, GlobalKey<ExpansionTileCardState>? cardA, int? index,  Function? action}){
  return ExpansionTileCard(duration:Duration(milliseconds : 800),key: cardA,borderRadius: BorderRadius.circular(20),shadowColor:  (Colors.grey[200])!,expandedTextColor: Colors.red,
            leading: SvgPicture.asset(Algorithms.getUseCaseServiceIcon(type: consultation), color: kDeepTeal, width: wv*8,),
            title:Text(title!, style: TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(" ${service!.resultsUrls!.length} images"),
            children: <Widget>[
              Container(width: double.infinity, height:hv*50,decoration: BoxDecoration(color: Colors.white, ),
            child:ListView.builder(itemCount: service.resultsUrls!.length,itemBuilder: (BuildContext ctx, int index) {
                    return Padding(padding: EdgeInsets.all(10),child: 
                    Card(shape:Border.all(width: 1, ),elevation: 3,color: Colors.black,
                      child: Column( children: <Widget>[Image.network(service.resultsUrls![index]),],),),
                    );
                  },
                ),
         ),
         ButtonBar(alignment: MainAxisAlignment.spaceAround, buttonHeight: 52.0,buttonMinWidth: 90.0,
        children: <Widget>[ 
          TextButton( style: flatButtonStyle,onPressed: () { cardA!.currentState?.collapse();},
          child: Column(
            children: const <Widget>[
              Icon(Icons.arrow_upward),
              Padding(padding:  EdgeInsets.symmetric(vertical: 2.0), ),
              Text('Close'),
            ],
          ),
        ),
      ],
    ),
            ]
  );
  }
  Widget getDetailPrescription({String? title, UseCaseServiceModel? service, List<dynamic>? array, GlobalKey<ExpansionTileCardState>? cardA, int? index,  Function? action}){
  return ExpansionTileCard(duration:Duration(milliseconds : 800),key: cardA,borderRadius: BorderRadius.circular(20),shadowColor:  (Colors.grey[200])!,expandedTextColor: Colors.red,
            leading: SvgPicture.asset(Algorithms.getUseCaseServiceIcon(type: consultation), color: kDeepTeal, width: wv*8,),
            title:Text(title!, style: TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(" ${service!.precriptionUrls!.length} images"),
            children: <Widget>[
              Container(width: double.infinity, height:hv*50,decoration: BoxDecoration(color: Colors.white, ),
            child:Expanded(
              child: service.drugsList!=null && service.precriptionUrls !=null?
              ListView.builder(
                 itemCount:  service.drugsList!.length,
                 itemBuilder: (BuildContext context, int index) {
                   return Dismissible(
                     key:  UniqueKey(), 
                     onDismissed: (direction){
                       if(direction== DismissDirection.endToStart){
                         showAlertDialog(
                         context,
                         S.of(context).tesvousSur,
                         (){
                           setState(() {
                           if (kDebugMode) {
                             print("66666666666666666666666666666");
                            print(index);
                            print(service.precriptionUrls![index]);
                           }
                           widget.devis!.amount= widget.devis!.amount!-widget.devis!.drugsList![index]['Prix'];
                           prixDAnaid= (widget.devis!.amount!*70/100);
                           prixpatient= widget.devis!.amount!-prixDAnaid!;
                            if (kDebugMode) {
                              print("++++++++++++++++PRix du patient : "+prixpatient.toString());
                            }
                           deletedData!.add(widget.devis!.drugsList![index]);
                           widget.devis!.precriptionUrls?.removeAt(index);
                           if (kDebugMode) {
                             print(deletedData);
                           }
                           });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).medicamentsSupprimer)));
                           Navigator.of(context).pop();
                         }
                         );
                       }
                        
                     },
                     direction: DismissDirection.endToStart,
                     background: Container(color: Colors.red, child: 
                     Row(mainAxisAlignment: MainAxisAlignment.end,children: [ Icon(Icons.delete,color: Colors.white,), SizedBox(width: wv*3,),],), ),
                     child: ListTile(title: Text(widget.devis!.drugsList![index]['NomMedicaments'], style: TextStyle(fontWeight: FontWeight.bold, color: kBlueForce),),
                     subtitle: Text(widget.devis!.drugsList![index]['NonScientifique'], style: TextStyle(fontWeight: FontWeight.normal, color: kBlueForce),),
                       trailing: Column(mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text("${service.drugsList![index]['Prix'].toString()}.f", style: TextStyle(fontWeight: FontWeight.bold, color: kBlueForce)),
                           Text("-${service.drugsList![index]['PrixCOuvert'].toString()}.f", style: TextStyle(fontWeight: FontWeight.normal, color: kBlueForce))
                         ],
                       ),
                     ),
                   );
                 },) : ListView.builder(itemCount: service.precriptionUrls!.length,itemBuilder: (BuildContext ctx, int index) {
                      return Padding(padding: EdgeInsets.all(10),child: 
                      Card(shape:Border.all(width: 1, ),elevation: 3,color: Colors.black,
                        child: Column( children: <Widget>[Image.network(service.precriptionUrls![index]),],),),
                      );
                    },
                  ),
            ),
         ),
         ButtonBar(alignment: MainAxisAlignment.spaceAround, buttonHeight: 52.0,buttonMinWidth: 90.0,
        children: <Widget>[ 
          TextButton( style: flatButtonStyle,onPressed: () { cardA!.currentState?.collapse();}, child: Column(children: const <Widget>[ Icon(Icons.arrow_upward, color: Colors.red), Padding(padding:  EdgeInsets.symmetric(vertical: 2.0), ), Text('fermer', style: TextStyle(color:  Colors.red)),], ),),
           TextButton(
            style: flatButtonStyle,
            onPressed: () {
              if(widget.devis!.drugsList!=null){
                if (kDebugMode) {
                  print(deletedData.toString());
                }
                  if(isDeleteddrugsItems==true  && deletedData!=null){
                      // setState(() {
                      //    isUpdatatingDrugs=true;
                      // });
                      if (kDebugMode) {
                        print("ffdsfdsfdsfdsf-----------------------");
                        print(deletedData);
                      }
                      
                    FirebaseFirestore.instance.collection('USECASES').doc(widget.devis!.usecaseId).collection('PRESTATIONS').doc(widget.devis!.id).update(
                       {
                         "drugsList": deletedData!=null ? FieldValue.arrayRemove(deletedData!) :FieldValue.arrayUnion(widget.devis!.drugsList!),
                         "amountToPay":widget.devis!.amount,
                       }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).medicamentsMiseJour),));
                      setState(() {
                           deletedData=[];
                         isUpdatatingDrugs=false;
                      });
                    }).catchError((onError){
                      setState(() {
                         isUpdatatingDrugs=false;
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).uneErreurEstSurvenu),));
                      });
                    });
                    }else if(deletedData==[]){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).veuillezSelectionnerUnMdicamentAuPralable),));
                    }
                    // else if(isDeleteddrugsItems==true && isuserHasAccepteddrugsItems==false){
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("veuillez confirmer la liste des médicaments auprès du client du client"),));
                    // }
                    else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).laSauvegardeNestPossibleQuapresAvoirSupprimerAuMoinsElement),));
                    }
              }else{
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).ceButtonNeSeraActifQuaprsValidationDesImagesPar),));
              }
                
            },
            child: isUpdatatingDrugs!? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kTextBlue),
                ) : Column( children: <Widget>[Icon(Icons.save, color: isDeleteddrugsItems==true? kBlueForce: Colors.grey),
                Padding( padding: const EdgeInsets.symmetric(vertical: 2.0),),
                Text('enregistrer', style: TextStyle(color: isDeleteddrugsItems==true? kBlueForce: Colors.grey )),
              ],
            ),
          ),
           TextButton(
            style: flatButtonStyle,
            onPressed: () {
                if(isDeleteddrugsItems==true){
                    setState(() {
                         isconfirmgDrugs=true;
                      });
                    FirebaseFirestore.instance.collection('USECASES').doc(widget.devis!.usecaseId).collection('PRESTATIONS').doc(widget.devis!.id).update(
                       {
                         "isConfirmDrugList": true,
                       }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).prestationClturer),));
                      setState(() {
                           widget.devis!.isConfirmDrugList=true;
                           buttonLoading = false;
                           deletedData=[];
                          isconfirmgDrugs=false;
                          isuserHasAccepteddrugsItems=true;
                      });
                    }).catchError((onError){
                      setState(() {
                         isconfirmgDrugs=false;
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).uneErreurEstSurvenu),));
                      });
                    });
                }else{
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).laSauvegardeNestPossibleQuapresAvoirSupprimerAuMoinUn),));
                }
            },
            child: isconfirmgDrugs!? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kTextBlue),
                ) : Column(
              children: <Widget>[
                Icon(Icons.thumb_up, color: kDeepTeal),
                Padding(  padding: const EdgeInsets.symmetric(vertical: 2.0), ),
                Text(S.of(context).confirmerLaListe, style: TextStyle(color:kDeepTeal )),
              ],
            ),
          )
      ],
    ),
            ]
  );
  }

}