import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/facture.dart';
import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:danaid/core/models/useCaseServiceModel.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/serviceprovider/PrestationsEnCours.dart';
import 'package:danaid/views/serviceprovider/paiementHistory/DetailsPrestationHistoryForProvider.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
class PrestationHistoryForProvider extends StatefulWidget {
  PrestationHistoryForProvider({Key? key}) : super(key: key);

  @override
  _PrestationHistoryForProviderState createState() => _PrestationHistoryForProviderState();
}

class _PrestationHistoryForProviderState extends State<PrestationHistoryForProvider> {
   DateFormat? dateFormat=DateFormat("MMM yyyy");
   String? data= DateFormat("yyyy").format(DateTime.now());
   String? newsDate='';
   DateTime? today = DateTime.now();
   List<Facture>? facture=[];
   int? currentYears= 0 ;
   List<Map<int, Map<String, Object>>>? paiementHistory= [];
   int? consultationpersonnes=0;
   int? referencemeentPersonnes=0;
   int? totalAnuel=0;
   int? paidYear=0;
   int? notpaidYear=0;
   bool? loading=false;
    @override
  void initState() {
    
    if (kDebugMode) {
      print(getMonthsInYear().toString());
    }
    getPaiement(currentDate: data!);
    setState((){
      currentYears=int.parse(data!);
    }); 
    super.initState();
  }
   List<String>? getMonthsInYear() {
    List<String>? month=[];
     for(int i=1; i<=12; i++){
        var date = DateFormat("MMMM").format(DateTime(today!.year.toInt(), i));
        month.add(date);
     }
   return month;
  }

  getPaiement({String? currentDate }){
      paiementHistory=[];
            consultationpersonnes=0;
            referencemeentPersonnes=0;
            totalAnuel=0;
            paidYear=0;
            notpaidYear=0;
            facture=[];
      setState(() {
          loading=true ;  
        });                            
    var date = DateFormat("yyyy").format(DateTime(int.parse(currentDate!), 1, 1, 0, 0 ));
 
     ServiceProviderModelProvider prestataireProvider =
        Provider.of<ServiceProviderModelProvider>(context, listen: false);
    
    // on get la listes 
    if (kDebugMode) {
      print(prestataireProvider.getServiceProvider!.id);
    }
    var facturation =  FirebaseFirestore.instance.collectionGroup('FACTURATIONS').where('idMedecin',  isEqualTo: prestataireProvider.getServiceProvider!.id).orderBy('createdAt', descending: true).get();
        facturation.then((querySnapshot){
        if (kDebugMode) {
          print( querySnapshot.docs.length);
        }
        // ont get la list des ffacture ici
        for (var doc in querySnapshot.docs) {

           Facture facturesList= Facture.fromDocument(doc);
          print(facturesList.createdAt);
          
           setState(() {
              facture?.add(facturesList);
           });
        }
       if (kDebugMode) {
         print(facture!.length.toString()+"********************");
       }

      List<String>? monthName= getMonthsInYear();
     // print(monthName.length);
      monthName?.asMap().forEach((key, value) {
          if (kDebugMode) {
            print(key.toString()+'----');
            print(monthName[key].toString()+'----');
          }
              var data =facture?.where((element){

                DateTime date = element.createdAt!;
                String datetime= DateFormat("MMMM").format(date);
                String year= DateFormat("yyyy").format(date);
                return datetime==monthName[key] && date.year.toString()==year;
              });
      // print(data.toString());
            if(data!.isNotEmpty){
                List<Facture> fac=data.toList();
                if (kDebugMode) {
                  print("+++++++++++++++++++++++++"+fac[0].toString());
                }
                Facture lastObject= fac.last;
                var isSolve= fac.every((element) => element.isSolve==true);
                var ispaidalready= fac.where((element) => element.isSolve==true);
                var notReadyispaidalready= fac.where((element) => element.isSolve==false && element.canPay==1);
                var personesConsultForMonth= fac.where((element) => element.types!='REFERENCEMENT' && element.types!=null && element.canPay==1 );
                var personesConsultForMonthAll= fac.where((element) => element.types!='REFERENCEMENT' && element.types!=null  );
                var personesReftForMonth= fac.where((element) =>  element.types!=null && element.types!.contains('REFERENCEMENT')==true && element.isSolve==true);
                var personesReftForMonthAll= fac.where((element) => element.types!=null &&  element.types!.contains('REFERENCEMENT')==true );
                int sum=0;
                fac.forEach((e)=>{
                  if(e.amountToPay!=null){
                     sum += e.amountToPay!.toInt()
                  }
                });
                int readyPaid=0;
                for (var e in ispaidalready) {
                  readyPaid += e.amountToPay!.toInt();
                }
                int readyPaidYet=0;
                for (var e in notReadyispaidalready) {
                  readyPaidYet += e.amountToPay!.toInt();
                }
                setState((){
                    consultationpersonnes=consultationpersonnes!.toInt()+personesConsultForMonth.length;
                    referencemeentPersonnes=referencemeentPersonnes!.toInt()+personesReftForMonth.length;
                    totalAnuel=totalAnuel!+sum;
                    paidYear=paidYear!+readyPaid;
                    notpaidYear=notpaidYear!+readyPaidYet;
                });
                fac.sort((a, b) => a.createdAt!.compareTo(a.createdAt!));
                DateTime lastDayOfMonth =  DateTime(fac.last.createdAt!.year, fac.last.createdAt!.month + 1, 0);
                var lastDate=  DateTime(fac.last.createdAt!.year, fac.last.createdAt!.month, lastDayOfMonth.day+15  );
                var formatedDate= DateFormat("dd-MM-yyyy").format(lastDate);
                var obj={
                  key :{
                  'month': monthName[key],
                  'data': fac,
                  'patientLenght': fac.length,
                  'paidAllReady': '${ispaidalready.length}/${personesConsultForMonthAll.length+personesReftForMonthAll.length}',
                  'patientConsult': personesConsultForMonth.length,
                  'patientRef': personesReftForMonth.length,
                  'totlaOfMonths': readyPaidYet,
                  'lasDateOfMonth': formatedDate,
                  'EnAttente' : isSolve
                  } 
                };  
                if (kDebugMode) {
                  print(obj);
                  print(consultationpersonnes);
                  print(referencemeentPersonnes);
                  print(totalAnuel);
                  print(readyPaidYet);
                  print(paidYear);
                }
              paiementHistory?.add(obj);
            }
         
        
      });

     setState((){
       loading=false  ; 
     });
   });
    // ont comment le traitement 
  }
 
