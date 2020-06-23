import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitcomplaint/provider/firebase_work.dart';
import 'package:vitcomplaint/widgets/rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

final picker = ImagePicker();
File _image;
String complaintId, complaint, status = 'Pending', priority;
bool loading = false;

class _AddScreenState extends State<AddScreen> {
  Future getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    _image = File(pickedFile.path);
  }

  Future<void> submit() async {
    setState(() {
      loading = true;
    });
    String url = await Provider.of<FirebaseWork>(context, listen: false)
        .getComplaintURL(_image, complaintId);
    await Provider.of<FirebaseWork>(context, listen: false)
        .setComplaint(complaintId, complaint, status, priority, url);
    setState(() {
      loading = false;
    });
  }

  List<String> _blocks = [
    'Room Cleaning',
    'AC',
    'Electricty',
    'Furniture',
    'Others'
  ];
  List<String> _priority = ['Urgent', 'Not so urgent'];
  String rvalue = 'type';
  String rpvalue = 'priority';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    complaintId = DateTime.now().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.only(top: 20.0,left: 20.0,right: 20.0),
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
              'Add compalint.',
              style: TextStyle(fontSize: 25.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 335.0,
              child: loading == false? ListView(
                children: [
                  Container(
                      child: ListTile(
                    leading: Text(
                      'Complaint type',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    trailing: DropdownButton<String>(
                      dropdownColor: Theme.of(context).primaryColor,
                      hint: Text(
                        rvalue,
                        style: TextStyle(fontSize: 20.0, color: Colors.amber),
                      ),
                      iconEnabledColor: Theme.of(context).primaryColor,
                      iconSize: 30.0,
                      items: _blocks.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          rvalue = value;
                          complaint = rvalue;
                        });
                      },
                    ),
                  )),
                  Container(
                      child: ListTile(
                        leading: Text(
                          'Select priority',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        trailing: DropdownButton<String>(
                          dropdownColor: Theme.of(context).primaryColor,
                          hint: Text(
                            rpvalue,
                            style: TextStyle(fontSize: 20.0, color: Colors.amber),
                          ),
                          iconEnabledColor: Theme.of(context).primaryColor,
                          iconSize: 30.0,
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
                            setState(() {
                              rpvalue = value;
                              priority = rpvalue;
                            });
                          },
                        ),
                      )),

                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Complaint',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  RoundedButton(
                    title: 'Choose Image',
                    colour: Colors.amber,
                    onPressed: () async {
                      await getImage();
                    },
                  ),
                  RoundedButton(
                    title: 'Submit',
                    colour: Theme.of(context).primaryColor,
                    onPressed: ()async{await submit();},
                  ),
                ],
              ) : Center(
                child: SpinKitCubeGrid(
                  color: Theme.of(context).primaryColor,
                  size: 50.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
