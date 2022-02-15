import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/providers/doctorModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/doctor_info_cards.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:danaid/widgets/drawer.dart';
import 'package:danaid/widgets/forms/form_widget.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:danaid/widgets/streams.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:simple_tags/simple_tags.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/date_symbol_data_local.dart';

class AppointmentForm extends StatefulWidget {
  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _symptomController = new TextEditingController();
  TextEditingController _hospitalController = new TextEditingController();
  TextEditingController _otherInfoController = new TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey = new GlobalKey();
  PageController controller = PageController(initialPage: 0, keepPage: false);
  String? emergencyReason;
  int currentPageValue = 0;
  String? purpose;
  List<Widget>? pageList;

  double tarif = 2000.0;

  String? consultationType;
  String? reason;
  bool consultationCabinetSelected = false;
  bool consultationVideoSelected = false;
  bool consultationDomicileSelected = false;

  String? _emergencyPurpose;

  double calendarTextValue = 14.0;
  TextStyle defCalendartextStyle = TextStyle(color: whiteColor, fontWeight: FontWeight.w500, fontSize: 14.0);
  DateTime? focusedDay;
  TimeOfDay? timePicked;
  DateTime? timeSelected;
  bool buttonLoading = false;
  
  String currentSymptomText = "";
  List<String> suggestions = [
    S.current.migraines,
    S.current.fatigue,
    S.current.diarrhe,
    S.current.fivre,
    S.current.mauxDeTte,
    S.current.courbatures,
    S.current.mauxDeVentre
  ];
  List<String> symptoms = [];

  GoogleMapController? mapController;

  final LatLng _center = const LatLng(4.044656688777058, 9.695724531228858);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  bool noFamilyDoctor = false;

  List<TimeOfDay> bookedSchedule = [];

  loadInfos(){
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    AdherentModelProvider adherent = Provider.of<AdherentModelProvider>(context, listen: false);
    if(doctorProvider.getDoctor == null){}
    if(adherent.getAdherent?.familyDoctorId != null){
      FirebaseFirestore.instance.collection("MEDECINS").doc(adherent.getAdherent?.familyDoctorId).get().then((doc) {
        DoctorModel doctorModel = DoctorModel.fromDocument(doc);
        doctorProvider.setDoctorModel(doctorModel);
        chosenDoctor = doctorModel;
        setState((){});
      });
    } else {
      setState(() {
        noFamilyDoctor = true;
      });
    }
    
  }

  Map todayDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy', 'fr_FR');
    String formattedTime = DateFormat('kk:mm:a', 'fr_FR').format(now);
    String formattedDate = formatter.format(now);
    print(formattedTime);
    print(formattedDate);

