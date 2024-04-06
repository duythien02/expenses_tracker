import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/category.dart';
import 'package:expenses_tracker_app/sceens/drawer/category/create_cateogry.dart';
import 'package:expenses_tracker_app/widgets/drawer/main_drawer.dart';
import 'package:expenses_tracker_app/widgets/category/category_item.dart';
import 'package:flutter/material.dart';

class UserCategory extends StatefulWidget {
  const UserCategory({super.key, required this.isExpense});
  final bool isExpense;

  @override
  State<UserCategory> createState() => _UserCategoryState();
}

class _UserCategoryState extends State<UserCategory> {
  bool isExpense = true;
  var getCategory = FirebaseAPI.getAllCategories();
  List<Category> listCateogories = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục'),
      ),
      drawer: FutureBuilder(
        future: FirebaseAPI.getInfoUser(),
        builder: (context, user) {
          if (user.hasData) {
            return MainDrawer(
              user: user.data!,
            );
          }
          return Container();
        },
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
                      if (isExpense != true) {
                        setState(() {
                          isExpense = true;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: isExpense
                              ? const Border(
                                  bottom:
                                      BorderSide(width: 2, color: Colors.white))
                              : const Border(bottom: BorderSide.none)),
                      child: Text(
                        'CHI PHÍ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight:
                                isExpense ? FontWeight.w600 : FontWeight.w400),
                      ),
                    )),
                TextButton(
                  onPressed: () {
                    if (isExpense == true) {
                      setState(() {
                        isExpense = false;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: !isExpense
                            ? const Border(
                                bottom:
                                    BorderSide(width: 2, color: Colors.white))
                            : const Border(bottom: BorderSide.none)),
                    child: Text(
                      'THU NHẬP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            isExpense ? FontWeight.w400 : FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
            future: getCategory,
            builder: (context, category) {
              if (category.connectionState == ConnectionState.waiting) {
                return Container(
                  height: MediaQuery.of(context).size.width / 2 - 15,
                );
              }
              if (category.hasData) {
                if (isExpense) {
                  listCateogories = (category.data!
                      .where((e) => e.type == Type.expense.name)).toList();
                } else {
                  listCateogories = (category.data!
                      .where((e) => e.type == Type.income.name)).toList();
                }
                return Expanded(
                  child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      children:
                          List.generate(listCateogories.length + 1, (index) {
                        if (index < listCateogories.length) {
                          return GestureDetector(
                            onTap: () {
                              //go to edit category screen
                            },
                            child: CategoryItem(
                              category: listCateogories[index],
                              isAddCategory: false,
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddCategoryScreen(
                                    isExpense: isExpense,
                                    category: null,
                                  ),
                                ),
                              );
                              setState(() {
                                getCategory = FirebaseAPI.getAllCategories();
                              });
                            },
                            child: const CategoryItem(
                              category: null,
                              isAddCategory: false,
                            ),
                          );
                        }
                      })),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
