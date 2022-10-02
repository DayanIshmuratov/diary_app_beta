import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/models/data_story.dart';
import 'package:flutter/material.dart';


class StoryScreen extends StatelessWidget {
  final DataStory dataStory;
  const StoryScreen(this.dataStory);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(dataStory.title),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${dataStory.text}", style: TextStyle(color: Colors.grey, fontSize: 20),textAlign: TextAlign.justify,),
        ),
      ),
    );
  }
}
