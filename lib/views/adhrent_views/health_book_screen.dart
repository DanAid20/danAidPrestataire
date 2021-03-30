import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HealthBookScreen extends StatefulWidget {
  @override
  _HealthBookScreenState createState() => _HealthBookScreenState();
}

class _HealthBookScreenState extends State<HealthBookScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(children: [
            Text("Carnet de Santé"),
            Text("Paramètres temporaires"),
            TextButton(
              child: Text("Se Déconnecter"),
              onPressed: () async {
                //HiveDatabase.setSignInState(true);
                HiveDatabase.setRegisterState(false);
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/splash');
              },
            ),
          ],),
        ),
      ),
    );
  }
}