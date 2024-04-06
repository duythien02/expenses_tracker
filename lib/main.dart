import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/firebase_options.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/sceens/auth/auth.dart';
import 'package:expenses_tracker_app/sceens/home/home.dart';
import 'package:expenses_tracker_app/sceens/welcome/sync_data.dart';
import 'package:expenses_tracker_app/sceens/welcome/welcome1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(1, 187, 199, 198));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Expenses Tracker App',
      theme: ThemeData(
          colorScheme: kColorScheme,
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 177, 32, 1),
              foregroundColor: const Color.fromRGBO(255, 177, 32, 1),
              fixedSize: const Size(250, 45),
              disabledBackgroundColor: const Color.fromARGB(131, 255, 177, 32),
            ),
          ),
          datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: kColorScheme.primary,
              headerForegroundColor: kColorScheme.background),
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.primary,
            foregroundColor: kColorScheme.onPrimary,
          ),
          textTheme: ThemeData().textTheme.copyWith(
                titleLarge: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
                bodyMedium: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
          drawerTheme: const DrawerThemeData()
              .copyWith(backgroundColor: kColorScheme.primary)),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder(
                stream: FirebaseAPI.getAccount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SyncDataScreen();
                  }
                  if (snapshot.data!.docs.isNotEmpty) {
                    final data = snapshot.data!.docs;
                    List<Account> listAccount =
                        data.map((e) => Account.fromMap(e.data())).toList();
                    Account currentAccount = listAccount
                        .firstWhere((element) => element.isMain == true);
                    return StreamBuilder(
                        stream: FirebaseAPI.getGroupedExpensesStream(
                            currentAccount),
                        builder: (context, expense) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SyncDataScreen();
                          }
                          if (expense.hasData) {
                            return HomeScreen(
                              listAccount: listAccount,
                              currentAccount: currentAccount,
                              expenseData: expense.data!,
                            );
                          }
                          return const SyncDataScreen();
                        });
                  } else {
                    return const WelcomScreen1();
                  }
                });
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
