import 'package:cloud_firestore/cloud_firestore.dart';

class Hints{
  late  List<String> hintsTemp;
  late  List<String> hints;


    Hints.toList(DocumentSnapshot doc){
    hintsTemp = doc['hints'];
    // hintsTemp.forEach((element) {
    // hints = List.castFrom(hintsTemp);
    // });
  }
}