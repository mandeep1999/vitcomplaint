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
  Future<bool> getUser() async {
    user = await _firebaseAuth.currentUser();
    if (user != null) {
      uid = user.uid;
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
      }
    }
    notifyListeners();
  }

  Future<void> setProfile(String name, String url, int block) async {
    await _firestore
        .collection('profiles')
        .document(uid)
        .updateData({'name': name, 'url': url, 'block': block});
  }

  Future<String> getURL(File _image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('pictures/profiles/$uid');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    await storageReference.getDownloadURL().then((fileURL) {
      return fileURL;
    });
    return 'error while uploading';
  }

  Future<String> getComplaintURL(File _image, String id) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('pictures/complaints/$uid/$id');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    await storageReference.getDownloadURL().then((fileURL) {
      return fileURL;
    });
    return 'error while uploading';
  }

  Future<void> setComplaint(String id, String complaint, int status,
      int priority, String complaintUrl) async {
    await _firestore.collection(block).document(id).setData({
      'user': uid,
      'complaint': complaint,
      'status': status,
      'priority': priority,
      'url': complaintUrl
    });
  }
}
