import 'package:cached_network_image/cached_network_image.dart';
import 'package:danaid/core/models/notificationModel.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:danaid/core/providers/notificationModelProvider.dart';

class Notifications extends StatefulWidget {
  const Notifications({ Key? key }) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  init() async {
    NotificationModelProvider notifications = Provider.of<NotificationModelProvider>(context, listen: false);
    await notifications.updateProvider();
    notifications.markAllAsSeen();
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    NotificationModelProvider notifications = Provider.of<NotificationModelProvider>(context);
    List<NotificationModel> notifs = List.from(notifications.getNotifications.reversed);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: kDeepTeal,
        leading: InkWell(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(LineIcons.angleLeft,),
          ),
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
        title: Text("Notifications", style: TextStyle(color: Colors.white),)
      ),
      body: Container(
        child: ListView.builder(
          itemCount: notifs.length,
          itemBuilder: (context, index) {
            NotificationModel notif = notifs[index];
            return Container(
              margin: EdgeInsets.only(bottom: hv*1),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: notifs[index].profileImgUrl != null ? CachedNetworkImageProvider(notifs[index].profileImgUrl!) : null,
                  child: notifs[index].profileImgUrl != null ? Container() : Icon(LineIcons.image, color: whiteColor,),
                ),
                title: Text(notifs[index].title!),
                subtitle: Text(notifs[index].description!),
                trailing: Text(notifs[index].dateReceived != null ? Algorithms.getTimeElapsed(date: notifs[index].dateReceived)! : ""),
              ),
            );
          },
        ),
      ),
    );
  }
}