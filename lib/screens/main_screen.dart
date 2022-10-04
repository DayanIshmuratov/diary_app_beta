import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/utilities/data_receiver.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/data_story.dart';
import '../utilities/more_settings.dart';
import '../widgets/dialogs.dart';

class MainScreen extends StatefulWidget {
  final User user;

  MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}
late User currentUser;
class _MainScreenState extends State<MainScreen> {
  List<DataStory> storyList = [];
  FirebaseAuth firebase = FirebaseAuth.instance;

  @override


  void initState() {
    currentUser = widget.user;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton(
              onSelected: choiceAction,
              color: Colors.yellow,
              itemBuilder: (BuildContext context) {
                return MoreSettings.choices.map((String choice) {
                  return PopupMenuItem(value: choice,
                    child: Text(choice),);
                }).toList();
              },)
          ],
          centerTitle: true,
          title: Text("Diary App".toUpperCase(),
            style: const TextStyle(
              fontSize: 30,
            ),
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, "/input_screen");
          setState(() {});
        },
        child: Center(
          child: Text(
            "+", style: const TextStyle(fontFamily: 'Rostov', fontSize: 40,),),
        ),
      ),
      body:
      FutureBuilder<List<DataStory>>(
          future: DataReceiver.getStory(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                '${snapshot.error}', style: TextStyle(color: Colors.white),);
            }

            if (snapshot.connectionState == ConnectionState.done) {
              storyList = snapshot.data!;

              if (storyList.isEmpty) {
                return emptyViewBuild();
              }
              else {
                return listBuilder(storyList);
              }
            }

            return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ));
          }
      ),
    );
  }

  emptyViewBuild() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          child:
          Center(
              child: Text(
                '${currentUser.displayName}, напишите свою первую историю',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Rostov',
                    color: Colors.yellow.withOpacity(0.5)),
              )
          )
      ),
    );
  }

  listBuilder(List<DataStory> storyList) {
    return RefreshIndicator(
      onRefresh: () async {
        storyList = [];
        await DataReceiver.getStory();
        setState(() {});
        return Future.value();
      },
      child: ListView.builder(
        itemCount: storyList.length,
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(children: [
              Container(
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.all(Radius.circular(25)),
                //   border: Border.all(
                //       color: Colors.yellow,
                //       width: 1
                //   ),
                // ),

                child: ListTile(
                  onTap: () {
                    log(currentUser.uid);
                    Navigator.pushNamed(
                        context, '/story_screen', arguments: storyList[index]);
                  },
                  leading: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  title: Text(
                    "${storyList[index].title}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: storyList[index].date != null ? Text(
                      "${storyList[index].date}",
                      style: TextStyle(color: Colors.grey)) : Text(""),
                  trailing: Row(mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () async {
                        await Navigator.of(context).pushNamed(
                            '/edit_screen', arguments: storyList[index]
                        );
                        setState(() {});
                      }, icon: Icon(
                        Icons.edit,
                        color: Colors.white70,),
                      ),
                      IconButton(onPressed: () async {
                        await Dialogs.askedToDelete(storyList[index], context);
                        setState(() {});
                      }, icon: Icon(
                        Icons.delete_outline,
                        color: Colors.white70,),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
            ],
            ),
          );
        },
      ),
    );
  }

  void choiceAction(String choice) async{
    switch(choice) {
      case MoreSettings.LogOut : Dialogs.askedToLogOut(context, firebase);
      break;
      case MoreSettings.Settings : Navigator.of(context).pushNamed('/profile_screen');
    }
  }

}