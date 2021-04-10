import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/constants.dart';
import '../helpers/styles.dart';
import '../widgets/readMoreText.dart';

class HomePageComponents {
  getDoctorQuestion(
      {String imgUrl,
      String userName,
      String timeAgo,
      String text,
      int likeCount,
      int commentCount,
      int sendcountNumber}) {
    return Container(
      height: hv * 20,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: inch * 1.5, right: inch * 1.5, top: inch * 1),
            child: Column(
              children: [
                Row(
                  children: [
                    getAvatar(
                        imgUrl: imgUrl,
                        size: wv * 8.3,
                        renoveIsConnectedButton: false),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '$userName',
                              style: TextStyle(
                                color: kDeepTeal,
                                fontSize: fontSize(size: 17),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(' a posé une',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: fontSize(size: 17))),
                            SizedBox(
                              width: wv * 1,
                            ),
                            Text('Question',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: fontSize(size: 16))),
                          ],
                        ),
                        SizedBox(
                          height: hv * 0.3,
                        ),
                        Text(
                          '$timeAgo',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize(size: 16)),
                        )
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ReadMoreText(
                    text != null
                        ? text
                        : "Docta, que reccomendez vous en cas de fièvre de plus de 40’ de l’enfant? et quelles sont les mesure prise en cas de complications de la maladie ? ",
                    trimLines: 2,
                    trimLength: 73,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, color: bkgColor),
                    colorClickableText: kDeepTeal,
                    trimMode: TrimMode.Length,
                    trimCollapsedText: ' ... voir Plus',
                    trimExpandedText: ' ... reduire',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: inch * 0.6, right: inch * 1.5, top: inch * 0),
                  child: Row(children: [
                    Container(
                      margin: EdgeInsets.only(right: wv * 1),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Bulk/Heart.svg',
                            width: wv * 7,
                          ),
                          SizedBox(
                            width: wv * 1,
                          ),
                          Text(
                              likeCount != null
                                  ? '${likeCount.toString()}'
                                  : "123",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    SizedBox(width: wv * 7),
                    Container(
                      margin: EdgeInsets.only(right: wv * 1),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Bulk/Chat.svg',
                            width: wv * 7,
                          ),
                          SizedBox(
                            width: wv * 1.5,
                          ),
                          Text(
                              commentCount != null
                                  ? '${commentCount.toString()}'
                                  : "123",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    SizedBox(width: wv * 5),
                    Container(
                      margin: EdgeInsets.only(right: wv * 1),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Bulk/Send.svg',
                            width: wv * 7,
                          ),
                          SizedBox(
                            width: wv * 1.5,
                          ),
                          Text(
                              sendcountNumber != null
                                  ? '${sendcountNumber.toString()}'
                                  : "123",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getAvatar({String imgUrl, double size, bool renoveIsConnectedButton = true}) {
    return Padding(
      padding: EdgeInsets.only(right: wv * 1),
      child: Stack(
        children: [
          CircleAvatar(
            radius: size != null ? size : wv * 5.5,
            child: Image.asset(
              imgUrl,
              fit: BoxFit.cover,
            ),
          ),
          renoveIsConnectedButton
              ? Positioned(
                  top: wv * 7,
                  left: wv * 8,
                  child: CircleAvatar(
                    radius: wv * 1.5,
                    backgroundColor: primaryColor,
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }

  getProfileStat({String imgUrl, String title, int occurence}) {
    return Row(children: [
      Container(
        margin: EdgeInsets.only(right: wv * 1),
        child: SvgPicture.asset(
          imgUrl,
          width: wv * 7,
        ),
      ),
      Column(
        children: [
          Text("$occurence",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          Text(title, style: TextStyle(fontSize: inch * 1.3))
        ],
      )
    ]);
  }

  Widget getMyCoverageOptionsCard(
      {String imgUrl, String label, Color labelColor}) {
    return Container(
      width: wv * 35,
      height: hv * 17,
      padding: EdgeInsets.symmetric(horizontal: wv * 3, vertical: hv * 2.5),
      margin: EdgeInsets.symmetric(horizontal: wv * 1.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(inch * 2.5)),
          image: DecorationImage(image: AssetImage(imgUrl), fit: BoxFit.cover)),
      child: Align(
        child: Text(label,
            style: TextStyle(
                color: labelColor, fontSize: 14, fontWeight: FontWeight.w800)),
        alignment: Alignment.bottomLeft,
      ),
    );
  }

  getMyCoverageHospitalsTiles(
      {String initial, String name, String date, String price, int state}) {
    return ListTile(
      leading: Container(
        width: wv * 13,
        padding: EdgeInsets.symmetric(horizontal: wv * 1, vertical: hv * 2),
        decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.all(Radius.circular(inch * 1))),
        child: Center(
            child: Text(initial,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: inch * 2,
                    fontWeight: FontWeight.w700))),
      ),
      title: Text(
        name,
        style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: inch * 1.6),
      ),
      subtitle: Text(
        date,
        style: TextStyle(color: kPrimaryColor),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            price,
            style: TextStyle(color: kPrimaryColor, fontSize: inch * 1.5),
          ),
          Text(
            state == 0 ? "En cours" : "Clôture",
            style: TextStyle(
                color: state == 0 ? primaryColor : Colors.teal[400],
                fontSize: inch * 1.5),
          ),
        ],
      ),
    );
  }

  getMyDoctorAppointmentTile(
      {String label, String doctorName, String date, String type, int state}) {
    return ListTile(
      leading: Container(
        width: wv * 12,
        padding: EdgeInsets.symmetric(horizontal: wv * 1),
        decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.all(Radius.circular(inch * 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("18",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: inch * 1.7,
                    fontWeight: FontWeight.w700)),
            Text("02/21",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: inch * 1.5,
                    fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          label,
          style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w700,
              fontSize: inch * 2),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: TextStyle(color: kPrimaryColor, fontSize: inch * 1.4),
          ),
          Text(
            doctorName,
            style: TextStyle(color: kPrimaryColor, fontSize: inch * 1.4),
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            type,
            style: TextStyle(color: kPrimaryColor, fontSize: inch * 1.7),
          ),
          Text(
            getAppointmentStateText(state),
            style: TextStyle(
                color: getAppointmentStateColor(state), fontSize: inch * 1.7),
          ),
        ],
      ),
    );
  }

  String getAppointmentStateText(int val) {
    if (val == 0)
      return "En attente";
    else if (val == 1)
      return "Approuvé";
    else if (val == 2)
      return "Rejetté";
    else
      return "Clôturé";
  }

  Color getAppointmentStateColor(int val) {
    if (val == 0)
      return primaryColor;
    else if (val == 1)
      return Colors.teal;
    else if (val == 2)
      return Colors.red;
    else
      return Colors.brown;
  }

  verticalDivider() {
    return Container(
      width: wv * 0.5,
      height: wv * 8,
      color: Colors.grey.withOpacity(0.4),
    );
  }
}
