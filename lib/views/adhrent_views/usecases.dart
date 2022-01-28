import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/usecaseModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/usecaseModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UseCaseList extends StatefulWidget {
  const UseCaseList({ Key? key }) : super(key: key);

  @override
  _UseCaseListState createState() => _UseCaseListState();
}

class _UseCaseListState extends State<UseCaseList> {
  int limit = 20;
  @override
  Widget build(BuildContext context) {
    AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDeepTeal,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, color: whiteColor,), onPressed: ()=>Navigator.pop(context)),
        title: Text("Utilisation du service", style: TextStyle(color: whiteColor),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("USECASES").where('adherentId', isEqualTo: adherentProvider.getAdherent!.adherentId).orderBy('createdDate', descending: true).limit(limit).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }

          return snapshot.data!.docs.length >= 1
            ? NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                  var metrics = scrollEnd.metrics;
                  if (metrics.atEdge) {
                    if (metrics.pixels == 0) print('At top');
                    else setState(() {limit = limit + 5;});
                  }
                  return true;
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    int lastIndex = snapshot.data!.docs.length - 1;
                    DocumentSnapshot useCaseDoc = snapshot.data!.docs[index];
                    UseCaseModel useCase = UseCaseModel.fromDocument(useCaseDoc);
                    print("name: ");
                    return Padding(
                      padding: EdgeInsets.only(bottom: lastIndex == index ? hv * 5 : 0),
                      child: useCase.establishment != null ? HomePageComponents().getMyCoverageHospitalsTiles(
                        initial: useCase.establishment!.toUpperCase().substring(0,3),
                        name: useCase.establishment,
                        date: useCase.dateCreated!.toDate(),
                        state: useCase.status,
                        price: useCase.amount != null ? useCase.amount : 0,
                        action: (){
                          UseCaseModelProvider usecaseProvider = Provider.of<UseCaseModelProvider>(context, listen: false);
                          usecaseProvider.setUseCaseModel(useCase);
                          Navigator.pushNamed(context, '/use-case');
                        }
                      ) : Container(),
                    );
                  }),
            )
            : Center(
              child: Container(padding: EdgeInsets.only(bottom: hv*4),child: Text(S.of(context)!.aucunCasDutilisationEnrgistrPourLeMoment, textAlign: TextAlign.center)),
            );
        }
      ),
    );
  }
}