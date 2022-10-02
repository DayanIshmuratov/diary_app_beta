import 'package:cloud_firestore/cloud_firestore.dart';

class Data{
  late int counter;
  late String email;
  late String name;
  Data.fromDoc(Map<dynamic, dynamic> doc){
    counter = doc["counter"];
    email = doc["email"];
    name = doc["name"];
  }
}