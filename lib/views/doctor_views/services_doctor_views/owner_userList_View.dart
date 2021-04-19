import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class OwnerUserListView extends StatefulWidget {
  final String idOfAdherent;
  OwnerUserListView({Key key, this.idOfAdherent}) : super(key: key);

  @override
  _OwnerUserListViewState createState() => _OwnerUserListViewState();
}

class _OwnerUserListViewState extends State<OwnerUserListView> {
  @override
  void initState() {
    super.initState();
  }

  getListOfUser() {
    Stream<QuerySnapshot> query = FirebaseFirestore.instance
        .collection("ADHERENTS")
        .doc('${widget.idOfAdherent}')
        .collection('BENEFICIAIRES')
        .snapshots();
    AdherentModelProvider adherentProvider =
        Provider.of<AdherentModelProvider>(context, listen: false);
    return StreamBuilder(
        stream: query,
        builder: (context, snapshot) {
          print(snapshot.data.docs.length);
          print(widget.idOfAdherent);
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          }
          int lastIndex = snapshot.data.docs.length - 1;
          return snapshot.data.docs.length >= 1
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  //shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data.docs[index];
                    AdherentModel doctor = AdherentModel.fromDocument(doc);
                    print("name: ");
                    return Padding(
                        padding: EdgeInsets.only(
                            bottom: lastIndex == index ? hv * 5 : 0),
                        child: HomePageComponents().getAdherentsList(
                            adherent: doctor, isAccountIsExists: true));
                  })
              : Center(
                  child: Text("Aucun Adherent  disponible pour le moment.."),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
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
                  children: [
                    Text('Identifier le patient '),
                    Text('15 Janvier 2021, 1:30')
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
          body: Container(
              child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(children: [
              Container(
                height: hv * 70,
                margin: EdgeInsets.only(left: wv * 1.5, top: hv * 5),
                child: getListOfUser(),
              ),
              SvgPicture.asset(
                'assets/icons/Bulk/Dots.svg',
                color: kSouthSeas,
                height: hv * 5,
                width: wv * 3,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: wv * 80,
                  margin: EdgeInsets.only(top: hv * 3),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Acceder au carnet de Sante',
                      style: TextStyle(
                          color: textColor,
                          fontSize: wv * 4.5,
                          fontWeight: FontWeight.w600),
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 15)),
                        backgroundColor:
                            MaterialStateProperty.all(kFirstIntroColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))))),
                  ),
                ),
              ),
            ]),
          )),
        ));
  }
}
