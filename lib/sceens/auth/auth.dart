import 'dart:developer';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/sceens/auth/resister.dart';
import 'package:expenses_tracker_app/sceens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  
  _handleGoogleBtnClick() {
    _signInWithGoogle().then((user) async {
      if (user != null && user.additionalUserInfo!.isNewUser) {
        await FirebaseAPI.createNewUser(
          FirebaseAPI.user.displayName!,
          FirebaseAPI.user.email!,
          FirebaseAPI.user.photoURL,
          );
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              SizedBox(
                width: 200,
                child: Image.asset('assets/images/logo.png'),
              ),
              const Text(
                'Đăng ký để lưu thông tin của bạn',
                style: TextStyle(fontSize: 22,color: Colors.black),
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                },
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Text(
                  "Đăng nhập",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ),
              const SizedBox(
                height: 54,
              ),
              const Spacer(),
              const Text(
                "Đăng nhập với",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
              IconButton(
                onPressed: _handleGoogleBtnClick,
                icon: const Icon(EvaIconData(0xeaec)),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
