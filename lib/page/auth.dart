import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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