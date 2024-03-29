import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class FirebaseWork extends ChangeNotifier {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  String uid;
  String email, userName, url;
  bool warden;
  String block;
  String room;
  bool loaded = false;
  List<dynamic> roommates;
  Future<bool> getUser() async {
    user = await _firebaseAuth.currentUser();
    if (user != null) {
      uid = user.uid;
      await checkAdmin(uid);
      return true;
    }
    return false;
  }

  Future<void> getProfile() async {
    final items = await _firestore.collection('profiles').getDocuments();
    for (var message in items.documents) {
      if (message.documentID == uid) {
        userName = message.data['name'];
        url = message.data['url'];
        warden = message.data['warden'];
        block = message.data['block'];
        room = message.data['room'];
      }
    }
    loaded = true;
    notifyListeners();
  }

  Future<bool> checkAdmin(uid) async {
    final items = await _firestore.collection('users').getDocuments();
    for (var message in items.documents) {
      if (message.data['uid'] == uid) {
        bool warden1 = message.data['warden'];
        print(warden1);
        if (warden1 == false) {
          warden = false;
          return false;
        }
      }
    }
    warden = true;
    return true;
  }

  Future<void> setProfile(
      String name, String url, String block, String room) async {
    await _firestore.collection('profiles').document(uid).setData({
      'name': name,
      'url': url,
      'block': block,
      'room': room,
      'warden': warden
    });
    await getProfile();
  }

  Future<void> setProfileWarden(String name, String url, String block) async {
    await _firestore.collection('profiles').document(uid).setData({
      'name': name,
      'url': url,
      'block': block,
      'warden': warden
    });
    await getProfile();
  }

  Future<void> getURL(File _image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('pictures/profiles/$uid');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    await storageReference.getDownloadURL().then((fileURL) {
      print(fileURL);
      setProfile(userName, fileURL, block, room);
    });
  }

  Future<String> getComplaintURL(File _image, String id) async {
    String url;
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('pictures/complaints/$uid/$id');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    await storageReference.getDownloadURL().then((fileURL) {
      url = fileURL;
      return fileURL;
    });
    return url;
  }

  Future<void> setComplaint(String id, String complaint, String status,
      String priority, String complaintUrl, String type) async {
    print('submit');
    await _firestore
        .collection('complaints')
        .document(block)
        .collection('complaints')
        .document(id)
        .setData({
      'user': uid,
      'name': userName,
      'block': block,
      'room': room,
      'type': type,
      'complaint': complaint,
      'status': status,
      'priority': priority,
      'url': complaintUrl
    });
  }

  Future<void> updateComplaint(
      String id, String status, String priority) async {
    print('submit');
    await _firestore
        .collection('complaints')
        .document(block)
        .collection('complaints')
        .document(id)
        .updateData({
      'status': status,
      'priority': priority,
    });
  }

  Future<void> deleteComplaint(String id) async {
    print('delete');
    await _firestore
        .collection('complaints')
        .document(block)
        .collection('complaints')
        .document(id)
        .delete();
  }

  Future<void> sendRequest(
      String senderID, String receiverID, String name, String block) async {
    await _firestore
        .collection('requests')
        .document(senderID + receiverID)
        .setData({
      'senderID': senderID,
      'receiverID': receiverID,
      'name': name,
      'block': block
    });
  }

  Future<void> acceptRequest(String senderID, String receiverID) async {
    bool condition = true;
    if(roommates != null) {
      for (String i in roommates){
        if(i.toLowerCase().trim() == senderID.toLowerCase().trim()){
          condition = false;
        }
      }
    }
    if(condition == true){
    List<dynamic> result = [senderID];
    if(roommates != null){
    for(String i in roommates){
      result.add(i);
    }}
    await _firestore.collection('roommates').document(receiverID).setData({
      'roommates': result
    });
    List<dynamic> result1 = [];
    final items = await _firestore.collection('roommates').getDocuments();
    for (var message in items.documents) {
      if (message.documentID == senderID) {
        result1 = message.data['roommates'];
      }
    }
    result1.add(receiverID);
    await _firestore.collection('roommates').document(senderID).setData({
      'roommates': result1
    });
    result = []; result1 = [];}
    await _firestore
        .collection('requests')
        .document(senderID + receiverID)
        .delete();
    await getRoommates();
  }

  Future<void> deleteRoommate(String id) async {
    List<dynamic> result = [];
    if(roommates != null){
    for (String i in roommates) {
      if (i.toLowerCase().trim() != id.toLowerCase().trim()) {
        result.add(i);
      }}
    }
    await _firestore
        .collection('roommates')
        .document(uid)
        .setData({'roommates': result});
    result.clear();
    List<dynamic> roome = [];
    final items = await _firestore.collection('roommates').getDocuments();
    for (var message in items.documents) {
      if (message.documentID == id) {
        roome = message.data['roommates'];
      }
    }
    for (String i in roome) {
      if (i.toLowerCase().trim() != uid.toLowerCase().trim()) {
        result.add(i);
      }
    }
    await _firestore
        .collection('roommates')
        .document(id)
        .setData({'roommates': result});
    await getRoommates();
  }

  Future<void> rejectRequest(String senderID, String receiverID) async {
    await _firestore
        .collection('requests')
        .document(senderID + receiverID)
        .delete();
  }

  Future<void> getRoommates() async {
    final items = await _firestore.collection('roommates').getDocuments();
    for (var message in items.documents) {
      if (message.documentID == uid) {
        roommates = message.data['roommates'];
      }
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    uid = null;
    userName = null;
    room = null;
    warden = null;
    block = null;
    url = null;
    roommates = null;
    await _firebaseAuth.signOut();
  }
}
