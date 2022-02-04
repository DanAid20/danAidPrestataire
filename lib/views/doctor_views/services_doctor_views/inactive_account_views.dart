import 'dart:math';
import 'dart:ui';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/models/usecaseModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/providers/usecaseModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/owner_userList_View.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/doctorModelProvider.dart';
import '../../../helpers/constants.dart';
import '../../../widgets/home_page_mini_components.dart';
import '../../../helpers/utils.dart';

class InactiveAccount extends StatefulWidget {
  final AdherentModel? data;
  final bool? isAccountIsExists;
  final String? phoneNumber;
  final String? consultationType;
  InactiveAccount(
      {Key? key, this.data, this.isAccountIsExists, this.phoneNumber, this.consultationType})
      : super(key: key);

  @override
  _InactiveAccountState createState() => _InactiveAccountState();
}

class _InactiveAccountState extends State<InactiveAccount> {
  bool? isActive;
  AdherentModelProvider? adherentModelProvider;
  ScrollController? scrollController;
  int? userSelected=-1;
  BeneficiaryModel? adherentUserSelected;
  BeneficiaryModel? beneficiary;
  bool? isloading=false;
  bool? isRequestLaunch=false;
  bool? registerClientError=false;
  String? registerClient;
  UseCaseModelProvider? userCaprovider;
  String? famillyDoctorNAme;
  CarouselController? beneficiaryCarouselController = CarouselController();
  TextEditingController _patientController = new TextEditingController();
    final GlobalKey<FormState> _FormKey = GlobalKey<FormState>();

