import 'dart:ui';

import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/adhrent_views/family_doctors_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PartnersScreen extends StatefulWidget {
  @override
  _PartnersScreenState createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  
  int contentIndex = 0;
  BuildContext sheetContext;
  double minSheetHeight = 0.4;
  double maxSheetHeight = 1.0;
  double initialSheetHeight = 0.4;
  ScrollController _scrollController = new ScrollController();
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(contentIndex == 0){
          //Provider Stuff
        }
        else{
          setState(() {
            contentIndex = 0;
          });
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBrownCanyon,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              SizedBox(
                width: wv*8,
                child: IconButton(icon: Icon(Icons.arrow_back_ios), 
                onPressed: (){
                  if(contentIndex == 0){
                    //Provider Stuff
                  }
                  else{
                    setState(() {
                      contentIndex = 0;
                    });
                  }
                }
                ),
              ),
              Text("Trouver un Prestataire de Santé", style: TextStyle(color: whiteColor),),
            ],
          ),
          actions: [
            Align(child: Text("Ndogbong", style: TextStyle(color: primaryColor),), alignment: Alignment.center,),
            Icon(MdiIcons.mapMarkerOutline, color: primaryColor,)
          ],
        ),
        body: Stack(children: [
          Container(
            child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
          ),
          DraggableScrollableActuator(
            child: DraggableScrollableSheet(
              initialChildSize:  initialSheetHeight, //contentIndex == 0 ? 0.4 : 1.0,
              minChildSize: minSheetHeight, //contentIndex == 0 ? 0.4 : 1.0,
              maxChildSize: maxSheetHeight, //contentIndex == 0 ? 0.9 : 1.0,
              builder: (BuildContext context, _scrollController){
                sheetContext = context;
                return ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.grey.shade200.withOpacity(0.5),
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        controller: _scrollController,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100.withOpacity(0.4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 2.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(0, 1)
                                )
                              ]
                            ),
                            child: Row(children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    fillColor: whiteColor.withOpacity(0.6),
                                    prefixIcon: Icon(Icons.search, color: kBrownCanyon,),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: kBrownCanyon.withOpacity(0.7)),
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: kBrownCanyon.withOpacity(0.7)),
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                    ),
                                    hintText: "Rechercher",
                                    hintStyle: TextStyle(color: kBrownCanyon)
                                  ),
                                ),
                              ),
                              SizedBox(width: 5,),
                              TextButton(onPressed: (){},
                                child: Text("Annuler", style: TextStyle(color: kBrownCanyon),)
                              ),
                              IconButton(icon: SvgPicture.asset("assets/icons/Bulk/Filter.svg"), onPressed: (){})

                            ],),
                          ),
                          //content
                          getSheetContent()
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ],),
      ),
    );
  }

  getSheetContent(){
    if(contentIndex == 0){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          SizedBox(height: hv*1,),
          SvgPicture.asset("assets/icons/Bulk/ArrowUp.svg"),
          Text("Recherchez en inscrivant directement le nom du praticien ou de l’etablissement de santé. Vous pouvez aussi rechercher les prestataires en sélectionant les groupes ci-dessous.", style: TextStyle(fontSize: 13), textAlign: TextAlign.center,),
          
          SizedBox(height: hv*4,),

          getDragSheetTiles(
            title: "Médécin de Famille",
            markerColor: kBrownCanyon,
            onTap: (){
              setState(() {
                contentIndex = 1;
                initialSheetHeight = 1.0;
                maxSheetHeight = 1.0;
                minSheetHeight = 1.0;
              });
              DraggableScrollableActuator.reset(context);
            }
          ),
          getDragSheetTiles(
            title: "Autres Spécialistes",
            markerColor: kPrimaryColor,
            onTap: (){
              setState(() {
                contentIndex = 2;
              });
            }
          ),
          getDragSheetTiles(
            title: "Hôpital ou clinique",
            markerColor: kSouthSeas,
            onTap: (){
              setState(() {
                contentIndex = 3;
              });
            }
          ),
          getDragSheetTiles(
            title: "Laboratoire",
            markerColor: primaryColor,
            onTap: (){
              setState(() {
                contentIndex = 4;
              });
            }
          ),
          getDragSheetTiles(
            title: "Pharmacie",
            markerColor: Colors.teal,
            onTap: (){
              setState(() {
                contentIndex = 5;
              });
            }
          )
        ],
        )
      );
    }
    else if (contentIndex == 1){
      return FamilyDoctorList();
    }
    else if (contentIndex == 2){
      return Text("Autres specialistes");
    }
    else if (contentIndex == 3){
      return Text("Hôpital ou clinique");
    }
    else if (contentIndex == 4){
      return Text("Laboratoire");
    }
    else if (contentIndex == 5){
      return Text("Pharmacie");
    }
  }

  Widget getDragSheetTiles({String title, Color markerColor, Function onTap}){
    return Padding(
      padding: EdgeInsets.only(right: 35.0, top: 3, bottom: 3, left: 20),
      child: Row(
        children: [
          SvgPicture.asset("assets/icons/Bulk/Location.svg", color: markerColor,),
          SizedBox(width: 10,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: kSmoothBrown.withOpacity(0.4),
              ),
              child: ListTile(
                onTap: onTap,
                dense: true,
                title: Text(title, style: TextStyle(color: kBlueForce, fontSize: inch*1.9, fontWeight: FontWeight.w600),),
                trailing: Icon(Icons.arrow_forward_ios_rounded, color: kBrownCanyon,)
              )
            ),
          )
        ],
      ),
    );
  }
}