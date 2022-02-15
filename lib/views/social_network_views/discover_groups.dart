import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:danaid/core/models/groupModel.dart';
import 'package:line_icons/line_icons.dart';

class DiscoverGroups extends StatefulWidget {
  @override
  _DiscoverGroupsState createState() => _DiscoverGroupsState();
}

class _DiscoverGroupsState extends State<DiscoverGroups> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("GROUPS").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return snapshot.data!.docs.length >= 1 ? ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            GroupModel group = GroupModel.fromDocument(doc);
            return getGroupContainers(
              name: group.groupName!,
              description: group.groupDescription!,
              imgUrl: group.imgUrl!,
              date: group.dateCreated!.toDate(),
              members: group.membersIds!.length
            );
          },
        ) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Icon(LineIcons.userShield, color: Colors.grey[400], size: 85,),
              SizedBox(height: 5,),
              Text(S.of(context).aucunGroupePourLeMoment, 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[400] )
              , textAlign: TextAlign.center,),
            ],
          ),
        );
      }
    );
  }

  getGroupContainers({String? name, int? members, DateTime? date, String? description, String? imgUrl}){
    String? time = Algorithms.getTimeElapsed(date: date);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: wv*3),
            width: wv*20,
            height: hv*7,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.grey[500]!, blurRadius: 2.5, spreadRadius: 1.2, offset: Offset(0, 1.5))],
              image: imgUrl != null ? DecorationImage(image: CachedNetworkImageProvider(imgUrl), fit: BoxFit.cover) : null
            ),
            child: imgUrl == null ? SvgPicture.asset('assets/icons/Bulk/Users.svg', color: Colors.grey[200],) : Container(),
          ),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: kTextBlue, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(text: "$name\n"),
                            TextSpan(text: members.toString()+" membres")
                          ]
                        ),
                      ),
                    ),
                    Expanded(flex: 3, child: Text(S.of(context).ilYa+time!, style: TextStyle(fontSize: 12), textAlign: TextAlign.end,))
                  ],
                ),
                SizedBox(height: hv*2,),
                Text(description!, style: TextStyle(color: kTextBlue))
              ],
            ),
          )
        ],
      ),
    );
  }
}