import 'package:email_validator/email_validator.dart';
import 'package:expenses_tracker_app/firebase/firebase.dart';
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

  bool isSubmited = false;

  late bool _passwordVisible;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isSubmited = true;
    });
    try {
      await FirebaseAPI.firebaseAuth
          .signInWithEmailAndPassword(email: _email.text, password: _pass.text)
          .then((value) {
        Navigator.pop(context);
      });
    } on FirebaseAuthException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sai Email hoặc mật khẩu.'),
          ),
        );
        setState(() {
          isSubmited = false;
        });
      }
    }
  }

  @override
  void initState() {
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
      body: SingleChildScrollView(
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
                    autofocus: true,
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
                  onPressed: isSubmited ? null : _submit,
                  child: !isSubmited
                      ? const Text(
                          'Đăng nhập',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        )
                      : const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(),
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
