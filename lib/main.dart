import 'dart:io';

import 'package:diary_app/models/data.dart';
import 'package:diary_app/models/data_story.dart';
import 'package:diary_app/screens/edit_screen.dart';
import 'package:diary_app/screens/forgot_password_screen.dart';
import 'package:diary_app/screens/input_screen.dart';
import 'package:diary_app/screens/login_screen.dart';
import 'package:diary_app/screens/main_screen.dart';
import 'package:diary_app/screens/profile_screen.dart';
import 'package:diary_app/screens/signup_screen.dart';
import 'package:diary_app/screens/story_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;


main() async {
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        switch(settings.name){
          case '/' : return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/main_screen' :
            User user = settings.arguments as User;
            return MaterialPageRoute(builder: (context) => MainScreen(user: user));
          case '/input_screen' :
            return MaterialPageRoute(builder : (context) => InputScreen());
          case '/edit_screen' :
            DataStory dataStory = settings.arguments as DataStory;
            return MaterialPageRoute(builder: (context) => EditScreen(dataStory));
          case '/story_screen' :
            DataStory dataStory = settings.arguments as DataStory;
            return MaterialPageRoute(builder: (context) => StoryScreen(dataStory));
          case '/profile_screen' :
            return MaterialPageRoute(builder: (context) => ProfileScreen());
          case '/signup_screen' :
            return MaterialPageRoute(builder: (context) => SignUpScreen());
          case '/forgot_password_screen' :
            return MaterialPageRoute(builder: (context) => ForgotPasswordScreen());
        }
      },
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'Rostov',
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.yellow,
            accentColor: Colors.yellowAccent,
          )),
      home: LoginScreen(),
    );
  }
}
