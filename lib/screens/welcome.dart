import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_manager/widgets/profile.dart';
import 'package:college_manager/widgets/timetable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/redirect.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int _selectedTab;
  String _user;
  Future<FirebaseUser> get _getUser async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _user = prefs.getString('user');
    } catch (e) {
      print(e);
    }
    return FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUser,
        builder: (ctx, snap) {
          if (snap.hasData) {
            return FutureBuilder(
              future: Firestore.instance
                  .collection(_user)
                  .document(snap.data.uid)
                  .get(),
              builder: (ctx, snapdata) {
                if (snapdata.connectionState == ConnectionState.waiting)
                  return Redirect();

                if (snapdata.hasData) {
                  var data = snapdata.data;
                  return DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text(data['name']),
                        actions: <Widget>[
                          IconButton(
                              icon: Icon(Icons.exit_to_app),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('user');
                                FirebaseAuth.instance.signOut();
                              })
                        ],
                        bottom: TabBar(
                          tabs: [
                            Tab(
                              icon: Icon(Icons.schedule),
                              text: 'TimeTable',
                            ),
                            Tab(
                              icon: Icon(Icons.person_outline),
                              text: 'Profile',
                            )
                          ],
                        ),
                      ),
                      body: TabBarView(children: [
                        Scaffold(
                          bottomNavigationBar: TimeTableWidget(),
                        ),
                        Profile(data, _user),
                      ]),
                    ),
                  );
                }
                return Center(child: Text('No data'));
              },
            );
          }
          return Redirect();
        });
  }
}
