import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/firebase_options.dart';
import 'package:expenses_tracker_app/sceens/auth/auth.dart';
import 'package:expenses_tracker_app/sceens/home/home.dart';
import 'package:expenses_tracker_app/sceens/welcome/sync_data.dart';
import 'package:expenses_tracker_app/sceens/welcome/welcome1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(1, 104, 252, 208));

void main() async{
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
      debugShowCheckedModeBanner: false,
      title: 'Expenses Tracker App',
      theme: ThemeData(
        colorScheme: kColorScheme,
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
            foregroundColor: kColorScheme.onPrimaryContainer,
          ),
        ),
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.primary,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: kColorScheme.onSecondaryContainer,
          ),
        ),
      ),
      
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return StreamBuilder(
              stream: FirebaseAPI.isCompleteRegistor(),
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const SyncDataScreen();
                }
                if(snapshot.hasData){
                  return const HomeScreen();
                }
                return const WelcomScreen1();
              }
            );
          }
          return const AuthScreen();
        },
      ),
    );
  }
}

