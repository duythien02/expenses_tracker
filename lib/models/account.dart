class Account{
  late String accountId;
  late String accountName;
  late double accountBalance;
  late String currencyCode;
  late String currencyName;
  late String currencyLocale;
  late String symbol;
  late int color;
  late bool isMain;
  late bool isActive;
  late DateTime createAt;

  Account({
    required this.accountId,
    required this.accountName,
    required this.accountBalance,
    required this.currencyCode,
    required this.currencyName,
    required this.currencyLocale,
    required this.symbol,
    required this.color,
    required this.isMain,
    required this.isActive,
    required this.createAt
  });

  Map<String, dynamic> toMap() {
    return {
      'accountId' : accountId,
      'accountName': accountName,
      'accountBalance': accountBalance,
      'currencyCode': currencyCode,
      'currencyName': currencyName,
      'currencyLocale': currencyLocale,
      'symbol': symbol,
      'color': color,
      'isMain': isMain,
      'isActive': isActive,
      'createAt': createAt.microsecondsSinceEpoch
    };
  }
  
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      accountId: map['accountId'] as String,
      accountName: map['accountName'] as String,
      accountBalance: map['accountBalance'] as double,
      currencyCode: map['currencyCode'] as String,
      currencyName: map['currencyName'] as String,
      currencyLocale: map['currencyLocale'] as String,
      symbol: map['symbol'] as String,
      color: map['color'] as int,
      isMain: map['isMain'],
      isActive: map['isActive'],
      createAt: DateTime.fromMicrosecondsSinceEpoch(map['createAt'] as int),
    );
  }
}