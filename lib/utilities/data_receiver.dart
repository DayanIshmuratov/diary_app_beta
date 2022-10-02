import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/models/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/data_story.dart';

class DataReceiver {
  static Future<List<DataStory>> getStory() async {
    List<DataStory> stories = [];
    await FirebaseFirestore.instance
        .collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .collection("UserStories")
        .orderBy("counterOfStory", descending: false)
        .get()
        .then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
        stories.add(DataStory.fromDoc(doc));
      });
    });
    return stories;
  }


  static Future<UserData> getUserData() async {
    UserData userData;
    var temp;
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
          userData = UserData.fromDoc(documentSnapshot);
          temp = userData;
        }
        );
    return temp;
  }
}