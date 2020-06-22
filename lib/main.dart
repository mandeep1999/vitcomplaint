import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitcomplaint/provider/firebase_work.dart';
import 'package:vitcomplaint/theme/themes.dart';
import 'screens/welcome_screen.dart';
import 'screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier(lightTheme)),
          ChangeNotifierProvider<FirebaseWork>(create: (_) => FirebaseWork()),
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeNotifier.getTheme(),
      home: _getLandingPage(),
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        Home.id : (context) => Home(),
      },
    );
  }
}
Widget _getLandingPage(){
  return StreamBuilder<FirebaseUser>(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData && (!snapshot.data.isAnonymous) && snapshot.data.isEmailVerified) {
        return Home();
      }
      return WelcomeScreen();
    },
  );
}