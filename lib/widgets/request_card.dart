import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitcomplaint/provider/firebase_work.dart';
import 'user_avatar.dart';
import 'package:provider/provider.dart';

class RequestCard extends StatefulWidget {
  final String imageURL, name, block, senderID, receiverID;
  RequestCard(
      {@required this.imageURL,
      @required this.block,
      @required this.name,
      @required this.senderID,
      @required this.receiverID});

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
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
              UserAvatar(imageURL: widget.imageURL),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      widget.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22.0),
                    ),
                    Text(
                      widget.block + ' block',
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
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      Provider.of<FirebaseWork>(context, listen: false)
                          .acceptRequest(widget.senderID, widget.receiverID);
                    },
                    child: Text(
                      'Accept',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      Provider.of<FirebaseWork>(context, listen: false)
                          .rejectRequest(widget.senderID, widget.receiverID);
                    },
                    child: Text(
                      'Reject',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
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
