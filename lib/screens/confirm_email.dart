import 'package:diary_app/models/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class confirmEmail extends StatefulWidget {
  const confirmEmail({Key? key}) : super(key: key);

  @override
  State<confirmEmail> createState() => _confirmEmailState();
}

class _confirmEmailState extends State<confirmEmail> {
  @override
  bool isClicked = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text("Потверждение почты"),
        ),
      ),
      body: isClicked ? sended() : notSended(),
    );
  }

  notSended() {
    return Center(
      child: ElevatedButton(onPressed: () async {
        await FirebaseAuth.instance.currentUser?.sendEmailVerification();
        isClicked = true;
        setState(() {

        });
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text("Ссылка для потверждения почты отправлена на ${FirebaseAuth.instance.currentUser?.email}")));
      }, child: Text("Потвердить почту", style: TextStyle(fontSize: 23),),
        style: ElevatedButton.styleFrom(
        ),),
    );
  }

  sended() {
    return Center(
        child: Text(
            "Ссылка для потверждения почты отправлена на ${FirebaseAuth.instance
                .currentUser?.email}", style: TextStyle(fontSize: 23, color: Colors.yellow.withOpacity(0.5)), textAlign: TextAlign.center,)
    );
  }

}