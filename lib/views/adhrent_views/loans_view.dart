import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/loanModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/loanModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/advantage_card.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Loans extends StatefulWidget {
  @override
  _LoansState createState() => _LoansState();
}

class _LoansState extends State<Loans> with TickerProviderStateMixin {

  TabController _loanTabController;
  TextEditingController _amountController = new TextEditingController();

  @override
  void initState() {
    _loanTabController = new TabController(length: 2, vsync: this);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    LoanModelProvider loanProvider = Provider.of<LoanModelProvider>(context);
    AdherentModel adh = adherentProvider.getAdherent;

    bool enable = userProvider.getUserModel.enable == null ? false : userProvider.getUserModel.enable;

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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: hv*2),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: hv*11),
                        padding: EdgeInsets.only(bottom: hv*9),
                        decoration: BoxDecoration(
                          color: kBrownCanyon.withOpacity(0.3),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                        ),
                        child: HomePageComponents.header(title: adh.surname + " " + adh.familyName, subtitle: adh.address.toString(), avatarUrl: adh.imgUrl),
                      ),
                      Positioned(
                        top: hv*5.5,
                        child: Hero(
                          tag: "loanCard",
                          child: AdvantageCard(
                            label: "Prêt de santé",
                            description: "MAXIMUM DISPONIBLE",
                            state: "DISPONIBLE",
                            price: adherentProvider.getAdherent.adherentPlan == 0 ? "#50.000 f." : adherentProvider.getAdherent.adherentPlan == 1 ? "#100.000 f." : adherentProvider.getAdherent.adherentPlan == 2 ? "#150.000 f." : "#200.000 f.",
                            showLogo: true,
                            color: Colors.brown.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: wv*90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*0.5),
                          decoration: BoxDecoration(
                            color: kSouthSeas,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text("Rapide", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(width: wv*5,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*0.5),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text("Pour tous", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(width: wv*5,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*0.5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text("Simple", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: hv*2,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(width: wv*3,),
                      Expanded(
                        flex: 6,
                        child: CustomTextField(
                          label: "Je souhaite emprunter",
                          noPadding: true,
                          hintText: "Entrer le montant",
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$')),
                          ],
                          onChanged: (val)=>setState((){}),
                        ),
                      ),
                      SizedBox(width: wv*3,),
                      Expanded(
                        flex: 5,
                        child: CustomTextButton(
                          noPadding: true,
                          expand: false,
                          enable: _amountController.text.isNotEmpty && enable == true,
                          fontSize: 14,
                          borderRadius: 20,
                          text: "Démander un crédit",
                          action: (){
                            double amount = double.parse(_amountController.text);
                            double maxAmount =  adherentProvider.getAdherent.adherentPlan == 0 ? 50000 : adherentProvider.getAdherent.adherentPlan == 1 ? 100000 : adherentProvider.getAdherent.adherentPlan == 2 ? 150000 : 200000;
                            if(amount > maxAmount){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Désolé, votre plan actuel ne vous permet pas d\'emprunter plus de '+maxAmount.toString()+' f.'),));
                            }
                            else{
                              //loanProvider.setAmount(double.parse(_amountController.text));
                              loanProvider.setLoanModel(LoanModel(amount: double.parse(_amountController.text), maxAmount: maxAmount));
                              //loanProvider.setMaxAmount(maxAmount);
                              Navigator.pushNamed(context, '/loan-form');
                            }
                          },
                        ),
                      ),
                      SizedBox(width: wv*3,)
                    ],
                  ),
                  SizedBox(height: hv*1.5,)
                ],
              ),
            ),
            SizedBox(height: hv*2.5,),
            enable ? HomePageComponents.getInfoActionCard(
              icon: SvgPicture.asset('assets/icons/Two-tone/Monochrome.svg'),
              title: "Emprunter coûte de l'argent",
              subtitle: "Un crédit vous engage et doit être remboursé. Vérifiez vos capacités de remboursement avant de vous engager",
              actionLabel: "F.A.Q",
              action: (){}
            ) :  Container(),
            !enable ? Container(
              padding: EdgeInsets.symmetric(vertical: hv*1),
              child: HomePageComponents.getInfoActionCard(
                title: "Completez d'abord votre profil",
                subtitle: "Fournir les informations et pièces démandées pour pouvoir emprunter",
                actionLabel: "Compléter mon profil",
                action: ()=>Navigator.pushNamed(context, '/adherent-profile-edit')
              ),
            ) : Container(),
            adherentProvider.getAdherent.adherentPlan == 0 ? Container(
              padding: EdgeInsets.symmetric(vertical: hv*1),
              child: HomePageComponents.getInfoActionCard(
                title: "Vous êtes au niveau 0 : Découverte",
                subtitle: "Vous devez réferer 3 amis & connaissances pour pouvoir emprunter",
                actionLabel: "Inviter des amis",
                action: (){}
              ),
            ) : Container(),
            SizedBox(height: hv*2.5,),
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
                            controller: _loanTabController,
                            indicatorWeight: 5,
                            indicatorColor: kPrimaryColor,
                            isScrollable: true,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            labelColor: kPrimaryColor,
                            tabs: [
                              Tab(text: "En Cours"),
                              Tab(text: "Achevés"),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: hv*50,
                        child: TabBarView(
                          controller: _loanTabController,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: hv*2),
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance.collection("CREDITS").where('adherentId', isEqualTo: adherentProvider.getAdherent.adherentId).where('status', isEqualTo: 0).orderBy('createdDate', descending: true).snapshots(),
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
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          int lastIndex = snapshot.data.docs.length - 1;
                                          DocumentSnapshot loanDoc = snapshot.data.docs[index];
                                          LoanModel loan = LoanModel.fromDocument(loanDoc);
                                          print("name: ");
                                          return Padding(
                                            padding: EdgeInsets.only(bottom: lastIndex == index ? hv * 5 : 0),
                                            child: HomePageComponents.getLoanTile(
                                              label: "hhgfhfghfh",
                                              doctorName: "gfgdgdfg",
                                              date: loan.dateCreated.toDate(),
                                              firstDate: loan.firstPaymentDate.toDate(),
                                              lastDate: loan.lastPaymentDate.toDate(),
                                              mensuality: loan.mensuality,
                                              type: "gfg",
                                              state: loan.status,
                                              action: (){
                                                /*LoanModelProvider loanProvider = Provider.of<LoanModelProvider>(context, listen: false);
                                                loanProvider.setLoanModel(loan);
                                                Navigator.pushNamed(context, '/loan-details');*/
                                              }
                                            ),
                                          );
                                        })
                                    : Center(
                                      child: Container(padding: EdgeInsets.only(bottom: hv*4),child: Text("Aucune demande de crédit enrégistrée\npour le moment..", textAlign: TextAlign.center)),
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