import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class FireAuth {
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      FirebaseFirestore.instance.collection("UsersData")
          .doc("${FirebaseAuth.instance.currentUser?.uid}")
          .set({
        "name": auth.currentUser?.displayName,
        "email": auth.currentUser?.email,
        "counterOfStory": 0,
        "hints": ["Если бы вы могли достичь чего угодно в своей жизни, что бы это было и почему?",
          "Каковы ваши три самых сильных страха?",
          "Какие три вещи вы можете сделать, чтобы улучшить своё здоровье?",
          "Напишите о трудностях в вашей жизни. Как вы их преодолели?",
          "Напишите письмо человеку, который больше всех вас поддерживает.",
          "Что сделало вас счастливым сегодня?",
          "Куда бы вы поехали, если бы могли поехать куда угодно?",
          "Опишите ваш самый главный провал и то, чему он вас научил.",
          "Какие три урока вы извлекли из состояния гнева или депрессии?",
          "Чтобы вы в себе изменили, если могли бы?",
          "Как выглядит ваша идеальная жизнь?",
          "Каким вы себя видите через 5, 10, 20 лет?",
          "Что бы вы рассказали о себе незнакомцу?",
          "Назовите ваши пять главнейших жизненных принципов.",
          "Что никто не знает о вас? Почему вы храните это в секрете?",
          "Что бы ты мог делать по-другому, зная, что никто тебя не осудит?",
          "Есть ли у тебя что-то, за что ты держишься, что давно пора отпустить?",
          "Что нового вы сегодня узнали?",
          "Сто вещей, которые вам удаются.",
          "Сто вещей, которым вы благодарны.",
          "Чему вас научил сегодняшний день?",
          "Что в жизни друзей или коллег может вызвать у вас легкую зависть?",
          "Чем вы любите заниматься в свободное время?",
          "Что в жизни вы любите более всего и хотели бы, чтобы это происходило с вами как можно чаще?",
          "Чем вы любили заниматься в детстве? Кем хотели стать?",
          "Как давно вы научились чему-то новому?",
          "Кто вас вдохновляет?",
          "Когда вы в последний раз прочитали книгу? О чем она была?",
          "Если бы вам сказали, что через год вас не станет, чем бы вы занимались следующие 12 месяцев?"],
      });
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if  (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Данная почта уже зарегистрирована.')));
      }else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Введите корректную почту.')));
      }
    } catch (e) {
      print(e);
    }
    return user;
  }


  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Данная почта еще не зарегистрирована.')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Неправильный пароль.')));
      }
    }
  }

  static Future<User?> logOut() async{
    await FirebaseAuth.instance.signOut();
  }
  static resetPassword(String email, BuildContext context) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(email: email);
  }

  static Future<User?> reAuthUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Данная почта еще не зарегистрирована.')));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Неправильный пароль.')));
        print('Wrong password provided.');
      }
    }
  }
  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }
}