import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/views/doctor_views/services_doctor_views/owner_userList_View.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/doctorModelProvider.dart';
import '../../../helpers/constants.dart';
import '../../../widgets/home_page_mini_components.dart';
import '../../../helpers/utils.dart';

class InactiveAccount extends StatefulWidget {
  final AdherentModel data;
  final bool isAccountIsExists;
  final String phoneNumber;
  final String consultationType;
  InactiveAccount(
      {Key key, this.data, this.isAccountIsExists, this.phoneNumber, this.consultationType})
      : super(key: key);

  @override
  _InactiveAccountState createState() => _InactiveAccountState();
}

class _InactiveAccountState extends State<InactiveAccount> {
  bool isActive;
  AdherentModelProvider adherentModelProvider;
  int userSelected=-1;
  AdherentModel adherentUserSelected;
  bool isloading=false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isAccountIsExists == false) {
        await showDialog<String>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) =>
                _buildAboutDialog(context, true));
      }
    });
  }

  createConsultationCode() async {
     DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection('MEDECINS').doc(doctorProvider.getDoctor.id)
    .collection('CONSULATION_CODE').doc(getRandomString(4)).set({
      'id': getRandomString(4),
      'idAdherent': adherentUserSelected.adherentId,
      'idBeneficiairy':adherentUserSelected.adherentId,
      'createdAt':  DateTime.now(),
      'enable': true,
    }, SetOptions(merge: true)).then((value) {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Le Code ce consultation creer avec succes comme médecin de famille..")));
        
      }).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          isloading = false;
        });
      });
  }
  facturationCode() async {
     DoctorModelProvider doctorProvider =
        Provider.of<DoctorModelProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection('MEDECINS').doc(doctorProvider.getDoctor.id)
    .collection('FACTURATIONS').doc().set({
      'id':'',
      'idAdherent': adherentUserSelected.adherentId,
      'idBeneficiairy':adherentUserSelected.adherentId,
      'idMedecin':doctorProvider.getDoctor.id,
      'amountToPay':'2000',
      'isSolve':false,
      'Type': widget.consultationType ,
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
  getUserSelected(int index, AdherentModel adherent ){
    setState(() {
      userSelected=index;
      adherentUserSelected= adherent;
    });
    print(userSelected);
    print(adherentUserSelected);
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
  getListOfUser() {
    Stream<QuerySnapshot> query = FirebaseFirestore.instance
        .collection("ADHERENTS")
        .doc('${widget.phoneNumber}')
        .collection('BENEFICIAIRES')
        .snapshots();
    return StreamBuilder(
        stream: query,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("un instant svp "),
                    SizedBox(
                      height: 50.0,
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              );
          }else{
            return snapshot.data.docs.length >= 1
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  //shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data.docs[index];
                    AdherentModel doctor = AdherentModel.fromDocument(doc);
                    print("name: ");
                    return index==0 ?Container(
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: HomePageComponents().getAdherentsList(
                              adherent: widget.data, isAccountIsExists: true, index: index, onclick: getUserSelected, iSelected:userSelected )),
                    )  : Container(
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: HomePageComponents().getAdherentsList(
                              adherent: doctor, isAccountIsExists: true, index: index, onclick:getUserSelected, iSelected:userSelected )),
                    );
                  })
              : Center(
                  child: Text("Aucun Adherent  disponible pour le moment.."),
                );
          }
          
        });
  }
   

  String getRandomString(int length){
  const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random _rnd = Random();
    var result= String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)))); 
    return 'YM'+result;
  } 
  
  Widget _buildAboutDialog(BuildContext context, bool isIninitState) {
    adherentModelProvider = Provider.of<AdherentModelProvider>(context);
    AdherentModel adherent = adherentModelProvider.getAdherent;

    return Container(
      color: backgroundOverlayColor.withOpacity(0.8),
      child: WillPopScope(
        onWillPop: () {
          if (isIninitState == true) {
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        },
        child: new AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: cardColor,
          scrollable: true,
          elevation: 8.0,
          content: Container(
            width: wv * 100,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            widget.isAccountIsExists == false
                                ? 'Le numéro'
                                : 'Le Compte de l\'adherent',
                            style: TextStyle(
                              color: kBlueForce,
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize(size: 21),
                            )),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            widget.isAccountIsExists == false &&
                                    widget.phoneNumber != null
                                ? widget.phoneNumber
                                : ' est inatif',
                            style: TextStyle(
                              color: kBlueForce,
                              fontWeight: FontWeight.w700,
                              fontSize: fontSize(size: 21),
                            )),
                      ),
                      Align(
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
                                ? 'N\'est pas encore adherent a la mutuelle sante DanAid.Recommncer La mutuelle et devenez le medecin de famille de votre patient'
                                : 'L’adhérent n’etant pas à jour de ses cotisation, vous ne bénéficierez pas de la compensation dans le parsours de soins  DanAid.',
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
                              ? 'Vous recevrez la compensation DanAid(2.000 Cfa) si la famille adh7re a la mutuelle'
                              : 'Poursuivez la consultation hors parcours de soin DanAid',
                          style: TextStyle(
                              color: kBlueForce,
                              fontSize: fontSize(size: 17),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: hv * 10.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: new Container(
                    width: wv * 100,
                    margin:
                        EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 15),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: wv * 100,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[500],
                                spreadRadius: 0.5,
                                blurRadius: 3),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildAboutDialog(context, false),
                            );
                          },
                          child: Text(
                            widget.isAccountIsExists == true
                                ? 'Ajouter une famille'
                                : 'Poursuivre hors parcours',
                            style: TextStyle(
                                color: textColor,
                                fontSize: wv * 4.5,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.w600),
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: 15)),
                              backgroundColor:
                                  MaterialStateProperty.all(kFirstIntroColor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))))),
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
    AdherentModel adherent = adherentModelProvider.getAdherent;

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
                    children: [Text('Famille'), Text('...')],
                  ),
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
                        padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
                        child: widget.isAccountIsExists==true ?  Container(
                          margin: EdgeInsets.only(left:15.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: hv * 60,
                              margin: EdgeInsets.only(left:3.w),
                              child: getListOfUser(),),
                              SvgPicture.asset(
                                'assets/icons/Bulk/Dots.svg',
                                color: kSouthSeas,
                                height: hv * 5,
                                width: wv * 5,
                              ),
                            ],
                          )   
                        ) : Container(
                      child: Padding(
                          padding: EdgeInsets.all(2),
                          child: HomePageComponents().getAdherentsList( isAccountIsExists: false)),
                    ) ,
                      ),
                      widget.isAccountIsExists == false
                          ? SizedBox.shrink()
                          : Container(
                            alignment: Alignment.bottomCenter,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: wv * 80,
                                  margin: EdgeInsets.only(top: hv * 2),
                                  child: TextButton(
                                    onPressed: () async {
                                      // if (adherent.enable == false) {
                                      //   showDialog(
                                      //       context: context,
                                      //       builder: (BuildContext context) =>
                                      //           _buildAboutDialog(
                                      //               context, false));
                                      // } else {
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             OwnerUserListView(
                                      //               idOfAdherent:
                                      //                   widget.phoneNumber,
                                      //             )),
                                      //   );
                                      // }
                                      if(userSelected!=-1){
                                      await createConsultationCode();
                                      await facturationCode();
                                      }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selectioner un beneficiaire avant de valider")));
                                      }
                                    },
                                    child: Text(
                                      'Acceder au carnet de Sante',
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: wv * 4.5,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(vertical: 10)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                kFirstIntroColor),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25))))),
                                  ),
                                ),
                              ),
                          ),
                            
                    ])))));
  }
}
