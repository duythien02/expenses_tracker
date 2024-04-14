class Category{
  late String categoryId;
  late String categoryName;
  late bool type;
  late String symbol;
  late int color;
  late bool picked;
  late DateTime createAt;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.type,
    required this.symbol,
    required this.color,
    this.picked = false,
    required this.createAt
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['categoryId'] as String,
      categoryName: map['categoryName'] as String,
      type: map['type'] as bool,
      symbol: map['symbol'] as String,
      color: map['color'] as int,
      picked: map['picked'] as bool,
      createAt: DateTime.fromMicrosecondsSinceEpoch(map['createAt'] as int),
    );
  }

  Map<String, dynamic> toMap(){
    return({
      "categoryId" : categoryId,
      "categoryName" : categoryName,
      "type" : type,
      "symbol" : symbol,
      "color" : color,
      "picked" : picked,
      "createAt" : createAt.microsecondsSinceEpoch
    });
  }
}