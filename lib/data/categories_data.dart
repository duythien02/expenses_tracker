import 'package:expenses_tracker_app/models/category.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

List<Category> defaultCategories = [
  Category(
    categoryId: uuid.v4(),
    categoryName: "Sức khoẻ",
    type: Type.expense.name,
    symbol: "0xe800",
    color: 4294198070
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Giải trí",
    type: Type.expense.name,
    symbol: "0xe802",
    color: 4283215696
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Ăn uống",
    type: Type.expense.name,
    symbol: "0xe804",
    color: 4294961979
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Mua sắm",
    type: Type.expense.name,
    symbol: "0xe803",
    color: 4278238420
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Gia đình",
    type: Type.expense.name,
    symbol: "0xe805",
    color: 4293467747
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Lương",
    type: Type.expense.name,
    symbol: "0xe806",
    color: 4283215696
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Quà Tặng",
    type: Type.expense.name,
    symbol: "0xe807",
    color: 4294198070
  ),
];
