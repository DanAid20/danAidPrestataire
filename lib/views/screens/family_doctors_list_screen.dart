import 'package:danaid/widgets/doctor_info_cards.dart';
import 'package:flutter/material.dart';

class FamilyDoctorList extends StatefulWidget {
  @override
  _FamilyDoctorListState createState() => _FamilyDoctorListState();
}

class _FamilyDoctorListState extends State<FamilyDoctorList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(children: [
            Text("Ordonner par"),
            DropdownButton(
              items: [
                DropdownMenuItem(child: Text("Distance")),
                DropdownMenuItem(child: Text("Date d'ajout"))
              ], 
              onChanged: null
            )
          ], mainAxisAlignment: MainAxisAlignment.start,),
          Container(
            height: 500,
            child: ListView(
              shrinkWrap: true,
              children: [
                DoctorInfoCard(
                  name: "Jean Marie Nka",
                  title: "Medecin de Famille",
                  speciality: "Généraliste",
                  distance: "800",
                  onTap: (){},
                ),
                DoctorInfoCard(
                  name: "Jean Marie Nka",
                  title: "Medecin de Famille",
                  speciality: "Généraliste",
                  distance: "800",
                  onTap: (){},
                ),
                DoctorInfoCard(
                  name: "Jean Marie Nka",
                  title: "Medecin de Famille",
                  speciality: "Généraliste",
                  distance: "800",
                  onTap: (){},
                ),
                DoctorInfoCard(
                  name: "Jean Marie Nka",
                  title: "Medecin de Famille",
                  speciality: "Généraliste",
                  distance: "800",
                  onTap: (){},
                ),
            ],),),
         
        ]
      ),
    );
  }
}