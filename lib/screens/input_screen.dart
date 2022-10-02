import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/models/user_info.dart';
import 'package:diary_app/models/data.dart';
import 'package:diary_app/models/hints.dart';
import 'package:diary_app/utilities/data_receiver.dart';
import 'package:diary_app/utilities/data_setter.dart';
import 'package:diary_app/utilities/data_update.dart';
import 'package:diary_app/utilities/field_focus_change.dart';
import 'package:diary_app/utilities/validators.dart';
import 'package:diary_app/widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math';


class InputScreen extends StatefulWidget {

  @override
  State<InputScreen> createState() => _InputScreenState();
}


class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleFocus = FocusNode();
  final _textFocus = FocusNode();

  late String hint1;
  late String hint2;
  late String hint3;

  bool isChoose1 = false;
  bool isChoose2 = false;
  bool isChoose3 = false;
  late UserData userData;

  bool isDate = false;

  TextEditingController textController = TextEditingController();
  TextEditingController titleController =  TextEditingController();

  Map<int, dynamic> toDelete = {};
  var date;
  var newDate;
  String? formattedDate;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {
            if (_formKey.currentState!.validate()) {
              Dialogs.askedToLeaveInputScreen(context);
            } else {
              Navigator.pop(context);
            }
            },
          ),
          title: Text("Введите историю"),
          actions: [
            IconButton(onPressed: () async{
              userData = await DataReceiver.getUserData();
              List<String> hints = userData.hints;
              if (hints.isNotEmpty) {
                await chooseHint(hints);
              } else {
                Dialogs.ifEmpty(context);
              }
              setState(() {});
              textController = TextEditingController(text: isChoose1 ? hint1 : isChoose2 ? hint2 : isChoose3 ? hint3 : '');
            }, icon: Icon(Icons.tips_and_updates_outlined))
          ],
        ),

        body: Container(
          padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(children: [
                const SizedBox(height: 8),
                TextFormField(
                  onFieldSubmitted: (_){
                    FieldFocusChange(context: context, currentFocus: _titleFocus, nextFocus: _textFocus);
                  },
                  focusNode: _titleFocus,
                  style: const TextStyle(color: Colors.grey),
                  maxLines: 1,
                  controller: titleController,
                  decoration: const InputDecoration(
                    fillColor: Colors.white30,
                    filled: true,
                    hintText: 'Название',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(25),
                  ],
                  validator: (value) => Validators.validateTitle(title: value as String),
                ),
                const SizedBox(height: 16,),
                Expanded(
                  child: TextFormField(
                    focusNode: _textFocus,
                    maxLines: 100,
                    style: const TextStyle(color: Colors.grey),
                    controller: textController,
                    decoration: InputDecoration(
                      fillColor: Colors.white30,
                      // prefixIcon: Icon(Icons.notes, color: Colors.grey,),
                      filled: true,
                      hintText: 'Содержимое',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    validator: (value) => Validators.validateText(text: value as String),
                  ),
                ),
                const SizedBox(height: 16,),
                Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showCalendar(context);
                      },
                      child: isDate ? Text("$formattedDate") : const Icon(Icons.date_range, color: Colors.black,),
                    ),
                    ElevatedButton(
                      onPressed: () async{
                         if(_formKey.currentState!.validate()) {
                         DataUpdate.counterUpdate();
                         await DataSetter.addStory(text: textController.text, title: titleController.text, userData: userData, formattedDate: formattedDate);
                         if (toDelete.isNotEmpty){
                           List<String> hints = toDelete[1];
                           List<int> idList = toDelete[2];
                           if (isChoose1 == true) {
                             hints.removeAt(idList.elementAt(0));
                             updateHints(hints);
                           }
                           else if (isChoose2 == true) {
                             hints.removeAt(idList.elementAt(1));
                             updateHints(hints);
                           }
                           else if (isChoose3 == true) {
                             hints.removeAt(idList.elementAt(2));
                             updateHints(hints);
                           }
                          }
                         Navigator.pop(context);
                         }
                      },
                      child: Text("Сохранить".toUpperCase()),
                    ),
                  ]
                ),
              ],
              ),
            )
        )
    );
  }

  // Future<void> getUserInfo() async {
  //   await FirebaseFirestore.instance.collection("UsersData")
  //       .doc("${FirebaseAuth.instance.currentUser?.uid}")
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //       userData = UserData.fromDoc(documentSnapshot);
  //   });
  // }

  // void counterUpdate()async{
  //   await FirebaseFirestore.instance.collection("UsersData")
  //       .doc("${FirebaseAuth.instance.currentUser?.uid}")
  //       .update({"counterOfStory": FieldValue.increment(1)});
  // }

 //  Future<void> addStory({required String text, required String title})
 //  async {
 //    userData = await DataReceiver.getUserData();
 //    int counter = userData.counterOfStory;
 //    await FirebaseFirestore.instance.collection("UsersData")
 //        .doc("${FirebaseAuth.instance.currentUser?.uid}")
 //        .collection("UserStories")
 //        .doc()
 //        .set({"title": title, "text": text, "date" : formattedDate, "counterOfStory" : counter});
 // }

  Future _showCalendar(BuildContext context) async{
    final newDate =  await showDatePicker(
      context: context,
      initialDate: date = DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      fieldLabelText: "Выберите дату",
      fieldHintText: "Выберите дату",
      helpText:  "Выберите дату",
    );
    if (newDate == null) {
      return null;
    } else {
      setState(() {
      final String formatted = DateFormat('dd/MM/yyyy').format(newDate);
      formattedDate = formatted;
      isDate = true;
    });
    }
  }

  String dateFormatter(){
    final String formatted = DateFormat.yMMMd().format(date);
    return formatted;
  }

  Future<void> chooseHint(List<String> hints) async {

    bool isHigh1 = false;
    bool isHigh2 = false;
    bool isHigh3 = false;


    List<int> idList = [];
    late int i;
    hints.length > 2 ? i = 3 : hints.length > 1 ? i = 2 : hints.length > 0 ? i = 1 : null;
    while (i > 0) {
      int n = Random().nextInt(hints.length);
      if (!idList.contains(n)){
            idList.add(n);
            i--;
      }
    }
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              title: const Text('Выберите вопрос, на который Вы бы хотели ответить', textAlign: TextAlign.center,),
              children: <Widget>[
                Container(
                  child: hints.length > 2 ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
                        child: ElevatedButton(onPressed: (){
                          isHigh1 = true; isHigh2 = false; isHigh3 = false;
                          setState(() {});}, child: Text(hints.elementAt(idList.elementAt(0)), textAlign: TextAlign.center, style: TextStyle(fontSize: 16),), style: isHigh1 ? ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ): ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                        ) ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
                        child: ElevatedButton(onPressed: (){
                          isHigh1 = false; isHigh2 = true; isHigh3 = false;
                          setState(() {});}, child: Text(hints.elementAt(idList.elementAt(1)), textAlign: TextAlign.center, style: TextStyle(fontSize: 16),), style: isHigh2 ? ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ):ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                        )),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
                        child: ElevatedButton(onPressed: (){
                          isHigh1 = false; isHigh2 = false; isHigh3 = true;
                          setState(() {});}, child: Text(hints.elementAt(idList.elementAt(2)), textAlign: TextAlign.center,  style: TextStyle(fontSize: 16),), style: isHigh3 ? ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ): ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                        ) ),
                      ),

                      ElevatedButton(onPressed: (){
                        toDelete = {
                          1: hints,
                          2: idList,
                        };
                        if (isHigh1 == true){
                          isChoose1 = true;isChoose2 = false;isChoose3 = false;
                          hint1 = hints[idList[0]];
                          // hints.removeAt(idList.elementAt(0));
                          // updateHints(hints);
                          Navigator.pop(context);
                        }
                        else if (isHigh2 == true){
                          isChoose1 = false;isChoose2 = true;isChoose3 = false;
                          hint2 = hints[idList[1]];
                          Navigator.pop(context);
                        }
                        else if (isHigh3 == true){
                          isChoose1 = false;isChoose2 = false;isChoose3 = true;
                          hint3 = hints[idList[2]];
                          Navigator.pop(context);
                        }
                        else {
                          Navigator.pop(context);
                        }
                      }, child: Text('Потвердить'))
                    ],
                  ): hints.length > 1 ? Column(
                    children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
                      child: ElevatedButton(onPressed: (){
                          isHigh1 = true; isHigh2 = false; isHigh3 = false;
                          setState(() {});}, child: Text(hints.elementAt(idList.elementAt(0)), textAlign: TextAlign.center, style: TextStyle(fontSize: 16),), style: isHigh1 ? ElevatedButton.styleFrom(
                          primary: Colors.green,
                          ): ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                          ) ),
                    ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
                          child: ElevatedButton(onPressed: (){
                          isHigh1 = false; isHigh2 = true; isHigh3 = false;
                          setState(() {});}, child: Text(hints.elementAt(idList.elementAt(1)), textAlign: TextAlign.center, style: TextStyle(fontSize: 16),), style: isHigh2 ? ElevatedButton.styleFrom(
                          primary: Colors.green,
                          ) :
                          ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                          )),
                        ),
                      ElevatedButton(onPressed: (){
                        toDelete = {
                          1: hints,
                          2: idList,
                        };
                        if (isHigh1 == true){
                          isChoose1 = true;isChoose2 = false;isChoose3 = false;
                          hint1 = hints[idList[0]];
                          // hints.removeAt(idList.elementAt(0));
                          // updateHints(hints);
                          Navigator.pop(context);
                        }
                        else if (isHigh2 == true){
                          isChoose1 = false;isChoose2 = true;isChoose3 = false;
                          hint2 = hints[idList[1]];
                          // hints.removeAt(idList.elementAt(1));
                          // updateHints(hints);
                          Navigator.pop(context);
                        }
                        else {
                          Navigator.pop(context);
                        }
                      }, child: Text('Потвердить'))]): hints.length > 0 ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
                          child: ElevatedButton(onPressed: (){
                            isHigh1 = true; isHigh2 = false; isHigh3 = false;
                            setState(() {});}, child: Text(hints.elementAt(idList.elementAt(0)), textAlign: TextAlign.center, style: TextStyle(fontSize: 16),), style: isHigh1 ? ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ): ElevatedButton.styleFrom(
                            primary: Colors.yellow,
                          ) ),
                        ),
                        ElevatedButton(onPressed: (){
                          toDelete = {
                            1: hints,
                            2: idList,
                          };
                          if (isHigh1 == true){
                            isChoose1 = true;isChoose2 = false;isChoose3 = false;
                            hint1 = hints[idList[0]];
                            // hints.removeAt(idList.elementAt(0));
                            // updateHints(hints);
                            Navigator.pop(context);
                          }
                          else {
                            Navigator.pop(context);
                          }
                        }, child: Text('Потвердить'))
                      ]) : Center(child: Text("Вы использовали все подсказки")),
                ),
              ],
            );
            },
          );
        }
    );
  }


  Future<void> updateHints(List<String> hints) async{
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .update({
      "hints" : hints,
    });
  }
}
