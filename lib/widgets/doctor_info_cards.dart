import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoctorInfoCard extends StatelessWidget {

  final String name;
  final String title;
  final String speciality;
  final String distance;
  final Function onTap;

  const DoctorInfoCard({Key key, this.name, this.title, this.speciality, this.distance, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: wv*5, vertical: 5),
      decoration: BoxDecoration(
        color: kSouthSeas,
        borderRadius: BorderRadius.all(Radius.circular(20)),
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                          radius: 30,
                      ),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dr. $name", style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w600),),
                          Text("$title, $speciality", style: TextStyle(color: whiteColor.withOpacity(0.6), fontSize: 14),),

                        ],
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 5,),

              Container(
                height: 2.5,
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

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("Services Offerts", style: TextStyle(color: whiteColor, fontSize: 15),),
                  ),
                  Row(
                    children: [
                      Text("$distance m", style: TextStyle(color: whiteColor, fontSize: 15),),
                      SizedBox(width: 15,),
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
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: SvgPicture.asset("assets/icons/Bulk/MapLocal.svg", width: 25,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 10,),
                  SvgPicture.asset("assets/icons/Bulk/Video.svg", width: 20),
                  SizedBox(width: 10,),
                  SvgPicture.asset("assets/icons/Bulk/Chat.svg", width: 20),
                  SizedBox(width: 10,),
                  SvgPicture.asset("assets/icons/Bulk/Calling.svg", width: 20, color: whiteColor),
                  SizedBox(width: 10,),
                  SvgPicture.asset("assets/icons/Bulk/Home.svg", width: 20, color: whiteColor.withOpacity(0.7),),
                  SizedBox(width: 10,),
                  SvgPicture.asset("assets/icons/Bulk/Calendar.svg", width: 20),
                  SizedBox(width: 10,),
                  SvgPicture.asset("assets/icons/Bulk/Profile.svg", width: 20),
                ],
              ),

              SizedBox(height: 5,),
            ],),
          ),
          /*Container(
            margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
            child: Text("Yeahhh")
          )*/
          Container(height: 30,
            child: TextButton(
              onPressed: onTap,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.only(bottom: 4, right: 15))
              ),
              child: Row(children: [
                Text("Plus de détails", style: TextStyle(color: Colors.white),),
                SizedBox(width: 10,),
                Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],mainAxisAlignment: MainAxisAlignment.end)
            ),
          )
        ],
      ),
    )
        ;
  }
}