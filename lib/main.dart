import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:school/page/login.dart';
import 'package:school/page/admin.dart';
import 'package:school/page/login.dart';
import 'package:school/page/encoder.dart';
import 'package:school/page/parent.dart';
import 'package:school/page/teacher.dart';
import 'package:school/page/register/main_register.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
				primarySwatch: Colors.cyan,
        primaryColor: Colors.cyan,
        //accentColor: Color(0x46c6ce),
      ),
      initialRoute: '/',
      routes: {
        '/register': (context) => Register(),
        '/admin': (context) => AdminPage(),
        '/encoder': (context) => Encoder(),
        '/teacher': (context) => Teacher(),
        '/parent': (context) => Parent(),
      },
      home: Scaffold(
				body: Login(),
      ),
    );
  }
}


