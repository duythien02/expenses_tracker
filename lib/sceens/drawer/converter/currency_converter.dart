import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:expenses_tracker_app/data/curencies_data.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/currency.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/services/currency_converter_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen(
      {super.key, required this.account, required this.expenseData});
  final Map<dynamic, List<Expense>> expenseData;
  final Account account;

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final CurrencyConverter converter = CurrencyConverter();
  final formKey = GlobalKey<FormState>();
  TextEditingController fromCurrencyctrl = TextEditingController();
  TextEditingController toCurrencyctrl = TextEditingController();
  final List<Currency> listCurrency = currencies;
  late Currency fromCurrency;
  late Currency toCurrency;
  bool isSubmited = false;
  double? rate;

  @override
  void initState() {
    fromCurrency = listCurrency
        .firstWhere((element) => element.code == widget.account.currencyCode);
    toCurrency = listCurrency
        .firstWhere((element) => element.code != widget.account.currencyCode);
    fromCurrencyctrl.text = 0.toString();
    toCurrencyctrl.text = 0.toString();
    super.initState();
    converter.getRate(fromCurrency.code, toCurrency.code).then((value) {
      setState(() {
        rate = value;
      });
    });
  }

  void convert() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      setState(() {
        isSubmited = true;
      });
      await converter
          .getConvert(fromCurrency.code, toCurrency.code,
              double.parse(fromCurrencyctrl.text))
          .then((value) {
        setState(() {
          toCurrencyctrl.text = value.toString();
          isSubmited = false;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    toCurrencyctrl.dispose();
    fromCurrencyctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chuyển đổi tiền tệ"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Text(
                      'Công cụ chuyển đổi tiền tệ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 24),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Chuyển đổi các đơn vị tiền tệ có trong hệ thống và kiểm tra tỉ giá.',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 28, right: 28, bottom: 36),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 36),
                                  child: Column(
                                    children: [
                                      DropdownButton(
                                          value: fromCurrency,
                                          items: List.generate(
                                            listCurrency.length,
                                            (index) => DropdownMenuItem(
                                              value: listCurrency[index],
                                              child: Text(
                                                listCurrency[index].name,
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            fromCurrency = value!;
                                            fromCurrencyctrl.text =
                                                0.toString();
                                            setState(() {
                                              rate = null;
                                            });
                                            converter
                                                .getRate(fromCurrency.code,
                                                    toCurrency.code)
                                                .then((value) {
                                              setState(() {
                                                rate = value;
                                              });
                                            });
                                          }),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Form(
                                        key: formKey,
                                        child: TextFormField(
                                          controller: fromCurrencyctrl,
                                          maxLength: 15,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontSize: 20),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            counterText: '',
                                            filled: true,
                                            fillColor: kColorScheme.surface,
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 12),
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(
                                                RegExp(',')),
                                          ],
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Vui lòng nhập số tiền muốn đổi';
                                            } else if (double.tryParse(value) ==
                                                    null ||
                                                (value.contains('.') &&
                                                    value.split('.')[1].length >
                                                        2)) {
                                              return 'Số tiền nhập vào không hợp lệ';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            if (currenciesCodeHasDecimal
                                                .contains(fromCurrency.code)) {
                                              fromCurrencyctrl.text =
                                                  value!.trim();
                                            } else {
                                              fromCurrencyctrl.text =
                                                  value!.split('.')[0];
                                            }
                                          },
                                          onTapOutside: (event) =>
                                              FocusScope.of(context).unfocus(),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 36),
                                  child: Column(
                                    children: [
                                      DropdownButton(
                                          value: toCurrency,
                                          items: List.generate(
                                            listCurrency.length,
                                            (index) => DropdownMenuItem(
                                              value: listCurrency[index],
                                              child: Text(
                                                  listCurrency[index].name),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            toCurrency = value!;
                                            toCurrencyctrl.text = 0.toString();
                                            setState(() {
                                              rate = null;
                                            });
                                            converter
                                                .getRate(fromCurrency.code,
                                                    toCurrency.code)
                                                .then((value) {
                                              setState(() {
                                                rate = value;
                                              });
                                            });
                                          }),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      TextField(
                                        controller: toCurrencyctrl,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(fontSize: 20),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          counterText: '',
                                          filled: true,
                                          fillColor: kColorScheme.surface,
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 12),
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                              RegExp(',')),
                                          FilteringTextInputFormatter.deny(
                                              RegExp('-')),
                                        ],
                                        enabled: false,
                                        onTapOutside: (event) =>
                                            FocusScope.of(context).unfocus(),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: kColorScheme.primary,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    EvaIcons.arrowDownwardOutline,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        ElevatedButton(
                            onPressed: isSubmited ? null : convert,
                            child: isSubmited
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : const Text(
                                    'Chuyển đổi',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Tỉ giá',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                rate != null
                    ? Text(
                        '1 ${fromCurrency.code} = $rate ${toCurrency.code}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
          ),
        ));
  }
}
