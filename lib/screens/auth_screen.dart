import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/auth_form.dart';
import '../enums/enums.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    BuildContext ctx, {
    String name,
    String email,
    String password,
    bool isLogin,
    String stream,
    String phn,
    String reg,
    User userType,
    File image,
  }) async {
    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user', userType.toString());
      prefs.setString('lastuser', userType.toString());
      if (isLogin) {
        if (userType == User.admin) {
          var admin =
              await Firestore.instance.collection('User.admin').getDocuments();
          if (email != admin.documents[0]['email']) {
            Scaffold.of(ctx).showSnackBar(
              SnackBar(
                content: Text('You are not admin.'),
                backgroundColor: Theme.of(ctx).errorColor,
              ),
            );
          }
        }
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.jpg');
        await ref.putFile(image).onComplete;
        final url = await ref.getDownloadURL();
        if (userType == User.teacher) {
          await Firestore.instance
              .collection(userType.toString())
              .document(authResult.user.uid)
              .setData({
            'phone number': phn,
            'name': name,
            'email': email,
            'image_url': url,
          });
        }
        if (userType == User.student) {
          await Firestore.instance
              .collection(userType.toString())
              .document(authResult.user.uid)
              .setData({
            'phone number': phn,
            'stream': stream,
            'registration no.': reg,
            'name': name,
            'email': email,
            'image_url': url,
          });
        }
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      log(err.toString(), name: 'debug');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
