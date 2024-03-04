import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/sceens/home/home.dart';
import 'package:expenses_tracker_app/sceens/profile/profile.dart';
import 'package:expenses_tracker_app/widgets/item_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ProfileScreen()),(route) => route.isFirst);
              },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  color: kColorScheme.onPrimaryContainer,
                  height: 66,
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: Image.asset("assets/images/user_avatar.png"),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tên người dùng',
                              style: const TextTheme().bodyMedium),
                          Text('Số dư', style: const TextTheme().bodyMedium)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ItemDrawer(destination: const HomeScreen(), icon: Icons.home, title: "Trang chủ"),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Row(
                  children: [
                    Icon(Icons.logout,color: Colors.white,),
                    SizedBox(width: 20,),
                    Text('Đăng xuất')
                  ],
                ),
              ),
            )
          ],
        ),
      );
  }
}