import 'package:expenses_tracker_app/data/curencies_data.dart';
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomScreen3 extends StatefulWidget {
  const WelcomScreen3({super.key, required this.currency});

  final Currency currency;

  @override
  State<WelcomScreen3> createState() => _WelcomScreen3State();
}

class _WelcomScreen3State extends State<WelcomScreen3> {
  TextEditingController balance = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isSubmited = false;

  @override
  void dispose() {
    super.dispose();
    balance.dispose();
  }

  void _submit() async {
    final isValidForm = formKey.currentState!.validate();
    if (!isValidForm) {
      return;
    }
    formKey.currentState!.save();
    setState(() {
      isSubmited = true;
    });
    await FirebaseAPI.completeRegistration(
            'Chính',
            double.parse(balance.text),
            widget.currency.code,
            widget.currency.name,
            widget.currency.locale,
            "0xe808",
            4285132974)
        .then((value) => Navigator.popUntil(context, (route) => route.isFirst));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Theme.of(context).primaryColor),
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
                  const SizedBox(
                    height: 42,
                  ),
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
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: kColorScheme.surface,
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(',')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập số dư';
                              } else if (double.tryParse(value) == null ||
                                  (value.contains('.') &&
                                      value.split('.')[1].length > 2)) {
                                return 'Số dư không hợp lệ';
                              }
                              return null;
                            },
                            onChanged: (value) {},
                            onSaved: (value) {
                              if (currenciesCodeHasDecimal
                                  .contains(widget.currency.code)) {
                                balance.text = value!.trim();
                              } else {
                                balance.text = value!.split('.')[0];
                              }
                            },
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Text(widget.currency.code,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20))),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: isSubmited ? null : _submit,
                    child: !isSubmited
                        ? const Text(
                            'Hoàn thành',
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
      ),
    );
  }
}
