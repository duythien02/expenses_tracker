import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/category.dart';
import 'package:expenses_tracker_app/sceens/drawer/category/create_cateogry.dart';
import 'package:expenses_tracker_app/widgets/drawer/main_drawer.dart';
import 'package:expenses_tracker_app/widgets/category/category_item.dart';
import 'package:flutter/material.dart';

class UserCategoryScreen extends StatefulWidget {
  const UserCategoryScreen({super.key});

  @override
  State<UserCategoryScreen> createState() => _UserCategoryScreenState();
}

class _UserCategoryScreenState extends State<UserCategoryScreen> {
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
                      .where((e) => e.type == true)).toList();
                } else {
                  listCateogories = (category.data!
                      .where((e) => e.type == false)).toList();
                }
                listCateogories.sort((category1, category2) =>
                    category2.createAt.compareTo(category1.createAt));
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      children: List.generate(
                        listCateogories.length + 1,
                        (index) {
                          if (index < listCateogories.length) {
                            return GestureDetector(
                              onTap: () async {
                                var category = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCategoryScreen(isExpense: isExpense,category: listCateogories[index],)));
                                if (category != null) {
                                  setState(() {
                                    getCategory = FirebaseAPI.getAllCategories();
                                    isExpense = category;
                                  });
                                }
                              },
                              child: CategoryItem(
                                category: listCateogories[index],
                                isAddCategory: false,
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () async {
                                var category = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateCategoryScreen(
                                      isExpense: isExpense,
                                      category: null,
                                    ),
                                  ),
                                );
                                if (category != null) {
                                  setState(() {
                                    getCategory = FirebaseAPI.getAllCategories();
                                  });
                                }
                              },
                              child: const CategoryItem(
                                category: null,
                                isAddCategory: false,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
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
