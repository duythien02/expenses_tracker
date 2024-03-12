import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/category.dart';
import 'package:expenses_tracker_app/widgets/item_category.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

// ignore: must_be_immutable
class AddExpense extends StatefulWidget {
  AddExpense({super.key, required this.isExpense, required this.listAccount});
  bool isExpense;
  List<Account> listAccount;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final formKey = GlobalKey<FormState>();

  TextEditingController balance = TextEditingController();

  final getCategory = FirebaseAPI.getAllCategories();

  List<Category> subListCategory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thêm giao dịch',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(children: [
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
        Container(
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
                        controller: balance,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số dư';
                          }
                          return null;
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
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ],
              ),
              Text(
                'Tài khoản',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                child: Text('Chưa chọn',
                    style: TextStyle(
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .primary)),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Danh mục',
                style: TextStyle(color: Colors.grey[600]),
              ),
              FutureBuilder(
                  future: getCategory,
                  builder: (context, category) {
                    if (category.hasData) {
                      if(widget.isExpense){
                        subListCategory = (category.data!.where((e) => e.type == Type.expense.name)).toList();
                        
                      }else{
                        subListCategory = (category.data!.where((e) => e.type == Type.income.name)).toList();
                      }
                      return Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: MediaQuery.of(context).size.width / 2,
                        child: GridView.count(
                            crossAxisCount: 4,
                            children: List.generate(
                                subListCategory.length >= 7
                                    ? 8
                                    : subListCategory.length + 1, (index) {
                              if ((index < 7 && index < subListCategory.length)) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (subListCategory.indexWhere((e) => e.picked == true) >=0) {
                                        subListCategory[subListCategory.indexWhere(
                                                (e) => e.picked == true)]
                                            .picked = false;
                                      }
                                      subListCategory[index].picked = true;
                                    });
                                  },
                                  child: CategoryItem(
                                    category: subListCategory[index],
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {},
                                  child: const CategoryItem(
                                    category: null,
                                  ),
                                );
                              }
                            })),
                      );
                    }
                    return Container();
                  })
            ],
          ),
        ),
      ]),
    );
  }
}
