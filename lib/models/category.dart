enum Type {income, expense}

class Category{
  late String categoryId;
  late String categoryName;
  late String type;
  late String symbol;
  late int color;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.type,
    required this.symbol,
    required this.color
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['categoryId'] as String,
      categoryName: map['categoryName'] as String,
      type: map['type'] as String,
      symbol: map['symbol'] as String,
      color: map['color'] as int,
    );
  }

  Map<String, dynamic> toMap(){
    return({
      "categoryId" : categoryId,
      "categoryName" : categoryName,
      "type" : type,
      "symbol" : symbol,
      "color" : color
    });
  }
}