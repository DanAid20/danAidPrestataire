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
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class PrestationHistoryForProvider extends StatefulWidget {
  PrestationHistoryForProvider({Key key}) : super(key: key);

  @override
  _PrestationHistoryForProviderState createState() => _PrestationHistoryForProviderState();
}

class _PrestationHistoryForProviderState extends State<PrestationHistoryForProvider> {
   DateFormat dateFormat=DateFormat("MMM yyyy");
   String data= DateFormat("yyyy").format(DateTime.now());
   String newsDate='';
   DateTime today = DateTime.now();
   List<UseCaseServiceModel> facture=[];
   int currentYears= 0 ;
   List<Map<int, Map<String, Object>>> paiementHistory= [];
   int consultationpersonnes=0;
   int referencemeentPersonnes=0;
   int totalAnuel=0;
   int paidYear=0;
   int notpaidYear=0;
   bool loading=false;
    @override
  void initState() {
    print(getMonthsInYear().toString());
    getPaiement(currentDate: data);
    setState((){
      currentYears=int.parse(data);
    }); 
    super.initState();
  }
   List<String> getMonthsInYear() {
    List<String> month=[];
     for(int i=1; i<=12; i++){
        var date = DateFormat("MMMM").format(DateTime(today.year, i));
        month.add(date);
     }
   return month;
  }

  getPaiement({String currentDate }){
      paiementHistory=[];
            consultationpersonnes=0;
            referencemeentPersonnes=0;
            totalAnuel=0;
            paidYear=0;
            notpaidYear=0;
            facture=[];
          loading=true  ;                            
    var date = DateFormat("yyyy").format(DateTime(int.parse(currentDate), 1, 1, 0, 0 ));
 
     ServiceProviderModelProvider prestataireProvider =
        Provider.of<ServiceProviderModelProvider>(context, listen: false);
    
    // on get la listes 
    print(prestataireProvider.getServiceProvider.id);
    var facturation =  FirebaseFirestore.instance.collectionGroup('PRESTATIONS').where('prestataireId',  isEqualTo: prestataireProvider.getServiceProvider.id).orderBy('createdAt', descending: true).get();
        facturation.then((querySnapshot){
        print( querySnapshot.docs.length);
        // ont get la list des ffacture ici
        querySnapshot.docs.forEach((doc) {

           UseCaseServiceModel facturesList= UseCaseServiceModel.fromDocument(doc);
          print(facturesList.amount);
          
           setState(() {
              facture.add(facturesList);
           });
        });
       print(facture.length);

      List<String> monthName= getMonthsInYear();
     // print(monthName.length);
      monthName.asMap().forEach((key, value) {
         // print(key.toString()+'----');
          print(monthName[key].toString()+'----');
              var data =facture.where((element){
               //   print(element.createdAt.month);
               Timestamp t = element.dateCreated;
               DateTime date = t.toDate();
                String data= DateFormat("MMMM").format(date);
                String year= DateFormat("yyyy").format(date);
                return data==monthName[key] && date==year ;
              });
            
            if(data.length>0){
                List<UseCaseServiceModel > fac=data.toList();
                print("+++++++++++++++++++++++++"+fac.length.toString());
                UseCaseServiceModel  lastObject= fac.last;
                var isSolve= fac.every((element) => element.paid==true);
                var ispaidalready= fac.where((element) =>  element.paid==true);
                var notReadyispaidalready= fac.where((element) =>  element.paid==false );
                var personesConsultForMonth= fac.where((element) => element.type!='REFERENCEMENT' );
                var personesConsultForMonthAll= fac.where((element) => element.type!='REFERENCEMENT'  );
                var personesReftForMonth= fac.where((element) => element.type.contains('REFERENCEMENT')==true);
                var personesReftForMonthAll= fac.where((element) => element.type.contains('REFERENCEMENT')==true);
                int sum=0;
                fac.forEach((e) => sum += e.amount);
                int readyPaid=0;
                ispaidalready.forEach((e) => readyPaid += e.amount);
                int readyPaidYet=0;
                notReadyispaidalready.forEach((e) => readyPaidYet += e.amount);
                setState((){
                    consultationpersonnes+=personesConsultForMonth.length;
                    referencemeentPersonnes+=personesReftForMonth.length;
                    totalAnuel+=sum;
                    paidYear+=readyPaid;
                    notpaidYear+=readyPaidYet;
                });
                fac.sort((a, b) => a.date.compareTo(a.date));
                DateTime lastDayOfMonth = new DateTime(fac.last.date.toDate().year, fac.last.date.toDate().month + 1, 0);
                var lastDate= new DateTime(fac.last.date.toDate().year, fac.last.date.toDate().month, lastDayOfMonth.day+15  );
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
                print(obj);
                print(consultationpersonnes);
                print(referencemeentPersonnes);
                print(totalAnuel);
                print(readyPaidYet);
                print(paidYear);
              paiementHistory.add(obj);
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

    print(data);
    int dataTIme= int.parse(data);
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: kBgTextColor,
          appBar: AppBar(
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
                  children: [Text(S.of(context).historiqueDesPrestations), Text(S.of(context).vosConsultationsPaiement)],
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
          body: SingleChildScrollView(
    
      child: Column(
              children: [
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
                                Text('${consultationpersonnes*2000}f',style: TextStyle(
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
                                Text('${referencemeentPersonnes*2000}f',style: TextStyle(
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
                                Text('${ referencemeentPersonnes*2000+consultationpersonnes*2000} f',style: TextStyle(
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
                              paiementHistory.length==0 ?   Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(child: Container(child: Text(S.of(context).aucuneTransactionPourCetteAnne))),
                              ):
                               loading? Center(child: Loaders().buttonLoader(kPrimaryColor)) : 
                               ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: false,
                                itemCount: paiementHistory.length,
                                itemBuilder: (context, index) {
                                  if(paiementHistory.elementAt(index)!=null){
                                       for (int key in  paiementHistory.elementAt(index).keys){
                                        // print( paiementHistory.elementAt(index)[key]);
                                        // print( paiementHistory.elementAt(index)[key]['month']);
                                         return GestureDetector(onTap:(){
                                         Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsPrestationHistoryForProvider(
                                                    facture:paiementHistory.elementAt(index)[key]['data'],
                                                    month: paiementHistory.elementAt(index)[key]['month'],
                                                  )),
                                        );
                                        },
                                        child: HomePageComponents().paiementItem(
                                          lastDatePaiement: paiementHistory.elementAt(index)[key]['lasDateOfMonth'],
                                          month:paiementHistory.elementAt(index)[key]['month'], 
                                          paidAllReady: paiementHistory.elementAt(index)[key]['paidAllReady'],
                                          paidOrNot: paiementHistory.elementAt(index)[key]['EnAttente'],
                                          prix: paiementHistory.elementAt(index)[key]['totlaOfMonths'].toString()
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