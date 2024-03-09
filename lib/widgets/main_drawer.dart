import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/user.dart';
import 'package:expenses_tracker_app/sceens/home/home.dart';
import 'package:expenses_tracker_app/sceens/drawer/profile.dart';
import 'package:expenses_tracker_app/widgets/item_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: must_be_immutable
class MainDrawer extends StatelessWidget {
  MainDrawer({super.key, required this.user});
  UserModel user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ProfileScreen()),(route) => route.isFirst);
              },
              child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: kColorScheme.onPrimaryContainer
                  ),
                  currentAccountPicture: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: user.image == null 
                      ? const AssetImage("assets/images/user_avatar.png") as ImageProvider
                      : NetworkImage(user.image!),    
                  ),
                  accountName: Text('Tên người dùng: ${user.userName}'),
                  accountEmail: Text('Email: ${user.email}')
                  ),
              ),
            ItemDrawer(destination: const HomeScreen(), icon: Icons.home, title: "Trang chủ"),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut().whenComplete(() => Navigator.popUntil(context, (route) => route.isFirst));
                await GoogleSignIn().signOut();
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