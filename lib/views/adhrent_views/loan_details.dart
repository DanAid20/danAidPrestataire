import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/loanModel.dart';
import 'package:danaid/core/models/mensualityModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/loanModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LoanDetails extends StatefulWidget {
  const LoanDetails({ Key key }) : super(key: key);

  @override
  _LoanDetailsState createState() => _LoanDetailsState();
}

class _LoanDetailsState extends State<LoanDetails> with TickerProviderStateMixin {

  TabController _loanDetailTabController;

  @override
  void initState() {
    _loanDetailTabController = new TabController(length: 2, vsync: this);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    UserProvider userProvider = Provider.of<UserProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    LoanModelProvider loanProvider = Provider.of<LoanModelProvider>(context);
    LoanModel loan = loanProvider.getLoan;
    AdherentModel adh = adherentProvider.getAdherent;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,),
          onPressed: ()=>Navigator.pop(context)
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Aperçu de mon Prêt Santé", style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
            Text("Ajouter, modifier ou envoyer les pièces", 
              style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          //IconButton(icon: SvgPicture.asset('assets/icons/Two-tone/InfoSquare.svg', color: kSouthSeas,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
          //IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: (){})
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: hv*2),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.grey[700].withOpacity(0.4), blurRadius: 3, spreadRadius: 1.5, offset: Offset(0,4))]
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: hv*1.5),
                    decoration: BoxDecoration(
                      color: kBrownCanyon.withOpacity(0.2),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: hv*1.5),
                          decoration: BoxDecoration(
                            color: kBrownCanyon.withOpacity(0.3),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                          ),
                          child: Column(
                            children: [
                              HomePageComponents.header(label: "Demandeur", title: adh.surname + " " + adh.familyName, subtitle: adh.address.toString(), avatarUrl: adh.imgUrl, titleColor: kTextBlue),
                              SizedBox(height: hv*2),
                              Row(
                                children: [
                                  SizedBox(width: wv*4,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Total à payer", style: TextStyle(fontSize: 16, color: kTextBlue, fontWeight: FontWeight.w600)),
                                      Text(loanProvider.getLoan.totalToPay.toString() + " .f", style: TextStyle(fontSize: 25, color: kTextBlue, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Vos mensualités", style: TextStyle(fontSize: 16, color: kTextBlue, fontWeight: FontWeight.w600)),
                                      Container(
                                        margin: EdgeInsets.only(top: hv*0.2),
                                        padding: EdgeInsets.symmetric(horizontal: wv*6, vertical: hv*0.25),
                                        decoration: BoxDecoration(
                                          color: kBrownCanyon.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Text(Algorithms.getFixedMonthlyMortgageRate(amount: loanProvider.getLoan.amount, rate: adherentProvider.getAdherent.adherentPlan == 0 ? 0.16/12 : 0.05/12, months: loan.duration).toInt().toString() + " .f", style: TextStyle(fontSize: 20, color: kTextBlue, fontWeight: FontWeight.bold))
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: wv*4,),
                                ],
                              )
                            ],
                        )),
                        SizedBox(height: hv*1.5,),
                        Row(
                          children: [
                            SizedBox(width: wv*5),
                            SvgPicture.asset('assets/icons/Two-tone/Monochrome.svg'),
                            SizedBox(width: wv*2),
                            Expanded(child: Text("Rembourser à temps augmente votre niveau de crédit.", style: TextStyle(fontSize: 15, color: kTextBlue))),
                            SizedBox(width: wv*5)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*1.5),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Durée", style: TextStyle(fontSize: 15, color: kTextBlue)),
                            SizedBox(height: 5),
                            Container(
                              width: wv*40,
                              padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Text(loan.duration.toString() + " Mois", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600, fontSize: 16),),
                            )
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date de fin", style: TextStyle(fontSize: 15, color: kTextBlue)),
                            SizedBox(height: 5),
                            Container(
                              width: wv*40,
                              padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Text(loan.lastPaymentDate.toDate().day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(loan.lastPaymentDate.toDate())+" "+ loan.lastPaymentDate.toDate().year.toString(), style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600, fontSize: 16),),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: hv*5,),
            Container(
              decoration: BoxDecoration(
                color: whiteColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: hv*2,),
                  Text("   Statut des emprunts", style: TextStyle(color: kPrimaryColor, fontSize: 16),),
                  SizedBox(height: hv*2,),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.only(left: wv*3),
                          child: TabBar(
                            controller: _loanDetailTabController,
                            indicatorWeight: 5,
                            indicatorColor: kPrimaryColor,
                            isScrollable: true,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            labelColor: kPrimaryColor,
                            tabs: [
                              Tab(text: "En Cours"),
                              Tab(text: "Effectués"),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: hv*50,
                        child: TabBarView(
                          controller: _loanDetailTabController,
                          children: [
                            Container(
                              //margin: EdgeInsets.symmetric(vertical: hv*2),
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance.collectionGroup("MENSUALITES").where('loanId', isEqualTo: loan.id).where('status', isEqualTo: 0).orderBy('number').snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                                      ),
                                    );
                                  }
                                  return snapshot.data.docs.length >= 1
                                    ? ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          int lastIndex = snapshot.data.docs.length - 1;
                                          DocumentSnapshot mensualityDoc = snapshot.data.docs[index];
                                          MensualityModel mensuality = MensualityModel.fromDocument(mensualityDoc);
                                          print("name: ");
                                          return Padding(
                                            padding: EdgeInsets.only(bottom: lastIndex == index ? hv * 5 : 0),
                                            child: HomePageComponents.getLoanTile(
                                              label: "hhgfhfghfh",
                                              subtitle: "",
                                              date: mensuality.startDate.toDate(),
                                              firstDate: mensuality.startDate.toDate(),
                                              lastDate: mensuality.endDate.toDate(),
                                              mensuality: mensuality.amount.toInt(),
                                              type: "gfg",
                                              state: mensuality.status,
                                              action: (){}
                                            ),
                                          );
                                        })
                                    : Center(
                                      child: Container(padding: EdgeInsets.only(bottom: hv*4, right: wv*5, left: wv*5),child: Text("Votre demande de crédit ne respecte pas le nouveau format. Veillez récommencer la procédure s'il vous plait", textAlign: TextAlign.center)),
                                    );
                                }
                              ),
                            ),
                            Container(),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
            
          ],
        ),
      ),
    
    );
  }
}