  List<Widget>? beneficiaries;
  var code;
  @override
  void initState() {
     code= getRandomString(4);
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (widget.isAccountIsExists == false) {
        await showDialog<String>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) =>
                _buildAboutDialog(context, true));
      }else{
        getListOfUser();
      }

    });
    super.initState();
  userCaprovider =Provider.of<UseCaseModelProvider>(context, listen: false);
   if(widget.data!=null){
    
    getFamillyDoctorName(widget.data?.familyDoctorId);
    
   }
  }
 Future<String> createConsultationCode({bool exists=false, String? id, String? name, String? phone}) async {
     DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);

    var date= DateTime.now();
    var newUseCase =FirebaseFirestore.instance.collection('USECASES').doc();
     newUseCase.set({
      'id': exists==false?newUseCase.id:code,
      'adherentId':exists==false && phone!.isNotEmpty?phone: adherentUserSelected!.adherentId,
      'beneficiaryId':exists==false && phone!.isNotEmpty?phone: adherentUserSelected!.matricule,
      'beneficiaryName':exists==false&& name!.isNotEmpty ? name:adherentUserSelected!.familyName,
      'otherInfo':'',
      'consultationCode': code,
      'idMedecin' : doctorProvider.getDoctor!.id,
      'idAppointement': id,
      'type': widget.consultationType,
      'amountToPay': 2000 ,
      'status' : 0  ,
      'createdDate':  DateTime.now(), 
      'enable': false,
    }, SetOptions(merge: true)).then((value) {
        setState(() {
          isloading = false;
        });
    userCaprovider!.getUseCase!.consultationCode=code;
    userCaprovider!.getUseCase!.dateCreated= Timestamp.fromDate(date);
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context)!.leCodeCeConsultationCreerAvecSuccesCommeMdecinDe)));
        
      }).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          isloading = false;
        });
      });
    
    return newUseCase.id;
  }

  addCodeToAdherent(code) async {
    await FirebaseFirestore.instance.collection('ADHERENTS').doc(adherentUserSelected!.adherentId).set({
      'CurrentcodeConsultation' : code
    },SetOptions(merge: true)).then((value) {
        setState(() {
          isloading = false;
        });

    });
  
  }
  facturationCode(id,{String? name,String? phone}) async {
    DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection('USECASES').doc(id)
    .collection('FACTURATIONS').doc().set({
      'id':Utils.createCryptoRandomString(8),
      'idAdherent': widget.isAccountIsExists==false && phone!.isNotEmpty?phone: adherentUserSelected!.adherentId,
      'idFammillyMember': widget.isAccountIsExists==false && phone!.isNotEmpty ? widget.phoneNumber : phone,
      'idBeneficiairy': widget.isAccountIsExists==false && phone!.isNotEmpty ? phone: adherentUserSelected!.matricule,
      'idMedecin':doctorProvider.getDoctor!.id,
      'amountToPay': 2000,
      'isSolve':false,
      'idAppointement': id,
      'canPay': 0,
      'Type':widget.consultationType ,
      'createdAt':  DateTime.now(),
    }, SetOptions(merge: true)).then((value) {
        setState(() {
          isloading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("La facture a bien ete generer avec succes ")));
        
      }).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          isloading = false;
        });
      });
  }
  
  getUserSelected(int index, BeneficiaryModel adherent, action ){
  
    if(action=="add"){
    setState(() {
      userSelected=index;
      adherentUserSelected= adherent;
    });
    if (kDebugMode) {
      print(userSelected);
      print(adherentUserSelected!.avatarUrl);
    }
   
    }else if( action=="remove"){
       setState(() {
      userSelected=-1;
      adherentUserSelected= null;
    });
    print(userSelected);
    print(adherentUserSelected);
    }
  }
  // void writeData() async{
  //   final FirebaseUser user = await _auth.currentUser();
  //   final uid = user.uid;
  //   DBRef.child(uid).set({
  //     'id':'ID1',
  //     'Name':'Mehul Jain',
  //     'Phone':'8856061841'
  //   });
  // }
 getFamillyDoctorName(id)  {
    var newUseCase = FirebaseFirestore.instance.collection('MEDECINS').doc(id);
    newUseCase.get().then((value){
      var result= value.data() as Map<String, dynamic>;
      if(value.exists){
        setState(() {
          famillyDoctorNAme=result['cniName'] ?? '';
        });
        
      }
    });
     
   if (kDebugMode) {
     print(famillyDoctorNAme);
   }
  }
  getListOfUser() {
     AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
     String medecin;
      if (kDebugMode) {
        print("------------");
        print(adherentProvider.getAdherent);
        print("------------");
      }
      if(adherentProvider.getAdherent!.familyDoctorId != null){
        FirebaseFirestore.instance.collection("MEDECINS").doc(adherentProvider.getAdherent!.familyDoctorId).get().then((doc){
           var result= doc.data() as Map<String, dynamic>;
          String name = result["nomDefamille"];
            medecin = "Dr $name";
        });
      }

      FirebaseFirestore.instance.collection("ADHERENTS").doc('${widget.phoneNumber}').collection("BENEFICIAIRES").get().then((snapshot) async {
        print(snapshot.docs.length.toString());
        beneficiaries = [];
        BeneficiaryModel adherentBeneficiary = BeneficiaryModel(
          avatarUrl: widget.data?.imgUrl,
                        surname: widget.data?.surname,
                        familyName: widget.data?.familyName,
                        matricule: widget.data?.matricule,
                        gender: widget.data?.gender,
                        adherentId: widget.data?.adherentId,
                        birthDate  : widget.data?.birthDate,
                        dateCreated: widget.data?.dateCreated,
                        enabled: widget.data?.enable,
                        height: null,
                        weight: null,
                        bloodGroup: null,
                        protectionLevel: widget.data?.adherentPlan!.toInt(),
                        cniName: widget.data?.cniName,
                        marriageCertificateName: widget.data?.marriageCertificateName,
                        marriageCertificateUrl:  widget.data?.marriageCertificateUrl,
                        validityEndDate: widget.data?.validityEndDate,
                        phoneList: widget.data?.phoneList,
         );
     
        Widget adherentBeneficiaryCard = InkWell(
                         onTap: ()=>{
                           beneficiaryCarouselController?.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeIn)
                         }, child:  Padding(
                             padding: const EdgeInsets.all(5),
                             child: HomePageComponents().getAdherentsList(
                                 adherent: adherentBeneficiary, doctorName: famillyDoctorNAme!, isAccountIsExists: true, index: 0, onclick: getUserSelected, iSelected:userSelected! )));
        beneficiaries?.add(adherentBeneficiaryCard);
        if (kDebugMode) {
          print(snapshot.docs.length);
        }
        for (int i = 0; i < snapshot.docs.length; i++){
          DocumentSnapshot doc = snapshot.docs[i];
          BeneficiaryModel beneficiary = BeneficiaryModel.fromDocument(doc);
          Widget content = InkWell(
                         onTap: ()=>{
                           // ignore: avoid_print
                           print(i),
                           beneficiaryCarouselController?.animateToPage(0, duration:const Duration(milliseconds: 500), curve: Curves.easeIn)
                         }, child: Padding(
                             padding: const EdgeInsets.all(5),
                             child: HomePageComponents().getAdherentsList(
                                 adherent: beneficiary, doctorName: famillyDoctorNAme!, isAccountIsExists: true, index: i, onclick: getUserSelected, iSelected:userSelected! )));
          beneficiaries?.add(content);
        }
        setState(() {
          
        });
      });

  }
   

  String getRandomString(int length){
  const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random _rnd = Random();
    var result= String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)))); 
    return 'YM'+result;
  } 
  
  saveSucces(BuildContext context, {String? string}) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
        Navigator.pop(context);
     },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(S.of(context)!.infos),
    content: Text(string!.isNotEmpty? string :S.of(context)!.cetAdherentABienTCrer),
    actions: [
      okButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
   Widget _buildAboutDialog(BuildContext context, bool isIninitState) {
    adherentModelProvider = Provider.of<AdherentModelProvider>(context);
     bool issaveInknowUserLoading=false;
      saveDataForUnknow(name,phone) async { 
        setState(() {issaveInknowUserLoading=true;});
        if (kDebugMode) {
          print(issaveInknowUserLoading);
        }
        await createConsultationCode(exists: widget.isAccountIsExists! ,name:name,phone:phone).then((value) async {
            await facturationCode(value,name:name,phone:phone);
          setState(() {issaveInknowUserLoading=false;});
        });
        if (kDebugMode) {
          print(issaveInknowUserLoading);
        }
      }
     Future<bool> _onWillpop() async {
        
          if (isIninitState == true) {
            Navigator.pop<bool>(context);
            Navigator.pop<bool>(context);
            return true;
          } else {
            Navigator.pop<bool>(context);
            return true;
          }
        
      }
    return Container(
      color: backgroundOverlayColor.withOpacity(0.8),
      child: WillPopScope(
        onWillPop:_onWillpop,
        child:  AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: cardColor,
          scrollable: true,
          elevation: 8.0,
          content:  SizedBox(
            width: wv * 100,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child:  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child:GestureDetector(
                          onTap: (){
                              Navigator.pop(context);
                              Navigator.pop(context);
                          },
                          child: Container(
                            decoration:BoxDecoration(
                               borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(MdiIcons.close, color: kPrimaryColor, size: wv*10,)),
                        )
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            widget.isAccountIsExists == false
                                ? S.of(context)!.leNumro
                                : S.of(context)!.leCompteDeLadherent,
                            style: TextStyle(
                              color: kBlueForce,
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize(size: 21),
                            )),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            widget.isAccountIsExists == false && widget.phoneNumber != null ? widget.phoneNumber!: S.of(context)!.estInatif,
                            style: TextStyle(
                              color: kBlueForce,
                              fontWeight: FontWeight.w700,
                              fontSize: fontSize(size: 21),
                            )),
                      ),
                     issaveInknowUserLoading==true ? const  Text('...'): Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          "assets/icons/Bulk/Danger.svg",
                          height: hv * 20,
                          width: wv * 20,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            widget.isAccountIsExists == false &&
                                    widget.phoneNumber != null
                                ? S.of(context)!.nestPasEncoreAdherentALaMutuelleSanteDanaidrecommncerLa
                                : S.of(context)!.ladhrentNetantPasJourDeSesCotisationVousNeBnficierez,
                            style: TextStyle(
                              color: kBlueForce,
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize(size: 17),
                            ),
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        height: hv * 2,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.isAccountIsExists == false &&
                                  widget.phoneNumber != null
                              ? S.of(context)!.vousRecevrezLaCompensationDanaid2000CfaSiLaFamilleAdherent
                              : S.of(context)!.poursuivezLaConsultationHorsParcoursDeSoinDanaid,
                          style: TextStyle(
                              color: kBlueForce,
                              fontSize: fontSize(size: 17),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: hv*2.5,),
                        Form(key: _FormKey,
                           child: Column(children: [
                      CustomTextField(
                        label:"Nom du patient",
                        hintText:"Jean MArie Nkah",
                        enabled: true,
                        controller: _patientController,
                        validator: (String? val) => (val!.isEmpty) ? S.of(context)!.ceChampEstObligatoire : null,
                      ),
                      ] )
                      )
                    ],
                  ),
                ),
                Container(
                  height: hv * 10.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child:   Container(
                    width: wv * 100,
                    margin:
                      const  EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 15),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: issaveInknowUserLoading==true ? Loaders().buttonLoader(kPrimaryColor) :  Container(
                        width: wv * 100, 
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: (Colors.grey[500])!,
                                spreadRadius: 0.5,
                                blurRadius: 3),
                          ],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child:   TextButton(
                          onPressed: () async {
                            if (_FormKey.currentState!.validate()){
                               if (kDebugMode) {
                                 print(_patientController.text);
                                  print(widget.phoneNumber);
                               }
                               DoctorModelProvider doctorProvider = Provider.of<DoctorModelProvider>(context, listen: false);
                                 var usecase= FirebaseFirestore.instance.collection('USECASES')
                                .where('adherentId', isEqualTo: widget.phoneNumber ).where('idMedecin',isEqualTo:doctorProvider.getDoctor!.id).orderBy('createdDate').limit(1).get(); 
                                usecase.then((value) async {
                                  if(value.size>0){
                                      if (kDebugMode) {
                                        print(value.docs[0].data());
                                      }
                                    var useCase= value.docs[0].data();
                                     Timestamp t = useCase['createdDate'].runtimeType==DateTime?Timestamp.fromDate( useCase['createdDate']): useCase['createdDate'];
                                                    DateTime d = t.toDate();
                                       if (kDebugMode) {
                                         print(t);
                                         print(d);
                                       }
                                    final date2 = DateTime.now(); 
                                    final difference = date2.difference(d).inDays;
                                     if( difference>14 &&  useCase['consultationCode']!=null ){
                                         saveDataForUnknow(_patientController.text,widget.phoneNumber).then((value){
                                          saveSucces(context,string:S.of(context)!.lePatientABienTAjouter);
                                          _patientController.clear();
                                            setState(() {issaveInknowUserLoading=false;});
                                        });
                                     }else{
                                        saveSucces(context,string:S.of(context)!.uneConsultationEnCoursTDtecterPourCePatientDonc);
                                     }
                                  }else{
                                     saveDataForUnknow(_patientController.text,widget.phoneNumber).then((value){
                                          saveSucces(context,string:S.of(context)!.lePatientABienTAjouterAuSysteme);
                                          _patientController.clear();
                                           setState(() {issaveInknowUserLoading=false;});
                                        });
                                  }
                                    
                                }).catchError((onError){
                                  if (kDebugMode) {
                                    print(onError);
                                  }
                                  saveSucces(context,string:S.of(context)!.uneErreurEstSurvenuVeuillezContacterLeService);
                                });

                            }
                           
                          },
                          child:  Text( 
                            widget.isAccountIsExists == false
                                ? S.of(context)!.ajouterCePatient
                                : S.of(context)!.poursuivreHorsParcours,
                            style: TextStyle(
                                color: textColor,
                                fontSize: wv * 4.5,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.w600),
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 15)),
                              backgroundColor:
                                  MaterialStateProperty.all(kFirstIntroColor),
                              shape: MaterialStateProperty.all(
                                const  RoundedRectangleBorder(borderRadius:  BorderRadius.all( Radius.circular(25))))),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    adherentModelProvider = Provider.of<AdherentModelProvider>(context);
     DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);
        if (kDebugMode) {
          print(widget.data);
        }
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            backgroundColor: kBgTextColor,
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: kDateTextColor,
                  ),
                  onPressed: () => Navigator.pop(context)),
              title: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [Text(S.of(context)!.famille), const Text('...')],
                ),
              ),
              actions: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/Bulk/Setting.svg',
                    color: whiteColor,
                  ),
                  onPressed: () {},
                  color: kSouthSeas,
                )
              ],
            ),
            body: Container(
              alignment: Alignment.center,
                child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Container(
                        width:double.infinity,
                        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                        child: widget.isAccountIsExists==true ?  Container(
                          margin: EdgeInsets.only(left:2.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              beneficiaries != null ? Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: hv*2),
                                    child: Container(
                                     
                                      child: CarouselSlider(
                                        carouselController: beneficiaryCarouselController,
                                        options: CarouselOptions(
                                          scrollPhysics: const BouncingScrollPhysics(),
                                          height: hv * 60,
                                          aspectRatio: 16 / 9,
                                          viewportFraction: 1,
                                          initialPage: 0,
                                          enableInfiniteScroll: false,
                                          reverse: false,
                                          autoPlay: false,
                                          enlargeCenterPage: true,
                                          scrollDirection: Axis.horizontal,
                                        ),
                                        items: beneficiaries
                                      ),
                                    ),
                                  ),
                                ) : Center(child: Loaders().buttonLoader(kCardTextColor)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'assets/icons/Bulk/Dots.svg',
                                  color: kSouthSeas,
                                  height: hv * 1,
                                  width: wv *1,
                                ),
                              ),
                            ],
                          )   
                        ) : Padding(
                            padding: EdgeInsets.all(2),
                            child: HomePageComponents().getAdherentsList( isAccountIsExists: false)) ,
                      ),
                  //   Container(decoration:  BoxDecoration(
                  //   color: whiteColor,
                  //   borderRadius: BorderRadius.all(Radius.circular(10) ),
                  // ) ,width: wv * 80,height: hv*5,child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(adherentUserSelected.),
                  //   ],
                  // ))),
                 
                      widget.isAccountIsExists == false
                          ? const SizedBox.shrink()
                          : isRequestLaunch! ? Loaders().buttonLoader(kPrimaryColor) :Container(
                            alignment: Alignment.bottomCenter,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: wv * 80,
                                  child: TextButton(
                                    onPressed: () async {
                                         if (kDebugMode) {
                                           print("fdskfjgdskjfhdljksflkjsdflkjsdhfkljasdfhjkdasf");
                                         }
                                      // if (adherent.enable == false) {
                                      //   showDialog(
                                      //       context: context,
                                      //       builder: (BuildContext context) =>
                                      //           _buildAboutDialog(
                                      //               context, false));
                                      // } else {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           OwnerUserListView(
                                        //             idOfAdherent:
                                        //                 widget.phoneNumber,
                                        //           )),
                                        // );
                                      //}
                                      print(userSelected);
                                       final Map<String, dynamic> userData = {
                                            'codeConsultation': code,
                                            'createdDate': DateTime.now()
                                          };
                                       
                                       if(userSelected!=-1){
                                         if (kDebugMode) {
                                           print(adherentModelProvider!.getAdherent!.adherentId);
                                           print(doctorProvider.getDoctor!.id);
                                         }
                                             var usecase= FirebaseFirestore.instance.collection('USECASES')
                                              .where('adherentId', isEqualTo: adherentModelProvider!.getAdherent!.adherentId ).where('idMedecin',isEqualTo:doctorProvider.getDoctor!.id).orderBy('createdDate').get(); 
                                              usecase.then((value) async {
                                                if (kDebugMode) {
                                                  print(value.docs.isEmpty);
                                                }
                                                    if(value.docs.length==0){    
                                                      // cette consultation existe pas encore    
                                                      //  Timestamp t = adherentModelProvider.getAdherent.codeConsult['createdDate'];
                                                      //   DateTime d = t.toDate();
                                                      //   final date2 = DateTime.now();
                                                      //   final difference = date2.difference(d).inDays;
                                                      //    adherentModelProvider.getAdherent.codeConsult['createdDate']
                                                       if (kDebugMode) {
                                                         print("-------nnnnnnn--------${adherentModelProvider!.getAdherent!.codeConsult}");
                                                       }
                                                      // print("--------------------${adherentModelProvider.getAdherent.codeConsult.isEmpty}");
                                                      if(adherentModelProvider!.getAdherent!.codeConsult==null){
                                                        if (kDebugMode) {
                                                          print('dksjfhdsjkfhsdjklfhdskjfhdsjkfh');
                                                        }
                                                        setState(() {
                                                              isRequestLaunch=true;
                                                            });
                                                          await createConsultationCode(exists: widget.isAccountIsExists!, id: null).then((value) async {
                                                              await facturationCode(value);
                                                              await addCodeToAdherent(userData);
                                                              adherentModelProvider?.getAdherent!.codeConsult=userData;
                                                              setState(() {
                                                              isRequestLaunch=false;
                                                            });
                                                            
                                                          }).then((value){
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      OwnerUserListView(
                                                                        idOfAdherent:
                                                                            widget.phoneNumber!,
                                                                        beneficiare: adherentUserSelected!,
                                                                        consultationCode:  adherentModelProvider!.getAdherent!.codeConsult!['codeConsultation'],
                                                                        createdAt:  DateTime.now(),
                                                                      )),
                                                            ); 
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text(S.of(context)!.uneFactureVientDtreCrerPourCette)));
                                                          });
                                                      }else{
                                                         Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      OwnerUserListView(
                                                                        idOfAdherent:
                                                                            widget.phoneNumber!,
                                                                        beneficiare: adherentUserSelected!,
                                                                        consultationCode:  adherentModelProvider?.getAdherent!.codeConsult!['codeConsultation'],
                                                                        createdAt:  DateTime.now(),
                                                                      )),
                                                            ); 
                                                      }
                                                          
                                                    }else if(value.docs.isNotEmpty){
                                                    Timestamp t = adherentModelProvider?.getAdherent!.codeConsult!['createdDate'].runtimeType==DateTime?Timestamp.fromDate(adherentModelProvider?.getAdherent!.codeConsult!['createdDate']):adherentModelProvider?.getAdherent!.codeConsult!['createdDate'];
                                                    DateTime d = t.toDate();
                                                   if (kDebugMode) {
                                                     print(t);
                                                     print(d);
                                                   }
                                                  final date2 = DateTime.now(); 
                                                  final difference = date2.difference(d).inDays;
                                                  if (kDebugMode) {
                                                    print(difference);
                                                  }
                                                        if( difference>14 && adherentModelProvider?.getAdherent!.codeConsult!=null ){
                                                                if (kDebugMode) {
                                                                  print('jfhsdkfhdjksf');
                                                                }
                                                                  setState(() {
                                                                    isRequestLaunch=true;
                                                                  });
                                                                await createConsultationCode(exists: widget.isAccountIsExists!, id: null).then((value) async {
                                                                    await facturationCode(value);
                                                                    await addCodeToAdherent(userData);
                                                                    adherentModelProvider?.getAdherent!.codeConsult=userData;
                                                                    setState(() {
                                                                    isRequestLaunch=false;
                                                                  });
                                                                  
                                                                }).then((value){
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            OwnerUserListView(
                                                                              idOfAdherent:
                                                                                  widget.phoneNumber!,
                                                                              beneficiare: adherentUserSelected!,
                                                                              consultationCode: adherentModelProvider!.getAdherent!.codeConsult!['codeConsultation'],
                                                                              createdAt:  DateTime.now(),
                                                                            )),
                                                                  ); 
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text(S.of(context)!.uneFactureVientDtreCrerPourCette)));
                                                                });
                                                        }else{
                                                          Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            OwnerUserListView(
                                                                              idOfAdherent:
                                                                                  widget.phoneNumber!,
                                                                              beneficiare: adherentUserSelected!,
                                                                              consultationCode:  adherentModelProvider?.getAdherent!.codeConsult!['codeConsultation'],
                                                                              createdAt:  DateTime.now(),
                                                                            )),
                                                                  ); 
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text(S.of(context)!.redirtectionVersLeCarnet)));
                                                        }
                                                          
                                                    }
                                                    else{
                                                        Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      OwnerUserListView(
                                                                        idOfAdherent:
                                                                            widget.phoneNumber!,
                                                                        beneficiare: adherentUserSelected!,
                                                                        consultationCode:  code,
                                                                        createdAt:  DateTime.now(),
                                                                      )),
                                                            ); 
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text(S.of(context)!.redirectionVersLeCarnet)));
                                                          }
                                                    });
                                         
                                         
                                        
                                      }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context)!.selectionerUnBeneficiaireAvantDeValider)));
                                      }
                                    },
                                    child:adherentUserSelected!=null ? Row(
                                      children: [
                                      Padding(padding: EdgeInsets.only(left: 10.w),
                                      child: HomePageComponents().getAvatar(
                                          imgUrl: adherentUserSelected!.avatarUrl ?? 'assets/images/avatar-profile.jpg' ,
                                          size: 15.0,
                                          renoveIsConnectedButton: false
                                        ),),
                                        const Spacer(),
                                        Text(
                                            S.of(context)!.carnetDe+adherentUserSelected!.cniName!.toString(),
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: wv * 4.5,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        const Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(right:10.h),
                                          child: SvgPicture.asset(
                                            'assets/icons/Bulk/Left.svg',
                                            width: wv * 6,
                                          color: whiteColor
                                          ),
                                        ),
                                      ],
                                    ): Text(
                                          S.of(context)!.accederAuCarnetDeSante,
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: wv * 4.5,
                                              fontWeight: FontWeight.w600),
                                        ),
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                          const  EdgeInsets.symmetric(vertical: 10)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                kFirstIntroColor),
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25))))),
                                  ),
                                ),
                              ),
                          ),
                            
                    ])))));
  }
}