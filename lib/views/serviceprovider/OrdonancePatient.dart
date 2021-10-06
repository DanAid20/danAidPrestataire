
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/models/devisModel.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/SizeConfig.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class OrdonanceDuPatient extends StatefulWidget {
  final DevisModel devis;
  OrdonanceDuPatient({Key key, this.devis}) : super(key: key);


  @override
  _OrdonanceDuPatientState createState() => _OrdonanceDuPatientState();
}

class _OrdonanceDuPatientState extends State<OrdonanceDuPatient> {
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   bool isGetdevis=false, buttonLoading=false;
   Timestamp dateNaiss;
   num prixDAnaid, prixpatient;
   String userId, urlImage, username, codeDeconsultation;
   List<String> urlImg;
   List deletedData=[];
   List<DevisModel> devis=[];
   @override
   void initState() {
     setState(() {
          prixDAnaid= (widget.devis.amount*70/100);
          prixpatient= widget.devis.amount-prixDAnaid;
        
    });
     super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_){
        print(widget.devis.appointementId);
        getAdhenents(widget.devis.appointementId);
    });
   }
   
  


    Future<void> getAdhenents(String code)  async {
     print("--------------------------------");
     setState(() {
            isGetdevis=true;
          });
     await FirebaseFirestore.instance
          .collection('APPOINTMENTS').doc(code).get()
          .then((value) {
          print(code);
          print(value.data().toString());
        if (value.data()!=null) {
          setState(() {
           userId= code;
           dateNaiss= value.data()['birthDate'];
           urlImage= value.data()['avatarUrl'];
           username= value.data()['username'];
           
          });
        }else {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("cet utilisateur n'existe pas "),));
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
    return WillPopScope(
      onWillPop:()async{
         Navigator.pop(context);
      },
      child: Scaffold(
      key: _scaffoldKey,  
      appBar: AppBar(
          backgroundColor:  kGoldlightYellow,
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
                  Text(S.of(context).ordonance, style: TextStyle(color: kDateTextColor, fontSize: wv*4, fontWeight: FontWeight.w500), ),
                  Text("Devis Numéro 123456 ", style: TextStyle(color: kDateTextColor, fontSize: wv*4, fontWeight: FontWeight.w300), ),
                 
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
       Container(
        child: Column(
          children: [
            Container(
              height: MySize.getScaledSizeHeight(120),
              width: double.infinity,
              padding: EdgeInsets.only(bottom: hv*1, left: wv*2),
              decoration: BoxDecoration( color: kGoldlightYellow),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Container(
                      margin: EdgeInsets.only(left: wv*1),
                      child: Text('pour Le patient', style: TextStyle( color: kSimpleForce, fontSize: wv*5, fontWeight: FontWeight.w500),)),
                    SizedBox(height: hv*0.3,),
                     Container(
                      margin: EdgeInsets.only(left: wv*1),
                      child: Text('$username', style: TextStyle( color: kSimpleForce, fontSize: wv*9, fontWeight: FontWeight.w800),)),
                     SizedBox(height: hv*0.3,),
                       Container(
                      margin: EdgeInsets.only(left: wv*1),
                      child: Text('Code de consultation', style: TextStyle( color: kSimpleForce, fontSize: wv*5, fontWeight: FontWeight.w400),)),
                     SizedBox(height: hv*0.3,),
                       Container(
                      margin: EdgeInsets.only(left: wv*1),
                      child: Text('${widget.devis.consultationCode}', style: TextStyle( color: kSimpleForce, fontSize: wv*5, fontWeight: FontWeight.w800),)),
                
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
                            Text(S.of(context).couvertureDanaid, style: TextStyle(color: kCardTextColor, fontSize: 16,)),
                            Spacer(),
                            Text(S.of(context).copaiement, style: TextStyle(color: kCardTextColor, fontSize: 16,))
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
                                  Text("${widget.devis.amount.toDouble().round()}.f", style: TextStyle(color: kCardTextColor, fontSize: 17,))
                                ],
                              ),
                            ),
                            Container(
                              width: wv*60,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                boxShadow: [BoxShadow(color: Colors.grey[500].withOpacity(0.3), blurRadius: 7, spreadRadius: 1, offset: Offset(0,4))]
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.75),
                                    decoration: BoxDecoration(
                                      color: kDeepYellow.withOpacity(0.65),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
                                    ),
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Text('$prixDAnaid.f', style: TextStyle(color: kCardTextColor, fontSize: 17, fontWeight: FontWeight.bold))
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
                                               widget.devis.status==0? S.of(context).enAttente : widget.devis.status==1? S.of(context).pay: S.of(context).tatInconue ,
                                                  style: TextStyle(color:  widget.devis.status==0? kBlueForce: widget.devis.status==1? kDeepTeal: kDeepDarkTeal, fontWeight: FontWeight.bold),
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
                    
            widget.devis.requestTreatedList.isNotEmpty? Container(
              margin: EdgeInsets.all(5),
               width: double.infinity,
                    height: hv*25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
              child:
            Center(child: ListView.builder(
                  itemCount: widget.devis.requestTreatedList.length,
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
                            print(widget.devis.requestTreatedList[index]);
                            widget.devis.amount= widget.devis.amount-widget.devis.requestTreatedList[index]['Prix'];
                            prixDAnaid= (widget.devis.amount*70/100);
                            prixpatient= widget.devis.amount-prixDAnaid;
                             print("++++++++++++++++PRix du patient : "+prixpatient.toString());
                            deletedData.add(widget.devis.requestTreatedList[index]);
                            widget.devis.requestTreatedList.removeAt(index);
                            print(widget.devis.requestTreatedList.length);
                            });
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).medicamentsSupprimer)));
                            Navigator.of(context).pop();
                          }
                          );
                        }
                         
                      },
                      direction: DismissDirection.endToStart,
                      background: Container(color: Colors.red, child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                   SizedBox(width: wv*3,),
                        ],
                      ), ),
                      child: ListTile(
                        title: Text(widget.devis.requestTreatedList[index]['NomMedicaments'], style: TextStyle(fontWeight: FontWeight.bold, color: kBlueForce),),
                        subtitle: Text(widget.devis.requestTreatedList[index]['NonScientifique'], style: TextStyle(fontWeight: FontWeight.normal, color: kBlueForce),),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${widget.devis.requestTreatedList[index]['Prix'].toString()}.f", style: TextStyle(fontWeight: FontWeight.bold, color: kBlueForce)),
                            Text("-${widget.devis.requestTreatedList[index]['PrixCOuvert'].toString()}.f", style: TextStyle(fontWeight: FontWeight.normal, color: kBlueForce))
                          ],
                        ),
                      ),
                    );
                  },)
             )):
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: hv*30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.devis.urlImageDevis.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                        shape:Border.all(width: 5, ),
                        elevation: 10,
                        color: Colors.black,
                        child: Column(
                          children: <Widget>[
                            Image.network(widget.devis.urlImageDevis[index]),
                          ],
                        ),
                        ),
                      );
        },
       
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
                                Colors.grey[200],
                                Colors.white,
                              ],
                            )),
                          child: SizedBox.shrink(),
                            ),
                        Container(
                          width: double.infinity,
                          height: hv*12,
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
                                          Text("${widget.devis.amount.toDouble().round().toString()}.f",style: TextStyle(
                                  fontSize: fontSize(size: wv * 5),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.2,
                                  color: kBlueForce)),
                                        ],
                                      ),
                                    ),
                                  ),
                                 
                                  Container(
                                    width: wv*65,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(S.of(context).couvertParDanaid,style: TextStyle(
                                  fontSize: fontSize(size: wv * 4),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                  color: kMaron)),
                                               Text(S.of(context).niveauIDecouverte,style: TextStyle(
                                  fontSize: fontSize(size: wv * 4),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.2,
                                  color: kMaron)),
                                            ],
                                          ),
                                          Text("${prixDAnaid.toDouble().round().toString()}.f",style: TextStyle(
                                  fontSize: fontSize(size: wv * 5),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                  color: kMaron)),
                                        ],
                                      ),
                                    ),
                                  ),
                                 
                                  Container(
                                    width: wv*65,
                                    child: Padding(
                                      padding:  EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(S.of(context).copaiement,style: TextStyle(
                                  fontSize: fontSize(size: wv * 4),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                  color: kBlueForce)),
                                         
                                          Text("${prixpatient.toDouble().round().toString()}.f",style: TextStyle(
                                  fontSize: fontSize(size: wv * 4),
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
              expand: false,
              noPadding: false,
              action: () =>{
                setState(() {
                       buttonLoading = true;
                  }),
                print(widget.devis.requestTreatedList.length),
                 FirebaseFirestore.instance.collection("DEVIS").doc(widget.devis.id).update(
                   {
                     "RequestTreatedList" : deletedData!=null ? FieldValue.arrayRemove(deletedData) :FieldValue.arrayUnion(widget.devis.requestTreatedList),
                     "status": 1,
                     "montant":widget.devis.amount,
                     "ispaid": widget.devis.ispaid,
                   }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Prestation Clôturer'),));
                  setState(() {
                       buttonLoading = false;
                       deletedData=[];
                  });
                })
              },
            ),  
               ],
             )
            ), 
           

          ])))

      )
    );
  }
}