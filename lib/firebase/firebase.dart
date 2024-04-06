import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:expenses_tracker_app/data/categories_data.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/category.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirebaseAPI {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

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
      int balance,
      String curCode,
      String curName,
      String curSymbol,
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
    var uuid = const Uuid();
    final account = Account(
        accountId: uuid.v4(),
        accountName: name,
        accountBalance: balance,
        currencyCode: curCode,
        currencyName: curName,
        currencyLocale: curSymbol,
        symbol: symbol,
        color: color,
        isMain: true);
    return await firestore
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(account.accountId)
        .set(account.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAccount() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
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

  static Future<void> addExpense(int amount, Category category, DateTime date,
      String? note, Account account, bool isExpense) async {
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
        .doc(account.accountId)
        .collection('expenses')
        .doc(newExpense.expenseId)
        .set(newExpense.toMap())
        .whenComplete(
            () async => await calMoneyFromAccount(account, amount, isExpense));
  }

  static Future<void> calMoneyFromAccount(
      Account account, int amount, bool isExpense) async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(account.accountId)
        .get();
    int balance = documentSnapshot['accountBalance'];
    if (isExpense) {
      balance -= amount;
    } else {
      balance += amount;
    }

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection("accounts")
        .doc(account.accountId)
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
    List<Expense> listExpense = [];
    Map<String, List<Expense>> groupedExpenses = {};
    return getAllExpense(account).map((QuerySnapshot snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        listExpense.add(Expense.fromMap(doc.data() as Map<String, dynamic>));
        groupedExpenses = groupBy(listExpense, (expense) => expense.categoryId);
      }
      return groupedExpenses;
    });
  }

  static Future<void> createCategory(
      String categoryName, int color, String symbol, bool type) async {
    var uuid = const Uuid();
    final category = Category(
      categoryId: uuid.v4(),
      categoryName: categoryName,
      color: color,
      symbol: symbol,
      type: type ? Type.expense.name : Type.income.name ,
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .collection('categories')
        .doc(uuid.v4())
        .set(category.toMap());
  }
}
