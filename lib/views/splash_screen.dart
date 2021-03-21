import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/views/home_page_view.dart';
import 'package:danaid/views/screens/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<Map> checkSignInState() async {
    AdherentProvider adherentProvider = Provider.of<AdherentProvider>(context, listen: false);
    bool isSignedIn = await HiveDatabase.getSignInState();
    bool isRegistered = await HiveDatabase.getRegisterState();
    String phone = await HiveDatabase.getAuthPhone();
    String fname = await HiveDatabase.getFamilyName();
    String sname = await HiveDatabase.getSurname();
    String imgUrl = await HiveDatabase.getImgUrl();
    adherentProvider.setAdherentId(phone);
    adherentProvider.setFamilyName(fname);
    adherentProvider.setSurname(sname);
    adherentProvider.setImgUrl(imgUrl);
    return {
      "isSignedIn": isSignedIn,
      "isRegistered": isRegistered
    };
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkSignInState(),
      builder: (context, snapshot) {
        return snapshot.hasData ? 
          (snapshot.data["isRegistered"] == true) ?
            HomePageView() : OnboardScreen()
        : Scaffold(
          body: Center(child: Text("Splash Screen Temporaire !!!"),),
        );
      },
    );
  }
}