import 'package:studentdetails/models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserdetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('user').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // sign up user

  Future<String> signUpUser({
    required String email,
    required String password,
  }) async {
    String res = "Please Ender Correct Data!!";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
        );

        await _firestore.collection('user').doc(cred.user!.uid).set(
              user.toJson(),
            );

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Logging user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Please Ender Correct Data!!";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'password') {}
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
