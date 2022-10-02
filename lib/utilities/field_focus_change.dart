import 'package:flutter/material.dart';

class FieldFocusChange {
  final currentFocus = FocusNode();
  final nextFocus = FocusNode();
  FieldFocusChange({required context, required FocusNode currentFocus, required FocusNode nextFocus}){
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}