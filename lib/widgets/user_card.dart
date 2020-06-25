import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vitcomplaint/provider/firebase_work.dart';
import 'user_avatar.dart';
import 'package:provider/provider.dart';

class UserCard extends StatefulWidget {

  final String imageURL, name, block, id, room;
  final bool warden,friend;
  UserCard(
      {@required this.imageURL, @required this.block, @required this.name, @required this.id, @required this.warden, @required this.room, @required this.friend});

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {

  bool loading = false,sent = false;
  @override
  Widget build(BuildContext context) {

    return
      GestureDetector(
        onLongPress: ()async{
          await Provider.of<FirebaseWork>(context,listen: false).deleteRoommate(widget.id);
        },
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom : 15.0),
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
                      UserAvatar(imageURL: widget.imageURL,warden: widget.warden,),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              widget.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22.0),
                            ),
                            SizedBox(height: 5.0,),
                            Text(
                              widget.block + (widget.room != null ? ( ' - ' + widget.room) : '') ,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  (Provider.of<FirebaseWork>(context).warden != true && widget.friend == false) ? Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sent == false ? 'Add' : 'Sent',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        loading == false ? IconButton(
                          onPressed: sent == false ? ()async{
                            setState(() {
                              loading = true;
                            });
                            await Provider.of<FirebaseWork>(context,listen: false).sendRequest(Provider.of<FirebaseWork>(context,listen: false).uid, widget.id, Provider.of<FirebaseWork>(context).userName, widget.block);
                            setState(() {
                              loading = false;
                              sent = true;
                            });
                          } :() {},
                          icon: FaIcon(
                            sent == false ? FontAwesomeIcons.plus: FontAwesomeIcons.checkCircle,
                            color: Colors.white,
                            size: 18.0,
                          ),
                        ) : IconButton(icon: FaIcon(FontAwesomeIcons.arrowAltCircleUp,color: Colors.white,size: 18.0,)),
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
                  ) : Container(height: 0,width: 0,),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: widget.warden == true ?  FaIcon(FontAwesomeIcons.crown,size: 17.0,) : FaIcon(FontAwesomeIcons.graduationCap,size: 17.0,),
            ),
          ],
        ),
      );

  }
}
