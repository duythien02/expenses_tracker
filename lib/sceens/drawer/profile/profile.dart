import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/models/user.dart';
import 'package:expenses_tracker_app/widgets/drawer/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user, required this.expenseData, required this.account});
  final UserModel user;
  final Map<dynamic, List<Expense>> expenseData;
  final Account account;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEmailVerified = false;
  @override
  void initState() {
    super.initState();
    FirebaseAPI.user.reload();
    isEmailVerified = FirebaseAPI.user.emailVerified;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hồ sơ',
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
              expenseData: widget.expenseData,
              account: widget.account,
            );
          }
          return Container();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 6,
                backgroundImage: widget.user.image == null
                    ? const AssetImage("assets/images/user_avatar.png")
                        as ImageProvider
                    : NetworkImage(widget.user.image!),
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.mail_outline, color: Colors.grey[600]),
                const SizedBox(
                  width: 10,
                ),
                Text('Địa chỉ mail',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16))
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            isEmailVerified
                ? Text(
                    widget.user.email,
                    style: const TextStyle(color: Colors.black),
                  )
                : InkWell(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(20),
                            actionsPadding: const EdgeInsets.only(right: 20),
                            content: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: const Text(
                                'Email chưa được xác minh, gửi lại email kèm liên kết xác minh',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,),
                              ),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
                              TextButton(onPressed: () {
                                FirebaseAPI.user.sendEmailVerification();
                                Navigator.pop(context);
                              }, child: const Text('Gửi')),
                            ],
                          );
                        },
                      );
                    },
                    child: SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.user.email,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          )
                        ],
                      ),
                    ),
                  ),
            const SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.person_2_outlined, color: Colors.grey[600]),
                const SizedBox(
                  width: 10,
                ),
                Text('Tên người dùng',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16))
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              widget.user.userName,
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          await showDialog(context: context, builder: (context) => AlertDialog(
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
              TextButton(onPressed: () async {
                await FirebaseAuth.instance.signOut().whenComplete(() => Navigator.popUntil(context, (route) => route.isFirst));
                await GoogleSignIn().signOut();
              }, child: const Text('Thoát')),
            ],
            contentPadding: const EdgeInsets.all(32),
            content: const Text('Bạn có muốn đăng xuất không?', style: TextStyle(color: Colors.black),),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Thoát', style: TextStyle(color: kColorScheme.primary),),
              const SizedBox(width: 6,),
              Icon(Icons.exit_to_app,color: kColorScheme.primary,)
            ],
          ),
        ),
      ),
    );
  }
}
