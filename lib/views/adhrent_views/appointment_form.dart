import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/doctor_info_cards.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:danaid/widgets/streams.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:simple_tags/simple_tags.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentForm extends StatefulWidget {
  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {

  TextEditingController _symptomController = new TextEditingController();
  TextEditingController _hospitalController = new TextEditingController();
  TextEditingController _otherInfoController = new TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey = new GlobalKey();
  PageController controller = PageController(initialPage: 0, keepPage: false);
  String emergencyReason;
  int currentPageValue = 0;
  String purpose;
  List<Widget> pageList;

  String consultationType;
  String reason;
  bool consultationCabinetSelected = false;
  bool consultationVideoSelected = false;
  bool consultationDomicileSelected = false;

  double calendarTextValue = 14.0;
  TextStyle defCalendartextStyle = TextStyle(color: whiteColor, fontWeight: FontWeight.w500, fontSize: 14.0);
  DateTime focusedDay;
  TimeOfDay timePicked;
  DateTime timeSelected;
  bool buttonLoading = false;
  
  String currentSymptomText = "";
  List<String> suggestions = [
    "Migraines",
    "Fatigue",
    "Diarrhée",
    "Fièvre",
    "Maux de tête",
    "Courbatures",
    "Maux de ventre"
  ];
  List<String> symptoms = [];

  @override
  Widget build(BuildContext context) {
    BeneficiaryModelProvider beneficiaryProvider = Provider.of<BeneficiaryModelProvider>(context);
    pageList = <Widget>[
      formLayout(menu()),
      formLayout(beneficiaryProvider.getBeneficiary.matricule != null ? purpose != "emmergency" ? chooseDoctor() : emergencyHospital() : Text("Loading..")),
      formLayout(beneficiaryProvider.getBeneficiary.matricule != null ? schedule() : Text("Loading..")),
      formLayout(beneficiaryProvider.getBeneficiary.matricule != null && focusedDay != null && timeSelected != null ? finalize() : Text("Loading.."))
    ];
    return WillPopScope(
      onWillPop: () async {
        if (currentPageValue == 0)
          Navigator.pop(context);
        else
          controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
        return null;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,), 
            onPressed: (){
              if (currentPageValue == 0)
                Navigator.pop(context);
              else
                controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
            }
          ),
          title: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(purpose != "emmergency" ? "Démander une prise en charge" : "Déclarer une urgence", style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
              Text(purpose != "emmergency" ? currentPageValue == 0 ? "Le guide vous assiste" : currentPageValue == 1 ? "Le guide vous assiste" : currentPageValue == 2 ? "Choisir la date et la période" : "Raison et symptôme" : "Renseignez l'établissement", 
                style: TextStyle(color: kPrimaryColor, fontSize: wv*3.8, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kSouthSeas,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: (){})
          ],
        ),
        body: SafeArea(
          child: Container(
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(currentPageValue == 0 ? "0\n" : currentPageValue == 1 ? purpose != "emmergency" ? "1 / 3\n" : "1 / 2\n" : currentPageValue == 2 ? purpose != "emmergency" ? "2 / 3\n" : "2 / 2\n" : "3 / 3\n", style: TextStyle(fontWeight: FontWeight.w700,color: kBlueDeep),),
              ),
              Expanded(
                child: PageView.builder(
                  pageSnapping: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pageList.length,
                  onPageChanged: (int page) {
                    getChangedPageAndMoveBar(page);
                  },
                  controller: controller,
                  itemBuilder: (context, index) {
                    return pageList[index];
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: hv*3, top: hv*2),
                child: purpose != "emmergency" ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < pageList.length; i++)
                      if (i == currentPageValue) ...[circleBar(true)] else
                        circleBar(false),
                  ],
                ) :
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < (pageList.length - 1); i++)
                      if (i == currentPageValue) ...[circleBar(true)] else
                        circleBar(false),
                  ],
                ),
              ),
            ],),
          ),
        ),
      ),
    );
  }

  Widget menu(){
    BeneficiaryModelProvider beneficiaryProvider = Provider.of<BeneficiaryModelProvider>(context);
    return Padding(
      padding: EdgeInsets.only(bottom: hv*3),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: wv*2),
            decoration: BoxDecoration(
              color: kSouthSeas.withOpacity(0.3),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: hv*2),
              child: BeneficiaryStream(standardUse: false),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: wv*4),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: hv*2.5,),
                    RichText(text: TextSpan(
                      text: "Que souhaitez vous faire?\n",
                      children: [
                        TextSpan(text: "Sélectionner votre choix", style: TextStyle(color: kPrimaryColor, fontSize: wv*3.3)),
                      ], style: TextStyle(color: kPrimaryColor, fontSize: wv*4.5)),
                    ),
                    SizedBox(height: hv*5,),

                    HomePageComponents.appointmentPurpose(
                      enable: beneficiaryProvider.getBeneficiary.matricule != null,
                      title: "Consulter Aujourd'hui",
                      iconPath: 'assets/icons/Two-tone/Home.svg',
                      action: (){
                        purpose = "consult-today";
                        controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                      }
                    ),
                    SizedBox(height: hv*2,),
                    HomePageComponents.appointmentPurpose(
                      enable: beneficiaryProvider.getBeneficiary.matricule != null,
                      title: "Prendre Rendez-vous",
                      iconPath: 'assets/icons/Bulk/CalendarLine.svg',
                      action: (){
                        purpose = "appointment";
                        controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                      }
                    ),
                    SizedBox(height: hv*2,),
                    HomePageComponents.appointmentPurpose(
                      enable: beneficiaryProvider.getBeneficiary.matricule != null,
                      title: "Déclarer une urgence",
                      iconPath: 'assets/icons/Two-tone/Home.svg',
                      action: (){
                        purpose = "emmergency";
                        controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                      }
                    ),
                    SizedBox(height: hv*0.4,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget emergencyHospital(){
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: kSouthSeas.withOpacity(0.3),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          head(),
                          SizedBox(width: wv*2,),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: wv*2.5, vertical: hv*1),
                              decoration: BoxDecoration(
                                color: kSouthSeas.withOpacity(0.5),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(20))
                              ),
                              child: Column(
                                children: [
                                  Text("Appeler la mutuelle", style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600, fontSize: 16),),
                                  SizedBox(height: hv*1,),
                                  Row(children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(color: Colors.grey[600], blurRadius: 2.0, spreadRadius: 1.0, offset: Offset(0, 2))]
                                      ),
                                      child: SvgPicture.asset('assets/icons/Bulk/Calling.svg', color: primaryColor, width: 30,),
                                    ),
                                    SizedBox(width: wv*2,),
                                    Expanded(child: Text("+237 233 419 203", style: TextStyle(color: kTextBlue, fontSize: 17)))
                                  ],),
                                ],
                              )
                              ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: kTextBlue, fontSize: 13),
                            children: [
                              TextSpan(text: "ou - Renseigner l'établissement\n", style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600, fontSize: 17)),
                              TextSpan(text: "Sélectioner le patient")
                            ]
                          )
                        ),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(wv*4),
                  child: CustomTextField(
                    label: "Hôpital de préférence",
                    controller: _hospitalController,
                  ),
                )
              ],
            ),
          ),
        ),
        CustomTextButton(
          enable: consultationType != null,
          text: "Continuer",
          action: (){controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);},
        )
      ],
    );
  }

  Widget chooseDoctor(){
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    DoctorModel doc = doctorProvider.getDoctor;
    return Padding(
      padding: EdgeInsets.only(bottom: hv*2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kSouthSeas.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                head(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1),
                  child: RichText(text: TextSpan(
                    text: "Demander un Rendez-vous chez\n",
                    children: [
                      TextSpan(text: "Sélectionner le médecin", style: TextStyle(fontSize: wv*3.3, fontWeight: FontWeight.w400)),
                    ], style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w600)),
                  ),
                ),
                Container(
                  child: DoctorInfoCard(
                    noPadding: true,
                    avatarUrl: doc.avatarUrl,
                    name: doc.cniName,
                    title: "Medecin de Famille, " + doc.field,
                    speciality: doc.speciality,
                    teleConsultation: doc.serviceList != null ? doc.serviceList["tele-consultation"] : false,
                    consultation: doc.serviceList != null ? doc.serviceList["consultation"] : false,
                    chat: doc.serviceList != null ? doc.serviceList["chat"] : false,
                    rdv: doc.serviceList != null ? doc.serviceList["rdv"] : false,
                    visiteDomicile: doc.serviceList != null ? doc.serviceList["visite-a-domicile"] : false,
                    field: doc.speciality,
                    officeName: doc.officeName,
                    includeHospital: true,
                    distance: adherentProvider.getAdherent.location != null && doc.location != null
                      ? (Algorithms.calculateDistance( adherentProvider.getAdherent.location["latitude"], adherentProvider.getAdherent.location["longitude"], doc.location["latitude"], doc.location["longitude"]).toStringAsFixed(2)).toString() : null,
                    onTap: () {
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2.5),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Choisir le type de consultation", style: TextStyle(color: kBlueDeep, fontWeight: FontWeight.bold, fontSize: 16),),
                    Container(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          HomePageComponents.consultationType(
                            iconPath: 'assets/icons/Bulk/Profile.svg',
                            title: "Consultation",
                            type: "en cabinet",
                            price: "2.000",
                            selected: consultationType == "Cabinet",
                            action: (){
                              setState(() {
                                consultationType = "Cabinet";
                              });
                            }
                          ),
                          HomePageComponents.consultationType(
                            iconPath: 'assets/icons/Bulk/Video.svg',
                            title: "Consultation",
                            type: "Vidéo",
                            price: "2.000",
                            selected: consultationType == "Video",
                            action: (){
                              setState(() {
                                consultationType = "Video";
                              });
                            }
                          ),
                          HomePageComponents.consultationType(
                            iconPath: 'assets/icons/Bulk/Home.svg',
                            title: "Consultation",
                            type: "à domicile",
                            price: "2.000",
                            selected: consultationType == "Domicile",
                            action: (){
                              setState(() {
                                consultationType = "Domicile";
                              });
                            }
                          ),
                        ],),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: wv*4, right: wv*4, top: hv*0.5),
            child: CustomTextButton(
              noPadding: true,
              enable: consultationType != null,
              text: "Continuer",
              action: (){controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);},
            )
          )
        ],
      ),
    );
  }
  Widget schedule(){
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    DoctorModel doc = doctorProvider.getDoctor;
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: kSouthSeas.withAlpha(50),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              head(),
              SizedBox(height: hv*1,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  color: kPrimaryColor,
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 1,
                          blurRadius: 1.5,
                          offset: Offset(0, 2)
                        )]
                      ),
                      child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: doc.avatarUrl == null ? AssetImage("assets/images/avatar-profile.jpg",) : CachedNetworkImageProvider(doc.avatarUrl),
                          radius: 30,
                      ),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dr. ${doc.surname + doc.familyName}", style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w600),),
                          Text("Médecin de Famille, ${doc.field}", style: TextStyle(color: whiteColor.withOpacity(0.6), fontSize: 14),),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: hv*1.3,),
                              Text(doc.officeName.toString(), style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600, fontSize: 16),),
                              Text("Service - ${doc.speciality.toString()}", style: TextStyle(color: whiteColor.withOpacity(0.6), fontSize: 14),),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: kSouthSeas,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  boxShadow: [BoxShadow(color: Colors.grey[400], blurRadius: 2.0, spreadRadius: 1.0, offset: Offset(0,1))]
                ),
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  locale: 'fr_FR',
                  lastDay: DateTime(DateTime.now().year, DateTime.now().month + 3, DateTime.now().day),
                  focusedDay: focusedDay != null ? focusedDay : DateTime.now(),
                  calendarFormat: CalendarFormat.week,
                  daysOfWeekVisible: true,
                  selectedDayPredicate: (date){
                    return isSameDay(focusedDay, date);
                  },
                  onDaySelected: (date1, date2){
                    setState(() {
                      focusedDay = date1;
                    });
                  },
                  calendarStyle:  CalendarStyle(
                    isTodayHighlighted: false,
                    selectedDecoration: BoxDecoration(shape: BoxShape.circle, color: kBlueForce,),
                    rangeStartTextStyle: defCalendartextStyle, 
                    weekendTextStyle: defCalendartextStyle, 
                    defaultTextStyle: defCalendartextStyle, 
                    holidayTextStyle: defCalendartextStyle,
                    outsideTextStyle: defCalendartextStyle,
                    disabledTextStyle: TextStyle(color: kDeepTeal , fontWeight: FontWeight.w700, fontSize: calendarTextValue),
                    todayTextStyle:  TextStyle(color: whiteColor , fontWeight: FontWeight.w900, fontSize: 16)
                  ), 
                  headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      headerMargin: const EdgeInsets.only(left: 18),
                      headerPadding: const EdgeInsets.only(top: 10, bottom: 10),
                      rightChevronVisible: false,
                      leftChevronVisible: false,
                      titleTextStyle:  TextStyle(color: whiteColor, fontWeight: FontWeight.w700, fontSize: 17)),
                  daysOfWeekStyle:  DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: whiteColor, fontWeight: FontWeight.w500,),
                    weekendStyle: TextStyle(color: whiteColor, fontWeight: FontWeight.w500,),
                  ),
                ),
              ),
            
            ],
          ),
        ),
              
        Expanded(child: SingleChildScrollView(
          child: Container(
            child: focusedDay != null ? checkAvailability(DateFormat('EEEE').format(focusedDay)) ? 
              Container(
                margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*4),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Text("Choisir un horaire:", style: TextStyle(color: kBlueDeep, fontWeight: FontWeight.w900, fontSize: 15.5), textAlign: TextAlign.center)),
                    SizedBox(height: hv*1,),
                    GestureDetector(
                      onTap: () async {
                        _selectTime(context);
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*10, vertical: hv*1.5),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            timeSelected != null ? timeSelected.hour.toString().padLeft(2, '0')+" H : "+timeSelected.minute.toString().padLeft(2, '0')+" M" : "Selection"
                            , style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.w900, fontSize: wv*5), textAlign: TextAlign.center, overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              )
              : 
              Container(
                margin: EdgeInsets.symmetric(horizontal: wv*10, vertical: hv*4),
                child: Text("Dr ${doc.familyName} n'est pas disponible les ${DateFormat('EEEE', 'fr_FR').format(focusedDay)}s !", style: TextStyle(color: kBlueDeep, fontWeight: FontWeight.w900, fontSize: 17), textAlign: TextAlign.center)
              )
              : 
              Container(
                margin: EdgeInsets.symmetric(horizontal: wv*10, vertical: hv*4),
                child: Center(child: Text("Choisissez un jour pour le rendez-vous", style: TextStyle(color: kBlueDeep, fontWeight: FontWeight.w900, fontSize: 17), textAlign: TextAlign.center,))
              ),
          ),
        )),
        
        CustomTextButton(
          text: "Continuer",
          enable: focusedDay != null && timeSelected != null,
          action: ()=>controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate),
        ) 
      ],
    );
  }
  Widget finalize(){
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    AdherentModel adherentModel = adherentProvider.getAdherent;
    DoctorModel doc = doctorProvider.getDoctor;
    return Padding(
      padding: EdgeInsets.only(bottom: hv*2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kSouthSeas.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                head(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 6,
                        child: RichText(text: TextSpan(
                          text: "Rendez-vous\n",
                          children: [
                            TextSpan(text: "Dr ${doc.surname} ${doc.familyName}\n", style: TextStyle(fontSize: wv*3.8, fontWeight: FontWeight.w400)),
                            TextSpan(text: "${doc.field}, Médecin de Famille", style: TextStyle(fontSize: wv*3.3, fontWeight: FontWeight.w400)),
                          ], style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: RichText(text: TextSpan(
                          text: DateFormat('EEEE', 'fr_FR').format(focusedDay)+", "+ focusedDay.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(focusedDay)+" "+ focusedDay.year.toString() +"\n",
                          children: [
                            TextSpan(text: timeSelected.hour.toString().padLeft(2, '0')+ "H:"+timeSelected.minute.toString().padLeft(2, '0')+ " à "+ (timeSelected.hour + 1).toString().padLeft(2, '0') + "H:"+timeSelected.minute.toString().padLeft(2, '0'), style: TextStyle(fontSize: wv*3.3, fontWeight: FontWeight.w400)),
                          ], style: TextStyle(color: kPrimaryColor, fontSize: wv*3.6, fontWeight: FontWeight.w600)),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*3.5),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Quelle en est la raison", style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600, fontSize: 16),),
                    SizedBox(height: hv*1.5,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: wv*3),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            icon: Icon(Icons.keyboard_arrow_down_rounded, size: wv*6, color: kPrimaryColor,),
                            isExpanded: true,
                            value: reason,
                            hint: Text("Choisir"),
                            items: [
                              DropdownMenuItem(
                                child: Text("Nouvelle Consultation", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                value: "nouvelle-consultation",
                              ),
                              DropdownMenuItem(
                                child: Text("Suivi", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                value: "suivi",
                              ),
                              DropdownMenuItem(
                                child: Text("Référencement", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                value: "referencement",
                              ),
                              DropdownMenuItem(
                                child: Text("Résultat d'examen", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                value: "resultat-examen",
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                reason = value;
                              });
                            }),
                        ),
                      ),
                    ),
                    SizedBox(height: hv*2.5,),

                    
                    Text("Listez vos symptômes", style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600, fontSize: 16),),
                    SizedBox(height: hv*1.5,),
                    Row(children: [
                    Text("Symptômes", style: TextStyle(fontSize: 16, color: kTextBlue),), SizedBox(width: wv*3,),
                    Expanded(
                      child: Stack(
                        children: [
                          SimpleAutoCompleteTextField(
                            key: autoCompleteKey, 
                            suggestions: suggestions,
                            controller: _symptomController,
                            decoration: defaultInputDecoration(),
                            textChanged: (text) => currentSymptomText = text,
                            clearOnSubmit: false,
                            submitOnSuggestionTap: false,
                            textSubmitted: (text) {
                              if (text != "") {
                                !symptoms.contains(_symptomController.text) ? symptoms.add(_symptomController.text) : print("yo"); 
                              }
                              
                            }
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: (){
                                if (_symptomController.text.isNotEmpty) {
                                setState(() {
                                  !symptoms.contains(_symptomController.text) ? symptoms.add(_symptomController.text) : print("yo");
                                  _symptomController.clear();
                                });
                              }
                              },
                              icon: CircleAvatar(child: Icon(Icons.add, color: whiteColor), backgroundColor: kSouthSeas,),),
                          )
                        ],
                      ),
                    )
                  ],),

                  SizedBox(height: hv*2),

                  SimpleTags(
                    content: symptoms,
                    wrapSpacing: 4,
                    wrapRunSpacing: 4,
                    onTagPress: (tag) {
                      setState(() {
                        symptoms.remove(tag);
                      });
                    },
                    tagContainerPadding: EdgeInsets.all(6),
                    tagTextStyle: TextStyle(color: kPrimaryColor),
                    tagIcon: Icon(Icons.clear, size: wv*3, color: kDeepTeal,),
                    tagContainerDecoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: wv*4, right: wv*4, top: hv*0.5),
            child: !buttonLoading ? CustomTextButton(
              noPadding: true,
              enable: reason != null,
              text: "Terminer",
              action: (){
                DateTime consultationStartDate = DateTime(focusedDay.year, focusedDay.month, focusedDay.day, timeSelected.hour, timeSelected.minute);
                DateTime consultationEndDate = DateTime(focusedDay.year, focusedDay.month, focusedDay.day, timeSelected.hour + 1, timeSelected.minute);
                BeneficiaryModelProvider beneficiary = Provider.of<BeneficiaryModelProvider>(context, listen: false);
                FirebaseFirestore.instance.collection("APPOINTMENTS")
                  .doc(adherentModel.getAdherentId+"-"+DateTime.now().millisecondsSinceEpoch.toString())
                  .set({
                    "adherentId": adherentModel.getAdherentId,
                    "doctorId": doc.id,
                    "beneficiaryId": beneficiary.getBeneficiary.matricule,
                    "doctorName": doc.surname + " " + doc.familyName,
                    "createdDate": DateTime.now(),
                    "enabled": false,
                    "symptoms": symptoms,
                    "title": reason,
                    "appointment-type": purpose,
                    "consultation-type": consultationType,
                    "start-time": consultationStartDate,
                    "end-time": consultationEndDate,
                    "price": 2000,
                    "avatarUrl": beneficiary.getBeneficiary.avatarUrl,
                    "birthDate": beneficiary.getBeneficiary.birthDate,
                    "username":  beneficiary.getBeneficiary.surname+" "+beneficiary.getBeneficiary.familyName,
                    "status" : 0 //En attente
                  }, SetOptions(merge: true)).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Le rendez-vous a bien été enrégistrée'),));
                    setState(() {
                      buttonLoading = false;
                    });
                    Navigator.pop(context);
                  })
                  .catchError((e){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    setState(() {
                      buttonLoading = false;
                    });
                  });
              },
            ) : Center(child: Loaders().buttonLoader(kPrimaryColor))
          )
        ],
      ),
    );
  }
  
  bool checkAvailability (String day){
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    DoctorModel doc = doctorProvider.getDoctor;
    if (doc.availability != null) {
      bool weekAvail = doc.availability["monday to friday"]["available"];
      bool saturdayAvail = doc.availability["saturday"]["available"];
      bool sundayAvail = doc.availability["sunday"]["available"];
      List<String> weekDays = ["Monday","Tuesday","Wednesday","Thursday","Friday"];
      if(weekDays.contains(day)){
        return weekAvail;
      } else if (day == "Saturday"){
        return saturdayAvail;
      } else if (day == "Sunday") {
        return sundayAvail;
      } else {
        return true;
      }
    }

    return true;
  }

  Future<void> _selectTime(BuildContext context) async {
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    DoctorModel doc = doctorProvider.getDoctor;
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: doc.availability["monday to friday"]["start"].toDate().hour, minute: doc.availability["monday to friday"]["start"].toDate().minute), builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );});

    if (picked_s != null && picked_s != TimeOfDay(hour: doc.availability["monday to friday"]["start"].toDate().hour, minute: doc.availability["monday to friday"]["start"].toDate().minute))
      setState(() {
        timePicked = picked_s; //DateTime(2000, 1, 1, picked_s.hour, picked_s.minute);
      });
      print(picked_s.toString());
      checkTimeRange(picked_s);
  }

  checkTimeRange(TimeOfDay time){
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    DoctorModel doc = doctorProvider.getDoctor;

    if (doc.availability != null) {
      String day = DateFormat('EEEE').format(focusedDay);
      List<String> weekDays = ["Monday","Tuesday","Wednesday","Thursday","Friday"];
      if(weekDays.contains(day)){
        TimeOfDay start = TimeOfDay(hour: doc.availability["monday to friday"]["start"].toDate().hour, minute: doc.availability["monday to friday"]["start"].toDate().minute);
        TimeOfDay end = TimeOfDay(hour: doc.availability["monday to friday"]["end"].toDate().hour, minute: doc.availability["monday to friday"]["end"].toDate().minute);
        double timeN = time.hour + time.minute/60;
        double startN = start.hour + start.minute/60;
        double endN = end.hour + end.minute/60;
        if(timeN >= startN && timeN <= endN){
          print(time.toString());
          setState(() {
            timeSelected = DateTime(2000, 1, 1, time.hour, time.minute);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Désolé, cette horaire n'est pas disponible, choisissez en un autre"), duration: Duration(seconds: 4),));
          setState(() {
            timeSelected = null;
          });
        }
      } else if (day == "Saturday"){
        TimeOfDay start = TimeOfDay(hour: doc.availability["saturday"]["start"].toDate().hour, minute: doc.availability["saturday"]["start"].toDate().minute);
        TimeOfDay end = TimeOfDay(hour: doc.availability["saturday"]["end"].toDate().hour, minute: doc.availability["saturday"]["end"].toDate().minute);
        double timeN = time.hour + time.minute/60;
        double startN = start.hour + start.minute/60;
        double endN = end.hour + end.minute/60;
        if(timeN >= startN && timeN <= endN){
          setState(() {
            timeSelected = DateTime(2000, 1, 1, time.hour, time.minute);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Désolé, cette horaire n'est pas disponible, choisissez en un autre"), duration: Duration(seconds: 4),));
          setState(() {
            timeSelected = null;
          });
        }
      } else if (day == "Sunday") {
        TimeOfDay start = TimeOfDay(hour: doc.availability["sunday"]["start"].toDate().hour, minute: doc.availability["sunday"]["start"].toDate().minute);
        TimeOfDay end = TimeOfDay(hour: doc.availability["sunday"]["end"].toDate().hour, minute: doc.availability["sunday"]["end"].toDate().minute);
        double timeN = time.hour + time.minute/60;
        double startN = start.hour + start.minute/60;
        double endN = end.hour + end.minute/60;
        if(timeN >= startN && timeN <= endN){
          setState(() {
            timeSelected = DateTime(2000, 1, 1, time.hour, time.minute);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Désolé, cette horaire n'est pas disponible, choisissez en un autre"), duration: Duration(seconds: 4),));
          setState(() {
            timeSelected = null;
          });
        }
      }
    }
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  Widget formLayout(Widget content){
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: wv*2),
      margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 3.0, spreadRadius: 1.0, offset: Offset(0, 2))]
      ),
      child: content,
    );
  }

  Widget head(){
    BeneficiaryModelProvider beneficiaryProvider = Provider.of<BeneficiaryModelProvider>(context);
    return Container(
      padding: EdgeInsets.only(left: wv*4),
      decoration: BoxDecoration(
        //color: kSouthSeas.withOpacity(0.3),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: hv*1),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pour le patient", style: TextStyle(color: kPrimaryColor, fontSize: wv*4, fontWeight: FontWeight.w900)),
            SizedBox(height: hv*1,),
            Row(children: [
              CircleAvatar(
                backgroundImage: beneficiaryProvider.getBeneficiary.avatarUrl != null ? CachedNetworkImageProvider(beneficiaryProvider.getBeneficiary.avatarUrl) : null,
                backgroundColor: whiteColor,
                radius: wv*6,
                child: beneficiaryProvider.getBeneficiary.avatarUrl != null ? Container() : Icon(LineIcons.user, color: kSouthSeas.withOpacity(0.7), size: wv*10),
              ),
              SizedBox(width: wv*3,),
              RichText(text: TextSpan(
                text: beneficiaryProvider.getBeneficiary.surname + " " +  beneficiaryProvider.getBeneficiary.familyName + "\n",
                children: [
                  TextSpan(text: (DateTime.now().year - beneficiaryProvider.getBeneficiary.birthDate.toDate().year).toString() + " ans", style: TextStyle(fontSize: wv*3.3)),
                ], style: TextStyle(color: kDeepTeal, fontSize: wv*4.2)),
              ),
            ],),
            SizedBox(height: hv*0.5,)
          ],
        ),
      ),
    );
  }
  
  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 10 : 6,
      width: isActive ? 10 : 6,
      decoration: BoxDecoration(
          color: isActive ? kDeepTeal : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}