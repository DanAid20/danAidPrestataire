
// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/models/devisModel.dart';
import 'package:danaid/core/models/useCaseServiceModel.dart';
import 'package:danaid/core/providers/ServicesProviderInvoice.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/serviceprovider/OrdonancePatient.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class PrestationEnCours extends StatefulWidget {
  final bool? isbeneficiare;
  final String? userId;
  final BeneficiaryModel? data;
  PrestationEnCours({Key? key, this.userId, this.isbeneficiare, this.data}) : super(key: key);

  @override
  _PrestationEnCoursState createState() => _PrestationEnCoursState();
}

class _PrestationEnCoursState extends State<PrestationEnCours> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool? isGetdevis=false;
   Timestamp? dateNaiss;
   num? prixDAnaid, prixpatient;
   String? userId, urlImage, username;
   List<String>? urlImg;
   List? deletedData=[];
   List<DevisModel>? devis=[];
   @override
   void initState() {
     super.initState();
     
   }

 
  @override
  Widget build(BuildContext context) {
     ServiceProviderModelProvider prestataire = Provider.of<ServiceProviderModelProvider>(context);
    var prestatiaireObject= prestataire.getServiceProvider;
    if (kDebugMode) {
      print(prestatiaireObject!.id);
      print(userId.toString());
    }
     Stream<QuerySnapshot> query = widget.isbeneficiare==false? FirebaseFirestore.instance.collectionGroup('PRESTATIONS').where("adherentId", isEqualTo: widget.userId).where('prestataireId', isEqualTo: prestatiaireObject!.id).snapshots():
     FirebaseFirestore.instance.collectionGroup('PRESTATIONS').where("beneficiaryId", isEqualTo: widget.userId).where('prestataireId', isEqualTo: prestatiaireObject!.id).snapshots();

    return  WillPopScope(
      onWillPop:()async{
         Navigator.pop(context);
         return true;
      },
      child: Scaffold(
      key: _scaffoldKey,  
      appBar: AppBar(
          backgroundColor:  kGoldlightYellow,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: kDateTextColor,
              ),
              onPressed: () => Navigator.pop(context)),
          title: Align(
            alignment: Alignment.center,
            child: Container(
              child: Column(
                children: [
                  Text("Prestations", style: TextStyle(color: kDateTextColor, fontSize: wv*4, fontWeight: FontWeight.w600), ),
                  Text("du ${widget.userId}", style: TextStyle(color: kDateTextColor, fontSize: wv*4, fontWeight: FontWeight.w400), ),
                  
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/Bulk/Search.svg',
                color: kSouthSeas,
              ),
              onPressed: () {},
              color: kSouthSeas,
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/Bulk/Drawer.svg',
                color: kSouthSeas,
              ),
              onPressed: () {},
              color: kSouthSeas,
            )
          ],
        ),
       body: SafeArea(child:
       Container(
         child: 
          Column(
            children: [
              
                SizedBox(height: hv*0.3,),
            // HomePageComponents().paiementPrestaireItem(
            //   lastDatePaiement: "gfdg",
            //   month:"Devis N.123456", 
            //   paidAllReady: "fdf",
            //   paidOrNot: 1,
            //   prix: "12452", 
            //   redirectOncliked: (){
            //   //   Navigator.push(
            //   //   context,
            //   //   MaterialPageRoute(
            //   //       builder: (context) =>
            //   //           OrdonanceDuPatient(idOfAdherent: )),
            //   // );
            //   }
            //   ),
            // HomePageComponents().paiementPrestaireItem(
            //   lastDatePaiement: "gfdg",
            //   month:"Devis N.123456", 
            //   paidAllReady: "fdf",
            //   paidOrNot: 2,
            //   prix: "12452"
            //   ),
            // HomePageComponents().paiementPrestaireItem(
            //   lastDatePaiement: "gfdg",
            //   month:"Devis N.123456", 
            //   paidAllReady: "fdf",
            //   paidOrNot: 0,
            //   prix: "12452"
            //   )
              StreamBuilder(
                stream: query,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                      return Center(
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
                        UseCaseServiceModel service = UseCaseServiceModel.fromDocument(doc, doc.data() as Map);

                        return  HomePageComponents().prestataireItemList(
                            etat: service.paid!? 1:0,
                            montant: DateFormat("dd MMMM yyy ")
                                .format(service.dateCreated!.toDate()),
                            date:"${service.title}- ${service.amount}.f" ,
                            nom: "${service.titleDuDEvis}",
                            iconesConsultationTypes:Algorithms.getUseCaseServiceIcon(type: service.type!), 
                            redirectOncliked: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                OrdonanceDuPatient(devis: service))
                                );
                            }
                        );

                     }
                  ): SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                      child: Text(S.of(context).aucunDevisNeCorrespondACePatient),
                ),
                    ),
                  );
                },
              ),

            ],
          ),
       )
        ,),
      ),
    );
    
      
  }
}