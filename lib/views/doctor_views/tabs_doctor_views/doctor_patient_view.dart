import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/appointmentModel.dart';
import 'package:danaid/core/models/devisModel.dart';
import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:danaid/core/models/useCaseServiceModel.dart';
import 'package:danaid/core/providers/ServicesProviderInvoice.dart';
import 'package:danaid/core/providers/appointmentProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/services/getPlatform.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/add_patient_views.dart';
import 'package:danaid/views/doctor_views/paiementHistory/prestationHistory.dart';
import 'package:danaid/views/serviceprovider/OrdonancePatient.dart';
import 'package:danaid/views/serviceprovider/ScanPatient.dart';
import 'package:danaid/views/serviceprovider/ServicesProvider_QuoteEmit.dart';
import 'package:danaid/views/serviceprovider/create_Quote.dart';
import 'package:danaid/views/serviceprovider/paiementHistory/PrestationHistoryForProvider.dart';
import 'package:danaid/views/serviceprovider/services_provider_views/add_patient_views_service_Providers.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorPatientView extends StatefulWidget {
  DoctorPatientView({Key? key}) : super(key: key);

  @override
  _DoctorPatientViewState createState() => _DoctorPatientViewState();
}

class _DoctorPatientViewState extends State<DoctorPatientView> {
  final NavigationService? _navigationService = locator<NavigationService>();
  var startDays;
  var endDay;
  var currrentDaysOfPrestatire;
  @override
  void initState() {
    super.initState();
    triggerGetPatient();
    getDateOfToday();
  }

  getDateOfToday(){
     var theDay = DateTime.now();
      var theTime=new DateTime(theDay.year, theDay.month, theDay.day, 23, 59);
    setState(() {
          currrentDaysOfPrestatire=theTime;
        });
  }
  triggerGetPatient() {
    var dates = DateTime.now();
    var start = new DateTime(dates.year, dates.month, dates.day, 00, 00);
    var end = new DateTime(dates.year, dates.month, dates.day, 23, 59);
    print(start);
    print(end);
    setState(() {
      startDays = start;
      endDay = end;
    });
  }

