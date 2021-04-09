import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';

class RendezVousDoctorView extends StatefulWidget {
  RendezVousDoctorView({Key key}) : super(key: key);

  @override
  _RendezVousDoctorViewState createState() => _RendezVousDoctorViewState();
}

class _RendezVousDoctorViewState extends State<RendezVousDoctorView> {
  Widget calendar() {
    return Column(children: [
      Container(
        width: wv * 100,
        height: hv * 15,
        decoration: BoxDecoration(
          color: kThirdIntroColor,
          boxShadow: [
            BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.week,
              daysOfWeekVisible: true,
              calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: kDateTextColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  rangeStartTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                  weekendTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                  defaultTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                  holidayTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                  todayTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18)),
              headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  headerMargin: const EdgeInsets.only(left: 18),
                  headerPadding: const EdgeInsets.only(top: 10, bottom: 10),
                  rightChevronVisible: false,
                  leftChevronVisible: false,
                  titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18)),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                weekendStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: inch * 1.5, right: inch * 1.5, top: inch * 0),
                  child: Text(
                    "Aujourd'hui",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: fontSize(size: 17)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: inch * 1.5, right: inch * 1.5, top: inch * 0),
                  child: Text(
                    "Semaines",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: fontSize(size: 17)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      Container(
        width: wv * 100,
        height: hv * 54,
        color: Colors.white,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(children: [
            timeline(
              age: '16 ans',
              consultationDetails: 'Tous et fievre depuis 3 jours',
              consultationType: 'Nouvelle Consultation',
              time: '09:30',
              userImage: 'assets/images/sarahHamidou.png',
              userName: 'Sarah Amidou',
            ),
            timeline(
              age: '61 ans',
              consultationDetails: 'J’ai des douleurs à la cheville ',
              consultationType: 'Suivi',
              time: '09:30',
              userImage: 'assets/images/sarahHamidou.png',
              userName: 'Telesphore Babianou',
            ),
            timeline(
              age: '61 ans',
              consultationDetails: 'Tous et fievre depuis 3 jours',
              consultationType: 'Nouvelle Consultation',
              time: '09:30',
              userImage: 'assets/images/sarahHamidou.png',
              userName: 'Sarah Amidou',
            )
          ]),
        ),
      ),
      Container(
        width: wv * 100,
        height: hv * 13,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        margin: EdgeInsets.only(
            left: inch * 1.5, right: inch * 1.5, top: inch * 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: inch * 1.5, right: inch * 1.5, top: inch * 0),
              child: Row(
                children: [
                  Text("Salle d'attente ",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: fontSize(size: 16),
                      )),
                  Text("Voir plus..",
                      style: TextStyle(
                          color: kBrownCanyon,
                          fontWeight: FontWeight.w700,
                          fontSize: fontSize(size: 16))),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  waitingRoomListOfUser(),
                  waitingRoomListOfUser(),
                  waitingRoomListOfUser(),
                  waitingRoomListOfUser(),
                  waitingRoomListOfUser(),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget waitingRoomListOfUser() {
    return Container(
      width: wv * 50,
      height: hv * 8,
      margin: EdgeInsets.only(
        left: inch * 1.5,
        right: inch * 1.5,
        top: inch * 2,
        bottom: inch * 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: wv * 15,
            height: hv * 8,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/avatar-profile.jpg'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kThirdColor,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )),
          ),
          Column(
            children: [
              Text('Fabrice Mbanga',
                  style: const TextStyle(
                      color: kDateTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 18)),
              SizedBox(
                height: hv * .5,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: inch * 1,
                ),
                child: Flexible(
                  child: Container(
                    width: wv * 30,
                    child: Text(
                        'Douleurs dentaires et violents mots de tête...',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            color: kDateTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget timeline({
    String time,
    String userImage,
    String userName,
    String consultationDetails,
    String age,
    String consultationType,
    String videChatLink,
    String detailsCOnsultationLink,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: inch * 3.5, right: inch * 1.5),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: inch * .5),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: inch * 1.5),
                  child: Text(time,
                      style: TextStyle(
                          color: kTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: fontSize(size: 18))),
                ),
                SvgPicture.asset(
                  'assets/icons/Bulk/Line.svg',
                  height: hv * 5,
                  color: kPrimaryColor,
                  width: wv * 5,
                ),
              ],
            ),
          ),
          Container(
            width: wv * 100,
            height: hv * 12,
            margin: EdgeInsets.only(bottom: wv * 2),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: kThirdColor, spreadRadius: 0.5, blurRadius: 4),
              ],
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: wv * 30,
                      height: hv * 12,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(userImage),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kThirdColor,
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          )),
                    ),
                    Positioned(
                        bottom: hv * 0.5,
                        right: wv * 1,
                        child: SvgPicture.asset(
                          'assets/icons/Bulk/Shield Done.svg',
                          width: wv * 4,
                        ))
                  ],
                ),
                Container(
                  width: wv * 46.6,
                  margin: EdgeInsets.only(left: wv * 1.5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: hv * 1.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: wv * .9),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userName,
                                style: const TextStyle(
                                    color: kDateTextColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18)),
                            Text(age,
                                style: TextStyle(
                                    color: kCardTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: fontSize(size: 18))),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: hv * 1.3,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(consultationDetails,
                                style: TextStyle(
                                    color: kCardTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: fontSize(size: 18))),
                          ),
                          SizedBox(
                            height: hv * 1,
                          ),
                          Text(consultationType,
                              style: TextStyle(
                                  color: kDeepTeal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: fontSize(size: 18))),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // lien la page de l'appel video
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        width: wv * 10,
                        height: hv * 6,
                        decoration: BoxDecoration(
                            color: kSouthSeas,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )),
                        child: SvgPicture.asset(
                          'assets/icons/Bulk/Video.svg',
                          width: wv * 7,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // lien vers les detailes des la consultation
                      },
                      child: Container(
                        padding: EdgeInsets.all(3),
                        height: hv * 6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/Bulk/ArrowRight Circle.svg',
                          width: wv * 7,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            calendar(),
          ],
        ),
      ),
    );
  }
}
