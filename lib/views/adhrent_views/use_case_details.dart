 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/doctorModel.dart';
import 'package:danaid/core/models/usecaseModel.dart';
import 'package:danaid/core/models/useCaseServiceModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/usecaseModelProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/adhrent_views/usecase_service_details.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class UseCaseDetails extends StatefulWidget {
  @override
  _UseCaseDetailsState createState() => _UseCaseDetailsState();
}

class _UseCaseDetailsState extends State<UseCaseDetails> {
  TextEditingController _commentController = new TextEditingController();
  bool canComment = false;
  bool showServiceMenu = false;
  bool commentButtonSpinner = false;



  init() async {
    UseCaseModelProvider usecaseProvider = Provider.of<UseCaseModelProvider>(context, listen: false);
    UseCaseModel? usecase = usecaseProvider.getUseCase;
    if(usecase!.otherInfo != null )
      setState((){_commentController.text =  usecase.otherInfo!;});
    
    if(usecase.doctorId != null){
      if(usecase.doctorName == null){
        await FirebaseFirestore.instance.collection("MEDECINS").doc(usecase.doctorId).get().then((doc) async {
          DoctorModel doctorModel = DoctorModel.fromDocument(doc, doc.data() as Map);
          await FirebaseFirestore.instance.collection('USECASES').doc(usecase.id).update({
            'doctorName' : doctorModel.surname.toString() + ' ' + doctorModel.familyName.toString(), 
            'establishment' : doctorModel.officeName != '' ? doctorModel.officeName : null}).then((value){
              usecaseProvider.setDoctorName(doctorModel.surname.toString() + ' ' + doctorModel.familyName.toString());
              usecaseProvider.setEstablishment(doctorModel.officeName!);
            });
        });
      }
    }
    
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    UseCaseModelProvider usecaseProvider = Provider.of<UseCaseModelProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    AdherentModel? adh = adherentProvider.getAdherent;
    DateTime startTime = usecaseProvider.getUseCase!.dateCreated!.toDate();
    UseCaseModel? usecase = usecaseProvider.getUseCase;
    print(usecase!.doctorId.toString());
    int status = 2;
    UseCaseServiceModel consultationService = UseCaseServiceModel(
      date: usecase.dateCreated,
      dateCreated: usecase.dateCreated,
      status: usecase.consultationStatus,
      executed: usecase.executed,
      bookletUrls: usecase.bookletUrls,
      receiptUrls: usecase.receiptUrls,
      otherDocUrls: usecase.otherDocUrls,
      bookletIsValid: usecase.bookletIsValid,
      receiptIsValid: usecase.receiptIsValid,
      otherDocIsValid: usecase.otherDocIsValid,
      type: consultation,
      amount: usecase.consultationCost == null ? 0 : usecase.consultationCost
    );
    num? amount = usecase.amount != null ? usecase.amount : 0;
    num danAidCov = adh?.adherentPlan != 0 ? (amount!*0.7).round() : (amount!*0.05).round();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,), 
          onPressed: ()=>Navigator.pop(context)
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(S.of(context).dmandeDu + startTime.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(startTime)+" "+ startTime.year.toString(), style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
            Text(S.of(context).ajouterDesPrestationsEtJustificatifs,  style: TextStyle(color: kPrimaryColor, fontSize: wv*3.8, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: SvgPicture.asset('assets/icons/Two-tone/InfoSquare.svg', color: kSouthSeas,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: (){})
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: hv*2,),
            Container(
              padding: EdgeInsets.only(bottom: hv*1),
              decoration: BoxDecoration(
                color: kSouthSeas.withOpacity(0.3),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: HomePageComponents.head(surname: usecaseProvider.getUseCase?.beneficiaryName, fname: "")),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: hv*5,),
                          Text(S.of(context).statutDeLaDemande,  style: TextStyle(color: kBlueDeep, fontSize: 15, fontWeight: FontWeight.w300)),
                          SizedBox(height: hv*1,),
                          Container(
                            width: wv*50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: status == 1 ? 45 : 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kDeepTeal,
                                      border: Border.all(color: whiteColor, width: 2),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                                    ),
                                    child: Text(status == 1 ?  "1. "+S.of(context).enAttente : "1", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),)),
                                Expanded(
                                  flex: status == 2 ? 45 : 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kDeepTeal.withOpacity(0.7),
                                      border: Border(top: BorderSide(color: whiteColor, width: 2), bottom: BorderSide(color: whiteColor, width: 2), right: BorderSide(color: whiteColor, width: 2)),
                                    ),
                                    child: Text(status == 2 ?  "2. "+S.of(context).enCours : "2", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
                                Expanded(
                                  flex: status == 3 ? 45 : 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kDeepTeal.withOpacity(0.3),
                                      border: Border(top: BorderSide(color: whiteColor, width: 2), bottom: BorderSide(color: whiteColor, width: 2), right: BorderSide(color: whiteColor, width: 2)),
                                    ),
                                    child: Text(status == 3 ?  "3. "+S.of(context).approuv : "3", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
                                Expanded(
                                  flex: status == 4 ? 45 : 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      border: Border(top: BorderSide(color: whiteColor, width: 2), bottom: BorderSide(color: whiteColor, width: 2)),
                                    ),
                                    child: Text(status == 4 ?  "4. "+S.of(context).rjt : "4", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
                                Expanded(
                                  flex: status == 5 ? 45 : 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      border: Border.all(color: whiteColor, width: 2),
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                                    ),
                                    child: Text(status == 5 ?  "5. "+S.of(context).cltur : "5", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: wv*3,)
                    ],
                  ),
                  SizedBox(height: hv*1,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        usecase.doctorName != null && usecase.doctorName != "" ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Médecin", style: TextStyle(color: kTextBlue, fontSize: 17, fontWeight: FontWeight.bold)),
                            Text(usecase.doctorName!, style: TextStyle(color: kTextBlue, fontSize: 17)),
                            Text("Médecin de famille", style: TextStyle(color: kTextBlue, fontSize: 14))
                          ],
                        ) : Container(),
                        Spacer(),
                        usecase.establishment != null && usecase.establishment != "" ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Etablissement", style: TextStyle(color: kTextBlue, fontSize: 17, fontWeight: FontWeight.bold)),
                            Text(usecase.establishment!, style: TextStyle(color: kTextBlue, fontSize: 15)),
                          ],
                        ) : Container(),
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Code de consultation", style: TextStyle(color: kTextBlue, fontSize: 17),),
                              SizedBox(height: hv*1,),
                              Text(usecase.consultationCode != null ? usecase.consultationCode! : "Non spécifié", style: TextStyle(color: kBrownCanyon, fontSize: 17, fontWeight: FontWeight.bold)),
                            ],
                          )
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Date de démarrage", style: TextStyle(color: kTextBlue, fontSize: 17),),
                              SizedBox(height: hv*1,),
                              Text("${startTime.day}/${startTime.month}/${startTime.year}", style: TextStyle(color: kTextBlue, fontSize: 17, fontWeight: FontWeight.bold)),
                            ],
                          )
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Date de clôture", style: TextStyle(color: kTextBlue, fontSize: 17),),
                                SizedBox(height: hv*1,),
                                Text("--/--/--", style: TextStyle(color: kTextBlue, fontSize: 17, fontWeight: FontWeight.bold)),
                              ],
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: hv*3,),
                  Row(
                    children: [
                      Text("Commentaire", style: TextStyle(color: kTextBlue, fontSize: 18.5),),
                      Spacer(),
                      IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Edit Square.svg', color: kSouthSeas, width: wv*8,), onPressed: ()=>setState((){canComment = !canComment;}),) 
                    ],
                  ),
                  CustomTextField(
                    minLines: 3,
                    noPadding: true,
                    hintText: "",
                    multiLine: true,
                    controller: _commentController,
                    onChanged: (val)=>setState((){}),
                    seal: !canComment
                  ),
                  canComment ? Row(
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextButton(
                          text: "Envoyer le commentaire",
                          color: kSouthSeas,
                          isLoading: commentButtonSpinner,
                          expand: false,
                          noPadding: true,
                          action: () async {
                            setState((){commentButtonSpinner = true;});
                            await FirebaseFirestore.instance.collection('USECASES').doc(usecase.id).update({"otherInfo" : _commentController.text}).then((value){
                              setState((){commentButtonSpinner = false; canComment = false;});
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nouveau commentaire ajouté'),));
                            }).onError((error, stackTrace){
                              setState((){commentButtonSpinner = false;});
                            });
                          },
                        ),
                      ),
                    ],
                  ) : Container()
                ],
              ),
            ),
            SizedBox(height: hv*2,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*3),
              decoration: BoxDecoration(
                color: whiteColor
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Suivie des prestations', style: TextStyle(color: kBlueDeep, fontSize: 17, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: hv*1,),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: wv*2.5, vertical: hv*1.5),
                        height: 500,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LineIcons.stethoscope, size: 100, color: Colors.grey,),
                                  Text(" Liste des prestations ", style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                  SizedBox(height: 30,)
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                usecase.consultationCode != null || usecase.consultationId != null ? SizedBox(height: 85,) : Container(),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('USECASES').doc(usecase.id).collection('PRESTATIONS').snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                                          ),
                                        );
                                      }

                                      return snapshot.data!.docs.length >= 1
                                        ? ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              DocumentSnapshot useCaseDoc = snapshot.data!.docs[index];
                                              UseCaseServiceModel service = UseCaseServiceModel.fromDocument(useCaseDoc);
                                              print("name: ");
                                              return getServiceTile(
                                                service: service,
                                                action: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => UseCaseServiceDetails(type: service.type!, service: service,),),)
                                              );
                                            })
                                        : Center(
                                          child: Container(),
                                        );
                                    }
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      usecase.consultationCode != null || usecase.consultationId != null ? getServiceTile(
                        action: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => UseCaseServiceDetails(type: consultation, service: consultationService,),),),
                        service: consultationService
                        
                      ) : Container(),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              height: showServiceMenu ? 500 : 0,
                              width: showServiceMenu ? 250 : 0,
                              child: SingleChildScrollView(
                                reverse: true,
                                child: Column(
                                  children: [
                                    usecase.ambulanceId == null ? getServiceMenuItem(
                                      title: "Ajouter des",
                                      label: "Soins",
                                      icon: 'assets/icons/Bulk/Consultation.svg',
                                      color: kPrimaryColor,
                                      action: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => UseCaseServiceDetails(type: ambulance,),),)
                                    ) : Container(),
                                    usecase.hospitalizationId == null ? getServiceMenuItem(
                                      title: "Ajouter une",
                                      label: "Hospitalisation",
                                      icon: 'assets/icons/Bulk/Hospitalisation.svg',
                                      color: kBrownCanyon,
                                      action: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => UseCaseServiceDetails(type: hospitalization,),),)
                                    ) : Container(),
                                    getServiceMenuItem(
                                      title: "Ajouter un",
                                      label: "Examen de labo",
                                      icon: 'assets/icons/Bulk/Labo.svg',
                                      color: kSouthSeas,
                                      action: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => UseCaseServiceDetails(type: labo,),),)
                                    ),
                                    getServiceMenuItem(
                                      title: "Ajouter une",
                                      label: "Ordonance",
                                      icon: 'assets/icons/Bulk/Ordonance.svg',
                                      color: primaryColor,
                                      action: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => UseCaseServiceDetails(type: pharmacy,),),)
                                    ),
                                    usecase.consultationCode == null ? getServiceMenuItem(
                                      title: "Ajouter une",
                                      label: "Consultation",
                                      icon: 'assets/icons/Bulk/Consultation.svg',
                                      color: kDeepTeal,
                                      action: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => UseCaseServiceDetails(type: consultation,),),)
                                    ) : Container(),
                                    SizedBox(height: 10,),
                                    //Align(alignment: Alignment.bottomRight,child: FloatingActionButton(child: Icon(LineIcons.times), backgroundColor: kPrimaryColor, onPressed: ()=>setState((){showServiceMenu = false;})))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FloatingActionButton(child: Icon(showServiceMenu ? LineIcons.times : LineIcons.plus), heroTag: "usecase_fab", backgroundColor: kPrimaryColor, onPressed: ()=>setState((){showServiceMenu = !showServiceMenu;})),
                                ],
                              ),
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: whiteColor,
              child: Container(
                color: kSouthSeas.withOpacity(0.3),
                padding: EdgeInsets.symmetric(horizontal: wv*7, vertical: hv*1.5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Votre demande", style: TextStyle(color: kTextBlue, fontSize: 15, fontWeight: FontWeight.w400),),
                        Spacer(),
                        Text("$amount f.", style: TextStyle(color: kTextBlue, fontSize: 15, fontWeight: FontWeight.w400))
                      ],
                    ),
                    Row(
                      children: [
                        Text("Votre copaiement", style: TextStyle(color: kBlueDeep, fontSize: 15, fontWeight: FontWeight.w400),),
                        Spacer(),
                        Text("${amount - danAidCov} f.", style: TextStyle(color: kBlueDeep, fontSize: 15, fontWeight: FontWeight.w400))
                      ],
                    ),
                    Row(
                      children: [
                        Text("Couverture DanAid", style: TextStyle(color: kTextBlue, fontSize: 16, fontWeight: FontWeight.bold),),
                        Spacer(),
                        Text("$danAidCov f.", style: TextStyle(color: kTextBlue, fontSize: 16, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getServiceTile({required UseCaseServiceModel service, Function? action}){
    bool executed = service.executed != null ? service.executed! : false;
    bool estimate = service.estimate != null ? service.estimate! : false;
    bool ongoing = service.ongoing != null ? service.ongoing! : false;
    bool requested = service.requested != null ? service.requested! : false;
    return GestureDetector(
      onTap: ()=> action,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1.5),
        margin: EdgeInsets.only(bottom: hv*1),
        decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [BoxShadow(color: Colors.grey[200]!, spreadRadius: 1.5, blurRadius: 3.0, offset: Offset(0,3))],
        borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(text: TextSpan(
                style: TextStyle(color: kTextBlue, fontSize: 13),
                children: [
                  service.type == pharmacy || service.type == labo ? TextSpan(text: "Dévis > ", style: TextStyle(fontWeight: estimate ? FontWeight.bold : FontWeight.w400)) : TextSpan(text: ''),
                  service.type == ambulance || service.type == hospitalization ? TextSpan(text: "Requis > ", style: TextStyle(fontWeight: requested ? FontWeight.bold : FontWeight.w400)) : TextSpan(text: ''),
                  service.type == pharmacy || service.type == labo || service.type == consultation ? TextSpan(text: "Executé > ", style: TextStyle(fontWeight: executed ? FontWeight.bold : FontWeight.w400)) : TextSpan(text: ''),
                  service.type == ambulance || service.type == hospitalization ? TextSpan(text: "En cours > ", style: TextStyle(fontWeight: ongoing ? FontWeight.bold : FontWeight.w400)) : TextSpan(text: ''),
                  TextSpan(text: "Justifié", style: TextStyle(fontWeight: service.status == 1 ? FontWeight.bold : FontWeight.w400)),
                ]
              )),
              SizedBox(height: hv*2,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(Algorithms.getUseCaseServiceIcon(type: service.type), color: kDeepTeal, width: wv*8,),
                  SizedBox(width: wv*2.5,),
                  Text(Algorithms.getUseCaseServiceName(type: service.type), style: TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
          Spacer(),
          Column(
            children: [
              Text(service.date != null ? "${service.date?.toDate().day}/${service.date?.toDate().month.toString().padLeft(2, '0')}/${service.date?.toDate().year}" : "--/--/--", style: TextStyle(color: kBrownCanyon, fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(height: hv*2,),
              Text(service.amount != null ? "${service.amount} f." : "-- f.", style: TextStyle(color: kTextBlue, fontSize: 17),),
            ],
          ),
          SizedBox(width: wv*3,),
          HomePageComponents.getStatusIndicator(status: service.status)
        ],
        ),
      ),
    );
  }
Widget getServiceMenuItem({String? title, String? label, String? icon, Color? color, Function? action}){
  return GestureDetector(
    onTap: ()=> action,
    child: Container(
      margin: EdgeInsets.only(bottom: 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: 13.5),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1.5, blurRadius: 3.0, offset: Offset(0,3))]
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title!, style: TextStyle(color: kCardTextColor, fontSize: 15.5)),
                    Text(label!, style: TextStyle(color: kCardTextColor, fontSize: 18.5, fontWeight: FontWeight.bold))
                  ],
                ),
                Spacer()
              ],
            ),
          ),
          Positioned(
            child: Container(
              width: 70, height: 70,
              child: FittedBox(
                child: FloatingActionButton(heroTag: 'hero_$label', child: SvgPicture.asset(icon!, width: 25, color: whiteColor,), backgroundColor: color, onPressed: ()=> action)),
            ), 
            right: 0,
            top: 4,
          )
        ],
      ),
    ),
  );
}
}