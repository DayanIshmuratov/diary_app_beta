import 'package:diary_app/api/auth.dart';
import 'package:diary_app/utilities/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isClicked = false;
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Смена пароля"),),
      body: isClicked ? clicked() : forgotPasswordView(),
    );
  }

  forgotPasswordView() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              style: const TextStyle(color: Colors.grey),
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
            SizedBox(height: 8,),
            ElevatedButton(onPressed: () async {
              if (_formKey.currentState!.validate()) {
                FireAuth.resetPassword(emailController.text, context);
                isClicked = true;
                setState(() {});
              }
            },
                child: const Text(
                  "Сбросить пароль", style: TextStyle(fontSize: 20),))
          ],
        ),
      ),
    );
  }

  clicked() {
    return Center(
        child: Text(
          "Ссылка для смены пароля отправлена на ${emailController.text}",
          style: TextStyle(fontSize: 23, color: Colors.yellow.withOpacity(0.5)),
          textAlign: TextAlign.center,)
    );
  }
}