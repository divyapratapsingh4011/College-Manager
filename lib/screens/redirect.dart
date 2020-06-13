import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Redirect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onDoubleTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('user');
            FirebaseAuth.instance.signOut();
          },
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
