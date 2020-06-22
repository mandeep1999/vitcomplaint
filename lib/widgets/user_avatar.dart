import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String imageURL;
  UserAvatar({this.imageURL});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(42.0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(42.0)),
        child: FadeInImage.assetNetwork(
          placeholderScale: 10.8,
          imageScale: 3.0,
          placeholder: 'assets/images/student.png',
          image: imageURL,
        ),
      ),
    );
  }
}