  @override
  Widget build(BuildContext context) {

    if (kDebugMode) {
      print(data);
    }
    int dataTIme= int.parse(data!);
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: kBgTextColor,
          appBar: AppBar(
            leading:  IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: kDateTextColor,
                ),
                onPressed: () => Navigator.pop(context)
              ),
            title: Align(
              alignment: Alignment.center,
              child: Container(
                child: Column(
                  children: [Text(S.of(context).historiqueDesPrestations), Text(S.of(context).vosConsultationsPaiement)],
                ),
              ),
            ),
            actions: [
                IconButton(
                icon: Icon(MdiIcons.refresh, color: kSouthSeas, size: wv*8,),
                onPressed: () {
                   getPaiement(currentDate: data);
                },
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
          body: SingleChildScrollView(
    
      child: Column(
              children: [
                loading!?SizedBox(
                width: double.infinity,
                height: hv*7.5,
                child: Loaders().buttonLoader(kPrimaryColor),): Container(),
                Container(   
                  margin : EdgeInsets.only(
                              left: 15.w,top: 3.h, bottom: 15.h), alignment: Alignment.centerLeft,
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                      onTap: ()=>{
                                        if( currentYears!=dataTIme+1){
                                         setState((){
                                          newsDate=DateFormat("yyyy").format(DateTime(dataTIme+1, 1, 1, 0, 0));
                                          currentYears=dataTIme+1;
                                         }),
                                        getPaiement(currentDate: newsDate),

                                        }
                                      },
                                       child: Column(
                                      children: [
                                        Text('${dataTIme+1}', style: TextStyle(
                                            color: kFirstIntroColor,
                                            fontWeight: FontWeight.w700,
                                            
                                            fontSize: wv*3.5), textScaleFactor: 1.0),
                                       currentYears==dataTIme+1? Container(height: 4.h, width:30.w, color: kFirstIntroColor, child:Text('') ,) : Container()
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: ()=>{
                                        if( currentYears!=dataTIme){
                                           setState((){
                                          newsDate=DateFormat("yyyy").format(DateTime(dataTIme, 1, 1, 0, 0));
                                          print(newsDate);
                                          currentYears=dataTIme;
                                         }),
                                        getPaiement(currentDate: newsDate),
                                        }
                                        
                                      },child: Column(
                                      children: [
                                        Text('${dataTIme}', style: TextStyle(
                                            color: kFirstIntroColor,
                                            fontWeight: FontWeight.w700,
                                            
                                            fontSize: wv*3.5), textScaleFactor: 1.0),
                                       currentYears==dataTIme? Container(height: 4.h, width:30.w, color: kFirstIntroColor, child:Text('') ,) : Container()
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: ()=>{
                                          if( currentYears!=dataTIme-1){
                                              setState((){
                                            newsDate=DateFormat("yyyy").format(DateTime(dataTIme-1, 1, 1, 0, 0));
                                            print(newsDate);
                                            currentYears=dataTIme-1;
                                          }),
                                            getPaiement(currentDate: newsDate),
                                          }
                                         
                                      },child: Column(
                                      children: [
                                        Text('${dataTIme-1}', style: TextStyle(
                                            color: kFirstIntroColor,
                                            fontWeight: FontWeight.w700,
                                            
                                            fontSize: wv*3.5), textScaleFactor: 1.0),
                                       currentYears==dataTIme-1? Container(height: 4.h, width:30.w, color: kFirstIntroColor, child:Text('') ,) : Container()
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: ()=>{
                                          if( currentYears!=dataTIme-2){
                                               setState((){
                                                newsDate=DateFormat("yyyy").format(DateTime(dataTIme-2, 1, 1, 0, 0));
                                                print(newsDate);
                                                currentYears=dataTIme-2;
                                              }),
                                              getPaiement(currentDate: newsDate),
                                            }
                                        
                                      }, child: Column(
                                      children: [
                                        Text('${dataTIme-2}', style: TextStyle(
                                            color: kFirstIntroColor,
                                            fontWeight: FontWeight.w700,
                                            
                                            fontSize: wv*3.5), textScaleFactor: 1.0),
                                       currentYears==dataTIme-2? Container(height: 4.h, width:30.w, color: kFirstIntroColor, child:Text('') ,) : Container()
                                      ],
                                    ),
                                  ),
                                 
                                ],
                              )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin : EdgeInsets.only(
                              left: 15.w,top: 2.h),
                          child: Text(S.of(context).statusDesPaiements, style: TextStyle(
                                      color: kFirstIntroColor,
                                      fontWeight: FontWeight.w500,
                                      
                                      fontSize:  16.sp), textScaleFactor: 1.0,)),
                        Container(
                           alignment: Alignment.centerLeft,
                           
                          margin: EdgeInsets.only(left: wv*5, top: hv*2, right: wv*5) ,
                          padding: EdgeInsets.all(20) ,
                          width: double.infinity,
                              decoration: BoxDecoration(
                                color:kThirdIntroColor.withOpacity(0.3),
                                
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                          child: 
                          Column(
                            mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              
                              children: [
                                Text(S.of(context).consultation, textScaleFactor: 1.0, style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w500,
                                          
                                          fontSize: wv*3.5)),
                                Container(
                                  margin: EdgeInsets.only(left:wv*6),
                                  child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('$consultationpersonnes x',textScaleFactor: 1.0, style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w600,
                                          
                                          fontSize: wv*3.5)),
                                            Text('2000 f.',style: TextStyle(
                                          color: kSimpleForce,
                                          fontWeight: FontWeight.w500,
                                          
                                          fontSize: wv*3.5), textScaleFactor: 1.0,),
                                          ],
                                        ),
                                      Container(
                                        width: 80.w,
                                        child: Text(S.of(context).beneficiaresJours,style: TextStyle(
                                          color: kSimpleForce,
                                          fontWeight: FontWeight.w500,
                                          fontSize: wv*3), textScaleFactor: 1.0,),
                                      ),
                                        
                                                                          ],
                                    ),
                                  ],
                                )),
                                Text('${consultationpersonnes!*2000}f',style: TextStyle(
                                      color: kFirstIntroColor,
                                      fontWeight: FontWeight.w500,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,),
                              ],
                            ),
                             SizedBox(
                          height: hv * 1.3,
                        ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(S.of(context).rfrencements, textScaleFactor: 1.0, style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w500,
                                          
                                          fontSize: wv*3.5)),
                                Container(
                                  margin: EdgeInsets.only(left:hv*4),
                                  child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('$referencemeentPersonnes x',textScaleFactor: 1.0, style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w600,
                                          
                                          fontSize: wv*3.5)),
                                            Text('2000f.',style: TextStyle(
                                          color: kSimpleForce,
                                          fontWeight: FontWeight.w500,
                                          
                                          fontSize: wv*3.5), textScaleFactor: 1.0,),
                                          ],
                                        ),
                                       Container(
                                        width: 80.w,
                                        child: Text(S.of(context).personnesInscrites,style: TextStyle(
                                          color: kSimpleForce,
                                          fontWeight: FontWeight.w500,
                                          fontSize: wv*3), textScaleFactor: 1.0,),
                                      ),
                                      ],
                                    ),
                                  ],
                                )),
                                Spacer(),
                                Text('${referencemeentPersonnes!*2000}f',style: TextStyle(
                                      color: kFirstIntroColor,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,),
                              ],
                            ),
                            new Divider(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(S.of(context).totalAnnuel, textScaleFactor: 1.0, style: TextStyle(
                                          color: kFirstIntroColor,
                                          fontWeight: FontWeight.w500,
                                          
                                          fontSize: wv*3.5)),
                                 Spacer(),
                                Text('${ referencemeentPersonnes!*2000+consultationpersonnes!*2000} f',style: TextStyle(
                                      color: kFirstIntroColor,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,),
                              ],
                            ),
                           SizedBox(
                          height: hv * 1.3,
                        ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(S.of(context).pay, textScaleFactor: 1.0, style: TextStyle(
                                          color: kDeepTeal,
                                          fontWeight: FontWeight.w600,
                                          
                                          fontSize: wv*3.5)),
                                 Spacer(),
                                Text('$paidYear f',style: TextStyle(
                                      color: kDeepTeal,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,),
                              ],
                            ),
                           SizedBox(
                          height: hv * 1.3,
                        ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(S.of(context).restePayer, textScaleFactor: 1.0, style: TextStyle(
                                          color: kSimpleForce,
                                          fontWeight: FontWeight.w600,
                                          
                                          fontSize: wv*3.5)),
                                 Spacer(),
                                Text('$notpaidYear f',style: TextStyle(
                                      color: kFirstIntroColor,
                                      fontWeight: FontWeight.w700,
                                      
                                      fontSize: wv*3.5), textScaleFactor: 1.0,),
                              ],
                            ),
                          ],
                        )),
                      ],
                    )),
                  ],
                ),
               SizedBox(height: hv * 3,),
               Container(
                 width: double.infinity,
                  color: Colors.white,
                  margin: EdgeInsets.only(top: hv * 2),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: ()=>{
                                      getPaiement()
                                    },
                                    child: Container( margin: EdgeInsets.only(left: wv * 4, top: hv * 2,bottom: wv * 2),alignment: Alignment.centerLeft, child: Text('Mes derniers prestations', style: TextStyle(
                                        color: kFirstIntroColor,
                                        fontWeight: FontWeight.w500,
                                        
                                        fontSize: wv*3.5), textScaleFactor: 1.0,)),
                                  ),
                            Column(
                              children: [
                                // GestureDetector(onTap:(){
                                //   Navigator.pushNamed(context, '/details-history-prestation-doctor');
                                // }, 
                                //    child: HomePageComponents().paiementItem()),
                                // HomePageComponents().paiementItem(),
                                // HomePageComponents().paiementItem(),
                                // HomePageComponents().paiementItem(),
                              paiementHistory!.isEmpty ?   Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(child: Container(child: Text(S.of(context).aucuneTransactionPourCetteAnne))),
                              ):
                               loading!? Center(child: Loaders().buttonLoader(kPrimaryColor)) : 
                               ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: false,
                                reverse: true,
                                itemCount: paiementHistory!.length,
                                itemBuilder: (context, index) {
                                  if(paiementHistory!.elementAt(index).isNotEmpty){
                                       for (int key in  paiementHistory!.elementAt(index).keys){
                                        // print( paiementHistory.elementAt(index)[key]);
                                        // print( paiementHistory.elementAt(index)[key]['month']);
                                         return GestureDetector(onTap:(){
                                         Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsPrestationHistoryForProvider(
                                                    facture:paiementHistory?.elementAt(index)[key]!['data'] as List<Facture>,
                                                    month: paiementHistory?.elementAt(index)[key]!['month']!.toString(),
                                                  )),
                                        );
                                        },
                                        child: HomePageComponents().paiementItem(
                                          lastDatePaiement: paiementHistory!.elementAt(index)[key]!['lasDateOfMonth'] as String,
                                          month:paiementHistory!.elementAt(index)[key]!['month']!.toString(), 
                                          paidAllReady: paiementHistory!.elementAt(index)[key]!['paidAllReady']!.toString(),
                                          paidOrNot: paiementHistory?.elementAt(index)[key]!['EnAttente'] as bool,
                                          prix: paiementHistory?.elementAt(index)[key]!['totlaOfMonths']as String
                                        ));
                                      }
                                 
                                  }else {
                                    return Container(child: Text(S.of(context).aucuneTransactionPourCetteAnne));
                                  }
                                  return  Container(child: Text(S.of(context).aucuneTransactionPourCetteAnne));
                             
                                 }
                              ),
                              ],
                            ),
                  //      'month': monthName[key],
                  // 'data': fac,
                  // 'patientLenght': fac.length,
                  // ''
                  // 'totlaOfMonths': sum,
                  // 'lasDateOfMonth': formatedDate,
                  // 'EnAttente' : isSolve

                 ]
                                ,
                              ),
               )
              ],
            ),
          ),
        )
      );
  }
}