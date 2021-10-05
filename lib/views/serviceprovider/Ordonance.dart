import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/models/devisModel.dart';
import 'package:danaid/core/providers/ServicesProviderInvoice.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/SizeConfig.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Ordonances extends StatefulWidget {
  final DevisModel devis;

  Ordonances({Key key, this.devis}) : super(key: key);
  @override
  _OrdonanceDuPatientState createState() => _OrdonanceDuPatientState();
}

class _OrdonanceDuPatientState extends State<Ordonances> {
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   TextEditingController _costController = new TextEditingController();
    
   bool edit=false, buttonLoading=false;
   DateTime selectedDate;
   Timestamp dateNaiss;
   num prixDAnaid, prixpatient;
   String userId, urlImage, username;
   List<String> urlImg;
   List deletedData=[];
  @override
  initState()  {
    setState(() {
        
          _costController.text=widget.devis.amount.toString();
          selectedDate= widget.devis.createdDate.toDate();
          prixDAnaid= (widget.devis.amount*70/100);
          prixpatient= widget.devis.amount-prixDAnaid;
        
    });
    print(prixDAnaid);
    print(prixpatient);
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_){
        print(widget.devis.appointementId);
        getPatientInformation(widget.devis.appointementId);
    });
  }
  String formatTimestamp(Timestamp timestamp) {
  var format = new DateFormat('y-MM-d'); // 'hh:mm' for hour & min
  return format.format(timestamp.toDate());
}
   Future<void> getPatientInformation(String code)  async {
     print("--------------------------------");
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
        }
      }).onError((error, stackTrace) {
          print(error);
          print(stackTrace);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("une erreur s'est produite "),));
      });
   print("--------------------------------");
 }
 
 showAlertDialog(BuildContext context, String title,  VoidCallback function) async {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("supprimer"),
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
    ServicesProviderInvoice devisProvider = Provider.of<ServicesProviderInvoice>(context);
    print(devisProvider.getInvoice.amount);
    
    print(userId);
    print(dateNaiss.toString());
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
                  Text("${widget.devis.intitule}", style: TextStyle(color: kDateTextColor, fontSize: wv*4, fontWeight: FontWeight.w300), ),
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
       Column(
         children: [

          SingleChildScrollView(
             physics: BouncingScrollPhysics(),
             child: Column(
               children: [
                 Container(
               color: kGoldlightYellow,
               height: hv*43,
               child: Column(
                 children: [
                   Container(
                           margin: EdgeInsets.only(top: hv*1, left: 5, right: 5),
                           decoration: BoxDecoration(
                             color: whiteColor,
                             borderRadius: BorderRadius.circular(20),
                             boxShadow: [BoxShadow(color: Colors.grey[700].withOpacity(0.4), blurRadius: 3, spreadRadius: 1.5, offset: Offset(0,4))]
                           ),
                           child: Column(
                             children: [
                               Container(
                                 height: hv*13.8,
                                 padding: EdgeInsets.only(bottom: hv*1.2),
                                 decoration: BoxDecoration(
                                   color: kGoldlightYellow.withOpacity(0.3),
                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                                 ),
                                 child: Column(
                                   children: [
                                     Row(
                                       children: [
                                         Expanded(child: HomePageComponents.header(label: S.of(context).pourLePatient, title: username, subtitle: (DateTime.now().year - dateNaiss.toDate().year).toString() + " ans", avatarUrl: urlImage , titleColor: kTextBlue)),
                                         HomePageComponents.getIconBox(iconPath: 'assets/icons/Bulk/Edit.svg', color: kDeepTeal, size: 25, action: ()=>setState((){
                                           print(edit);
                                           edit = !edit;
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
                                             Text("${widget.devis.consultationCode}",
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
                                           Text( 'Date*', style: TextStyle(fontSize: 16, color: kTextBlue, fontWeight: FontWeight.w400),),
                                           SizedBox(height: 3,),
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
                                                 Text( selectedDate != null ? "${selectedDate.toLocal()}".split(' ')[0] : S.of(context).choisir, style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.bold),),
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
                                           Text(S.of(context).montantPercu, style: TextStyle(fontSize: 15, color: kTextBlue)),
                                           SizedBox(height: 5),
                                           TextFormField(
                                             controller: _costController,
                                             onChanged: (val)=>setState((){}),
                                             enabled: edit,
                                             inputFormatters: <TextInputFormatter>[
                                               FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                                             ],
                                             textAlign: TextAlign.end,
                                             keyboardType: TextInputType.numberWithOptions(decimal: true),
                                             style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),
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

                   Expanded(child: 
                Column(
                  children: [
                    Padding(
                       padding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*1),
                       child: Column(
                         children: [
                           SizedBox(height: hv*1,),
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
                                     Text("${prixpatient.toDouble().round().toString()}.f", style: TextStyle(color: kCardTextColor, fontSize: 17,))
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
                                         color: kLightWhite.withOpacity(0.65),
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
                                             HomePageComponents.getStatusIndicator(status: widget.devis.status, size: 12)
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
                )
               ), 
                 ],
               ),
             ),

            widget.devis.requestTreatedList.isNotEmpty? Container(
              margin: EdgeInsets.all(5),
               width: double.infinity,
                    height: hv*30,
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
                            _costController.text=widget.devis.amount.toString();
                            deletedData.add(widget.devis.requestTreatedList[index]);
                            widget.devis.requestTreatedList.removeAt(index);
                            print(widget.devis.requestTreatedList.length);
                            });
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(' medicaments supprimer')));
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
                  Container(
                    width: double.infinity,
                    height: hv*30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  child: ListView.builder(
                  itemCount: widget.devis.urlImageDevis.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Padding(
                      padding: EdgeInsets.all(20),
                      child: Card(
                      shape:Border.all(width: 5, ),
                      elevation: 20,
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
                                  Colors.grey[200],
                                  Colors.white,
                                ],
                              )),
                            child: SizedBox.shrink(),
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
                                            Text("${widget.devis.amount}.f",style: TextStyle(
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
          buttonLoading==true?  Loaders().buttonLoader(kPrimaryColor) : 
          Padding(
             padding: EdgeInsets.only(left:wv*5, right: wv*5, top:hv*3),
             child: CustomTextButton(
                borderRadius:60,
                text: S.of(context).validerLaPrestation,
                color: kBlueDeep,
                expand: false,
                noPadding: true,
                action: () =>{
                  setState(() {
                         buttonLoading = true;
                    }),
                  print(widget.devis.requestTreatedList.length),
                   FirebaseFirestore.instance.collection("DEVIS").doc(widget.devis.id).update(
                     {
                       "RequestTreatedList" : deletedData!=null ? FieldValue.arrayRemove(deletedData) :FieldValue.arrayUnion(widget.devis.requestTreatedList),
                       "montant": _costController.text,
                       "status": 1,
                       "ispaid": widget.devis.ispaid,
                       "closeDevisDate": selectedDate
                     }).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Prestation Clôturer'),));
                    setState(() {
                         buttonLoading = false;
                         deletedData=[];
                    });
                  })
                },
              ),
           ),
           Padding(
             padding: EdgeInsets.only(left:wv*5.0, right: wv*5.0, top:hv*3),
             child: CustomTextButton(
                borderRadius:60,
                text: S.of(context).annuler,
                textColor: kBlueForce, 
                color: Colors.grey[200],
                expand: false,
                noPadding: true,
                action: () => Navigator.pop(context),
              ),
           )
        ],)

             
         
               ],
             )
             
           ),
          

         ]))

      )
    );
  }
   _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
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