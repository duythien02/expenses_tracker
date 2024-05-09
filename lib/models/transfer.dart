class Transfer {
  late String transferID;
  late String fromAccountId;
  late String fromAccountName;
  String? toAccountId;
  String? toAccountName;
  late double amount;
  late String currencyLocal;
  late DateTime createdAt;
  String? note;
  late String type;

  Transfer({
    required this.transferID,
    required this.fromAccountId,
    required this.fromAccountName,
    required this.toAccountId,
    required this.toAccountName,
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
      toAccountId: map['toAccountId'],
      toAccountName: map['toAccountName'],
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
      'toAccountId': toAccountId,
      'toAccountName': toAccountName,
      'amout': amount,
      'currencyLocal': currencyLocal,
      'createAt': createdAt.microsecondsSinceEpoch,
      'note': note,
      'type': type,
    };
  }
}

enum TransferType { transfer, init, change }
