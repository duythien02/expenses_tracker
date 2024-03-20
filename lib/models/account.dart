class Account{
  late String accountId;
  late String accountName;
  late int accountBalance;
  late String currencyCode;
  late String currencyName;
  late String currencyLocale;
  late String symbol;
  late int color;
  late bool isMain;

  Account({
    required this.accountId,
    required this.accountName,
    required this.accountBalance,
    required this.currencyCode,
    required this.currencyName,
    required this.currencyLocale,
    required this.symbol,
    required this.color,
    required this.isMain
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
      'isMain': isMain
    };
  }
  
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      accountId: map['accountId'] as String,
      accountName: map['accountName'] as String,
      accountBalance: map['accountBalance'] as int,
      currencyCode: map['currencyCode'] as String,
      currencyName: map['currencyName'] as String,
      currencyLocale: map['currencyLocale'] as String,
      symbol: map['symbol'] as String,
      color: map['color'] as int,
      isMain: map['isMain']
    );
  }
}