import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool editName = false;
  String name = 'Student name';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 75.0,
            width: double.infinity,
            padding: EdgeInsets.only(top: 10.0, left: 20.0),
            color: Theme.of(context).primaryColor,
            child: Text(
              'Profile',
              style: TextStyle(
                  fontSize: 30.0, color: Colors.white, fontFamily: 'Pacifico'),
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                  ),
                ),
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Student',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25.0,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Stack(
                          children: [
                            Card(
                                elevation: 15.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(82.0))),
                                child: CircleAvatar(
                                    radius: 82.0,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: CircleAvatar(
                                      radius: 80.0,
                                      backgroundImage: AssetImage(
                                          'assets/images/student.png'),
                                    ))),
                            Positioned(
                              top: 130.0,
                              left: 130.0,
                              child: FaIcon(FontAwesomeIcons.userEdit),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              editName == false
                                  ? Text(
                                      name,
                                      style: TextStyle(fontSize: 20.0),
                                    )
                                  : Container(
                                      width: 200.0,
                                      child: TextField(
                                        onChanged: (value) {
                                          name = value;
                                        },
                                        autofocus: true,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Write your name.'),
                                      ),
                                    ),
                              editName == false
                                  ? IconButton(
                                      icon: FaIcon(FontAwesomeIcons.edit),
                                      onPressed: () {
                                        setState(() {
                                          editName = true;
                                        });
                                      },
                                    )
                                  : IconButton(
                                      icon: FaIcon(FontAwesomeIcons.save),
                                      onPressed: () {
                                        setState(() {
                                          editName = false;
                                        });
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
