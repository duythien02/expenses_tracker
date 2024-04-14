import 'package:expenses_tracker_app/models/category.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

List<Category> defaultCategories = [
  Category(
    categoryId: uuid.v4(),
    categoryName: "Sức khoẻ",
    type: true,
    symbol: "0xe800",
    color: 4294198070,
    createAt: DateTime.now()
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Giải trí",
    type: true,
    symbol: "0xe802",
    color: 4283215696,
    createAt: DateTime.now()
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Ăn uống",
    type: true,
    symbol: "0xe804",
    color: 4294961979,
    createAt: DateTime.now()
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Mua sắm",
    type: true,
    symbol: "0xe803",
    color: 4278238420,
    createAt: DateTime.now()
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Gia đình",
    type: true,
    symbol: "0xe805",
    color: 4293467747,
    createAt: DateTime.now()
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Lương",
    type: false,
    symbol: "0xe806",
    color: 4283215696,
    createAt: DateTime.now()
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Quà Tặng",
    type: false,
    symbol: "0xe807",
    color: 4294198070,
    createAt: DateTime.now()
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Đầu tư",
    type: false,
    symbol: "0xe809",
    color: 4278238420,
    createAt: DateTime.now()
  ),
  Category(
    categoryId: uuid.v4(),
    categoryName: "Kinh doanh",
    type: false,
    symbol: "0xe80a",
    color: 4293467747,
    createAt: DateTime.now()
  ),
];
