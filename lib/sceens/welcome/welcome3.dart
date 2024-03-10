import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class WelcomScreen3 extends StatelessWidget {
  WelcomScreen3({super.key, required this.currency});

  final Currency currency;

  TextEditingController balance = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Theme.of(context).primaryColor
        ),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 36),
            padding: const EdgeInsets.all(34),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Nhập số dư tài khoản chính',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  Text(
                    'Bạn có thể thêm nhiều tài khoản hơn trong phần tài khoản',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 42,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Form(
                        key: formKey,
                        child: Container(
                          margin: const EdgeInsets.only(top: 5),
                          width: 120,
                          height: 70,
                          child: TextFormField(
                            controller: balance,
                            maxLength: 15,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                            decoration:InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: kColorScheme.background,
                              hintStyle: const  TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(vertical:0, horizontal: 0),
                            ),
                            validator: (value) {
                              if(value == null || value.isEmpty) return 'Vui lòng nhập số dư';
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Expanded(child: Text(currency.code, style: const TextStyle(color: Colors.black,fontSize: 20))),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton (
                    onPressed: () async {
                      if(formKey.currentState!.validate() == true){
                        formKey.currentState!.save();
                      }
                      await FirebaseAPI.completeRegistration('Chính', int.parse(balance.text), currency.code, currency.name, currency.symbol, "0xe808", 4285132974)
                      .then((value) => Navigator.popUntil(context ,(route) => route.isFirst));
                    },
                    child: const Text('Tiếp theo', style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),),
                    
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
