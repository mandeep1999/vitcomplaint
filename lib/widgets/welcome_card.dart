import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class WelcomeCard extends StatelessWidget {
  const WelcomeCard({
    Key key,
    @required this.value,this.type,
  }) : super(key: key);

  final bool value;
  final int type;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: value == true ? 6.0 : 3.0,
        child: Column(
          children: [
            Stack(
              overflow: Overflow.visible,
              children: [
                Image.asset(
                  type == 1 ?'assets/images/warden.png' : 'assets/images/student.png',
                  height: 150.0,
                ),
                value == true
                    ? Positioned(
                  bottom: -50,
                  right: -10,
                  child: FaIcon(
                    FontAwesomeIcons.checkCircle,
                    color: Colors.green,
                  ),
                )
                    : Container(
                  height: 0,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                type == 1 ? 'Warden' : 'Student',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ));
  }
}