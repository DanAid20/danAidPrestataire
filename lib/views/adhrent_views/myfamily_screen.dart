import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:danaid/widgets/user_avatar_coverage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MyFamilyScreen extends StatefulWidget {
  @override
  _MyFamilyScreenState createState() => _MyFamilyScreenState();
}

class _MyFamilyScreenState extends State<MyFamilyScreen> {

  getBeneficiary(){
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection("BENEFICIAIRES").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData){
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),);
        }
        print(snapshot.data.toString() + "rfrfr");
        return Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(text: TextSpan(
              text: "Bénéficiaires\n",
              children: [
                TextSpan(text: snapshot.data.docs.length.toString()+" personnes", style: TextStyle(color: kPrimaryColor, fontSize: wv*3.5)),
              ], style: TextStyle(color: kPrimaryColor, fontSize: wv*5)),
            ),
            SizedBox(height: hv*2,),
            Container(
              height: hv*22,
              child: snapshot.data.docs.length >= 1 ? ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
                DocumentSnapshot doc = snapshot.data.docs[index];
                BeneficiaryModel beneficiary = BeneficiaryModel.fromDocument(doc);
                print("name: ");
                return HomePageComponents.beneficiaryCard(
                  name: beneficiary.surname, 
                  imgUrl: beneficiary.avatarUrl, 
                  action: (){}
                );
            }
          ) : Center(child: Text("Vous n'avez pas encore ajouté de bénéficiaire..", style: TextStyle(color: kTextBlue, fontSize: wv*4.5)),)
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: hv*10,
        title: UserAvatarAndCoverage(),
        actions: [
          Column(crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Setting.svg', width: wv*10), onPressed: (){}),
              Container(
                child: Row(
                  children: [
                    Text("12 000 Pts", style: TextStyle(fontSize: inch*1.3, fontWeight: FontWeight.w700, color: Colors.teal[400]),),
                    SizedBox(width: wv*2,),
                    ((adherentProvider.getAdherent.adherentPlan == 1) | (adherentProvider.getAdherent.adherentPlan == 2) | (adherentProvider.getAdherent.adherentPlan == 3)) ? SvgPicture.asset("assets/icons/Bulk/Shield Done.svg", width: 18,) : Container(),
                    SvgPicture.asset("assets/icons/Bulk/Ticket Star.svg", width: 18,),
                  ],
                ),
              )
            ],
          )
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: wv*3),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Aperçu de votre couverture"),
                  TextButton(onPressed: (){}, child: Text("Améliorer...", style: TextStyle(color: Colors.brown),)),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: wv*3),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*3),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(text: TextSpan(
                          text: "Vous bénéficiez d'une ",
                          children: [
                            TextSpan(text: "rémise de 5%", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: " dans certaines pharmacies & Labos du réseau DanAid")
                          ]
                        , style: TextStyle(color: kBlueDeep, fontSize: wv*3.5)),
                        ),
                        TextButton(onPressed: (){},
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), shadowColor: MaterialStateProperty.all(Colors.grey[50].withOpacity(0.5))),
                          child: Text("Obtenez une couverture complète à 70% !", style: TextStyle(color: kDeepTeal, fontSize: wv*3.5, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: wv*3, right: hv*4, left: wv*3, top: wv*3),
                        decoration: BoxDecoration(
                          color: kSouthSeas.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: getBeneficiary(),
                      ),
                      Positioned(
                        right: wv*0, bottom: hv*8,
                        child: IconButton(
                          onPressed: (){ Navigator.pushNamed(context, '/add-beneficiary'); },
                          icon: CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            radius: wv*4,
                            child: Icon(Icons.add, color: Colors.white,),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [BoxShadow(color: Colors.grey[200], spreadRadius: 3.0, blurRadius: 5.0)]
              ),
              margin: EdgeInsets.only(top: hv*4),
              padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Paramètres du compte", style: TextStyle(color: kBlueDeep, fontSize: wv*4)),
                  SizedBox(height: hv*2,),
                  HomePageComponents.accountParameters(
                    title: "Domicile Principale", 
                    subtitle: "Ndog-bong, Douala ou Hôpital à choisir.", 
                    svgIcon: "assets/icons/Two-tone/Home.svg", 
                    action: (){}
                  ),
                  HomePageComponents.accountParameters(
                    title: "Points et badges", 
                    subtitle: "Ndog-bong, Douala ou Hôpital à choisir.", 
                    svgIcon: "assets/icons/Bulk/TicketStarLine.svg", 
                    action: (){}
                  ),
                  HomePageComponents.accountParameters(
                    title: "Votre niveau de service", 
                    subtitle: "Contacts, documents, bénéfices.", 
                    svgIcon: "assets/icons/Bulk/ShieldLine.svg", 
                    action: (){}
                  ),
                  HomePageComponents.accountParameters(
                    title: "Changez de medecin de famille", 
                    subtitle: "Moyens et fréquence des paiements", 
                    svgIcon: "assets/icons/Bulk/Stethoscope.svg", 
                    action: (){}
                  ),

                  SizedBox(height: hv*10,)
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
  Widget marginX = SizedBox(width: wv*3,);
}