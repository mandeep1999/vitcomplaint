import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vitcomplaint/provider/firebase_work.dart';
import 'user_avatar.dart';
import 'package:provider/provider.dart';

class ComplaintCard extends StatefulWidget {
  final String imageURL,
      name,
      block,
      complaintID,
      priority,
      complaint,
      status,
      room,
      type;
  ComplaintCard(
      {@required this.imageURL,
      @required this.block,
      @required this.room,
      @required this.type,
      @required this.name,
      @required this.complaint,
      @required this.complaintID,
      @required this.status,
      @required this.priority});

  @override
  _ComplaintCardState createState() => _ComplaintCardState();
}

class _ComplaintCardState extends State<ComplaintCard> {
  List<String> _priority = ['Urgent', 'Not so urgent'];
  List<String> _status = ['Pending', 'Solved', 'In progress'];
  Future<void> submit(String priority, String status) async {
    await Provider.of<FirebaseWork>(context, listen: false).setComplaint(
        widget.complaintID,
        widget.complaint,
        status,
        priority,
        widget.imageURL,
        widget.type);
  }

  void showError(String errorMessage,String name) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  title: Text(
                    name + ' complaint message !!',
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text(
                    errorMessage != null
                        ? errorMessage
                        : 'Complaint message is empty.',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18.0,
                      fontFamily: 'Pacifico',
                    ),
                  )),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        GestureDetector(
          onLongPress: () {
            showError(widget.complaint,widget.name);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12.0),
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
                            widget.type == null ? 'null' : widget.type,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            widget.room == null
                                ? widget.block
                                : widget.block + ' - ' + widget.room,
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
                          child: Center(
                        child: DropdownButton<String>(
                          dropdownColor: Theme.of(context).primaryColor,
                          iconEnabledColor: Colors.white,
                          iconSize: 30.0,
                          hint: Text(
                            widget.status,
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          items: _status.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            await submit(widget.priority, value);
                          },
                        ),
                      )),
                      Container(
                        width: 1.0,
                        color: Colors.white,
                      ),
                      Expanded(
                          child: Center(
                        child: DropdownButton<String>(
                          dropdownColor: Theme.of(context).primaryColor,
                          iconEnabledColor: Colors.white,
                          iconSize: 30.0,
                          hint: Text(
                            widget.priority,
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          items: _priority.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            await submit(value, widget.status);
                          },
                        ),
                      )),
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
          ),
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.trash,
              color: Theme.of(context).primaryColor,
              size: 18.0,
            ),
            onPressed: () async {
              await Provider.of<FirebaseWork>(context, listen: false)
                  .deleteComplaint(widget.complaintID);
            },
          ),
        ),
      ],
    );
  }
}
