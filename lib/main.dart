import 'package:college_manager/screens/redirect.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/auth_screen.dart';
import './screens/admin/ad_welcome.dart';
import './screens/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> get _getUser async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('user');
    } catch (e) {
      print(e);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      title: 'College Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amber,
        visualDensity: VisualDensity.comfortable,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, snap) {
          if (snap.hasData) {
            return FutureBuilder(
              future: _getUser,
              builder: (ctx, userSnapshot) {
                if (userSnapshot.hasData) {
                  var data = userSnapshot.data;
                  if (data == "User.student" || data == "User.teacher")
                    return Welcome();
                  else if (data == "User.admin") return AdminWelcome();
                }
                return Redirect();
              },
            );
          }
          return AuthScreen();
        },
      ),
    );
  }
}
