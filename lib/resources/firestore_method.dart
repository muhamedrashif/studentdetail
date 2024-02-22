import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studentdetails/models/posts.dart';
import 'package:studentdetails/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload student details

  Future<String> uploadStudentdetails({
    required String name,
    required String age,
    required Uint8List file,
    required String uid,
  }) async {
    String res = "Some error occurred";
    try {
      if (name.isNotEmpty || age.isNotEmpty || file != null || uid.isNotEmpty) {
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        String postId = const Uuid().v1();
        Studentdetails studentdetails = Studentdetails(
            photoUrl: photoUrl, name: name, age: age, postId: postId, uid: uid);

        await _firestore.collection('studentdetails').doc(postId).set(
              studentdetails.toJson(),
            );
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
