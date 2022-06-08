
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/models/devisModel.dart';
import 'package:danaid/core/models/useCaseServiceModel.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/services/getPlatform.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/SizeConfig.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

class  OrdonanceDuPatient extends StatefulWidget {
   UseCaseServiceModel? devis;
  OrdonanceDuPatient({Key? key, this.devis}) : super(key: key);


  @override
  _OrdonanceDuPatientState createState() => _OrdonanceDuPatientState();
}

class _OrdonanceDuPatientState extends State<OrdonanceDuPatient> {
   final GlobalKey<ScaffoldState>? _scaffoldKey = GlobalKey<ScaffoldState>();
   final GlobalKey<ExpansionTileCardState>? cardA = new GlobalKey();
  final GlobalKey<ExpansionTileCardState>? cardB = new GlobalKey();
  final GlobalKey<ExpansionTileCardState>? cardC = new GlobalKey();
  final GlobalKey<ExpansionTileCardState>? cardD = new GlobalKey();
   bool? isGetdevis=false, buttonLoading=false;
   Timestamp? dateNaiss;
   num? prixDAnaid, prixpatient;
   String? userId, urlImage, username, codeDeconsultation;
   List<String>? urlImg;
   List? deletedData=[];
   List<DevisModel>? devis=[];
  bool? visibilityDrugs = false;
  bool? visibilityReceipt = false;
  bool? visibilityResult = false;
  bool? visibilityPrescription = false;
  bool? isDeleteddrugsItems= false, isuserHasAccepteddrugsItems= false;
  bool? isUpdatatingDrugs= false, isconfirmgDrugs= false;
  int? currentIndex=0;
 
