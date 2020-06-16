import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitcomplaint/theme/themes.dart';
import 'screens/welcome_screen.dart';
void main() {
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(create: (context) => ThemeNotifier(lightTheme),child: MyApp(),),
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
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
      },
    );
  }
}