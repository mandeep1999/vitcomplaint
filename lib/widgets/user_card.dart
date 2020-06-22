import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'user_avatar.dart';

class UserCard extends StatelessWidget {
  final String imageURL, name, block;
  UserCard(
      {@required this.imageURL, @required this.block, @required this.name});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              UserAvatar(imageURL: imageURL),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22.0),
                    ),
                    Text(
                      block + ' block',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.plus,
                    color: Colors.white,
                    size: 18.0,
                  ),
                )
              ],
            ),
            height: 40.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(9.0),
                  bottomRight: Radius.circular(9.0)),
            ),
          ),
        ],
      ),
    );
  }
}
