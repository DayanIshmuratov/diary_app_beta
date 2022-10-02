import 'dart:developer';

import 'package:diary_app/screens/main_screen.dart';
import 'package:diary_app/utilities/field_focus_change.dart';
import 'package:diary_app/utilities/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../api/auth.dart';
import '../api/notifications.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isHide = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));

  Future<FirebaseApp> _initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushNamed("/main_screen", arguments: user);
    }
    return Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
  }




  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
          title: Text(
            "Diary App".toUpperCase(),
            style: const TextStyle(
              fontSize: 30,
            ),
          )),
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              '${snapshot.error}',
              style: TextStyle(color: Colors.white),
            ));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return loginWidgets();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget loginWidgets() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              style: TextStyle(color: Colors.grey),
              maxLines: 1,
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.mail,
                  color: Colors.grey,
                ),
                iconColor: Colors.yellow,
                fillColor: Colors.white30,
                filled: true,
                labelText: 'Почта',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              validator: (value) => Validators.validateEmail(email: value as String),
            ),
            SizedBox(height: 16),
            TextFormField(
              style: TextStyle(color: Colors.grey),
              maxLines: 1,
              controller: passwordController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: (){
                    setState((){
                      _isHide = !_isHide;
                    });
                  }, icon: _isHide ?  Icon(Icons.visibility) : Icon(Icons.visibility_off), color: Colors.grey,),
                  filled: true,
                  fillColor: Colors.white30,
                  labelText: "Пароль",
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
              ),
              obscureText: _isHide,
              validator: (value) =>
                  Validators.validatePassword(password: value as String),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async{
                    if( _formKey.currentState!.validate()){
                      User? user = await FireAuth.signInUsingEmailPassword(email: emailController.text, password: passwordController.text, context: context);
                      setState((){
                        if (user != null) {
                          Navigator.of(context).pushNamed('/main_screen', arguments: user);
                        }
                      });
                    }
                  },
                  child: Text(
                    "Войти",
                    style: TextStyle(fontSize: 25),
                  ),
                  style: ElevatedButton.styleFrom(

                    // padding: EdgeInsets.symmetric(horizontal: 50),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/signup_screen');

                  },
                  child: Text(
                    "Регистрация",
                    style: TextStyle(fontSize: 25),
                  ),
                  style: ElevatedButton.styleFrom(
                    // padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(child: InkWell(onTap: (){
              Navigator.pushNamed(context, "/forgot_password_screen");
            },child: Text("Забыли пароль?", style: TextStyle(fontSize: 20, color: Colors.grey)))),
          ],
        ),
      ),
    );

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 16, right: 16),
    //       child: TextField(
    //         style: TextStyle(color: Colors.grey),
    //         maxLines: 1,
    //         controller: emailController,
    //         decoration: const InputDecoration(
    //           prefixIcon: Icon(
    //             Icons.mail,
    //             color: Colors.grey,
    //           ),
    //           iconColor: Colors.yellow,
    //           fillColor: Colors.white30,
    //           filled: true,
    //           labelText: 'Почта',
    //           labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
    //         ),
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 16, right: 16),
    //       child: TextFormField(
    //         maxLines: 1,
    //         obscureText: true,
    //         style: TextStyle(color: Colors.grey),
    //         controller: passwordController,
    //         decoration: InputDecoration(
    //           prefixIcon: Icon(
    //             Icons.lock,
    //             color: Colors.grey,
    //           ),
    //           iconColor: Colors.yellow,
    //           fillColor: Colors.white30,
    //           filled: true,
    //           labelText: 'Пароль',
    //           labelStyle: TextStyle(color: Colors.grey),
    //         ),
    //       ),
    //     ),
    //     SizedBox(height: 7),
    //     Padding(
    //       padding: const EdgeInsets.only(left: 16, right: 16),
    //       child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //         ElevatedButton(
    //         onPressed: () async {
    //           if ((passwordController.text != "") & (emailController.text != "")){
    //             User? user = await FireAuth.signInUsingEmailPassword(
    //                 email: emailController.text,
    //                 password: passwordController.text, context: context);
    //             setState(() {});
    //             if (user != null) {
    //               Navigator.of(context)
    //                   .pushReplacement(
    //                 MaterialPageRoute(
    //                   builder: (context) =>
    //                       MyHomePage(user: user),
    //                 ),
    //               );
    //             }
    //           }
    //           else{
    //             ifNotFul();
    //           }
    //         },
    //         child: Text(
    //           "ВОЙТИ",
    //           style: TextStyle(fontSize: 20),
    //         ),
    //           style: ElevatedButton.styleFrom(
    //             padding: EdgeInsets.symmetric(horizontal: 52, vertical: 13),
    //           ),
    //       ), ElevatedButton(
    //         onPressed: () async {
    //              Navigator.of(context).pushReplacement(
    //              MaterialPageRoute(builder: (context) => SignUpPage()),
    //              );
    //           },
    //         child: Text(
    //           "Регистрация".toUpperCase(),
    //           style: TextStyle(fontSize: 20),
    //         ),
    //             style: ElevatedButton.styleFrom(
    //             padding: EdgeInsets.symmetric(horizontal: 23,vertical: 13),
    //           ),
    //       ),],),
    //     ),
    //
    //     SizedBox(height: 16),
    //     Center(child: InkWell(onTap: (){
    //       Navigator.of(context).push(
    //         MaterialPageRoute(builder: (context) => forgotPasswordPage()),
    //       );
    //     },child: Text("Забыли пароль?", style: TextStyle(fontSize: 20, color: Colors.grey)))),
    //   ],
    // );
  }

  // Future<void> ifNotFul() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: true, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Ошибка'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: const <Widget>[
  //               Text('Заполните все поля'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           ElevatedButton(
  //             child: const Text('Хорошо'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
