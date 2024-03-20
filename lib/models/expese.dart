class Expense{
  late String expenseId;
  late String categoryId;
  late int amount;
  late DateTime date;
  late String categoryName;
  late String type;
  late String symbol;
  late int color;
  String? note;

  Expense({
    required this.expenseId,
    required this.categoryId,
    required this.amount,
    required this.date,
    required this.categoryName,
    required this.type,
    required this.symbol,
    required this.color,
    this.note,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      expenseId: map['expenseId'] as String,
      categoryId: map['categoryId'] as String,
      amount: map['amount'] as int,
      date: DateTime.fromMicrosecondsSinceEpoch(map['date'] as int),
      categoryName: map['categoryName'] as String,
      type: map['type'] as String,
      symbol: map['symbol'] as String,
      color: map['color'] as int,
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'expenseId': expenseId,
      'categoryId': categoryId,
      'amount': amount,
      'date': date.microsecondsSinceEpoch,
      'categoryName': categoryName,
      'type': type,
      'symbol': symbol,
      'color': color,
      'note': note,
    };
  }
}
