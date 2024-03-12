import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/widgets/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text('Hồ sơ',style: TextStyle(color: Colors.white),),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30)
          )
        ),
      ),
      drawer: FutureBuilder(
        future: FirebaseAPI.getInfoUser(),
        builder: (context,user){
        if(user.connectionState == ConnectionState.done){
          return MainDrawer(user: user.data!,);
        }
          return Container();
        },
      )
    );
  }
}