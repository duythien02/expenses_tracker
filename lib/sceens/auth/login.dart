import 'package:email_validator/email_validator.dart';
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/helper/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _pass = TextEditingController();

  bool isAuthenticating = false;

  late bool _passwordVisible;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      setState(() {
        isAuthenticating = true;
      });
      await FirebaseAPI.firebaseAuth
        .signInWithEmailAndPassword(
          email: _email.text, password: _pass.text).whenComplete(() => Navigator.pop(context));
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sai Email hoặc mật khẩu.'),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đăng nhập',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: isAuthenticating ? loading() : SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 35,
                ),
                const Text(
                  'Nhập email và mật khẩu bạn đã đăng ký',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 380,
                  child: TextFormField(
                    controller: _email,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      errorStyle: TextStyle(fontSize: 14),
                      hintText: "Email",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !EmailValidator.validate(value)) {
                        return "Vui lòng nhập địa chỉ email hợp lệ.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email.text = value!.trim();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 380,
                  child: TextFormField(
                    controller: _pass,
                    style: const TextStyle(fontSize: 18),
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                        hintText: "Mật khẩu",
                        errorStyle: const TextStyle(fontSize: 14),
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        )),
                    validator: (value) {
                      if (value == null || value.trim().length < 6) {
                        return "Mật khẩu phải có độ dài ít nhất 6 kí tự.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _pass.text = value!.trim();
                    },
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    _submit();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 177, 32, 1),
                      fixedSize: const Size(250, 45)),
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
