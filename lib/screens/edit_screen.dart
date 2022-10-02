import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/models/data_story.dart';
import 'package:diary_app/utilities/data_update.dart';
import 'package:diary_app/utilities/field_focus_change.dart';
import 'package:diary_app/utilities/validators.dart';
import 'package:diary_app/widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EditScreen extends StatefulWidget {
  final DataStory dataStory;
  const EditScreen(this.dataStory, {Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}


class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleFocus = FocusNode();
  final _textFocus = FocusNode();
  @override
  var date;
  var newDate;
  dynamic formattedDate = '';
  bool isDate = false;

  Widget build(BuildContext context) {
    dynamic formattedDate1 = widget.dataStory.date;
    TextEditingController textController = TextEditingController(
        text: widget.dataStory.text);
    TextEditingController titleController = TextEditingController(
        text: widget.dataStory.title);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
            Dialogs.askedToLeaveInputScreen(context);
          },),
          title: const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text("Редактирование"),
          ),
        ),

        body: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(children: [
                const SizedBox(height: 8),
                TextFormField(
                  focusNode: _titleFocus,
                  onFieldSubmitted: (_) {
                    FieldFocusChange(context: context,
                        currentFocus: _titleFocus,
                        nextFocus: _textFocus);
                  },
                  style: TextStyle(color: Colors.grey),
                  maxLines: 1,
                  controller: titleController,
                  decoration: const InputDecoration(
                    iconColor: Colors.yellow,
                    fillColor: Colors.white30,
                    // prefixIcon: Icon(Icons.book, color: Colors.grey,),
                    filled: true,
                    hintText: 'Название',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(25),
                  ],
                  validator: (value) =>
                      Validators.validateTitle(title: value as String),
                ),
                const SizedBox(height: 16,),
                Expanded(
                  child: TextFormField(
                    focusNode: _textFocus,
                    maxLines: 100,
                    style: TextStyle(color: Colors.grey),
                    controller: textController,
                    decoration: const InputDecoration(
                      // hintText: dataStory.text,
                      iconColor: Colors.yellow,
                      fillColor: Colors.white30,
                      // prefixIcon: Icon(Icons.notes, color: Colors.grey,),
                      filled: true,
                      hintText: 'Содержимое',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    validator: (value) =>
                        Validators.validateText(text: value as String),
                  ),
                ),
                const SizedBox(height: 16,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      formattedDate == '' ?
                      ElevatedButton(
                        onPressed: () async {
                          await _showCalendar(context);
                          await DataUpdate.updateDate(date: formattedDate, docId: widget.dataStory.docId);
                          setState(() {});
                        },
                        child: formattedDate1 != null
                            ? Text("$formattedDate1")
                            : Icon(Icons.date_range, color: Colors.black,),
                      ) :
                      ElevatedButton(
                        onPressed: () async {
                          await _showCalendar(context);
                          await DataUpdate.updateDate(date: formattedDate, docId: widget.dataStory.docId);
                          setState(() {});
                        },
                        child: Text("$formattedDate"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await DataUpdate.updateStory(text: textController.text,
                                title: titleController.text, docId: widget.dataStory.docId);
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


  // Future<void> updateStory(
  //     {required String text, required String title}) async {
  //   await FirebaseFirestore.instance.collection("UsersData")
  //       .doc("${FirebaseAuth.instance.currentUser?.uid}")
  //       .collection("UserStories")
  //       .doc("${widget.dataStory.docId}")
  //       .update({"title": title, "text": text});
  // }

  // Future<void> updateDate({required String date}) async {
  //   await FirebaseFirestore.instance.collection("UsersData")
  //       .doc("${FirebaseAuth.instance.currentUser?.uid}")
  //       .collection("UserStories")
  //       .doc("${widget.dataStory.docId}")
  //       .update({"date": date});
  // }

  Future _showCalendar(BuildContext context) async {
    formattedDate = widget.dataStory.date;
    final newDate = await showDatePicker(
      context: context,
      initialDate: date = DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      fieldLabelText: "Выберите дату",
      fieldHintText: "Выберите дату",
      helpText: "Выберите дату",
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
}