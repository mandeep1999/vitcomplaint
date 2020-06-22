import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'user_avatar.dart';

class UserCard extends StatelessWidget {
  final String imageURL;
  UserCard({this.imageURL});
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
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          UserAvatar(imageURL: imageURL),
        ],
      ),
    );
  }
}