   final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  void _changed(bool visibility, String field, int index) {
    setState(() {
      if (index==1){
        visibilityDrugs = visibility;
      }
      else if (index==2){
        visibilityReceipt = visibility;
      }
      
    });
  }
   @override
   void initState() {
     setState(() {
          prixDAnaid= (widget.devis!.amount!*70/100);
          prixpatient= widget.devis!.amount!-prixDAnaid!;
        
    });
     super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_){
        getAdhenents(widget.devis!.idAppointement!);
    });
   }
   
  


    Future<void> getAdhenents(String code)  async {
     if (kDebugMode) {
       print("--------------------------------");
     }
     print(code);
     setState(() {
            isGetdevis=true;
          });
     await FirebaseFirestore.instance
          .collection('APPOINTMENTS').doc(code).get()
          .then((value) {
          if (kDebugMode) {
            print(value.id);
            print(value.data());
            print("--------------------------------");   
            print( value.data().toString());
            print("--------------------------------");   
          }
        if (value.data()!=null) {
          setState(() {
           userId= code;  
           dateNaiss= value.data()!['birthDate'];
           urlImage= value.data()!['avatarUrl'];
           username= value.data()!['username'];
           
          });
        }else {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:  Text("cet utilisateur n'existe pas "),));
           setState(() {
            isGetdevis=false;
          });
        }
      }).onError((error, stackTrace) {
         setState(() {
            isGetdevis=false;
          });
          print(error);
          print(stackTrace);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("une erreur s'est produite "),));
      });
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
      setState(()=> {
        isDeleteddrugsItems=true
      });
    }
    
    
    
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
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
   
    return WillPopScope(
      onWillPop:()async{
         Navigator.pop(context);
         return true;
      },
      child: Scaffold(
      key: _scaffoldKey,  
      appBar: AppBar(
          backgroundColor:  kGoldlightYellow,
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
                  Text("${widget.devis!.title}", style: TextStyle(color: kDateTextColor, fontSize: Device.isSmartphone(context) ?  wv*4 :17 , fontWeight: FontWeight.w700), ),
                  Text("${widget.devis!.titleDuDEvis}", style: TextStyle(color: kDateTextColor, fontSize: Device.isSmartphone(context) ? wv*4 : 15, fontWeight: FontWeight.w300), ),
                 
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
      body:  SafeArea(
      child: Center(
        child: Container(
          constraints: BoxConstraints(
              maxWidth: Device.isSmartphone(context) ? double.infinity : 1000
          ),
          child: StreamBuilder(
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
                    Text('Chargement', style: TextStyle(color: Colors.grey[600], fontSize: 25, fontWeight: FontWeight.bold),),
                  ],
                )
              ,);
            }
            var userDocument = snapshot.data as DocumentSnapshot<Object?>;
            widget.devis= UseCaseServiceModel.fromDocument(userDocument, userDocument.data() as Map);
              return Container(
                child: 
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints){
              return   SingleChildScrollView(
           child: ConstrainedBox(
             constraints: BoxConstraints(
                   minHeight: viewportConstraints.maxHeight,
                 ),
                 
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      height: MySize.getScaledSizeHeight(130),
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: hv*1, left: wv*2),
                      decoration: const BoxDecoration( color: kGoldlightYellow),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Container(
                              margin: EdgeInsets.only(left: wv*1),
                              child: Text(S.of(context).pourLePatient, style: TextStyle( color: kSimpleForce, fontSize: Device.isSmartphone(context)? wv*5 :17, fontWeight: FontWeight.w500),)),
                            SizedBox(height: hv*0.3,),
                             Container(
                              margin: EdgeInsets.only(left: wv*1),
                              child: Text(username!=null?'$username':"pas definie", style: TextStyle( color: kSimpleForce, fontSize: Device.isSmartphone(context)? wv*9: 15, fontWeight: FontWeight.w800),)),
                             SizedBox(height: hv*0.3,),
                               Container(
                              margin: EdgeInsets.only(left: wv*1),
                              child: Text(S.of(context).codeDeConsultation, style: TextStyle( color: kSimpleForce, fontSize: Device.isSmartphone(context)? wv*5:15 , fontWeight: FontWeight.w400),)),
                             SizedBox(height: hv*0.3,),
                               Container(
                              margin: EdgeInsets.only(left: wv*1),
                              child: Text('${widget.devis!.consultationCode}', style: TextStyle( color: kSimpleForce, fontSize: Device.isSmartphone(context)? wv*5:15, fontWeight: FontWeight.w800),)),
                        
                        ],
                      )
                    ),
                    Expanded(child: 
                     Column(
                       children: [
                         Padding(
                            padding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*1),
                            child: Column(
                              children: [
                                SizedBox(height: hv*2,),
                                Row(
                                  children: [
                                    Text(S.of(context).couvertureDanaid, style:   TextStyle(color: kCardTextColor, fontSize: Device.isSmartphone(context)? wv*5:16,)),
                                    const Spacer(),
                                    Text(S.of(context).copaiement, style:  TextStyle(color: kCardTextColor, fontSize: Device.isSmartphone(context)? wv*5:16,))
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
                                          Spacer(),
                                          Text("${widget.devis!.amount!.toDouble().round()}.f", style: const TextStyle(color: kCardTextColor, fontSize: 17,))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: Device.isSmartphone(context) ? wv*60 : wv*50,
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
                                              color: kDeepYellow.withOpacity(0.65),
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
                                                  HomePageComponents.getStatusIndicator(status: 1, size: 12)
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
                    
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
                        decoration: BoxDecoration(
                          color: whiteColor
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(S.of(context).suivieDesPrestations, style: TextStyle(color: kBlueDeep, fontSize: 17, fontWeight: FontWeight.bold)),
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
                                                service: widget.devis!,
                                                cardA: cardA!,
                                               )
                                              ),
                                          ): Container(),
                                          
                                          widget.devis!.receiptUrls!.isNotEmpty?  Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Expanded(
                                              child: getDetailReceipt(
                                                title: doc2,
                                                service: widget.devis!,
                                                cardA: cardB!,
                                               )
                                              ),
                                          ): Container(),
                                          widget.devis!.resultsUrls!.isNotEmpty?  Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Expanded(
                                              child: getDetailReultExamens(
                                                title: doc3,
                                                service: widget.devis!,
                                                cardA: cardC!,
                                               )
                                              ),
                                          ): Container(),
                                          widget.devis!.precriptionUrls!.isNotEmpty?  Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Expanded(
                                              child: getDetailPrescription(
                                                title: doc3,
                                                service: widget.devis!,
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
                    ),
                   
                          
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: wv*10, vertical: hv*2),
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: Device.isSmartphone(context) ? wv*50 : wv*30,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("TOTAL", style: TextStyle(
                                          fontSize: Device.isSmartphone(context) ? fontSize(size: wv * 5) : 17,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.3,
                                          color: kBlueForce)),
                                                  Text("${widget.devis!.amount!.toDouble().round().toString()}.f",style: TextStyle(
                                          fontSize: Device.isSmartphone(context) ? fontSize(size: wv * 5):17,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.2,
                                          color: kBlueForce)),
                                                ],
                                              ),
                                            ),
                                          ),
                                         
                                          SizedBox(
                                            width: Device.isSmartphone(context) ? wv*50 : wv*30,
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(S.of(context).couvertParDanaid,style: TextStyle(
                                          fontSize:Device.isSmartphone(context) ? fontSize(size: wv * 4): 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2,
                                          color: kMaron)),
                                                       Text(S.of(context).niveauIDecouverte,style: TextStyle(
                                          fontSize: Device.isSmartphone(context) ? fontSize(size: wv * 4):16,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.2,
                                          color: kMaron)),
                                                    ],
                                                  ),
                                                  Text("${prixDAnaid!.toDouble().round().toString()}.f",style: TextStyle(
                                          fontSize: Device.isSmartphone(context) ? fontSize(size: wv * 5) :16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2,
                                          color: kMaron)),
                                                ],
                                              ),
                                            ),
                                          ),
                                         
                                          SizedBox(
                                            width: Device.isSmartphone(context) ? wv*65 : wv*30,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(S.of(context).copaiement,style: TextStyle(
                                          fontSize: Device.isSmartphone(context) ? fontSize(size: wv * 4) : 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2,
                                          color: kBlueForce)),
                                                 
                                                  Text("${prixpatient!.toDouble().round().toString()}.f",style: TextStyle(
                                          fontSize:Device.isSmartphone(context) ? fontSize(size: wv * 4):16,
                                          fontWeight: FontWeight.w600,
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
                      buttonLoading==true? Center(child: Loaders().buttonLoader(kCardTextColor)) :
                   CustomTextButton(
                      borderRadius:60,
                      text: S.of(context).validerLaPrestation,
                      color: kBlueDeep,
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
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prestation Clôturer'),));
                          setState(() {
                               buttonLoading = false;
                               deletedData=[];
                          });
                        }).then((value) => {
                           Navigator.pushNamed(context, '/home')
                        })
                      },
                    ),  
                       ],
                     )
                    ), 
                   

                  ]),
              ),
            ),
           );

            }),
          
              );
            },
          ),
        ),
      ),
      
      
      )

      ));
  
 
  }

 
 
   Widget getDetailOrdonanceDevis({String? title, UseCaseServiceModel? service, List<dynamic>? array, GlobalKey<ExpansionTileCardState>? cardA, int? index,  Function ?action}){
  var state= service!.drugsList==null? S.of(context).enCoursDeTraitement :"${Algorithms.getUseCaseServiceName(type: service.type!)}- ${service.drugsUrls!.length} images";
  print(service.drugsList);
  print("333333333333333333333333333333333333333333333333333333");
 
  return ExpansionTileCard(duration:const Duration(milliseconds : 800),key: cardA,borderRadius: BorderRadius.circular(20),shadowColor:  (Colors.grey[200])!,expandedTextColor: Colors.red,
            leading: SvgPicture.asset(Algorithms.getUseCaseServiceIcon(type: service.type!), color: kDeepTeal, width: wv*8,),
            title:Text(title!, style:const TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(state),
            children: <Widget>[
              Container(width: double.infinity, height:hv*30,decoration: const BoxDecoration(color: Colors.white, ),
            child: Expanded(child: service.drugsList!=null && service.drugsUrls!=null && service.drugsList!.isNotEmpty && service.drugsUrls!.isNotEmpty?
            ListView.builder(
                 itemCount:  service.drugsList!.length,
                 itemBuilder: (BuildContext context, int index) {
                  var  item=  service.drugsList![0];
                  print(item['Prix']);
                  print("66666666666666666666666666666666666666666");
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
                                    print(widget.devis!.drugsList!.length);
                                    print(service.drugsList!.length);
                                
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
                           Text("-${item['PrixCOuvert'].toString()}.f", style: const TextStyle(fontWeight: FontWeight.normal, color: kBlueForce))
                         ],
                       ),
                     ),
                   );
                 },) :ListView.builder(itemCount: service.drugsUrls!.length,itemBuilder: (BuildContext ctx, int index) {
                   return Padding(padding:const EdgeInsets.all(10),child: 
                   Card(shape:Border.all(width: 1, ),elevation: 3,color: Colors.black,
                     child: Column( children: <Widget>[Image.network(service.drugsUrls![index]),],),),
                   );
                 },
               ),)  
         ),
         ButtonBar(alignment: widget.devis!.drugsList!=null?  MainAxisAlignment.center: MainAxisAlignment.spaceAround, buttonHeight: 52.0,buttonMinWidth: 90.0,
        children: <Widget>[ 
         widget.devis!.drugsList!=null? 
           Container( alignment: Alignment.center, child: Center(child: TextButton( style: flatButtonStyle,onPressed: () { cardA?.currentState?.collapse();}, child: Column(children: const <Widget>[ Icon(Icons.arrow_upward, color: Colors.red), Padding(padding:  EdgeInsets.symmetric(vertical: 2.0), ), Text('fermer', style: TextStyle(color:  Colors.red)),], ),)))
           :
          TextButton( style: flatButtonStyle,onPressed: () { cardA?.currentState?.collapse();}, child: Column(children: const <Widget>[ Icon(Icons.arrow_upward, color: Colors.red), Padding(padding:  EdgeInsets.symmetric(vertical: 2.0), ), Text('fermer', style: TextStyle(color:  Colors.red)),], ),),
         widget.devis!.drugsList!=null? Container() :TextButton(
            style: flatButtonStyle,
            onPressed: () { 
              if(widget.devis!.drugsList!=null){
                print(deletedData.toString());
                  if(isDeleteddrugsItems==true  && deletedData!=null){
                      // setState(() {
                      //    isUpdatatingDrugs=true;
                      // });
                      print("ffdsfdsfdsfdsf-----------------------");
                      print(deletedData);
                      
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
            child: isUpdatatingDrugs!? const CircularProgressIndicator(
                  valueColor:  AlwaysStoppedAnimation<Color>(kTextBlue),
                ) : Column( children: <Widget>[Icon(Icons.save, color: isDeleteddrugsItems==true? kBlueForce: Colors.grey),
                const Padding( padding:  EdgeInsets.symmetric(vertical: 2.0),),
                Text(S.of(context).enregistrer, style: TextStyle(color: isDeleteddrugsItems==true? kBlueForce: Colors.grey )),
              ],
            ),
          ),
         widget.devis!.drugsList!=null? Container() : TextButton(
            style: flatButtonStyle,
            onPressed: () {
                if(isDeleteddrugsItems==true){
                  print(deletedData);
                  print(service.drugsList);
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
            child: isconfirmgDrugs!? const  CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kTextBlue),
                ) : Column(
              children: <Widget>[
                const Icon(Icons.thumb_up, color: kDeepTeal),
                const Padding(  padding:  EdgeInsets.symmetric(vertical: 2.0), ),
                 Text(S.of(context).confirmerLaListe, style:const TextStyle(color:kDeepTeal )),
              ],
            ),
          )
      ],
    ),
            ]
  );
}
  Widget getDetailReceipt({String? title, UseCaseServiceModel? service, List<dynamic>? array, GlobalKey<ExpansionTileCardState>? cardA, int? index,  Function? action}){
  return ExpansionTileCard(duration:const Duration(milliseconds : 800),key: cardA,borderRadius: BorderRadius.circular(20),shadowColor:  (Colors.grey[200])!,expandedTextColor: Colors.red,
            leading: SvgPicture.asset(Algorithms.getUseCaseServiceIcon(), color: kDeepTeal, width: wv*8,),
            title:Text(title!, style: const TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(" ${service!.receiptUrls!.length} images"),
            children: <Widget>[
              Container(width: double.infinity, height:hv*50,decoration: const BoxDecoration(color: Colors.white, ),
            child:ListView.builder(itemCount: service.receiptUrls!.length,itemBuilder: (BuildContext ctx, int index) {
                    return Padding(padding: const EdgeInsets.all(10),child: 
                    Card(shape:Border.all(width: 1, ),elevation: 3,color: Colors.black,
                      child: Column( children: <Widget>[Image.network(service.receiptUrls![index]),],),),
                    );
                  },
                ),
         ),
         ButtonBar(alignment: MainAxisAlignment.spaceAround, buttonHeight: 52.0,buttonMinWidth: 90.0,
        children: <Widget>[ 
          TextButton( style: flatButtonStyle,onPressed: () { cardA?.currentState?.collapse();},
          child: Column(
            children: <Widget>[
              const Icon(Icons.arrow_upward),
              const Padding(padding:  EdgeInsets.symmetric(vertical: 2.0), ),
              Text(S.of(context).close),
            ],
          ),
        ),
      ],
    ),
            ]
  );
  }
  Widget getDetailReultExamens({String? title, UseCaseServiceModel? service, List<dynamic>? array, GlobalKey<ExpansionTileCardState>? cardA, int? index,  Function? action}){
  return ExpansionTileCard(duration: const Duration(milliseconds : 800),key: cardA,borderRadius: BorderRadius.circular(20),shadowColor:  (Colors.grey[200])!,expandedTextColor: Colors.red,
            leading: SvgPicture.asset(Algorithms.getUseCaseServiceIcon(type: consultation), color: kDeepTeal, width: wv*8,),
            title:Text(title!, style:const TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(" ${service!.resultsUrls!.length} images"),
            children: <Widget>[
              Container(width: double.infinity, height:hv*50,decoration: const BoxDecoration(color: Colors.white, ),
            child:ListView.builder(itemCount: service.resultsUrls!.length,itemBuilder: (BuildContext ctx, int index) {
                    return Padding(padding: const EdgeInsets.all(10),child: 
                    Card(shape:Border.all(width: 1, ),elevation: 3,color: Colors.black,
                      child: Column( children: <Widget>[Image.network(service.resultsUrls![index]),],),),
                    );
                  },
                ),
         ),
         ButtonBar(alignment: MainAxisAlignment.spaceAround, buttonHeight: 52.0,buttonMinWidth: 90.0,
        children: <Widget>[ 
          TextButton( style: flatButtonStyle,onPressed: () { cardA?.currentState?.collapse();},
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
  return ExpansionTileCard(duration:const Duration(milliseconds : 800),key: cardA,borderRadius: BorderRadius.circular(20),shadowColor:  (Colors.grey[200])!,expandedTextColor: Colors.red,
            leading: SvgPicture.asset(Algorithms.getUseCaseServiceIcon(type: consultation), color: kDeepTeal, width: wv*8,),
            title:Text(title!, style: const TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(" ${service!.precriptionUrls!.length} images"),
            children: <Widget>[
              Container(width: double.infinity, height:hv*50,decoration: const BoxDecoration(color: Colors.white, ),
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
                           print("66666666666666666666666666666");
                           print(index);
                           print(service.precriptionUrls![index]);
                           widget.devis!.amount= widget.devis!.amount!-widget.devis!.drugsList![index]['Prix'];
                           prixDAnaid= (widget.devis!.amount!*70/100);
                           prixpatient= widget.devis!.amount!-prixDAnaid!;
                            print("++++++++++++++++PRix du patient : "+prixpatient.toString());
                           deletedData!.add(widget.devis!.drugsList![index]);
                           widget.devis!.precriptionUrls!.removeAt(index);
                           print(deletedData);
                           });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).medicamentsSupprimer)));
                           Navigator.of(context).pop();
                         }
                         );
                       }
                        
                     },
                     direction: DismissDirection.endToStart,
                     background: Container(color: Colors.red, child: 
                     Row(mainAxisAlignment: MainAxisAlignment.end,children: [ const Icon(Icons.delete,color: Colors.white,), SizedBox(width: wv*3,),],), ),
                     child: ListTile(title: Text(widget.devis!.drugsList![index]['NomMedicaments'], style: const TextStyle(fontWeight: FontWeight.bold, color: kBlueForce),),
                     subtitle: Text(widget.devis!.drugsList![index]['NonScientifique'], style: const TextStyle(fontWeight: FontWeight.normal, color: kBlueForce),),
                       trailing: Column(mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text("${service.drugsList![index]['Prix'].toString()}.f", style: const TextStyle(fontWeight: FontWeight.bold, color: kBlueForce)),
                           Text("-${service.drugsList![index]['PrixCOuvert'].toString()}.f", style: const TextStyle(fontWeight: FontWeight.normal, color: kBlueForce))
                         ],
                       ),
                     ),
                   );
                 },) : ListView.builder(itemCount: service.precriptionUrls!.length,itemBuilder: (BuildContext ctx, int index) {
                      return Padding(padding: const EdgeInsets.all(10),child: 
                      Card(shape:Border.all(width: 1, ),elevation: 3,color: Colors.black,
                        child: Column( children: <Widget>[Image.network(service.precriptionUrls![index]),],),),
                      );
                    },
                  ),
            ),
         ),
         ButtonBar(alignment: MainAxisAlignment.spaceAround, buttonHeight: 52.0,buttonMinWidth: 90.0,
        children: <Widget>[ 
          TextButton( style: flatButtonStyle,onPressed: () { cardA?.currentState?.collapse();}, child: Column(children: const <Widget>[ Icon(Icons.arrow_upward, color: Colors.red), Padding(padding:  EdgeInsets.symmetric(vertical: 2.0), ), Text('fermer', style: TextStyle(color:  Colors.red)),], ),),
           TextButton(
            style: flatButtonStyle,
            onPressed: () {
              if(widget.devis!.drugsList!=null){
                print(deletedData.toString());
                  if(isDeleteddrugsItems==true  && deletedData!=null){
                      // setState(() {
                      //    isUpdatatingDrugs=true;
                      // });
                      print("ffdsfdsfdsfdsf-----------------------");
                      print(deletedData);
                      
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
            child: isUpdatatingDrugs!? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kTextBlue),
                ) : Column( children: <Widget>[Icon(Icons.save, color: isDeleteddrugsItems==true? kBlueForce: Colors.grey),
                const Padding( padding:  EdgeInsets.symmetric(vertical: 2.0),),
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
            child: isconfirmgDrugs!? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kTextBlue),
                ) : Column(
              children:  <Widget>[
                const Icon(Icons.thumb_up, color: kDeepTeal),
                const Padding(  padding:  EdgeInsets.symmetric(vertical: 2.0), ),
                Text(S.of(context).confirmerLaListe, style: const TextStyle(color:kDeepTeal )),
              ],
            ),
          )
      ],
    ),
            ]
  );
  }

}