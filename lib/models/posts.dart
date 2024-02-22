import 'package:cloud_firestore/cloud_firestore.dart';

class Studentdetails {
  final String name;
  final String age;
  final String photoUrl;
  final String postId;
  final String uid;

  const Studentdetails(
      {required this.name,
      required this.age,
      required this.photoUrl,
      required this.postId,
      required this.uid});

  Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
        "photoUrl": photoUrl,
        "postId": postId,
        "uid": uid
      };

  static Studentdetails fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Studentdetails(
        name: snapshot['name'],
        age: snapshot['age'],
        photoUrl: snapshot['photoUrl'],
        postId: snapshot['postId'],
        uid: snapshot['uid']);
  }
}
