import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/category.dart';
import 'package:expenses_tracker_app/widgets/category/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

// ignore: must_be_immutable
class AddExpense extends StatefulWidget {
  AddExpense(
      {super.key,
      required this.isExpense,
      required this.listAccount,
      required this.currentAccount});
  bool isExpense;
  final List<Account> listAccount;
  Account currentAccount;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController note = TextEditingController();
  final getCategory = FirebaseAPI.getAllCategories();
  List<Category> listCateogories = [];
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  bool isCategoryPicked = false;
  bool isSubmited = false;

  void addExpense() async {
    final isValidForm = formKey.currentState!.validate();
    if (!isValidForm) {
      return;
    }
    formKey.currentState!.save();
    setState(() {
      isSubmited = true;
    });
    if (note.text.isEmpty) {
      await FirebaseAPI.addExpense(
              int.parse(amount.text),
              listCateogories.firstWhere((element) => element.picked == true),
              selectedDate,
              null,
              widget.currentAccount,
              widget.isExpense)
          .whenComplete(() => Navigator.pop(context));
    } else {
      await FirebaseAPI.addExpense(
              int.parse(amount.text),
              listCateogories.firstWhere((element) => element.picked == true),
              selectedDate,
              note.text,
              widget.currentAccount,
              widget.isExpense)
          .whenComplete(() => Navigator.pop(context));
    }
  }

  String moneyFormat(int number) {
    var format = NumberFormat.simpleCurrency(
        locale: widget.currentAccount.currencyLocale);
    return format.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thêm giao dịch',
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 45,
            decoration: ShapeDecoration(
              color: kColorScheme.primary,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30))),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {
                      if (widget.isExpense != true) {
                        setState(() {
                          widget.isExpense = true;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: widget.isExpense
                              ? const Border(
                                  bottom:
                                      BorderSide(width: 2, color: Colors.white))
                              : const Border(bottom: BorderSide.none)),
                      child: Text(
                        'CHI PHÍ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: widget.isExpense
                                ? FontWeight.w600
                                : FontWeight.w400),
                      ),
                    )),
                TextButton(
                    onPressed: () {
                      if (widget.isExpense == true) {
                        setState(() {
                          widget.isExpense = false;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: !widget.isExpense
                              ? const Border(
                                  bottom:
                                      BorderSide(width: 2, color: Colors.white))
                              : const Border(bottom: BorderSide.none)),
                      child: Text(
                        'THU NHẬP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: widget.isExpense
                              ? FontWeight.w400
                              : FontWeight.w600,
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        Form(
                          key: formKey,
                          child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 120,
                            height: 70,
                            child: TextFormField(
                              controller: amount,
                              maxLength: 15,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: kColorScheme.background,
                                hintStyle: const TextStyle(color: Colors.grey),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 0),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp('-')),
                              ],
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    int.parse(value) == 0) {
                                  return 'Số tiền không hợp lệ';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                amount.text = value!.trim();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            widget.listAccount[0].currencyCode,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Tài khoản',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(
                      height: 5,
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
                                        child: const Text('Huỷ'))
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
                                              widget.listAccount.length,
                                              (index) => RadioListTile(
                                                    title: Text(
                                                      widget.listAccount[index]
                                                          .accountName,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    subtitle: Text(moneyFormat(
                                                        widget
                                                            .listAccount[index]
                                                            .accountBalance)),
                                                    value: widget
                                                        .listAccount[index],
                                                    groupValue:
                                                        widget.currentAccount,
                                                    onChanged: (value) {
                                                      widget.currentAccount =
                                                          value!;
                                                    },
                                                  )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                      },
                      child: Text(widget.currentAccount.accountName,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .primary)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Danh mục',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    FutureBuilder(
                      future: getCategory,
                      builder: (context, category) {
                        if (category.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: MediaQuery.of(context).size.width / 2 - 15,
                          );
                        }
                        if (category.hasData) {
                          if (widget.isExpense) {
                            listCateogories = (category.data!
                                    .where((e) => e.type == Type.expense.name))
                                .toList();
                          } else {
                            listCateogories = (category.data!
                                    .where((e) => e.type == Type.income.name))
                                .toList();
                          }
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: MediaQuery.of(context).size.width / 2 - 15,
                            child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 4,
                                children: List.generate(
                                    listCateogories.length >= 7
                                        ? 8
                                        : listCateogories.length + 1, (index) {
                                  if ((index < 7 &&
                                      index < listCateogories.length)) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (listCateogories[index].picked ==
                                              false) {
                                            if (listCateogories.indexWhere(
                                                    (e) => e.picked == true) >=
                                                0) {
                                              listCateogories[listCateogories
                                                      .indexWhere((e) =>
                                                          e.picked == true)]
                                                  .picked = false;
                                            }
                                            isCategoryPicked = true;
                                            listCateogories[index].picked =
                                                true;
                                          }
                                        });
                                      },
                                      child: CategoryItem(
                                        category: listCateogories[index],
                                        isAddCategory: true,
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: const CategoryItem(
                                        category: null,
                                        isAddCategory: true,
                                      ),
                                    );
                                  }
                                })),
                          );
                        }
                        return Container();
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Chọn ngày',
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
                            icon: const Icon(Icons.date_range))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
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
                    Center(
                      child: ElevatedButton(
                        onPressed: isCategoryPicked
                            ? isSubmited
                                ? null
                                : addExpense
                            : null,
                        child: !isSubmited
                            ? const Text(
                                'Thêm',
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
