import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/adherentProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:provider/provider.dart';
import 'package:danaid/core/providers/authProvider.dart';
import 'package:danaid/core/providers/devEnvironmentProvider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  checkSignInState() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool isSignedIn = await HiveDatabase.getSignInState();
    bool isRegistered = await HiveDatabase.getRegisterState();
    String phone = await HiveDatabase.getAuthPhone();
    //String phone = await HiveDatabase.getAuthPhone();
    //String fname = await HiveDatabase.getFamilyName();
    //String sname = await HiveDatabase.getSurname();
    //String imgUrl = await HiveDatabase.getImgUrl();
    String profile = await HiveDatabase.getProfileType();
    await Future.delayed(Duration(seconds: 1));

    print("state"+ isRegistered.toString());
    
    authProvider.setSignInState(isSignedIn);
    authProvider.setRegisterState(isRegistered);

    if (isRegistered == true){
      //print(phone + "phoone");
      userProvider.setUserId(phone);
      userProvider.setProfileType(profile);
      (profile == doctor) ? Navigator.pushReplacementNamed(context, '/home') : Navigator.pushReplacementNamed(context, '/home');
    }
    else {
      Navigator.pushReplacementNamed(context, '/intro-view');
    }
    //return true;
    /*{
      "isSignedIn": isSignedIn,
      "isRegistered": isRegistered
    };*/
  }
  

  @override
  void initState() {
    checkSignInState();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    DevEnvironmentProvider devEnv = Provider.of<DevEnvironmentProvider>(context, listen: false);
    SizeConfig().init(context);
    return Scaffold(
          body: Center(child: Text("Splash Screen Temporaire !!!\n${devEnv.getEnv}", textAlign: TextAlign.center,),),
        );
  }
}