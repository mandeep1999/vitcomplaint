import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:vitcomplaint/widgets/request_card.dart';
import 'package:vitcomplaint/provider/firebase_work.dart';

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            Text(
              'Requests',
              style: TextStyle(fontSize: 25.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 400.0,
              child:  UserStream(),

            ),
          ],
        ),
      ),
    );
  }
}

class UserStream extends StatelessWidget {
  final _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('requests').snapshots(),
      builder: (context, snapshot) {
        List<RequestCard> requestBubbles = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
        final messages = snapshot.data.documents;
        for (var message in messages) {
          final block = message.data['block'];
          final name = message.data['name'];
          final imageURL = message.data['url'];
          final senderID = message.data['senderID'];
          final receiverID = message.data['receiverID'];
          if (receiverID != null && senderID != null) {
            if (receiverID == Provider.of<FirebaseWork>(context).uid) {

              final requestBubble = RequestCard(
                imageURL: imageURL,
                name: name,
                block: block,
                senderID: senderID,
                receiverID : receiverID,
              );
              requestBubbles.add(requestBubble);
          }}
        }
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          children: requestBubbles.isEmpty
              ? <Widget>[
                  Center(
                      child: Text(
                    'Nothing here yet.',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: 40.0,
                  ),
                  Center(
                    child: Image.asset('assets/images/nothing.jpg',height: 300.0,),
                  ),
                ]
              : requestBubbles,
        );
      },
    );
  }
}
