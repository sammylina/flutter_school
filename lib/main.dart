import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:school/page/login.dart';
import 'package:school/page/admin.dart';
import 'package:school/page/login.dart';
import 'package:school/page/encoder.dart';

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
				primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        //'/': (context) => Login(),
        '/admin': (context) => AdminPage(),
        '/encoder': (context) => Encoder(),
      },
      home: Scaffold(
				body: Encoder(),
      ),
    );
  }
}


