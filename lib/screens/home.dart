import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vitcomplaint/components/user_screen.dart';
import 'package:vitcomplaint/components/home_screen.dart';
import 'package:vitcomplaint/components/profile_screen.dart';
import 'package:vitcomplaint/provider/firebase_work.dart';

class Home extends StatefulWidget {
  static final String id = 'home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;
  static List<Widget> _widgetOptions = <Widget>[
    UserScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<FirebaseWork>(context,listen: false).getUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user),
              title: Text('Profile'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).iconTheme.color,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

//_widgetOptions.elementAt(_selectedIndex),
