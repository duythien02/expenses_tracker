import 'package:expenses_tracker_app/data/curencies_data.dart';
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/currency.dart';
import 'package:expenses_tracker_app/models/transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CreateTransfer extends StatefulWidget {
  CreateTransfer({
    super.key,
    required this.listAccount,
    required this.currency,
  });
  List<Account> listAccount;
  Currency currency;

  @override
  State<CreateTransfer> createState() => _CreateTransferState();
}

class _CreateTransferState extends State<CreateTransfer> {
  final formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController note = TextEditingController();
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  bool isSubmited = false;
  Account? fromAccount;
  Account? toAccount;
  List<Account> listAccountTo = [];

  void submit() async {
    final isValidForm = formKey.currentState!.validate();
    if (!isValidForm) {
      return;
    }
    formKey.currentState!.save();
    setState(() {
      isSubmited = true;
    });
      return await FirebaseAPI.setTransfer(
        fromAccount!,
        toAccount,
        double.parse(amount.text),
        selectedDate,
        note.text.isEmpty ? null : note.text,
        TransferType.transfer.name,
      ).whenComplete(() => Navigator.pop(context,true));
  }

  @override
  void initState() {
    super.initState();
    amount.text = 0.toString();
  }

  @override
  void dispose() {
    super.dispose();
    amount.dispose();
    note.dispose();
  }

  void filterAccount(Account fromAccount) {
    listAccountTo.clear();
    for (var account in widget.listAccount) {
      if (fromAccount.currencyCode == account.currencyCode &&
          fromAccount.accountId != account.accountId) {
        listAccountTo.add(account);
      }
    }
  }

  String moneyFormat(double number, Account account) {
    var format = NumberFormat.simpleCurrency(locale: account.currencyLocale);
    return format.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo chuyển khoản"),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "*Lưu ý: Chỉ có thể chuyển khoản với những tài khoản có cùng đơn vị tiền tệ",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Text(
              "Chuyển từ tài khoản",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            GestureDetector(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Huỷ'),
                      )
                    ],
                    title: const Text('Chọn tài khoản'),
                    contentPadding: const EdgeInsets.all(10),
                    content: IntrinsicHeight(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width / 2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              widget.listAccount.length,
                              (index) => RadioListTile(
                                title: Text(
                                  widget.listAccount[index].accountName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text(
                                  moneyFormat(
                                    widget.listAccount[index].accountBalance,
                                    widget.listAccount[index],
                                  ),
                                ),
                                value: widget.listAccount[index],
                                groupValue: fromAccount,
                                onChanged: (value) {
                                  Navigator.pop(context);
                                  setState(() {
                                    if ((fromAccount != null &&
                                            fromAccount!.currencyCode !=
                                                value!.currencyCode) ||
                                        (toAccount != null &&
                                            value!.accountId ==
                                                toAccount!.accountId)) {
                                      toAccount = null;
                                    }
                                    fromAccount = value;
                                    filterAccount(fromAccount!);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                fromAccount != null ? fromAccount!.accountName : "Chưa chọn",
                style: TextStyle(
                  color: Theme.of(context).buttonTheme.colorScheme!.primary,
                ),
              ),
            ),
            if (fromAccount != null)
              Text('Số dư: ${moneyFormat(fromAccount!.accountBalance, fromAccount!) }', style: const TextStyle(color: Colors.black),),
              const SizedBox(
                height: 16,
              ),
            if (fromAccount != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chuyển vào tài khoản",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => listAccountTo.isEmpty
                            ? const AlertDialog(
                                content: SizedBox(
                                  child: Text(
                                    'Bạn cần phải tạo ít nhất một tài khoản cùng đơn vị tiền tệ khác để thực hiện tính năng chuyển khoản',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : AlertDialog(
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Huỷ'),
                                  )
                                ],
                                title: const Text('Chọn tài khoản'),
                                contentPadding: const EdgeInsets.all(10),
                                content: IntrinsicHeight(
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width / 2,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: List.generate(
                                          listAccountTo.length,
                                          (index) => RadioListTile(
                                            title: Text(
                                              listAccountTo[index].accountName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            subtitle: Text(
                                              moneyFormat(
                                                listAccountTo[index]
                                                    .accountBalance,
                                                listAccountTo[index],
                                              ),
                                            ),
                                            value: listAccountTo[index],
                                            groupValue: null,
                                            onChanged: (value) {
                                              Navigator.pop(context);
                                              setState(() {
                                                toAccount = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      );
                    },
                    child: Text(
                      toAccount != null ? toAccount!.accountName : "Chưa chọn",
                      style: TextStyle(
                        color:
                            Theme.of(context).buttonTheme.colorScheme!.primary,
                      ),
                    ),
                  ),
                  if (toAccount != null)
                    Text('Số dư: ${moneyFormat(toAccount!.accountBalance, toAccount!) }', style: const TextStyle(color: Colors.black),),
                    const SizedBox(
                      height: 16,
                    ),
                  Text(
                    "Số tiền chuyển khoản",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            else
              Container(),
            Row(
              children: [
                Form(
                  key: formKey,
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 120,
                    height: 70,
                    child: TextFormField(
                      controller: amount,
                      maxLength: 15,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        counterText: '',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp('-')),
                        FilteringTextInputFormatter.deny(RegExp(',')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập số tiền';
                        } else if (double.tryParse(value) == null ||
                            double.parse(value) == 0 ||
                            value.contains('.') &&
                                value.split('.')[1].length > 2) {
                          return 'Số tiền không hợp lệ';
                        }
                        if(double.parse(value) > fromAccount!.accountBalance){
                          return 'Số dư không đủ';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if(currenciesCodeHasDecimal.contains(fromAccount!.currencyCode)){
                          amount.text = value!.trim();
                        }else{
                          amount.text = value!.split('.')[0];
                        }
                      },
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    fromAccount != null
                        ? fromAccount!.currencyCode
                        : widget.currency.code,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Text(
              'Ngày',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            Row(
              children: [
                Text(
                  '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                  style: const TextStyle(color: Colors.black),
                ),
                IconButton(
                  onPressed: () async {
                    final DateTime? dateTime = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      locale: const Locale('vi', 'VI'),
                      lastDate: DateTime.now(),
                    );
                    if (dateTime != null) {
                      setState(() {
                        selectedDate = dateTime;
                      });
                    }
                  },
                  icon: const Icon(Icons.date_range),
                )
              ],
            ),
            Text(
              'Ghi chú',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            TextFormField(
              controller: note,
              maxLength: 4096,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                errorStyle: TextStyle(fontSize: 14),
                hintText: "Ghi chú",
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: toAccount == null
                            ? null
                            : isSubmited
                                ? null 
                                : submit,
                child: isSubmited
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(),
                      )
                    : const Text(
                        'Thêm',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
