import 'package:expenses_tracker_app/data/curencies_data.dart';
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/category.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/sceens/drawer/category/expand_category.dart';
import 'package:expenses_tracker_app/widgets/category/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

// ignore: must_be_immutable
class AddExpenseScreen extends StatefulWidget {
  AddExpenseScreen(
      {super.key,
      required this.isExpense,
      this.listAccount,
      required this.currentAccount,
      this.expense,
      required this.isUpdateExpense});
  bool isExpense;
  final List<Account>? listAccount;
  Account currentAccount;
  final Expense? expense;
  final bool isUpdateExpense;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpenseScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController note = TextEditingController();
  var getCategory = FirebaseAPI.getAllCategories();
  List<Category> listCategories = [];
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  bool isCategoryPicked = false;
  bool isSubmited = false;
  Category? category;

  @override
  void initState() {
    super.initState();
    if(widget.expense != null){
      getCategoryfromDB();
      isCategoryPicked = true;
      if (!currenciesCodeHasDecimal.contains(widget.currentAccount.currencyCode)) {
        amount.text = widget.expense!.amount.toStringAsFixed(0);
      }else{
        amount.text = widget.expense!.amount.toStringAsFixed(2);
      }
      if(widget.expense!.note != null){
        note.text = widget.expense!.note!;
      }
    }
  }
  @override
  void dispose(){
    super.dispose();
    amount.dispose();
    note.dispose();
  }

  Future<void> getCategoryfromDB() async{
    await FirebaseAPI.getCategory(widget.expense!.categoryId).then((value) {
      setState(() {
        category = value;
        category!.picked =  true;
      });
    });
  }

  void addExpense() async {
    if ( formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        isSubmited = true;
      });
      FocusScope.of(context).unfocus();
      bool isChangeTypeExpense = false;
      if(widget.isUpdateExpense){
        if(widget.expense!.type == true && widget.isExpense == false || widget.expense!.type == false && widget.isExpense == true){
          isChangeTypeExpense = true;
        }
        await FirebaseAPI.updateExpense(
          widget.expense!.expenseId,
          double.parse(amount.text),
          widget.expense!.amount,
          listCategories.firstWhere((element) => element.picked == true),
          selectedDate,
          note.text.isEmpty ? null : note.text,
          widget.currentAccount.accountId,
          widget.isExpense,
          isChangeTypeExpense
        ).whenComplete(() => Navigator.popUntil(context, (route) => route.isFirst));
      }else{
        await FirebaseAPI.addExpense(
          double.parse(amount.text),
          listCategories.firstWhere((element) => element.picked == true),
          selectedDate,
          note.text.isEmpty ? null : note.text,
          widget.currentAccount.accountId,
          widget.isExpense
        ).whenComplete(() => Navigator.pop(context));
      }
    }
  }

  String moneyFormat(double number) {
    var format = NumberFormat.simpleCurrency(
        locale: widget.currentAccount.currencyLocale); 
    return format.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isUpdateExpense ? 'Chỉnh sửa giao dịch' : 'Thêm giao dịch',
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
                              decoration: const InputDecoration(
                                counterText: '',
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 0),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp('-')),
                                FilteringTextInputFormatter.deny(RegExp(',')),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty){
                                  return 'Vui lòng nhập số tiền';
                                }else if(double.tryParse(value) == null || double.parse(value) == 0 || value.contains('.') && value.split('.')[1].length > 2){
                                  return 'Số tiền không hợp lệ';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if(currenciesCodeHasDecimal.contains(widget.currentAccount.currencyCode)){
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
                            widget.currentAccount.currencyCode,
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
                      onTap: widget.isUpdateExpense ? null : () async {
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
                                              widget.listAccount!.length,
                                              (index) => RadioListTile(
                                                    title: Text(
                                                      widget.listAccount![index]
                                                          .accountName,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    subtitle: Text(moneyFormat(
                                                        widget
                                                            .listAccount![index]
                                                            .accountBalance)),
                                                    value: widget.listAccount![index],
                                                    groupValue: widget.currentAccount,
                                                    onChanged: (value) {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        widget.currentAccount = value!;
                                                      });
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
                      builder: (context, categoryData) {
                        if (categoryData.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: MediaQuery.of(context).size.width / 2 - 15,
                          );
                        }
                        if (categoryData.hasData) {
                        categoryData.data!.sort((category1 ,category2) => category2.createAt.compareTo(category1.createAt));
                          listCategories = (categoryData.data!
                                    .where((e) => e.type == widget.isExpense))
                                .toList();
                              if(category != null){
                                if (listCategories.contains(category) ) {
                                  if(category!.type == widget.isExpense && listCategories.indexWhere((element) => element.categoryId == category!.categoryId) > 6){
                                    listCategories.removeWhere((element) => element.categoryId == category!.categoryId);
                                    listCategories.insert(0, category!);
                                  }
                                }else{
                                  if(category!.type == widget.isExpense && listCategories.indexWhere((element) => element.categoryId == category!.categoryId) > 6){
                                    listCategories.removeWhere((element) => element.categoryId == category!.categoryId);
                                    listCategories.insert(0, category!);
                                  }else{
                                    if( listCategories.indexWhere((element) => element.categoryId == category!.categoryId) > -1){
                                      int index = listCategories.indexWhere((element) => element.categoryId == category!.categoryId);
                                      listCategories.removeWhere((element) => element.categoryId == category!.categoryId);
                                      listCategories.insert(index, category!);
                                    }
                                  }
                                }
                              }
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: MediaQuery.of(context).size.width / 2 - 15,
                            child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 4,
                                children: List.generate(
                                    listCategories.length >= 7
                                        ? 8
                                        : listCategories.length + 1, (index) {
                                  if ((index < 7 &&
                                      index < listCategories.length)) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (listCategories[index].picked == false) {
                                            for(var category in listCategories){
                                              category.picked = false;
                                            }
                                            isCategoryPicked = true;
                                            listCategories[index].picked = true;
                                          }
                                        });
                                      },
                                      child: CategoryItem(
                                        category: listCategories[index],
                                        isAddCategory: true,
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () async {
                                        // chuyển đến màn hình mở rộng danh mục
                                        var categoryFromExpandCategoryScreen = await Navigator.push(context, MaterialPageRoute(builder: (context) => ExpandCategoryScreen(listCategories: listCategories, isExpense: widget.isExpense,)));
                                        if(categoryFromExpandCategoryScreen != null){
                                          if(categoryFromExpandCategoryScreen == true){
                                            // tạo một category mới
                                              category = null;
                                              getCategory = FirebaseAPI.getAllCategories();
                                              getCategory.then((value) {
                                                value.sort((category1 ,category2) => category2.createAt.compareTo(category1.createAt));
                                                if(value[0].type == true){
                                                  setState(() {
                                                    widget.isExpense = true;
                                                  });
                                                }else{
                                                  setState(() {
                                                    widget.isExpense = false;
                                                  });
                                                }
                                                value[0].picked = true;
                                              });
                                          }else{
                                            // chọn một category khác
                                            setState(() {
                                              category = categoryFromExpandCategoryScreen;
                                              isCategoryPicked = true;
                                            });
                                          }
                                        }
                                      },
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
                            ? Text(
                                widget.isUpdateExpense ? 'Lưu' : 'Thêm',
                                style: const TextStyle(
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
