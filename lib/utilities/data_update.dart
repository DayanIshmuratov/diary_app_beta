import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataUpdate {
  static void counterUpdate()async{
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .update({"counterOfStory": FieldValue.increment(1)});
  }

  static Future<void> updateStory(
      {required String text, required String title, required String docId}) async {
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .collection("UserStories")
        .doc(docId)
        .update({"title": title, "text": text});
  }

  static Future<void> updateDate({required String date, required String docId}) async {
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .collection("UserStories")
        .doc(docId)
        .update({"date": date});
  }
}