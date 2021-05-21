import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/usecaseModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MyCoverageTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              SizedBox(height: hv*2,),
              adherentProvider.getAdherent != null ? Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  boxShadow: [BoxShadow(color: Colors.grey[350], spreadRadius: 0.5, blurRadius: 1.0)],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(inch*1), topRight: Radius.circular(inch*1), bottomLeft: Radius.circular(inch*1),)
                ),
                margin: EdgeInsets.symmetric(horizontal: wv*3),
                child: IntrinsicHeight(
                  child: Row(crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(Icons.message, size: 35, color: Colors.teal[300],),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: hv*1,),
                            Text(
                              adherentProvider.getAdherent.adherentPlan == 0 ? "Vous êtes au Niveau 0: Découverte"
                               : adherentProvider.getAdherent.adherentPlan == 1 ? "Vous êtes au Niveau I: Accès"
                               : adherentProvider.getAdherent.adherentPlan == 2 ? "Vous êtes au Niveau II: Assist"
                               : adherentProvider.getAdherent.adherentPlan == 3 ? "Vous êtes au Niveau III: Sérénité" : "..."
                              , style: TextStyle(color: kPrimaryColor, fontSize: inch*1.7, fontWeight: FontWeight.bold)
                            ),
                            //Text("Votre garantie expire dans 365 jours", style: TextStyle(color: kPrimaryColor, fontSize: inch*1.5)),
                            SizedBox(height: hv*1,),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(inch*1), bottomLeft: Radius.circular(inch*1),),
                            color: kPrimaryColor,
                          ),
                          child: Center(child: Text("Comparer Les Services", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
                        ),
                      )
                    ],
                  ),
                ),
              )
              : 
              Center(child: Loaders().buttonLoader(kPrimaryColor)),

              SizedBox(height: hv*2,),

              GestureDetector(
                onTap: ()=>Navigator.pushNamed(context, '/rdv'),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: hv*2),
                  color: whiteColor,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*1),
                    margin: EdgeInsets.symmetric(horizontal: wv*3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(inch*2.5)),
                      boxShadow: [
                        BoxShadow(blurRadius: 5.0, color: Colors.grey[400], spreadRadius: 1.0, offset: Offset(0, 5))
                      ],
                      image: DecorationImage(image: AssetImage("assets/images/CoverageBanner.png"), fit: BoxFit.cover)
                    ),
                    child: Column(children: [
                      Align(child: SvgPicture.asset("assets/icons/Two-tone/Bookmark.svg"),alignment: Alignment.topRight,),
                      SizedBox(height: hv*5,),
                      Text("Démarrer une prise en charge", style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800)),
                      SizedBox(height: hv*1,),
                      Text("Vous êtes malades ? Commencez ici\npour obtenir la couverture de vos frais", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                      SizedBox(height: hv*2,),
                    ],crossAxisAlignment: CrossAxisAlignment.start, ),
                  ),
                ),
              ),
              SizedBox(height: wv*3,),
              Column(mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(scrollDirection: Axis.horizontal, physics: BouncingScrollPhysics(),
                  child: Row(children: [
                    SizedBox(width: wv*1.5,),
                    GestureDetector(
                      onTap: ()=>Navigator.pushNamed(context, '/adherent-card'),
                      child: HomePageComponents().getMyCoverageOptionsCard(
                        imgUrl: "assets/images/presentCard.png",
                        label: "Présenter ma carte d'adhérant",
                        labelColor: kPrimaryColor
                      ),
                    ),
                    HomePageComponents().getMyCoverageOptionsCard(
                      imgUrl: "assets/images/TrackSavings.png",
                      label: "Suivre mes côtisations",
                      labelColor: Colors.white
                    ),
                    GestureDetector(
                      onTap: ()=>Navigator.pushNamed(context, '/refund-form'),
                      child: HomePageComponents().getMyCoverageOptionsCard(
                        imgUrl: "assets/images/TrackSavings.png",
                        label: "Demander un remboursement",
                        labelColor: Colors.white
                      ),
                    ),
                  ],),
                  ),
                ],
              ),
              SizedBox(height: hv*2),
              Container(
                color: whiteColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),
                  child: Row(children: [
                    Text("Utilisation", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                    //Text("Voir plus..")
                  ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                ),
              ),
              Container(
                color: whiteColor,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("USECASES").where('adherentId', isEqualTo: adherentProvider.getAdherent.adherentId).orderBy('createdDate', descending: true).snapshots(),
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
                            DocumentSnapshot useCaseDoc = snapshot.data.docs[index];
                            UseCaseModel useCase = UseCaseModel.fromDocument(useCaseDoc);
                            print("name: ");
                            return Padding(
                              padding: EdgeInsets.only(bottom: lastIndex == index ? hv * 5 : 0),
                              child: HomePageComponents().getMyCoverageHospitalsTiles(
                                initial: useCase.establishment.toUpperCase().substring(0,3),
                                name: useCase.establishment,
                                date: useCase.dateCreated.toDate(),
                                state: useCase.status,
                                price: "",
                                action: (){
                                  /*AppointmentModelProvider appointmentProvider = Provider.of<AppointmentModelProvider>(context, listen: false);
                                  appointmentProvider.setAppointmentModel(appointment);
                                  _doc != null ? doctorProvider.setDoctorModel(_doc) : print("nope");
                                  Navigator.pushNamed(context, '/appointment');*/
                                }
                              ),
                            );
                          })
                      : Center(
                        child: Container(child: Text("Aucun cas d'utilisation enrégistré pour le moment..", textAlign: TextAlign.center)),
                      );
                    /*return Container(
                      color: whiteColor,
                      child: Column(
                        children: [
                          HomePageComponents().getMyCoverageHospitalsTiles(
                            initial: "HLD",
                            name: "Hopital Laquintinie de Douala",
                            date: "Mercredi, 23 Janvier 2021",
                            price: "127.000 f.",
                            state: 0,
                          ),
                          HomePageComponents().getMyCoverageHospitalsTiles(
                            initial: "CNM",
                            name: "Cabinet Dr. Manaouda Malachie",
                            date: "Mercredi, 23 Janvier 2021",
                            price: "6.000 f.",
                            state: 1,
                          ),
                          HomePageComponents().getMyCoverageHospitalsTiles(
                            initial: "HLD",
                            name: "Hopital Laquintinie de Douala",
                            date: "Mercredi, 23 Janvier 2021",
                            price: "127.000 f.",
                            state: 0,
                          ),
                        ],
                      ),
                    );*/
                  }
                ),
              ),
              SizedBox(height: hv*3,),
            ],
          ),
        ),
      ],
    );
  }
}