    return {
      "date": formattedDate,
      "time": formattedTime
    };
  }

  QuerySnapshot? searchSnapshot;
  Future<QuerySnapshot>? futureSearchResults;
  TextEditingController _searchController = new TextEditingController();
  bool searchDoc = true;
  ServiceProviderModel? chosenSP;
  DoctorModel? chosenDoctor;

  @override
  void initState() {
    loadInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context);
    BeneficiaryModelProvider beneficiaryProvider = Provider.of<BeneficiaryModelProvider>(context);
    BottomAppBarControllerProvider bottomController = Provider.of<BottomAppBarControllerProvider>(context);
    DoctorModel? doc = doctorProvider.getDoctor;
    
    pageList = <Widget>[
      formLayout(menu()),
      formLayout(beneficiaryProvider.getBeneficiary.matricule != null ? purpose != "emergency" ? doc != null ? chooseDoctor(doc) : Text("Aucun médecin de famille") : emergencyHospital() : Text("Loading..")),
      formLayout(beneficiaryProvider.getBeneficiary.matricule != null ? purpose == "emergency" ? emergencyComplete() :  doc != null ? schedule() : Text("Aucun médecin de famille") : Text("Loading..")),
      formLayout(beneficiaryProvider.getBeneficiary.matricule != null && focusedDay != null && timeSelected != null ? finalize() : Text("Loading.."))
    ];
    return WillPopScope(
      onWillPop: () async {
        if (purpose != "consult-today"){
          if (currentPageValue == 0)
            Navigator.pop(context);
          else
            controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
        else if((purpose == "consult-today") && controller.page == 3) {
          controller.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
        else {Navigator.pop(context);}
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,), 
            onPressed: (){
              if (purpose != "consult-today"){
                if (currentPageValue == 0)
                  Navigator.pop(context);
                else
                  controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
              }
              else if((purpose == "consult-today") && controller.page == 3) {
                controller.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
              }
              else {Navigator.pop(context);}
            }
          ),
          title: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(purpose != "emergency" ? S.of(context).dmanderUnePriseEnCharge : S.of(context).dclarerUneUrgence, style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
              Text(purpose != "emergency" ? currentPageValue == 0 ? S.of(context).leGuideVousAssiste : currentPageValue == 1 ? S.of(context).leGuideVousAssiste : currentPageValue == 2 ? S.of(context).choisirLaDateEtLaPriode : S.of(context).raisonEtSymptme : S.of(context).renseignezLtablissement, 
                style: TextStyle(color: kPrimaryColor, fontSize: wv*3.8, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kSouthSeas,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: () => _scaffoldKey.currentState?.openEndDrawer())
          ],
        ),
        endDrawer: DefaultDrawer(
          entraide: (){Navigator.pop(context); Navigator.pop(context);},
          accueil: (){Navigator.pop(context); Navigator.pop(context);},
          carnet: (){Navigator.pop(context); Navigator.pop(context);},
          partenaire: (){Navigator.pop(context); Navigator.pop(context);},
          famille: (){Navigator.pop(context); Navigator.pop(context);},
        ),
        body: !noFamilyDoctor ? doctorProvider.getDoctor != null ? SafeArea(
          child: Container(
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(currentPageValue == 0 ? "0\n" : currentPageValue == 1 ? purpose != "emergency" ? "1 / 3\n" : "1 / 2\n" : currentPageValue == 2 ? purpose != "emergency" ? "2 / 3\n" : "2 / 2\n" : "3 / 3\n", style: TextStyle(fontWeight: FontWeight.w700,color: kBlueDeep),),
              ),
              Expanded(
                child: PageView.builder(
                  pageSnapping: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pageList?.length,
                  onPageChanged: (int page) {
                    getChangedPageAndMoveBar(page);
                  },
                  controller: controller,
                  itemBuilder: (context, index) {
                    return pageList![index];
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: hv*3, top: hv*2),
                child: purpose != "emergency" ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < pageList!.length; i++)
                      if (i == currentPageValue) ...[circleBar(true)] else
                        circleBar(false),
                  ],
                ) :
                purpose != "consult-today" ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < (pageList!.length - 1); i++)
                      if (i == currentPageValue) ...[circleBar(true)] else
                        circleBar(false),
                  ],
                ) : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < (pageList!.length - 2); i++)
                      if (i == currentPageValue) ...[circleBar(true)] else
                        circleBar(false),
                  ],
                ),
              ),
            ],),
          ),
        ) : Center(child: Loaders().buttonLoader(kPrimaryColor))
        : Center(child: Padding(
          padding: const EdgeInsets.all(12),
          child: CustomTextButton(text: S.of(context).choisissezUnMedecinDeFamille, action: (){bottomController.setIndex(3);Navigator.pop(context);},),
        )),
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
                      text: S.of(context).queSouhaitezVousFairen,
                      children: [
                        TextSpan(text: S.of(context).slectionnerVotreChoix, style: TextStyle(color: kPrimaryColor, fontSize: wv*3.3)),
                      ], style: TextStyle(color: kPrimaryColor, fontSize: wv*4.5)),
                    ),
                    SizedBox(height: hv*5,),

                    HomePageComponents.appointmentPurpose(
                      enable: beneficiaryProvider.getBeneficiary.matricule != null,
                      title: S.of(context).consulterAujourdhui,
                      iconPath: 'assets/icons/Two-tone/Home.svg',
                      action: (){
                        purpose = "consult-today";
                        DateTime now = DateTime.now();
                        setState(() {
                          focusedDay = DateTime(now.year, now.month, now.day);
                          timeSelected = DateTime(now.year, now.month, now.day, 8, 0);
                        });
                        controller.animateToPage(3, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                        //controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                      }
                    ),
                    SizedBox(height: hv*2,),
                    HomePageComponents.appointmentPurpose(
                      enable: beneficiaryProvider.getBeneficiary.matricule != null,
                      title: S.of(context).prendreRendezvous,
                      iconPath: 'assets/icons/Bulk/CalendarLine.svg',
                      action: (){
                        purpose = "appointment";
                        controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                      }
                    ),
                    SizedBox(height: hv*2,),
                    HomePageComponents.appointmentPurpose(
                      enable: beneficiaryProvider.getBeneficiary.matricule != null,
                      title: S.of(context).dclarerUneUrgence,
                      iconPath: 'assets/icons/Bulk/BuyRdv.svg',
                      action: (){
                        purpose = "emergency";
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
                          Expanded(child: head()),
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
                                  Text(S.of(context).appelerLaMutuelle, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600, fontSize: 16),),
                                  SizedBox(height: hv*1,),
                                  GestureDetector(
                                    onTap: () async {
                                      String url = S.of(context).tel+"+237233419203";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Row(children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [BoxShadow(color: Colors.grey[600]!, blurRadius: 2.0, spreadRadius: 1.0, offset: Offset(0, 2))]
                                        ),
                                        child: SvgPicture.asset('assets/icons/Bulk/Calling.svg', color: primaryColor, width: 25,),
                                      ),
                                      SizedBox(width: wv*2,),
                                      Expanded(child: Text("+237 233 419 203", style: TextStyle(color: kTextBlue, fontSize: 14)))
                                    ],),
                                  ),
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
                              TextSpan(text: S.of(context).ouRenseignerLtablissementn, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600, fontSize: 17)),
                              TextSpan(text: S.of(context).slectionerLePatient)
                            ]
                          )
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: hv*25,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                  ),
                ),
                SizedBox(height: hv*1.5,),
                /*Row(children: [
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: whiteColor.withOpacity(0.6),
                        prefixIcon: Icon(Icons.search, color: kSouthSeas,),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: kSouthSeas.withOpacity(0.7)),
                          borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: kSouthSeas.withOpacity(0.7)),
                          borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        hintText: "Rechercher",
                        hintStyle: TextStyle(color: kSouthSeas)
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  TextButton(onPressed: (){},
                    child: Text("Annuler", style: TextStyle(color: kSouthSeas),)
                  ),

                ],),*/

                Padding(
                  padding: EdgeInsets.all(wv*3),
                  child: CustomTextField(
                    noPadding: true,
                    onChanged: (val)=>setState((){}),
                    label: S.of(context).hpitalDePrfrence,
                    controller: _hospitalController,
                  ),
                )
              ],
            ),
          ),
        ),
        CustomTextButton(
          enable: _hospitalController.text.isNotEmpty,
          text: S.of(context).continuer,
          action: (){controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);},
        )
      ],
    );
  }

  Widget emergencyComplete(){
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
                      head(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(color: kTextBlue, fontSize: 17),
                                  children: [
                                    TextSpan(text: S.of(context).urgenceN, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
                                    TextSpan(text: _hospitalController.text),
                                    //TextSpan(text: "LogPom, Douala", style: TextStyle(fontSize: 14)),
                                  ]
                                )
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(todayDate()["date"], textAlign: TextAlign.end, style: TextStyle(color: kTextBlue, fontSize: 13, fontWeight: FontWeight.w700)),
                                    Text(todayDate()["time"], textAlign: TextAlign.end, style: TextStyle(color: kTextBlue, fontSize: 13))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: wv*4.5, vertical: hv*2),
                  child: Column(
                    children: [
                      SizedBox(height: hv*2),
                      CustomDropDownButton(
                        label: S.of(context).quelleEstLaRaison,
                        value: _emergencyPurpose,
                        items: [
                          DropdownMenuItem(child: Text(S.of(context).accidentDomestique, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)), value: "A-DOMESTIQUE",),
                          DropdownMenuItem(child: Text(S.of(context).accidentRoutier, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),), value: "A-ROUTIER",),
                          DropdownMenuItem(child: Text(S.of(context).maladieSubite, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),), value: "MALADIE",),
                          DropdownMenuItem(child: Text(S.of(context).autre, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),), value: "AUTRE",)
                        ],
                        onChanged: (value) => setState(() {_emergencyPurpose = value;})
                      ),

                      SizedBox(height: hv*2),

                      CustomTextField(
                        label: S.of(context).informationSupplmentaire,
                        controller: _otherInfoController,
                        onChanged: (val)=>setState((){}),
                        noPadding: true,
                        multiLine: true,
                        minLines: 4,
                        maxLines: 7,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        CustomTextButton(
          enable: _emergencyPurpose != null,
          text: S.of(context).continuer,
          isLoading: buttonLoading,
          action: (){
            setState((){buttonLoading = true;});
            AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
            DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
            DoctorModel? doc = doctorProvider.getDoctor;
            AdherentModel? adherentModel = adherentProvider.getAdherent;
            BeneficiaryModelProvider beneficiary = Provider.of<BeneficiaryModelProvider>(context, listen: false);
            FirebaseFirestore.instance.collection("USECASES")
              .add({
                "adherentId": adherentModel?.getAdherentId,
                "beneficiaryId": beneficiary.getBeneficiary.matricule,
                "otherInfo": _otherInfoController.text,
                "establishment": _hospitalController.text,
                "createdDate": DateTime.now(),
                "title": _emergencyPurpose,
                "type": purpose,
                "beneficiaryName":  beneficiary.getBeneficiary.surname!+" "+beneficiary.getBeneficiary.familyName!,
                "status" : 0 //En attente
              }).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).lurgenceABienTEnrgistre),));
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
        )
      ],
    );
  }

  Widget chooseDoctor(DoctorModel doc){
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(bottom: hv*2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
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
                            text: S.of(context).demanderUnRendezvousChezn,
                            children: [
                              TextSpan(text: S.of(context).slectionnerLeMdecin, style: TextStyle(fontSize: wv*3.3, fontWeight: FontWeight.w400)),
                            ], style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        Container(
                          child: chosenDoctor != null ? DoctorInfoCard(
                            noPadding: true,
                            avatarUrl: chosenDoctor?.avatarUrl,
                            name: chosenDoctor?.cniName,
                            title: S.of(context).medecinDeFamille + chosenDoctor!.field!,
                            speciality: chosenDoctor?.speciality,
                            teleConsultation: chosenDoctor?.serviceList != null ? chosenDoctor?.serviceList["tele-consultation"] : false,
                            consultation: chosenDoctor?.serviceList != null ? chosenDoctor?.serviceList["consultation"] : false,
                            chat: chosenDoctor?.serviceList != null ? chosenDoctor?.serviceList["chat"] : false,
                            rdv: chosenDoctor?.serviceList != null ? chosenDoctor?.serviceList["rdv"] : false,
                            visiteDomicile: chosenDoctor?.serviceList != null ? chosenDoctor?.serviceList["visite-a-domicile"] : false,
                            field: chosenDoctor?.speciality,
                            officeName: chosenDoctor?.officeName,
                            includeHospital: true,
                            distance: adherentProvider.getAdherent?.location?["latitude"] != null && chosenDoctor?.location?["latitude"] != null
                              ? (Algorithms.calculateDistance( adherentProvider.getAdherent?.location?["latitude"], adherentProvider.getAdherent?.location?["longitude"], chosenDoctor?.location?["latitude"], chosenDoctor?.location?["longitude"]).toStringAsFixed(2)).toString() : null,
                            onTap: () {
                              showModalBottomSheet(
                                context: context, 
                                builder: (BuildContext bc){
                                  return SafeArea(
                                    child: Container(
                                      child: new Wrap(
                                        children: <Widget>[
                                          ListTile(
                                            contentPadding: EdgeInsets.symmetric(vertical: hv*0, horizontal: wv*3),
                                            leading: Icon(LineIcons.doctor, size: 45, color: kDeepTeal,),
                                            title: new Text('Médecin', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600),),
                                            subtitle: Text("Voir un médecin"),
                                            onTap: searchPartners
                                          ),
                                          ListTile(
                                            contentPadding: EdgeInsets.symmetric(vertical: hv*0, horizontal: wv*3),
                                            leading: Icon(LineIcons.hospital, size: 40, color: kDeepTeal),
                                            title: new Text('Prestataire', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600),),
                                            subtitle: Text("Voir un prestataire"),
                                            onTap: ()=>searchPartners(isDoctor: false)
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              );
                            },
                          ) 
                          : chosenSP != null ? 
                            DoctorInfoCard(
                              noPadding: true,
                              avatarUrl: chosenSP?.avatarUrl,
                              name: chosenSP?.contactName,
                              title: S.of(context).medecinDeFamille + chosenSP!.contactName!,
                              isServiceProvider: true,
                              speciality: chosenSP?.category,
                              teleConsultation: false,
                              consultation: false,
                              chat: false,
                              rdv: false,
                              visiteDomicile: false,
                              field: "",
                              officeName: "",
                              includeHospital: true,
                              distance: adherentProvider.getAdherent?.location?["latitude"] != null && chosenSP?.coordGps != null
                                ? (Algorithms.calculateDistance( adherentProvider.getAdherent?.location?["latitude"], adherentProvider.getAdherent?.location?["longitude"], chosenSP?.coordGps?["latitude"], chosenSP?.coordGps?["longitude"]).toStringAsFixed(2)).toString() : null,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context, 
                                  builder: (BuildContext bc){
                                    return SafeArea(
                                      child: Container(
                                        child: new Wrap(
                                          children: <Widget>[
                                            ListTile(
                                              contentPadding: EdgeInsets.symmetric(vertical: hv*0, horizontal: wv*3),
                                              leading: Icon(LineIcons.doctor, size: 45, color: kDeepTeal,),
                                              title: new Text('Médecin', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600),),
                                              subtitle: Text("Voir un médecin"),
                                              onTap: searchPartners
                                            ),
                                            ListTile(
                                              contentPadding: EdgeInsets.symmetric(vertical: hv*0, horizontal: wv*3),
                                              leading: Icon(LineIcons.hospital, size: 40, color: kDeepTeal),
                                              title: new Text('Prestataire', style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600),),
                                              subtitle: Text("Voir un prestataire"),
                                              onTap: ()=>searchPartners(isDoctor: false)
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                );
                              },
                            )
                          : Container(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2.5),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).choisirLeTypeDeConsultation, style: TextStyle(color: kBlueDeep, fontWeight: FontWeight.bold, fontSize: 16),),
                        Container(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              HomePageComponents.consultationType(
                                iconPath: 'assets/icons/Bulk/Profile.svg',
                                title: S.of(context).consultation,
                                type: S.of(context).enCabinet,
                                price: doc.rate != null ? doc.rate!["public"].toString() : "2000.0",
                                selected: consultationType == "Cabinet",
                                action: (){
                                  setState(() {
                                    consultationType = "Cabinet";
                                    tarif = doc.rate != null ? doc.rate!["public"] : 2000.0;
                                  });
                                }
                              ),
                              HomePageComponents.consultationType(
                                iconPath: 'assets/icons/Bulk/Video.svg',
                                title: "Consultation",
                                type: "Vidéo",
                                price: doc.rate != null ? doc.rate!["public"].toString() : "2000.0",
                                selected: consultationType == "Video",
                                action: (){
                                  setState(() {
                                    consultationType = "Video";
                                  });
                                }
                              ),
                              HomePageComponents.consultationType(
                                iconPath: 'assets/icons/Bulk/Home.svg',
                                title: S.of(context).consultation,
                                type: S.of(context).domicile,
                                price: "7500.0",
                                selected: consultationType == "Domicile",
                                action: (){
                                  setState(() {
                                    consultationType = "Domicile";
                                    tarif = 7500.0;
                                  });
                                }
                              ),
                            ],),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: wv*4, right: wv*4, top: hv*0.5),
            child: CustomTextButton(
              noPadding: true,
              enable: consultationType != null,
              text: S.of(context).continuer,
              action: (){controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);},
            )
          )
        ],
      ),
    );
  }

  searchPartners({bool isDoctor = true}){
    showDialog(context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.symmetric(horizontal: wv*3),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: hv*80,
                  width: wv*90,
                  padding: EdgeInsets.symmetric(horizontal: wv*2,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(children: [
                    SizedBox(height: hv*2,),
                    //Text(message.data['body'], style: TextStyle(color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.w700),),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),

                      // TextField
                      child: TextField(
                        autofocus: true,
                        controller: _searchController,
                        onChanged: (val) => setState((){}),
                        cursorColor: kPrimaryColor,
                        style: TextStyle(color: kPrimaryColor),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)), borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)), borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)), borderRadius: BorderRadius.circular(10)),
                          hintText: S.of(context).entrezLeNom,
                          filled: true,
                          contentPadding: EdgeInsets.only(bottom: 12, left: 15, right: 15),
                          suffixIcon: IconButton(icon: Icon(Icons.cancel, color: Colors.white,), onPressed: () => _searchController.clear(),),
                        ),
                      ),
                    ),
                    SizedBox(height: hv*2),
                    (_searchController.text.isNotEmpty)
                      ? Expanded(
                          child: searchResults(isDoctor: isDoctor))
                      : Expanded(child: noUsers(context)),
                    SizedBox(height: hv*2),
                    CustomTextButton(
                      text: "Fermer",
                      color: kPrimaryColor,
                      action: ()=>Navigator.pop(context),
                    )
                    
                  ], mainAxisAlignment: MainAxisAlignment.start, ),
                ),
              ],
            ),
          );
        });
      }
    );
  }

  searchResults({bool isDoctor = true}) {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    var query = isDoctor ? FirebaseFirestore.instance.collection("MEDECINS").where("nameKeywords", arrayContains: _searchController.text.toLowerCase()).where("profilEnabled", isEqualTo: true).snapshots() : FirebaseFirestore.instance.collection("PRESTATAIRE").where("nameKeywords", arrayContains: _searchController.text.toLowerCase()).where("profilEnabled", isEqualTo: true).snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: query,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        int lastIndex = snapshot.data!.docs.length - 1;
        return snapshot.data!.docs.length >= 1 ? ListView.builder(
          //shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            DoctorModel? doctor = isDoctor ? DoctorModel.fromDocument(doc) : null;
            ServiceProviderModel? sp = !isDoctor ? ServiceProviderModel.fromDocument(doc) : null;

            return Padding(
              padding: EdgeInsets.only(bottom: lastIndex == index ? hv * 10 : 0),
              child: isDoctor ? DoctorInfoCard(
                actionText: "Choisir",
                avatarUrl: doctor?.avatarUrl,
                name: doctor?.cniName,
                title: S.of(context).medecinDeFamille + doctor!.field!,
                speciality: doctor.speciality,
                teleConsultation: doctor.serviceList != null ? doctor.serviceList["tele-consultation"] : false,
                consultation: doctor.serviceList != null ? doctor.serviceList["consultation"] : false,
                chat: doctor.serviceList != null ? doctor.serviceList["chat"] : false,
                rdv: doctor.serviceList != null ? doctor.serviceList["rdv"] : false,
                visiteDomicile: doctor.serviceList != null ? doctor.serviceList["visite-a-domicile"] : false,
                distance: 
                  adherentProvider.getAdherent?.location?["latitude"] != null && doctor.location?["latitude"] != null
                    ? (Algorithms.calculateDistance( adherentProvider.getAdherent?.location?["latitude"], adherentProvider.getAdherent?.location?["longitude"], doctor.location?["latitude"], doctor.location?["longitude"]).toStringAsFixed(2)).toString() : null
                ,
                onTap: () {
                  chosenSP = null;
                  chosenDoctor = doctor;
                  Navigator.pop(context);
                  Navigator.pop(context);
                  setState((){});
                },
              )
              :
              DoctorInfoCard(
                actionText: "Choisir",
                avatarUrl: sp?.avatarUrl,
                isServiceProvider: true,
                name: sp?.name.toString(),
                title: sp?.contactName.toString(),
                speciality: sp?.category.toString(),
                teleConsultation: false,
                consultation: false,
                chat: false,
                rdv: false,
                visiteDomicile: false,
                distance: adherentProvider.getAdherent?.location?["latitude"] != null && sp?.coordGps != null
                    ? (Algorithms.calculateDistance( adherentProvider.getAdherent?.location?["latitude"], adherentProvider.getAdherent?.location?["longitude"], sp?.coordGps?["latitude"], sp?.coordGps?["longitude"]).toStringAsFixed(2)).toString() : null,
                onTap: () {
                  chosenSP = sp;
                  chosenDoctor = null;
                  Navigator.pop(context);
                  Navigator.pop(context);
                  setState((){});
                },
              ),
            );
          }) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Icon(MdiIcons.databaseRemove, color: kPrimaryColor.withOpacity(0.7), size: 85,),
              SizedBox(height: 5,),
              Text(S.of(context).aucunMdecinAvecPourNom+":\n \"${_searchController.text}\"", 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kPrimaryColor )
              , textAlign: TextAlign.center,),
            ],
          ),
        );
      },
    );
  }

  Widget noUsers(context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: hv*5,),
            Hero(
              tag: "search",
              child: Icon(
                LineIcons.search,
                size: 70,
                color: kPrimaryColor,
              ),
            ),
            Text(
              "Autres partenaires DanAid",
              style: TextStyle(fontSize: 17, color: kPrimaryColor, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }

  Widget schedule(){
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context);
    DoctorModel? doc = doctorProvider.getDoctor;
    List<DateTime> dates = [];
    if(doc!.planning != null){
      for(int i = 0; i < doc.planning!.length; i++){
        dates.add(doc.planning?[i]['date'].toDate());
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: SingleChildScrollView(
          child: Column(
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
                                backgroundImage: doc.avatarUrl == null ? AssetImage("assets/images/avatar-profile.jpg",) : CachedNetworkImageProvider(doc.avatarUrl!) as ImageProvider,
                                radius: 30,
                            ),
                          ),
                          SizedBox(width: 8,),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dr. ${doc.surname! + doc.familyName!}", style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w600),),
                                Text(S.of(context).mdecinDeFamille+" ${doc.field}", style: TextStyle(color: whiteColor.withOpacity(0.6), fontSize: 14),),
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: hv*1.3,),
                                    Text(doc.officeName.toString(), style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600, fontSize: 16),),
                                    Text( S.of(context).service+" - ${doc.speciality.toString()}", style: TextStyle(color: whiteColor.withOpacity(0.6), fontSize: 14),),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
                
              Container(
                decoration: BoxDecoration(
                  color: kSouthSeas,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  boxShadow: [BoxShadow(color: Colors.grey[400]!, blurRadius: 2.0, spreadRadius: 1.0, offset: Offset(0,1))]
                ),
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  locale: 'fr_FR',
                  lastDay: DateTime(DateTime.now().year, DateTime.now().month + 3, DateTime.now().day),
                  focusedDay: focusedDay != null ? focusedDay! : DateTime.now(),
                  calendarFormat: CalendarFormat.week,
                  daysOfWeekVisible: true,
                  selectedDayPredicate: (date){
                    return isSameDay(focusedDay, date);
                  },
                  onDaySelected: (date1, date2){
                    bookedSchedule = [];
                    List<TimeOfDay> times = [];
                    for (int t = 0; t < dates.length; t++){
                      if(DateTime(date1.year, date1.month, date1.day) == DateTime(dates[t].year, dates[t].month, dates[t].day)){
                        times.add(TimeOfDay(hour: dates[t].hour, minute: dates[t].minute));
                      }
                    }
                    for (int u = 0; u < times.length; u++){
                      int s = 0;
                      for (int v = 0; v < times.length; v++){
                        if(times[u] == times[v]){
                          s = s+1;
                        }
                      }
                      if(s>=4){
                        bookedSchedule.add(TimeOfDay(hour: times[u].hour, minute: times[u].minute));
                      }
                    }
                    setState(() {
                      focusedDay = date1;
                      if(checkAvailability(DateFormat('EEEE', 'en_US').format(focusedDay!)) == false){
                        timeSelected = null;
                        timePicked = null;
                      }
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
            
              Container(
                child: focusedDay != null ? 
                /*checkAvailability(DateFormat('EEEE').format(focusedDay)) ? 
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*4),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: Text(S.of(context).choisirUnHoraire, style: TextStyle(color: kBlueDeep, fontWeight: FontWeight.w900, fontSize: 15.5), textAlign: TextAlign.center)),
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
                                timeSelected != null ? timeSelected.hour.toString().padLeft(2, '0')+" H : "+timeSelected.minute.toString().padLeft(2, '0')+" M" : S.of(context).selection
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
                    child: Text("Dr ${doc.familyName} "+S.of(context).nestPasDisponibleLes+" ${DateFormat('EEEE', 'fr_FR').format(focusedDay)}s !", style: TextStyle(color: kBlueDeep, fontWeight: FontWeight.w900, fontSize: 17), textAlign: TextAlign.center)
                  )*/
                  checkAvailability(DateFormat('EEEE', 'en_US').format(focusedDay!)) ? Column(
                    children: [
                      SizedBox(height: hv*3,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getTimeRangeBox(
                            time: TimeOfDay(hour: 8, minute: 0),
                            enable: checkTimeAvailability(TimeOfDay(hour: 8, minute: 0)) && !bookedSchedule.contains(TimeOfDay(hour: 8, minute: 0)),
                            selected: timePicked == TimeOfDay(hour: 8, minute: 0),
                            onSelect: ()=>setState((){timePicked = TimeOfDay(hour: 8, minute: 0); focusedDay = DateTime(focusedDay!.year, focusedDay!.month, focusedDay!.day, 8, 0); timeSelected = DateTime(2000, 1, 1, 8, 0); })
                          ),
                          SizedBox(width: wv*10,),
                          getTimeRangeBox(
                            time: TimeOfDay(hour: 9, minute: 0),
                            enable: checkTimeAvailability(TimeOfDay(hour: 9, minute: 0)) && !bookedSchedule.contains(TimeOfDay(hour: 9, minute: 0)),
                            selected: timePicked == TimeOfDay(hour: 9, minute: 0),
                            onSelect: ()=>setState((){timePicked = TimeOfDay(hour: 9, minute: 0); focusedDay = DateTime(focusedDay!.year, focusedDay!.month, focusedDay!.day, 9, 0); timeSelected = DateTime(2000, 1, 1, 9, 0); })
                          )
                        ],
                      ),
                      SizedBox(height: hv*1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getTimeRangeBox(
                            time: TimeOfDay(hour: 10, minute: 0),
                            enable: checkTimeAvailability(TimeOfDay(hour: 10, minute: 0)) && !bookedSchedule.contains(TimeOfDay(hour: 10, minute: 0)),
                            selected: timePicked == TimeOfDay(hour: 10, minute: 0),
                            onSelect: ()=>setState((){timePicked = TimeOfDay(hour: 10, minute: 0); focusedDay = DateTime(focusedDay!.year, focusedDay!.month, focusedDay!.day, 10, 0); timeSelected = DateTime(2000, 1, 1, 10, 0); })
                          ),
                          SizedBox(width: wv*10,),
                          getTimeRangeBox(
                            time: TimeOfDay(hour: 11, minute: 0),
                            enable: checkTimeAvailability(TimeOfDay(hour: 11, minute: 0)) && !bookedSchedule.contains(TimeOfDay(hour: 11, minute: 0)),
                            selected: timePicked == TimeOfDay(hour: 11, minute: 0),
                            onSelect: ()=>setState((){timePicked = TimeOfDay(hour: 11, minute: 0); focusedDay = DateTime(focusedDay!.year, focusedDay!.month, focusedDay!.day, 11, 0); timeSelected = DateTime(2000, 1, 1, 11, 0); })
                          )
                        ],
                      ),
                      SizedBox(height: hv*1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getTimeRangeBox(
                            time: TimeOfDay(hour: 12, minute: 0),
                            enable: checkTimeAvailability(TimeOfDay(hour: 12, minute: 0)) && !bookedSchedule.contains(TimeOfDay(hour: 12, minute: 0)),
                            selected: timePicked == TimeOfDay(hour: 12, minute: 0),
                            onSelect: ()=>setState((){timePicked = TimeOfDay(hour: 12, minute: 0); focusedDay = DateTime(focusedDay!.year, focusedDay!.month, focusedDay!.day, 12, 0); timeSelected = DateTime(2000, 1, 1, 12, 0); })
                          ),
                          SizedBox(width: wv*10,),
                          getTimeRangeBox(
                            time: TimeOfDay(hour: 13, minute: 0),
                            enable: checkTimeAvailability(TimeOfDay(hour: 13, minute: 0)) && !bookedSchedule.contains(TimeOfDay(hour: 13, minute: 0)),
                            selected: timePicked == TimeOfDay(hour: 13, minute: 0),
                            onSelect: ()=>setState((){timePicked = TimeOfDay(hour: 13, minute: 0); focusedDay = DateTime(focusedDay!.year, focusedDay!.month, focusedDay!.day, 13, 0); timeSelected = DateTime(2000, 1, 1, 13, 0); })
                          )
                        ],
                      ),
                      SizedBox(height: hv*1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getTimeRangeBox(
                            time: TimeOfDay(hour: 14, minute: 0),
                            enable: checkTimeAvailability(TimeOfDay(hour: 14, minute: 0)) && !bookedSchedule.contains(TimeOfDay(hour: 14, minute: 0)),
                            selected: timePicked == TimeOfDay(hour: 14, minute: 0),
                            onSelect: ()=>setState((){timePicked = TimeOfDay(hour: 14, minute: 0); focusedDay = DateTime(focusedDay!.year, focusedDay!.month, focusedDay!.day, 14, 0); timeSelected = DateTime(2000, 1, 1, 14, 0); })
                          ),
                          SizedBox(width: wv*10,),
                          getTimeRangeBox(
                            time: TimeOfDay(hour: 15, minute: 0),
                            enable: checkTimeAvailability(TimeOfDay(hour: 15, minute: 0)) && !bookedSchedule.contains(TimeOfDay(hour: 15, minute: 0)),
                            selected: timePicked == TimeOfDay(hour: 15, minute: 0),
                            onSelect: ()=>setState((){timePicked = TimeOfDay(hour: 15, minute: 0); focusedDay = DateTime(focusedDay!.year, focusedDay!.month, focusedDay!.day, 15, 0); timeSelected = DateTime(2000, 1, 1, 15, 0); })
                          )
                        ],
                      ),
                    ],
                  ): 
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: wv*10, vertical: hv*4),
                    child: Text("Dr ${doc.familyName} "+S.of(context).nestPasDisponibleLes+" ${DateFormat('EEEE', 'fr_FR').format(focusedDay!)}s !", style: TextStyle(color: kBlueDeep, fontWeight: FontWeight.w900, fontSize: 17), textAlign: TextAlign.center)
                  )
                  : 
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: wv*10, vertical: hv*4),
                    child: Center(child: Text(S.of(context).choisissezUnJourPourLeRendezvous, style: TextStyle(color: kBlueDeep, fontWeight: FontWeight.w900, fontSize: 17), textAlign: TextAlign.center,))
                  ),
              ),
            ],
          ),
        )),
        
        CustomTextButton(
          text: S.of(context).continuer,
          enable: focusedDay != null && timeSelected != null,
          action: ()=>controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate),
        ) 
      ],
    );
  }
  Widget finalize(){
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    AdherentModel? adherentModel = adherentProvider.getAdherent;
    DoctorModel? doc = doctorProvider.getDoctor;
    return Padding(
      padding: EdgeInsets.only(bottom: hv*2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
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
                                  text: S.of(context).rendezvousn,
                                  children: [
                                    TextSpan(text: "Dr ${doc?.surname} ${doc?.familyName}\n", style: TextStyle(fontSize: wv*3.8, fontWeight: FontWeight.w400)),
                                    TextSpan(text: "${doc?.field}"+S.of(context).mdecinDeFamille, style: TextStyle(fontSize: wv*3.3, fontWeight: FontWeight.w400)),
                                  ], style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w600)),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: RichText(text: TextSpan(
                                  text: DateFormat('EEEE', 'fr_FR').format(focusedDay!)+", "+ focusedDay!.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(focusedDay!)+" "+ focusedDay!.year.toString() +"\n",
                                  children: [
                                    TextSpan(text: timeSelected!.hour.toString().padLeft(2, '0')+ "H:"+timeSelected!.minute.toString().padLeft(2, '0')+ " à "+ (timeSelected!.hour + ((purpose != "consult-today") ? 1 : 8)).toString().padLeft(2, '0') + "H:"+timeSelected!.minute.toString().padLeft(2, '0'), style: TextStyle(fontSize: wv*3.3, fontWeight: FontWeight.w400)),
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*3.5),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).quelleEnEstLaRaison, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600, fontSize: 16),),
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
                              child: DropdownButton<String>(
                                icon: Icon(Icons.keyboard_arrow_down_rounded, size: wv*6, color: kPrimaryColor,),
                                isExpanded: true,
                                value: reason,
                                hint: Text(S.of(context).choisir),
                                items: [
                                  DropdownMenuItem(
                                    child: Text(S.of(context).nouvelleConsultation, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                    value: S.of(context).nouvelleconsultation,
                                  ),
                                  DropdownMenuItem(
                                    child: Text(S.of(context).suivi, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                    value: S.of(context).suivi,
                                  ),
                                  DropdownMenuItem(
                                    child: Text(S.of(context).rfrencement, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                    value: S.of(context).referencement,
                                  ),
                                  DropdownMenuItem(
                                    child: Text(S.of(context).rsultatDexamen, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                    value: S.of(context).resultatexamen,
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

                        
                        Text(S.of(context).listezVosSymptmes, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.w600, fontSize: 16),),
                        SizedBox(height: hv*1.5,),
                        Row(children: [
                        Text(S.of(context).symptmes, style: TextStyle(fontSize: 16, color: kTextBlue),), SizedBox(width: wv*3,),
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
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: wv*4, right: wv*4, top: hv*0.5),
            child: CustomTextButton(
              noPadding: true,
              isLoading: buttonLoading,
              enable: reason != null,
              text: S.of(context).terminer,
              action: () async {
                setState(() {
                  buttonLoading = true;
                });
                DateTime? consultationStartDate = purpose != "consult-today" ? focusedDay : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 0);
                DateTime consultationEndDate = purpose != "consult-today" ? focusedDay!.add(Duration(hours: 1)) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 16, 0);
                BeneficiaryModelProvider beneficiary = Provider.of<BeneficiaryModelProvider>(context, listen: false);
                await FirebaseFirestore.instance.collection("APPOINTMENTS").add({
                    "adherentId": adherentModel?.getAdherentId,
                    "rdvPrestataire": chosenSP != null,
                    "doctorId": chosenSP != null ? chosenSP?.id : chosenDoctor?.id,
                    "beneficiaryId": beneficiary.getBeneficiary.matricule,
                    "doctorName": chosenSP != null ? chosenSP?.name : chosenDoctor!.surname! + " " + chosenDoctor!.familyName!,
                    "createdDate": DateTime.now(),
                    "enabled": false,
                    "symptoms": symptoms,
                    "title": reason,
                    "appointment-type": purpose,
                    "consultation-type": purpose == "consult-today" ? "Cabinet" : consultationType,
                    "start-time": consultationStartDate,
                    "end-time": consultationEndDate,
                    "price": tarif,
                    "announced": purpose == "consult-today"? true : false,
                    "avatarUrl": beneficiary.getBeneficiary.avatarUrl,
                    "birthDate": beneficiary.getBeneficiary.birthDate,
                    "username":  beneficiary.getBeneficiary.surname! +" "+ beneficiary.getBeneficiary.familyName!,
                    "status" : 0 //En attente
                  }).then((doc) async  {
                    if(purpose != "consult-today"){
                      print('adding planning');
                      FirebaseFirestore.instance.collection("MEDECINS").doc(doctorProvider.getDoctor?.id).update({"planning" : FieldValue.arrayUnion([{'idRdv': doc.id, 'date': focusedDay}])}).then((value) {
                        print("new planning added");
                      });
                    }
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
            )
          )
        ],
      ),
    );
  }
  
  bool checkAvailability (String day){
    print(day);
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    DoctorModel? doc = doctorProvider.getDoctor;
    if (doc?.availability != null) {
      bool weekAvail = doc?.availability?["monday to friday"]["available"];
      bool saturdayAvail = doc?.availability?["saturday"]["available"];
      bool sundayAvail = doc?.availability?["sunday"]["available"];
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
    DoctorModel? doc = doctorProvider.getDoctor;
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: doc?.availability?["monday to friday"]["start"].toDate().hour, minute: doc?.availability?["monday to friday"]["start"].toDate().minute), 
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );});

    if (picked_s != null && picked_s != TimeOfDay(hour: doc?.availability?["monday to friday"]["start"].toDate().hour, minute: doc?.availability?["monday to friday"]["start"].toDate().minute))
      setState(() {
        timePicked = picked_s; //DateTime(2000, 1, 1, picked_s.hour, picked_s.minute);
      });
      print(picked_s.toString());
      checkTimeRange(picked_s!);
  }

  checkTimeRange(TimeOfDay time){
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    DoctorModel? doc = doctorProvider.getDoctor;

    if (doc?.availability != null) {
      String day = DateFormat('EEEE').format(focusedDay!);
      List<String> weekDays = ["lundi","mardi","mercredi","jeudi","vendredi"];
      List<String> weekDaysEnglish = ["Monday","Tuesday","Wednesday","Thursday","Friday"];
      if(weekDays.contains(day)){
        TimeOfDay start = TimeOfDay(hour: doc?.availability?["monday to friday"]["start"].toDate().hour, minute: doc?.availability?["monday to friday"]["start"].toDate().minute);
        TimeOfDay end = TimeOfDay(hour: doc?.availability?["monday to friday"]["end"].toDate().hour, minute: doc?.availability?["monday to friday"]["end"].toDate().minute);
        double timeN = time.hour + time.minute/60;
        double startN = start.hour + start.minute/60;
        double endN = end.hour + end.minute/60;
        if(timeN >= startN && timeN <= endN){
          print(time.toString());
          setState(() {
            timeSelected = DateTime(2000, 1, 1, time.hour, time.minute);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).dsolCetteHoraireNestPasDisponibleChoisissezEnUnAutre), duration: Duration(seconds: 4),));
          setState(() {
            timeSelected = null;
          });
        }
      } else if (day == "samedi"){
        TimeOfDay start = TimeOfDay(hour: doc?.availability?["saturday"]["start"].toDate().hour, minute: doc?.availability?["saturday"]["start"].toDate().minute);
        TimeOfDay end = TimeOfDay(hour: doc?.availability?["saturday"]["end"].toDate().hour, minute: doc?.availability?["saturday"]["end"].toDate().minute);
        double timeN = time.hour + time.minute/60;
        double startN = start.hour + start.minute/60;
        double endN = end.hour + end.minute/60;
        if(timeN >= startN && timeN <= endN){
          setState(() {
            timeSelected = DateTime(2000, 1, 1, time.hour, time.minute);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).dsolCetteHoraireNestPasDisponibleChoisissezEnUnAutre), duration: Duration(seconds: 4),));
          setState(() {
            timeSelected = null;
          });
        }
      } else if (day == "dimanche") {
        TimeOfDay start = TimeOfDay(hour: doc?.availability?["sunday"]["start"].toDate().hour, minute: doc?.availability?["sunday"]["start"].toDate().minute);
        TimeOfDay end = TimeOfDay(hour: doc?.availability?["sunday"]["end"].toDate().hour, minute: doc?.availability?["sunday"]["end"].toDate().minute);
        double timeN = time.hour + time.minute/60;
        double startN = start.hour + start.minute/60;
        double endN = end.hour + end.minute/60;
        if(timeN >= startN && timeN <= endN){
          setState(() {
            timeSelected = DateTime(2000, 1, 1, time.hour, time.minute);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).dsolCetteHoraireNestPasDisponibleChoisissezEnUnAutre), duration: Duration(seconds: 4),));
          setState(() {
            timeSelected = null;
          });
        }
      }
    }
  }

  bool checkTimeAvailability(TimeOfDay time){
    DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
    DoctorModel? doc = doctorProvider.getDoctor;

    if (doc?.availability != null) {
      String day = DateFormat('EEEE').format(focusedDay!);
      List<String> weekDays = ["lundi","mardi","mercredi","jeudi","vendredi"];
      List<String> weekDaysEnglish = ["Monday","Tuesday","Wednesday","Thursday","Friday"];
      if(weekDays.contains(day)){
        TimeOfDay start = TimeOfDay(hour: doc?.availability?["monday to friday"]["start"].toDate().hour, minute: doc?.availability?["monday to friday"]["start"].toDate().minute);
        TimeOfDay end = TimeOfDay(hour: doc?.availability?["monday to friday"]["end"].toDate().hour, minute: doc?.availability?["monday to friday"]["end"].toDate().minute);
        double timeN = time.hour + time.minute/60;
        double startN = start.hour + start.minute/60;
        double endN = end.hour + end.minute/60;
        if(timeN >= startN && timeN <= endN){
          return true;
        } else {
          return false;
        }
      } else if (day == "samedi"){
        TimeOfDay start = TimeOfDay(hour: doc?.availability?["saturday"]["start"].toDate().hour, minute: doc?.availability?["saturday"]["start"].toDate().minute);
        TimeOfDay end = TimeOfDay(hour: doc?.availability?["saturday"]["end"].toDate().hour, minute: doc?.availability?["saturday"]["end"].toDate().minute);
        double timeN = time.hour + time.minute/60;
        double startN = start.hour + start.minute/60;
        double endN = end.hour + end.minute/60;
        if(timeN >= startN && timeN <= endN){
          return true;
        } else {
          return false;
        }
      } else if (day == "dimanche") {
        TimeOfDay start = TimeOfDay(hour: doc?.availability?["sunday"]["start"].toDate().hour, minute: doc?.availability?["sunday"]["start"].toDate().minute);
        TimeOfDay end = TimeOfDay(hour: doc?.availability?["sunday"]["end"].toDate().hour, minute: doc?.availability?["sunday"]["end"].toDate().minute);
        double timeN = time.hour + time.minute/60;
        double startN = start.hour + start.minute/60;
        double endN = end.hour + end.minute/60;
        if(timeN >= startN && timeN <= endN){
          return true;
        } else {
          return false;
        }
      }
    }
    return true;
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
        boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 3.0, spreadRadius: 1.0, offset: Offset(0, 2))]
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
            Text(S.of(context).pourLePatient, style: TextStyle(color: kPrimaryColor, fontSize: wv*4, fontWeight: FontWeight.w900)),
            SizedBox(height: hv*1,),
            Row(children: [
              CircleAvatar(
                backgroundImage: beneficiaryProvider.getBeneficiary.avatarUrl != null ? CachedNetworkImageProvider(beneficiaryProvider.getBeneficiary.avatarUrl!) : null,
                backgroundColor: whiteColor,
                radius: wv*6,
                child: beneficiaryProvider.getBeneficiary.avatarUrl != null ? Container() : Icon(LineIcons.user, color: kSouthSeas.withOpacity(0.7), size: wv*10),
              ),
              SizedBox(width: wv*3,),
              Expanded(
                child: RichText(text: TextSpan(
                  text: beneficiaryProvider.getBeneficiary.surname! + " " +  beneficiaryProvider.getBeneficiary.familyName! + "\n",
                  children: [
                    TextSpan(text: (DateTime.now().year - beneficiaryProvider.getBeneficiary.birthDate!.toDate().year).toString() + S.of(context).ans, style: TextStyle(fontSize: wv*3.3)),
                  ], style: TextStyle(color: kDeepTeal, fontSize: wv*4.2)),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],),
            SizedBox(height: hv*0.5,)
          ],
        ),
      ),
    );
  }

  Widget getTimeRangeBox({required TimeOfDay time, bool selected = false, bool enable = true, Function? onSelect}){
    return GestureDetector(
      onTap: enable ? ()=> onSelect : null,
      child: Container(
        width: wv*35,
        padding: EdgeInsets.symmetric(horizontal: wv*1, vertical: hv*1.5),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          border: selected ? Border.all(color: kDeepTeal) : null
        ),
        child: Text("${time.hour.toString().padLeft(2, '0')}:00 - ${(time.hour+1).toString().padLeft(2, '0')}:00", style: TextStyle(color: enable ? kCardTextColor : Colors.grey, fontWeight: FontWeight.w900, fontSize: 18), textAlign: TextAlign.center, overflow: TextOverflow.fade,
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