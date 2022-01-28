import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoRoom extends StatefulWidget {
  final String? token, channelName;
  final int? uid;

  const VideoRoom({Key? key, this.token, this.channelName, this.uid}) : super(key: key);

  @override
  _VideoRoomState createState() => _VideoRoomState();
}


class _VideoRoomState extends State<VideoRoom> {
  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Init the app
  Future<void> initPlatformState() async {
    await [Permission.camera, Permission.microphone].request();

    RtcEngineContext context = RtcEngineContext(agoraAppId);
    var engine = await RtcEngine.createWithContext(context);

    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print('joinChannelSuccess ${channel} ${uid}');
          setState(() {
            _joined = true;
          });
        }, 
        userJoined: (int uid, int elapsed) {
          print('userJoined $uid');
          setState(() {
            _remoteUid = uid;
          });
        }, 
        userOffline: (int uid, UserOfflineReason reason) {
          print('userOffline $uid');
          setState(() {
            _remoteUid = 0;
          });
        },
        tokenPrivilegeWillExpire: (String token){},
    ));

    await engine.enableVideo();

    await engine.joinChannel(widget.token, widget.channelName!, null, widget.uid!);
    await engine.enableLocalVideo(true);
    await engine.enableLocalAudio(true);
  }


  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async {
        RtcEngineContext context_agora = RtcEngineContext(agoraAppId);
        var engine = await RtcEngine.createWithContext(context_agora);
        engine.destroy(); 
        Navigator.pop(context);
        return true;
      },
      child: MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              Center(
                child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 120,
                  height: 150,
                  color: Colors.black,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _switch = !_switch;
                      });
                    },
                    child: Center(
                      child:
                      _switch ? _renderLocalPreview() : _renderRemoteVideo(),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: 70,
                  height: 70,
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.call_end, size: 40,),
                    onPressed: () async {
                      RtcEngineContext context_agora = RtcEngineContext(agoraAppId);
                      var engine = await RtcEngine.createWithContext(context_agora);
                      engine.destroy(); 
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderLocalPreview() {
    if (_joined) {
      return RtcLocalView.SurfaceView();
    } else {
      return Text(
        "Vous n'êtes pas connecté",
        style: TextStyle(color: whiteColor),
        textAlign: TextAlign.center,
      );
    }
  }

  // Remote preview
 Widget _renderRemoteVideo() {
    if (_remoteUid != 0) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid,
        //channelId: "123456",
      );
    } else {
      return Text(
        "En attente de l'utilisateur distant",
        style: TextStyle(color: whiteColor),
        textAlign: TextAlign.center,
      );
    }
  }

}