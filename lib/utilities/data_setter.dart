import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/models/user_info.dart';
import 'package:diary_app/utilities/data_receiver.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataSetter {
  static Future<void> addStory({required String text, required String title, required UserData userData, required String? formattedDate})
  async {
    userData = await DataReceiver.getUserData();
    int counter = userData.counterOfStory;
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .collection("UserStories")
        .doc()
        .set({"title": title, "text": text, "date" : formattedDate, "counterOfStory" : counter});
  }
}