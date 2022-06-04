import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class FireAuth {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<User?> registerUsingEmailPassword({
    required String email,
    required String password,
}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential user_cred = await auth.createUserWithEmailAndPassword(email: email, password: password);
      user = user_cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('weak password');
      }else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email');
      }
    }

    return user;
  }
}

class CustomAuth {
  Random rand = Random();
  final _chars = 'ABCDEFGHIJKLMNOPRSTUVWXYZabcedfghijklmnopqrstuvwxyz!@123456789';
  String generate_password() {
    final password = String.fromCharCodes(Iterable.generate(6, (_) => _chars.codeUnitAt(rand.nextInt(_chars.length))));
    return password;
}
}