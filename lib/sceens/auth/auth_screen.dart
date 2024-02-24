import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              SizedBox(
                width: 200,
                child: Image.asset('assets/images/logo.png'),
              ),
              const Text('Đăng ký để lưu thông tin của bạn', style: TextStyle(fontSize: 22),),
              const SizedBox(height: 24,),
              ElevatedButton (
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(255, 177, 32, 1),fixedSize: const Size(250,45)),
                child: const Text('Đăng ký', style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),),
                
              ),
              const SizedBox(height: 16,),
              TextButton(
                onPressed: () {
                  
                },
                child: const Text('Đăng nhập', style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal),),
              ),
              const SizedBox(height: 54,),
              const Spacer(),
              const Text('Đăng nhập với',style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
              IconButton(
                onPressed: () {},
                icon: const Icon(EvaIcons.google)
              ),
              const SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}
