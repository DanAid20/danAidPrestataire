
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/models/devisModel.dart';
import 'package:danaid/core/providers/ServicesProviderInvoice.dart';
import 'package:danaid/core/providers/serviceProviderModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/serviceprovider/OrdonancePatient.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
class PrestationEnCours extends StatefulWidget {
  final bool isbeneficiare;
  final String userId;
  final BeneficiaryModel data;
  PrestationEnCours({Key key, this.userId, this.isbeneficiare, this.data}) : super(key: key);

  @override
  _PrestationEnCoursState createState() => _PrestationEnCoursState();
}

class _PrestationEnCoursState extends State<PrestationEnCours> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isGetdevis=false;
   Timestamp dateNaiss;
   num prixDAnaid, prixpatient;
   String userId, urlImage, username;
   List<String> urlImg;
   List deletedData=[];
   List<DevisModel> devis=[];
   @override
   void initState() {
     super.initState();
     
   }
//     Future<void> getDevis(String code)  async {
//      print("--------------------------------");
//       List<Future<QuerySnapshot>> futures = [];
//       var query= FirebaseFirestore.instance
//           .collection('DEVIS');
//     var firstQuery = query
//         .where('adherentId', isEqualTo: code)
//         .get();

//     var secondQuery = query
//         .where('beneficiaryId', isEqualTo: code)
//         .get();

//     futures.add(firstQuery);
//     futures.add(secondQuery);

//     List<QuerySnapshot> results = await Future.wait(futures);
//     results.forEach((res) {
//       res.docs.forEach((docResults) {
//           if(docResults.data().isNotEmpty){
//             print(docResults.data());
//             // docResults.data().forEach((element) {
//             //   setState(() {
//             //   devis.add(DevisModel.fromDocument(element));
//             // });
//             // });
//           }else{
//             devis=[];
//           }
//       });
//     });
//     //  var result= FirebaseFirestore.instance
//     //       .collection('DEVIS').where('userId', isEqualTo: code).get()
//     //       .then((value) {
//     //   }).onError((error, stackTrace) {
//     //       print(error);
//     //       print(stackTrace);
//     //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("une erreur s'est produite "),));
//     //   });
//    print("--------------------------------");
//  }
//     Future<void> getAdhenents(String code)  async {
//      print("--------------------------------");
//      setState(() {
//             isGetdevis=true;
//           });
//      await FirebaseFirestore.instance
//           .collection('APPOINTMENTS').doc(code).get()
//           .then((value) {
//           print(code);
//           print(value.data().toString());
//         if (value.data()!=null) {
//           setState(() {
//            userId= code;
//            dateNaiss= value.data()['birthDate'];
//            urlImage= value.data()['avatarUrl'];
//            username= value.data()['username'];
//           });
//         }else {
//            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("cet utilisateur n'existe pas "),));
//            setState(() {
//             isGetdevis=false;
//           });
//         }
//       }).onError((error, stackTrace) {
//          setState(() {
//             isGetdevis=false;
//           });
//           print(error);
//           print(stackTrace);
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("une erreur s'est produite "),));
//       });
//    print("--------------------------------");
//  }
 
  @override
  Widget build(BuildContext context) {
     ServiceProviderModelProvider prestataire = Provider.of<ServiceProviderModelProvider>(context);
    var prestatiaireObject= prestataire.getServiceProvider;
    print(devis.length);
     Stream<QuerySnapshot> query = widget.isbeneficiare==false? FirebaseFirestore.instance.collection('DEVIS').where("adherentId", isEqualTo: widget.userId).where('prestataireId', isEqualTo: prestatiaireObject.id).snapshots():
     FirebaseFirestore.instance.collection('DEVIS').where("beneficiaryId", isEqualTo: widget.userId).where('prestataireId', isEqualTo: prestatiaireObject.id).snapshots();

    return  WillPopScope(
      onWillPop:()async{
         Navigator.pop(context);
      },
      child: Scaffold(
      key: _scaffoldKey,  
      appBar: AppBar(
          backgroundColor:  kGoldlightYellow,
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
                children: [
                  Text(S.of(context).prestationsEnCours, style: TextStyle(color: kDateTextColor, fontSize: wv*4, fontWeight: FontWeight.w400), ),
                  
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
                        var devis=DevisModel.fromDocument(doc);
                        return  HomePageComponents().paiementPrestaireItem(
                            lastDatePaiement: "gfdg",
                            month:"${devis.intitule}", 
                            paidAllReady: "fdf",
                            paidOrNot: devis.ispaid? 1: 0,
                            prix: "${devis.amount}",
                            redirectOncliked: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                OrdonanceDuPatient(devis: devis))                                       );

                            }
                            );
                     }
                  ): Center(
                  child: Text(S.of(context).aucunDevisNeCorrespondACePatient),
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