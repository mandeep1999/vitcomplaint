import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password,bool warden);
  Future<String> signUp(String email, String password, bool warden);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  String errorMessage;
  FirebaseUser user;
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<String> signUp(String email, String password, bool warden) async {
    print('signup');
    errorMessage = null;
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      if (warden == true) {
        await user.sendEmailVerification();
        setAdmin(warden, email);
      } else {
        await user.sendEmailVerification();
        setAdmin(warden, email);
      }
    } catch (error) {
      print(error.code);
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "Email is already in use.";
          break;
        case "ERROR_WEAK_PASSWORD":
          errorMessage = "Your password is weak.";
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          errorMessage = "Please check your internet connection.";
          break;
        case "ERROR_INVALID_EMAIL":
          errorMessage = "You have given invalid email id.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "Something went wrong.";
      }
    }
    if (errorMessage != null) {
      return errorMessage;
    }

    return user.uid;
  }

  @override
  Future<String> signIn(String email, String password, bool warden) async {
    print('sign in');
    bool adminResult;
    errorMessage = null;
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
    } catch (error) {
      print(error.code);
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if (errorMessage != null) {
      print('failure');
      return errorMessage;
    }
    if (user.isEmailVerified) {
      print('success');
      if (warden == true) {
        adminResult = await checkAdmin();
        if (adminResult == false) {
          await signOut();
          errorMessage = "You are not a warden.";
          return errorMessage;
        }
      }
      if(warden == false){
        adminResult = await checkAdmin();
        if(adminResult == true){
          await signOut();
          errorMessage = "You are not a student.";
          return errorMessage;
        }
      }
      return user.uid;
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> setAdmin(bool warden, String email) async {
    if (warden == false) {
      String first = email.substring(0, email.indexOf('.'));
      String last =
          email.substring(email.indexOf('.') + 1, email.indexOf('@') - 4);
      String year = email.substring(email.indexOf('@') - 4, email.indexOf('@'));
      await _firestore.collection("profiles").document(user.email).setData({
        'email': user.email,
        'warden': warden,
        'first': first,
        'last': last,
        'year': year
      });
    } else {
      await _firestore
          .collection("profiles")
          .document(user.email)
          .setData({'email': user.email, 'warden': warden});
    }
  }

  Future<bool> checkAdmin() async {
    final items = await _firestore.collection('profiles').getDocuments();
    for (var message in items.documents) {
      if (message.data['email'] == user.email) {
        bool warden = message.data['warden'];
        if (warden == false) {
          return false;
        }
      }
    }
    return true;
  }
}
