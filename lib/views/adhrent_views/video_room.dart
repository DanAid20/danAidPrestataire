import 'package:flutter/material.dart';

class VideoRoom extends StatefulWidget {
  final String? token, channelName;
  final int? uid;

  const VideoRoom({Key? key, this.token, this.channelName, this.uid}) : super(key: key);

  @override
  _VideoRoomState createState() => _VideoRoomState();
}


class _VideoRoomState extends State<VideoRoom> {



  @override
  Widget build(BuildContext context) {
    
    return Container();
  }

}