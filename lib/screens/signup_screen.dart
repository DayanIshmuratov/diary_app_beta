import 'package:diary_app/screens/main_screen.dart';
import 'package:diary_app/utilities/field_focus_change.dart';
import 'package:diary_app/utilities/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../api/auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isHideFirst = true;
  bool isHideSecond = true;

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusFirstPassword = FocusNode();
  final _focusSecondPassword = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordFirstController = TextEditingController();
  TextEditingController passwordSecondController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Регистрация", style: const TextStyle(fontSize: 24,),),),
      body: Form(
        key: _formKey,
        child:
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  focusNode: _focusName,
                  autofocus: true,
                  onFieldSubmitted: (_){
                    FieldFocusChange(context: context, currentFocus: _focusName, nextFocus: _focusEmail);
                  },
                  style: TextStyle(color: Colors.grey),
                  maxLines: 1,
                  controller: nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    iconColor: Colors.yellow,
                    fillColor: Colors.white30,
                    filled: true,
                    labelText: 'Имя',
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  validator: (value) =>
                      Validators.validateName(name: value as String),
                ),
                SizedBox(height: 16),
                TextFormField(
                  focusNode: _focusEmail,
                  onFieldSubmitted: (_){
                    FieldFocusChange(context: context, currentFocus: _focusEmail, nextFocus: _focusFirstPassword);
                  },
                  style: TextStyle(color: Colors.grey),
                  maxLines: 1,
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.mail, color: Colors.grey,),
                    iconColor: Colors.yellow,
                    fillColor: Colors.white30,
                    filled: true,
                    labelText: 'Почта',
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  validator: (value) =>
                      Validators.validateEmail(email: value as String),
                ),
                SizedBox(height: 16),
                TextFormField(
                  focusNode: _focusFirstPassword,
                  onFieldSubmitted: (_){
                    FieldFocusChange(context: context, currentFocus: _focusFirstPassword, nextFocus: _focusSecondPassword);
                  },
                  maxLines: 1,
                  obscureText: isHideFirst,
                  style: TextStyle(color: Colors.grey),
                  controller: passwordFirstController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(onPressed: () {
                      setState((){
                        isHideFirst = !isHideFirst;
                      });
                    }, icon: Icon(isHideFirst ? Icons.visibility : Icons.visibility_off, color: Colors.grey,)),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey,),
                    iconColor: Colors.yellow,
                    fillColor: Colors.white30,
                    filled: true,
                    labelText: 'Пароль',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (value) =>
                      Validators.validatePassword(password: value as String),
                ),
                SizedBox(height: 16),
                TextFormField(
                    focusNode: _focusSecondPassword,
                    maxLines: 1,
                    obscureText: isHideSecond,
                    style: TextStyle(color: Colors.grey),
                    controller: passwordSecondController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(onPressed: () {
                        setState((){
                          isHideSecond = !isHideSecond;
                        });
                      }, icon: Icon(isHideSecond ? Icons.visibility : Icons.visibility_off, color: Colors.grey,)),
                      prefixIcon: Icon(Icons.lock, color: Colors.grey,),
                      iconColor: Colors.yellow,
                      fillColor: Colors.white30,
                      filled: true,
                      labelText: 'Повторите пароль',
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                    validator: (value) =>
                        Validators.validateSecondPassword(
                            first: passwordFirstController.text,
                            second: value as String)
                ),
                SizedBox(height: 16),
                ElevatedButton(onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    User? user = await FireAuth
                        .registerUsingEmailPassword(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordFirstController.text,
                      context: context,
                    );
                    setState(() {});
                    if (user != null) {
                      Navigator.of(context).pushNamed(
                          '/main_screen', arguments: user);
                    }
                  }
                },

                  child: Text("Зарегистрироваться".toUpperCase(),
                    style: TextStyle(fontSize: 20,),),
                  style: ElevatedButton.styleFrom(
                      // padding: EdgeInsets.only()
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}