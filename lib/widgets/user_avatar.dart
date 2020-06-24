import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String imageURL;
  UserAvatar({this.imageURL});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
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
        borderRadius: BorderRadius.all(Radius.circular(45.0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(45.0)),
        child: FadeInImage.assetNetwork(
          placeholderScale: 10.8,
          imageCacheHeight: 85,
          imageCacheWidth: 85,
          placeholder: 'assets/images/student.png',
          image: imageURL != null
              ? imageURL
              : 'https://source.unsplash.com/1600x900/daily/?nature,water,sun',
        ),
      ),
    );
  }
}
