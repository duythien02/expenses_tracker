import 'package:email_validator/email_validator.dart';
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _ResisterScreenState();
}

class _ResisterScreenState extends State<RegisterScreen> {
  late bool _passwordVisible;
  late bool _reTypePasswordVisible;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  final _userNameFocusNode = FocusNode();
  final _passFocusNode = FocusNode();
  final _reTypePassFocusNode = FocusNode();

  bool isSubmited = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _reTypePasswordVisible = false;
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _userName.dispose();
    _pass.dispose();
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isSubmited = true;
    });
    FocusScope.of(context).unfocus();
    try {
      await FirebaseAPI.firebaseAuth
          .createUserWithEmailAndPassword(
              email: _email.text, password: _pass.text)
          .then((user) async {
        await FirebaseAPI.createNewUser(_userName.text, _email.text, null)
            .then((value) => Navigator.pop(context));
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        setState(() {
          isSubmited = false;
        });
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email đã có người sử dụng'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đăng ký',
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
                  'Đăng ký với email và mật khẩu',
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
                    maxLength: 30,
                    decoration: const InputDecoration(
                      errorStyle: TextStyle(fontSize: 14),
                      hintText: "Email",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_userNameFocusNode),
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
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 380,
                  child: TextFormField(
                    focusNode: _userNameFocusNode,
                    controller: _userName,
                    style: const TextStyle(fontSize: 18),
                    maxLength: 50,
                    decoration: const InputDecoration(
                      errorStyle: TextStyle(fontSize: 14),
                      hintText: "Tên người dùng",
                    ),
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_passFocusNode),
                    validator: (value) {
                      if (value == null || value.trim().length < 4) {
                        return "Vui lòng nhập vào ít nhất 4 kí tự.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName.text = value!.trim();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 380,
                  child: TextFormField(
                    focusNode: _passFocusNode,
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
                    onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_reTypePassFocusNode),
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
                  height: 20,
                ),
                SizedBox(
                  width: 380,
                  child: TextFormField(
                    focusNode: _reTypePassFocusNode,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        hintText: "Nhập lại mật khẩu",
                        errorStyle: const TextStyle(fontSize: 14),
                        suffixIcon: IconButton(
                          icon: Icon(_reTypePasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _reTypePasswordVisible = !_reTypePasswordVisible;
                            });
                          },
                        )),
                    obscureText: !_reTypePasswordVisible,
                    validator: (value) {
                      if (value == null || value.trim().length < 6) {
                        return "Mật khẩu phải có độ dài ít nhất 6 kí tự.";
                      }
                      if (value != _pass.text) {
                        return "Mật khẩu không trùng khớp";
                      }
                      return null;
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
                          'Tiếp theo',
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
