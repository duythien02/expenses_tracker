import 'package:expenses_tracker_app/models/category.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.category, required this.isAddCategory});
  final Category? category;
  final bool isAddCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: category != null
              ? category!.picked
                  ? Color(category!.color)
                  : null
              : null
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: MediaQuery.of(context).size.width / 7,
              width: MediaQuery.of(context).size.width / 7,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      category != null ? Color(category!.color) : !isAddCategory ? Colors.orange : Colors.grey),
              child: Icon(
                category != null
                    ? IconData(int.parse(category!.symbol),
                        fontFamily: "MyIcon")
                    : Icons.add,
                size: MediaQuery.of(context).size.width / 11,
                color: Colors.white,
              )),
          category != null
              ? Text(
                  category!.categoryName,
                  style: TextStyle(color: category!.picked ? Colors.white : Colors.black,),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                )
              : !isAddCategory ? const Text(
                  'Tạo',
                  style: TextStyle(color: Colors.black),
                ) : const Text(
                  'Xem thêm',
                  style: TextStyle(color: Colors.black),
                )
        ],
      ),
    );
  }
}
