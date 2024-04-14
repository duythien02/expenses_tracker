import 'package:expenses_tracker_app/models/category.dart';
import 'package:expenses_tracker_app/sceens/drawer/category/create_cateogry.dart';
import 'package:expenses_tracker_app/widgets/category/category_item.dart';
import 'package:flutter/material.dart';

class ExpandCategoryScreen extends StatefulWidget {
  const ExpandCategoryScreen({super.key, required this.listCategories, required this.isExpense});
  final List<Category> listCategories;
  final bool isExpense;

  @override
  State<ExpandCategoryScreen> createState() => _ExpandCategoryScreenState();
}

class _ExpandCategoryScreenState extends State<ExpandCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm danh mục'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          children: List.generate(
            widget.listCategories.length + 1,
            (index) {
              if (index < widget.listCategories.length) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (widget.listCategories[index].picked == false) {
                        if (widget.listCategories.indexWhere((e) => e.picked == true) >= 0) {
                          widget.listCategories[widget.listCategories.indexWhere((e) => e.picked == true)].picked = false;
                        }
                        widget.listCategories[index].picked = true;
                      }
                    });
                    Navigator.pop(context,widget.listCategories[index]);
                  },
                  child: CategoryItem(
                    category: widget.listCategories[index],
                    isAddCategory: false,
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () async {
                    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCategoryScreen(isExpense: widget.isExpense, category: null)));
                    if(result != null && context.mounted){
                      Navigator.pop(context,true);
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
}
