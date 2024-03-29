import 'package:flutter/material.dart';

final darkTheme = ThemeData.dark().copyWith(primaryColor: Colors.black, textTheme: TextTheme(bodyText2: TextStyle(color: Colors.grey)),buttonTheme: ButtonThemeData(buttonColor: Colors.black));

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.indigo,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  textTheme: TextTheme(bodyText2: TextStyle(color: Colors.indigo)),
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.red),
  iconTheme: IconThemeData(color: Color(0xff3e51b5)),
  primaryIconTheme: IconThemeData(color: Colors.red),
  dividerColor: Colors.white54,
);

class ThemeNotifier with ChangeNotifier{
  ThemeData _themeData;
  ThemeNotifier(this._themeData);
  getTheme() => _themeData;
  setTheme(ThemeData themeData)async{
    _themeData = themeData;
    notifyListeners();
  }
}