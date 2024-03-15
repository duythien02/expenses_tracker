import 'package:expenses_tracker_app/models/category.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.category});
  final Category? category;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 4,
      width: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: category != null
              ? category!.picked
                  ? Color(category!.color)
                  : Colors.white
              : Colors.white
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
                      category != null ? Color(category!.color) : Colors.grey),
              child: Icon(
                category != null
                    ? IconData(int.parse(category!.symbol),
                        fontFamily: "AppIcons")
                    : Icons.add,
                size: MediaQuery.of(context).size.width / 11,
                color: Colors.white,
              )),
          category != null
              ? Text(
                  category!.categoryName,
                  style: TextStyle(color: category!.picked ? Colors.white : Colors.black),
                )
              : const Text(
                  'Xem thêm',
                  style: TextStyle(color: Colors.black),
                )
        ],
      ),
    );
  }
}
