import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitcomplaint/widgets/welcome_card.dart';
import 'package:vitcomplaint/widgets/rounded_button.dart';
import 'package:vitcomplaint/auth/auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static final String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  Auth auth = new Auth();
  String email;
  String password;
  String errorMessage;
  bool obscureCode = true,
      obscurePassword = true,
      invalidEmail = false,
      loading = false;
  String secretCode = 'randompassword';
  TextEditingController textEditingControllerEmail =
      new TextEditingController();
  TextEditingController textEditingControllerPassword =
      new TextEditingController();
  AnimationController controller;
  void startAnimation() {
    controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
      value: 1.0,
    );
    controller.reverse();
    controller.addListener(() {
      setState(() {});
    });
  }

  void showError(String errorMessage) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  'Alert !!!',
                  style: TextStyle(color: Colors.red),
                ),
                content: TyperAnimatedTextKit(
                    speed: Duration(milliseconds: 100),
                    onTap: () {
                      print("Tap Event");
                    },
                    text: [
                      errorMessage,
                    ],
                    textStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 18.0,
                      fontFamily: 'Pacifico',
                    ),
                    textAlign: TextAlign.start,
                    alignment:
                        AlignmentDirectional.topStart // or Alignment.topLeft
                    ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return;
        });
  }

  bool warden, student, details, newLogin = false;
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
        textEditingControllerEmail.clear();
        textEditingControllerPassword.clear();
      } else {
        warden = false;
        student = true;
        details = true;
        textEditingControllerEmail.clear();
        textEditingControllerPassword.clear();
      }
    });
  }

  void validateEmail() {
    if (email != null) {
      String domain = email.substring(email.indexOf('@') + 1);
      if (domain.toLowerCase() == 'vitstudent.ac.in' ||
          domain.toLowerCase() == 'vit.ac.in') {
        setState(() {
          invalidEmail = false;
        });
      } else {
        setState(() {
          invalidEmail = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: (warden == false && student == false) ? 50.0 : 10.0,
                  ),
                  Image.asset(
                    'assets/images/vit.png',
                    height: (warden == false && student == false)
                        ? 250.0
                        : 250.0 * controller.value,
                  ),
                  SizedBox(
                    height: (warden == false && student == false)
                        ? 100.0
                        : 100.0 * controller.value,
                  ),
                  Text(
                    'Choose an account type',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (warden == false && student == false) {
                              startAnimation();
                            }
                            enableCard(1);
                          },
                          child: WelcomeCard(value: warden, type: 1),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (warden == false && student == false) {
                              startAnimation();
                            }
                            enableCard(2);
                          },
                          child: WelcomeCard(value: student, type: 2),
                        ),
                      ],
                    ),
                  ),
                  details == true
                      ? Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 125.0,
                              ),
                              Text(
                                newLogin == true ? 'Sign Up' : 'Login',
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.blue),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextField(
                                onChanged: (value) {
                                  email = value;
                                  validateEmail();
                                },
                                controller: textEditingControllerEmail,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: warden == true
                                      ? 'Email ID'
                                      : 'VIT Email ID',
                                  prefixIcon: Icon(Icons.email),
                                  suffixIcon: Icon(
                                    Icons.error,
                                    color: invalidEmail == true
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextField(
                                controller: textEditingControllerPassword,
                                onChanged: (value) {
                                  password = value;
                                },
                                obscureText: obscurePassword,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                        });
                                      },
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        color: obscurePassword == true
                                            ? Colors.blue
                                            : Colors.green,
                                      )),
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              loading == false
                                  ? RoundedButton(
                                      title: newLogin == true
                                          ? 'Sign up'
                                          : 'Login',
                                      colour: Colors.blue,
                                      onPressed: invalidEmail == false
                                          ? () async {
                                              if (email != null &&
                                                  password != null) {
                                                setState(() {
                                                  loading = true;
                                                });
                                                if (newLogin == true) {
                                                  errorMessage =
                                                      await auth.signUp(email,
                                                          password, warden);

                                                  if (auth.errorMessage !=
                                                      null) {
                                                    print(
                                                        'welcome screen sign up');
                                                    showError(errorMessage);
                                                  } else {
                                                    showError(
                                                        'Verify your email id.');
                                                  }
                                                } else if (newLogin == false) {
                                                  errorMessage =
                                                      await auth.signIn(email,
                                                          password, warden);

                                                  if (auth.errorMessage !=
                                                      null) {
                                                    print(
                                                        'welcome screen sign in');
                                                    showError(errorMessage);
                                                  }
                                                }
                                                setState(() {
                                                  loading = false;
                                                });
                                              } else {
                                                setState(() {
                                                  loading = false;
                                                  showError(
                                                      'Please provide email id and password.');
                                                });
                                              }
                                            }
                                          : () {
                                              showError('Invalid email.');
                                            },
                                    )
                                  : RoundedButton(
                                      title: 'Loading...',
                                      onPressed: () {},
                                      colour: Colors.blue,
                                    ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          newLogin = !newLogin;
                                          textEditingControllerPassword.clear();
                                          textEditingControllerEmail.clear();
                                        });
                                      },
                                      child: Text(
                                        newLogin == false
                                            ? 'New to our app? '
                                            : 'Go back to Login.',
                                        style: TextStyle(fontSize: 15.0),
                                      )),
                                  GestureDetector(
                                      onTap: () {
                                        if (email != null && email != '') {
                                          auth.resetPassword(email);
                                        } else {}
                                      },
                                      child: Text(
                                        'Forgot password?',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 0,
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