  Widget servicesList() {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ServiceProviderModelProvider prestataire =
        Provider.of<ServiceProviderModelProvider>(context);
    //print(prestataire.);
    bool isPrestataire =
        userProvider.getProfileType == serviceProvider ? true : false;
    return Container(
      constraints: BoxConstraints(
        maxWidth: Device.isSmartphone(context) ? double.infinity : 1000,
        maxHeight: Device.isSmartphone(context) ? double.infinity : 420
      ),
      margin: EdgeInsets.only(top: hv * 1.5, bottom: hv * 1.5),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column( 
        children: [
          GestureDetector(
            onTap: () {
              isPrestataire? 
              Navigator.push( 
                context,
                MaterialPageRoute(
                    builder: (context) => ScanPatient()),
              )
              :
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddPatientView(
                          isLaunchConsultation: true,
                        )),
              );
            },
            child: Container(
                margin:
                    EdgeInsets.only(left: SizeConfig.defaultSize! * 1.5, right: SizeConfig.defaultSize! * 1.5, top: 20.h),
                width:  Device.isSmartphone(context) ? 330.w : 1000 ,
                height: Device.isSmartphone(context) ? 140.h : 220 ,
                decoration: BoxDecoration(
                  color: isPrestataire ? kGold : kThirdIntroColor,
                  boxShadow: const[
                     BoxShadow(
                        color: Colors.grey, spreadRadius: 0.5, blurRadius: 4),
                  ],
                  borderRadius: const  BorderRadius.all(
                    Radius.circular(17),
                  ),
                ),
                padding: EdgeInsets.only(top: SizeConfig.defaultSize! * 1),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(right: SizeConfig.defaultSize! * 3.5, top: SizeConfig.defaultSize! * 0.5),
                        child: SvgPicture.asset(
                            'assets/icons/Bulk/Bookmark.svg',
                            width: Device.isSmartphone(context) ? wv*8 : wv*3,
                            color: isPrestataire == true ? kBlueForce : kDeepTeal),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 20.w, right: hv * 1.5, top: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              isPrestataire
                                  ? S.of(context).complterUnePriseEnCharge
                                  : S.of(context).dmarrerUneConsultation,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: kCardTextColor,
                                  fontWeight: FontWeight.w800, 
                                  fontSize: Device.isSmartphone(context) ?20.sp : 30),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(left: 20.w, right: Device.isSmartphone(context) ? 60.w : 30.w, top: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              isPrestataire
                                  ? S.of(context).vrifierLeStatutDesPaiementsAvantDeRaliserLesServices
                                  : S.of(context).accdezAuCarnetDeSantDigitalDeVosPatientsEt,
                              textScaleFactor: 0.8,
                              style: TextStyle(
                                  color: kCardTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Device.isSmartphone(context) ? 15.5.sp : 20 ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2.0),
            height: 110.r ,
            child:  ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                GestureDetector(
                  onTap: () { 
                    isPrestataire
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateQuote()),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddPatientView(
                                      isLaunchConsultation: false,
                                    )),
                          );
                  },
                  child: displsOtherServices(
                    iconesUrl: isPrestataire
                        ? 'assets/icons/Bulk/Discount.svg'
                        : 'assets/icons/Bulk/Add User.svg',
                    title: isPrestataire
                        ? S.of(context).emettreUnDevis
                        : S.of(context).ajouterUnPatient,
                    isPrestataire: isPrestataire,
                  ),
                ),
                isPrestataire?GestureDetector(
                  onTap: () {
                   Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddPatientViewServiceProvider(
                                      isLaunchConsultation: true,
                                    )),
                          );
                  },
                  child: displsOtherServices(
                    iconesUrl: 'assets/icons/Two-tone/3User.svg',
                    title:S.of(context).prendreRendezvous,
                    isPrestataire: isPrestataire,
                  ),
                ): SizedBox.shrink(),
                GestureDetector(
                  onTap: () {
                    isPrestataire? 
                     Navigator.push( context,
                        MaterialPageRoute(
                            builder: (context) => PrestationHistoryForProvider()),
                      ): Navigator.push( context,
                        MaterialPageRoute(
                            builder: (context) =>PrestationHistory()),
                      );
                     
                  },
                  child: displsOtherServices(
                    iconesUrl: 'assets/icons/Bulk/Chart.svg',
                    title: S.of(context).suivreMesPaiements,
                    isPrestataire: isPrestataire,
                  ),
                ),
                
               
                
                GestureDetector(
                  onTap: () {
                    isPrestataire
                        ? Navigator.pushNamed(context, '/chatroom')
                        : Navigator.pushNamed(context, '/chatroom');
                  },
                  child: displsOtherServices(
                    iconesUrl: 'assets/icons/Bulk/Message.svg',
                    title: S.of(context).mesMessages,
                    isPrestataire: isPrestataire,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  displsOtherServices(
      {String? iconesUrl, String? title, bool? isPrestataire = false}) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(
                left:  Device.isSmartphone(context) ? 20.w : 8.w , right: wv * 1.5, top: hv * 2, bottom: hv * 1),
            width:  Device.isSmartphone(context) ? 125.r :200.r,
            height:  Device.isSmartphone(context) ? 85.r : 80.r ,
            decoration: BoxDecoration(
              color: isPrestataire == true ? kGoldlight : kThirdIntroColor,
              boxShadow: const [
                BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding: EdgeInsets.only(top: hv * 0.3),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 10.w, top: 4.h),
                    child: SvgPicture.asset(
                        iconesUrl ?? 'assets/icons/Bulk/Bookmark.svg',
                        width:  Device.isSmartphone(context) ? wv * 6 :wv * 2,
                        color: isPrestataire == true ? kBlueForce : kDeepTeal),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 10.w, right: wv * 1.5, top: 1.h),
                  child: Row(
                    children: [
                      SizedBox(
                        width:  Device.isSmartphone(context) ? 90.r :100.r   ,
                        child: Text(
                          title ?? S.of(context).ajouterUnPatient,
                          style: TextStyle( 
                              color: kCardTextColor,
                              fontWeight: FontWeight.w800,
                              fontSize: Device.isSmartphone(context) ? 16.sp : 14 ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }

  getListOfUser(startDays, endDay, date, doctorId) {
    print(doctorId);
    Stream<QuerySnapshot> query = FirebaseFirestore.instance
        .collection("APPOINTMENTS")
        .where("doctorId", isEqualTo: doctorId)
        .where("start-time", isGreaterThan: startDays, isLessThan: endDay)
        .orderBy("start-time", descending: true)
        .snapshots();
        AppointmentModelProvider rendezVous = Provider.of<AppointmentModelProvider>(context);
    AppointmentModel appointmentModel;
    return StreamBuilder<QuerySnapshot>(
        stream: query,
        builder: (context, snapshot) {
          //print(snapshot.data.docs.length);
          if (snapshot.connectionState == ConnectionState.waiting && snapshot.hasData==false) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }
          
          return snapshot.data!.docs.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var componenent;
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    if(doc["adherentId"] != doc["beneficiaryId"]){
                            CollectionReference users =
                              FirebaseFirestore.instance.collection("ADHERENTS/${doc["adherentId"]}/BENEFICIAIRES");
                          componenent= FutureBuilder<DocumentSnapshot>(
                            future: users.doc(doc["beneficiaryId"]).get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const  Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(kPrimaryColor),
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return Text(S.of(context).somethingWentWrong);
                              }
                              if (snapshot.connectionState == ConnectionState.done) {
                                Map<String, dynamic> data = snapshot.data!.data()  as Map<String, dynamic> ;
                                Timestamp day = doc["start-time"];
                                DateTime dateTime = day.toDate();
                                String formattedTime =
                                    DateFormat.Hm().format(dateTime);

                                return GestureDetector(
                                      onTap: ()=>{
                                      appointmentModel=AppointmentModel.fromDocument(doc, doc.data() as Map),
                                      rendezVous.setAppointmentModel(appointmentModel),
                                      rendezVous.getAppointment!.adherentId=snapshot.data!.id,
                                      rendezVous.getAppointment!.avatarUrl=data["imageUrl"],
                                      rendezVous.getAppointment!.username='${data["prenom"]} ${data["nomFamille"]} ',
                                      rendezVous.getAppointment!.birthDate=data["dateNaissance"],
                                      
                                        Navigator.of(context).pushNamed('/appointment-apointement')
                                        
                                      },
                                      child: HomePageComponents().patientsItem(
                                    apointementDate: formattedTime,
                                    etat:doc["status"],
                                    imgUrl: '${data["imageUrl"]}',
                                    nom: '${data["prenom"]} ${data["nomFamille"]}',
                                    subtitle: '${doc["title"]}', ));
                              }
                              return Text(S.of(context).loading);
                            },
                          );
                     }else if(doc["adherentId"] == doc["beneficiaryId"]){
                        CollectionReference users =
                        FirebaseFirestore.instance.collection('ADHERENTS');
                      componenent= FutureBuilder<DocumentSnapshot>(
                      future: users.doc(doc["adherentId"]).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPrimaryColor),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text(S.of(context).somethingWentWrong);
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                          Timestamp day = doc["start-time"];
                          DateTime dateTime = day.toDate();
                          String formattedTime =
                              DateFormat.Hm().format(dateTime);

                          return GestureDetector(
                                onTap: ()=>{
                                appointmentModel=AppointmentModel.fromDocument(doc, doc.data() as Map),
                                rendezVous.setAppointmentModel(appointmentModel),
                                rendezVous.getAppointment!.adherentId=snapshot.data!.id,
                                rendezVous.getAppointment!.avatarUrl=data["imageUrl"],
                                rendezVous.getAppointment!.username='${data["prenom"]} ${data["nomFamille"]} ',
                                rendezVous.getAppointment!.birthDate=data["dateNaissance"],
                                Navigator.of(context).pushNamed('/appointment-apointement')
                                  
                                },
                                child: HomePageComponents().patientsItem(
                              apointementDate: formattedTime,
                              etat:doc["status"],
                              imgUrl: '${data["imageUrl"]}',
                              nom: '${data["prenom"]} ${data["nomFamille"]}',
                              subtitle: '${doc["title"]}'));
                        }
                        return Text(S.of(context).loading);
                      },
                    );
                     }
                     return componenent;
                    
                  })
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child:
                        Text(S.of(context).vousNavezAucunRendezvousPourLeMoment),
                  ),
                );
        });
  }
  
  getPrestataireList( prestatairesId){
     Stream<QuerySnapshot> query = FirebaseFirestore.instance
        .collectionGroup("PRESTATIONS")
        .where("prestataireId", isEqualTo: prestatairesId)
        .where("status", isEqualTo: 2)
         .where("createdDate", isGreaterThan: startDays, isLessThan: endDay)
        .orderBy("createdDate", descending: true)
        .snapshots();
      return StreamBuilder(
        stream: query,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
         
          if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                        ),
                      );
          }
          
        
        return snapshot.data.docs.length!=0? ListView.builder(
                     shrinkWrap: true,
                     itemCount: snapshot.data.docs.length,
                     itemBuilder: (context, index) {
                         DocumentSnapshot doc = snapshot.data.docs[index];
                        // var devis=DevisModel.fromDocument(doc);
                        UseCaseServiceModel devis= UseCaseServiceModel.fromDocument(doc, doc.data() as Map);
                        return HomePageComponents()
                         .prestataireItemList(
                            etat: devis.paid!? 1:0,
                            montant: DateFormat("dd MMMM yyy ")
                                .format(devis.dateCreated!.toDate()),
                            date:"${devis.title}- ${devis.amount}.f" ,
                            nom: "${devis.titleDuDEvis}",
                            iconesConsultationTypes:Algorithms.getUseCaseServiceIcon(type: devis.type), 
                            redirectOncliked: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                OrdonanceDuPatient(devis: devis))
                                );
                            });
                      
                     }
                  ): const Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("aucun devis en attente aujourd'hui "),
                  ),
                );
        }     
      );
  }
  patientOfTodyaList() {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);
    bool isPrestataire =
        userProvider.getProfileType == serviceProvider ? true : false;
    return Container(
       constraints: BoxConstraints(
        maxWidth: Device.isSmartphone(context) ? double.infinity : 1000,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          decoration:const BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.only(top: hv * 2, left: wv * 5, right: wv * 5),
          child: Row(
            children: [
              Text(
                S.of(context).demandesDeRdv,
                style: TextStyle(
                    color: kFirstIntroColor,
                    fontSize:  Device.isSmartphone(context) ? 15.sp : 20 ,
                    fontWeight: FontWeight.w500),
              ),
              Text(S.of(context).voirPlus,
                  style: TextStyle(
                      color: kBrownCanyon,
                      fontSize:  Device.isSmartphone(context) ? 15.sp : 20,
                      fontWeight: FontWeight.w700))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Container(
            margin: const  EdgeInsets.symmetric(vertical: 2.0),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                userProvider.getProfileType == doctor &&
                        doctorProvider.getDoctor!.id != null &&
                        startDays != null &&
                        endDay != null
                    ? getListOfUser(
                        startDays, endDay, null, doctorProvider.getDoctor!.id)
                    : Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                            child:
                                Text(S.of(context).aucunRendezvousPourLinstant)),
                      )
              ],
            ))
      ]),
    );
  }

  DevisOFprestataireOfTodyaList() {
    UserProvider userProvider = Provider.of<UserProvider>(context);
   ServiceProviderModelProvider prestataire =
        Provider.of<ServiceProviderModelProvider>(context);
    bool isPrestataire =
        userProvider.getProfileType == serviceProvider ? true : false;

    return Container(
       constraints: BoxConstraints(
            maxWidth: Device.isSmartphone(context) ?  double.infinity : 1000
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.only(top: hv * 2, left: wv * 5, right: wv * 5),
          child: Row(
            children: [
              Text(
               isPrestataire? S.of(context).derniresPrestations: S.of(context).derniresRendezvous,
                style: TextStyle(
                    color: kFirstIntroColor,
                    fontSize:  Device.isSmartphone(context) ?  15.sp : 16 ,
                    fontWeight: FontWeight.w500),
              ),
              Text(S.of(context).voirPlus,
                  style: TextStyle(
                      color: kBrownCanyon,
                      fontSize: Device.isSmartphone(context) ?  15.sp : 16,
                      fontWeight: FontWeight.w700))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 2.0),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                   getPrestataireList(
                        prestataire.getServiceProvider?.id)
                    
              ],
            ))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
     UserProvider userProvider = Provider.of<UserProvider>(context);
    bool isPrestataire =
        userProvider.getProfileType == serviceProvider ? true : false;
    
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        
        decoration: const BoxDecoration(
          color: kBgTextColor,
        ),
        child: Column(
          children: [servicesList(), isPrestataire? DevisOFprestataireOfTodyaList(): patientOfTodyaList()],
        ),
      ),
    );
  }
}
