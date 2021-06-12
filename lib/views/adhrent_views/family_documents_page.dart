import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class FamilyDocumentsPage extends StatefulWidget {
  const FamilyDocumentsPage({ Key key }) : super(key: key);

  @override
  _FamilyDocumentsPageState createState() => _FamilyDocumentsPageState();
}

class _FamilyDocumentsPageState extends State<FamilyDocumentsPage> {
  CarouselController carouselController = CarouselController();
  String description = "";
  String title = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSouthSeas.withOpacity(0.3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kCardTextColor,), 
          onPressed: ()=>Navigator.pop(context)
        ),
        actions: [
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kCardTextColor,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kCardTextColor), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: (){})
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("DOCUMENTS").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<Widget> documents = [];
          for (int i = 0; i < snapshot.data.docs.length; i++){
            DocumentSnapshot doc = snapshot.data.docs[i];
            Widget content = getDocumentBox(
              switchColor: i.isEven,
              title: doc.data()["nom"],
              size: doc.data()["poids"],
              url: doc.data()["url"]
            );
            documents.add(content);
            /*title = snapshot.data.docs[0].data()["nom"];
            description = snapshot.data.docs[0].data()["description"];*/
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: kSouthSeas.withOpacity(0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: hv*5,),
                      Container(
                        padding: EdgeInsets.only(left: wv*5, right: wv*2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Documents", style: TextStyle(fontSize: 45, color: kCardTextColor),),
                            Text("Aperçu & téléchargement des documents administratifs DanAid", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kCardTextColor),),
                          ],
                      )),
                      SizedBox(height: hv*5,),
                      CarouselSlider(
                        carouselController: carouselController,
                        options: CarouselOptions(
                          scrollPhysics: BouncingScrollPhysics(),
                          viewportFraction: 0.5,
                          height: 250,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          reverse: false,
                          autoPlay: false,
                          enlargeCenterPage: false,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (j, reason){
                            title = snapshot.data.docs[j].data()["nom"];
                            description = snapshot.data.docs[j].data()["description"];
                            setState((){});
                          }
                        ),
                        items: documents
                      ),
                      SizedBox(height: hv*2,)
                    ],
                  ),
                ),
                title != "" || description != "" ? Container(
                  padding: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*Center(child: SvgPicture.asset('assets/icons/Two-tone/Paper.svg', color: kDeepTeal.withOpacity(0.7), width: wv*30,)),
                      Text("Aucun document disponible\npour le moment", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kDeepTeal), textAlign: TextAlign.center,),*/
                      Text(title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: kCardTextColor),),
                      SizedBox(height: hv*3,),
                      Text(description.toString(), style: TextStyle(fontSize: 15, color: kCardTextColor),),
                      SizedBox(height: hv*3,)
                    ],
                  ),
                ) : Center(child: Column(
                  children: [
                    SizedBox(height: hv*3,),
                    SvgPicture.asset('assets/icons/Two-tone/Paper.svg', color: kDeepTeal.withOpacity(0.4), width: wv*30,),
                    Text("Défilez pour avoir\nle résumé", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kDeepTeal.withOpacity(0.5)), textAlign: TextAlign.center),
                    SizedBox(height: hv*3,)
                  ],
                )),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget getDocumentBox({String title, String url, num size, bool switchColor}){
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: wv*40,
          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: switchColor ? kDeepTeal : kSouthSeas,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 2.5, spreadRadius: 1, offset: Offset(0, 3))]
          ),
          child: Container(
            height: 250,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: whiteColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Text("$size kb", style: TextStyle(color: kBrownCanyon, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
                Spacer(),
                Text(title, style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 25),),
              ],
            ),
          ),
        ),
        Positioned(
          left: -20,
          top: 20,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: kCardTextColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(Icons.arrow_downward_rounded, size: 25, color: kCardTextColor,),
          ),
        )
      ],
    );
  }
}