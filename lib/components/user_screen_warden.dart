import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitcomplaint/provider/firebase_work.dart';
import 'package:vitcomplaint/widgets/user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserScreenWarden extends StatefulWidget {
  @override
  _UserScreenWardenState createState() => _UserScreenWardenState();
}
String search = '';
List<UserCard> messageBubbles = [];
class _UserScreenWardenState extends State<UserScreenWarden> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    search = '';
    messageBubbles = [];
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 75.0,
            width: double.infinity,
            padding: EdgeInsets.only(top: 10.0, left: 10.0),
            color: Theme.of(context).primaryColor,
            child: ListTile(
              leading: Text(
                'Search',
                style: TextStyle(
                    fontSize: 30.0, color: Colors.white, fontFamily: 'Pacifico'),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Container(
                padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Search students.',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextField(
                      onChanged: (value){
                        setState(() {
                          search = value;
                          messageBubbles = [];
                        });

                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search here',
                        border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Expanded(
                      child: UserStream(),
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

class UserStream extends StatelessWidget {
  final _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('profiles').snapshots(),
      builder: (context, snapshot) {
        List<UserCard> messageBubbles = [];
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
          final bool  warden = message.data['warden'];
          final String room = message.data['room'];
          final id = message.documentID;
          final currentUser = Provider.of<FirebaseWork>(context).uid;
          if(name != null && name != ''){
            if (currentUser == id){
            } else{
              bool searchBool = search != '' ? true : false;
              if(searchBool == true
                  ? name.toLowerCase().startsWith(search.toLowerCase())
                  : true){
                final messageBubble = UserCard(
                  imageURL : imageURL,
                  name: name,
                  block: block,
                  id: id,
                  room : room,
                  warden : warden,
                );
                messageBubbles.add(messageBubble);
              }}}
        }
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          children: messageBubbles.isEmpty
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
              child: Image.asset('assets/images/nothing.jpg'),
            ),
          ]
              : messageBubbles,
        );
      },
    );
  }
}

