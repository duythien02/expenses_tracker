import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:expenses_tracker_app/data/categories_data.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/category.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/models/message.dart';
import 'package:expenses_tracker_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uuid/uuid.dart';

class FirebaseAPI {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static User get user => firebaseAuth.currentUser!;

  static Future<void> createNewUser(
      String userName, String email, String? image) async {
    final newUser = UserModel(
      userId: user.uid,
      userName: userName,
      email: email,
      image: image,
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(newUser.toMap());
  }

  static Future<void> completeRegistration(
      String name,
      double balance,
      String curCode,
      String curName,
      String curLocale,
      String symbol,
      int color) async {
    for (var category in defaultCategories) {
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('categories')
          .doc(category.categoryId)
          .set(category.toMap());
    }
    return await setAccount(null,name, balance, curCode, curName, curLocale, symbol, color,true, true,null);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAccount() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .orderBy('createAt',descending: false)
        .snapshots();
  }

  static Future<UserModel> getInfoUser() async {
    DocumentSnapshot doc =
        await firestore.collection('users').doc(user.uid).get();
    UserModel curUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    return curUser;
  }

  static Future<List<Category>> getAllCategories() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('categories')
        .get();
    return querySnapshot.docs
        .map((e) => Category.fromMap(e.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<void> addExpense(double amount, Category category, DateTime date,
      String? note, String accountId, bool isExpense) async {
    var uuid = const Uuid();

    final newExpense = Expense(
        expenseId: uuid.v4(),
        amount: amount,
        date: date,
        note: note,
        type: category.type,
        categoryId: category.categoryId,
        categoryName: category.categoryName,
        color: category.color,
        symbol: category.symbol);

    return await firestore
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(accountId)
        .collection('expenses')
        .doc(newExpense.expenseId)
        .set(newExpense.toMap())
        .whenComplete(
            () async => await calMoneyFromAccount(accountId, amount, isExpense, false));
  }

  static Future<void> calMoneyFromAccount(
      String accountId, double amount, bool isExpense, bool isDeleteExpense) async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(accountId)
        .get();
    double balance = documentSnapshot['accountBalance'];
    if(isDeleteExpense){
      if (isExpense) {
        balance += amount;
      } else {
        balance -= amount;
      }
    }else{
      if (isExpense) {
        balance -= amount;
      } else {
        balance += amount;
      }
    }
  
    balance = double.parse(balance.toStringAsFixed(2));
    return await firestore
        .collection('users')
        .doc(user.uid)
        .collection("accounts")
        .doc(accountId)
        .update({'accountBalance': balance});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllExpense(
      Account account) {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(account.accountId)
        .collection('expenses')
        .snapshots();
  }

  static Stream<Map<dynamic, List<Expense>>> getGroupedExpensesStream(
      Account account) {
    return getAllExpense(account).map((QuerySnapshot snapshot) {
      List<Expense> listExpense = [];
      Map<String, List<Expense>> groupedExpenses = {};
      for (DocumentSnapshot doc in snapshot.docs) {
        listExpense.add(Expense.fromMap(doc.data() as Map<String, dynamic>));
        groupedExpenses = groupBy(listExpense, (expense) => expense.categoryId);
      }
      return groupedExpenses;
    });
  }

  static Future<void> setCategory(String? categoryId, String categoryName, int color, String symbol, bool type, DateTime? createAt) async {
    var uuid = const Uuid();
    final category = Category(
      categoryId: categoryId ?? uuid.v4(),
      categoryName: categoryName,
      color: color,
      symbol: symbol,
      type: type,
      createAt: createAt ?? DateTime.now()
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .collection('categories')
        .doc(category.categoryId)
        .set(category.toMap());
  }

  static Future<void> updateBalance(double newBalance, String accountId) async{
    return await firestore
      .collection('users')
      .doc(user.uid)
      .collection('accounts')
      .doc(accountId)
      .update({"accountBalance": newBalance});
  }

  static Future<void> updateActiveAccount(String accountId, bool isActive) async{
    return  await firestore
      .collection('users')
      .doc(user.uid)
      .collection('accounts')
      .doc(accountId)
      .update({'isActive': isActive});
  }
  static Future<void> deleteExpense(String expenseId, String accountId, bool isExpense, double amount) async{
    return await firestore
      .collection('users')
      .doc(user.uid)
      .collection('accounts')
      .doc(accountId)
      .collection('expenses')
      .doc(expenseId)
      .delete().whenComplete(() async => await calMoneyFromAccount(accountId, amount, isExpense, true));
  }
  static Future<Category> getCategory(String categoryId) async{
    DocumentSnapshot doc = await firestore
      .collection('users')
      .doc(user.uid)
      .collection('categories')
      .doc(categoryId)
      .get();
    Category category = Category.fromMap(doc.data() as Map<String, dynamic>);
    return category;
  }

  static Future<void> editExpense(String expenseId,double newAmount, double oldAmount, Category category, DateTime date,
      String? note, String accountId, bool isExpense, bool isChangeTypeExpense) async{
    final newExpense = Expense(
        expenseId: expenseId,
        amount: newAmount,
        date: date,
        note: note,
        type: category.type,
        categoryId: category.categoryId,
        categoryName: category.categoryName,
        color: category.color,
        symbol: category.symbol);
    return await firestore
      .collection('users')
      .doc(user.uid)
      .collection('accounts')
      .doc(accountId)
      .collection('expenses')
      .doc(expenseId)
      .set(newExpense.toMap())
      .whenComplete(() async => await calMoneyFromAccount(
        accountId,
        isChangeTypeExpense 
          ? newAmount + oldAmount 
          : newAmount - oldAmount,
        isExpense, false));
  }

  static Future<void> sendTextInChat(String text, String from,) async{
    var uuid = const Uuid();
    final ChatMessage message = ChatMessage(
      messageId: uuid.v4(),
      text: text,
      from: from,
      createAt: DateTime.now(),
    );
    return await firestore
      .collection('users')
      .doc(user.uid)
      .collection('chat_messages')
      .doc(message.messageId)
      .set(message.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getTextInChat() {
    return firestore.collection('users').doc(user.uid).collection('chat_messages').orderBy('createAt',descending: true).snapshots();
  }

  static Future<List<Account>> getListAccount() async{
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('accounts').orderBy('createAt', descending: false)
        .get();
    return querySnapshot.docs
        .map((e) => Account.fromMap(e.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<Account> getMainAccount() async{
    QuerySnapshot querySnapshot = await firestore.collection('users').doc(user.uid).collection('accounts').get();
    late Account account;
    for(var doc in querySnapshot.docs){
      if (doc['isMain'] == true){
        account = Account.fromMap(doc.data() as Map<String,dynamic>);
      }
    }
    return account;
  }

  static Future<void> setAccount(String? accountId, String name,double balance,String curCode,String curName,String curLocale,String symbol,int color, bool? isMain, bool? isActive, DateTime? createAt) async{
    var uuid = const Uuid();
    final account = Account(
        accountId: accountId ?? uuid.v4(),
        accountName: name,
        accountBalance: balance,
        currencyCode: curCode,
        currencyName: curName,
        currencyLocale: curLocale,
        symbol: symbol,
        color: color,
        isMain: isMain ?? false,
        isActive: isActive ?? false,
        createAt: createAt ?? DateTime.now());
    return await firestore
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(account.accountId)
        .set(account.toMap());
  }

  static Future<void> deleteAccount(String accountId) async{
    return await firestore
      .collection('users')
      .doc(user.uid)
      .collection('accounts')
      .doc(accountId)
      .delete();
  }
}
