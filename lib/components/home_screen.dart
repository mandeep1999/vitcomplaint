import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vitcomplaint/provider/firebase_work.dart';
import 'package:vitcomplaint/screens/add_screen.dart';
import 'package:vitcomplaint/widgets/user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
String search = '';
List<UserCard> messageBubbles = [];
class _HomeScreenState extends State<HomeScreen> {

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
                'Home',
                style: TextStyle(
                    fontSize: 30.0, color: Colors.white, fontFamily: 'Pacifico'),
              ),
              trailing: IconButton(icon: FaIcon( FontAwesomeIcons.plus,color: Colors.white,size: 20.0,),onPressed: (){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: AddScreen(),
                        )));
              },),
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
                      'Search your complaint.',
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

