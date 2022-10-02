import 'package:cloud_firestore/cloud_firestore.dart';

class DataStory {
  late String text;
  late String title;
  late dynamic date;
  late String docId;

  DataStory.fromDoc(QueryDocumentSnapshot doc) {
    text = doc["text"];
    title = doc["title"];
    date = doc["date"];
    docId = doc.id;
  }
}
