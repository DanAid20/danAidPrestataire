import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePageComponents {
    getAvatar({String imgUrl}){
      return Padding(
        padding: EdgeInsets.only(right: wv*1),
        child: Stack(children: [
          CircleAvatar(
            radius: wv*5.5,
            child: Image.asset(imgUrl, fit: BoxFit.cover,),
          ),
          Positioned(
            top: wv*7,
            left: wv*8,
            child: CircleAvatar(
              radius: wv*1.5,
              backgroundColor: primaryColor,
            ),
          )
        ],),
      );
    }
    getProfileStat({String imgUrl, String title, int occurence}){
      return Row(children: [
        Container(
          margin: EdgeInsets.only(right: wv*1),
          child: SvgPicture.asset(imgUrl, width: wv*7,),
        ),
        Column(children: [ 
          Text("$occurence", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          Text(title, style: TextStyle(fontSize: inch*1.3))
        ],)
      ]);
    }
    Widget getMyCoverageOptionsCard({String imgUrl, String label, Color labelColor}){
      return Container(
        width: wv*35, height: hv*17,
        padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2.5),
        margin: EdgeInsets.symmetric(horizontal: wv*1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(inch*2.5)),
          image: DecorationImage(image: AssetImage(imgUrl), fit: BoxFit.cover)
        ),
        child: Align(child: Text(label, style: TextStyle(color: labelColor, fontSize: 14, fontWeight: FontWeight.w800)), alignment: Alignment.bottomLeft,),
      );
    }

    getMyCoverageHospitalsTiles({String initial, String name, String date, String price, int state}){
      return ListTile(
        leading: Container(
          width: wv*13,
          padding: EdgeInsets.symmetric(horizontal: wv*1, vertical: hv*2),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.all(Radius.circular(inch*1))
          ),
          child: Center(child: Text(initial, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: inch*2, fontWeight: FontWeight.w700))),
        ),
        title:  Text(name, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: inch*1.6),),
        subtitle: Text(date, style: TextStyle(color: kPrimaryColor),),
        trailing: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(price, style: TextStyle(color: kPrimaryColor, fontSize: inch*1.5),),
            Text(
              state == 0 ? "En cours" : "Clôture", 
              style: TextStyle(color: state == 0 ? primaryColor: Colors.teal[400] , fontSize: inch*1.5),),
          ],
        ),
      );
    }

    getMyDoctorAppointmentTile({String label, String doctorName, String date, String type, int state}){
      return ListTile(
        leading: Container(
          width: wv*12,
          padding: EdgeInsets.symmetric(horizontal: wv*1),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.all(Radius.circular(inch*1))
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("18", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: inch*1.7, fontWeight: FontWeight.w700)),
              Text("02/21", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: inch*1.5, fontWeight: FontWeight.w400)),            ],
          ),
        ),
        title:  Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Text(label, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700, fontSize: inch*2),overflow: TextOverflow.ellipsis,),
        ),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date, style: TextStyle(color: kPrimaryColor, fontSize: inch*1.4),),
            Text(doctorName, style: TextStyle(color: kPrimaryColor, fontSize: inch*1.4),),
          ],
        ),
        trailing: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(type, style: TextStyle(color: kPrimaryColor, fontSize: inch*1.7),),
            Text(
              getAppointmentStateText(state), 
              style: TextStyle(color: getAppointmentStateColor(state) , fontSize: inch*1.7),),
          ],
        ),
      );
    }

    String getAppointmentStateText(int val){
      if (val == 0)
        return "En attente";
      else if(val == 1)
        return "Approuvé";
      else if(val == 2)
        return "Rejetté";
      else return "Clôturé";
    }

    Color getAppointmentStateColor(int val){
      if (val == 0)
        return primaryColor;
      else if(val == 1)
        return Colors.teal;
      else if(val == 2)
        return Colors.red;
      else return Colors.brown;
    }

    verticalDivider(){
      return Container(
        width: wv*0.5,
        height: wv*8,
        color: Colors.grey.withOpacity(0.4),
      );
    }
}