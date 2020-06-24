import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:vitcomplaint/provider/firebase_work.dart';
import 'package:vitcomplaint/screens/home.dart';
import 'package:vitcomplaint/screens/home_warden.dart';

class LoadingScreen extends StatefulWidget {
  static final String id = 'loading_screen';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiate();
  }

  Future<void> initiate() async {
    await Provider.of<FirebaseWork>(context, listen: false).getUser();
    if (Provider.of<FirebaseWork>(context, listen: false).uid != null) {
      await Provider.of<FirebaseWork>(context, listen: false).getProfile();
      await Provider.of<FirebaseWork>(context, listen: false).getRoommates();
      if (Provider.of<FirebaseWork>(context, listen: false).warden == true) {
        Navigator.pushNamedAndRemoveUntil(context, HomeWarden.id, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: TyperAnimatedTextKit(
                onTap: () {
                  print("Tap Event");
                },
                text: [
                  'Loading....',
                ],
                textStyle: TextStyle(fontSize: 35.0, fontFamily: "Pacifico"),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                ),
          ),
        ),
      ),
    );
  }
}
