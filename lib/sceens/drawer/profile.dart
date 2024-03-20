import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/models/user.dart';
import 'package:expenses_tracker_app/widgets/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hồ sơ',
          style: TextStyle(color: Colors.white),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      ),
      drawer: FutureBuilder(
        future: FirebaseAPI.getInfoUser(),
        builder: (context, user) {
          if (user.connectionState == ConnectionState.done) {
            return MainDrawer(
              user: user.data!,
            );
          }
          return Container();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 34,horizontal: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width/6,
                backgroundImage: user.image == null
                    ? const AssetImage("assets/images/user_avatar.png")
                        as ImageProvider
                    : NetworkImage(user.image!),
              ),
            ),
            const SizedBox(height: 22,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.mail_outline, color: Colors.grey[600]),
                const SizedBox(width: 10,),
                Text('Địa chỉ mail', style: TextStyle(color: Colors.grey[600], fontSize: 16))
              ],
            ),
            const SizedBox(height: 4,),
            Text(user.email, style: const TextStyle(color: Colors.black),),
            const SizedBox(height: 8,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.person_2_outlined, color: Colors.grey[600]),
                const SizedBox(width: 10,),
                Text('Tên người dùng', style: TextStyle(color: Colors.grey[600], fontSize: 16))
              ],
            ),
            const SizedBox(height: 4,),
            Text(user.userName, style: const TextStyle(color: Colors.black),)
          ],
        ),
      ),
    );
  }
}
