import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/sceens/welcome/welcome2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomScreen1 extends StatelessWidget {
  const WelcomScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Theme.of(context).primaryColor
        ),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 150),
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 150,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  const SizedBox(height: 50,),
                  Text('Chào mừng bạn đến với Quản lý chi tiêu',style: TextStyle(color: kColorScheme.primary,fontSize: 20,fontWeight: FontWeight.w600)),
                  const SizedBox(height: 24,),
                  const Text('Quản lý chi tiêu - một ứng dùng dùng để theo dõi chi tiêu và thu nhập một cách dễ dàng', textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.black),),
                  const SizedBox(height: 52,),
                  ElevatedButton (
                      onPressed: () async{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomScreen2()));
                      },
                      child: const Text('Bắt đầu', style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),),
                      
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
