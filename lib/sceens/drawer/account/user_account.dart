import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/widgets/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class UserAccountScreen extends StatelessWidget {
  const UserAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      drawer: FutureBuilder(
        future: FirebaseAPI.getInfoUser(),
        builder: (context, user) {
          if (user.hasData) {
            return MainDrawer(
              user: user.data!,
            );
          }
          return Container();
        },
      ),
    );
  }
}