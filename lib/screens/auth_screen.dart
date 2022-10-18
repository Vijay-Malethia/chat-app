import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;
  var isLoading = false;
  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool islogin,
    BuildContext ctx,
    File image,
  ) async {
    UserCredential authresult;
    try {
      setState(() {
        isLoading = true;
      });
      if (islogin) {
        authresult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        print(authresult);
      } else {
        authresult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authresult.user!.uid + '.jpg');
        ref.putFile(image);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authresult.user?.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
    } on PlatformException catch (err) {
      var message = 'an error occured, please check your crdential';
      if (err.message != null) {
        message = err.message.toString();
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, isLoading));
  }
}
