import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

class MyDoctorTabView extends StatefulWidget {
  @override
  _MyDoctorTabViewState createState() => _MyDoctorTabViewState();
}

class _MyDoctorTabViewState extends State<MyDoctorTabView> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: wv*5, vertical: hv*3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [BoxShadow(
              color: Colors.grey[300],
              spreadRadius: 1.5,
              blurRadius: 3,
              offset: Offset(0, 2)
            )]
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  color: kPrimaryColor,
                ),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*1.5),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(
                              color: Colors.black54,
                              spreadRadius: 1,
                              blurRadius: 1.5,
                              offset: Offset(0, 2)
                            )]
                          ),
                          child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: AssetImage("assets/images/avatar-profile.jpg",),
                              radius: 35,
                          ),
                        ),
                        SizedBox(width: 8,),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Dr. Jean Marie Nka", style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w600),),
                              Text("Medecin de Famille, Généraliste", style: TextStyle(color: whiteColor.withOpacity(0.6), fontSize: 14),),
                              SizedBox(height: hv*1.3,),
                              Text("HOPITAL DE DISTRICT DE NEW BELL", style: TextStyle(color: whiteColor, fontSize: 15),),
                              Text("Service - Médécine Générale", style: TextStyle(color: whiteColor.withOpacity(0.6), fontSize: 14),),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 5,),

                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kSouthSeas, kPrimaryColor],
                        begin: Alignment.centerLeft,
                        stops: [0.25, 0.55],
                      ),
                      color: kSouthSeas,
                    ),
                    child: Divider(color: Colors.transparent,),
                  ),

                  SizedBox(height: 5,),

                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text("Services Offerts", style: TextStyle(color: whiteColor, fontSize: 15),),
                          ),
                          subtitle: Row(
                            children: [
                              WebsafeSvg.asset("assets/icons/Bulk/Video.svg", width: 20),
                              SizedBox(width: 10,),
                              WebsafeSvg.asset("assets/icons/Bulk/Chat.svg", width: 20),
                              SizedBox(width: 10,),
                              WebsafeSvg.asset("assets/icons/Bulk/Calling.svg", width: 20, color: whiteColor),
                              SizedBox(width: 10,),
                              WebsafeSvg.asset("assets/icons/Bulk/Home.svg", width: 20, color: whiteColor.withOpacity(0.7),),
                              SizedBox(width: 10,),
                              WebsafeSvg.asset("assets/icons/Bulk/Calendar.svg", width: 20),
                              SizedBox(width: 10,),
                              WebsafeSvg.asset("assets/icons/Bulk/Profile.svg", width: 20),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(
                            color: Colors.black54,
                            spreadRadius: 1,
                            blurRadius: 1.5,
                            offset: Offset(0, 2)
                          )]
                        ),
                        child: CircleAvatar(
                          radius: wv*8,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(top: inch*1),
                            child: WebsafeSvg.asset("assets/icons/Bulk/MapLocal.svg"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                ],),
              ),
              Container(
                decoration: BoxDecoration(
                  color: kSouthSeas,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                ),
                child: ListTileTheme(
                  dense: true,
                  child: Theme(
                    data: ThemeData.light().copyWith(
                      accentColor: whiteColor, 
                      primaryColor: whiteColor,
                      iconTheme: IconThemeData(color: whiteColor, size: 40),
                      unselectedWidgetColor: whiteColor
                      ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.only(right: 15, left: 3),
                      onExpansionChanged: (val){
                        setState(() {
                          isExpanded = val;
                        });
                      },
                      title: !isExpanded ? Align(child: Text("Plus de détails", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 16)), alignment: Alignment.centerRight,) 
                      : Column(
                          children: [
                            Row(
                              children: [
                                getFeatureCard(title: "Consultations"),
                                getFeatureCard(title: "Télé-Consultations"),
                              ],
                            ),
                            Row(
                              children: [
                                getFeatureCard(title: "Chat"),
                                getFeatureCard(title: "Rendez-vous"),
                                getFeatureCard(title: "Visite à domicile"),
                              ],
                            )
                          ],
                        ),
                      children: [
                        Container(
                          child: Column(
                            children: [
                              SizedBox(height:5),
                              SizedBox(height: 30,
                                child: Row(
                                  children: [
                                    SizedBox(width: 5,),
                                    TextButton.icon(
                                      onPressed: (){},
                                      icon: WebsafeSvg.asset("assets/icons/Bulk/Chat.svg"),
                                      label: Text("Ecrire", style: TextStyle(color: whiteColor),),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                                        padding: MaterialStateProperty.all(EdgeInsets.only(right: 10, left: 8)),
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      ),
                                    ),

                                    SizedBox(width: 10,),

                                    TextButton.icon(
                                      onPressed: (){},
                                      icon: Padding(
                                        padding: const EdgeInsets.only(top: 3.0),
                                        child: WebsafeSvg.asset("assets/icons/Bulk/Calendar.svg", color: kPrimaryColor,),
                                      ),
                                      label: Text("Prendre Rendez-vous", style: TextStyle(color: kPrimaryColor),),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(whiteColor),
                                        padding: MaterialStateProperty.all(EdgeInsets.only(right: 10, left: 8)),
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              DefaultTextStyle(
                                style: TextStyle(color: kPrimaryColor),
                                child: Row(
                                  children: [
                                    SizedBox(width: wv*2,),
                                    Expanded(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Horaire", style: TextStyle(fontWeight: FontWeight.w800)),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Lundi à Vendredi"),
                                                Text("08H00 - 16H00"),
                                              ]
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                TableCell(child: Text("Samedi")),
                                                TableCell(child: Text("08H00 - 16H00")),
                                              ]
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Dimanche"),
                                                Text("08H00 - 16H00"),
                                              ]
                                            ),
                                          ),

                                          SizedBox(height: 10,),

                                          Text("Adresse", style: TextStyle(fontWeight: FontWeight.w800)),
                                          Text("Nouvelle Route, Face Hotel la Falaise, Douala 5, Cameroun")
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: wv*2,),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: whiteColor.withOpacity(0.7),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("Tarif publique", style: TextStyle(fontWeight: FontWeight.w800)),
                                          Text("3000 f."),
                                          SizedBox(height: 10,),
                                          Text("Tarif DanAid", style: TextStyle(color: Colors.teal[400], fontWeight: FontWeight.w800)),
                                          Row(
                                            children: [
                                              Text("Adhérents"),
                                              SizedBox(width: 5,),
                                              Text("900 f."),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Autres"),
                                              SizedBox(width: 5,),
                                              Text("2850 f."),
                                            ],
                                          ),
                                          SizedBox(height: 20,)
                                        ]
                                      ),
                                    ),
                                    SizedBox(width: 10,)
                                  ],
                                ),
                              ),
                              SizedBox(height: 15,)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(),
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text("Mes Rendez-vous", style: TextStyle(color: Colors.teal[400], fontSize: 17),)
        ),
        Column(
          children: [
            HomePageComponents().getMyDoctorAppointmentTile(
              doctorName: "Dr. Jean Marie Nka, Médécin de Famille",
              date: "Mercredi, 18 février 2021, 10:30",
              state: 0,
              type: "Consultation",
              label: "Contrôle"
            ),
            HomePageComponents().getMyDoctorAppointmentTile(
              doctorName: "Dr. Jean Marie Nka, Médécin de Famille",
              date: "Lundi, 10 février 2021, 14:00",
              state: 1,
              type: "Télé-Consultation",
              label: "Résultat d'examens"
            ),
            HomePageComponents().getMyDoctorAppointmentTile(
              doctorName: "Dr. Jean Marie Nka, Médécin de Famille",
              date: "Mercredi, 22 Janvier 2021, 08:00",
              state: 2,
              type: "Consultation",
              label: "Résultat d'examens"
            ),
            HomePageComponents().getMyDoctorAppointmentTile(
              doctorName: "Dr. Jean Marie Nka, Médécin de Famille",
              date: "Mercredi, 10 février 2021, 10:30",
              state: 3,
              type: "Consultation",
              label: "Fièvre et toux depuis"
            ),

            SizedBox(height: 20,),
          ],
        )
      ],),
    );
  }
  Widget getFeatureCard({String title}){
    return Container(
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(title, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500, fontSize: 13)),
    );
  }
}