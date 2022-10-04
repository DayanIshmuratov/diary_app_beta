import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/dialogs.dart';
class MoreSettings {
  static const String Settings = "Профиль";
  static const String LogOut  = "Выход";
  static const List<String> choices = [
    Settings, LogOut
  ];
}