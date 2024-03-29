import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vitcomplaint/provider/firebase_work.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vitcomplaint/screens/welcome_screen.dart';

class ProfileScreenWarden extends StatefulWidget {
  @override
  _ProfileScreenWardenState createState() => _ProfileScreenWardenState();
}

class _ProfileScreenWardenState extends State<ProfileScreenWarden>
    with TickerProviderStateMixin {
  bool editName = false;
  bool editBlock = false;
  File _image;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<FirebaseWork>(context, listen: false).getProfile();
  }

  @override
  Widget build(BuildContext context) {
    String name = Provider.of<FirebaseWork>(context).userName == null
        ? 'name'
        : Provider.of<FirebaseWork>(context).userName;
    String block = Provider.of<FirebaseWork>(context).block == null
        ? 'null'
        : Provider.of<FirebaseWork>(context).block;
    String url = Provider.of<FirebaseWork>(context).url;

    List<String> _blocks = ['A', 'B', 'C', 'D'];
    final picker = ImagePicker();

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
      await Provider.of<FirebaseWork>(context, listen: false)
          .setProfileWarden(name, url, block=='null'? null : block);
      setState(() {
        loading = false;
      });
    }

    return Container(
      child: Column(
        children: [
          Container(
            height: 75.0,
            width: double.infinity,
            padding: EdgeInsets.only(top: 10.0,left: 5.0),
            color: Theme.of(context).primaryColor,
            child: ListTile(
              leading: Text(
                'Profile',
                style: TextStyle(
                    fontSize: 30.0, color: Colors.white, fontFamily: 'Pacifico'),
              ),
              trailing: IconButton(icon: FaIcon(FontAwesomeIcons.signOutAlt,color: Colors.white,),onPressed: ()async{
                await Provider.of<FirebaseWork>(context,listen: false).signOut();
                Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, (route) => false);
              },),
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                  ),
                ),
                child: Provider.of<FirebaseWork>(context).loaded == true
                    ? Container(
                  child: loading == false
                      ? ListView(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Warden',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Stack(
                            children: [
                              Card(
                                  elevation: 15.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              82.0))),
                                  child: CircleAvatar(
                                      radius: 82.0,
                                      backgroundColor:
                                      Theme.of(context)
                                          .primaryColor,
                                      child: CircleAvatar(
                                        radius: 80.0,
                                        backgroundImage: url == null
                                            ? AssetImage(
                                            'assets/images/student.png')
                                            : NetworkImage(url),
                                      ))),
                              Positioned(
                                top: 120.0,
                                left: 120.0,
                                child: IconButton(
                                  onPressed: () async {
                                    await getImage();
                                    if (_image != null) {
                                      await Provider.of<
                                          FirebaseWork>(
                                          context,
                                          listen: false)
                                          .getURL(_image);
                                    }
                                  },
                                  icon: FaIcon(
                                      FontAwesomeIcons.userEdit),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context)
                                      .primaryColor),
                              borderRadius:
                              BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(2.0,
                                      2.0), // shadow direction: bottom right
                                )
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                editName == false
                                    ? Expanded(
                                  child:
                                  SingleChildScrollView(
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                          fontSize: 20.0),
                                    ),
                                  ),
                                )
                                    : Container(
                                  width: 200.0,
                                  child: TextField(
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryColor,
                                    ),
                                    onChanged: (value) {
                                      name = value;
                                    },
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        border:
                                        InputBorder.none,
                                        hintText:
                                        'Write your name.'),
                                  ),
                                ),
                                editName == false
                                    ? IconButton(
                                  icon: FaIcon(
                                      FontAwesomeIcons.edit),
                                  onPressed: () {
                                    setState(() {
                                      editName = true;
                                    });
                                  },
                                )
                                    : IconButton(
                                  icon: FaIcon(
                                      FontAwesomeIcons.save),
                                  onPressed: () async {
                                    await submit();
                                    setState(() {
                                      editName = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context)
                                      .primaryColor),
                              borderRadius:
                              BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(2.0,
                                      2.0), // shadow direction: bottom right
                                )
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                editBlock == false
                                    ? Text(
                                  block + ' block',
                                  style: TextStyle(
                                      fontSize: 20.0),
                                )
                                    : Container(
                                    width: 150.0,
                                    child:
                                    DropdownButton<String>(
                                      dropdownColor:
                                      Theme.of(context)
                                          .primaryColor,
                                      iconEnabledColor:
                                      Theme.of(context)
                                          .primaryColor,
                                      iconSize: 30.0,
                                      hint: Text(
                                        block + ' block',
                                        style: TextStyle(
                                            color: Theme.of(
                                                context)
                                                .primaryColor,
                                            fontSize: 20.0),
                                      ),
                                      items: _blocks
                                          .map((String value) {
                                        return new DropdownMenuItem<
                                            String>(
                                          value: value,
                                          child: new Text(
                                            value + ' block',
                                            style: TextStyle(
                                                color: Colors
                                                    .white),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) async {
                                        setState(() {
                                          block = value;
                                          editBlock = false;
                                        });
                                        await submit();
                                      },
                                    )),
                                editBlock == false
                                    ? IconButton(
                                  icon: FaIcon(
                                      FontAwesomeIcons.edit),
                                  onPressed: () {
                                    setState(() {
                                      editBlock = true;
                                    });
                                  },
                                )
                                    : IconButton(
                                  icon: FaIcon(
                                      FontAwesomeIcons.save),
                                  onPressed: () async {
                                    await submit();
                                    setState(() {
                                      editBlock = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                      : Center(
                    child: SpinKitCubeGrid(
                      color: Theme.of(context).primaryColor,
                      size: 50.0,
                    ),
                  ),
                )
                    : Center(
                  child: SpinKitCubeGrid(
                    color: Theme.of(context).primaryColor,
                    size: 50.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
