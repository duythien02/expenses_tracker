import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker_app/data/categories_data.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirebaseAPI{
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User? get user => firebaseAuth.currentUser;

  // static Future<bool> userExist() async {
  //   return (
  //     await firestore.collection('users').doc(user!.uid).get()
  //     ).exists;
  // }

  static Future<void> createNewUser (String userName, String email, String? image, String type) async {
    final newUser = UserModel(
      userId: user!.uid,
      userName: userName,
      email: email,
      image: image,
      type: type
    );
    return await firestore.collection('users').doc(user!.uid).set(newUser.toMap());
  }

  static Future<void> completeRegistration(String name, int balance, String curCode, String curName, String curSymbol, String symbol, int color) async {
    for(var category in defaultCategories){
      await firestore.collection('users').doc(user!.uid).collection('categories').doc(category.categoryId).set(category.toMap());
    }
    var uuid = const Uuid();
    final account = Account(
      accountId: uuid.v4(),
      accountName: name,
      accountBalance: balance,
      currencyCode: curCode,
      currencyName: curName,
      currencySymbol: curSymbol,
      symbol: symbol,
      color: color,
      isMain: true
    );
    return await firestore.collection('users').doc(user!.uid).collection('accounts').doc(uuid.v4()).set(account.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> isCompleteRegistor()  {
    return firestore.collection('users').doc(user!.uid).collection('accounts').snapshots();
  }
}