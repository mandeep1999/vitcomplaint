import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitcomplaint/widgets/welcome_card.dart';
class WelcomeScreen extends StatefulWidget {
  static final String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  AnimationController controller;
  void startAnimation(){
  controller = AnimationController(
  duration: Duration(milliseconds: 400),
  vsync: this,
    value: 1.0,
  );
  controller.reverse();
  controller.addListener(() {
  setState(() {});
  });}
  bool warden, student,details,newLogin = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    warden = false;
    student = false;
    details = false;
  }

  void enableCard(val) {
    setState(() {
      if (val == 1) {
        warden = true;
        student = false;
        details = true;
      } else {
        warden = false;
        student = true;
        details = true;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  SizedBox(height: (warden == false && student == false) ? 50.0 : 10.0,),
                  Image.asset('assets/images/vit.png',height: (warden == false && student == false) ? 250.0 : 250.0 * controller.value,),
                  SizedBox(
                    height: (warden == false && student == false) ? 100.0 : 100.0 * controller.value,
                  ),
                  SizedBox(height: 20.0,),
                  Text('Choose an account type',style: TextStyle(fontSize: 20.0),),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if(warden == false && student == false){startAnimation(); }
                            enableCard(1);
                          },
                          child: WelcomeCard(value: warden,type: 1),
                        ),
                        GestureDetector(
                          onTap: () {
                            if(warden == false && student == false){startAnimation();}
                            enableCard(2);
                                               },
                          child: WelcomeCard(value: student,type: 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100.0,),
                  Text(newLogin == true ? 'Sign Up' : 'Login',style: TextStyle(fontSize: 20.0),),
                  SizedBox(height: 15.0,),
                  details == true && warden == true ? TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Warden secret code',
                      suffixIcon: Icon(Icons.remove_red_eye),
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey),borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ) : Container(height: 0,),
                  details == true && warden == true ? SizedBox(height: 15.0,) : Container(height: 0,),
                  details == true ? TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: warden == true? 'Email ID' :'VIT Email ID',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ) : Container(height: 0,),
                  SizedBox(height: 15.0,),
                  details == true ? TextField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: Icon(Icons.remove_red_eye),
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ) : Container(height: 0,),
                  SizedBox(height: 15.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(onTap: (){
                        setState(() {
                          newLogin = !newLogin;
                        });
                      },child: Text(newLogin == false ? 'New to our app? ' : 'Go back to Login.',style: TextStyle(fontSize: 15.0),)),
                      Text('Forget password',style: TextStyle(fontSize: 15.0,),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


