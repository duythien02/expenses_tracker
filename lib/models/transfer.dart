class Transfer {
  late String transferID;
  late String fromAccountId;
  late String fromAccountName;
  late String fromAccountSymbol;
  late int fromAccountColor;
  String? toAccountId;
  String? toAccountName;
  String? toAccountSymbol;
  int? toAccountColor;
  late double amount;
  late String currencyLocal;
  late DateTime createdAt;
  String? note;
  late String type;

  Transfer({
    required this.transferID,
    required this.fromAccountId,
    required this.fromAccountName,
    required this.fromAccountSymbol,
    required this.fromAccountColor,
    required this.toAccountId,
    required this.toAccountName,
    required this.toAccountSymbol,
    required this.toAccountColor,
    required this.amount,
    required this.currencyLocal,
    required this.createdAt,
    required this.note,
    required this.type,
  });

  factory Transfer.fromMap(Map<String, dynamic> map) {
    return Transfer(
      transferID: map['transferID'] as String,
      fromAccountId: map['fromAccountId'] as String,
      fromAccountName: map['fromAccountName'] as String,
      fromAccountSymbol: map['fromAccountSymbol'] as String,
      fromAccountColor: map['fromAccountColor'] as int,
      toAccountId: map['toAccountId'],
      toAccountName: map['toAccountName'],
      toAccountSymbol: map['toAccountSymbol'],
      toAccountColor: map['toAccountColor'],
      amount: map['amout'] as double,
      currencyLocal: map['currencyLocal'] as String,
      createdAt: DateTime.fromMicrosecondsSinceEpoch(map['createAt'] as int),
      note: map['note'],
      type: map['type'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transferID': transferID,
      'fromAccountId': fromAccountId,
      'fromAccountName': fromAccountName,
      'fromAccountSymbol': fromAccountSymbol,
      'fromAccountColor': fromAccountColor,
      'toAccountId': toAccountId,
      'toAccountName': toAccountName,
      'toAccountSymbol': toAccountSymbol,
      'toAccountColor': toAccountColor,
      'amout': amount,
      'currencyLocal': currencyLocal,
      'createAt': createdAt.microsecondsSinceEpoch,
      'note': note,
      'type': type,
    };
  }
}

enum TransferType { transfer, init, change }
